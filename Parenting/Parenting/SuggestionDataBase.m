//
//  SuggestionDataBase.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 13-12-23.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import "SuggestionDataBase.h"

@implementation SuggestionDataBase

+(id)suggestionDataBase
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}

+(BOOL)insertSuggestionType:(int)type
                         ID:(int)typeserial
                        Url:(NSString*)url
                     Author:(NSString*)author
                  ContentCN:(NSString*)contentCN
                  ContentEN:(NSString*)contentEN
{
    BOOL isNew = [self isExistisType:type ID:typeserial];
    
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:SDBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    NSString *tableName;
    if (type == SUGGESTION_TYPE_HUMI){
        tableName = @"humi_suggestion";
    }
    else if (type == SUGGESTION_TYPE_TEMP){
        tableName = @"temp_suggestion";
    }
    else if (type == SUGGESTION_TYPE_NOICE){
        tableName = @"noice_suggestion";
    }
    else if (type == SUGGESTION_TYPE_LIGHT){
        tableName = @"light_suggestion";
    }
    else if (type == SUGGESTION_TYPE_UV){
        tableName = @"uv_suggestion";
    }
    else if (type == SUGGESTION_TYPE_PM25){
        tableName = @"pm25_suggestion";
    }
    
    //根据typeserial判断该条数据是否存在
    NSString *strSQL;
    if (isNew) {
        strSQL = [NSString stringWithFormat:@"insert into %@ (id, url, author,content_cn,content_en) values(?,?,?,?,?)",tableName];
        res=[db executeUpdate:strSQL,[NSNumber numberWithInt:typeserial],url,author,contentCN,contentEN];
        if (!res)
        {
            NSLog(@"插入失败");
            return res;
        }
    }
    else{
        strSQL = [NSString stringWithFormat:@"update %@ set url=?, author=?,content_cn=?,content_en=? where id=?",tableName];
        res=[db executeUpdate:strSQL,url,author,contentCN,contentEN,[NSNumber numberWithInt:typeserial]];
        if (!res)
        {
            NSLog(@"更新失败");
            return res;
        }
    }
    
    [db close];
    return YES;
}

#pragma 判断记录是否存在
+(BOOL)isExistisType:(int)type ID:(int)typeserial{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:SDBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    FMResultSet *resultset;
    if (type == SUGGESTION_TYPE_HUMI){
        //根据typeserial判断该条数据是否存在
        resultset=[db executeQuery:@"select * from humi_suggestion where id=?",[NSNumber numberWithInt:typeserial]];
    }
    else if (type == SUGGESTION_TYPE_TEMP){
        resultset=[db executeQuery:@"select * from temp_suggestion where id=?",[NSNumber numberWithInt:typeserial]];
    }
    else if (type == SUGGESTION_TYPE_NOICE){
        resultset=[db executeQuery:@"select * from noice_suggestion where id=?",[NSNumber numberWithInt:typeserial]];
    }
    else if (type == SUGGESTION_TYPE_LIGHT){
        resultset=[db executeQuery:@"select * from light_suggestion where id=?",[NSNumber numberWithInt:typeserial]];
    }
    else if (type == SUGGESTION_TYPE_UV){
        resultset=[db executeQuery:@"select * from uv_suggestion where id=?",[NSNumber numberWithInt:typeserial]];
    }
    else if (type == SUGGESTION_TYPE_PM25){
        resultset=[db executeQuery:@"select * from pm25_suggestion where id=?",[NSNumber numberWithInt:typeserial]];
    }

    if ([resultset next]) {
        [db close];
        return NO;
    }
    else{
        [db close];
        return YES;
    }
    
}


@end
