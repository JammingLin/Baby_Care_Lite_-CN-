//
//  HomeViewController.h
//  Parenting
//
//  Created by 家明 on 13-5-17.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BabyinfoViewController.h"
#import "BLEController.h"

@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate,UIActionSheetDelegate,UIAlertViewDelegate,BLEControllerDelegate>
{
    NSTimer *timer;
    IBOutlet UITableView *datatable;
    IBOutlet UITableView *actionTable;
    NSMutableArray *actionArray;
    NSArray *iconarray;
    UIImagePickerController *imagePicker;
    UIImageView *babyImage;
    UIButton *camera;
    UILabel *birth;
    NSMutableData *webData;
    NSArray *dataArray;
    UIView *titleView;
    UILabel *titleText;
    
    BLEController *bleController;
    CBPeripheral	*connectPeripheral;
    BOOL isTimeOut;
    BOOL isFound;
    UIButton *buttonSyncBLE;
    
}
@property(nonatomic,strong)CLLocationManager *lm;

@end
