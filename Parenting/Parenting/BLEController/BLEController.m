//
//  BLEController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-13.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import "BLEController.h"
@interface BLEController()<UartDelegate>
{
    UartLib *uartLib;
    
    CBPeripheral	*connectPeripheral;
}


@end

@implementation BLEController

+(id)btcontroller
{
    
    __strong static BLEController *_sharedObject = nil;
    
    _sharedObject =  [[self alloc] init]; // or some other init metho
    
    
    return _sharedObject;
}

-(id)init
{
    self=[super init];
    if (self) {
        connectPeripheral = nil;
        uartLib = [[UartLib alloc] init];
        [uartLib setUartDelegate:self];
        isNext = 0;
        isSaved = NO;
    }
    
    return self;
}
/****************************************************************************/
/*                       UartDelegate Methods                        */
/****************************************************************************/
- (void) didBluetoothPoweredOff{
    [self.bleControllerDelegate BLEPowerOff:YES];
    NSLog(@"power off");
}

- (void) didScanedPeripherals:(NSMutableArray  *)foundPeripherals
{
    NSLog(@"didScanedPeripherals(%d)", [foundPeripherals count]);
    
    CBPeripheral	*peripheral;
    
    for (peripheral in foundPeripherals) {
		NSLog(@"--Peripheral:%@", [peripheral name]);
	}
    
    if ([foundPeripherals count] > 0) {
        connectPeripheral = [foundPeripherals objectAtIndex:0];
        if ([connectPeripheral name] == nil) {
            [[NSUserDefaults standardUserDefaults] setObject:@"BT_COM" forKey:@"BTNAME"];
            scanCount++;
            if (scanCount>10) {
                [self.bleControllerDelegate scanResult:NO with:nil];
            }
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:[connectPeripheral name] forKey:@"BTNAME"];
            [self.bleControllerDelegate scanResult:YES with:foundPeripherals];
        }
    }
    else{
        scanCount++;
        if (scanCount>10) {
//            [self stopscan];
            [self.bleControllerDelegate scanResult:NO with:nil];
        }
    }
}

- (void) didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"did Connect Peripheral");
    
    connectPeripheral = peripheral;
    [self.bleControllerDelegate DidConnected:YES];
    [self setSystemTime];
}

- (void) didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"did Disconnect Peripheral");
    
    connectPeripheral = nil;
    [self.bleControllerDelegate DidConnected:NO];
}

- (void) didWriteData:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"didWriteData:%@", [peripheral name]);
}

- (void) didReceiveData:(CBPeripheral *)peripheral recvData:(NSData *)recvData
{
    NSLog(@"uart recv(%d):%@", [recvData length], recvData);
    [self RecvBTData:recvData];
}
#pragma -mark pid deal
- (void) resp_set_sys_time : (NSData*) data
{
    NSLog(@"resp_set_sys_time BTData:%@", data);
    NSString *hexStr=@"";
    
    Byte *hexData = (Byte *)[data bytes];
    
    for (int i=0; i<[data length]; i++) {
        NSString *str = [NSString stringWithFormat:@"%02x", hexData[i]&0xff];
        if (hexStr == nil) {
            hexStr = str;
        }
        else
        {
            hexStr = [hexStr stringByAppendingString:str];
        }
    }
}

-(void) resp_get_history :(NSData*) data
{
    NSLog(@"resp_set_sys_time BTData:%@", data);
    NSString *hexStr=@"";
    
    Byte *hexData = (Byte *)[data bytes];
    for (int i=0; i<[data length]; i++) {
        NSString *str = [NSString stringWithFormat:@"%02x", hexData[i]&0xff];
        if (hexStr == nil) {
            hexStr = str;
        }
        else
        {
            hexStr = [hexStr stringByAppendingString:str];
        }
    }
    
    isSaved = YES;
    //******cwb******
    if (![hexStr  isEqual: @"00000000000000000000"]){
        //进行解析并存入数据库
        
        //是否有按键历史信息
        //        NSString *haveHistroy = [hexStr substringWithRange:NSMakeRange(0,2)];
        //按键id值
        NSString *buttonID = [hexStr substringWithRange:NSMakeRange(2,2)];
        //按键持续时间,单位秒 2字节
        int hDuration = [BLEController hexStringToInt:[hexStr substringWithRange:NSMakeRange(4,4)]];
        
        //开始时间
        int dYear = [BLEController hexStringToInt:[hexStr substringWithRange:NSMakeRange(8,2)]];
        int dMonth = [BLEController hexStringToInt:[hexStr substringWithRange:NSMakeRange(10,2)]];
        int dDay = [BLEController hexStringToInt:[hexStr substringWithRange:NSMakeRange(12,2)]];
        int dHour = [BLEController hexStringToInt:[hexStr substringWithRange:NSMakeRange(14,2)]];
        int dMinite = [BLEController hexStringToInt:[hexStr substringWithRange:NSMakeRange(16,2)]];
        int dSecond = [BLEController hexStringToInt:[hexStr substringWithRange:NSMakeRange(18,2)]];
        
        NSString *str_startTime = [NSString stringWithFormat:@"20%02d-%02d-%02d %02d:%02d:%02d",dYear,dMonth,dDay,dHour,dMinite,dSecond];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSDate *startTime = [formatter dateFromString:str_startTime];
        
        NSLog(@"%@",startTime);
        
        DataBase *db = [[DataBase alloc]init];
        if (startTime == nil){
            //数据格式错误，异常数据处理
            //isSaved = NO;
            isSaved = YES;//测试用
        }
        else if ([buttonID  isEqual: BLUETOOTH_BUTTON_FEED]) {
            //db insertFeed
            isSaved = [db insertfeedStarttime:startTime Month:[currentdate getMonthFromDate:startTime] Week:[currentdate getWeekFromDate:startTime] WeekDay:[currentdate getWeekDayFromDate:startTime] Duration:hDuration Feedway:0 OzorLR:@"" Remark:@""];
        }
        else if ([buttonID  isEqual: BLUETOOTH_BUTTON_DIAPER]) {
            //db insertDiaper
            isSaved = [db insertdiaperStarttime:startTime Month:[currentdate getMonthFromDate:startTime] Week:[currentdate getWeekFromDate:startTime]  WeekDay:[currentdate getWeekDayFromDate:startTime] Status:@"" Remark:@""];
        }
        else if ([buttonID  isEqual: BLUETOOTH_BUTTON_BATH]) {
            //db insertBath
            isSaved = [db insertbathStarttime:startTime Month:[currentdate getMonthFromDate:startTime] Week:[currentdate getWeekFromDate:startTime]   WeekDay:[currentdate getWeekDayFromDate:startTime] Duration:hDuration Remark:@""];
        }
        else if ([buttonID  isEqual: BLUETOOTH_BUTTON_SLEEP]) {
            isSaved = [db insertsleepStarttime:startTime Month:[currentdate getMonthFromDate:startTime] Week:[currentdate getWeekFromDate:startTime] WeekDay:[currentdate getWeekDayFromDate:startTime] Duration:hDuration Remark:@""];
        }
        else if ([buttonID  isEqual: BLUETOOTH_BUTTON_PLAY]) {
            //db insertPlay
            isSaved = [db insertplayStarttime:startTime Month:[currentdate getMonthFromDate:startTime] Week:[currentdate getWeekFromDate:startTime] WeekDay:[currentdate getWeekDayFromDate:startTime] Duration:(hDuration) Remark:@""];
        }
        
        [self getPressKeyHistory:1];
    }
    else
    {
        [self.bleControllerDelegate RecvDataFinish:YES];
    }
    //******endcwb******
}

-(void)resp_get_temphumi:(NSData*)data
{
  //  [self.bleControllerDelegate RecvHumiAndTempDada:data];
}

-(void)resp_get_light:(NSData*)data
{
  //  [self.bleControllerDelegate RecvLightData:data];
}

-(void)resp_get_uv:(NSData*)data
{
  //  [self.bleControllerDelegate RecvUVData:data];
}

-(void)resp_get_microphone:(NSData*)data
{
    //  [self.bleControllerDelegate RecvUVData:data];
}

#pragma mark tools function
-(void)RecvBTData:(NSData*)recvData
{
    Byte *hexData = (Byte *)[recvData bytes];
    int pid = 0;
    int datalength = 0, j=0;
    Byte btData[datalength];
    memset(btData, 0, datalength);
    for(int i=0;i<[recvData length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%02x",hexData[i]&0xff];
        // 提取协议号
        if (i == 2) {
            pid = [BLEController hexStringToInt:newHexStr];
        }
        
        if (i == 3)
        {
            datalength = [BLEController hexStringToInt:newHexStr];
        }
        
        if (i >= 4) {
            btData[j] = [BLEController hexStringToInt:newHexStr];
            j++;
        }
        
    }
    
    NSData *respData =[[NSData alloc] initWithBytes:btData length:datalength];
    //NSLog(@"recv BTData:%@", respData);
    switch (pid) {
        case PID_RESP_SET_SYS_TIME:
            [self resp_set_sys_time:respData];
            break;
        case PID_RESP_GET_HISTORY:
            [self resp_get_history:respData];
            break;
        case PID_RESP_GET_TEMPHUMI:
            [self resp_get_temphumi:respData];
            break;
        case PID_RESP_GET_LIGHT:
            [self resp_get_light:respData];
            break;
        case PID_RESP_GET_UV:
            [self resp_get_uv:respData];
            break;
        case PID_RESP_GET_MICROPHONE:
            [self resp_get_microphone:recvData];
            break;
        default:
            //提取结束
            [self.bleControllerDelegate RecvDataFinish:YES];
            break;
    }
    
}

+ (int) hexStringToInt:(NSString *)hexString
{
    int int_ch = 0;  /// 两位16进制数转化后的10进制数
    // NSLog(@"str length: %d, %@ ", [hexString length], hexString);
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:0]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        int int_ch2 = 0;
        if ([hexString length] > 1)
        {
            unichar hex_char2 = [hexString characterAtIndex:1]; ///两位16进制数中的第二位(低位)
            
            if(hex_char2 >= '0' && hex_char2 <='9')
                int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
            else if(hex_char1 >= 'A' && hex_char1 <='F')
                int_ch2 = hex_char2-55; //// A 的Ascll - 65
            else
                int_ch2 = hex_char2-87; //// a 的Ascll - 97
        }
        
        int_ch = int_ch1+int_ch2;
        // NSLog(@"int_ch=%d",int_ch);
    }
    return int_ch;
}

+ (int) hexStringHighToInt:(NSString *)hexString
{
    int int_ch = 0;  /// 两位16进制数转化后的10进制数
    //NSLog(@"str length: %d, %@ ", [hexString length], hexString);
    for(int i=0;i<[hexString length];i++)
    {
        
        
        unichar hex_char1 = [hexString characterAtIndex:0]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16*16*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16*16*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16*16*16; //// a 的Ascll - 97
        int int_ch2 = 0;
        if ([hexString length] > 1)
        {
            unichar hex_char2 = [hexString characterAtIndex:1]; ///两位16进制数中的第二位(低位)
            
            if(hex_char2 >= '0' && hex_char2 <='9')
                int_ch2 = (hex_char2-48)*16*16; //// 0 的Ascll - 48
            else if(hex_char1 >= 'A' && hex_char1 <='F')
                int_ch2 = (hex_char2-55)*16*16; //// A 的Ascll - 65
            else
                int_ch2 = (hex_char2-87)*16*16; //// a 的Ascll - 97
        }
        
        int_ch = int_ch1+int_ch2;
        
    }
    return int_ch;
}

#pragma 主要指令:同步时间;同步硬件操作历史数据
//同步时间
-(void)setSystemTime
{
    Byte ucaCmdData[12];
    
    NSDate *curdate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit|NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:curdate];
    
    memset(ucaCmdData, 0, 12);
    ucaCmdData[0] = 0xab;
    ucaCmdData[1] = 0xcd;
    ucaCmdData[2] = 0x01; //协议号
    ucaCmdData[3] = 7; //长度
    
    if ([comps year] == 2013)
    {
        ucaCmdData[4] = 0xdd;
        ucaCmdData[5] = 0x07;
    }
    else if ([comps year] == 2014)
    {
        ucaCmdData[4] = 0xde;
        ucaCmdData[5] = 0x07;
    }
    else if ([comps year] == 2014)
    {
        ucaCmdData[4] = 0xde;
        ucaCmdData[5] = 0x07;
    }
    else if ([comps year] == 2015)
    {
        ucaCmdData[4] = 0xdf;
        ucaCmdData[5] = 0x07;
        
    }
    else if ([comps year] == 2016)
    {
        ucaCmdData[4] = 0xe0;
        ucaCmdData[5] = 0x07;
    }
    
    //月
    ucaCmdData[6]  = [comps month];
    //日
    ucaCmdData[7]  = [comps day];
    //小时
    ucaCmdData[8]  = [comps hour];
    //分钟
    ucaCmdData[9]  = [comps minute];
    //秒
    ucaCmdData[10] = [comps second];
    
    ucaCmdData[11] = calculateXor(ucaCmdData, 11);
    
    NSData *cmdData =[[NSData alloc] initWithBytes:ucaCmdData length:12];
    NSLog(@"get setSystemTime:%@", cmdData);
    
    NSLog(@"%@",cmdData);
    [uartLib sendValue:connectPeripheral sendData:cmdData type:CBCharacteristicWriteWithoutResponse];
}
//获取按键历史记录
- (void)getPressKeyHistory:(int)type{
    Byte ucaCmdData[10];
    
    memset(ucaCmdData, 0, 10);
    ucaCmdData[0] = 0xab;
    ucaCmdData[1] = 0xcd;
    ucaCmdData[2] = 0x03;
    ucaCmdData[3] = 1;
    
    if (isNext == 0) {
        ucaCmdData[4] = 0;
        isNext = 1;
    }
    else
    {
        //******cwb******
        //******定义isSaved，如果isSaved=true，则ucaCmdData=2，删除该条数据*******
        //******如果isSaved=false，则ucaCmdData=1，跳过该条数据。*******
        if (isSaved) {
            ucaCmdData[4] = 2;
        }
        else  {
            ucaCmdData[4] = 1;
            isSaved = NO;
        }
        //******endcwb******
    }
    
    ucaCmdData[5] = calculateXor(ucaCmdData, 5);
    NSData *cmdData =[[NSData alloc] initWithBytes:ucaCmdData length:6];
    NSLog(@"get getPressKeyHistory:%@", cmdData);
    
    [uartLib sendValue:connectPeripheral sendData:cmdData type:CBCharacteristicWriteWithoutResponse];
}


#pragma -mark environment data request
//温度请求
- (void)getTemperature
{
    Byte ucaCmdData[10];
    
    memset(ucaCmdData, 0, 10);
    ucaCmdData[0] = 0xab;
    ucaCmdData[1] = 0xcd;
    ucaCmdData[2] = 0x05;
    ucaCmdData[3] = 0;
    ucaCmdData[4] = calculateXor(ucaCmdData, 4);
    
    NSData *cmdData =[[NSData alloc] initWithBytes:ucaCmdData length:5];
    NSLog(@"get temperature:%@", cmdData);
    
    [uartLib sendValue:connectPeripheral sendData:cmdData type:CBCharacteristicWriteWithoutResponse];
}

-(void)getLight
{
    Byte ucaCmdData[10];
    
    memset(ucaCmdData, 0, 10);
    ucaCmdData[0] = 0xab;
    ucaCmdData[1] = 0xcd;
    ucaCmdData[2] = 0x07;
    ucaCmdData[3] = 0;
    ucaCmdData[4] = calculateXor(ucaCmdData, 4);
    
    NSData *cmdData =[[NSData alloc] initWithBytes:ucaCmdData length:5];
    NSLog(@"get light:%@", cmdData);
    
    [uartLib sendValue:connectPeripheral sendData:cmdData type:CBCharacteristicWriteWithoutResponse];
}

-(void)getUV
{
    Byte ucaCmdData[10];
    
    memset(ucaCmdData, 0, 10);
    ucaCmdData[0] = 0xab;
    ucaCmdData[1] = 0xcd;
    ucaCmdData[2] = 0x09;
    ucaCmdData[3] = 0;
    ucaCmdData[4] = calculateXor(ucaCmdData, 4);
    
    NSData *cmdData =[[NSData alloc] initWithBytes:ucaCmdData length:5];
    NSLog(@"get uv:%@", cmdData);
    
    [uartLib sendValue:connectPeripheral sendData:cmdData type:CBCharacteristicWriteWithoutResponse];
}

-(void)getMicrophone:(int)type
{
    Byte ucaCmdData[10];
    
    memset(ucaCmdData, 0, 10);
    ucaCmdData[0] = 0xab;
    ucaCmdData[1] = 0xcd;
    ucaCmdData[2] = 0x0b;
    ucaCmdData[3] = 1;
    ucaCmdData[4] = type;
    ucaCmdData[5] = calculateXor(ucaCmdData, 5);
    
    NSData *cmdData =[[NSData alloc] initWithBytes:ucaCmdData length:6];
    NSLog(@"get Micro:%@", cmdData);
    
    [uartLib sendValue:connectPeripheral sendData:cmdData type:CBCharacteristicWriteWithoutResponse];
}

#pragma -mark public function
#pragma -mark tools  function
Byte calculateXor(Byte *pcData, Byte ucDataLen){
    Byte ucXor = 0;
    Byte i;
    
    for (i=0; i<ucDataLen; i++) {
        ucXor ^= *(pcData+i);
    }
    
    return ucXor;
}

-(void)startscan
{
    [uartLib scanStart];
}

-(void)stopscan
{
    [uartLib scanStop];
}

-(void)bleconnect
{
    NSLog(@"connect Peripheral");
    [uartLib scanStop];
    [uartLib connectPeripheral:connectPeripheral];
}

-(void)bledisconnect;
{
    [uartLib scanStop];
    [uartLib disconnectPeripheral:connectPeripheral];
}

-(void)senddata:(NSData *)sendData
{
    [uartLib sendValue:connectPeripheral sendData:sendData type:CBCharacteristicWriteWithoutResponse];
}
@end
