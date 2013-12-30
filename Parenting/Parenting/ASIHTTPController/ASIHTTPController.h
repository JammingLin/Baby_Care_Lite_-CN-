//
//  ASIHTTPController.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 13-12-23.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"

@interface ASIHTTPController : NSObject
{
    int syncCount;
    int beginCount;
    NSString *lastSyncTime;
}

-(void)getSyncCount;

@end
