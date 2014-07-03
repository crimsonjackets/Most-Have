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


@interface BRViewController ()
{   UIImageView * rightImage;
    UIImageView * leftImage;
    UIButton * butLeftMenu;
    NSTimer *myTimer;
    UIButton * menuButton;
    NSTimer *myTimer2;
    int indexForInfo;
    NSArray *rangeForInfo;
    NSArray* mostWithTimer;
    NSTimer *myTimerForTimer;
    CGFloat yMenuBot;
    UIButton *butForOpenTimers;
    NSInteger newBot;
    UILabel* fourLabel;
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


    indexForInfo=0;


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
        frameLabels.origin.y+=75;
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
    
    
    fourLabel=[[UILabel alloc]initWithFrame:CGRectMake(18, 161, 285, 45)];

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
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger index=[self.bridge beforeAfterwithCalendar:calendar];
    

    
    
    if(index<0)
    {
        CGRect frameLabels=viewWithLabels.frame;

        self.viewWithTimer.hidden=YES;
        self.beforeAfter.hidden=YES;
       // butForOpenTimers.hidden=YES;
        self.twoView.hidden=YES;
        self.twoLabelbefor.hidden=YES;
        frameLabels=self.viewWithLabels.frame;
       // frameLabels.origin.y+=newBot/2;
        if (newBot==0) {
            //frameLabels.origin.y+=20;
        }
        self.viewWithLabels.frame=frameLabels;
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
    }
    else
    {
        fourLabel.hidden=YES;
            NSArray* titleInfo=[self.bridge getInfoTitlewithCalendar:calendar];
            NSString * new=[[titleInfo objectAtIndex:0] uppercaseString];
            self.firstLabelInfo.text=new;
            if([new length]>11)
            {
                self.firstLabelInfo.font=[UIFont boldSystemFontOfSize:36-[new length]/1.3];
            }
            new=[[titleInfo objectAtIndex:1] uppercaseString];
            self.shakeLabel.text=[[titleInfo objectAtIndex:1]uppercaseString];
            if([new length]>10)
            {
                self.shakeLabel.font=[UIFont boldSystemFontOfSize:36-[new length]/1.3];
            }
            new=[[titleInfo objectAtIndex:2] uppercaseString];
            self.lastLabelInfo.text=[[titleInfo objectAtIndex:2]uppercaseString];
            if([new length]>11)
            {
                self.lastLabelInfo.font=[UIFont boldSystemFontOfSize:36-[new length]/1.3];
            }
           // butForOpenTimers.hidden=NO;
                self.viewWithTimer.hidden=NO;
                self.beforeAfter.hidden=NO;

            mostWithTimer=[self.bridge getListOfMostwithCalendar:calendar];
            self.firstMost.text=[NSString stringWithFormat:@"%@", [mostWithTimer objectAtIndex:0]];
        
            if (index==9)
            {
                self.beforeAfter.text=@"ВРЕМЯ ДО СВОДКИ БЛИЖАЙШЕГО МОСТА:";
                self.twoView.hidden=NO;
                self.twoLabelbefor.hidden=NO;
  
                for(int i=1;i<[mostWithTimer count];i++)
                {
                    
                    UILabel* newLabel=[[UILabel alloc]initWithFrame:CGRectMake(6, 6+i*25, 221, 21)];
                    newLabel.text=[mostWithTimer objectAtIndex:i];
                    newLabel.tag=i;
                    newLabel.alpha=0;
                    [newLabel setBackgroundColor:[UIColor clearColor]];
                    [newLabel setFont: [UIFont fontWithName:@"Arial" size:11.0]];
                    [newLabel setTextAlignment:NSTextAlignmentCenter];
                    if([newLabel.text hasPrefix:@"МОСТ А. НЕВСКОГО"])
                        self.twoLabel.text=newLabel.text;
                    else
                        [self.viewWithTimer addSubview:newLabel];
                }

            }
            else
            {
                self.twoView.hidden=YES;
                self.twoLabelbefor.hidden=YES;

                if(index==10||index==13||index>=15)
                    self.beforeAfter.text=@"ВРЕМЯ ДО СВОДКИ БЛИЖАЙШЕГО МОСТА:";
                else
                    self.beforeAfter.text=@"ВРЕМЯ ДО РАЗВОДКИ БЛИЖАЙШЕГО МОСТА:";


                
                
                for (UIView *subview in [self.viewWithTimer subviews]) {
                    if (subview.tag >0) {
                        [subview removeFromSuperview];
                    }
            }

            for(int i=1;i<[mostWithTimer count];i++)
            {
               // NSLog(@" %@",[mostWithTimer objectAtIndex:i]);
                UILabel* newLabel=[[UILabel alloc]initWithFrame:CGRectMake(6, 6+i*25, 221, 21)];
                newLabel.text=[mostWithTimer objectAtIndex:i];
                newLabel.tag=i;
                newLabel.alpha=0;
                [newLabel setBackgroundColor:[UIColor clearColor]];
                [newLabel setFont: [UIFont fontWithName:@"Arial" size:11.0]];
                [newLabel setTextAlignment:NSTextAlignmentCenter];
                [self.viewWithTimer addSubview:newLabel];
            }
            }
        if(self.viewWithTimer.frame.size.height>25)
            [self addLabel];
    }
    
}

-(void)openTimers
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [self refTimer];

    NSInteger index=[self.bridge beforeAfterwithCalendar:calendar];
    if(index>-1)
    {
    CGRect frame=self.viewWithTimer.frame;
    CGRect frameFirst=self.firstMost.frame;
    CGRect twoFrame=self.twoView.frame;
    CGRect twoLabFrame=self.twoLabelbefor.frame;
    
    if (frame.size.height==25) {
        
        for(int i=1;i<[mostWithTimer count];i++)
        {
            frame.size.height+=25;
            
        }
        if([mostWithTimer count]>1)
        {
            frame.size.height+=10;
            frameFirst.origin.y+=5;
        }
        if (index==9)
        {
            frame.size.height-=25;
            twoFrame.origin.y+=35;
           // 
            twoLabFrame.origin.y+=35;
        }
        myTimerForTimer = [NSTimer scheduledTimerWithTimeInterval:0.4
                                                           target:self
                                                         selector:@selector(addLabel)
                                                         userInfo:nil
                                                          repeats:NO];
        if(index==10||index==13||index>=15||index==9)
        {
            self.beforeAfter.text=@"ВРЕМЯ ДО СВОДКИ МОСТОВ:";
        }
        else
        {
            if([mostWithTimer count]>1)
                self.beforeAfter.text=@"ВРЕМЯ ДО РАЗВОДКИ МОСТОВ:";
        }
       // frameView.origin.y-=10;
    }
    else
    {
        if([mostWithTimer count]>1)
        {
            frameFirst.origin.y-=5;
        }
        
        if (index==9)
        {
            twoFrame.origin.y-=35;
            twoLabFrame.origin.y-=35;
        }
        for(int i=1;i<[mostWithTimer count];i++)
        {
            
            UILabel * but=[self.viewWithTimer.subviews objectAtIndex:i];
            but.alpha=0;
        }
        frame.size.height=25;
    //    frameView.origin.y+=10;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
        self.viewWithTimer.frame=frame;
      //  self.viewWithLabels.frame=frameView;
        self.firstMost.frame=frameFirst;
        self.twoView.frame=twoFrame;
        self.twoLabelbefor.frame=twoLabFrame;
    [UIView commitAnimations];
        

    [self hideBridge:nil];
    }
    else
    {
        [self refTimer];
    }
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
        
        frameLabels.origin.y-=(self.viewWithTimer.frame.size.height-25-80)/2;
        frame.origin.y=60;
        scroller.frame=frame;
        viewWithLabels.frame=frameLabels;
        [UIView commitAnimations];
        rightImage.image=[UIImage imageNamed:@"butClose.png"];
    }
    else
    {
        
        
        frameLabels.origin.y=(yMenuBot-419)/2;
        
        if([mostWithTimer count]==0)
        {
            frameLabels.origin.y+=newBot/2;
            if (newBot==0) {
                frameLabels.origin.y+=20;
            }
        }
        
        frame.origin.y=140;
        scroller.frame=frame;
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
