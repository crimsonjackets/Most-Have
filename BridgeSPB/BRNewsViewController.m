//
//  BRNewsViewController.m
//  BridgeSPB
//
//  Created by Stas on 09.04.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import "BRNewsViewController.h"
#import "BRAppDelegate.h"
#import "APICache.h"
#import "InitSlViewController.h"


@interface BRNewsViewController ()
{
    UIImageView * rightImage;
    UIImageView * leftImage;

    NSString * message;
    NSString * currDate;
    
}
@end



@implementation BRNewsViewController

@synthesize messageTextView;
@synthesize lineSep;


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
    
    //init bridges
    self.bridges=[Bridge initWithView:self.view belowBiew:self.infoView];
    leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 25, 15, 11)];
    rightImage=[[UIImageView alloc]initWithFrame:CGRectMake(260, 30, 35, 5)];
    NSArray *imageLeftRight=[NSArray arrayWithObjects:rightImage,leftImage, nil];
    self.view=[BRAppHelpers addHeadonView:self.view andImages:imageLeftRight withTarget:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStuff) name:@"updateRSS" object:nil];
    [BRAppDelegate getRSS];
    [self updateInfo];
    


    //[self.messageTextView loadHTMLString:[NSString stringWithFormat:@"<p>%@</p>", attributedString] baseURL:nil];
    
	// Do any additional setup after loading the view.
}

-(void) updateInfo
{
    //load message from UserDefaults
    message = [[NSUserDefaults standardUserDefaults] stringForKey:@"messageRSS"];
    NSLog(@"[News] message = %@", message);
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[message dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    message = attributedString.string;
    NSLog(@"[News] attributedString = %@", attributedString.string);

    
    NSMutableAttributedString *mutAttributedString = [[NSMutableAttributedString alloc] initWithData:[message dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]};
    [mutAttributedString setAttributes:dict range:NSMakeRange(0, mutAttributedString.length)];

    NSLog(@"[News] mutAttributedString = %@", mutAttributedString);

    self.messageTextView.attributedText = mutAttributedString;
    //[self.messageTextView.attributedText setValue:[UIFont systemFontOfSize:15.0f] forKey:NSFontAttributeName];
    
    [self.infoView setNeedsDisplay];
}

-(void) killMenu
{
    [self.slidingViewController resetTopView];
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

-(void)leftMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}


-(void)hideBridge:(id)sender//спрятать вид с иконками мостов
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    CGRect frameSep=self.lineSep.frame;
    CGRect frame=self.infoView.frame;
    if(frame.origin.y!=60)
    {
        frame.origin.y=60;
        frame.size.height += 80;
        frameSep.origin.y-=80;
        self.infoView.frame=frame;
        self.lineSep.frame=frameSep;
        [UIView commitAnimations];
        rightImage.image=[UIImage imageNamed:@"butClose.png"];
    }
    else
    {
        frame.origin.y=140;
        frame.size.height -= 80;
        frameSep.origin.y+=80;
        self.infoView.frame=frame;
        self.lineSep.frame=frameSep;
        [UIView commitAnimations];
        rightImage.image=[UIImage imageNamed:@"butOpen.png"];
    }
        [self.bridges refreshLoad:NO];
}



-(void)updateStuff
{
    [self.bridges refreshLoad:NO];
    [self updateInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
