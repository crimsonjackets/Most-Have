//
//  BRBridgeViewController.m
//  BridgeSPB
//
//  Created by Stas on 06.03.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import "BRBridgeViewController.h"
#import "BRMAPViewController.h"
#import "MoreInfoViewController.h"
#import "Annotation.h"
#import "InitSlViewController.h"


#define METERS_PER_MILE 1609.344
@interface BRBridgeViewController ()
{
    UIImageView *moreInfo;
    UIImageView * rightImage;
    UIImageView * leftImage;
    float yMenuBot;
       NSTimer * myTimer;
           NSTimer * myTimer2;
}
@end

@implementation BRBridgeViewController


@synthesize bridge;
@synthesize info;
@synthesize imageBridge;
@synthesize NameBr;
@synthesize butMoreInfo;
@synthesize bridges;
@synthesize allIndex;
@synthesize moreInfotext;
@synthesize menu;
@synthesize laftBut;
@synthesize button;
@synthesize map;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.bridges refreshLoad:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewWithHelp.hidden=YES;
    
    if(([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)&&([UIScreen mainScreen].bounds.size.height == 568.0))
    {
        yMenuBot=91;

    }
    else
    {
        yMenuBot=0;
    }
    
    
  //  [self.view insertSubview:self.viewWithHelp aboveSubview:self.AllView];

   // [self.view insertSubview:self.AllView belowSubview:self.viewWithHelp];
    
    //CGRect frame=menu.frame;
    //frame.origin.y+=yMenuBot;
    //menu.frame=frame;
    

    
    CGRect frame=self.AllView.frame;
    frame.size.height-=91-yMenuBot-20;
    self.AllView.frame=frame;
    
    frame=self.viewWithHelp.frame;
    frame.origin.y+=yMenuBot-5;
    self.viewWithHelp.frame=frame;
    
    
    
    self.goToCur.alpha=0;
    map.alpha=0;
    map.showsUserLocation = YES;
    //[map setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    [moreInfotext setTextAlignment:NSTextAlignmentNatural];
    button.layer.cornerRadius=5;
    laftBut.layer.cornerRadius=5;
    button.layer.borderColor=[[UIColor blackColor] CGColor];
    button.layer.borderWidth=2;
    laftBut.layer.borderColor=[[UIColor blackColor] CGColor];
    laftBut.layer.borderWidth=2;
    [self becomeFirstResponder];
    
    moreInfo=[[UIImageView alloc]initWithFrame:CGRectMake(279, 46, 10.5, 6.5)];
    moreInfo.image=[UIImage imageNamed:@"buttonMoreInfo.png"];
    [self.AllView addSubview:moreInfo];
    moreInfo.alpha=0.8;
    
    /*UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(openMenu:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.AllView addGestureRecognizer:swipeUp];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(openMenu:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.AllView addGestureRecognizer:swipeDown];
    */
    //инициализация шапки
    self.bridges=[Bridge initWithView:self.view belowBiew:self.AllView];
    leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 40, 30)];
    rightImage=[[UIImageView alloc]initWithFrame:CGRectMake(260, 30, 35, 5)];
    NSArray *imageLeftRight=[NSArray arrayWithObjects:rightImage,leftImage, nil];
    self.view=[BRAppHelpers addHeadonView:self.view andImages:imageLeftRight withTarget:self];
    rightImage.image=[UIImage imageNamed:@"butClose.png"];
    leftImage.image=[UIImage imageNamed:@"Back.png"];
    
    //[self.view insertSubview:self.goToCur aboveSubview:map];
    
    [self refresh];

	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
   /* myTimer=[NSTimer scheduledTimerWithTimeInterval:3
                                             target:self
                                           selector:@selector(menuShowing)
                                           userInfo:nil
                                            repeats:YES];
    */
    [self.bridges refreshLoad:YES];
}

-(void)menuShowing
{
    if ([myTimer isValid]&& menu.frame.origin.y<440+yMenuBot) {
        [myTimer invalidate];
    }
    if(menu.frame.origin.y>440+yMenuBot)
    {
    CGRect frame=self.menu.frame;
    frame.origin.y=460+yMenuBot-25;
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
//кнопка больше информации о мосте
- (IBAction)moreInfo:(id)sender {
    /*
    CGRect frame=self.menu.frame;
    
    if(frame.origin.y!=460+yMenuBot)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        
        frame.origin.y=460+yMenuBot;
        self.menu.frame=frame;
        [UIView commitAnimations];

    }
    */
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.9];
    
    CGRect butFr=butMoreInfo.frame;

    if(butFr.size.height<250)
    {   
        [self performSelector:@selector(mymethod) withObject:nil afterDelay:0.1f];
        butFr.size.height+=270+yMenuBot;
        butMoreInfo.alpha=0.7;
        moreInfo.image=[UIImage imageNamed:@"butCloseInfo.png"];
    }
    else
    {
        [self mymethod];
        butMoreInfo.alpha=0.2;
        butFr.size.height-=270+yMenuBot;
        moreInfo.image=[UIImage imageNamed:@"buttonMoreInfo.png"];
    }
    
    
    
    self.butMoreInfo.frame=butFr;
    [UIView commitAnimations];
    
}

-(void)mymethod
{
    
    CGRect textFr=moreInfotext.frame;
    if(textFr.size.height<230)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.9];
        textFr.size.height+=230+yMenuBot;
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.8];
        textFr.size.height-=230+yMenuBot;
    }
    moreInfotext.frame=textFr;
    [UIView commitAnimations];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(Annotation*)annotation
{
    if (annotation == mapView.userLocation) {
        return nil;
    }
    MKAnnotationView * annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    annotationView.image = [bridges findAnnImage:annotation.index];
    
   // annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.canShowCallout = YES;
    annotationView.frame=CGRectMake(0, 0, 20, 29);
    
    return annotationView;
    }



//обновление информации о мосте, при выборе другого моста
-(void)refresh
{
    
    [self.bridges refreshLoad:YES];
    //self.imageTimeOff.image=[UIImage imageNamed:self.bridge.bridgeGraph];

    self.moreInfotext.text=self.bridge.moreinfo;
    info.text=self.bridge.name;
    UIImage *image=[UIImage imageNamed:bridge.imageBackGr];
    self.imageBridge.image=image;
    self.NameBr.text=bridge.name;
    self.info.text=bridge.info;
    if([self.info.text length]>30)
    {
        self.info.font=[UIFont systemFontOfSize:12];
    }
    else
    {
        self.info.font=[UIFont systemFontOfSize:17];
    }
    CLLocationCoordinate2D zoomLocation=CLLocationCoordinate2DMake(bridge.coord.x, bridge.coord.y);
    //    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(59.944136f, 30.288484f),
    //                                                       MKCoordinateSpanMake(1, 1));
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 3*METERS_PER_MILE, 3*METERS_PER_MILE);
    [map setRegion:viewRegion animated:YES];
    [map setCenterCoordinate:zoomLocation animated:YES];
    NSMutableArray * annotationsToRemove = [ map.annotations mutableCopy ] ;
    [ annotationsToRemove removeObject:map.userLocation ] ;
    [ map removeAnnotations:annotationsToRemove ] ;

    Annotation *annotation2 = [Annotation new];
    annotation2.index=1;
    annotation2.title = bridge.name;
    annotation2.subtitle = bridge.info;
    annotation2.coordinate = CLLocationCoordinate2DMake(bridge.coord.x, bridge.coord.y);
    [map addAnnotation:annotation2];
    [map selectAnnotation:annotation2 animated:YES];
}




//скрыть/открыть мосты
-(void)hideBridge:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    CGRect frame=self.AllView.frame;
    if(frame.origin.y>69)
    {
       // [self moveFrames:0];
        frame.origin.y=69;
        self.AllView.frame=frame;
        [UIView commitAnimations];
        rightImage.image=[UIImage imageNamed:@"butClose.png"];
    }
    else
    {
        frame.origin.y=140;
        self.AllView.frame=frame;
        //[self moveFrames:46];
        [UIView commitAnimations];
        rightImage.image=[UIImage imageNamed:@"butOpen.png"];
    }
    [self.bridges refreshLoad:YES];
}

//обработка касаний
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.AllView.frame.origin.y!=69)
    {
        UITouch *touch = [touches anyObject];
        CGPoint touchPnt = [touch locationInView:self.view];
        NSInteger index=[self.bridges findBridge:touchPnt];
        [self.bridges Information:index];
    }
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.AllView.frame.origin.y!=69)
    {
        UITouch *touch = [touches anyObject];
        CGPoint touchPnt = [touch locationInView:self.view];
        NSInteger index=[self.bridges findBridge:touchPnt];
        [self.bridges Information:index];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.AllView.frame.origin.y!=69)
    {
        UITouch *touch = [touches anyObject];
        CGPoint touchPnt = [touch locationInView:self.view];
        [self.bridges Information:-1];
        NSInteger index=[self.bridges findBridge:touchPnt];
        if (index>=0) {
            self.bridge=[self.bridges.bridges objectForKey:[NSNumber numberWithInt:index]];
            
            [self refresh];
        }
    }
}


//переход на предыдущую страницу
-(void)leftMenu:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}




-(void)openMenu:(UISwipeGestureRecognizer*)swipe
{
    

    CGRect frame=self.menu.frame;
    if(frame.origin.y!=460+yMenuBot && swipe.direction == UISwipeGestureRecognizerDirectionDown)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        
        frame.origin.y=460+yMenuBot;
        self.menu.frame=frame;
        [UIView commitAnimations];

    }
    else if(swipe.direction == UISwipeGestureRecognizerDirectionUp)
    {
        if ([myTimer2 isValid])
            [myTimer2 invalidate];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        frame.origin.y=403+yMenuBot;
        self.menu.frame=frame;
        
        [UIView commitAnimations];

    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.9];
    
    CGRect butFr=butMoreInfo.frame;

    if(butFr.size.height>=270)
    {
        [self mymethod];
        butMoreInfo.alpha=0.2;
        butFr.size.height-=270+yMenuBot;
        moreInfo.image=[UIImage imageNamed:@"buttonMoreInfo.png"];
    }
    
    self.butMoreInfo.frame=butFr;
    [UIView commitAnimations];

}


- (IBAction)goBrGraph:(id)sender {
    if(butMoreInfo.alpha == 0)
    {
        UIColor *newColor=button.backgroundColor;
        [button setBackgroundColor:laftBut.backgroundColor];
        [laftBut setBackgroundColor:newColor];
    
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        butMoreInfo.alpha=0.2;
        imageBridge.alpha=1;
        NameBr.alpha=1;
        info.alpha=1;
        moreInfo.alpha=0.8;
        map.alpha=0;
        self.goToCur.alpha=0;
        [UIView commitAnimations];
    }
}

- (IBAction)goMap:(id)sender {
    if(butMoreInfo.alpha!=0)
    {
        UIColor *newColor=button.backgroundColor;
        [button setBackgroundColor:laftBut.backgroundColor];
        [laftBut setBackgroundColor:newColor];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        
        self.goToCur.alpha=1;
        map.alpha=1;
        butMoreInfo.alpha=0;
        imageBridge.alpha=0;
        NameBr.alpha=0;
        info.alpha=0;
        moreInfo.alpha=0;
        [UIView commitAnimations];
    }
}

-(void)updateStuff
{
    [self.bridges refreshLoad:YES];

}

-(void)goToPush
{
    InitSlViewController * pushView=[self.storyboard instantiateViewControllerWithIdentifier:@"InitSlider"];
    pushView.controller=@"PUSHTop";
    [self.navigationController pushViewController:pushView animated:YES];
}

-(void)goHome
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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

- (IBAction)showCurrentLocation {
    [map setCenterCoordinate:map.userLocation.coordinate animated:YES];
}

@end
