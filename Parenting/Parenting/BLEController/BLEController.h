//
//  BLEController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-13.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UartLib.h"

@protocol BLEControllerDelegate<NSObject>
@optional
-(void)scanResult:(BOOL)result with:(NSMutableArray  *)foundPeripherals;
-(void)BLEPowerOff:(BOOL)isPowerOff;
-(void)DidConnected:(BOOL)isConnected;
-(void)RecvBTData:(NSData*)recvdata;
-(void)RecvDataFinish:(BOOL)isFinished;
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
- (void)getPressKeyHistory:(int)type;
@end
