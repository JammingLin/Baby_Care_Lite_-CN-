//
//  ActivityViewController.m
//  Parenting
//
//  Created by user on 13-5-21.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "feedViewController.h"

@interface feedViewController ()

@end

@implementation feedViewController
@synthesize activity,feedWay, summary,weather,breast,obj;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)init
{
    self=[super init];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ( IOS7_OR_LATER )
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        //self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+(id)shareViewController
{
    
    
    static dispatch_once_t pred = 0;
    __strong static feedViewController* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"喂食"];
    
    if (self.weather) {
        if (self.weather.isHidden == YES) {
            pmintro.hidden = YES;
        }
        else
        {
            pmintro.hidden = NO;
        }
        self.weather.chooseType = QCM_TYPE_FEED;
        [self.weather refreshweather];
    }
    
    if (startButton != nil) {
        startButton.enabled = YES;
    }
    
    if (startButtonleft != nil) {
        startButtonleft.enabled = YES;
    }
    
    if (startButtonright != nil) {
        startButtonright.enabled = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop:) name:@"stop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancel:) name:@"cancel" object:nil];
    
    NSUserDefaults *db = [NSUserDefaults standardUserDefaults];
    NSString *str = [db objectForKey:@"MARK"];
    if (![str isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    str = @"0";
    [db setObject:str forKey:@"MARK"];
    [db synchronize];
    
    UIButton *br=(UIButton*)[self.view viewWithTag:101];
    UIButton *bo=(UIButton*)[self.view viewWithTag:102];
    self.obj=@"self";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"breast"]) {
        
        [self feedWay:br];
    }
    else
    {
        [self feedWay:bo];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"timerOn"]&&[[[NSUserDefaults standardUserDefaults] objectForKey:@"ctl"] isEqualToString:@"feed"]) {
        addRecordBtn.enabled = NO;
        labletip.text = NSLocalizedString(@"Counting", nil);
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"breast"]) {
            NSString *s=[[NSUserDefaults standardUserDefaults] objectForKey:@"breast"];
            if ([s isEqualToString:@"left"]) {
                startButtonleft.selected=YES;
            }
            else
            {
                startButtonright.selected=YES;
            }
        }
        else
        {
            startButton.selected=YES;
        }
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"timerOnBefore"]) {
            
            timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerGo) userInfo:nil repeats:YES];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timerOnBefore"];
        }
        
    }
    else
    {
        labletip.text = NSLocalizedString(@"Wait", nil);
    }
}

-(void)stop
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timerOn"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ctl"];
    NSLog(@"%@",timer);
    [timer invalidate];
    timer = nil;
    timeLable.text=@"00:00:00";
    startButton.selected=NO;
    startButton.enabled = YES;
    startButtonright.enabled = YES;
    startButtonleft.enabled = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"喂食"];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"addfeednow"]){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timerOn"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ctl"];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"addfeednow"];
    }
    [saveView removeFromSuperview];
}

-(void)makeNav
{
    //self.navigationItem.title=NSLocalizedString(@"Feed", nil);
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 100, 20)];
    titleView.backgroundColor=[UIColor clearColor];
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
    titleText.textColor = [UIColor whiteColor];
    [titleText setTextAlignment:NSTextAlignmentCenter];
    [titleText setText:NSLocalizedString(@"Feed", nil)];
    [titleView addSubview:titleText];
    
    self.navigationItem.titleView = titleView;
    
    UIButton *backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(9, 0, 34, 28)];
    title.backgroundColor = [UIColor clearColor];
    [title setTextAlignment:NSTextAlignmentCenter];
    title.textColor = [UIColor whiteColor];
    title.text = NSLocalizedString(@"navback", nil);
    title.font = [UIFont systemFontOfSize:14];
    [backbutton addSubview:title];
    
    
    [backbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    backbutton.frame=CGRectMake(0, 0, 44, 28);
    
    
    UIBarButtonItem *backbar=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=backbar;
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"btn1.png"] forState:UIControlStateNormal];
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 83, 28)];
    title1.backgroundColor = [UIColor clearColor];
    [title1 setTextAlignment:NSTextAlignmentCenter];
    title1.textColor = [UIColor whiteColor];
    title1.text = NSLocalizedString(@"navsummary", nil);
    title1.font = [UIFont systemFontOfSize:14];
    [rightButton addSubview:title1];
    
    
    [rightButton addTarget:self action:@selector(pushSummaryView:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame=CGRectMake(0, 0, 83, 28);
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    self.hidesBottomBarWhenPushed=YES;
}

- (void)pushSummaryView:(id)sender{
    [summary MenuSelectIndex:2];
    self.tabBarController.selectedIndex = 1;
}

-(void)makeAdvise
{
    NSDictionary *dict1=[[NSDictionary alloc]initWithObjectsAndKeys:@"Everything is ok",@"title",@"Give your baby a bath and take him for a walk every day at about the same time. It'll get him used to the idea of daily routine. In fact, he'll probably take comfort in it. With a little luck, other schedules will fall into place more easily, too.",@"content", nil];
    NSDictionary *dict2=[[NSDictionary alloc]initWithObjectsAndKeys:@"Everything is ok",@"title",@"When your baby is very young, feed him whenever you notice hunger signals — even when they seem completely random.",@"content", nil];
    NSDictionary *dict3=[[NSDictionary alloc]initWithObjectsAndKeys:@"Everything is ok",@"title",@"It is very normal that Lots of babies seem to prefer the nighttime hours for activity, and the daytime hours for slumber.Be patient. Most babies adjust to the family timetable in a month or so. ",@"content", nil];
    
    AdviseScrollview *ad=[[AdviseScrollview alloc]initWithArray:[NSArray arrayWithObjects:dict1,dict2,dict3, nil]];
    
    [self.view addSubview:ad];
    
    self.weather = [WeatherView weatherview];
    [self.weather makeview];
    self.weather.chooseType = QCM_TYPE_FEED;
    weather.frame=CGRectMake(0, 0+G_YADDONVERSION, 320, 200);
    [self.view addSubview:weather];
    NSLog(@"weather %@",self.weather);
    
//    self.bleweather = [BLEWeatherView weatherview];
//    self.bleweather.chooseType = QCM_TYPE_FEED;
//    [self.bleweather makeview];
//    self.bleweather.frame=CGRectMake(0, 0+G_YADDONVERSION, 320, 200);
//    [self.view addSubview:self.bleweather];
//    [self.bleweather setHidden:YES];
//    NSLog(@"bleweather %@",self.bleweather);
    
}

-(void)makeView
{
//        UIButton *environment=[UIButton buttonWithType:UIButtonTypeCustom];
//        [environment setTitle:NSLocalizedString(@"气象站", nil) forState:UIControlStateNormal];
//        [environment setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 10, 0)];
//        [environment setBackgroundImage:[UIImage imageNamed:@"label_left.png"] forState:UIControlStateNormal];
//        [environment setBackgroundImage:[UIImage imageNamed:@"label_left_focus.png"] forState:UIControlStateDisabled];
//        environment.frame=CGRectMake(0, 190+G_YADDONVERSION, 160, 47);
//        [self.view addSubview:environment];
//        environment.tag=501;
//        [environment addTarget:self action:@selector(environmentOradvise:) forControlEvents:UIControlEventTouchUpInside];
//        [environment setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
//        [environment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//
//        UIButton *advise=[UIButton buttonWithType:UIButtonTypeCustom];
//        [advise setTitle:NSLocalizedString(@"监测宝", nil)  forState:UIControlStateNormal];
//        [advise setBackgroundImage:[UIImage imageNamed:@"label_right.png"] forState:UIControlStateNormal];
//        [advise setBackgroundImage:[UIImage imageNamed:@"label_right_focus.png"] forState:UIControlStateDisabled];
//        advise.frame=CGRectMake(160, 190+G_YADDONVERSION, 160, 47);
//        [advise setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 10, 0)];
//        [self.view addSubview:advise];
//        advise.tag=502;
//        [advise addTarget:self action:@selector(environmentOradvise:) forControlEvents:UIControlEventTouchUpInside];
//        [self environmentOradvise:advise];
//        [advise setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
//        [advise setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    if (CUSTOMER_COUNTRY==1) {
        pmintro = [[UILabel alloc]initWithFrame:CGRectMake(208-198, 187-5-5, 100, 20)];
        [pmintro setBackgroundColor:[UIColor clearColor]];
        [pmintro setText:@"数据来源PM25.in"];
        [pmintro setFont:[UIFont fontWithName:@"Arial" size:10]];
        [pmintro setTextColor:[UIColor whiteColor]];
        [self.view addSubview:pmintro];
    }
    
    addRecordBtn = [[UIButton alloc]initWithFrame:CGRectMake(130, 220+20, 50, 28)];
    [addRecordBtn setBackgroundColor:[UIColor clearColor]];
    [addRecordBtn setBackgroundImage:[UIImage imageNamed:@"btn2.png"] forState:UIControlStateNormal];
    [addRecordBtn setAlpha:1];
    [addRecordBtn setTitle:NSLocalizedString(@"Add", nil) forState:UIControlStateNormal];
    [addRecordBtn addTarget:self action:@selector(addrecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addRecordBtn];
    
    UIButton *Breast=[UIButton buttonWithType:UIButtonTypeCustom];
    Breast.frame=CGRectMake(10, 220+G_YADDONVERSION+20, 56, 28);
    UIButton *Bottle=[UIButton buttonWithType:UIButtonTypeCustom];
    Bottle.frame=CGRectMake(66, 220+G_YADDONVERSION+20, 56, 28);
    [Breast setBackgroundImage:[UIImage imageNamed:@"feedway_left.png"] forState:UIControlStateNormal];
    [Breast setBackgroundImage:[UIImage imageNamed:@"feedway_left_focus.png"] forState:UIControlStateDisabled];
    Breast.tag=101;
    [Breast setTitle:NSLocalizedString(@"Breast",nil) forState:UIControlStateNormal];
    Breast.highlighted=NO;
    [Breast addTarget:self action:@selector(feedWay:) forControlEvents:UIControlEventTouchUpInside];
    [Breast setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [Breast setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [Bottle setBackgroundImage:[UIImage imageNamed:@"feedway_right.png"] forState:UIControlStateNormal];
    [Bottle setBackgroundImage:[UIImage imageNamed:@"feedway_right_focus.png"] forState:UIControlStateDisabled];
    
    [Bottle setTitle:NSLocalizedString(@"Bottle",nil) forState:UIControlStateNormal];
    Bottle.tag=102;
    Bottle.highlighted=NO;
    [Bottle addTarget:self action:@selector(feedWay:) forControlEvents:UIControlEventTouchUpInside];
    [Bottle setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [Bottle setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self.view addSubview:Breast];
    [self.view addSubview:Bottle];
    
    UIImageView *feedwayimage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 280+G_YADDONVERSION, 70, 88)];
    feedwayimage.contentMode=UIViewContentModeScaleAspectFit;
    feedwayimage.image=[UIImage imageNamed:@"feed_bottle_time.png"];
    [self.view addSubview:feedwayimage];
    feedwayimage.tag=103;
    
    breastleft=[[UIImageView alloc]initWithFrame:CGRectMake(20, 280+G_YADDONVERSION, 49, 49)];
    breastleft.image=[UIImage imageNamed:@"breast_l.png"];
    breastleft.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:breastleft];
    
    breastright=[[UIImageView alloc]initWithFrame:CGRectMake(90, 280+G_YADDONVERSION, 49, 49)];
    breastright.image=[UIImage imageNamed:@"breast_r.png"];
    breastright.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:breastright];
    //    UIImageView *breastright;
    //
    
    startButton=[UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame=CGRectMake(90,300+G_YADDONVERSION, 63, 63);
    [startButton setBackgroundImage:[UIImage imageNamed:@"btn_start.png"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"btn_stop.png"] forState:UIControlStateSelected];
    [self.view addSubview:startButton];
    [startButton addTarget:self action:@selector(startOrPause:) forControlEvents:UIControlEventTouchUpInside];
    
    
    startButtonleft=[UIButton buttonWithType:UIButtonTypeCustom];
    startButtonleft.frame=CGRectMake(20,340+G_YADDONVERSION, 49, 49);
    [startButtonleft setBackgroundImage:[UIImage imageNamed:@"btn_start_breast"] forState:UIControlStateNormal];
    [startButtonleft setBackgroundImage:[UIImage imageNamed:@"btn_stop_breast.png"] forState:UIControlStateSelected];
    [self.view addSubview:startButtonleft];
    [startButtonleft addTarget:self action:@selector(startOrPause:) forControlEvents:UIControlEventTouchUpInside];
    
    
    startButtonright=[UIButton buttonWithType:UIButtonTypeCustom];
    startButtonright.frame=CGRectMake(90,340+G_YADDONVERSION, 49, 49);
    [startButtonright setBackgroundImage:[UIImage imageNamed:@"btn_start_breast"] forState:UIControlStateNormal];
    [startButtonright setBackgroundImage:[UIImage imageNamed:@"btn_stop_breast.png"] forState:UIControlStateSelected];
    [self.view addSubview:startButtonright];
    [startButtonright addTarget:self action:@selector(startOrPause:) forControlEvents:UIControlEventTouchUpInside];
    
    
    timeLable=[[UILabel alloc]initWithFrame:CGRectMake(170, 312+G_YADDONVERSION, 150, 40)];
    timeLable.font=[UIFont systemFontOfSize:32];
    timeLable.text=@"00:00:00";
    timeLable.textColor=[UIColor grayColor];
    timeLable.backgroundColor=[UIColor clearColor];
    [self.view addSubview:timeLable];
    
    
    
    UIImageView *timeicon=[[UIImageView alloc]initWithFrame:CGRectMake(160-G_XREDUCEONVERSION, 260+G_YADDONVERSION+20, 25, 25)];
    timeicon.contentMode=UIViewContentModeScaleAspectFit;
    timeicon.image=[UIImage imageNamed:@"icon_timing.png"];
    [self.view addSubview:timeicon];
    
    labletip=[[UILabel alloc]initWithFrame:CGRectMake(185-G_XREDUCEONVERSION, 260+G_YADDONVERSION-5+20, 140, 40)];
    labletip.text = NSLocalizedString(@"Wait", nil);
    labletip.font = [UIFont fontWithName:@"Arial" size:15];
    labletip.numberOfLines=0;
    [labletip setTextAlignment:NSTextAlignmentLeft];
    //labletip.textAlignment=UITextAlignmentLeft;
    labletip.lineBreakMode=NSLineBreakByWordWrapping;
    labletip.textColor=[UIColor grayColor];
    labletip.backgroundColor=[UIColor clearColor];
    [self.view addSubview:labletip];
    
    if ([UIScreen mainScreen].bounds.size.height==568) {
        CGRect fr;
        
        startButton.frame=CGRectMake(90,340+G_YADDONVERSION, 63, 63);
        startButtonleft.frame=CGRectMake(20,380+G_YADDONVERSION, 49, 49);
        startButtonright.frame=CGRectMake(90,380+G_YADDONVERSION, 49, 49);
        fr=feedwayimage.frame;
        feedwayimage.frame=CGRectMake(fr.origin.x, fr.origin.y+40, fr.size.width, fr.size.height);
        
        fr=breastleft.frame;
        breastleft.frame=CGRectMake(fr.origin.x, fr.origin.y+30, fr.size.width, fr.size.height);
        fr=breastright.frame;
        breastright.frame=CGRectMake(fr.origin.x, fr.origin.y+30, fr.size.width, fr.size.height);
        fr=timeLable.frame;
        
        timeLable.frame=CGRectMake(fr.origin.x, fr.origin.y+40+G_YADDONVERSION, fr.size.width, fr.size.height);
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeNav];
    //NSLog(@"timer:%@",timer);
    
    [self makeAdvise];
    [self makeView];
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1]];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)feedWay:(UIButton *)sender
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"timerOn"]&&[[[NSUserDefaults standardUserDefaults] objectForKey:@"ctl"] isEqualToString:@"feed"]&&![self.obj isEqualToString:@"self"]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TimerTipsTile", nil) message:NSLocalizedString(@"TimerMessage", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil, nil];
        
        [alert show];
        
        return;
    }
    
    sender.enabled=NO;
    UIButton *another=nil;
    UIImageView *feedway=(UIImageView*)[self.view viewWithTag:103];
    if (sender.tag==101) {
        another=(UIButton*)[self.view viewWithTag:102];
        self.feedWay=@"breast";
        feedway.hidden=YES;
        breastright.hidden=NO;
        breastleft.hidden=NO;
        startButton.hidden=YES;
        startButtonleft.hidden=NO;
        startButtonright.hidden=NO;
    }
    else
    {
        another=(UIButton*)[self.view viewWithTag:101];
        self.feedWay=@"bottle";
        feedway.hidden=NO;
        breastright.hidden=YES;
        breastleft.hidden=YES;
        startButton.hidden=NO;
        startButtonleft.hidden=YES;
        startButtonright.hidden=YES;
        
    }
    another.enabled=YES;
    self.obj=@"user";
    
}


-(void)startOrPause:(UIButton*)sender
{
    if (sender==startButton)
    {
        self.breast=nil;
        if (!sender.selected)
        {
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"timerOn"]) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TimerTipsTile", nil) message:NSLocalizedString(@"TimerMessage", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            labletip.text = NSLocalizedString(@"Counting", nil);           startButton.selected=YES;
            self.breast=@"";
            
            [[NSUserDefaults standardUserDefaults] setObject:[currentdate date] forKey:@"timerOn"];
            [[NSUserDefaults standardUserDefaults] setObject:@"feed" forKey:@"ctl"];
            timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerGo) userInfo:nil repeats:YES];
        }
        else{
            
            [self makeSave];
            
        }
        
        
    }
    else if(sender==startButtonleft)
    {
        self.breast=@"left";
        if (!sender.selected)
        {
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"timerOn"]) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TimerTipsTile", nil) message:NSLocalizedString(@"TimerMessage", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil, nil];
                
                [alert show];
                
                return;
            }
            labletip.text = NSLocalizedString(@"Counting", nil);
            
            sender.selected=YES;
            [[NSUserDefaults standardUserDefaults] setObject:[currentdate date] forKey:@"timerOn"];
            [[NSUserDefaults standardUserDefaults] setObject:@"feed" forKey:@"ctl"];
            [[NSUserDefaults standardUserDefaults] setObject:@"left" forKey:@"breast"];
            timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerGo) userInfo:nil repeats:YES];
        }
        else{
            [self makeSave];
            
        }
        
    }
    else
    {
        self.breast=@"right";
        if (!sender.selected)
        {
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"timerOn"]) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TimerTipsTile", nil) message:NSLocalizedString(@"TimerMessage", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil, nil];
                
                [alert show];
                
                return;
            }
            labletip.text = NSLocalizedString(@"Counting", nil);
            
            sender.selected=YES;
            [[NSUserDefaults standardUserDefaults] setObject:[currentdate date] forKey:@"timerOn"];
            [[NSUserDefaults standardUserDefaults] setObject:@"feed" forKey:@"ctl"];
            [[NSUserDefaults standardUserDefaults] setObject:@"right" forKey:@"breast"];
            timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerGo) userInfo:nil repeats:YES];
        }
        else
        {
            [self makeSave];
        }
    }
    addRecordBtn.enabled = NO;
}



-(void)timerGo
{
    
    timeLable.text=[currentdate durationFormat];
    NSLog(@"feed timerGo");
    NSArray *arr=[timeLable.text componentsSeparatedByString:@":"];
    if ([timeLable.text isEqualToString:@"00:00:00"]) {
        [self stop];
    }
    else
    {
        if ([[arr objectAtIndex:0]intValue]==4) {
            
            [self makeSave];
            [saveView Save];
        }
    }
}
-(void)makeSave
{
    if (saveView==nil) {
        //saveView=[[save_feedview alloc]initWithFrame:self.view.frame FeedWay:self.feedWay Breasttype:self.breast];
        saveView = [[save_feedview alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-SAVEVIEW_YADDONVERSION, self.view.frame.size.width, self.view.frame.size.height) FeedWay:self.feedWay Breasttype:self.breast];
    }
    saveView.feedway=self.feedWay;
    saveView.breast=self.breast;
    [saveView loaddata];
    
    startButton.enabled = NO;
    startButtonright.enabled = NO;
    startButtonleft.enabled = NO;

    [self.view addSubview:saveView];
    
}
-(void)stop:(NSNotification*)noti
{
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timerOn"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ctl"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"addfeednow"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"breast"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"breast"];
    }
    startButton.enabled = YES;
    startButtonright.enabled = YES;
    startButtonleft.enabled = YES;
    addRecordBtn.enabled = YES;
    
    [timer invalidate];
    timer = nil;
    timeLable.text=@"00:00:00";
    startButton.selected=NO;
    startButtonleft.selected=NO;
    startButtonright.selected=NO;
    [saveView removeFromSuperview];
    labletip.text=@"The end time,a total of...";
    NSNumber *dur=noti.object;
    labletip.text=[NSString stringWithFormat:NSLocalizedString(@"Over", nil),[dur floatValue]/3600];
    
    
}

-(void)cancel:(NSNotification*)noti
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"addfeednow"])
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timerOn"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ctl"];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"addfeednow"];
    }
    startButton.enabled = YES;
    startButtonright.enabled = YES;
    startButtonleft.enabled = YES;

}

-(void)environmentOradvise:(UIButton *)sender
{
    sender.enabled=NO;
    UIButton *another;
    
    if (sender.tag==501) {
        another=(UIButton*)[self.view viewWithTag:502];
        weather.hidden=NO;
        pmintro.hidden = NO;
        another.enabled=YES;
    }
    else
    {
        another=(UIButton*)[self.view viewWithTag:501];
        weather.hidden=YES;
        pmintro.hidden = YES;
        another.enabled=YES;
    }
    
}

-(IBAction)addrecord:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"addfeednow"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[currentdate date] forKey:@"timerOn"];
    [[NSUserDefaults standardUserDefaults] setObject:@"feed" forKey:@"ctl"];
    
    [self makeSave];
}

@end
