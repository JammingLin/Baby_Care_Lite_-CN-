//
//  MyDevicesTableCell.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 13-12-24.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDevicesTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewRight;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;


@end
