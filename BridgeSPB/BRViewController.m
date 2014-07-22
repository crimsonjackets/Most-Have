//
//  BRViewController.m
//  BridgeSPB
//
//  Created by Stas on 01.03.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import "BRViewController.h"
#import "Bridge.h"
#import "BRBridgeViewController.h"
#import "OneBridge.h"
#import "BRMAPViewController.h"
#import "UAirship.h"
#import "UAPush.h"
#import "MoreInfoViewController.h"
#import "InitSlViewController.h"
#import "time.h"
#import "MHBridgeInfo.h"
#import <CoreLocation/CoreLocation.h>

@interface BRViewController ()
{   UIImageView * rightImage;
    UIImageView * leftImage;
    UIButton * butLeftMenu;
    NSTimer *myTimer;
    UIButton * menuButton;
    NSTimer *myTimer2;
    NSTimer *myTimerForRef;
    int indexForInfo;
    NSArray *rangeForInfo;
    NSArray* mostWithTimer;
    NSTimer *myTimerForTimer;
    CGFloat yMenuBot;
    UIButton *butForOpenTimers;
    NSInteger newBot;
    UILabel* fourLabel;
    CLLocationManager *locationManager;
    NSInteger currentTime;
    
    
    
    int openSize, closeSize, shortSize, openedSize, closedSize;
    int openingSoon[13];//в старых индексах
    int openingSoonTime[13];
    int closingSoon[13];//в старых индексах
    int closingSoonTime[13];
    int shortClosed[13];
    int openedNow[13];
    int closedNow[13];
    
}
@end

@implementation BRViewController

@synthesize scroller;
@synthesize bridge;

@synthesize allIndex;
@synthesize shakeLabel;
@synthesize viewWithLabels;
@synthesize twoLabel;
@synthesize twoView;







- (void)viewDidAppear:(BOOL)animated {
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    self.slidingViewController.underRightViewController = nil;
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    [self.bridge refreshLoad:YES];
    [self refTimer];
    myTimerForRef =[NSTimer scheduledTimerWithTimeInterval:10
                                             target:self
                                           selector:@selector(updateStuff)
                                           userInfo:nil
                                            repeats:YES];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *pushMessage;
    if (standardUserDefaults)
        pushMessage = [standardUserDefaults objectForKey:@"pushMessage"];
    NSDictionary *lastMessage=[pushMessage lastObject];
    NSString *message=[[lastMessage objectForKey:@"aps"]objectForKey:@"shakeLabel"];
    if(message)
    {
        shakeLabel.text=message;
    }
    BOOL message1=NO;
    [standardUserDefaults setObject:[NSNumber numberWithBool:message1] forKey:@"toRoot"];
    [self becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [self becomeFirstResponder];
    [myTimerForRef invalidate];
}





- (BOOL) isFirstRun
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
    
    if (![defaults objectForKey:@"isFirstFirstRun"])
    {
       // NSLog(@"isFirstFirstRun");

        NSArray * time1 = [NSArray arrayWithObjects:
                           [Mytime MakeTimeWithHourOP:2 minOP:45 hourCl:1 minCl:25],
                           
                           [Mytime MakeTimeWithHourOP:0 minOP:0 hourCl:0 minCl:0],
                           [Mytime MakeTimeWithHourOP:4 minOP:50 hourCl:1 minCl:35],
                           [Mytime MakeTimeWithHourOP:4 minOP:45 hourCl:1 minCl:40],
                           [Mytime MakeTimeWithHourOP:5 minOP:00 hourCl:2 minCl:00],
                           [Mytime MakeTimeWithHourOP:5 minOP:10 hourCl:2 minCl:20],
                           [Mytime MakeTimeWithHourOP:3 minOP:45 hourCl:1 minCl:00],
                           [Mytime MakeTimeWithHourOP:2 minOP:55 hourCl:2 minCl:00],
                           [Mytime MakeTimeWithHourOP:4 minOP:55 hourCl:2 minCl:00],
                           [Mytime MakeTimeWithHourOP:0 minOP:0 hourCl:0 minCl:0],
                           [Mytime MakeTimeWithHourOP:0 minOP:0 hourCl:0 minCl:0],
                           [Mytime MakeTimeWithHourOP:0 minOP:0 hourCl:0 minCl:0],
                           [Mytime MakeTimeWithHourOP:5 minOP:30 hourCl:2 minCl:20],
                           nil];
        
        NSArray * time2 = [NSArray arrayWithObjects:
                           [Mytime MakeTimeWithHourOP:5 minOP:00 hourCl:3 minCl:10],
                           [Mytime MakeTimeWithHourOP:0 minOP:0 hourCl:0 minCl:0],
                           [Mytime MakeTimeWithHourOP:4 minOP:50 hourCl:1 minCl:35],
                           [Mytime MakeTimeWithHourOP:4 minOP:45 hourCl:1 minCl:40],
                           [Mytime MakeTimeWithHourOP:5 minOP:00 hourCl:2 minCl:00],
                           [Mytime MakeTimeWithHourOP:5 minOP:10 hourCl:2 minCl:20],
                           [Mytime MakeTimeWithHourOP:5 minOP:45 hourCl:4 minCl:15],
                           [Mytime MakeTimeWithHourOP:4 minOP:55 hourCl:3 minCl:35],
                           [Mytime MakeTimeWithHourOP:4 minOP:55 hourCl:2 minCl:00],
                           [Mytime MakeTimeWithHourOP:0 minOP:0 hourCl:0 minCl:0],
                           [Mytime MakeTimeWithHourOP:0 minOP:0 hourCl:0 minCl:0],
                           [Mytime MakeTimeWithHourOP:0 minOP:0 hourCl:0 minCl:0],
                           [Mytime MakeTimeWithHourOP:5 minOP:30 hourCl:2 minCl:20],
                           nil];

      //  [defaults setObject:[UIImage imageNamed: @"graphic.png"] forKey:@"graphic"] ;
        UIImage * image=[UIImage imageNamed: @"graphic.png"];
        [NSKeyedArchiver archiveRootObject:image
                                    toFile:[BRAppHelpers archivePathForGraphics]];

        NSMutableArray *array=[NSMutableArray arrayWithObjects:time1,time2, nil];
       // [defaults setObject: time1 forKey:@"mytimes"];
      //NSLog(@"hello %@",array );
        [NSKeyedArchiver archiveRootObject:array
                                toFile:[BRAppHelpers archivePaths]];
        [defaults setObject:@"isNOFirstRun" forKey:@"isFirstFirstRun"];
         [defaults synchronize];
       // NSLog(@"%@ - newGraphic",url);
    }
   // получаешь добро
    //Mytime *allRoles = [NSKeyedUnarchiver unarchiveObjectWithFile:[BRAppHelpers archivePaths]];
    
  //  NSLog(@"hello %@",allRoles );
      
    if ([defaults objectForKey:@"isFirstRun"])
    {
        NSString *string=[defaults objectForKey:@"isFirstRun"];
        if([string isEqualToString:@"isNOFirstRun"])
        {
            return NO;
        }
    }
    [defaults setObject:@"isNOFirstRun" forKey:@"isFirstRun"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

- (void)viewDidLoad
{
   [super viewDidLoad];

    [self becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStuff) name:@"updateBridgesInfo" object:nil];
    indexForInfo=0;
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];

    self.twoView.hidden=YES;
    self.twoLabelbefor.hidden=YES;
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.viewWithTimer.layer.shadowOffset = CGSizeMake(0, 1);
    self.viewWithTimer.layer.shadowOpacity = 0.5f;
    self.viewWithTimer.layer.shadowRadius = 0.5f;
    self.viewWithTimer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewWithTimer.layer.cornerRadius=15;
    
    self.twoView.layer.shadowOffset = CGSizeMake(0, 1);
    self.twoView.layer.shadowOpacity = 0.5f;
    self.twoView.layer.shadowRadius = 0.5f;
    self.twoView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.twoView.layer.cornerRadius=15;
    
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    [self.viewWithLabels addGestureRecognizer:self.slidingViewController.panGesture];
    
    self.navigationController.navigationBar.hidden=YES;
    
    //скроллер
    [scroller setScrollEnabled:NO];
    CGRect frame=scroller.frame;
    frame.origin.y=140;
    scroller.frame=frame;
    
    CGRect frameLabels=viewWithLabels.frame;
    
   
    
    //инициализация нижней кнопки меню и портатирование на 5 айфон
    

    
    if(([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)&&([UIScreen mainScreen].bounds.size.height == 568.0))
    {
        newBot=30;
        yMenuBot=510;
        //frameLabels.origin.y+=100;
        NSLog(@"viewWithLabels.frame inition");
        self.viewWithLabels.frame=frameLabels;
    }
    else
    {
        newBot=0;
        yMenuBot=419;
    }
    

    
    
    menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setFrame:CGRectMake(0, yMenuBot-5, 321, 45)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menubutton.png"] forState:UIControlStateNormal];

    [menuButton addTarget:self action:@selector(goGraphic:) forControlEvents:UIControlEventTouchUpInside];
    
  //  [menuButton setSelected:YES];
    UIColor *buttonColorHighlight = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    [menuButton setTitleColor:buttonColorHighlight forState:UIControlStateHighlighted];
    [menuButton setTitleShadowColor:buttonColorHighlight forState:UIControlStateHighlighted];
    [self.allView addSubview:menuButton];
    
    
    fourLabel=[[UILabel alloc]initWithFrame:CGRectMake(18, 118, 285, 45)];

    fourLabel.hidden=YES;
    [fourLabel setText:@"НАСТРОЕНИЯ"];
    [fourLabel setBackgroundColor:[UIColor clearColor]];
    [fourLabel setFont: self.shakeLabel.font];
    [fourLabel setTextColor:self.shakeLabel.textColor];
    [fourLabel setTextAlignment:NSTextAlignmentCenter];
    [self.viewWithLabels addSubview:fourLabel];
    
    
    
    if([self isFirstRun])
    {

        menuButton.hidden=YES;
        frameLabels.origin.y+=350+(yMenuBot-419)/2;
        viewWithLabels.frame=frameLabels;
        frameLabels.origin.y-=350+(yMenuBot-419)/2+newBot;
        //frameLabels.origin.y -= 30;
        NSLog(@"viewWithLabels.frame firstRun");
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2];
        
        
        viewWithLabels.frame=frameLabels;
        [UIView commitAnimations];
        
        
        
        myTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                                        target:self
                                                      selector:@selector(menuHide)
                                                      userInfo:nil
                                                       repeats:NO];

    }
    

    
    //инициализация шапки
    
    leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 25, 15, 11)];
    rightImage=[[UIImageView alloc]initWithFrame:CGRectMake(260, 30, 35, 5)];
    NSArray *imageLeftRight=[NSArray arrayWithObjects:rightImage,leftImage, nil];
    self.allView=[BRAppHelpers addHeadonView:self.allView andImages:imageLeftRight withTarget:self];
    

    
    self.bridge=[Bridge initWithView:self.allView belowBiew:scroller];

   // mostWithTimer=[self.bridge getListOfMostwithCalendar:calendar];
    butForOpenTimers=[UIButton buttonWithType:UIButtonTypeCustom];
    [butForOpenTimers setFrame:self.viewWithLabels.frame];
    frame=butForOpenTimers.frame;
    frame.origin.y-=yMenuBot-419;
    butForOpenTimers.frame=frame; 
    [butForOpenTimers addTarget:self action:@selector(openTimers) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scroller addSubview:butForOpenTimers];
    
    [self refTimer];
    
    [self.bridge refreshLoad:YES];
    // Do any additional setup after loading the view, typically from a nib.
}
//служит для обработки касаний

-(void)refTimer
{
    
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components =
    [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:today];
    currentTime = [components hour] * 60 + [components minute];
    NSLog(@"refTimer; currentTime == %d", currentTime);
    BOOL atLeastOneIsOpened = NO;
    BOOL noClosedBridgesToVO = NO;
    BOOL allBridgesAreOpened = YES;
    BOOL atLeastOneOnShortClose = NO;
    BOOL isMetroOpened = NO;
    BOOL isAtLeastOneIsOpeningSoon = NO;
    int firstOpenTime = 360;
    int lastOpenTime = 0;
    int closedBridgesToVO = 0;
    //Новые данные
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"bridgesInfo"];
    NSArray *newBridgesInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //Массив, отображающий индексы старых данных на индексы новых
    int indexInNew[13] = {0, 1, 4, 5, 6, 7, 8, 3, 2, 10, 11, 12, 9};
    openSize = 0;
    closeSize = 0;
    shortSize = 0;
    openedSize = 0;
    closedSize = 0;
    //просчитываем текущую ситуацию и выставляем флаги(BOOL)
    for (int i = 0; i < 9; i++){
        MHBridgeInfo *currBridgeInfo = newBridgesInfo[indexInNew[i]];
        if (firstOpenTime > currBridgeInfo.openTime){
            firstOpenTime = currBridgeInfo.openTime;
        }
        if (currBridgeInfo.isOpenedTwoTimes){
            if (lastOpenTime < currBridgeInfo.closeTime2){
                lastOpenTime = currBridgeInfo.closeTime2;
            }
        } else {
            if (lastOpenTime < currBridgeInfo.closeTime){
                lastOpenTime = currBridgeInfo.closeTime;
            }
        }
        if (currentTime >= currBridgeInfo.openTime - 30 && currentTime < currBridgeInfo.openTime){
            //opening soon;
            openingSoon[openSize] = i;
            openingSoonTime[openSize++] = currBridgeInfo.openTime;
            isAtLeastOneIsOpeningSoon = YES;
        }
        if (currentTime >= currBridgeInfo.closeTime - 30 && currentTime < currBridgeInfo.closeTime){
            //closing soon;
            closingSoonTime[closeSize] = currBridgeInfo.closeTime;
            closingSoon[closeSize++] = i;
        }
        if (currentTime >= currBridgeInfo.openTime && currentTime <= currBridgeInfo.closeTime){
            //Bridge is opened;
            openedNow[openedSize++] = i;
            atLeastOneIsOpened = YES;
        } else {
            //Bridge is closed;
            closedNow[closedSize++] = i;
            allBridgesAreOpened = NO;
            if (indexInNew[i] < 4){
                //bridge to VO
                closedBridgesToVO++;
            }
        }
        if (currBridgeInfo.isOpenedTwoTimes){
            if (currentTime >= currBridgeInfo.openTime2 - 30 && currentTime < currBridgeInfo.openTime2){
                //opening soon;
                openingSoon[openSize] = i;
                openingSoonTime[openSize++] = currBridgeInfo.openTime2;
            }
            if (currentTime >= currBridgeInfo.closeTime2 - 30 && currentTime < currBridgeInfo.closeTime2){
                //closing soon;
                closingSoonTime[closeSize] = currBridgeInfo.closeTime2;
                closingSoon[closeSize++] = i;
            }
            if (currentTime >= currBridgeInfo.openTime2 && currentTime <= currBridgeInfo.closeTime2){
                //Bridge is opened;
                openedNow[openedSize++] = i;
                closedSize--;
                atLeastOneIsOpened = YES;
                if (indexInNew[i] < 4){
                    //bridge to VO
                    closedBridgesToVO--;
                }
            }
            if (currentTime > currBridgeInfo.closeTime && currentTime < currBridgeInfo.openTime2){
                //Closed on a short time;
                shortClosed[shortSize++] = i;
                atLeastOneOnShortClose = YES;
                allBridgesAreOpened = NO;
            }
        }
        
    }
    noClosedBridgesToVO = (closedBridgesToVO == 0);
    allBridgesAreOpened = (openedSize == 9);
    
    
    //Sorting openingSoon and closingSoon relative to current user position

    CLLocation *loc = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
    //CLLocation *loc = [[CLLocation alloc] initWithLatitude:59.944443 longitude:30.295358];
    NSLog(@"Current location: %@",loc);
    
    if (loc.coordinate.longitude > 1e-5 && loc.coordinate.latitude > 1e-5){
    for(int i = 0; i < openSize; i++)
    {
        for(int j = 0; j < openSize - 1; j++)
        {
            int n1 = openingSoon[j];
            int n2 = openingSoon[j + 1];
            OneBridge *bridge1=[self.bridge.bridges objectForKey:[NSNumber numberWithInt:n1]];
            OneBridge *bridge2=[self.bridge.bridges objectForKey:[NSNumber numberWithInt:n2]];
            CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:bridge1.coord.x longitude:bridge1.coord.y ];
            CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:bridge2.coord.x longitude:bridge2.coord.y ];
            CLLocationDistance dist1 = [loc distanceFromLocation:loc1];
            CLLocationDistance dist2 = [loc distanceFromLocation:loc2];
            //NSLog(@"[Sort] n1 = %d n2 = %d", n1, n2);
           //NSLog(@"[Sort] Dist ot bridge %@ == %f, MYDIST = %f", bridge1.name, dist1, sqrtf((loc.coordinate.latitude - loc1.coordinate.latitude) * (loc.coordinate.latitude - loc1.coordinate.latitude)
           //       + (loc.coordinate.longitude - loc1.coordinate.longitude) * (loc.coordinate.longitude - loc1.coordinate.longitude)));
           // NSLog(@"[Sort] Dist ot bridge %@ == %f", bridge2.name, dist2);
            
            if(dist1>dist2)
            {
                int c = openingSoon[j];
                openingSoon[j] = openingSoon[j + 1];
                openingSoon[j + 1] = c;
                c = openingSoonTime[j];
                openingSoonTime[j] = openingSoonTime[j + 1];
                openingSoonTime[j + 1] = c;
                
            }
        }
    }
    for(int i = 0; i < closeSize; i++)
    {
        for(int j = 0; j < closeSize - 1; j++)
        {
            int n1 = closingSoon[j];
            int n2 = closingSoon[j + 1];
            OneBridge *bridge1=[self.bridge.bridges objectForKey:[NSNumber numberWithInt:n1]];
            OneBridge *bridge2=[self.bridge.bridges objectForKey:[NSNumber numberWithInt:n2]];
            CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:bridge1.coord.x longitude:bridge1.coord.y ];
            CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:bridge2.coord.x longitude:bridge2.coord.y ];
            CLLocationDistance dist1 = [loc distanceFromLocation:loc1];
            CLLocationDistance dist2 = [loc distanceFromLocation:loc2];
            
            if(dist1>dist2)
            {
                int c = closingSoon[j];
                closingSoon[j] = closingSoon[j + 1];
                closingSoon[j + 1] = c;
                c = closingSoonTime[j];
                closingSoonTime[j] = closingSoonTime[j + 1];
                closingSoonTime[j + 1] = c;
                
            }
        }
    }
    }
    
    
    if(currentTime < firstOpenTime - 30 || currentTime > lastOpenTime)
    {
        // NO INFO. ALL IS OK
        

        self.viewWithTimer.hidden=YES;
        self.beforeAfter.hidden=YES;
       // butForOpenTimers.hidden=YES;
        self.twoView.hidden=YES;
        self.twoLabelbefor.hidden=YES;
        
        NSArray* titleInfo=[NSArray arrayWithObjects:@"ВСЕ МОСТЫ",
                            @"СВЕДЕНЫ",
                            @"ХОРОШЕГО",
                            nil];
        NSString * new=[[titleInfo objectAtIndex:0] uppercaseString];
        self.firstLabelInfo.text=new;
        new=[[titleInfo objectAtIndex:1] uppercaseString];
        
        self.shakeLabel.text=[[titleInfo objectAtIndex:1]uppercaseString];
        new=[[titleInfo objectAtIndex:2] uppercaseString];
        
        self.lastLabelInfo.text=[[titleInfo objectAtIndex:2]uppercaseString];

        fourLabel.hidden=NO;
        
        CGRect frameLabels = self.viewWithLabels.frame;
        if (self.twoView.hidden){
            CGFloat height = self.viewWithTimer.frame.origin.y + self.viewWithTimer.frame.size.height;
            frameLabels.origin.y = (yMenuBot - self.scroller.frame.origin.y - height) / 2.0;
        } else {
            CGFloat height = self.twoView.frame.origin.y + self.twoView.frame.size.height;
            frameLabels.origin.y = (yMenuBot - self.scroller.frame.origin.y - height) / 2.0;
        }
        self.viewWithLabels.frame = frameLabels;
        
        
    }
    else
    {
        //deleting old labels;
        for (UIView *subview in [self.viewWithTimer subviews]) {
            if (subview.tag >0) {
                [subview removeFromSuperview];
            }
        }
        for (UIView *subview in [self.twoView subviews]) {
            if (subview.tag >0) {
                [subview removeFromSuperview];
            }
        }
        self.viewWithTimer.hidden = YES;
        self.beforeAfter.hidden = YES;
        self.firstMost.hidden = YES;
        self.twoLabelbefor.hidden = YES;
        self.twoLabel.hidden = YES;
        self.twoView.hidden = YES;
        
        //Putting info about openingSoon/closingSoon bridges to screen
        if (openSize > 0){
            self.viewWithTimer.hidden = NO;
            self.beforeAfter.hidden = NO;
            //there are openingSoon bridges
            if (self.scroller.frame.origin.y == 140){
                self.beforeAfter.text = @"СКОРО РАЗВЕДЕТСЯ";
            } else {
                if (openSize == 1){
                    self.beforeAfter.text = @"СКОРО РАЗВЕДЕТСЯ";
                }else{
                    self.beforeAfter.text = @"СКОРО РАЗВЕДУТСЯ";
                }
            }
            for (int i = 0; i < openSize; i++){
                
                
                UILabel* newLabel=[[UILabel alloc]initWithFrame:CGRectMake(6, 0+i*25, 221, 21)];
                NSString *timeStr;
                if (openingSoonTime[i] - currentTime < 5){
                    timeStr = [NSString stringWithFormat:@"%d минуты", openingSoonTime[i] - currentTime];
                } else {
                    timeStr = [NSString stringWithFormat:@"%d минут", openingSoonTime[i] - currentTime];
                }
                newLabel.text = [NSString stringWithFormat:@"%@: %@",
                                 ((OneBridge *)[self.bridge.bridges objectForKey:[NSNumber numberWithInt: openingSoon[i]]]).name,
                                 timeStr];
                
                //NSLog(@"Distance to %@ == %f", newLabel.text,
                 //     [loc distanceFromLocation:[[CLLocation alloc] initWithLatitude:((OneBridge *)[self.bridge.bridges objectForKey:[NSNumber numberWithInt: openingSoon[i]]]).coord.x longitude:((OneBridge *)[self.bridge.bridges objectForKey:[NSNumber numberWithInt: openingSoon[i]]]).coord.y ]]);
                
                
                newLabel.tag = i + 1;
                if (self.scroller.frame.origin.y == 60){
                    newLabel.alpha = 1;
                } else {
                    if (i == 0)
                        newLabel.alpha = 1;
                    else
                        newLabel.alpha = 0;
                }
                [newLabel setBackgroundColor:[UIColor clearColor]];
                [newLabel setFont: [UIFont fontWithName:@"Arial" size:11.0]];
                [newLabel setTextAlignment:NSTextAlignmentCenter];
                if (i == 0){
                    self.firstMost.text = newLabel.text;
                }
                [self.viewWithTimer addSubview:newLabel];
            }
            CGRect frame = self.viewWithTimer.frame;
            if (self.scroller.frame.origin.y == 60){
                frame.size.height = 25 * openSize;
            } else {
                frame.size.height = 25;
            }
            self.viewWithTimer.frame = frame;
            
           
        }
        if (openSize > 0 && closeSize > 0){
            //there are closingSoon bridges and openingSoon too;
            
            self.twoLabel.hidden = YES;
            self.twoView.hidden = NO;
            self.twoLabelbefor.hidden = NO;
            
            CGRect frame = self.twoLabelbefor.frame;
            frame.origin.y = self.viewWithTimer.frame.origin.y + self.viewWithTimer.frame.size.height + 2;
            self.twoLabelbefor.frame = frame;
            frame = self.twoView.frame;
            frame.origin.y = self.viewWithTimer.frame.origin.y + self.viewWithTimer.frame.size.height + 26;
            self.twoView.frame = frame;
            if (self.scroller.frame.origin.y == 140){
                self.twoLabelbefor.text = @"СКОРО СВЕДЕТСЯ";
            } else {
                if (closeSize == 1){
                    self.twoLabelbefor.text = @"СКОРО СВЕДЕТСЯ";
                }else{
                    self.twoLabelbefor.text = @"СКОРО СВЕДУТСЯ";
                }
            }
            for (int i = 0; i < closeSize; i++){
                
                
                UILabel* newLabel=[[UILabel alloc]initWithFrame:CGRectMake(6, 0+i*25, 221, 21)];
                NSString *timeStr;
                if (closingSoonTime[i] - currentTime < 5){
                    timeStr = [NSString stringWithFormat:@"%d минуты", closingSoonTime[i] - currentTime];
                } else {
                    timeStr = [NSString stringWithFormat:@"%d минут", closingSoonTime[i] - currentTime];
                }
                newLabel.text = [NSString stringWithFormat:@"%@: %@",
                                 ((OneBridge *)[self.bridge.bridges objectForKey:[NSNumber numberWithInt: closingSoon[i]]]).name,
                                 timeStr];
                
                //NSLog(@"Distance to %@ == %f", newLabel.text,
                //     [loc distanceFromLocation:[[CLLocation alloc] initWithLatitude:((OneBridge *)[self.bridge.bridges objectForKey:[NSNumber numberWithInt: openingSoon[i]]]).coord.x longitude:((OneBridge *)[self.bridge.bridges objectForKey:[NSNumber numberWithInt: openingSoon[i]]]).coord.y ]]);
                
                
                
                newLabel.tag = i + 1;
                if (self.scroller.frame.origin.y == 60){
                    newLabel.alpha = 1;
                } else {
                    if (i == 0)
                        newLabel.alpha = 1;
                    else
                        newLabel.alpha = 0;
                }
                [newLabel setBackgroundColor:[UIColor clearColor]];
                [newLabel setFont: [UIFont fontWithName:@"Arial" size:11.0]];
                [newLabel setTextAlignment:NSTextAlignmentCenter];
                if (i == 0){
                    self.twoLabel.text = newLabel.text;
                }
                [self.twoView addSubview:newLabel];
                
                
            }
            frame = self.twoView.frame;
            if (self.scroller.frame.origin.y == 60){
                frame.size.height = 25 * closeSize;
            } else {
                frame.size.height = 25;
            }
            self.twoView.frame = frame;
            
           
        }
        if (openSize == 0 && closeSize > 0){
            //there are closingSoon bridges and no openingSoon;
            self.viewWithTimer.hidden = NO;
            self.beforeAfter.hidden = NO;
            if (self.scroller.frame.origin.y == 140){
                self.beforeAfter.text = @"СКОРО СВЕДЕТСЯ";
            } else {
                if (closeSize == 1){
                    self.beforeAfter.text = @"СКОРО СВЕДЕТСЯ";
                }else{
                    self.beforeAfter.text = @"СКОРО СВЕДУТСЯ";
                }
            }
            for (int i = 0; i < closeSize; i++){
                
                
                UILabel* newLabel=[[UILabel alloc]initWithFrame:CGRectMake(6, 0+i*25, 221, 21)];
                NSString *timeStr;
                if (closingSoonTime[i] - currentTime < 5){
                    timeStr = [NSString stringWithFormat:@"%d минуты", closingSoonTime[i] - currentTime];
                } else {
                    timeStr = [NSString stringWithFormat:@"%d минут", closingSoonTime[i] - currentTime];
                }
                newLabel.text = [NSString stringWithFormat:@"%@: %@",
                                 ((OneBridge *)[self.bridge.bridges objectForKey:[NSNumber numberWithInt: closingSoon[i]]]).name,
                                 timeStr];
                
                //NSLog(@"Distance to %@ == %f", newLabel.text,
                //     [loc distanceFromLocation:[[CLLocation alloc] initWithLatitude:((OneBridge *)[self.bridge.bridges objectForKey:[NSNumber numberWithInt: openingSoon[i]]]).coord.x longitude:((OneBridge *)[self.bridge.bridges objectForKey:[NSNumber numberWithInt: openingSoon[i]]]).coord.y ]]);
                
                
                newLabel.tag = i + 1;
                if (self.scroller.frame.origin.y == 60){
                    newLabel.alpha = 1;
                } else {
                    if (i == 0)
                        newLabel.alpha = 1;
                    else
                        newLabel.alpha = 0;
                }
                [newLabel setBackgroundColor:[UIColor clearColor]];
                [newLabel setFont: [UIFont fontWithName:@"Arial" size:11.0]];
                [newLabel setTextAlignment:NSTextAlignmentCenter];
                if (i == 0){
                    self.firstMost.text = newLabel.text;
                }
                [self.viewWithTimer addSubview:newLabel];
                
                
            }
            CGRect frame = self.viewWithTimer.frame;
            if (self.scroller.frame.origin.y == 60){
                frame.size.height = 25 * closeSize;
            } else {
                frame.size.height = 25;
            }
            self.viewWithTimer.frame = frame;
            
         
            
        }
        
        
        if (openSize == 0 && closeSize == 0){
            //nothing to show
            self.beforeAfter.hidden = YES;
            self.viewWithTimer.hidden = YES;
            self.firstMost.hidden = YES;
            self.twoLabel.hidden = YES;
            self.twoView.hidden = YES;
            self.twoLabelbefor.hidden = YES;
        }
        
        //центруем viewWithLabels;
        CGRect frameLabels = self.viewWithLabels.frame;
        if (self.twoView.hidden){
            CGFloat height = self.viewWithTimer.frame.origin.y + self.viewWithTimer.frame.size.height;
            frameLabels.origin.y = (yMenuBot - self.scroller.frame.origin.y - height) / 2.0;
        } else {
            CGFloat height = self.twoView.frame.origin.y + self.twoView.frame.size.height;
            frameLabels.origin.y = (yMenuBot - self.scroller.frame.origin.y - height) / 2.0;
        }
        self.viewWithLabels.frame = frameLabels;
        
        if (allBridgesAreOpened){
            //все мосты разведены
            
            NSArray* titleInfo=[NSArray arrayWithObjects:@"РОМАНТИКА",
                                @"БЕЛЫХ НОЧЕЙ",
                                @"ВО ВСЕЙ КРАСЕ",
                                nil];
            NSString * new=[[titleInfo objectAtIndex:0] uppercaseString];
            self.firstLabelInfo.text=new;
            new=[[titleInfo objectAtIndex:1] uppercaseString];
            
            self.shakeLabel.text=[[titleInfo objectAtIndex:1]uppercaseString];
            new=[[titleInfo objectAtIndex:2] uppercaseString];
            
            self.lastLabelInfo.text=[[titleInfo objectAtIndex:2]uppercaseString];
            
            fourLabel.hidden=YES;
            
            
            
            return;
        }
        if (atLeastOneOnShortClose){
            //Есть короткая сводка
            
            NSArray* titleInfo=[NSArray arrayWithObjects:@"ВРЕМЯ",
                                @"КОРОТКОЙ",
                                @"СВОДКИ",
                                nil];
            NSString * new=[[titleInfo objectAtIndex:0] uppercaseString];
            self.firstLabelInfo.text=new;
            new=[[titleInfo objectAtIndex:1] uppercaseString];
            
            self.shakeLabel.text=[[titleInfo objectAtIndex:1]uppercaseString];
            new=[[titleInfo objectAtIndex:2] uppercaseString];
            
            self.lastLabelInfo.text=[[titleInfo objectAtIndex:2]uppercaseString];
            
            fourLabel.hidden=YES;
            
            return;
        }
        
        if (noClosedBridgesToVO){
            //На Ваську не проехать
            
            NSArray* titleInfo=[NSArray arrayWithObjects:@"ЧАС РОМАНТИКИ",
                                @"НА ВАСИЛЬЕВСКОМ",
                                @"ОСТРОВЕ",
                                nil];
            NSString * new=[[titleInfo objectAtIndex:0] uppercaseString];
            self.firstLabelInfo.text=new;
            new=[[titleInfo objectAtIndex:1] uppercaseString];
            
            self.shakeLabel.text=[[titleInfo objectAtIndex:1]uppercaseString];
            new=[[titleInfo objectAtIndex:2] uppercaseString];
            
            self.lastLabelInfo.text=[[titleInfo objectAtIndex:2]uppercaseString];
            
            fourLabel.hidden=YES;
            
            return;
        }
        if (atLeastOneIsOpened){
            //хотя бы один разведен
            
            NSArray* titleInfo=[NSArray arrayWithObjects:@"НЕКОТОРЫЕ",
                                @"МОСТЫ УЖЕ",
                                @"РАЗВЕДЕНЫ",
                                nil];
            NSString * new=[[titleInfo objectAtIndex:0] uppercaseString];
            self.firstLabelInfo.text=new;
            new=[[titleInfo objectAtIndex:1] uppercaseString];
            
            self.shakeLabel.text=[[titleInfo objectAtIndex:1]uppercaseString];
            new=[[titleInfo objectAtIndex:2] uppercaseString];
            
            self.lastLabelInfo.text=[[titleInfo objectAtIndex:2]uppercaseString];
            
            fourLabel.hidden=YES;
            return;
        }
        if (isAtLeastOneIsOpeningSoon){
            //Какой-то скоро разведется
            
            NSArray* titleInfo=[NSArray arrayWithObjects:@"ПРИШЛО ВРЕМЯ",
                                @"СПЛАНИРОВАТЬ",
                                @"ВАШ МАРШРУТ",
                                nil];
            NSString * new=[[titleInfo objectAtIndex:0] uppercaseString];
            self.firstLabelInfo.text=new;
            new=[[titleInfo objectAtIndex:1] uppercaseString];
            
            self.shakeLabel.text=[[titleInfo objectAtIndex:1]uppercaseString];
            new=[[titleInfo objectAtIndex:2] uppercaseString];
            
            self.lastLabelInfo.text=[[titleInfo objectAtIndex:2]uppercaseString];
            
            fourLabel.hidden=YES;
            
            return;
        }
        
       
    }
    
}

-(void)openTimers
{
    [self hideBridge:nil];
}

-(void)addLabel
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    int count;
    if(self.twoView.hidden==NO)
    {
        count=[mostWithTimer count]-1;
    }
    else
    {
        count=[mostWithTimer count];
    }
    for(int i=1;i<count;i++)
    {
        
        UILabel * but=[self.viewWithTimer.subviews objectAtIndex:i];
        but.alpha=1;
    }
    
    [UIView commitAnimations];
}

-(void)menuHide
{

    menuButton.hidden=NO;

    myTimer2=[NSTimer scheduledTimerWithTimeInterval:0.5
                                              target:self
                                            selector:@selector(showInfo)
                                            userInfo:nil
                                             repeats:YES];
}


-(void)showInfo
{

    NSInteger index;
    switch(indexForInfo) {
        case 2:
            //do something;
            index=8;
            break;
        case 3:
            // do something else;
            index=7;
            break;
        case 4:
            //do something;
            index=2;
            break;
        case 5:
            // do something else;
            index=3;
            break;
        case 6:
            //do something;
            index=4;
            break;
        case 7:
            // do something else;
            index=5;
            break;
        case 8:
            //do something;
            index=6;
            break;
        default:
            index=indexForInfo;
            
            // do something by default;
    }
    [bridge Information:index];
    indexForInfo++;
    if ([myTimer2 isValid]&& indexForInfo>9) {
        [myTimer2 invalidate];
        [self.bridge Information:-1];
    }
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

//рандомный цвет для шейкЛейбла
- (UIColor *) randomColor {
    CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}



-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    // событие произошло
    // проверим что это событие движения встряхивания
    if (event.subtype == UIEventSubtypeMotionShake) {
        shakeLabel.textColor=[self randomColor];
        //shakeLabel.textAlignment=NSTextAlignmentCenter;
        fourLabel.textColor=[self randomColor];
        [self refTimer];

    }
    [self.bridge refreshLoad:YES];
}


-(void)hideBridge:(id)sender//спрятать вид с иконками мостов
{

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    CGRect frameLabels=viewWithLabels.frame;
    CGRect frame=scroller.frame;
    if(frame.origin.y!=60)
    {
        
        frame.origin.y=60;
        scroller.frame=frame;
        NSLog(@"viewWithLabels.frame hideBride; before else");
        //open viewWithTimer and twoView
        
        
        
        
        //changing viewWithTimer and twoView sizes;
        frame = self.viewWithTimer.frame;
        if (openSize > 0){
            frame.size.height = 25 * openSize;
            if (openSize == 1){
                self.beforeAfter.text = @"СКОРО РАЗВЕДЕТСЯ";
            }else{
                self.beforeAfter.text = @"СКОРО РАЗВЕДУТСЯ";
            }
        }else {
            if (closeSize == 1){
                self.beforeAfter.text = @"СКОРО СВЕДЕТСЯ";
            }else{
                self.beforeAfter.text = @"СКОРО СВЕДУТСЯ";
            }
            if (closeSize > 0) {
                frame.size.height = 25 * closeSize;
            } else {
                frame.size.height = 0;
            }
        }
        self.viewWithTimer.frame = frame;
    
        
        
        
        //changing origins;
        if (openSize > 0 && closeSize > 0){
            //there are closingSoon bridges and openingSoon too;
            if (closeSize == 1){
                self.twoLabelbefor.text = @"СКОРО СВЕДЕТСЯ";
            }else{
                self.twoLabelbefor.text = @"СКОРО СВЕДУТСЯ";
            }
            
            self.twoLabel.hidden = YES;
            self.twoView.hidden = NO;
            self.twoLabelbefor.hidden = NO;
            
            frame = self.twoLabelbefor.frame;
            frame.origin.y = self.viewWithTimer.frame.origin.y + self.viewWithTimer.frame.size.height + 2;
            self.twoLabelbefor.frame = frame;
            frame = self.twoView.frame;
        }
        
        frame = self.twoView.frame;
        if (closeSize > 0)
            frame.size.height = 25 * closeSize;
        else
            frame.size.height = 0;

        if (openSize > 0 && closeSize > 0){
            frame.origin.y = self.viewWithTimer.frame.origin.y + self.viewWithTimer.frame.size.height + 26;
        }
        self.twoView.frame = frame;
        
        //make text visible
        for (UIView *subview in [self.viewWithTimer subviews]) {
            if (subview.tag >0) {
                subview.alpha = 1;
            }
        }
        for (UIView *subview in [self.twoView subviews]) {
            if (subview.tag >0) {
                subview.alpha = 1;
            }
        }
        
        
        if (self.twoView.hidden){
            CGFloat height = self.viewWithTimer.frame.origin.y + self.viewWithTimer.frame.size.height;
            frameLabels.origin.y = (yMenuBot - 60 - height) / 2.0;
        } else {
            CGFloat height = self.twoView.frame.origin.y + self.twoView.frame.size.height;
            frameLabels.origin.y = (yMenuBot - 60 - height) / 2.0;
        }
        viewWithLabels.frame=frameLabels;
        
        
        
        [UIView commitAnimations];
        rightImage.image=[UIImage imageNamed:@"butClose.png"];
    }
    else
    {
        
        
        //frameLabels.origin.y= -30;
        /*
        if([mostWithTimer count]==0)
        {
            frameLabels.origin.y+=newBot/2;
            if (newBot==0) {
                frameLabels.origin.y+=20;
            }
        }
         */
        
        frame.origin.y=140;
        scroller.frame=frame;
        
        
        //changing viewWithTimer and twoView sizes;
        frame = self.viewWithTimer.frame;
        if (openSize > 0){
            frame.size.height = 25;
            
                self.beforeAfter.text = @"СКОРО РАЗВЕДЕТСЯ";
            
             
        }else {
            
                self.beforeAfter.text = @"СКОРО СВЕДЕТСЯ";
            
            if (closeSize > 0) {
                frame.size.height = 25;
            } else{
                frame.size.height = 0;
            }
        }
        self.viewWithTimer.frame = frame;
        
        
        
        //changing origins;
        if (openSize > 0 && closeSize > 0){
            //there are closingSoon bridges and openingSoon too;
            
            self.twoLabelbefor.text = @"СКОРО СВЕДЕТСЯ";
            
            self.twoLabel.hidden = YES;
            self.twoView.hidden = NO;
            self.twoLabelbefor.hidden = NO;
            
            frame = self.twoLabelbefor.frame;
            frame.origin.y = self.viewWithTimer.frame.origin.y + self.viewWithTimer.frame.size.height + 2;
            self.twoLabelbefor.frame = frame;
        }
        
        frame = self.twoView.frame;
        if (closeSize > 0)
            frame.size.height = 25;
        else
            frame.size.height = 0;
        if (openSize > 0 && closeSize > 0){
            frame.origin.y = self.viewWithTimer.frame.origin.y + self.viewWithTimer.frame.size.height + 26;
        }
        self.twoView.frame = frame;
        
        //make text invisible
        for (UIView *subview in [self.viewWithTimer subviews]) {
            if (subview.tag >1) {
                subview.alpha = 0;
            }
        }
        for (UIView *subview in [self.twoView subviews]) {
            if (subview.tag >1) {
                subview.alpha = 0;
            }
        }
        
        if (self.twoView.hidden){
            CGFloat height = self.viewWithTimer.frame.origin.y + self.viewWithTimer.frame.size.height;
            frameLabels.origin.y = (yMenuBot - 140 - height) / 2.0;
        } else {
            CGFloat height = self.twoView.frame.origin.y + self.twoView.frame.size.height;
            frameLabels.origin.y = (yMenuBot - 140 - height) / 2.0;
        }
        NSLog(@"viewWithLabels.frame hideBride; else");
        viewWithLabels.frame=frameLabels;
        [UIView commitAnimations];
        rightImage.image=[UIImage imageNamed:@"butOpen.png"];
    }
    
    [self.bridge refreshLoad:YES];
    
    
}


//
-(void)goGraphic:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.75f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    MoreInfoViewController *IpModal=[self.storyboard instantiateViewControllerWithIdentifier:@"graph"];
    IpModal.yMenu=460;
    [self.navigationController pushViewController:IpModal animated:YES];

}

-(void)leftMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPnt = [touch locationInView:self.view];
    NSInteger index=[self.bridge findBridge:touchPnt];
    if(index>=0)
    {
        self.slidingViewController.panGesture.enabled=NO;
    }
    else
    {
        self.slidingViewController.panGesture.enabled=YES;
    }
    [self.bridge Information:index];

}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPnt = [touch locationInView:self.view];
    NSInteger index=[self.bridge findBridge:touchPnt];
    if(index>=0)
    {
        self.slidingViewController.panGesture.enabled=NO;
    }
    else
    {
        self.slidingViewController.panGesture.enabled=YES;
    }
    [self.bridge Information:index];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPnt = [touch locationInView:self.view];
    [self.bridge Information:-1];
    NSInteger index=[self.bridge findBridge:touchPnt];
    if (index>=0) {
        self.allIndex=index;
        [self performSegueWithIdentifier:@"goBridge" sender:self];
            self.slidingViewController.panGesture.enabled=NO;
    }
    else
    {
            self.slidingViewController.panGesture.enabled=YES;
    }

}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqual:@"goBridge"])
    {
    BRBridgeViewController *detailController =segue.destinationViewController;
    detailController.bridge=[self.bridge.bridges objectForKey:[NSNumber numberWithInt:allIndex]];
    }
    else{
        if([segue.identifier isEqual:@"goMap"])
        {
        BRMAPViewController *detailController = segue.destinationViewController;
            detailController.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
            detailController.bridges=self.bridge;}
        else
        {
            MoreInfoViewController *detail = segue.destinationViewController;
            detail.modalPresentationStyle=UIModalPresentationPageSheet;
            detail.yMenu=460;
        }
    }
    
}

-(void)goHome
{
    [bridge refreshLoad:YES];
    
}

-(void)updateStuff
{   
    [self refTimer];
    [bridge refreshLoad:YES];
        
}

-(void)goToPush
{
    InitSlViewController * pushView=[self.storyboard instantiateViewControllerWithIdentifier:@"InitSlider"];
    pushView.controller=@"PUSHTop";
    [self.navigationController pushViewController:pushView animated:YES];
}



- (BOOL)shouldAutorotate {

    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {

    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
