//
//  LookingForDeviceViewController.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 13-12-17.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEController.h"

@interface LookingForDeviceViewController : UIViewController<BLEControllerDelegate,UIAlertViewDelegate>
{
    NSString *deviceName;
    BOOL isTimeOut;
    BOOL isFound;
    NSTimer *timer;
    NSMutableArray  *peripherals;
}

@property (nonatomic) BLEController *bleController;

@property (nonatomic) int deviceId;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *buttonRescan;
@end
