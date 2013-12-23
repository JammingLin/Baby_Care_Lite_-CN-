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
    [self.bleControllerDelegate RecvBTData:recvData];
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
    
    //do someting
    
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
    
    //******cwb******
    if (![hexStr  isEqual: @"00000000000000000000"]){
        //进行解析并存入数据库
        
        //是否有按键历史信息
        //        NSString *haveHistroy = [hexStr substringWithRange:NSMakeRange(0,2)];
        //按键id值
        NSString *buttonID = [hexStr substringWithRange:NSMakeRange(2,2)];
        //按键持续时间,单位秒 2字节
        int hDuration = [self hexStringToInt:[hexStr substringWithRange:NSMakeRange(4,4)]];
        
        //开始时间
        int dYear = [self hexStringToInt:[hexStr substringWithRange:NSMakeRange(8,2)]];
        int dMonth = [self hexStringToInt:[hexStr substringWithRange:NSMakeRange(10,2)]];
        int dDay = [self hexStringToInt:[hexStr substringWithRange:NSMakeRange(12,2)]];
        int dHour = [self hexStringToInt:[hexStr substringWithRange:NSMakeRange(14,2)]];
        int dMinite = [self hexStringToInt:[hexStr substringWithRange:NSMakeRange(16,2)]];
        int dSecond = [self hexStringToInt:[hexStr substringWithRange:NSMakeRange(18,2)]];
        
        NSString *str_startTime = [NSString stringWithFormat:@"20%02d-%02d-%02d %02d:%02d:%02d",dYear,dMonth,dDay,dHour,dMinite,dSecond];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSDate *startTime = [formatter dateFromString:str_startTime];
        
        NSLog(@"%@",startTime);
        
        //五个按钮:喂食,换尿布,洗澡,睡觉,玩耍
#define BLUETOOTH_BUTTON_FEED   @"01"
#define BLUETOOTH_BUTTON_DIAPER @"02"
#define BLUETOOTH_BUTTON_BATH   @"03"
#define BLUETOOTH_BUTTON_SLEEP  @"04"
#define BLUETOOTH_BUTTON_PLAY   @"05"
        
        if (startTime == nil){
            //数据格式错误，异常数据处理
            //isSaved = NO;
            isSaved = YES;//测试用
        }
        else if ([buttonID  isEqual: BLUETOOTH_BUTTON_FEED]) {
            //db insertFeed
            isSaved = YES;
        }
        else if ([buttonID  isEqual: BLUETOOTH_BUTTON_DIAPER]) {
            //db insertDiaper
            isSaved = YES;
        }
        else if ([buttonID  isEqual: BLUETOOTH_BUTTON_BATH]) {
            //db insertBath
            isSaved = YES;
        }
        else if ([buttonID  isEqual: BLUETOOTH_BUTTON_SLEEP]) {
            //            [db insertplayStarttime:startTime Month:[currentdate getMonthFromDate:startTime] Week:[currentdate getWeekFromDate:startTime] WeekDay:[currentdate getWeekDayFromDate:startTime] Duration:(hDuration) Remark:@""];
            isSaved = YES;
        }
        else if ([buttonID  isEqual: BLUETOOTH_BUTTON_PLAY]) {
            //db insertPlay
            isSaved = YES;
        }
        
        [self getPressKeyHistory:1];
    }
    //******endcwb******
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
            pid = [self hexStringToInt:newHexStr];
        }
        
        if (i == 3)
        {
            datalength = [self hexStringToInt:newHexStr];
        }
        
        if (i >= 4) {
            btData[j] = [self hexStringToInt:newHexStr];
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
        default:
            break;
    }
    
}

- (int) hexStringToInt:(NSString *)hexString
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

- (int) hexStringHighToInt:(NSString *)hexString
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
            //          ucaCmdData[4] = 2;
            //测试用
            ucaCmdData[4] = 1;
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



Byte calculateXor(Byte *pcData, Byte ucDataLen){
    Byte ucXor = 0;
    Byte i;
    
    for (i=0; i<ucDataLen; i++) {
        ucXor ^= *(pcData+i);
    }
    
    return ucXor;
}


#pragma -mark public function
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
