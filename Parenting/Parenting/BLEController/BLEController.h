//
//  BLEController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-13.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLEControllerDelegate<NSObject>
@optional
-(void)scanResult:(BOOL)result with:(NSMutableArray  *)foundPeripherals;
-(void)BLEPowerOff:(BOOL)isPowerOff;
-(void)DidConnected:(BOOL)isConnected;
-(void)DisConnected:(BOOL)isConnected;
-(void)RecvBTData:(NSData*)recvdata;
-(void)RecvDataFinish:(BOOL)isFinished;
-(void)RecvHumiAndTempDada:(NSData*)data;
-(void)RecvLightData:(NSData*)data;
-(void)RecvUVData:(NSData*)data;
-(void)RecvMicroPhone:(NSData*)data;
@end

@interface BLEController : NSObject{
    int isNext;
    //****cwb****
    BOOL isSaved;
    int scanCount;
}
@property (assign) id<BLEControllerDelegate> bleControllerDelegate;

-(void)startscan;
-(void)stopscan;
-(void)bleconnect;
-(void)bledisconnect;
-(void)senddata:(NSData*)sendData;
-(void)setSystemTime;
-(void)getPressKeyHistory:(int)type;

+ (int)hexStringHighToInt:(NSString *)hexString;
+ (int)hexStringToInt:(NSString *)hexString;

// 环境请求
-(void)getTemperatureAndHumi;
-(void)getLight;
-(void)getUV;
-(void)getMicrophone:(int)type;//0开启,1关闭
@end
