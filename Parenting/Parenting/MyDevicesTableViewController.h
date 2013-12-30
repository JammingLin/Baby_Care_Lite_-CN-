//
//  MyDevicesTableViewController.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 13-12-16.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDevicesTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *arrMyDevices;
    NSArray *arrAdd;
    NSMutableArray *arrData;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
