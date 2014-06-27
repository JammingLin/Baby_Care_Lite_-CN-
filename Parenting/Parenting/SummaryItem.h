//
//  SummaryItem.h
//  Amoy Baby Care
//
//  Created by user on 13-6-14.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SummaryItem : NSObject
@property(nonatomic,strong)NSDate *starttime;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *duration;
@property(nonatomic,strong)NSString *amount;
@property(nonatomic,strong)NSString *feed_type;
@end
