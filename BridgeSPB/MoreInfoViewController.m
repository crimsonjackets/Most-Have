//
//  MoreInfoViewController.m
//  BridgeSPB
//
//  Created by Stas on 28.03.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import "MoreInfoViewController.h"
#import "InitSlViewController.h"

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
}
@end

@implementation MoreInfoViewController

@synthesize scroller;
@synthesize bridge;
@synthesize grafic;
@synthesize menu;
@synthesize button;
@synthesize yMenu;
@synthesize laftBut;

-(void)viewDidAppear:(BOOL)animated
{
    myTimer=[NSTimer scheduledTimerWithTimeInterval:3
                                             target:self
                                           selector:@selector(menuShowing)
                                           userInfo:nil
                                            repeats:YES];
    [self.bridge refreshLoad:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewWithHelp.hidden=YES;
    self.abbrView.hidden=YES;

    
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
    frame.origin.y=self.yMenu+yMenuBot;
    self.menu.frame=frame;
    
    frame=self.viewWithHelp.frame;
    frame.origin.y+=yMenuBot;
    self.viewWithHelp.frame=frame;
    
    self.navigationController.navigationBar.hidden=YES;
    scroller.contentSize=CGSizeMake(960+diffCont, 300);
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
    UIPanGestureRecognizer *swipeUp1 = [[UIPanGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(openMenu:)];
  //  swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp1];

    [self.view insertSubview:menu aboveSubview:scroller];

  //  NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    UIImage *graphIm= [NSKeyedUnarchiver unarchiveObjectWithFile:[BRAppHelpers archivePathForGraphics]];

    
    self.grafic.image=graphIm;
 //   NSLog(@"%@",self.grafic.image);
    
    frame=grafic.frame;
    frame.size.height+=yMenuBot;
    frame.size.width=sizeHeigth;
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
        frameAbbr.origin.y=60;
        scroller.frame=frame;
        self.abbrView.frame=frameAbbr;
        [UIView commitAnimations];
        rightImage.image=[UIImage imageNamed:@"butClose.png"];
    }
    else
    {
        
        
        frame.origin.y=140;
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
    UIImage *graphIm= [NSKeyedUnarchiver unarchiveObjectWithFile:[BRAppHelpers archivePathForGraphics]];
    

    self.grafic.image=graphIm;
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
                    frameScroll.size.width=611;
                    CGSize sizescroll=self.scroller.contentSize;
                    sizescroll.height=300;
                    scroller.contentSize=CGSizeMake(960+diffCont, 300);
                        self.scroller.frame=frameScroll;
                        scroller.contentSize=CGSizeMake(960+diffCont, 300);
        
                    frameScroll=self.grafic.frame;
   


                    frameScroll.size=CGSizeMake(sizeHeigth, 350+yMenuBot);
                    self.grafic.frame=frameScroll;
                    
        
                    [self.view insertSubview:self.menu aboveSubview:self.scroller];
        }
        else
        {
                        for (UIView *subview in [self.view subviews]) {
                            [self.view insertSubview:self.scroller aboveSubview:subview];
                        }
                        
                        CGRect frameScroll=self.scroller.frame;
                        frameScroll.origin.y=0;
                        frameScroll.size.height=[UIScreen mainScreen].bounds.size.width;
                        frameScroll.size.width=[UIScreen mainScreen].bounds.size.height;
                        self.scroller.frame=frameScroll;
                    CGSize size=self.scroller.contentSize;
                    size.width=580;
                    self.scroller.contentSize=size;
                        frameScroll=self.grafic.frame;
                    frameScroll.size=CGSizeMake(595, 300);
                    self.grafic.frame=frameScroll;
        }
}





@end
