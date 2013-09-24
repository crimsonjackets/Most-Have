//
//  BRInfoViewController.m
//  BridgeSPB
//
//  Created by Stas on 09.04.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import "BRInfoViewController.h"

@interface BRInfoViewController ()
{
    UIImageView * rightImage;
    UIImageView * leftImage;
}
@end

@implementation BRInfoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    self.slidingViewController.underRightViewController = nil;
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bridges=[Bridge initWithView:self.view belowBiew:self.view];
    leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 25, 15, 11)];
    rightImage=[[UIImageView alloc]initWithFrame:CGRectMake(260, 30, 35, 5)];
    NSArray *imageLeftRight=[NSArray arrayWithObjects:rightImage,leftImage, nil];
    self.view=[BRAppHelpers addHeadonView:self.view andImages:imageLeftRight withTarget:self];
    rightImage.image=[UIImage imageNamed:@"butClose.png"];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPnt = [touch locationInView:self.view];

    NSInteger index=[self.bridges findBridge:touchPnt];
    [self.bridges Information:index];

}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPnt = [touch locationInView:self.view];

    NSInteger index=[self.bridges findBridge:touchPnt];
    
    [self.bridges Information:index];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPnt = [touch locationInView:self.view];

    [self.bridges Information:-1];
    NSInteger index=[self.bridges findBridge:touchPnt];
    if (index>=0) {

        BRBridgeViewController *back=[self.storyboard instantiateViewControllerWithIdentifier:@"bridgeTop"];
        OneBridge *bridge=[self.bridges.bridges objectForKey:[NSNumber numberWithInt:index]] ;
        back.bridge=bridge;
        [self.navigationController pushViewController:back animated:YES];

    }
    
}
-(void)updateStuff
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
