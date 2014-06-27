//
//  BLEWeatherView.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-1-8.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AdviseData;
@class AdviseLevel;
@interface BLEWeatherView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    BOOL         isgetted;
    UITableView *table;
    NSString    *tempcontent;
    int          templevel;
    //温度建议
    AdviseData  *mAdTemp;
    AdviseLevel *mAlTemp;
    
    //湿度建议
    AdviseData  *mAdHumi;
    AdviseLevel *mAlHumi;
    
    BOOL isFistTime;
    NSTimer *gettimer;
    NSTimeInterval getDataTimeInterval;

}
+(id)weatherview;
@property (nonatomic,strong)  NSMutableArray  *dataarray;
@property (nonatomic, weak )id delete;
@property int chooseType;
-(void)makeview;
-(void)refreshweather;
@end
