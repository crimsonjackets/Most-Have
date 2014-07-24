//
//  BRPushViewController.m
//  BridgeSPB
//
//  Created by Stas on 09.04.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import "BRPushViewController.h"
#import "BRPushCell.h"
@interface BRPushViewController ()
{
    UIImageView * rightImage;
    UIImageView * leftImage;
    NSMutableArray * pushMessage;
}
@end

@implementation BRPushViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
     self.navigationController.navigationBar.hidden=YES;
    [self.bridges refreshLoad:NO];
    if (standardUserDefaults)
        pushMessage = [standardUserDefaults objectForKey:@"pushMessage"];
     [self.tableView reloadData];
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    self.slidingViewController.underRightViewController = nil;
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStuff) name:@"updatePush" object:nil];
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    self.navigationController.navigationBar.hidden=YES;
    [self.bridges refreshLoad:NO];
    if (standardUserDefaults)
        pushMessage = [standardUserDefaults objectForKey:@"pushMessage"];
    [self.tableView reloadData];
    
    
    self.bridges=[Bridge initWithView:self.view belowBiew:self.tableView];
    leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 25, 15, 11)];
    rightImage=[[UIImageView alloc]initWithFrame:CGRectMake(260, 30, 35, 5)];
    NSArray *imageLeftRight=[NSArray arrayWithObjects:rightImage,leftImage, nil];
    self.view=[BRAppHelpers addHeadonView:self.view andImages:imageLeftRight withTarget:self];

     UIButton *newPush=[[UIButton alloc]initWithFrame:CGRectMake(40, 40, 40, 40)];
    [self.view addSubview:newPush];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.tableView.frame.origin.y!=60)
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
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.tableView.frame.origin.y!=60)
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
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.tableView.frame.origin.y!=60)
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
}


-(void)hideBridge:(id)sender//спрятать вид с иконками мостов
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    CGRect frameSep=self.lineSepar.frame;
    CGRect frame=self.tableView.frame;
    if(frame.origin.y!=60)
    {
        frame.origin.y=60;
        frameSep.origin.y-=80;
        self.tableView.frame=frame;
        self.lineSepar.frame=frameSep;
        [UIView commitAnimations];
        rightImage.image=[UIImage imageNamed:@"butClose.png"];
    }
    else
    {
        frame.origin.y=140;
        frameSep.origin.y+=80;
        self.tableView.frame=frame;
        self.lineSepar.frame=frameSep;
        [UIView commitAnimations];
        rightImage.image=[UIImage imageNamed:@"butOpen.png"];
    }
        [self.bridges refreshLoad:NO];
}

-(void)leftMenu:(id)sender
{
    if(self.slidingViewController)
    {
        [self.slidingViewController anchorTopViewTo:ECRight];
    }
    else
    {
        [self goHome];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pushMessage count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
}




// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    BRPushCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PushCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
        
    
    NSDictionary *lastMessage = [pushMessage objectAtIndex:[pushMessage count]-indexPath.row-1];
    cell.timePush.text = [lastMessage objectForKey:@"title"];
    cell.infoPush.text = [lastMessage objectForKey:@"message"];
   
    
    UIImageView *backGr=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pushWindowOff.png"]];
    CGRect frame=backGr.frame;
    frame.size.width-=100;
    backGr.frame=frame;
    cell.backgroundView=backGr;
    [cell becomeFirstResponder];
    cell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pushWindowOn.png"]];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateStuff
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
        pushMessage = [standardUserDefaults objectForKey:@"pushMessage"];
    [self.tableView reloadData];
    [self.bridges refreshLoad:NO];

}

-(void)goToPush
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
        pushMessage = [standardUserDefaults objectForKey:@"pushMessage"];
    [self.tableView reloadData];
    [self.bridges refreshLoad:NO];
}

-(void)goHome
{
    
    NSString *identifier = @"InitSlider";
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.navigationController pushViewController:newTopViewController animated:YES];

}


@end
