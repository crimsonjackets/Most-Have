//
//  MoreInfoViewController.m
//  BridgeSPB
//
//  Created by Stas on 28.03.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//



#import "MoreInfoViewController.h"
#import "InitSlViewController.h"
#import "MHBridgeTableViewCell.h"
#import "MHBridgeTimeLineView.h"
#import "MHTimeLine.h"
#import "MHBridgeInfo.h"

@interface MoreInfoViewController ()
{   UIImageView * rightImage;
    UIImageView * leftImage;
    UIButton * butLeftMenu;
    BRMAPViewController *mapv;
    float yMenuBot;
    NSTimer * myTimer;
    NSTimer * myTimer2;
    NSInteger diffCont;
    NSInteger sizeHeigth;
    BOOL panning;
    
    CGFloat currentTime;
    
    
}

@property NSArray *bridges;
@end

@implementation MoreInfoViewController

@synthesize scroller;
@synthesize bridge;
@synthesize grafic; //tableView
@synthesize menu;
@synthesize button;
@synthesize yMenu;
@synthesize laftBut;

@synthesize bridges;


-(void)viewDidAppear:(BOOL)animated
{
    myTimer=[NSTimer scheduledTimerWithTimeInterval:30
                                             target:self
                                           selector:@selector(updateProgress)
                                           userInfo:nil
                                            repeats:YES];
    [self.bridge refreshLoad:YES];
}


- (void) performInitializations
{
    //currentTime = 91.0f;//minutes;
    [self updateProgress];
    [self updateBridges];
}

- (void) updateProgress
{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components =
    [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:today];
    currentTime = [components hour] * 60 + [components minute];
    NSLog(@"CurrentTime == %f", currentTime);
    [self.grafic reloadData];
    
}



- (void) updateBridges{
    NSLog(@"Starting updating bridges");
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"bridgesInfo"];
    self.bridges = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self.grafic performSelectorOnMainThread:@selector(reloadData)
                                     withObject:nil
                                  waitUntilDone:NO];
    [self.bridge refreshLoad:YES];
    NSLog(@"Bridges Updated");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewWithHelp.hidden=YES;
    self.abbrView.hidden=YES;

    [self performInitializations];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBridges) name:@"updateBridgesInfo" object:nil];
    
    if(([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)&&([UIScreen mainScreen].bounds.size.height == 568.0))
    {
        yMenuBot=91;
        sizeHeigth=854;
        diffCont=854-678;
    }
    else
    {
        sizeHeigth=678;
        yMenuBot=0;
        diffCont=0;
    }
    [self addAbbriature];
    [self.view insertSubview:self.viewWithHelp aboveSubview:scroller];

    
    button.layer.cornerRadius=5;
    laftBut.layer.cornerRadius=5;
    button.layer.borderColor=[[UIColor blackColor] CGColor];
    button.layer.borderWidth=2;
    laftBut.layer.borderColor=[[UIColor blackColor] CGColor];
    laftBut.layer.borderWidth=2;
    mapv=[self.storyboard instantiateViewControllerWithIdentifier:@"map"];
    
    
	// Do any additional setup after loading the view.
    [self becomeFirstResponder];
    
    CGRect frame=self.menu.frame;
    frame.origin.y=self.yMenu+yMenuBot - 40;
    self.menu.frame=frame;
    
    frame=self.viewWithHelp.frame;
    frame.origin.y+=yMenuBot;
    self.viewWithHelp.frame=frame;
    
    self.navigationController.navigationBar.hidden=YES;
    //scroller.contentSize=CGSizeMake(960+diffCont, 300);
//    UIPanGestureRecognizer *swipeUp = [[UIPanGestureRecognizer alloc]
//                                         initWithTarget:self
//                                         action:@selector(openMenu:)];
//   // swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
//    [self.view addGestureRecognizer:swipeUp];
//    UIPanGestureRecognizer *swipeDown = [[UIPanGestureRecognizer alloc]
//                                           initWithTarget:self
//                                           action:@selector(openMenu:)];
//  //  swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
//    [self.view addGestureRecognizer:swipeDown];
    //UIPanGestureRecognizer *swipeUp1 = [[UIPanGestureRecognizer alloc]
    //                                     initWithTarget:self
    //                                     action:@selector(openMenu:)];
  //  swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    //[self.view addGestureRecognizer:swipeUp1];

    [self.view insertSubview:menu aboveSubview:scroller];

  //  NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    //UIImage *graphIm= [NSKeyedUnarchiver unarchiveObjectWithFile:[BRAppHelpers archivePathForGraphics]];

    
    self.grafic.dataSource = self;
    self.grafic.delegate = self;
    //Table footer
    CGRect titleRect = CGRectMake(10, 0, 310, 50);
    UILabel *tableFooter = [[UILabel alloc] initWithFrame:titleRect];
    tableFooter.textColor = [UIColor grayColor];
    tableFooter.backgroundColor = [self.grafic backgroundColor];
    tableFooter.opaque = YES;
    tableFooter.font = [UIFont boldSystemFontOfSize:11];
    tableFooter.text = @"Разводка Сампсониевского, Гренадерского, Кантемировского мостов производится с 1.30 ч. до 4.30 ч. по предварительной заявке за 2 суток.";
    tableFooter.lineBreakMode = NSLineBreakByWordWrapping;
    tableFooter.numberOfLines = 4;
    self.grafic.tableFooterView = tableFooter;
    [self.grafic reloadData];
    
 //   NSLog(@"%@",self.grafic.image);
    
    frame=grafic.frame;
    frame.size.height+=yMenuBot- 70;
    frame.size.width=320;
    grafic.frame=frame;

    
    frame=scroller.frame;
    frame.size.height=500;
    scroller.frame=frame;

    self.bridge=[Bridge initWithView:self.view belowBiew:scroller];
    
    //инициализация шапки
    
    leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 40, 30)];
    rightImage=[[UIImageView alloc]initWithFrame:CGRectMake(260, 30, 35, 5)];
    NSArray *imageLeftRight=[NSArray arrayWithObjects:rightImage,leftImage, nil];
    self.view=[BRAppHelpers addHeadonView:self.view andImages:imageLeftRight withTarget:self];
    leftImage.image=[UIImage imageNamed:@"Back.png"];
    rightImage.image=[UIImage imageNamed:@"butClose.png"];
    
    [self.view insertSubview:self.abbrView aboveSubview:scroller];
    
    [self.bridge refreshLoad:NO];
    
}

-(void)addAbbriature
{
    float diff=0;
    float hei=0;
    float start=0;
    if (yMenuBot==0)
    {
        hei=30;
        diff=22.4;
        start=19;
    }
    else
    {
        start=22.5;
        hei=40;
        diff=28.2;
    }
    
    NSArray *abbr=[NSArray arrayWithObjects:@"ЛШ",
                                        @"ТУ",
                   @"БЖ",
                   @"ТР",
                   @"ЛИ",
                   @"БО",
                   @"АН",
                   @"ВД",
                   @"ФН",
                   @"СН",
                   @"КТ",
                   @"ГД",
                   @"ДВ",
                   @"ВН",
                   nil];
    
    for(int i=0;i<14;i++)
    {
        UILabel * new=[[UILabel alloc]initWithFrame:CGRectMake(2,start+diff*i, 30, hei)];
        [new setBackgroundColor:[UIColor clearColor]];
        new.text=[abbr objectAtIndex:i];
        [self.abbrView addSubview:new];
    }
}

-(void)menuShowing
{
    if ([myTimer isValid]&& menu.frame.origin.y==403+yMenuBot) {
        [myTimer invalidate];
    }
    if(menu.frame.origin.y>440+yMenuBot)
    {

    CGRect frame=self.menu.frame;
    frame.origin.y=460+yMenuBot-20;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    self.menu.frame=frame;
    [UIView commitAnimations];
    myTimer2=[NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(menuShowing2)
                                           userInfo:nil
                                            repeats:NO];
    }
    }
    
-(void)menuShowing2
{
    if(![myTimer isValid])
        [myTimer2 invalidate];
    CGRect frame=self.menu.frame;
    frame.origin.y=460+yMenuBot+20;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    self.menu.frame=frame;
    [UIView commitAnimations];
}

-(void)openMenu:(UIPanGestureRecognizer*)swipe
{
    
    CGPoint v =[swipe velocityInView:grafic];
    
  //  NSLog(@"%f, %f",v.x,v.y);
    
    if(swipe.state == UIGestureRecognizerStateBegan) panning = NO;
    CGRect frame=self.menu.frame;
    
    if( (abs(v.y) >= 50) && !panning)
    {
        //    swipe.enabled=YES;
            panning = YES;
        [swipe cancelsTouchesInView];
        
        if(v.y>0&&frame.origin.y!=460+yMenuBot)
        {
            

            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1];
            
            frame.origin.y=460+yMenuBot;
            self.menu.frame=frame;

            [UIView commitAnimations];
        }
        else {
                NSLog(@"%f, %f",v.x,v.y);
            if ([myTimer2 isValid])
                [myTimer2 invalidate];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1];
            frame.origin.y=403+yMenuBot;
            self.menu.frame=frame;
;

            [UIView commitAnimations];
        };
    }
//    else
//    {
//        swipe.enabled=NO;
//    }
    

//    if(frame.origin.y!=460+yMenuBot && swipe.direction == UISwipeGestureRecognizerDirectionDown)
//    {
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:1];
//        
//        frame.origin.y=460+yMenuBot;
//        self.menu.frame=frame;
//        frameHelp.origin.y-=16+yMenuBot;
//        self.viewWithHelp.frame=frameHelp;
//        self.viewWithHelp.alpha=0.6;
//        [UIView commitAnimations];
//    }
//    else if(swipe.direction == UISwipeGestureRecognizerDirectionUp)
//    {
//        if ([myTimer2 isValid])
//            [myTimer2 invalidate];
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:1];
//        frame.origin.y=403+yMenuBot;
//        self.menu.frame=frame;
//        frameHelp.origin.y+=16+yMenuBot;
//        self.viewWithHelp.frame=frameHelp;
//        self.viewWithHelp.alpha=0;
//        [UIView commitAnimations];
//    }

}



-(void)hideBridge:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    CGRect frameAbbr=self.abbrView.frame;
    CGRect frame=scroller.frame;
    if(frame.origin.y!=60)
    {
        
        
        frame.origin.y=60;
        frame.size.height+=80;
        frameAbbr.origin.y=60;
        scroller.frame=frame;
        self.abbrView.frame=frameAbbr;
        [UIView commitAnimations];
        rightImage.image=[UIImage imageNamed:@"butClose.png"];
        
    }
    else
    {
        
        
        frame.origin.y=140;
        frame.size.height-=80;
        scroller.frame=frame;
        frameAbbr.origin.y=140;
        scroller.frame=frame;
        self.abbrView.frame=frameAbbr;
        [UIView commitAnimations];
        rightImage.image=[UIImage imageNamed:@"butOpen.png"];
        
        
    }
    
        [self.bridge refreshLoad:NO];
    
}
-(void)leftMenu:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.75f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goMap:(id)sender {
    
    mapv.bridges=self.bridge;
    [self.navigationController pushViewController:mapv animated:NO];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPnt1 = [touch locationInView:self.scroller];
    //NSInteger index=[self.bridge findBridge:touchPnt];
    NSLog(@"Touch down%f",touchPnt1.y);
    CGPoint touchPnt = [touch locationInView:self.view];
    NSLog(@"Touch down%f",touchPnt.y);
    NSInteger index=[self.bridge findBridge:touchPnt];
    [self.bridge Information:index];

}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    

    UITouch *touch = [touches anyObject];
    CGPoint touchPnt1 = [touch locationInView:scroller];
    //NSInteger index=[self.bridge findBridge:touchPnt];
    NSLog(@"Touch down%f",touchPnt1.y);
    CGPoint touchPnt = [touch locationInView:self.view];
    NSInteger index=[self.bridge findBridge:touchPnt];
    NSLog(@"Touch down%f",touchPnt.y);
    [self.bridge Information:index];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPnt = [touch locationInView:self.view];
    [self.bridge Information:-1];
    NSInteger index=[self.bridge findBridge:touchPnt];
    if (index>=0) {
        BRBridgeViewController *back=[self.storyboard instantiateViewControllerWithIdentifier:@"bridgeTop"];
        OneBridge *mybridge=[self.bridge.bridges objectForKey:[NSNumber numberWithInt:index]] ;
        back.bridge=mybridge;
        [self.navigationController pushViewController:back animated:YES];
    }
    
}


-(void)updateStuff
{
    //UIImage *graphIm= [NSKeyedUnarchiver unarchiveObjectWithFile:[BRAppHelpers archivePathForGraphics]];
    

    //self.grafic.image=graphIm;
    [self updateBridges];
    [bridge refreshLoad:NO];
}

-(void)goToPush
{
    InitSlViewController * pushView=[self.storyboard instantiateViewControllerWithIdentifier:@"InitSlider"];
    pushView.controller=@"PUSHTop";
    [self.navigationController pushViewController:pushView animated:YES];
}

-(void)goHome
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.75f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scroller.contentOffset.x>113) {
        self.abbrView.hidden=NO;
    }
    else
    {
        self.abbrView.hidden=YES;
    }
    
    //NSLog(@"%f",scroller.contentOffset.x);
    

CGRect frame=self.menu.frame;

if(frame.origin.y!=460+yMenuBot)
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    frame.origin.y=460+yMenuBot;
    self.menu.frame=frame;
    [UIView commitAnimations];
}
}
*/
//определение с ориентацией

- (BOOL)shouldAutorotate {

    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {

    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    UIInterfaceOrientation orientation = [UIApplication
                                          sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
    {
        CGRect frameScroll=self.scroller.frame;
        [self.view insertSubview:self.abbrView aboveSubview:scroller];
        frameScroll.origin.y=60;
        frameScroll.size.height=500;
        frameScroll.size.width=320;//600
        CGSize sizescroll=self.scroller.contentSize;
        sizescroll.height=300;
        //scroller.contentSize=CGSizeMake(960+diffCont, 300);
        self.scroller.frame=frameScroll;
        //scroller.contentSize=CGSizeMake(960+diffCont, 300);
        
        frameScroll=self.grafic.frame;
        
        
        
        frameScroll.size=CGSizeMake(320, 360+yMenuBot);
        self.grafic.frame=frameScroll;
        
        
        [self.view insertSubview:self.menu aboveSubview:self.scroller];
        
    }
    else
    {
        for (UIView *subview in [self.view subviews]) {
            [self.view insertSubview:self.scroller aboveSubview:subview];
        }
        
        CGRect frameScroll=self.scroller.frame;
        frameScroll.origin.y=15;
        frameScroll.size.height=[UIScreen mainScreen].bounds.size.width;
        frameScroll.size.width=[UIScreen mainScreen].bounds.size.height;
        self.scroller.frame=frameScroll;
        //CGSize size=self.scroller.contentSize;
        //size.width=570;
        //self.scroller.contentSize=size;
        frameScroll=self.grafic.frame;
        frameScroll.size=CGSizeMake(self.scroller.frame.size.width, 305);
        self.grafic.frame=frameScroll;
        
        
    }
    [self.grafic reloadData];
}



//grafic == tableView data source and delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.bridges count] - 4;
}

- (MHBridgeTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHBridgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MHBridgeTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell..
    
    int index = indexPath.row;
    NSLog(@"Configuring cell at index %d", index);
    cell.nameLabel.text = ((MHBridgeInfo *) bridges[index]).name ;
    //cell.nameLabel.text = [NSString stringWithFormat:@"%C%C",[((Bridge *) bridges[index]).name characterAtIndex:0],
    //                       [((Bridge *) bridges[index]).name characterAtIndex:1]];
    cell.timeLine.bridgeOpen = ((MHBridgeInfo *) bridges[index]).openTime;
    cell.timeLine.bridgeClose = ((MHBridgeInfo *) bridges[index]).closeTime;
    cell.timeLine.bridgeIsOpenedTwoTimes = ((MHBridgeInfo *) bridges[index]).isOpenedTwoTimes;
    cell.timeLine.bridgeOpen2 = ((MHBridgeInfo *) bridges[index]).openTime2;
    cell.timeLine.bridgeClose2 = ((MHBridgeInfo *) bridges[index]).closeTime2;
    cell.timeLine.progress = currentTime;
    //[cell.timeLine changeStateToSmall]; // state = small; view will be redrawn
    
    UIInterfaceOrientation orientation = [UIApplication
                                          sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
    {
        CGRect frame=cell.timeLine.frame;
        frame.size=CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, cell.timeLine.frame.size.height);
        cell.timeLine.frame = frame;
    } else {
        CGRect frame=cell.timeLine.frame;
        frame.size=CGSizeMake([UIScreen mainScreen].bounds.size.height - 40, cell.timeLine.frame.size.height);
        cell.timeLine.frame = frame;
    }
    
    [cell.timeLine setNeedsDisplay];
    [cell.timeLine setBackgroundColor:[UIColor clearColor]];
    UIImage *bridgeImage;
    if (currentTime >= cell.timeLine.bridgeOpen  && currentTime <= cell.timeLine.bridgeClose){
        //bridge is opened now;
        NSLog(@"OPEN! ITS OPEN!");
        bridgeImage = [UIImage imageNamed:@"bridge_icon_black0"];
        [cell setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.03]];
        //[cell.timeLine setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.2]];
        
    } else {
        //bridge is closed;
        bridgeImage = [UIImage imageNamed:@"bridge_icon_black1"];
        [cell setBackgroundColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.03]];
        //[cell.timeLine setBackgroundColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.2]];
        
    }
    if (cell.timeLine.bridgeIsOpenedTwoTimes) {
        if (currentTime >= cell.timeLine.bridgeOpen2  && currentTime <= cell.timeLine.bridgeClose2){
            //bridge is opened now;
            [cell setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.03]];
            //[cell.timeLine setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.2]];
            
            bridgeImage = [UIImage imageNamed:@"bridge_icon_black0"];
        }
        
    }
    cell.imageView.image = bridgeImage;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return cell;
    
}
//Custom row height;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;//44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MHTimeLine *headerView = [[MHTimeLine alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.alpha = 0.8f;
    [headerView setProgress: currentTime];
   
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}



@end
