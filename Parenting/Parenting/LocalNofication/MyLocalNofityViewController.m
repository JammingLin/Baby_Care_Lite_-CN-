//
//  MyLocalNofityViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-6.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import "MyLocalNofityViewController.h"

@interface MyLocalNofityViewController ()

@end

@implementation MyLocalNofityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 100, 20)];
        titleView.backgroundColor=[UIColor clearColor];
        UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        titleText.backgroundColor = [UIColor clearColor];
        [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
        titleText.textColor = [UIColor whiteColor];
        [titleText setTextAlignment:NSTextAlignmentCenter];
        [titleText setText:NSLocalizedString(@"LocalNotify", nil)];
        [titleView addSubview:titleText];
        
        self.navigationItem.titleView = titleView;
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

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
