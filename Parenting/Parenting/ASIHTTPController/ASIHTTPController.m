//
//  ASIHTTPController.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 13-12-23.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import "ASIHTTPController.h"
#import "SuggestionDataBase.h"


@implementation ASIHTTPController

-(id)init
{
    self=[super init];
    if (self) {
        syncCount = 0;
        beginCount = 0;
        
        //取用户存储的字典
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"LastSyncTime"])
        {
            lastSyncTime = [[NSUserDefaults standardUserDefaults] stringForKey:@"LastSyncTime"];
        }
        else{
            lastSyncTime=@"1970-1-1";
        }
    }
    
    return self;
}

#pragma 开始同步数据
-(void)beginSyncData
{
    if (beginCount + 10 >= syncCount)    //需更新的条数少于10条
    {
        //起始条目beginCount  取的数量:syncCount-count条
        [self syncDataByBeginIndex:beginCount andCount:syncCount-beginCount];
        NSString *newSyncTime = [self getNewSyncTime];
        //save newSyncTime;
        //sync over
    }
    else if (beginCount + 10 < syncCount)    //需更新的条数大于10条
    {
        
        [self syncDataByBeginIndex:beginCount andCount:10];
        beginCount = beginCount+10;
        //定时器
        
        [self beginSyncData];
    }
}

#pragma 同步数据by开始位置&条数
-(void)syncDataByBeginIndex:(int)beginIndex andCount:(int)count
{
    NSString* content = [@"GetSyncData/" stringByAppendingString:lastSyncTime];
    content = [content stringByAppendingString:[NSString stringWithFormat:@"/%d/",beginIndex]];
    content = [content stringByAppendingString:[NSString stringWithFormat:@"%d",count]];
    NSString* strUrl = [ASIHTTPADDRESS stringByAppendingString:content];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        //处理数据
        NSData *data = [request responseData];
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        for(NSDictionary *dic in [json reverseObjectEnumerator])
        {
            [SuggestionDataBase insertSuggestionType:[[dic objectForKey:@"typeId"] intValue] ID:[[dic objectForKey:@"typeSerial"] intValue] Url:[dic objectForKey:@"url"] Author:[dic objectForKey:@"author"] ContentCN:[dic objectForKey:@"content_cn"] ContentEN:[dic objectForKey:@"content_en"]];
        }
    }
    else
    {
        return;
    }
}

-(NSString*)getNewSyncTime
{
    NSString* content = [@"GetNewSyncTime/" stringByAppendingString:lastSyncTime];
    //token
    NSString* strUrl = [ASIHTTPADDRESS stringByAppendingString:content];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        return response;
    }
    else
    {
        return lastSyncTime;
    }
}

#pragma 异步获取更新数量
-(void)getSyncCount
{
    NSString* content = [@"GetSyncCount/" stringByAppendingString:lastSyncTime];
    //Token
    NSString* strUrl = [ASIHTTPADDRESS stringByAppendingString:content];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    //POST方法
	[request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:15000];//设置超时时间5秒
    //异步传输
    [request setCompletionBlock :^{
        // 请求响应结束
        NSString *count = [request responseString];
        syncCount = [count intValue];
        if (syncCount > 0) {
            [self beginSyncData];
        }
    }];
    [request setFailedBlock :^{
        // 请求响应失败，返回错误信息&处理
        syncCount=0;
    }];
	[request startAsynchronous];
}


@end
