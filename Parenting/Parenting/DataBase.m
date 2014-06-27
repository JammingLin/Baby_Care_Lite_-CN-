//
//  DataBase.m
//  Parenting
//
//  Created by user on 13-5-28.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "DataBase.h"
#import "FMDatabase.h"
#import "AdviseData.h"
#import "NotifyItem.h"
#import "LocalNotify.h"

@implementation DataBase
+(id)dataBase
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}

-(BOOL)insertfeedStarttime:(NSDate*)starttime
                 Month:(int)month
                  Week:(int)week
                   WeekDay:(int)weekday
              Duration:(int)duration
               Feedway:(int)feedway
                OzorLR:(NSString *)ozorlr
                Remark:(NSString *)remark
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists feed (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, feedway INTEGER DEFAULT NULL, ozorlr Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];

    if (!res) {
        NSLog(@"表格创建失败");
        return res;
    }
    res=[db executeUpdate:@"insert into feed values(?,?,?,?,?,?,?,?,?)",starttime,[NSNumber numberWithInt:month],[NSNumber numberWithInt:week],[NSNumber numberWithInt:weekday],[NSNumber numberWithInt:duration],[NSNumber numberWithInt:feedway],ozorlr,remark,@"Feed"];
    if (!res) {
        NSLog(@"%@",NSHomeDirectory());
        NSLog(@"插入失败");
        return res;
    }
    [db close];
    
    return res;
    
}

-(BOOL)insertdiaperStarttime:(NSDate*)starttime
                       Month:(int)month
                        Week:(int)week
                        WeekDay:(int)weekday
                      Status:(NSString*)status
                      Remark:(NSString*)remark
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists diaper (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, status Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        return res;
    }
    res=[db executeUpdate:@"insert into diaper values(?,?,?,?,?,?,?)",starttime,[NSNumber numberWithInt:month],[NSNumber numberWithInt:week],[NSNumber numberWithInt:weekday],status,remark,@"Diaper"];
    if (!res) {
        NSLog(@"插入失败");
        return res;
    }
    [db close];
    return res;
}

-(BOOL)insertplayStarttime:(NSDate *)starttime Month:(int)month Week:(int)week WeekDay:(int)weekday Duration:(int)duration Remark:(NSString *)remark
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists play (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    
    if (!res) {
        NSLog(@"表格创建失败");
        return res;
    }
    res=[db executeUpdate:@"insert into play values(?,?,?,?,?,?,?)",starttime,[NSNumber numberWithInt:month],[NSNumber numberWithInt:week],[NSNumber numberWithInt:weekday],[NSNumber numberWithInt:duration],remark,@"Play"];
    if (!res) {
        NSLog(@"插入失败");
        return res;
    }
    [db close];
    return res;
}

-(BOOL)insertsleepStarttime:(NSDate *)starttime Month:(int)month Week:(int)week WeekDay:(int)weekday Duration:(int)duration Remark:(NSString *)remark 
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists sleep (starttime Date DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    
    if (!res) {
        NSLog(@"表格创建失败");
        return res;
    }
    res=[db executeUpdate:@"insert into sleep values(?,?,?,?,?,?,?)",starttime,[NSNumber numberWithInt:month],[NSNumber numberWithInt:week],[NSNumber numberWithInt:weekday],[NSNumber numberWithInt:duration],remark,@"Sleep"];
    if (!res) {
        NSLog(@"插入失败");
        return res;
    }
    [db close];
    return res;
}

-(BOOL)insertbathStarttime:(NSDate *)starttime Month:(int)month Week:(int)week WeekDay:(int)weekday Duration:(int)duration Remark:(NSString *)remark
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists bath (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    
    if (!res) {
        NSLog(@"表格创建失败");
        return res;
    }
    res=[db executeUpdate:@"insert into bath values(?,?,?,?,?,?,?)",starttime,[NSNumber numberWithInt:month],[NSNumber numberWithInt:week],[NSNumber numberWithInt:weekday],[NSNumber numberWithInt:duration],remark,@"Bath"];
    if (!res) {
        NSLog(@"插入失败");
        return res;
    }
    [db close];
    return res;
}

-(BOOL)insertUserAdviseLock
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists user_advise (user_id INTEGER NOT NULL, diaper_lock INTEGER DEFAULT NULL, sleep_lock INTEGER DEFAULT NULL, bath_lock INTEGER DEFAULT NULL, feed_lock INTEGER DEFAULT NULL,play_lock INTEGER DEFAULT NULL, PRIMARY KEY  (user_id))"];
    
    if (!res) {
        NSLog(@"表格创建失败");
        return res;
    }
    
    
    res=[db executeUpdate:@"insert into user_advise(user_id, diaper_lock, sleep_lock, bath_lock, feed_lock, play_lock) values(1,0,0,0,0,0)"];
    if (!res)
    {
        NSLog(@"插入失败");
        return res;
    }
    [db close];
    return res;
}

-(BOOL)updateUserAdvise:(int)advice_type S_Lock:(int)s_lock
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists user_advise (user_id INTEGER DEFAULT NULL, diaper_lock INTEGER DEFAULT NULL, sleep_lock INTEGER DEFAULT NULL, bath_lock INTEGER DEFAULT NULL, feed_lock INTEGER DEFAULT NULL,play_lock INTEGER DEFAULT NULL, PRIMARY KEY  (user_id))"];
    
    if (!res) {
        NSLog(@"表格创建失败");
        return res;
    }
    
    NSString *sqlStr = NULL;
    switch(advice_type)
    {
        case ADVISE_TYPE_DIAPER:
            sqlStr = [NSString stringWithFormat:@"update user_advise set diaper_lock = %d where user_id = 1", s_lock];
            break;
        case ADVISE_TYPE_SLEEP:
            sqlStr = [NSString stringWithFormat:@"update user_advise set sleep_lock = %d where user_id = 1", s_lock];
            break;
        case ADVISE_TYPE_FEED:
            sqlStr = [NSString stringWithFormat:@"update user_advise set feed_lock = %d where user_id = 1", s_lock];
            break;
        case ADVISE_TYPE_PLAY:
            sqlStr = [NSString stringWithFormat:@"update user_advise set play_lock = %d where user_id = 1", s_lock];
            break;
        case ADVISE_TYPE_BATH:
            sqlStr = [NSString stringWithFormat:@"update user_advise set bath_lock = %d where user_id = 1", s_lock];
            break;
        default:
            break;
    }
    
    res=[db executeUpdate:sqlStr, [NSNumber numberWithInt:s_lock]];
    if (!res)
    {
        NSLog(@"更新失败");
        return res;
    }
    [db close];
    return res;
}

+(int)selectFromUserAdvise:(int)advice_type
{
    int s_lock = 0;
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    FMResultSet *set=[db executeQuery:@"select * from user_advise where user_id = 1"];
    while ([set next]) {
        switch (advice_type) {
            case ADVISE_TYPE_BATH:
                s_lock = [[[NSString alloc] initWithData:[set dataForColumn:@"bath_lock"] encoding:NSUTF8StringEncoding] intValue];
                break;
            case ADVISE_TYPE_DIAPER:
                s_lock = [[[NSString alloc] initWithData:[set dataForColumn:@"diaper_lock"] encoding:NSUTF8StringEncoding] intValue];
                break;
            case ADVISE_TYPE_FEED:
                s_lock = [[[NSString alloc] initWithData:[set dataForColumn:@"feed_lock"] encoding:NSUTF8StringEncoding] intValue];
                break;
            case ADVISE_TYPE_SLEEP:
                s_lock = [[[NSString alloc] initWithData:[set dataForColumn:@"sleep_lock"] encoding:NSUTF8StringEncoding] intValue];
                break;
            case ADVISE_TYPE_PLAY:
                s_lock = [[[NSString alloc] initWithData:[set dataForColumn:@"play_lock"] encoding:NSUTF8StringEncoding] intValue];
                break;
            default:
                break;
        }
    }
    [db close];
    NSLog(@"%d", s_lock);
    return s_lock;
}

-(NSArray*)selectAll
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }

    res=[db executeUpdate:@"CREATE TABLE if not exists feed (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, feedway INTEGER DEFAULT NULL, ozorlr Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists diaper (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, status Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists sleep (starttime Date DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bath (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists play (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    
    FMResultSet *set=[db executeQuery:@"select * from(select starttime,type from feed union all select starttime,type from diaper union all select starttime,type from sleep union all select starttime,type from bath union all select starttime,type from play)order by starttime desc"];
    while ([set next]) {
        ActivityItem *item=[[ActivityItem alloc]init];
        item.starttime=[set dateForColumn:@"starttime"];
        item.type=[set stringForColumn:@"type"];
        [array addObject:item];
    }
    if (!res) {
        NSLog(@"插入失败");
        return nil;
    }
    [db close];
    return  array;
}

-(NSString *)selectDurationfromStarttime:(NSDate*)start Type:(NSString *)type
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    NSString *str=@"";
    
    NSLog(@"type%@",type);
    
    if (![type isEqualToString:@"Diaper"]) {
        FMResultSet *resultset=[db executeQuery:@"select * from(select starttime,duration,type from feed union all select starttime,duration,type from sleep union all select starttime,duration,type from bath union all select starttime,duration,type from play)where starttime=? and type=? order by starttime desc",start,type ];            

        if ([resultset next]) {NSLog(@"duration%@",str);
            str= [currentdate getDurationfromdate:start second:[resultset intForColumn:@"duration"]];
        }
       
    }
    else {
        
        FMResultSet *set=[db executeQuery:@"select * from diaper where starttime=? and type=?",start,type];
        
        [set next];
        str= NSLocalizedString([set stringForColumn:@"status"], nil) ;

    }
    
     
    return str;
}

-(NSString*)selectFromfeed
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists feed (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, feedway INTEGER DEFAULT NULL, ozorlr Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select starttime from feed order by starttime desc"];
    while ([set next]) {
        NSDate *date=[set dateForColumn:@"starttime"];
        NSLog(@"feeddate %@",date);
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =NSDayCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSHourCalendarUnit;
        comps=  [calendar components:unitFlags fromDate:date toDate:[currentdate date] options:nil];
        if ([comps day] >0) {
            return [NSString stringWithFormat:NSLocalizedString(@"DayTips", nil),[comps day]];
        }
        else if ([comps hour]>0) {
            return [NSString stringWithFormat:NSLocalizedString(@"HourTips", nil),[comps hour]];
        }
        else if ([comps minute]>0) {
            return [NSString stringWithFormat:NSLocalizedString(@"MinuteTips", nil),[comps minute]];
        }
        else if ([comps second]>0) {
            return [NSString stringWithFormat:NSLocalizedString(@"SecondTips", nil),[comps second]];
        }
        else
        {
            return @"NULL";
        }
    }
    return @"NULL";
}
-(NSString*)selectFrombath
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists feed (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, feedway INTEGER DEFAULT NULL, ozorlr Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select starttime from bath order by starttime desc"];
    while ([set next]) {
        NSDate *date=[set dateForColumn:@"starttime"];
        NSLog(@"bathdate %@",date);
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =NSDayCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSHourCalendarUnit;
        comps=  [calendar components:unitFlags fromDate:date toDate:[currentdate date] options:nil];
        if ([comps day] >0) {
            return [NSString stringWithFormat:NSLocalizedString(@"DayTips", nil),[comps day]];
        }
        else if ([comps hour]>0) {
            return [NSString stringWithFormat:NSLocalizedString(@"HourTips", nil),[comps hour]];
        }
        else if ([comps minute]>0) {
            return [NSString stringWithFormat:NSLocalizedString(@"MinuteTips", nil),[comps minute]];
        }
        else if ([comps second]>0) {
            return [NSString stringWithFormat:NSLocalizedString(@"SecondTips", nil),[comps second]];
        }
        else
        {
            return @"NULL";
        }
    }
    return @"NULL";
}
-(NSString*)selectFromsleep
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists feed (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, feedway INTEGER DEFAULT NULL, ozorlr Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select starttime from sleep order by starttime desc"];
    while ([set next]) {
        NSDate *date=[set dateForColumn:@"starttime"];
        NSLog(@"sleepdate %@",date);
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =NSDayCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSHourCalendarUnit;
        comps=  [calendar components:unitFlags fromDate:date toDate:[currentdate date] options:nil];
        if ([comps day] >0) {
            return [NSString stringWithFormat:NSLocalizedString(@"DayTips", nil),[comps day]];
        }
        else if ([comps hour]>0) {
            return [NSString stringWithFormat:NSLocalizedString(@"HourTips", nil),[comps hour]];
        }
        else if ([comps minute]>0) {
            return [NSString stringWithFormat:NSLocalizedString(@"MinuteTips", nil),[comps minute]];
        }
        else if ([comps second]>0) {
            return [NSString stringWithFormat:NSLocalizedString(@"SecondTips", nil),[comps second]];
        }
        else
        {
            return @"NULL";
        }
    }
    return @"NULL";
}
-(NSString*)selectFromplay
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists feed (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, feedway INTEGER DEFAULT NULL, ozorlr Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select starttime from play order by starttime desc"];
    while ([set next]) {
        NSDate *date=[set dateForColumn:@"starttime"];
        
                NSLog(@"playdate %@",date);
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =NSDayCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSHourCalendarUnit;
        comps=  [calendar components:unitFlags fromDate:date toDate:[currentdate date] options:nil];
        if ([comps day] >0) {
            return [NSString stringWithFormat:NSLocalizedString(@"DayTips", nil),[comps day]];
        }
        else if ([comps hour]>0) {
            return [NSString stringWithFormat:NSLocalizedString(@"HourTips", nil),[comps hour]];
        }
        else if ([comps minute]>0) {
            return [NSString stringWithFormat:NSLocalizedString(@"MinuteTips", nil),[comps minute]];
        }
        else if ([comps second]>0) {
            return [NSString stringWithFormat:NSLocalizedString(@"SecondTips", nil),[comps second]];
        }
        else
        {
            return @"NULL";
        }
    }
    return @"NULL";

}
-(NSString*)selectFromdiaper
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists feed (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, feedway INTEGER DEFAULT NULL, ozorlr Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select starttime from diaper order by starttime desc"];
    while ([set next]) {
        NSDate *date=[set dateForColumn:@"starttime"];
        NSLog(@"diaperdate %@",date);
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =NSDayCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSHourCalendarUnit;
        comps=  [calendar components:unitFlags fromDate:date toDate:[currentdate date] options:nil];
        if ([comps day] >0) {
            return [NSString stringWithFormat:NSLocalizedString(@"DayTips", nil),[comps day]];
        }
        else if ([comps hour]>0) {
            return [NSString stringWithFormat:NSLocalizedString(@"HourTips", nil),[comps hour]];
        }
        else if ([comps minute]>0) {
            return [NSString stringWithFormat:NSLocalizedString(@"MinuteTips", nil),[comps minute]];
        }
        else if ([comps second]>0) {
            return [NSString stringWithFormat:NSLocalizedString(@"SecondTips", nil),[comps second]];
        }
        else
        {
            return @"NULL";
        }
    }
    return @"NULL";

}

-(NSArray*)searchFromfeed:(NSDate*)start
{
    
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    res=[db executeUpdate:@"create table if not exists feed(starttime,month,week,weekday,duration,feedway,ozorlr,remark,type)"];
    if (!res) {
        NSLog(@"表格创建失败");
        return nil;
        
    }
    
    FMResultSet *set=[db executeQuery:@"select * from feed where starttime=?",start];
    
    [set next];
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[set dateForColumn:@"starttime"]];
    [array addObject:[set  objectForColumnName:@"duration"]];
    [array addObject:[set objectForColumnName:@"feedway"]];
    if ([set stringForColumn:@"ozorlr"]) {
        [array addObject:[set stringForColumn:@"ozorlr"]];
    }
    else
    {
        [array addObject:[NSString stringWithFormat:@""]];
    }
    if ([set stringForColumn:@"remark"]) {
        [array addObject:[set stringForColumn:@"remark"]];
    }
    else
    {
        [array addObject:[NSString stringWithFormat:@""]];
    }
    
    return  array;
}
-(NSArray*)searchFromdiaper:(NSDate*)start
{
    
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    FMResultSet *set=[db executeQuery:@"select * from diaper where starttime=?",start];
    [set next];
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[set dateForColumn:@"starttime"]];
    if ([set stringForColumn:@"remark"]) {
        [array addObject:[set stringForColumn:@"remark"]];
    }
    else
    {
        [array addObject:[NSString stringWithFormat:@""]];
    }
    [array addObject:[set stringForColumn:@"status"]];
    return  array;
    
    
}
-(NSArray*)searchFrombath:(NSDate*)start
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    
    FMResultSet *set=[db executeQuery:@"select * from bath where starttime=?",start];
    
    [set next];
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[set dateForColumn:@"starttime"]];
    [array addObject:[set  objectForColumnName:@"duration"]];
    
    if ([set stringForColumn:@"remark"]) {
        [array addObject:[set stringForColumn:@"remark"]];
    }
    else
    {
        [array addObject:[NSString stringWithFormat:@""]];
    }
    return  array;
    
}
-(NSArray*)searchFromplay:(NSDate*)start
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    FMResultSet *set=[db executeQuery:@"select * from play where starttime=?",start];
    [set next];
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[set dateForColumn:@"starttime"]];
    [array addObject:[set  objectForColumnName:@"duration"]];
    
    if ([set stringForColumn:@"remark"]) {
        [array addObject:[set stringForColumn:@"remark"]];
    }
    else
    {
        [array addObject:[NSString stringWithFormat:@""]];
    }
    return  array;
}

-(NSArray*)searchFromsleep:(NSDate*)start
{
    
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    FMResultSet *set=[db executeQuery:@"select * from sleep where starttime=?",start];
    [set next];
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[set dateForColumn:@"starttime"]];
    [array addObject:[set  objectForColumnName:@"duration"]];
    
    if ([set stringForColumn:@"remark"]) {
        [array addObject:[set stringForColumn:@"remark"]];
    }
    else
    {
        [array addObject:[NSString stringWithFormat:@""]];
    }
    return  array;
    [db close];
}

+ (NSArray *)dataFromTable:(int)fileTag andpage:(int)scrollpage andTable:(NSString *)table
{
    //NSLog(@"dataFromTable:%d, page:%d, table:%@", fileTag, scrollpage, table);
    int week    = [currentdate getCurrentWeek];
    int weekday = [currentdate getCurrentWeekDay];
    int month   = [currentdate getCurrentMonth];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *count = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *duration = [[NSMutableArray alloc] initWithCapacity:0];
    BOOL res = YES;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    if (0 == fileTag) {
        //week
        int max = 0;
        if (week-scrollpage != [currentdate getCurrentWeek]) {
            max = 7;
        }else{
            max = weekday;
        }
        for (int i = 1; i <= max; i++) {
//            NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ where week = %i and weekday = %i", table, week - scrollpage, i];
//            NSString *sql1 = [NSString stringWithFormat:@"select sum(duration) from %@ where week = %i and weekday = %i", table, week - scrollpage, i];
            int curweek = 0;
            if (week <= scrollpage) {
                curweek = 52- scrollpage + week;
            }
            else
            {
                if (max == 7) {
                    curweek = week-scrollpage;
                }
                else
                {
                    curweek = week;
                }
            }

            NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ where week = %i and weekday = %i", table, curweek, i];
            NSString *sql1 = [NSString stringWithFormat:@"select sum(duration) from %@ where week = %i and weekday = %i", table, curweek, i];
            if ([table isEqualToString:@"Diaper"]) {
                //sql1 = [NSString stringWithFormat:@"select count(*) from %@ where week = %i and weekday = %i", table, week - scrollpage, i];
                sql1 = [NSString stringWithFormat:@"select count(*) from %@ where week = %i and weekday = %i", table, curweek, i];
            }
            FMResultSet *set  = [db executeQuery:sql];
            FMResultSet *set1 = [db executeQuery:sql1];
            if ([set next]) {
                [count addObject:[set objectForColumnIndex:0]];
            }
            if ([set1 next]) {
                NSString *ss;
                if (![[set1 objectForColumnIndex:0] isKindOfClass:[NSNull class]]) {
                    if ([table isEqualToString:@"Diaper"]) {
                        ss = [NSString stringWithFormat:@"%f", [[set1 objectForColumnIndex:0] floatValue]];
                    }else{
                        ss = [NSString stringWithFormat:@"%f", [[set1 objectForColumnIndex:0] floatValue]/3600];
                    }
                }else{
                    ss = @"0";
                }
                [duration addObject:ss];
            }
        }
    }
    else
    {
        //month
        int curmonth = 0;
        if (month <= scrollpage) {
            curmonth = 12- scrollpage + month;
        }
        else
        {
            curmonth = month;
        }

        int nowDay = [currentdate getday:[currentdate date]];
        if ((month-scrollpage) == [currentdate getCurrentMonth]) {
            for (int i = 0; i <= (nowDay - 1) / 7; i++) {
                NSString *str = @"0";
                [count addObject:str];
                [duration addObject:str];
            }
        }
        else
        {
            count = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil];
            duration = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil];
        }
        NSString *sql;
        if ([table isEqualToString:@"Diaper"]) {
            //sql = [NSString stringWithFormat:@"select starttime from %@ where month = %i", table, month - scrollpage];
            sql = [NSString stringWithFormat:@"select starttime from %@ where month = %i", table, curmonth];
        }else{
            //sql = [NSString stringWithFormat:@"select starttime,duration from %@ where month = %i", table, month - scrollpage];
            sql = [NSString stringWithFormat:@"select starttime,duration from %@ where month = %i", table, curmonth];
        }
        FMResultSet *set = [db executeQuery:sql];
        
        while ([set next]) {
            NSTimeInterval interval = [set doubleForColumn:@"starttime"];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
            int day = [currentdate getday:date];
            NSLog(@"set next day: %d count: %@ duration:%@", day, count, duration);
            int oldeCount = [[count objectAtIndex:(day - 1) / 7] intValue];
            oldeCount++;
            [count removeObjectAtIndex:(day - 1) / 7];
            NSString *str = [NSString stringWithFormat:@"%d", oldeCount];
            [count insertObject:str atIndex:(day - 1) / 7];
            NSString *str1 = [NSString stringWithFormat:@"%i", [set intForColumn:@"duration"]];
            int oldeDurationCount = [[duration objectAtIndex:(day - 1) / 7] intValue];
            [duration removeObjectAtIndex:(day - 1) / 7];
            if ([table isEqualToString:@"Diaper"]) {
                [duration insertObject:[NSString stringWithFormat:@"%i", oldeCount] atIndex:(day - 1) / 7];
            }
            else
            {
                [duration insertObject:[NSString stringWithFormat:@"%f", (oldeDurationCount + [str1 floatValue])/3600] atIndex:(day - 1) / 7];
            }
        }
    }
    
    if (0 == fileTag) {
        long timestamp = [OpenFunction getTimeStampFromDate:[currentdate date]];
        NSDate   *newDate    = [OpenFunction getDateFromTimeStamp:(timestamp-scrollpage*604800)];
        NSString *rangeTitle = [OpenFunction getWeekBeginAndEndWith:newDate];
        //[self setWeekName:fileTag andTAble:table andpage:scrollpage];
        [self setWeekName:table andrange:rangeTitle];
    }
    else
    {
        int curmonth = 0,curyear = 0;
        if (month <= scrollpage) {
            curmonth = 12- scrollpage + month;
            curyear  = [currentdate getCurrentYear]-scrollpage/12-1;
        }
        else
        {
            curmonth = month;
            curyear  = [currentdate getCurrentYear];
        }
        NSLog(@"scrollpage:%d, month:%d, curmonth:%d", scrollpage, month,curmonth);
        [self setTitleName:[NSString stringWithFormat:@"%@(%i.%d)",NSLocalizedString(table,nil), curyear, curmonth]];
    }
    [db close];
    [array addObject:count];
    [array addObject:duration];
    return [NSArray arrayWithArray:array];
}

+ (int)getMonthMax:(int)scrollpage
{
    int max   = 31;
    int month = [currentdate getCurrentMonth];
    BOOL res  = YES;
    NSString *sql;
    NSString *table = @"diaper";
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    if ([table isEqualToString:@"diaper"]) {
        sql = [NSString stringWithFormat:@"select starttime from %@ where month = %i", table, month - scrollpage];
    }
    
    FMResultSet *set = [db executeQuery:sql];
    while ([set next]) {
        NSTimeInterval interval = [set doubleForColumn:@"starttime"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
        max = range.length;
    }
    [db close];

    return max;
}

+ (NSArray *)dataSourceFromDatabase:(int)fileTag andpage:(int)scrollpage andTable:(NSString *)table
{
    int week = [currentdate getCurrentWeek];
    int weekday = [currentdate getCurrentWeekDay];
    int month = [currentdate getCurrentMonth];
    NSMutableArray *arrayCount = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *arr = [NSArray arrayWithObjects:@"play", @"bath", @"feed", @"sleep", @"diaper", nil];
    BOOL res = YES;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    for (NSString *table in arr) {
        NSString *cs = @"sum(duration)";
        if ([table isEqualToString:@"diaper"]) {
            cs = @"count(*)";
        }
        NSMutableArray *muarr = [[NSMutableArray alloc] initWithCapacity:0];
        // 显示周
        if (0 == fileTag) {
            int max = 0;
            if (week - scrollpage != [currentdate getCurrentWeek]) {
                max = 7;
            }else{
                max = weekday;
            }
            
            for (int i = 1; i <= max; i++) {
                NSString *sql = [NSString stringWithFormat:@"select %@ from %@ where week = %i and weekday = %i", cs, table, week - scrollpage, i];
                FMResultSet *set=[db executeQuery:sql];
                if ([set next]) {
                    NSString *str;
                    if ([[set objectForColumnIndex:0] isKindOfClass:[NSNull class]]) {
                        str=@"0";
                        
                    }else{
                        if ([table isEqualToString:@"diaper"]) {
                            str= [NSString stringWithFormat:@"%f", [[set objectForColumnIndex:0] floatValue]];
                        }else{
                            str= [NSString stringWithFormat:@"%f", [[set objectForColumnIndex:0] floatValue]/3600];
                        }
                        
                    }
                    [muarr addObject:str];
                }
            }
        }
        /**
         *	显示月
         */
        else
        {
            int nowDay = [currentdate getday:[currentdate date]];
            NSLog(@"datasourcefromdatebase：nowday:%d", nowDay);
            if (month-scrollpage == [currentdate getCurrentMonth]) {
                for (int i = 0; i <= (nowDay - 1) / 7; i++) {
                    NSString *str = @"0";
                    [muarr addObject:str];
                }
            }else{
                muarr = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil];
            }
            NSLog(@"datasourcefromdatabase:%@,scrollpage:%d", muarr,scrollpage);
            NSString *sql;
            if ([table isEqualToString:@"diaper"]) {
                sql = [NSString stringWithFormat:@"select starttime from %@ where month = %i", table, month - scrollpage];
            }else{
                sql = [NSString stringWithFormat:@"select starttime,duration from %@ where month = %i", table, month - scrollpage];
            }
            FMResultSet *set = [db executeQuery:sql];
            while ([set next]) {
                NSTimeInterval interval = [set doubleForColumn:@"starttime"];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
                int day = [currentdate getday:date];
                NSLog(@"datasourcefromdatabase: date:%@ day: %d",date,day);
                NSString *str = @"";
                int count = [[muarr objectAtIndex:(day - 1) / 7] intValue];
                NSLog(@"datasourcefromdatabase: count: %d", count);
                
                if ([table isEqualToString:@"diaper"]) {
                    [muarr removeObjectAtIndex:(day - 1) / 7];
                    [muarr insertObject:[NSString stringWithFormat:@"%i", count + 1] atIndex:(day - 1) / 7];
                }else{
                    if ([[set stringForColumn:@"duration"] isKindOfClass:[NSNull class]]) {
                        str = @"0";
                    }
                    else{
                        float dt = [[set stringForColumn:@"duration"] floatValue];
                        float olddt = [[muarr objectAtIndex:(day - 1) / 7] floatValue];
                        if (![table isEqualToString:@"diaper"]) {
                            str = [NSString stringWithFormat:@"%f", dt / 3600 + olddt];
                        }
                        [muarr removeObjectAtIndex:(day - 1) / 7];
                        [muarr insertObject:str atIndex:(day - 1) / 7];
                    }
                }
            }
        }
        [arrayCount addObject:muarr];
    }
    if (0 == fileTag) {
        [self setWeekName:fileTag andTAble:@"All" andpage:scrollpage];
    }else{
        int curmonth = 0;
        if (month <= scrollpage ) {
            curmonth = 12 - month + scrollpage;
        }
        [self setTitleName:[NSString stringWithFormat:@"%@(%i.%i)",NSLocalizedString(@"All",nil), [currentdate getCurrentYear], curmonth]];
    }
    [db close];
    NSLog(@"%@", arrayCount);
    return [NSArray arrayWithArray:arrayCount];
}

+ (NSArray *)scrollData:(int)scrollpage andTable:(NSString *)table andFieldTag:(int)fileTag{
    if ([table isEqualToString:@"All"]) {
        return  [self dataSourceFromDatabase:fileTag andpage:scrollpage andTable:table];
    }else{
        return [self dataFromTable:fileTag andpage:scrollpage andTable:table];
    }
}

+ (int)scrollWidth:(int)tag
{
    BOOL res = YES;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    NSArray *arr = [NSArray arrayWithObjects:@"play", @"bath", @"feed", @"sleep", @"diaper", nil];
    NSString *distinct = @"week";
    NSString *sql;
    int ret = 0;
    if (0 == tag) {
        distinct = @"week";
    }else{
        distinct = @"month";
    }
    for (NSString *table in arr) {
        int max = 0;
        int min = 0;
        //sql = [NSString stringWithFormat:@"select max(%@) from(select distinct(%@) from %@)", distinct, distinct, table];
        sql = [NSString stringWithFormat:@"select max(starttime) from %@", table];
        FMResultSet *set=[db executeQuery:sql];
        if ([set next]) {
            max = [set intForColumnIndex:0];
        }
        //sql = [NSString stringWithFormat:@"select min(%@) from(select distinct(%@) from %@)", distinct, distinct, table];
        sql = [NSString stringWithFormat:@"select min(starttime) from %@", table];
        set=[db executeQuery:sql];
        if ([set next]) {
            min = [set intForColumnIndex:0];
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:max];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekCalendarUnit;
        [calendar setFirstWeekday:1];
        comps=[calendar components:unitFlags fromDate:date];
        int maxyear  = [comps year];
        int maxmonth = [comps month];
        int maxweek  = [comps week];
        
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:min];
        NSCalendar *calendar2 = [NSCalendar currentCalendar];
        NSDateComponents *comps2 = [[NSDateComponents alloc] init];
        NSInteger unitFlags2 = NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekCalendarUnit;
        [calendar2 setFirstWeekday:1];
        comps2=[calendar2 components:unitFlags2 fromDate:date2];
        int minyear  = [comps2 year];
        int minmonth = [comps2 month];
        int minweek  = [comps2 week];
        
        int n = maxyear - minyear;
        if (0 == tag) {
            ret = maxweek + 52 * n - minweek + 1;
        }
        else
        {
            ret = maxmonth + 12 * n - minmonth + 1;
        }
        //        if (max - min + 1 > ret) {
//            ret = max - min + 1;
//        }
        NSLog(@"width:ret:%d", ret);
    }
    [db close];
    return ret;
}

+ (int)scrollWidthWithTag:(int)tag andTableName:(NSString*)tablename
{
    BOOL res = YES;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    NSString *sql;
    int ret = 0;
    int max = 0;
    int min = 0;
    sql = [NSString stringWithFormat:@"select max(starttime) from %@", tablename];
    FMResultSet *set=[db executeQuery:sql];
    if ([set next]) {
        max = [set intForColumnIndex:0];
    }
    sql = [NSString stringWithFormat:@"select min(starttime) from %@", tablename];
    set=[db executeQuery:sql];
    if ([set next]) {
        min = [set intForColumnIndex:0];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:max];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekCalendarUnit;
    [calendar setFirstWeekday:1];
    comps=[calendar components:unitFlags fromDate:date];
    int maxyear  = [comps year];
    int maxmonth = [comps month];
    int maxweek  = [comps week];
    
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:min];
    NSCalendar *calendar2 = [NSCalendar currentCalendar];
    NSDateComponents *comps2 = [[NSDateComponents alloc] init];
    NSInteger unitFlags2 = NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekCalendarUnit;
    [calendar2 setFirstWeekday:1];
    comps2=[calendar2 components:unitFlags2 fromDate:date2];
    int minyear  = [comps2 year];
    int minmonth = [comps2 month];
    int minweek  = [comps2 week];
    
    int n = maxyear - minyear;
    if (0 == tag) {
        ret = maxweek + 52 * n - minweek + 1;
    }
    else
    {
        ret = maxmonth + 12 * n - minmonth + 1;
    }
    NSLog(@"table:%@ width:%d",tablename, ret);
    [db close];
    return ret;
}

+ (void)setTitleName:(NSString *)name{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setObject:name forKey:@"NAME"];
    [df synchronize];
}

+ (void)setWeekName:(int)fileTag andTAble:(NSString *)table andpage:(int)scrollPage{
    NSString *name = [NSString stringWithFormat:@"%@(%i %@)",NSLocalizedString(table, nil), [self scrollWidth:fileTag] - scrollPage, NSLocalizedString(@"Week", nil)];
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setObject:name forKey:@"NAME"];
    [df synchronize];
}

+ (void)setWeekName:(NSString *)table andrange:(NSString *)range{
    NSString *name = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(table, nil), range];
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setObject:name forKey:@"NAME"];
    [df synchronize];
}

-(BOOL)updatefeedOzorlr:(NSDate*)starttime
                  Month:(int)month
                   Week:(int)week
                WeekDay:(int)weekday
               Duration:(int)duration
                 OzorLR:(NSString*)ozorlr
                 Remark:(NSString*)remark
           OldStartTime:(NSDate*)oldstarttime
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    if (!res) {
        NSLog(@"表格创建失败");
        return res;
    }
    res=[db executeUpdate:@"update feed set starttime = ?, month=?,week = ?,weekday=?,duration=?, ozorlr=? ,remark=? where starttime=?",starttime,[NSNumber numberWithInt:month],[NSNumber numberWithInt:week],[NSNumber numberWithInt:weekday],[NSNumber numberWithInt:duration],ozorlr,remark,oldstarttime];
    if (!res) {
        NSLog(@"更新失败");
        return res;
    }
    [db close];
    return res;
}

-(BOOL)updatediaperStatus:(NSDate*)newstarttime
                    Month:(int)month
                     Week:(int)week
                  WeekDay:(int)weekday
                   Status:(NSString*)status
                   Remark:(NSString*)remark
             OldStartTime:(NSDate *)oldstarttime
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    if (!res) {
        NSLog(@"表格创建失败");
        return res;
    }
    res=[db executeUpdate:@"update diaper set starttime=?, month=?, week=?, weekday=?, status=? ,remark=? where starttime=?",newstarttime, [NSNumber numberWithInt:month],[NSNumber numberWithInt:week],[NSNumber numberWithInt:weekday], status, remark, oldstarttime];
    if (!res) {
        NSLog(@"更新失败");
        return res;
    }
    [db close];
    return res;
}
-(BOOL)updatesleepRemark:(NSDate *)starttime Month:(int)month Week:(int)week WeekDay:(int)weekday Duration:(int)duration Remark:(NSString *)remark OldStartTime:(NSDate *)oldstarttime
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    if (!res) {
        NSLog(@"表格创建失败");
        return res;
    }
    res=[db executeUpdate:@"update sleep set starttime = ?, month=?,week = ?,weekday=?,duration=?,remark=? where starttime=?",starttime,[NSNumber numberWithInt:month],[NSNumber numberWithInt:week],[NSNumber numberWithInt:weekday],[NSNumber numberWithInt:duration],remark,oldstarttime];
    if (!res) {
        NSLog(@"更新失败");
        return res;
    }
    [db close];
    return res;
    
    
}
-(BOOL)updateplayRemark:(NSDate *)starttime Month:(int)month Week:(int)week WeekDay:(int)weekday Duration:(int)duration Remark:(NSString *)remark OldStartTime:(NSDate *)oldstarttime
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    if (!res) {
        NSLog(@"表格创建失败");
        return res;
    }
    res=[db executeUpdate:@"update play set starttime = ?, month=?,week = ?,weekday=?,duration=?,remark=? where starttime=?",starttime,[NSNumber numberWithInt:month],[NSNumber numberWithInt:week],[NSNumber numberWithInt:weekday],[NSNumber numberWithInt:duration],remark,oldstarttime];
    if (!res) {
        NSLog(@"更新失败");
        return res;
    }
    [db close];
    return res;
}

-(BOOL)updatebathRemark:(NSDate *)starttime Month:(int)month Week:(int)week WeekDay:(int)weekday Duration:(int)duration Remark:(NSString *)remark OldStartTime:(NSDate *)oldstarttime
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    if (!res) {
        NSLog(@"表格创建失败");
        return res;
    }
    res=[db executeUpdate:@"update bath set starttime = ?, month=?,week = ?,weekday=?,duration=?,remark=? where starttime=?",starttime,[NSNumber numberWithInt:month],[NSNumber numberWithInt:week],[NSNumber numberWithInt:weekday],[NSNumber numberWithInt:duration],remark,oldstarttime];
    if (!res) {
        NSLog(@"更新失败");
        return res;
    }
    [db close];
    return res;
}

+(NSArray*)selectbabyinfo:(int)age
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    
    NSLog(@"age:%d",age);
    
    int gender=0;
    
    NSLog(@"gender %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"gender"]);
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"gender"]) {
        NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
        if ([str isEqualToString:@"Female"])
        {
            gender=0;
        }
        else
        {
            gender=1;
        }
    }
    
    
    NSLog(@"gender  %d",gender);
    
    FMResultSet *resultset=[db executeQuery:@"select * from height where age=? and gender=?",[NSNumber numberWithInt:age],[NSNumber numberWithInt:gender]];
    
    if ([resultset next]) {
        NSString *str=[NSString stringWithFormat:@"%@%.1f~%.1f,%@%.1f",NSLocalizedString(@"Height:", nil),[resultset doubleForColumn:@"min"],[resultset doubleForColumn:@"max"],NSLocalizedString(@"Average:", nil),[resultset doubleForColumn:@"avg"]];
        
        [array addObject:str];
    }
    
    resultset=[db executeQuery:@"select * from weight where age=? and gender=?",[NSNumber numberWithInt:age],[NSNumber numberWithInt:gender]];
    if ([resultset next]) {
        NSString *str=[NSString stringWithFormat:@"%@%.1f~%.1f,%@%.1f",NSLocalizedString(@"Weight:", nil),[resultset doubleForColumn:@"min"],[resultset doubleForColumn:@"max"],NSLocalizedString(@"Average:", nil),[resultset doubleForColumn:@"avg"]];

        [array addObject:str];
    }
    
    resultset=[db executeQuery:@"select * from hc where age=? and gender=?",[NSNumber numberWithInt:age],[NSNumber numberWithInt:gender]];
    if ([resultset next]) {
        NSString *str=[NSString stringWithFormat:@"%@%.1f~%.1f,%@%.1f",NSLocalizedString(@"HC:", nil),[resultset doubleForColumn:@"min"],[resultset doubleForColumn:@"max"],NSLocalizedString(@"Average:", nil),[resultset doubleForColumn:@"avg"]];
        
        [array addObject:str];
    }
    NSLog(@"%@",array);

    [db close];
    return array;
}

+(NSArray*)selectsuggestiondiaper:(int)s_lock
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    NSLog(@"s_lock%d",s_lock);
    
    FMResultSet *resultset=[db executeQuery:@"select * from suggestion_diaper where s_lock > ? order by s_lock asc",[NSNumber numberWithInt:s_lock]];
    int i = 0;
    while([resultset next])
    {
        NSLog(@"NO.%d", i+1);
        //NSString *str=[NSString stringWithFormat:@"%@%@,%@%@,%@%@",NSLocalizedString(@"Content:", nil),[resultset stringForColumn:@"content"],NSLocalizedString(@"From:", nil),[resultset stringForColumn:@"from"],NSLocalizedString(@"Author:", nil),[resultset stringForColumn:@"author"]];
        
        AdviseData *ad = [[AdviseData alloc]init];
        ad.mAuthor  = [resultset stringForColumn:@"author"];
        ad.mContent = [resultset stringForColumn:@"content"];
        ad.mFromUrl = [resultset stringForColumn:@"from"];
        ad.mType    = ADVISE_TYPE_BATH;
        //NSLog(@"%@",str);
        [array addObject:ad];
        i++;
    }

    
    NSLog(@"%@",array);
    [db close];
    return array;
}

+(NSArray*)selectsuggestionbath:(int)s_lock
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    NSLog(@"s_lock%d",s_lock);
    
    FMResultSet *resultset=[db executeQuery:@"select * from suggestion_bath where s_lock >= ? order by s_lock asc",[NSNumber numberWithInt:s_lock]];
    int i = 0;
    while([resultset next])
    {
        NSLog(@"NO.%d", i+1);
        //NSString *str=[NSString stringWithFormat:@"%@%@,%@%@,%@%@",NSLocalizedString(@"Content:", nil),[resultset stringForColumn:@"content"],NSLocalizedString(@"From:", nil),[resultset stringForColumn:@"from"],NSLocalizedString(@"Author:", nil),[resultset stringForColumn:@"author"]];
        AdviseData *ad = [[AdviseData alloc]init];
        ad.mAuthor  = [resultset stringForColumn:@"author"];
        ad.mContent = [resultset stringForColumn:@"content"];
        ad.mFromUrl = [resultset stringForColumn:@"from"];
        ad.mType    = ADVISE_TYPE_BATH;
        //NSLog(@"%@",str);
        [array addObject:ad];
        i++;
    }

    [db close];
    return array;
}

+(NSArray*)selectsuggestionfeed:(int)s_lock
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    NSLog(@"s_lock%d",s_lock);
    
    FMResultSet *resultset=[db executeQuery:@"select * from suggestion_feed where s_lock >= ? order by s_lock asc",[NSNumber numberWithInt:s_lock]];
    int i = 0;
    while([resultset next])
    {
        NSLog(@"NO.%d", i+1);
        //NSString *str=[NSString stringWithFormat:@"%@%@,%@%@,%@%@",NSLocalizedString(@"Content:", nil),[resultset stringForColumn:@"content"],NSLocalizedString(@"From:", nil),[resultset stringForColumn:@"from"],NSLocalizedString(@"Author:", nil),[resultset stringForColumn:@"author"]];
        
        AdviseData *ad = [[AdviseData alloc]init];
        ad.mAuthor  = [resultset stringForColumn:@"author"];
        ad.mContent = [resultset stringForColumn:@"content"];
        ad.mFromUrl = [resultset stringForColumn:@"from"];
        ad.mType    = ADVISE_TYPE_BATH;
        //NSLog(@"%@",str);
        [array addObject:ad];
        i++;
    }
    
    NSLog(@"%@",array);
    [db close];
    return array;
}

+(NSArray*)selectsuggestionplay:(int)s_lock
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    NSLog(@"s_lock%d",s_lock);
    
    FMResultSet *resultset=[db executeQuery:@"select * from suggestion_play where s_lock >= ? order by s_lock asc",[NSNumber numberWithInt:s_lock]];
    int i = 0;
    while([resultset next])
    {
        NSLog(@"NO.%d", i+1);
        //NSString *str=[NSString stringWithFormat:@"%@%@,%@%@,%@%@",NSLocalizedString(@"Content:", nil),[resultset stringForColumn:@"content"],NSLocalizedString(@"From:", nil),[resultset stringForColumn:@"from"],NSLocalizedString(@"Author:", nil),[resultset stringForColumn:@"author"]];
        AdviseData *ad = [[AdviseData alloc]init];
        ad.mAuthor  = [resultset stringForColumn:@"author"];
        ad.mContent = [resultset stringForColumn:@"content"];
        ad.mFromUrl = [resultset stringForColumn:@"from"];
        ad.mType    = ADVISE_TYPE_BATH;
        //NSLog(@"%@",str);
        [array addObject:ad];
        i++;
    }
    
    NSLog(@"%@",array);
    [db close];
    return array;
}

+(NSArray*)selectsuggestionsleep:(int)s_lock
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    NSLog(@"s_lock%d",s_lock);
    
    FMResultSet *resultset=[db executeQuery:@"select * from suggestion_sleep where s_lock >= ? order by s_lock asc",[NSNumber numberWithInt:s_lock]];
    int i = 0;
    while([resultset next])
    {
        NSLog(@"NO.%d", i+1);
        //NSString *str=[NSString stringWithFormat:@"%@%@,%@%@,%@%@",NSLocalizedString(@"Content:", nil),[resultset stringForColumn:@"content"],NSLocalizedString(@"From:", nil),[resultset stringForColumn:@"from"],NSLocalizedString(@"Author:", nil),[resultset stringForColumn:@"author"]];
        
        AdviseData *ad = [[AdviseData alloc]init];
        ad.mAuthor  = [resultset stringForColumn:@"author"];
        ad.mContent = [resultset stringForColumn:@"content"];
        ad.mFromUrl = [resultset stringForColumn:@"from"];
        ad.mType    = ADVISE_TYPE_BATH;
        //NSLog(@"%@",str);
        [array addObject:ad];
        i++;
    }
    
    
    NSLog(@"%@",array);
    [db close];
    return array;
}

-(NSArray*)selectAllforsummary
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists feed (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, feedway INTEGER DEFAULT NULL, ozorlr Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists diaper (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, status Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists sleep (starttime Date DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bath (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists play (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select * from(select starttime,type from feed union all select starttime,type from diaper union all select starttime,type from sleep union all select starttime,type from bath union all select starttime,type from play)order by starttime desc"];
    while ([set next]) {
        SummaryItem *item=[[SummaryItem alloc]init];
        item.starttime=[set dateForColumn:@"starttime"];
        item.type=[set stringForColumn:@"type"];
        item.duration=[self selectDurationfromStarttime:item.starttime Type:item.type];
        
        
        [array addObject:item];
    }
    
    [db close];
    return  array;
}
-(NSArray*)selectfeedforsummary
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists feed (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, feedway INTEGER DEFAULT NULL, ozorlr Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists diaper (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, status Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists sleep (starttime Date DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bath (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists play (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select * from feed order by starttime desc"];
    while ([set next]) {
        SummaryItem *item=[[SummaryItem alloc]init];
        item.starttime=[set dateForColumn:@"starttime"];
        item.feed_type=[NSString stringWithFormat:@"%d",[set intForColumn:@"feedway"]];
        item.type    = [set stringForColumn:@"type"];
        item.amount  = [set stringForColumn:@"ozorlr"];
        item.duration=[self selectDurationfromStarttime:item.starttime Type:item.type];
        
        
        [array addObject:item];
    }
    
    [db close];
    return  array;
}
-(NSArray*)selectdiaperforsummary
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists feed (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, feedway INTEGER DEFAULT NULL, ozorlr Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists diaper (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, status Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists sleep (starttime Date DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bath (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists play (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select * from diaper order by starttime desc"];
    while ([set next]) {
        SummaryItem *item=[[SummaryItem alloc]init];
        item.starttime=[set dateForColumn:@"starttime"];
        item.type=[set stringForColumn:@"type"];
        item.duration=[self selectDurationfromStarttime:item.starttime Type:item.type];
        
        
        [array addObject:item];
    }
    
    [db close];
    return  array;
}

-(NSArray*)selectbathforsummary
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists feed (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, feedway INTEGER DEFAULT NULL, ozorlr Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists diaper (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, status Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists sleep (starttime Date DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bath (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists play (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select * from bath order by starttime desc"];
    while ([set next]) {
        SummaryItem *item=[[SummaryItem alloc]init];
        item.starttime=[set dateForColumn:@"starttime"];
        item.type=[set stringForColumn:@"type"];
        item.duration=[self selectDurationfromStarttime:item.starttime Type:item.type];
        
        
        [array addObject:item];
    }
    
    [db close];
    return  array;
}

-(NSArray*)selectsleepforsummary
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists feed (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, feedway INTEGER DEFAULT NULL, ozorlr Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists diaper (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, status Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists sleep (starttime Date DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bath (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists play (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select * from  sleep order by starttime desc"];
    while ([set next]) {
        SummaryItem *item=[[SummaryItem alloc]init];
        item.starttime=[set dateForColumn:@"starttime"];
        item.type=[set stringForColumn:@"type"];
        item.duration=[self selectDurationfromStarttime:item.starttime Type:item.type];
        
        
        [array addObject:item];
    }
    
    [db close];
    return  array;
}


-(NSArray*)selectplayforsummary
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists feed (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, feedway INTEGER DEFAULT NULL, ozorlr Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists diaper (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, status Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists sleep (starttime Date DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bath (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists play (starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select * from  play order by starttime desc"];
    while ([set next]) {
        SummaryItem *item=[[SummaryItem alloc]init];
        item.starttime=[set dateForColumn:@"starttime"];
        item.type=[set stringForColumn:@"type"];
        item.duration=[self selectDurationfromStarttime:item.starttime Type:item.type];
        
        
        [array addObject:item];
    }
    
    [db close];
    return  array;
}


-(BOOL)deleteWithStarttime:(NSDate*)starttime
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    if (!res) {
        NSLog(@"表格创建失败");
        return res;
    }

    res=[db executeUpdate:@"delete from feed where starttime=?",starttime];
    res=[db executeUpdate:@"delete from bath where starttime=?",starttime];
    res=[db executeUpdate:@"delete from diaper where starttime=?",starttime];
    res=[db executeUpdate:@"delete from sleep where starttime=?",starttime];
    res=[db executeUpdate:@"delete from play where starttime=?",starttime];
    [db close];
    return res;


}

+(BOOL)insertNotifyMessage:(NSString *)msg
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists notify_message (msgid INTEGER PRIMARY KEY AUTOINCREMENT, message Varchar DEFAULT NULL, notify_time Timestamp DEFAULT NULL, status INTEGER NOT NULL)"];
    
    if (!res) {
        NSLog(@"表格创建失败");
        return res;
    }
    
    
    res=[db executeUpdate:@"insert into notify_message (message, notify_time, status) values(?,?,0)",msg,[currentdate date]];
    if (!res)
    {
        NSLog(@"插入失败");
        return res;
    }
    [db close];
    return res;
}

+(BOOL)updateNotifyMessageById:(int)msgid
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    if (!res) {
        NSLog(@"表格创建失败");
        return res;
    }
    res=[db executeUpdate:@"update notify_message set status = 1 where msgid=?",[NSNumber numberWithInt:msgid]];
    if (!res) {
        NSLog(@"更新失败");
        return res;
    }
    [db close];
    return res;
}

+(BOOL)updateNotifyMessageAll
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    if (!res) {
        NSLog(@"表格创建失败");
        return res;
    }
    res=[db executeUpdate:@"update notify_message set status = 1 where status=0 "];
    if (!res) {
        NSLog(@"更新失败");
        return res;
    }
    [db close];
    return res;
}

+(NSArray*)selectNotifyMessage:(int)flagid;
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists notify_message (msgid INTEGER PRIMARY KEY AUTOINCREMENT, message Varchar DEFAULT NULL, notify_time Timestamp DEFAULT NULL, status INTEGER NOT NULL)"];
  
    if (!res) {
        NSLog(@"表格创建失败");
        return nil;
        
    }
    
    if (flagid == 0)
    {
        FMResultSet *set=[db executeQuery:@"select * from  notify_message order by notify_time desc"];
        while ([set next])
        {
            NotifyItem *item = [[NotifyItem alloc]init];
            item.notifyid = [set intForColumn:@"msgid"];
            item.content  = [set stringForColumn:@"message"];
            item.status   = [set intForColumn:@"status"];
            item.notify_time = [set dateForColumn:@"notify_time"];
            [array addObject:item];
        }

    }
    else
    {
        FMResultSet *set=[db executeQuery:@"select * from  notify_message where msgid=? order by notify_time desc", [NSNumber numberWithInt:flagid]];
        while ([set next])
        {
            NotifyItem *item = [[NotifyItem alloc]init];
            item.notifyid = [set intForColumn:@"msgid"];
            item.content  = [set stringForColumn:@"message"];
            item.status   = [set intForColumn:@"status"];
            item.notify_time = [set dateForColumn:@"notify_time"];
            [array addObject:item];
        }

    }
    
    [db close];
    return  array;

}

+(BOOL)deleteNotifyMessage:(NSDate*)date
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    res=[db executeUpdate:@"delete from notify_message where notify_time < ?",date];
    [db close];
    return res;

}

+(BOOL)deleteNotifyMessageById:(int)msgid
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    res=[db executeUpdate:@"delete from notify_message where msgid = ?", [NSNumber numberWithInt:msgid]];
    [db close];
    return res;
}

+(BOOL)insertNotifyTime:(NSDate *)createtime andNotifyTime:(NSString *)notifytime andRedundant:(NSString *)redundant andTitle:(NSString *)title
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    res=[db executeUpdate:@"CREATE TABLE if not exists notify_time (createtime Timestamp PRIMARY KEY NOT NULL, notifytime Varchar DEFAULT NULL, redundant Varchar DEFAULT NULL,title Varchar DEFAULT NULL,status INTEGER NOT NULL)"];
    
    if (!res) {
        NSLog(@"表格创建失败");
        return res;
    }
    
    NSLog(@"%@ %@ %@ %@", createtime, notifytime, redundant, title);
    res=[db executeUpdate:@"insert into notify_time(createtime, notifytime, redundant,title,status) values(?,?,?,?,?)",createtime,notifytime,redundant,title,[NSNumber numberWithInt:1]];
    if (!res)
    {
        NSLog(@"插入失败");
        return res;
    }
    [db close];
    
    return res;

}

+(BOOL)updateNotifyTime:(NSDate*)createtime andNotifyTime:(NSString*)notifytime andRedundant:(NSString*) redundant andTitle:(NSString*)title
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    res=[db executeUpdate:@"update notify_time set notifytime = ?,redundant = ?,title = ? where createtime = ?",notifytime,redundant,title,createtime];

    [db close];
    return res;

}

+(BOOL)updateNotifyTimeStatus:(NSDate*)createtime andStatus:(int)status
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    res=[db executeUpdate:@"update notify_time set status = ? where createtime = ?",[NSNumber numberWithInt:status],createtime];
    
    [db close];
    return res;
    
}

+(BOOL)deleteNotifyTime:(NSDate*) createtime
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    res=[db executeUpdate:@"delete from notify_time where createtime = ?", createtime];
    [db close];
    return res;
}

/**
 *	查询notifytime
 *
 *	@param	createtime	如果为空查询所有记录
 *
 *	@return	返回记录组
 */
+(NSArray*)selectNotifyTime:(NSDate*)createtime
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
     res=[db executeUpdate:@"CREATE TABLE if not exists notify_time (createtime Timestamp PRIMARY KEY NOT NULL, notifytime Varchar DEFAULT NULL, redundant Varchar DEFAULT NULL,title Varchar DEFAULT NULL,status INTEGER NOT NULL)"];
    
    if (!res) {
        NSLog(@"表格创建失败");
        return nil;
        
    }
    
    if (createtime == nil)
    {
        FMResultSet *set=[db executeQuery:@"select * from  notify_time order by createtime desc"];
        while ([set next])
        {
            LocalNotify *item = [[LocalNotify alloc]init];
            item.createtime = [set dateForColumn:@"createtime"];
            item.title  = [set stringForColumn:@"title"];
            item.time   = [set stringForColumn:@"notifytime"];
            item.redundant = [set stringForColumn:@"redundant"];
            item.status    = [set intForColumn:@"status"];
            [array addObject:item];
        }
        
    }
    else
    {
        FMResultSet *set=[db executeQuery:@"select * from  notify_message where createtime=? ", createtime];
        while ([set next])
        {
            LocalNotify *item = [[LocalNotify alloc]init];
            item.createtime = [set dateForColumn:@"createtime"];
            item.title  = [set stringForColumn:@"title"];
            item.time   = [set stringForColumn:@"notifytime"];
            item.redundant = [set stringForColumn:@"redundant"];
            item.status    = [set intForColumn:@"status"];
            [array addObject:item];
        }
    }
    
    return array;
}

@end
