//
//  MenuViewController.m
//  BridgeSPB
//
//  Created by Stas on 26.03.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import "MenuViewController.h"
#import "InitSlViewController.h"

@interface MenuViewController ()
{
    float yMenuBot;
}
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation MenuViewController
@synthesize menuItems;

- (void)awakeFromNib
{
    NSLog(@"[MENU] awake from nib");
    self.menuItems = [NSArray arrayWithObjects:@"ГЛАВНАЯ",@"О ПРОЕКТЕ", @"PUSH", @"НОВОСТЬ ДНЯ", nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"[Menu] view will appear; ");
    CGRect frame=self.tableView.frame;
    frame.origin.y = 20;
    self.tableView.frame=frame;
    frame = self.view.frame;
    self.view.frame = frame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if(([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)&&([UIScreen mainScreen].bounds.size.height == 568.0))
    {
        yMenuBot=88;
        
    }
    else 
    {
        yMenuBot=0;
    }
    CGRect frame=self.tableView.frame;
    frame.size.height-=yMenuBot + 20;
    self.tableView.frame=frame;
    frame=self.crimsonJack.frame;
    frame.origin.y+=yMenuBot;
    self.crimsonJack.frame=frame;
    frame=self.crimsBut.frame;
    frame.origin.y+=yMenuBot;
    self.crimsBut.frame=frame;
    frame=self.sotrudBut.frame;
    frame.origin.y+=yMenuBot;
    self.sotrudBut.frame=frame;
    
    [self.slidingViewController setAnchorRightRevealAmount:150.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
	// Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 4;
    //return self.menuItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.5;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MenuItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.textColor=[UIColor colorWithRed:84.0f/255 green:84.0f/255 blue:84.0f/255 alpha:1];
    cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"%@Top", [self.menuItems objectAtIndex:indexPath.row]];
    if([identifier isEqualToString:@"ГЛАВНАЯTop"])
    {
        identifier=@"FirstTop";
    }
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goToPush
{
    InitSlViewController * pushView=[self.storyboard instantiateViewControllerWithIdentifier:@"InitSlider"];
    pushView.controller=@"PUSHTop";
    [self.navigationController pushViewController:pushView animated:YES];
}

- (IBAction)goSite:(id)sender {
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:@"http://crimsonjackets.ru"]];
}

- (IBAction)openMail:(id)sender
{
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




#pragma mark - MFMailComposeController delegate


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{

    
	[self dismissModalViewControllerAnimated:YES];
}


@end
