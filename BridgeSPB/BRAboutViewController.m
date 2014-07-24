//
//  BRAboutViewController.m
//  Most Have
//
//  Created by Stas on 30.04.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import "BRAboutViewController.h"

#import "BRAppDelegate.h"
#import "APICache.h"
#import "InitSlViewController.h"

@interface BRAboutViewController ()
{
    UIImageView * rightImage;
    UIImageView * leftImage;
    NSInteger selectCell;
    NSInteger yMenuBot;
}
@end

@implementation BRAboutViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.bridges refreshLoad:NO];
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    self.slidingViewController.underRightViewController = nil;
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(killMenu) name:@"enterBackground" object:nil];
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if(([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)&&([UIScreen mainScreen].bounds.size.height == 568.0))
    {
        yMenuBot=91;
        
    }
    else
    {
        yMenuBot=0;
    }
    
    CGRect frameLogo=self.goToCrimson.frame;
    frameLogo.origin.y+=yMenuBot;
    self.goToCrimson.frame=frameLogo;
    
    self.bridges=[Bridge initWithView:self.view belowBiew:self.about];
    leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 25, 15, 11)];
    rightImage=[[UIImageView alloc]initWithFrame:CGRectMake(260, 30, 35, 5)];
    NSArray *imageLeftRight=[NSArray arrayWithObjects:rightImage,leftImage, nil];
    self.view=[BRAppHelpers addHeadonView:self.view andImages:imageLeftRight withTarget:self];
    [self.view insertSubview:self.goToCrimson aboveSubview:self.about];
    

// Dispose of any resources that can be recreated.
}

-(void)leftMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

-(void)hideBridge:(id)sender//спрятать вид с иконками мостов
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    CGRect frameSep=self.lineSep.frame;
    CGRect frame=self.about.frame;
    if(frame.origin.y!=61)
    {
        frame.origin.y=61;
        frameSep.origin.y-=80;
        self.about.frame=frame;
        self.lineSep.frame=frameSep;
        [UIView commitAnimations];
        rightImage.image=[UIImage imageNamed:@"butClose.png"];
    }
    else
    {
        frame.origin.y=141;
        frameSep.origin.y+=80;
        self.about.frame=frame;
        self.lineSep.frame=frameSep;
        [UIView commitAnimations];
        rightImage.image=[UIImage imageNamed:@"butOpen.png"];
    }
    [self.bridges refreshLoad:NO];
}



-(void) killMenu
{
    [self.slidingViewController resetTopView];
}

#pragma mark - MFMailComposeController delegate


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    
	[self dismissModalViewControllerAnimated:YES];
}



- (IBAction)goToCrims:(id)sender {
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:@"http://crimsonjackets.ru"]];
}
- (IBAction)sendMail:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        //Тема письма
        [picker setSubject:@"Hello from Most HAVE!"];
        
        //Получатели
        NSArray *toRecipients = [NSArray arrayWithObject:@"640x480@crimsonjackets.ru"];
        NSArray *ccRecipients = [NSArray new];
        NSArray *bccRecipients = [NSArray new];
        
        [picker setToRecipients:toRecipients];
        [picker setCcRecipients:ccRecipients];
        [picker setBccRecipients:bccRecipients];
        
        NSString *emailBody = @"from Most HAVE";
        [picker setMessageBody:emailBody isHTML:NO];
        
        [self presentModalViewController:picker animated:YES];
    } else {
        NSString *ccRecipients = @"second@example.com,third@example.com";
        NSString *subject = @"Hello from iMaladec!";
        NSString *recipients = [NSString stringWithFormat:
                                @"mailto:first@example.com?cc=%@&subject=%@",
                                ccRecipients, subject];
        NSString *body = @"&body=Это пример отправки Email с сайта iMaladec";
        
        NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
        email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    }
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPnt = [touch locationInView:self.view];
    
    NSInteger index=[self.bridges findBridge:touchPnt];
    if(index>=0)
    {
        self.slidingViewController.panGesture.enabled=NO;
    }
    else
    {
        self.slidingViewController.panGesture.enabled=YES;
    }
    [self.bridges Information:index];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPnt = [touch locationInView:self.view];
    NSInteger index=[self.bridges findBridge:touchPnt];
    if(index>=0)
    {
        self.slidingViewController.panGesture.enabled=NO;
    }
    else
    {
        self.slidingViewController.panGesture.enabled=YES;
    }
    [self.bridges Information:index];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPnt = [touch locationInView:self.view];
    [self.bridges Information:-1];
    NSInteger index=[self.bridges findBridge:touchPnt];
    if (index>=0) {
        self.slidingViewController.panGesture.enabled=NO;
        BRBridgeViewController *back=[self.storyboard instantiateViewControllerWithIdentifier:@"bridgeTop"];
        OneBridge *bridge=[self.bridges.bridges objectForKey:[NSNumber numberWithInt:index]] ;
        back.bridge=bridge;
        [self.navigationController pushViewController:back animated:YES];
    }
    else
    {
                self.slidingViewController.panGesture.enabled=YES;
    }
}


-(void)updateStuff
{
    [self.bridges refreshLoad:NO];
}

-(void)goHome
{
    
    NSString *identifier = @"InitSlider";
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.navigationController pushViewController:newTopViewController animated:YES];
    
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
