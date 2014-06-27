//
//  save_diaperview.m
//  Parenting
//
//  Created by user on 13-5-25.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "save_diaperview.h"

@implementation save_diaperview
@synthesize status=_status,select,start,isshow;

-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self  makeSave];
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame Select:(BOOL)_select Start:(NSDate*)_start
{
    self.start=_start;
    self.select=_select;

    self=[self initWithFrame:frame];
    return self;
}

-(id)initWithFrame:(CGRect)frame Status:(NSString*)status
{
    self.status=status;
    return [self initWithFrame:frame];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void)makeSave
{
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 290, 30)];
    title.text=NSLocalizedString(@"Confirm your activity",nil);
    title.textAlignment=NSTextAlignmentCenter;
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[UIColor grayColor];
    imageview=[[UIImageView alloc]init];
    imageview.bounds=CGRectMake(0, 0, 290, 260);
    imageview.center=CGPointMake(160, (460-44-49)/2);
    [self addSubview:imageview];
    [imageview addSubview:title];
    
    [self makeDatePicker];
    // saveView.backgroundColor=[UIColor colorWithWhite:0.4 alpha:0.3];
    
    imageview.backgroundColor=[UIColor clearColor];
    imageview.userInteractionEnabled=YES;
    imageview.image=[UIImage imageNamed:@"save_bg.png"];
    [imageview.image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    UILabel *date=[[UILabel alloc]initWithFrame:CGRectMake(10, 40, 100, 30)];
    
    UILabel *starttime=[[UILabel alloc]initWithFrame:CGRectMake(10, 80, 100, 30)];
    
    
    UILabel *remark=[[UILabel alloc]initWithFrame:CGRectMake(10, 120, 100, 30)];
    
    UILabel *Activity=[[UILabel alloc]initWithFrame:CGRectMake(10, 160, 100, 30)];
    
    date.backgroundColor=[UIColor clearColor];
    starttime.backgroundColor=[UIColor clearColor];

    Activity.backgroundColor=[UIColor clearColor];
    remark.backgroundColor=[UIColor clearColor];
    
    date.textColor=[UIColor grayColor];
    starttime.textColor=[UIColor grayColor];
        Activity.textColor=[UIColor grayColor];
    remark.textColor=[UIColor grayColor];
    
    
    date.text=NSLocalizedString(@"Date:",nil);
    starttime.text=NSLocalizedString(@"Start Time:",nil);
    Activity.text=NSLocalizedString(@"Activity:",nil);
    remark.text=NSLocalizedString(@"Comments:",nil);
    
    
    dirty=[UIButton buttonWithType:UIButtonTypeCustom];
    dirty.frame=CGRectMake(225, 160, 89/2.0, 89/2.0);
    [dirty setBackgroundImage:[UIImage imageNamed:@"panels_icon_dirty"] forState:UIControlStateNormal];
    [dirty setBackgroundImage:[UIImage imageNamed:@"panels_icon_dirty_choose"] forState:UIControlStateDisabled];
    [imageview addSubview:dirty];
    dirty.tag=201;
    [dirty addTarget:self action:@selector(changeStatus:) forControlEvents:
     UIControlEventTouchUpInside];
    
    dry=[UIButton buttonWithType:UIButtonTypeCustom];
    dry.frame=CGRectMake(115, 160, 89/2.0, 89/2.0);
    [dry setBackgroundImage:[UIImage imageNamed:@"panels_icon_both"] forState:UIControlStateNormal];
    [dry setBackgroundImage:[UIImage imageNamed:@"panels_icon_both_choose"] forState:UIControlStateDisabled];
    [imageview addSubview:dry];
    dry.tag=202;
    [dry addTarget:self action:@selector(changeStatus:) forControlEvents:
     UIControlEventTouchUpInside];
    
    wet=[UIButton buttonWithType:UIButtonTypeCustom];
    wet.frame=CGRectMake(170, 160, 89/2.0, 89/2.0);
    [wet setBackgroundImage:[UIImage imageNamed:@"panels_icon_wet"] forState:UIControlStateNormal];
    [wet setBackgroundImage:[UIImage imageNamed:@"panels_icon_wet_choose"] forState:UIControlStateDisabled];
    [imageview addSubview:wet];
    wet.tag=203;
    [wet addTarget:self action:@selector(changeStatus:) forControlEvents:
     UIControlEventTouchUpInside];
    
    date.textAlignment=NSTextAlignmentRight;
    starttime.textAlignment=NSTextAlignmentRight;
   
    Activity.textAlignment=NSTextAlignmentRight;
    remark.textAlignment=NSTextAlignmentRight;
    
    [imageview addSubview:date];
    [imageview addSubview:starttime];
    [imageview addSubview:Activity];
    [imageview addSubview:remark];
    
    datetext=[[UITextField alloc]initWithFrame:CGRectMake(115, 40, 150, 30)];
    [datetext setBackground:[UIImage imageNamed:@"save_text.png"]];
    datetext.adjustsFontSizeToFitWidth=YES;
    [imageview addSubview:datetext];
    //datetext.enabled=NO;
    datetext.delegate = self;
    datetext.inputView = datepicker;
    
    datetext.textColor=[UIColor grayColor];
    
    [datetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [datetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [datetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [datetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    
    starttimetext=[[UITextField alloc]initWithFrame:CGRectMake(115, 80, 150, 30)];
    [starttimetext setBackground:[UIImage imageNamed:@"save_text.png"]];
    [imageview addSubview:starttimetext];
    starttimetext.textColor=[UIColor grayColor];
    
    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    [starttimetext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    //starttimetext.enabled=NO;
    starttimetext.delegate = self;
    starttimetext.inputView = starttimepicker;
    
    UIImageView *remarkbg=[[UIImageView alloc]initWithFrame:CGRectMake(115, 120, 150, 30)];
    remarkbg.image=[UIImage imageNamed:@"save_text.png"];
    remarkbg.userInteractionEnabled=YES;
    
    remarktext=[[UITextView alloc]initWithFrame:CGRectMake(-2, 0, 140, 30)];
    remarktext.backgroundColor=[UIColor clearColor];
    remarktext.textColor=[UIColor grayColor];
    //    [remarktext setBackground:[UIImage imageNamed:@"save_text.png"]];
    remarktext.font=[UIFont systemFontOfSize:16];
    [remarkbg addSubview:remarktext];
    [imageview addSubview:remarkbg];
    remarktext.delegate=self;
    //    [remarktext setValue:[NSNumber numberWithInt:5] forKey:@"paddingTop"];
    //    [remarktext setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    //    [remarktext setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
    //    [remarktext setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    
    UIButton *savebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    savebutton.frame=CGRectMake(200, 220, 70, 30);
    [savebutton setBackgroundImage:[UIImage imageNamed:@"btn2.png"] forState:UIControlStateNormal];
    [savebutton setTitle:NSLocalizedString(@"Save",nil) forState:UIControlStateNormal];
    [savebutton addTarget:self action:@selector(Save:) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:savebutton];
    
    UIButton *canclebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    canclebutton.frame=CGRectMake(20, 220, 70, 30);
    [canclebutton setBackgroundImage:[UIImage imageNamed:@"btn2.png"] forState:UIControlStateNormal];
    [canclebutton setTitle:NSLocalizedString(@"Cancle",nil) forState:UIControlStateNormal];
    [canclebutton addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:canclebutton];
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)changeStatus:(UIButton*) sender
{
    switch (sender.tag) {
        case 201:
            self.status = @"Dirty";
            dirty.enabled = NO;
            dry.enabled = YES;
            wet.enabled = YES;
            break;
        case 202:
            self.status = @"Dry";
            dirty.enabled = YES;
            dry.enabled   = NO;
            wet.enabled   = YES;
            break;
        case 203:
            self.status = @"Wet";
            dirty.enabled = YES;
            dry.enabled   = YES;
            wet.enabled   = NO;
            break;
        default:
            break;
    }
}

-(void)loaddata
{
    if (self.select) {
        
        DataBase *db=[DataBase dataBase];
        NSArray *array= [db searchFromdiaper:self.start];
        NSDate *date=(NSDate*)[array objectAtIndex:0];
        
        self.start = date;
        
        datetext.text=[currentdate dateFomatdate:date];
        
        
        starttimetext.text=[currentdate getStarttimefromdate:date];
        
        
        remarktext.text=[array objectAtIndex:1];
        
        self.status=[array objectAtIndex:2];
        NSLog(@"%@",self.status);
        if ([self.status isEqualToString:@"Wet"]) {
            wet.enabled=NO;
        }
        else if ([self.status isEqualToString:@"Dirty"])
        {
            dirty.enabled=NO;
        }
        else if([self.status isEqualToString:@"Dry"])
        {
            dry.enabled=NO;
        }
    }
    
    else
    {
        datetext.text=[currentdate dateFomatdate:[currentdate date]];
        starttimetext.text=[currentdate getStarttimefromdate:[currentdate date]];
        if ([self.status isEqualToString:@"Wet"]) {
            wet.enabled=NO;
            dry.enabled=YES;
            dirty.enabled=YES;
        }
        else if ([self.status isEqualToString:@"Dirty"])
        {
            dirty.enabled=NO;
            dry.enabled=YES;
            wet.enabled=YES;
        }
        else if([self.status isEqualToString:@"Dry"])
        {
            dry.enabled=NO;
            wet.enabled=YES;
            dirty.enabled=YES;
        }
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    for (id key in imageview.subviews) {
        if ([key isKindOfClass:[UITextField class]]) {
            [key resignFirstResponder];
        }
    }
    [remarktext resignFirstResponder];
}

-(void)Save:(UIButton*)sender
{
    DataBase *db=[DataBase dataBase];
    if (select)
    {
        
        //[db updatediaperStatus:self.status Remark:remarktext.text Starttime:start];
        if (curstarttime == nil) {
            [db updatediaperStatus:self.start Month:[currentdate getMonthFromDate:self.start] Week:[currentdate getWeekFromDate:self.start] WeekDay:[currentdate getWeekDayFromDate:self.start] Status:self.status Remark:remarktext.text OldStartTime:self.start];
        }
        else
        {
            [db updatediaperStatus:curstarttime Month:[currentdate getMonthFromDate:curstarttime] Week:[currentdate getWeekFromDate:curstarttime] WeekDay:[currentdate getWeekDayFromDate:curstarttime] Status:self.status Remark:remarktext.text OldStartTime:self.start];
            curstarttime = nil;
        }
        
        [self removeFromSuperview];
    }
    else{
        if (!self.status) {
            self.status=@"";
        }
    //[db insertdiaperStarttime:[currentdate date] Month:[currentdate getCurrentMonth] Week:[currentdate getCurrentWeek] WeekDay:[currentdate getCurrentWeekDay] Status:self.status Remark:remarktext.text];
        if (curstarttime == nil) {
            [db insertdiaperStarttime:[currentdate date] Month:[currentdate getCurrentMonth] Week:[currentdate getCurrentWeek] WeekDay:[currentdate getCurrentWeekDay] Status:self.status Remark:remarktext.text];
        }
        else
        {
            [db insertdiaperStarttime:curstarttime Month:[currentdate getMonthFromDate:curstarttime] Week:[currentdate getWeekFromDate:curstarttime] WeekDay:[currentdate getWeekDayFromDate:curstarttime] Status:self.status Remark:remarktext.text];
            curstarttime = nil;
        }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stop" object:nil];
    }
    
    [self.diaperSaveDelegate sendDiaperSaveChanged:self.status andstarttime:self.start];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"justdoit"];
}

-(void)cancle:(UIButton*)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancel" object:nil];
    [self removeFromSuperview];
}

-(void)updatedate:(UIDatePicker*)sender
{
    NSLog(@"updatedate:%@", sender);
    UIDatePicker *picker = sender;
    if (self.start == nil) {
        if (curstarttime == nil) {
            curstarttime = picker.date;
        }
        else
        {
            curstarttime = [currentdate getNewDateFromOldDate:picker.date andOldDate:curstarttime];
        }
    }
    else
    {
        if (curstarttime == nil) {
            curstarttime  = [currentdate getNewDateFromOldDate:picker.date andOldDate:self.start];
        }
        else
        {
            curstarttime  = [currentdate getNewDateFromOldDate:picker.date andOldDate:curstarttime];
        }
    }
    
    datetext.text = [currentdate dateFomatdate:curstarttime];
}

-(void)actionsheetShow
{
    action=[[UIActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    if (datepicker==nil) {
        datepicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, datetext.frame.origin.y+45, 320, 100)];
        datepicker.datePickerMode=UIDatePickerModeDate;
        [datepicker addTarget:self action:@selector(updatedate:) forControlEvents:UIControlEventValueChanged];
    }
    
    datepicker.frame=CGRectMake(0, 0, 320, 100);
    
    action.bounds=CGRectMake(0, 0, 320, 200);
    [action addSubview:datepicker];
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    if ([window.subviews containsObject:self]) {
        [action showInView:self];
    } else {
        [action showInView:window];
    }
}


-(void)updatestarttime:(UIDatePicker*)sender
{
    NSLog(@"updatestarttime:%@", sender);
    UIDatePicker *picker = sender;
    if (self.start == nil)
    {
        if (curstarttime == nil) {
            curstarttime = picker.date;
        }
        else
        {
             curstarttime = [currentdate getNewDateFromOldTime:picker.date andOldDate:curstarttime];
        }
    }
    else
    {
        if (curstarttime == nil) {
            curstarttime = [currentdate getNewDateFromOldTime:picker.date andOldDate:self.start];
        }
        else
        {
            curstarttime = [currentdate getNewDateFromOldTime:picker.date andOldDate:curstarttime];
        }
    }
   
    starttimetext.text = [currentdate getStarttimefromdate:curstarttime];
}

-(void)actionsheetStartTimeShow
{
    action2=[[UIActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    if (starttimepicker==nil) {
        starttimepicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, datetext.frame.origin.y+45, 320, 100)];
        starttimepicker.datePickerMode=UIDatePickerModeTime;
        [starttimepicker addTarget:self action:@selector(updatestarttime:) forControlEvents:UIControlEventValueChanged];
    }
    
    starttimepicker.frame=CGRectMake(0, 0, 320, 100);
    
    action2.bounds=CGRectMake(0, 0, 320, 200);
    [action2 addSubview:starttimepicker];
    [action2 showInView:self.window];
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
   
}

-(void)makeDatePicker
{
    [self addSubview:datepicker];
    datepicker.hidden=YES;
    
    [self addSubview:starttimepicker];
    starttimepicker.hidden = YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == datetext)
    {
        [self actionsheetShow];
        [datetext resignFirstResponder];
    }
    
    if (textField == starttimetext) {
        [self actionsheetStartTimeShow];
        [starttimetext resignFirstResponder];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{

}

-(void)keyboradshow
{
    if (!self.isshow) {
        NSTimeInterval animationDuration = 0.25f;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y-150, 320, 460-44-49);
        [UIView commitAnimations];
        self.isshow=YES;
    }
    
}

-(void)keyboradhidden
{
    if (self.isshow) {
        NSTimeInterval animationDuration = 0.25f;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y+150, 320, 460-44-49);
        [UIView commitAnimations];
        self.isshow=NO;
    }
}

- (void)keyboardWillShown:(NSNotification*)aNotification
{
    [self keyboradshow];
}

-(void)keyboardWillHidden:(NSNotification*)aNotification
{
    [self keyboradhidden];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

@end
