//
//  SummaryViewController.m
//  Parenting
//
//  Created by 家明 on 13-5-17.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "SummaryViewController.h"
#import "defaultAppDelegate.h"
#import "UMSocial.h"
#import "QuadCurveMenuItem.h"
#import "CustumCell.h"
#import "AdviseData.h"
#import "AdviseTableViewCell.h"
#import "TipsWebViewController.h"

#define originalHeight 25.0f
#define newHeight 100.0f
#define isOpen @"100.0f"

@interface SummaryViewController ()
{
    int currentAPICall;
    
    //AdviseList
    NSMutableDictionary *dicClicked;
    CGFloat mHeight;
    NSInteger sectionIndex;
}
@end

@implementation SummaryViewController
@synthesize dataArray;
@synthesize plotScrollView, plot,Mark;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        plotTag = 0;
        isScroll = YES;
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 100, 20)];
        titleView.backgroundColor=[UIColor clearColor];
        UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        titleText.backgroundColor = [UIColor clearColor];
        [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
        titleText.textColor = [UIColor whiteColor];
        [titleText setTextAlignment:NSTextAlignmentCenter];
        [titleText setText:NSLocalizedString(@"navsummary", nil)];
        [titleView addSubview:titleText];
        
        self.navigationItem.titleView = titleView;
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ( IOS7_OR_LATER )
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        //self.title  = NSLocalizedString(@"navsummary", nil);
    }
    return self;
}

-(void)setting
{
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_title.png"] forBarMetrics:UIBarMetricsDefault];
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"总结"];
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"gototips"]boolValue] == YES) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"gototips"];
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.color = [UIColor grayColor];
        hud.alpha = 0.5;
        hud.labelText = NSLocalizedString(@"PlotLoading", nil);
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"justdoit"] boolValue] == YES) {
            NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(willShowView:) object:[NSNumber numberWithBool:YES]];
            [thread start];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"justdoit"];
        }
        else
        {
            NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(willShowView:) object:[NSNumber numberWithBool:NO]];
            [thread start];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"总结"];
    [menu setValue:[NSNumber numberWithBool:NO] forKey:@"expanding"];
    
}

-(void)willShowView:(NSNumber*)flag
{
    [self segmentSelected:(UIButton *)[self.view viewWithTag:101]];
    
    [self TimeSelected:(UIButton*)[self.view viewWithTag:201]];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"MARK"] isEqualToString:@"1"] ||![[NSUserDefaults standardUserDefaults] objectForKey:@"MARK"]) {
        [self MenuSelectIndex:1];
        if (backbutton) {
            [backbutton setHidden:YES];
        }
    }
    else
    {
        if (backbutton != nil ) {
            [backbutton setHidden:NO];
        }
    }
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg_title.png"]  forBarMetrics:UIBarMetricsDefault];
    if ([flag boolValue]==YES) {
        [self scrollUpadateData];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.Mark setFrame:CGRectMake(244, 31+G_YADDONVERSION, 76, 137)];
    
    NSLog(@"%@", DBPATH);
    plotArray = [[NSMutableArray alloc] initWithCapacity:0];
    CGRect rx = [ UIScreen mainScreen ].bounds;
    plotScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, 320, rx.size.height  - 35 - 49-20- G_YADDONVERSION + 5 + 23)];
    [self.view addSubview:plotScrollView];
    //plotScrollView.contentSize = CGSizeMake(320 * [DataBase scrollWidth:0], rx.size.height  - 35 - 49-20);
    plotScrollView.contentSize = CGSizeMake(320 * [DataBase scrollWidthWithTag:0 andTableName:[self tableName:selectIndex]], 0);
    plotScrollView.delegate = self;
    plotScrollView.pagingEnabled = YES;
    plotScrollView.showsHorizontalScrollIndicator = NO;
    //界面布局
    [self setting];

    [self makeHeadSegement];
    [self makeTimeSegment];
    [self makeMenu];
    NSLog(@"%f",menu.frame.size.height);
    List =[[UITableView alloc]initWithFrame:CGRectMake(0, 35 + G_YADDONVERSION, 320, menu.frame.size.height-60-30) style:UITableViewStylePlain];
    List.backgroundColor=[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];
    [self.view addSubview:List];
    List.delegate   = self;
    List.dataSource = self;
    List.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view bringSubviewToFront:self.ExplainView];

    List.allowsSelectionDuringEditing=YES;
    
    //AdviseList init
    mHeight = originalHeight;
    sectionIndex = 0;
    dicClicked = [NSMutableDictionary dictionaryWithCapacity:3];
    Advise =[[UITableView alloc]initWithFrame:CGRectMake(0, 35+G_YADDONVERSION, 320, menu.frame.size.height-60-30) style:UITableViewStylePlain];
    Advise.backgroundColor=[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1];
    [self.view addSubview:Advise];
    Advise.delegate=self;
    Advise.dataSource=self;
    Advise.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    //分享按钮
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 43, 28);
//    [button addTarget:self action:@selector(ShareBtn) forControlEvents:UIControlEventTouchUpInside];
//    [button setBackgroundImage:[UIImage imageNamed:@"btn3.png"] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
//    UIBarButtonItem *rtButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = rtButton;
//    
//    Shareview=[[UIImageView alloc]initWithFrame:CGRectMake(20, -300+G_YADDONVERSION, 280, 300)];
//
//    
//    [Shareview setImage:[UIImage imageNamed:@"save_bg.png"]];
//    [Shareview.image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
//    Shareview.userInteractionEnabled=YES;
//    UIImageView *Shareimage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 260, 180)];
//    [Shareview addSubview:Shareimage];
//    Shareimage.tag=10001;
//    Shareimage.contentMode=UIViewContentModeScaleAspectFit;
//    Sharetext=[[UITextField alloc]initWithFrame:CGRectMake(10, 210, 260, 30)];
//    [Shareview addSubview:Sharetext];
//    Sharetext.tag=10002;
//    Sharetext.borderStyle=UITextBorderStyleRoundedRect;
//    
//    UIButton *share=[UIButton buttonWithType:UIButtonTypeCustom];
//    [share setTitle:NSLocalizedString(@"Share",nil) forState:UIControlStateNormal];
//    
//    share.frame=CGRectMake(155, 250, 100, 40);
//    [share setBackgroundImage:[UIImage imageNamed:@"btn_setting.png"] forState:UIControlStateNormal];
//    [share addTarget:self action:@selector(Share) forControlEvents:UIControlEventTouchUpInside];
//    UIButton *cancle=[UIButton buttonWithType:UIButtonTypeCustom];
//    cancle.frame=CGRectMake(15, 250, 100, 40);
//    [cancle setTitle:NSLocalizedString(@"Cancle",nil) forState:UIControlStateNormal];
//    [cancle addTarget:self action:@selector(hidenshareview) forControlEvents:UIControlEventTouchUpInside];
//    [cancle setBackgroundImage:[UIImage imageNamed:@"btn_setting.png"] forState:UIControlStateNormal];
//    [Shareview addSubview:share];
//    [Shareview addSubview:cancle];
    
    backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(9, 0, 34, 28)];
    title.backgroundColor = [UIColor clearColor];
    [title setTextAlignment:NSTextAlignmentCenter];
    title.textColor = [UIColor whiteColor];
    title.text =NSLocalizedString(@"navback", nil);
    title.font = [UIFont systemFontOfSize:14];
    [backbutton addSubview:title];
    
    
    [backbutton addTarget:self action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    backbutton.frame=CGRectMake(0, 0, 44, 28);
    
    
    UIBarButtonItem *backbar=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=backbar;

    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"MARK"] isEqualToString:@"1"] ||![[NSUserDefaults standardUserDefaults] objectForKey:@"MARK"]) {
        
        [self MenuSelectIndex:0];
        [backbutton setHidden:YES];
    }
    else
    {
        [backbutton setHidden:NO];
    }

    [self.view bringSubviewToFront:menu];
    
    UILabel *sign1=(UILabel*)[self.Mark viewWithTag:601];
    UILabel *sign2=(UILabel*)[self.Mark viewWithTag:602];
    UILabel *sign3=(UILabel*)[self.Mark viewWithTag:603];
    UILabel *sign4=(UILabel*)[self.Mark viewWithTag:604];
    UILabel *sign5=(UILabel*)[self.Mark viewWithTag:605];
    
    sign1.text=NSLocalizedString(@"Play", nil);
    sign2.text=NSLocalizedString(@"Bath", nil);
    sign3.text=NSLocalizedString(@"Feed", nil);
    sign4.text=NSLocalizedString(@"Sleep", nil);
    sign5.text=NSLocalizedString(@"Diaper", nil);
    [self.view addSubview:Shareview];
    [self makePlotSegment];
    NSUserDefaults *db = [NSUserDefaults standardUserDefaults];
    [db setInteger:0 forKey:@"SHUIBIAN"];
    [db synchronize];
    
    

    // Do any additional setup after loading the view from its nib.
}

- (void)popViewControllerAnimated:(id)sender{
    NSString *str = @"1";
    NSUserDefaults *db = [NSUserDefaults standardUserDefaults];
    [db setObject:str forKey:@"MARK"];
    [db synchronize];
    self.tabBarController.selectedIndex = 0;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [Sharetext resignFirstResponder];
}

- (void)ShareBtn{
    
    [self hidenshareview];
    //UIView *view = [[[[[UIApplication sharedApplication] windows] objectAtIndex:0] subviews] lastObject];//获得某个window的某个subView
    UIGraphicsBeginImageContext(CGSizeMake(plotScrollView.frame.size.width, plotScrollView.frame.size.height - 65));
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *parentImage=UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef imageRef = parentImage.CGImage;
    CGRect myImageRect=CGRectMake(plotScrollView.frame.origin.x, plotScrollView.frame.origin.y, plotScrollView.frame.size.width, plotScrollView.frame.size.height - 65);
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size=CGSizeMake(plotScrollView.frame.size.width,  plotScrollView.frame.size.height - 65);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* image = [UIImage imageWithCGImage:subImageRef];

    
    NSData *imagedata=UIImagePNGRepresentation(image);
     [imagedata writeToFile:SHAREPATH atomically:NO];
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    UIGraphicsEndImageContext();
    [UIView beginAnimations:@"ToggleViews" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView commitAnimations];
    UIImageView *imageview=(UIImageView*)[Shareview viewWithTag:10001];
    imageview.image=image;
    [self showshareview];
    
    
    [self Share];
}
-(void)Share
{

    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENGAPPKEY
                                      shareText:@"分享我的宝贝每一天的记录"
                                     shareImage:[UIImage imageWithContentsOfFile:SHAREPATH]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ,UMShareToRenren,UMShareToDouban,UMShareToEmail,UMShareToSms,UMShareToFacebook,UMShareToTwitter,nil]
                                       delegate:nil];
    
    //构造分享内容
//    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
//                                       defaultContent:@"默认分享内容，没内容时显示"
//                                                image:[ShareSDK imageWithPath:SHAREPATH]
//                                                title:@"Babycare"
//                                                  url:@"http://www.sharesdk.cn"
//                                          description:@"这是一条测试信息"
//                                            mediaType:SSPublishContentMediaTypeNews];
//    
//    
//    
//    
//    NSArray *sharelist=[ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeFacebook,ShareTypeMail,ShareTypeCopy,ShareTypeAirPrint, nil];
//    
//
//
//    
//    
//    NSArray *oneKeyShareList = [ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeFacebook,nil];
//    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:nil
//                                                                oneKeyShareList:oneKeyShareList
//                                                               qqButtonHidden:YES
//                                                        wxSessionButtonHidden:YES
//                                                       wxTimelineButtonHidden:YES
//                                                         showKeyboardOnAppear:NO
//                                                            shareViewDelegate:nil
//                                                          friendsViewDelegate:nil  picViewerViewDelegate:nil];
//    
//    [ShareSDK showShareActionSheet:nil
//                         shareList:sharelist
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions: shareOptions
//                            result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                if (state == SSPublishContentStateSuccess)
//                                {
//                                    NSLog(@"分享成功");
//                                }
//                                else if (state == SSPublishContentStateFail)
//                                {
//                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode],  [error errorDescription]);
//                                }
//                            }];
//    
//
//
   
}
-(void)showshareview
{
    [self.view bringSubviewToFront:Shareview];
    [UIView setAnimationDuration:1];
    [UIView beginAnimations:nil context:nil];
    Shareview.frame=CGRectMake(20, 0, 280, 300);
    [UIView commitAnimations];
}

-(void)hidenshareview
{
    [UIView setAnimationDuration:1];
    [UIView beginAnimations:nil context:nil];
    Shareview.frame=CGRectMake(20, -300, 280, 300);
    Sharetext.text=@"";
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)segmentSelected:(UIButton *)sender
{
    sender.enabled=NO;
    List.hidden=YES;
    Advise.hidden=YES;
    plot.hidden=YES;
    Histogram.hidden=YES;
    Plotting.hidden=YES;
    sender.titleLabel.textColor=[UIColor whiteColor];
    [[self.view viewWithTag:201] setHidden:YES];
    [[self.view viewWithTag:202] setHidden:YES];
    self.Mark.hidden=YES;
    UIButton *another1,*another2;
    if (sender.tag==101) {
        another1=(UIButton*)[self.view viewWithTag:102];
        another2=(UIButton*)[self.view viewWithTag:103];
        self.Mark.hidden=NO;
        plot.hidden=NO;
        if (!(selectIndex==4)) {
            Histogram.hidden=NO;
            Plotting.hidden=NO;
        }
  
        [[self.view viewWithTag:201] setHidden:NO];
        [[self.view viewWithTag:202] setHidden:NO];
    }
    else if(sender.tag==102)
    {
        another1=(UIButton*)[self.view viewWithTag:101];
        another2=(UIButton*)[self.view viewWithTag:103];
        List.hidden=NO;
    }
    else
    {
        another1=(UIButton*)[self.view viewWithTag:101];
        another2=(UIButton*)[self.view viewWithTag:102];
        Advise.hidden = NO;
    }

    another1.enabled=YES;
    another2.enabled=YES;
    
    
}

-(void)makeHeadSegement
{
    UIButton *lable1_sum=[UIButton buttonWithType:UIButtonTypeCustom];
    [lable1_sum setBackgroundImage:[UIImage imageNamed:@"label1_sum.png"] forState:UIControlStateNormal];
    [lable1_sum setBackgroundImage:[UIImage imageNamed:@"label1_sum_focus.png"] forState:UIControlStateHighlighted];
    [lable1_sum setBackgroundImage:[UIImage  imageNamed:@"label1_sum_focus.png"] forState:UIControlStateDisabled];
    [lable1_sum addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventTouchUpInside];
    lable1_sum.frame=CGRectMake(0, 0+G_YADDONVERSION, 106, 35);
    lable1_sum.tag=101;
    [self.view addSubview:lable1_sum];
    
    UIButton *lable2_sum=[UIButton buttonWithType:UIButtonTypeCustom];
    [lable2_sum setBackgroundImage:[[UIImage imageNamed:@"label2_sum.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]forState:UIControlStateNormal];
    [lable2_sum setBackgroundImage:[[UIImage imageNamed:@"label2_sum_focus.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateHighlighted];
    [lable2_sum setBackgroundImage:[[UIImage imageNamed:@"label2_sum_focus.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateDisabled];
    [lable2_sum addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventTouchUpInside];
    lable2_sum.tag=102;
    lable2_sum.frame=CGRectMake(106, 0+G_YADDONVERSION, 108, 35);
    [self.view addSubview:lable2_sum];
    
    UIButton *lable3_sum=[UIButton buttonWithType:UIButtonTypeCustom];
    [lable3_sum setBackgroundImage:[UIImage imageNamed:@"label3_sum.png"] forState:UIControlStateNormal];
    [lable3_sum setBackgroundImage:[UIImage imageNamed:@"label3_sum_focus.png"] forState:UIControlStateHighlighted];
    [lable3_sum setBackgroundImage:[UIImage imageNamed:@"label3_sum_focus.png"] forState:UIControlStateDisabled];
    [lable3_sum addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventTouchUpInside];
    lable3_sum.frame=CGRectMake(214, 0+G_YADDONVERSION, 106, 35);
    lable3_sum.tag=103;
    
    [self.view addSubview:lable3_sum];
    
}
-(void)makeTimeSegment
{
    float Y = 0.0;
    if ([OpenFunction getSystemVersion] >= 7.0) {
        Y += 64.0;
    }
    CGRect rx = [ UIScreen mainScreen ].bounds;
    
    UIButton *week_sum=[UIButton buttonWithType:UIButtonTypeCustom];
    [week_sum setBackgroundImage:[UIImage imageNamed:@"btn_day.png"] forState:UIControlStateNormal];
    [week_sum setBackgroundImage:[UIImage imageNamed:@"btn_day_focus.png"] forState:UIControlStateHighlighted];
    [week_sum setBackgroundImage:[UIImage  imageNamed:@"btn_day_focus.png"] forState:UIControlStateDisabled];
    [week_sum addTarget:self action:@selector(TimeSelected:) forControlEvents:UIControlEventTouchUpInside];
    [week_sum setTitle:NSLocalizedString(@"Week", nil) forState:UIControlStateNormal];
    week_sum.frame=CGRectMake((320-86*2)/2, rx.size.height - 130-20+G_YADDONVERSION, 86, 30);
    week_sum.tag=201;
    
    week_sum.titleLabel.textColor=[UIColor grayColor];
    [self.view addSubview:week_sum];
    
    UIButton *year_sum=[UIButton buttonWithType:UIButtonTypeCustom];
    [year_sum setBackgroundImage:[UIImage imageNamed:@"btn_year.png"] forState:UIControlStateNormal];
    [year_sum setBackgroundImage:[UIImage imageNamed:@"btn_year_focus.png"] forState:UIControlStateHighlighted];
    [year_sum setBackgroundImage:[UIImage imageNamed:@"btn_year_focus.png"] forState:UIControlStateDisabled];
    [year_sum addTarget:self action:@selector(TimeSelected:) forControlEvents:UIControlEventTouchUpInside];
    [year_sum setTitle:NSLocalizedString(@"Month", nil) forState:UIControlStateNormal];
    year_sum.frame=CGRectMake((320-86*2)/2+86,  rx.size.height - 130-20 + G_YADDONVERSION, 86, 30);
    year_sum.tag=202;
    year_sum.titleLabel.textColor=[UIColor grayColor];
    
    [self.view addSubview:year_sum];
    [self TimeSelected:week_sum];
}
-(void)TimeSelected:(UIButton*)sender
{
    sender.enabled=NO;
    UIButton *another1;
    if (sender.tag==201) {
        plotTag = 0;
        another1=(UIButton*)[self.view viewWithTag:202];
    }
    else if(sender.tag==202)
    {
        plotTag = 1;
        another1=(UIButton*)[self.view viewWithTag:201];
    }
    another1.enabled=YES;
    
    another1.titleLabel.textColor=[UIColor grayColor];
    
    sender.titleLabel.textColor=[UIColor whiteColor];
    isScroll = NO;
    [plot removeFromSuperview];
    //CGRect rx = [UIScreen mainScreen ].bounds;
    
    //plotScrollView.contentSize = CGSizeMake([DataBase scrollWidth:plotTag] * 320, rx.size.height  - 35 - 49-20);
    plotScrollView.contentSize = CGSizeMake([DataBase scrollWidthWithTag:plotTag andTableName:[self tableName:selectIndex]] * 320, 0);
    
    for (MyCorePlot *plot_1 in plotArray) {
        [plot_1 removeFromSuperview];
    }
    [plotArray removeAllObjects];
    [self scrollUpadateData];

}

- (void)setName{
    NSUserDefaults *db = [NSUserDefaults standardUserDefaults];
  
    [plot setCorePlotName:[db objectForKey:@"NAME"]];
}

-(void)makeMenu
{
//    QuadCurveMenuItem *menuitemall = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"btn_all.png"]
//                                                     highlightedImage:[UIImage imageNamed:@"btn_all_focus.png"]
//                                                         ContentImage:[UIImage imageNamed:@"btn_all.png"]
//                                              highlightedContentImage:[UIImage imageNamed:@"btn_all_focus.png"]];
    // People MenuItem.
    QuadCurveMenuItem *menuitemplay = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"btn_play.png"]
                                                      highlightedImage:[UIImage imageNamed:@"btn_play_focus.png"]
                                                          ContentImage:[UIImage imageNamed:@"btn_play.png"]
                                               highlightedContentImage:[UIImage imageNamed:@"btn_play_focus.png"]];
    // Place MenuItem.
    QuadCurveMenuItem *menuitembath = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"btn_bath.png"]
                                                      highlightedImage:[UIImage imageNamed:@"btn_bath_focus.png"]
                                                          ContentImage:[UIImage imageNamed:@"btn_bath.png"]
                                               highlightedContentImage:[UIImage imageNamed:@"btn_bath_focus.png"]];
    // Music MenuItem.
    QuadCurveMenuItem *menuitemfeed = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"btn_feed.png"]
                                                      highlightedImage:[UIImage imageNamed:@"btn_feed_focus.png"]
                                                          ContentImage:[UIImage imageNamed:@"btn_feed.png"]
                                               highlightedContentImage:[UIImage imageNamed:@"btn_feed_focus.png"]];
    // Thought MenuItem.
    QuadCurveMenuItem *menuitemsleep = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"btn_sleep.png"]
                                                       highlightedImage:[UIImage imageNamed:@"btn_sleep_focus.png"]
                                                           ContentImage:[UIImage imageNamed:@"btn_sleep.png"]
                                                highlightedContentImage:[UIImage imageNamed:@"btn_sleep_focus.png"]];
    // Sleep MenuItem.
    QuadCurveMenuItem *menuitemdiaper = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"btn_diaper.png"]
                                                        highlightedImage:[UIImage imageNamed:@"btn_diaper_focus.png"]
                                                            ContentImage:[UIImage imageNamed:@"btn_diaper.png"]
                                                 highlightedContentImage:[UIImage imageNamed:@"btn_diaper_focus.png"]];
    
    NSArray *menus = [NSArray arrayWithObjects:menuitemplay, menuitembath, menuitemfeed, menuitemsleep, menuitemdiaper, nil];
    CGRect rx = [ UIScreen mainScreen ].bounds;
    
    float Y = 0.0;
    if ([OpenFunction getSystemVersion] >= 7.0) {
        Y += 64.0;
    }
    
    if(rx.size.height > 480){
        menu = [[QuadCurveMenu alloc] initWithFrame:CGRectMake(0, 0+G_YADDONVERSION, 320, [UIScreen mainScreen].bounds.size.height-20-44- 49) menus:menus];
    }else{
        menu = [[QuadCurveMenu alloc] initWithFrame:CGRectMake(0, 0+G_YADDONVERSION, 320, [UIScreen mainScreen].bounds.size.height-20-44 - 49) menus:menus];

    }
    
    menu.delegate = self;
    [self.view addSubview:menu];
    
}

- (void)MenuSelectIndex:(int)index{
    
    [self quadCurveMenu:menu didSelectIndex:index];
}

-(void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx
{
    
    UIButton *btn=(UIButton*)[self.view viewWithTag:101];
    NSLog(@"idx  %d",idx);
    if ((idx==4)||btn.enabled) {
        Plotting.hidden=YES;
        Histogram.hidden=YES;
    }
    else
    {
        Plotting.hidden=NO;
        Histogram.hidden=NO;
    }
    switch (idx) {
//        case 0:
//        {
//            ListArray=[[DataBase dataBase] selectAllforsummary];
//            [List reloadData];
//            
//            int advise_lock = [DataBase selectFromUserAdvise:ADVISE_TYPE_BATH];
//            AdviseArray = [DataBase selectsuggestionbath:advise_lock];
//           // NSLog(@"%@",AdviseArray);
//            chooseAdvise = ADVISE_TYPE_ALL;
//            [Advise reloadData];
//        }
//            break;
        case 0:
        {
            ListArray=[[DataBase dataBase] selectplayforsummary];
            [List reloadData];
            
            int advise_lock = [DataBase selectFromUserAdvise:ADVISE_TYPE_PLAY];
            AdviseArray = [DataBase selectsuggestionplay:advise_lock];
            chooseAdvise = ADVISE_TYPE_PLAY;
            [Advise reloadData];
        }
            break;
        case 1:
        {
            ListArray=[[DataBase dataBase] selectbathforsummary];
            [List reloadData];
            
            int advise_lock = [DataBase selectFromUserAdvise:ADVISE_TYPE_BATH];
            AdviseArray = [DataBase selectsuggestionbath:advise_lock];
            chooseAdvise = ADVISE_TYPE_BATH;
            [Advise reloadData];
        }
            break;
        case 2:
        {
            ListArray=[[DataBase dataBase] selectfeedforsummary];
            [List reloadData];
            
            int advise_lock = [DataBase selectFromUserAdvise:ADVISE_TYPE_FEED];
            AdviseArray = [DataBase selectsuggestionfeed:advise_lock];
            chooseAdvise = ADVISE_TYPE_FEED;
            [Advise reloadData];
        }
            break;
        case 3:
        {
            ListArray=[[DataBase dataBase] selectsleepforsummary];
            [List reloadData];
            
            int advise_lock = [DataBase selectFromUserAdvise:ADVISE_TYPE_SLEEP];
            chooseAdvise = ADVISE_TYPE_SLEEP;
            AdviseArray = [DataBase selectsuggestionsleep:advise_lock];
            [Advise reloadData];
        }
            break;
        case 4:
        {
            ListArray=[[DataBase dataBase] selectdiaperforsummary];
            [List reloadData];
            
            int advise_lock = [DataBase selectFromUserAdvise:ADVISE_TYPE_DIAPER];
            AdviseArray = [DataBase selectsuggestiondiaper:advise_lock];
            chooseAdvise = ADVISE_TYPE_DIAPER;
            [Advise reloadData];
        }
            break;

        default:
            break;
    }
    
    for (MyCorePlot *plot_1 in plotArray) {
        [plot_1 removeFromSuperview];
    }
    [plotArray removeAllObjects];
    selectIndex = idx;
    [self scrollUpadateData];
}

-(void)updaterecord:(NSInteger)idx
{
    
    UIButton *btn=(UIButton*)[self.view viewWithTag:101];
    NSLog(@"idx  %d",idx);
    if ((idx==4)||btn.enabled) {
        Plotting.hidden=YES;
        Histogram.hidden=YES;
    }
    else
    {
        Plotting.hidden=NO;
        Histogram.hidden=NO;
    }
    switch (idx) {
        case -1:
        {
            ListArray=[[DataBase dataBase] selectAllforsummary];
            [List reloadData];
            
            int advise_lock = [DataBase selectFromUserAdvise:ADVISE_TYPE_BATH];
            AdviseArray = [DataBase selectsuggestionbath:advise_lock];
            NSLog(@"%@",AdviseArray);
            chooseAdvise = ADVISE_TYPE_ALL;
            [Advise reloadData];
        }
            break;
        case 0:
        {
            ListArray=[[DataBase dataBase] selectplayforsummary];
            [List reloadData];
            
            int advise_lock = [DataBase selectFromUserAdvise:ADVISE_TYPE_PLAY];
            AdviseArray = [DataBase selectsuggestionplay:advise_lock];
            chooseAdvise = ADVISE_TYPE_PLAY;
            [Advise reloadData];
        }
            break;
        case 1:
        {
            ListArray=[[DataBase dataBase] selectbathforsummary];
            [List reloadData];
            
            int advise_lock = [DataBase selectFromUserAdvise:ADVISE_TYPE_BATH];
            AdviseArray = [DataBase selectsuggestionbath:advise_lock];
            chooseAdvise = ADVISE_TYPE_BATH;
            [Advise reloadData];
        }
            break;
        case 2:
        {
            ListArray=[[DataBase dataBase] selectfeedforsummary];
            [List reloadData];
            
            int advise_lock = [DataBase selectFromUserAdvise:ADVISE_TYPE_FEED];
            AdviseArray = [DataBase selectsuggestionfeed:advise_lock];
            chooseAdvise = ADVISE_TYPE_FEED;
            [Advise reloadData];
        }
            break;
        case 3:
        {
            ListArray=[[DataBase dataBase] selectsleepforsummary];
            [List reloadData];
            
            int advise_lock = [DataBase selectFromUserAdvise:ADVISE_TYPE_SLEEP];
            chooseAdvise = ADVISE_TYPE_SLEEP;
            AdviseArray = [DataBase selectsuggestionsleep:advise_lock];
            [Advise reloadData];
        }
            break;
        case 4:
        {
            ListArray=[[DataBase dataBase] selectdiaperforsummary];
            [List reloadData];
            
            int advise_lock = [DataBase selectFromUserAdvise:ADVISE_TYPE_DIAPER];
            AdviseArray = [DataBase selectsuggestiondiaper:advise_lock];
            chooseAdvise = ADVISE_TYPE_DIAPER;
            [Advise reloadData];
        }
            break;
            
        default:
            break;
    }
    
    selectIndex = idx;
    plotScrollView.contentSize = CGSizeMake([DataBase scrollWidthWithTag:plotTag andTableName:[self tableName:selectIndex]] * 320, 0);

    for (MyCorePlot *plot_1 in plotArray) {
        [plot_1 removeFromSuperview];
    }
    [plotArray removeAllObjects];
    [self scrollUpadateData];
}


- (NSString *)tableName:(int)tableTag{
    NSString *retStr;
    switch (tableTag) {
        case -1:
            selectIndex = 0;
            retStr = @"All";
            break;
        case 0:
            selectIndex = 0;
            retStr = @"Play";
            break;
        case 1:
            selectIndex = 1;
            retStr = @"Bath";
            break;
        case 2:
            selectIndex = 2;
            retStr = @"Feed";
            break;
        case 3:
            selectIndex = 3;
            retStr = @"Sleep";
            break;
        case 4:
            selectIndex = 4;
            retStr = @"Diaper";
            break;
    }
    return retStr;
}

- (void)viewDidUnload {
    [self setExplainView:nil];
    [self setMark:nil];
    [super viewDidUnload];
}
-(void)AlertWithTitle:(NSString *)title Message:(NSString*)message
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == Advise)
        return 1;
    else
        return ListArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView == Advise)
        //return AdviseArray.count;
        switch (chooseAdvise) {
            case ADVISE_TYPE_ALL:
                return 64;
                break;
            case ADVISE_TYPE_FEED:
                return 35;
                break;
            case ADVISE_TYPE_SLEEP:
                return 5;
                break;
            case ADVISE_TYPE_BATH:
                return 6;
                break;
            case ADVISE_TYPE_DIAPER:
                return 5;
                break;
            case ADVISE_TYPE_PLAY:
                return 13;
                break;
            default:
                return 5;
                break;
        }
    else
        return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == List) {
        return nil;
    }
    
    CGRect headerFrame = CGRectMake(0, 0, 300, 30);
    CGFloat y = 2;
    if (section == 0) {
        headerFrame = CGRectMake(0, 0, 300, 100);
        y = 18;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
    [headerView setAlpha:0.5];
    [headerView setBackgroundColor:[UIColor colorWithRed:0x97/255.0 green:0x97/255.0 blue:0x97/255.0 alpha:0xFF/255.0]];
    UILabel *dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, y, 240, 24)];//日期标签
    dateLabel.font=[UIFont boldSystemFontOfSize:16.0f];
    dateLabel.textColor = [UIColor colorWithRed:0x97/255.0 green:0x97/255.0 blue:0x97/255.0 alpha:0xFF/255.0];
    dateLabel.backgroundColor=[UIColor clearColor];
    UILabel *ageLabel=[[UILabel alloc] initWithFrame:CGRectMake(216, y, 88, 24)];//年龄标签
    ageLabel.font=[UIFont systemFontOfSize:14.0];
    ageLabel.textAlignment=NSTextAlignmentCenter;
    ageLabel.textColor = [UIColor colorWithRed:0x97/255.0 green:0x97/255.0 blue:0x97/255.0 alpha:0xFF/255.0];;
    ageLabel.backgroundColor=[UIColor clearColor];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM dd,yyyy";
    //dateLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
    dateLabel.text = @"Everything is OK!";
    ageLabel.text = @"1岁 2天";
    
    //[headerView addSubview:dateLabel];
    //[headerView addSubview:ageLabel];
    return headerView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d,row:%d", indexPath.section, indexPath.row);
    if (tableView == List)
    {
        CustumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CustumCell" owner:self options:nil] lastObject];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }

        if (indexPath.row >= [ListArray count]) {
            return cell;
        }

        cell.minutesLable.textColor=cell.timeLable.textColor;
        SummaryItem *item=[ListArray objectAtIndex:indexPath.row];
        cell.timeLable.text = [currentdate dateForSummaryList:item.starttime];
        cell.minutesLable.text = item.duration;
        if ([item.type isEqualToString:@"Feed"]) {
            if ([item.feed_type isEqualToString:@"0"]) {
                cell.MarkLable.text = @"奶瓶喂食";
                cell.minutesLable.text = item.amount;
            }
            else
            {
                cell.MarkLable.text = @"哺乳";
            }
        }
        else
        {
            cell.MarkLable.text = NSLocalizedString(item.type, nil);
        }
        if ([item.duration isEqualToString:NSLocalizedString(@"Wet", nil)]) {
            cell.minutesLable.textColor=[UIColor colorWithRed:0x82/255.0 green:0xC6/255.0 blue:0xE1/255.0 alpha:0xFF/255.0];
        }
        else if([item.duration isEqualToString:NSLocalizedString(@"Dry", nil)])
        {
            cell.minutesLable.textColor=[UIColor colorWithRed:0.684 green:0.409 blue:0.179 alpha:1.000];
        }
        else if ([item.duration isEqualToString:NSLocalizedString(@"Dirty", nil)]) {
            cell.minutesLable.textColor=[UIColor colorWithRed:1.000 green:0.857 blue:0.062 alpha:1.000];
        }
        else
        {
            cell.minutesLable.textColor=cell.timeLable.textColor;
        }
        
        return cell;
    }
    else if (tableView == Advise){
        static NSString *CellIdentifier = @"Cell";
        
        UIImageView *tipsImageView;
        UILabel *tipsTitle;
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AdviseTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        
        tipsImageView = (UIImageView*)[cell.contentView viewWithTag:1];
        tipsTitle     = (UILabel*)[cell.contentView viewWithTag:2];
        
        NSString *imageName,*title;
       // NSLog(@"%d",indexPath.section);
        switch (chooseAdvise) {
            case ADVISE_TYPE_ALL:
                if (indexPath.section < 35) {
                    imageName = [NSString stringWithFormat:@"Feed_%d.jpg", indexPath.section % 5  + 1];
                    title =[NSString stringWithFormat:@"Feed_T%d", indexPath.section + 1];
                }
                else if (indexPath.section < 10)
                {
                    imageName = [NSString stringWithFormat:@"Sleep_%d.jpg", indexPath.section % 35 + 1];
                    title =[NSString stringWithFormat:@"Sleep_T%d", indexPath.section % 5+ 1];
                }
                else if (indexPath.section < 16)
                {
                    imageName = [NSString stringWithFormat:@"Bath_%d.jpg", indexPath.section % 10 + 1];
                    title =[NSString stringWithFormat:@"Bath_T%d", indexPath.section % 10 + 1];
                }
                else if (indexPath.section < 21)
                {
                    imageName = [NSString stringWithFormat:@"Diaper_%d.jpg", indexPath.section % 16 + 1];
                    title = [NSString stringWithFormat:@"Diaper_T%d", indexPath.section % 16 + 1];
                    
                }
                else
                {
                    imageName = [NSString stringWithFormat:@"Play_%d.jpg", indexPath.section % 21 + 1];
                    title = [NSString stringWithFormat:@"Play_T%d", indexPath.section % 21 + 1];
                }

                break;
            case ADVISE_TYPE_FEED:
                if (indexPath.section < 35) {
                    imageName = [NSString stringWithFormat:@"Feed_%d.jpg", indexPath.section % 5+ 1];
                    title =[NSString stringWithFormat:@"Feed_T%d", indexPath.section + 1];
                }
                break;
            case ADVISE_TYPE_SLEEP:
                if (indexPath.section < 5) {
                    imageName = [NSString stringWithFormat:@"Sleep_%d.jpg", indexPath.section + 1];
                    title =[NSString stringWithFormat:@"Sleep_T%d", indexPath.section + 1];
                }

                break;
            case ADVISE_TYPE_BATH:
                if (indexPath.section < 6) {
                    imageName = [NSString stringWithFormat:@"Bath_%d.jpg", indexPath.section + 1];
                    title =[NSString stringWithFormat:@"Bath_T%d", indexPath.section + 1];
                }
                break;
            case ADVISE_TYPE_DIAPER:
                if (indexPath.section < 5) {
                    imageName = [NSString stringWithFormat:@"Diaper_%d.jpg", indexPath.section + 1];
                    title =[NSString stringWithFormat:@"Diaper_T%d", indexPath.section + 1];
                }
                break;
            case ADVISE_TYPE_PLAY:
                if (indexPath.section < 13) {
                    imageName = [NSString stringWithFormat:@"Play_%d.jpg", indexPath.section + 1];
                    title =[NSString stringWithFormat:@"Play_T%d", indexPath.section + 1];
                }

                break;
            default:
                break;
        }
        title = NSLocalizedString(title, nil);
        tipsTitle.textColor = [UIColor colorWithRed:0xB3/255.0 green:0xB3/255.0 blue:0xB3/255.0 alpha:0xFF/255.0];
        [tipsTitle setText:title];
        tipsTitle.numberOfLines = 0;
        tipsTitle.lineBreakMode=NSLineBreakByWordWrapping;
        tipsTitle.textAlignment=NSTextAlignmentCenter;
        [tipsTitle setFont:[UIFont fontWithName:@"Arial" size:15]];
        [tipsImageView setImage:[UIImage imageNamed:imageName]];
        [tipsImageView setFrame:CGRectMake(15, 15, 100, 60)];
        [tipsImageView setContentMode:UIViewContentModeScaleAspectFill];
        [cell.contentView addSubview:tipsTitle];
        [cell.contentView addSubview:tipsImageView];
        return cell;
    }
    else
    {
        return NULL;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == List) {
        SummaryItem *item=[ListArray objectAtIndex:indexPath.row];
        [self showHistory:item];
    }
    else
    {
        if (indexPath.row != 0) {
            UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
            if (targetCell.frame.size.height == originalHeight){
                [dicClicked setObject:isOpen forKey:indexPath];
            }
            else{
                [dicClicked removeObjectForKey:indexPath];
            }
            [Advise reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        NSString *url, *key;
        switch (chooseAdvise) {
            case ADVISE_TYPE_ALL:
                if (indexPath.section < 35) {
                    key = [NSString stringWithFormat:@"Feed_%d", indexPath.section + 1];
                }
                else if (indexPath.section < 10)
                {
                    key = [NSString stringWithFormat:@"Sleep_%d", indexPath.section %25+ 1];
                }
                else if (indexPath.section < 16)
                {
                    key = [NSString stringWithFormat:@"Bath_%d", indexPath.section %10+ 1];
                }
                else if (indexPath.section < 21)
                {
                    key = [NSString stringWithFormat:@"Diaper_%d", indexPath.section%16 + 1];
                }
                else
                {
                    key = [NSString stringWithFormat:@"Play_%d", indexPath.section %21+ 1];
                }

                break;
            case ADVISE_TYPE_FEED:
                if (indexPath.section < 35) {
                    key = [NSString stringWithFormat:@"Feed_%d", indexPath.section + 1];
                }
                break;
            case ADVISE_TYPE_SLEEP:
                if (indexPath.section < 5) {
                    key = [NSString stringWithFormat:@"Sleep_%d", indexPath.section + 1];
                }
                break;
            case ADVISE_TYPE_BATH:
                if (indexPath.section < 6) {
                    key = [NSString stringWithFormat:@"Bath_%d", indexPath.section + 1];
                }
                break;
            case ADVISE_TYPE_DIAPER:
                if (indexPath.section < 5) {
                    key = [NSString stringWithFormat:@"Diaper_%d", indexPath.section + 1];
                }
                break;
            case ADVISE_TYPE_PLAY:
                if (indexPath.section < 13) {
                    key = [NSString stringWithFormat:@"Play_%d", indexPath.section + 1];
                }
                break;
            default:
                break;
        }
        
        url = NSLocalizedString(key, nil);
        
        TipsWebViewController *tips = [[TipsWebViewController alloc] init];
        [tips setTipsUrl:url];
        [self.navigationController pushViewController:tips animated:YES];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"gototips"];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//Section的标题栏高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == Advise)
    {
        if (section == 0)
            return 0;
        else
            return 1;
    }
    else
    {
        return 0;
    }
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == Advise) {
//        if (indexPath.row != 0) {
//            if ([[dicClicked objectForKey:indexPath] isEqualToString: isOpen])
//                return [[dicClicked objectForKey:indexPath] floatValue];
//            else
//                return originalHeight;
//        }
//        else {
//            return 25.0f;
//        }
        return 120;
    }
    else
    {
        return 41.0f;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == List)
    {
        if (editingStyle==UITableViewCellEditingStyleDelete) {

        
        SummaryItem *item=[ListArray objectAtIndex:indexPath.row];

        DataBase *db=[DataBase dataBase];
        
        [db deleteWithStarttime:item.starttime];
        
        [self MenuSelectIndex:selectIndex];

        }
    }
}

-(void)showHistory:(SummaryItem*)item
{
    //NSLog(@"%@",item.type);
    if ([item.type isEqualToString:@"Feed"]) {
        
        feed=[[save_feedview alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-SAVEVIEW_YADDONVERSION, self.view.frame.size.width, self.view.frame.size.height) Select:YES Start:item.starttime Duration:item.duration];
        feed.feedSaveDelegate = self;
        [feed loaddata];
        [self.view addSubview:feed];
    }
    else if ([item.type isEqualToString:@"Sleep"])
    {
        sleep=[[save_sleepview alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-SAVEVIEW_YADDONVERSION, self.view.frame.size.width, self.view.frame.size.height) Select:YES Start:item.starttime Duration:item.duration];
        sleep.sleepSaveDelegate = self;
       [sleep loaddata];
        [self.view addSubview:sleep];
    }
    else if ([item.type isEqualToString:@"Play"])
    {
        play=[[save_playview alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-SAVEVIEW_YADDONVERSION, self.view.frame.size.width, self.view.frame.size.height) Select:YES Start:item.starttime Duration:item.duration];
        play.playSaveDelegate = self;
        [play loaddata];
        [self.view addSubview:play];
    }
    else if ([item.type isEqualToString:@"Bath"])
    {
        bath=[[save_bathview alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-SAVEVIEW_YADDONVERSION, self.view.frame.size.width, self.view.frame.size.height) Select:YES Start:item.starttime Duration:item.duration];
        bath.bathSaveDelegate = self;
        [bath loaddata];
        [self.view addSubview:bath];
    }
    else
    {
        diaper=[[save_diaperview alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-SAVEVIEW_YADDONVERSION, self.view.frame.size.width, self.view.frame.size.height) Select:YES Start:item.starttime];
        diaper.diaperSaveDelegate = self;
        [diaper loaddata];
        [self.view addSubview:diaper];
    }
    
}

- (void)scrollUpadateData{

    CGRect rx = [UIScreen mainScreen ].bounds;
    NSLog(@"scrollUpdateData:%@,%d, %d",[self tableName:selectIndex],plotTag,[DataBase scrollWidthWithTag:plotTag andTableName:[self tableName:selectIndex]]);
    //int range = [DataBase scrollWidth:plotTag];
    int range = [DataBase scrollWidthWithTag:plotTag andTableName:[self tableName:selectIndex]];
    int j = 0;
    for (int i = range - 1; i >= 0;i--)
    {
        NSArray *data  = [DataBase scrollData:i andTable:[self tableName:selectIndex] andFieldTag:plotTag];
        int maxmonthday = [DataBase getMonthMax:i];
       //NSLog(@"%@",data);
        float maxyAxis = 0.0f;
        for (NSArray *ar in data) {
            for (NSString *str in ar) {
                if ([str floatValue] > maxyAxis) {
                    maxyAxis = [str floatValue];
                }
            }
        }
        double xLength = 0.0f;
        if (0 == plotTag) {
            xLength = 7.0f;
        }else{
            xLength = 6.0f;
        }
       
        plot = [[MyCorePlot alloc] initWithFrame:CGRectMake(([DataBase scrollWidthWithTag:plotTag andTableName:[self tableName:selectIndex]] - j - 1) * 320, 0, 320, rx.size.height - 40 - 35 - 49-20) andTitle:[self tableName:selectIndex] andXplotRangeWithLocation:0.0f andXlength:xLength andYplotRangeWithLocation:0.0f andYlength:maxyAxis * 1.5 andDataSource:data andXAxisTag:plotTag andMaxDay:maxmonthday];
        [plotScrollView addSubview:plot];
        [self setName];
        [plotArray addObject:plot];
        j++;
    }
    
    [plotScrollView scrollRectToVisible:CGRectMake([DataBase scrollWidthWithTag:plotTag andTableName:[self tableName:selectIndex]] * 320 - 320, 0, 320, rx.size.height - 40 - 35 - 49-20) animated:NO];
    
    [self.view bringSubviewToFront:self.Mark];
}

//折线图切换
-(void)makePlotSegment
{
    CGRect rx = [ UIScreen mainScreen ].bounds;
    Histogram=[UIButton buttonWithType:UIButtonTypeCustom];
    [Histogram setBackgroundImage:[UIImage imageNamed:@"btn_day.png"]  forState:UIControlStateNormal];
    [Histogram setBackgroundImage:[UIImage imageNamed:@"btn_day_focus.png"] forState:UIControlStateHighlighted];
    [Histogram setBackgroundImage:[UIImage  imageNamed:@"btn_day_focus.png"]  forState:UIControlStateDisabled];
    Histogram.contentMode=UIViewContentModeScaleAspectFill;
    [Histogram setTitle:NSLocalizedString(@"H", nil) forState:UIControlStateNormal];
    Histogram.frame=CGRectMake((320-30*2)/2+120, rx.size.height - 130-20+G_YADDONVERSION, 30, 30);
    [self.view addSubview:Histogram];
    
    Plotting=[UIButton buttonWithType:UIButtonTypeCustom];
    Plotting=[UIButton buttonWithType:UIButtonTypeCustom];
    [Plotting setBackgroundImage:[UIImage imageNamed:@"btn_year.png"]forState:UIControlStateNormal];
    [Plotting setBackgroundImage:[UIImage imageNamed:@"btn_year_focus.png"]  forState:UIControlStateHighlighted];
    [Plotting setBackgroundImage:[UIImage  imageNamed:@"btn_year_focus.png"] forState:UIControlStateDisabled];
    [Plotting setTitle:NSLocalizedString(@"P", nil) forState:UIControlStateNormal];
    Plotting.frame=CGRectMake((320-30*2)/2+30+120, rx.size.height - 130-20+G_YADDONVERSION, 30, 30);
    Plotting.contentMode=UIViewContentModeScaleToFill;
    [self.view addSubview:Plotting];
    
    [Plotting setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [Plotting setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    [Histogram setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [Histogram setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    [Histogram addTarget:self action:@selector(PLotSelected:) forControlEvents:UIControlEventTouchUpInside];
    [Plotting addTarget:self action:@selector(PLotSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    
    Histogram.titleLabel.numberOfLines = 0;
    Plotting.titleLabel.numberOfLines  = 0;
    Plotting.titleLabel.textAlignment  = NSTextAlignmentCenter;
    [self PLotSelected:Histogram];
    Histogram.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}
-(void)PLotSelected:(UIButton*)sender
{
    NSUserDefaults *db = [NSUserDefaults standardUserDefaults];
    sender.enabled=NO;
    if (sender==Histogram) {
        Plotting.enabled=YES;
        [db setInteger:0 forKey:@"SHUIBIAN"];
    }
    else
    {
        Histogram.enabled=YES;
        [db setInteger:1 forKey:@"SHUIBIAN"];
    }
    
    [db synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATECOREPLOT" object:nil];
}

#pragma -mark save delegate 
-(void)sendDiaperSaveChanged:(NSString *)newstatus andstarttime:(NSDate *)newstarttime
{
    [self updaterecord:QCM_TYPE_DIAPER];
}

-(void)sendSleepSaveChanged:(int)duration andstarttime:(NSDate *)newstarttime
{
    [self updaterecord:QCM_TYPE_SLEEP];
}

-(void)sendPlaySaveChanged:(int)duration andstarttime:(NSDate *)newstarttime
{
    [self updaterecord:QCM_TYPE_PLAY];
}

-(void)sendBathSaveChanged:(int)duration andstarttime:(NSDate *)newstarttime
{
    [self updaterecord:QCM_TYPE_BATH];
}

-(void)sendFeedSaveChanged:(int)duration andstarttime:(NSDate *)newstarttime
{
    [self updaterecord:QCM_TYPE_FEED];
}

@end
