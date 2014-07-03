//
//  ViewController.m
//  LocalNotification
//
//  Created by Alximik on 31.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    
    
    
    [self createnotification:[NSString stringWithFormat:@"%i-%i-%i %i:%i",currentComps.month,currentComps.day,currentComps.year,currentComps.hour,currentComps.minute+1] withMess:@"More info"];
    
    
    

    [notification release];
}


//получить навигейшен и сторибоард
-(void)getNavigationControlAndStoryBoard
{
    UIStoryboard *storyboard;
    storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    // UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"FirstTop"];
    // You now have in rootViewController the view with your "Hello world" label and go button.
    
    // Get the navigation controller of this view controller with:
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"navigator"];
    UIViewController *rootViewController = [navigationController.storyboard instantiateViewControllerWithIdentifier:@"graph"];
    
    // You can now use it to push your next view controller:
    //self.window.rootViewController=rootViewController;
    //  self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"FirstTop"];
    [navigationController pushViewController:rootViewController animated:YES];
    NSLog(@"InitSlider%@",rootViewController);

}


//для создания локальных уведомлений в опр время
-(void)createnotification:(NSString *)dateandtime withMess:(NSString *)message    //call this function to produce a local notification even if your app is running in background.

{
    
    UIApplication *app                = [UIApplication sharedApplication];
    NSArray *oldNotifications         = [app scheduledLocalNotifications];
    
    //    if ([oldNotifications count] > 0) {
    //        [app cancelAllLocalNotifications];
    //    }
    
    for (UILocalNotification *aNotif in oldNotifications) {
        if([[aNotif.userInfo objectForKey:@"ID"] isEqualToString:@"0"]) {
            [app cancelLocalNotification:aNotif];
        }
    }
    
    UILocalNotification *notification = [UILocalNotification new];
    notification.timeZone  = [NSTimeZone systemTimeZone];
    notification.fireDate  = [[NSDate date] dateByAddingTimeInterval:5.0f];
    notification.alertAction = @"More info";
    notification.alertBody = @"iMaladec Local Notification example";
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"0" forKey:@"id"];
    notification.userInfo = infoDict;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *currentDate = [NSDate date];
    
    NSDateComponents *currentComps = [calendar components:(  NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:currentDate];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSLog(@"%@",dateandtime);
    [formatter setDateFormat:@"MM-dd-yyyy HH:mm"];
    
    //[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:-18000]];
    
    NSDate *alerttime = [formatter dateFromString:dateandtime];
    
    UIApplication * app = [UIApplication sharedApplication];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    
    if (notification)
        
    {
        
        notification.fireDate = alerttime;
        
        //notification.timeZone = [NSTimeZone defaultTimeZone];
        
        notification.repeatInterval = 0;
        
        notification.alertBody = message;
        
        [app scheduleLocalNotification:notification];
        
        [app presentLocalNotificationNow:notification];
        
    }
        [app scheduleLocalNotification:notification];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
