//
//  diaperViewController.m
//  Parenting
//
//  Created by user on 13-5-23.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "diaperViewController.h"

@interface diaperViewController ()

@end

@implementation diaperViewController
@synthesize summary,weather,status;

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"换尿布"];

  //  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"weather"];
    if (self.weather) {
        self.weather.chooseType = QCM_TYPE_DIAPER;
        [self.weather refreshweather];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop) name:@"stop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancel) name:@"cancel" object:nil];
    
    NSUserDefaults *db = [NSUserDefaults standardUserDefaults];

    [db setObject:@"0" forKey:@"MARK"];
    [db synchronize];
    
    if (startButton != nil) {
        startButton.enabled = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"换尿布"];
    
    [saveView removeFromSuperview];
}

+(id)shareViewController
{

    static dispatch_once_t pred = 0;
    __strong static diaperViewController* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;}

-(void)makeNav
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 100, 20)];
    titleView.backgroundColor=[UIColor clearColor];
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
    titleText.textColor = [UIColor whiteColor];
    [titleText setTextAlignment:NSTextAlignmentCenter];
    [titleText setText:NSLocalizedString(@"Diaper", nil)];
    [titleView addSubview:titleText];
    
    self.navigationItem.titleView = titleView;

    //self.navigationItem.title=NSLocalizedString(@"Diaper", nil);
    UIButton *backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(9, 0, 34, 28)];
    title.backgroundColor = [UIColor clearColor];
    [title setTextAlignment:NSTextAlignmentCenter];
    //title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.text =NSLocalizedString(@"navback", nil);
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
}

- (void)pushSummaryView:(id)sender{
    [summary MenuSelectIndex:4];
    self.tabBarController.selectedIndex = 1;
}



-(void)makeAdvise
{
    NSDictionary *dict1=[[NSDictionary alloc]initWithObjectsAndKeys:@"Everything is ok",@"title",@"Give your baby a bath and take him for a walk every day at about the same time. It'll get him used to the idea of daily routine. In fact, he'll probably take comfort in it. With a little luck, other schedules will fall into place more easily, too.",@"content", nil];
    NSDictionary *dict2=[[NSDictionary alloc]initWithObjectsAndKeys:@"Everything is ok",@"title",@"When your baby is very young, feed him whenever you notice hunger signals — even when they seem completely random.",@"content", nil];
    NSDictionary *dict3=[[NSDictionary alloc]initWithObjectsAndKeys:@"Everything is ok",@"title",@"It is very normal that Lots of babies seem to prefer the nighttime hours for activity, and the daytime hours for slumber.Be patient. Most babies adjust to the family timetable in a month or so. ",@"content", nil];
    
    AdviseScrollview *ad=[[AdviseScrollview alloc]initWithArray:[NSArray arrayWithObjects:dict1,dict2,dict3, nil]];
    
    
    [self.view addSubview:ad];

    
    self.weather=[WeatherView weatherview];
    [self.weather makeview];
    self.weather.chooseType = QCM_TYPE_DIAPER;
    weather.frame=CGRectMake(0, 0+G_YADDONVERSION, 320, 200);
    [self.view addSubview:weather];
    NSLog(@"weather %@",weather);
}

-(void)makeView
{
       

//    UIButton *environment=[UIButton buttonWithType:UIButtonTypeCustom];
//    [environment setTitle:NSLocalizedString(@"btnenvironment", nil) forState:UIControlStateNormal];
//    [environment setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 10, 0)];
//    [environment setBackgroundImage:[UIImage imageNamed:@"label_left.png"] forState:UIControlStateNormal];
//    [environment setBackgroundImage:[UIImage imageNamed:@"label_left_focus.png"] forState:UIControlStateDisabled];
//    environment.frame=CGRectMake(0, 190+G_YADDONVERSION, 160, 47);
//    [self.view addSubview:environment];
//    environment.tag=501;
//    [environment addTarget:self action:@selector(environmentOradvise:) forControlEvents:UIControlEventTouchUpInside];
//    [environment setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
//    [environment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    
    
//    UIButton *advise=[UIButton buttonWithType:UIButtonTypeCustom];
//    [advise setTitle:NSLocalizedString(@"btnadvise", nil)  forState:UIControlStateNormal];
//    [advise setBackgroundImage:[UIImage imageNamed:@"label_right.png"] forState:UIControlStateNormal];
//    [advise setBackgroundImage:[UIImage imageNamed:@"label_right_focus.png"] forState:UIControlStateDisabled];
//    advise.frame=CGRectMake(160, 190+G_YADDONVERSION, 160, 47);
//    [advise setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 10, 0)];
//    [self.view addSubview:advise];
//    advise.tag=502;
//    [advise addTarget:self action:@selector(environmentOradvise:) forControlEvents:UIControlEventTouchUpInside];
//    [self environmentOradvise:advise];
//    [advise setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
//    [advise setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    if (CUSTOMER_COUNTRY==1) {
        UILabel *pmintro = [[UILabel alloc]initWithFrame:CGRectMake(208, 187, 100, 20)];
        [pmintro setBackgroundColor:[UIColor clearColor]];
        [pmintro setText:@"数据来源PM25.in"];
        [pmintro setFont:[UIFont fontWithName:@"Arial" size:12]];
        [pmintro setTextColor:[UIColor whiteColor]];
        [self.view addSubview:pmintro];
    }

    startButton=[UIButton buttonWithType:UIButtonTypeCustom];
    startButton.bounds=CGRectMake(0, 0, 83, 28);
    startButton.center=CGPointMake(160, 370+G_YADDONVERSION);
    [startButton setTitle:NSLocalizedString(@"Submit",nil) forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"btn1.png"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"btn1_focus.png"] forState:UIControlStateSelected];
    [self.view addSubview:startButton];
    [startButton addTarget:self action:@selector(startOrPause:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *dry=[UIButton buttonWithType:UIButtonTypeCustom];
    dry.frame=CGRectMake(5, 220, 189/2.0, 189/2.0);
    [dry setBackgroundImage:[UIImage imageNamed:@"icon_both"] forState:UIControlStateNormal];
    [dry setBackgroundImage:[UIImage imageNamed:@"icon_both_choose"] forState:UIControlStateDisabled];
    [self.view addSubview:dry];
    dry.tag=201;
    [dry addTarget:self action:@selector(Activityselected:) forControlEvents:UIControlEventTouchUpInside];
    [self Activityselected:dry];
    
    UIButton *wet=[UIButton buttonWithType:UIButtonTypeCustom];
    wet.frame=CGRectMake(5+189/2.0+(320-10-189/2.0*3)/2.0, 220, 189/2.0, 189/2.0);
    [wet setBackgroundImage:[UIImage imageNamed:@"icon_wet"] forState:UIControlStateNormal];
    [wet setBackgroundImage:[UIImage imageNamed:@"icon_wet_choose"] forState:UIControlStateDisabled];
    [self.view addSubview:wet];
    wet.tag=202;
    [wet addTarget:self action:@selector(Activityselected:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *dirty=[UIButton buttonWithType:UIButtonTypeCustom];
    dirty.frame=CGRectMake(320-189/2.0-5, 220, 189/2.0, 189/2.0);
    [dirty setBackgroundImage:[UIImage imageNamed:@"icon_dirty"] forState:UIControlStateNormal];
    [dirty setBackgroundImage:[UIImage imageNamed:@"icon_dirty_choose"] forState:UIControlStateDisabled];
    [self.view addSubview:dirty];
    dirty.tag=203;
    [dirty addTarget:self action:@selector(Activityselected:) forControlEvents:UIControlEventTouchUpInside];

    
//    UILabel *labdry=[[UILabel alloc]init];
//    labdry.center=CGPointMake(dry.center.x, 330+G_YADDONVERSION);
//    labdry.bounds=CGRectMake(0, 0, 63, 30);
//    //labdry.text=NSLocalizedString(@"Dry",nil);
//    labdry.textAlignment=NSTextAlignmentCenter;
//    labdry.backgroundColor=[UIColor clearColor];
//    [self.view addSubview:labdry];
//    
//    UILabel *labwet=[[UILabel alloc]init];
//    labwet.center=CGPointMake(wet.center.x, 330+G_YADDONVERSION);
//    labwet.bounds=CGRectMake(0, 0, 63, 30);
//    labwet.text=NSLocalizedString(@"Wet",nil);
//    labwet.textAlignment=NSTextAlignmentCenter;
//    labwet.backgroundColor=[UIColor clearColor];
//    [self.view addSubview:labwet];
//    
//    UILabel *labdirty=[[UILabel alloc]init];
//    labdirty.center=CGPointMake(dirty.center.x, 330+G_YADDONVERSION);
//    labdirty.bounds=CGRectMake(0, 0, 63, 30);
//    labdirty.text=NSLocalizedString(@"Dirty",nil);
//    labdirty.textAlignment=NSTextAlignmentCenter;
//    labdirty.backgroundColor=[UIColor clearColor];
//    [self.view addSubview:labdirty];

    
    if ([UIScreen mainScreen].bounds.size.height==568) {
        CGRect fr;
        
        startButton.center=CGPointMake(160, 400+G_YADDONVERSION);
        
//        fr=labdirty.frame;
//        labdirty.frame=CGRectMake(fr.origin.x, fr.origin.y+30, fr.size.width, fr.size.height);
//        fr=labdry.frame;
//        labdry.frame=CGRectMake(fr.origin.x, fr.origin.y+30, fr.size.width, fr.size.height);
//        fr=labwet.frame;
//        labwet.frame=CGRectMake(fr.origin.x, fr.origin.y+30, fr.size.width, fr.size.height);
        
        fr=wet.frame;
        wet.frame=CGRectMake(fr.origin.x, fr.origin.y+30, fr.size.width, fr.size.height);
        fr=dirty.frame;
        dirty.frame=CGRectMake(fr.origin.x, fr.origin.y+30, fr.size.width, fr.size.height);
        fr=dry.frame;
        dry.frame=CGRectMake(fr.origin.x, fr.origin.y+30, fr.size.width, fr.size.height);
        
    }
    
    
}


-(void)Activityselected:(UIButton*)sender
{
    sender.enabled=NO;
    
    UIButton *another1,*another2;
    if (sender.tag==201) {
        another1=(UIButton*)[self.view viewWithTag:202];
        
        another2=(UIButton*)[self.view viewWithTag:203];
        self.status=@"Dry";
        
    }
    else if(sender.tag==202)
    {
        another1=(UIButton*)[self.view viewWithTag:201];
        another2=(UIButton*)[self.view viewWithTag:203];
        self.status=@"Wet";
    }
    else
    {
        another1=(UIButton*)[self.view viewWithTag:201];
        another2=(UIButton*)[self.view viewWithTag:202];
        self.status=@"Dirty";
    }
    another1.enabled=YES;
    another2.enabled=YES;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeNav];
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

-(void)startOrPause:(UIButton*)sender
{
    [self makeSave];
}

-(void)makeSave
{

    if (saveView==nil) {
        saveView=[[save_diaperview alloc]init];
        [saveView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-SAVEVIEW_YADDONVERSION, self.view.frame.size.width, self.view.frame.size.height)];
        saveView.status = self.status;

    }
    saveView.status=self.status;
    [saveView loaddata];

    startButton.enabled = NO;
    [self.view addSubview:saveView];
    
}
-(void)stop
{
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timerOn"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ctl"];
//    [timer invalidate];
//    timeLable.text=@"00:00:00";
    startButton.selected=NO;
    startButton.enabled = YES;

    [saveView removeFromSuperview];

}
-(void)cancel

{
    //[saveView removeFromSuperview];
    startButton.enabled = YES;
}
-(void)environmentOradvise:(UIButton *)sender
{
    sender.enabled=NO;
    sender.titleLabel.textColor=[UIColor whiteColor];
    UIButton *another;
    
    if (sender.tag==501) {
        another=(UIButton*)[self.view viewWithTag:502];
        weather.hidden=NO;
    }
    else
    {
        another=(UIButton*)[self.view viewWithTag:501];
        weather.hidden=YES;
        
    }
    another.enabled=YES;
    another.titleLabel.textColor=[UIColor grayColor];
}


@end
