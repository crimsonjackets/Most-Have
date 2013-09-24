//
//  BRAppDelegate.m
//  BridgeSPB
//
//  Created by Stas on 01.03.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import "BRAppDelegate.h"
#import "UAirship.h"
#import "UAPush.h"
#import "UAInboxPushHandler.h"
#import "BRPushViewController.h"


@implementation BRAppDelegate
@synthesize netStatus;
@synthesize hostReach;
@synthesize pushMessage;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    sleep(1);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:@"isFirstRun" forKey:@"isFirstRun"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    


    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    self.hostReach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReach startNotifier];
    [self updateInterfaceWithReachability: hostReach];

    
    //[self customizeAppearance];
    [application setApplicationSupportsShakeToEdit:YES];
    //Create Airship options dictionary and add the required UIApplication launchOptions
    NSMutableDictionary *takeOffOptions = [NSMutableDictionary dictionary];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    
    // Call takeOff (which creates the UAirship singleton), passing in the launch options so the
    // library can properly record when the app is launched from a push notification. This call is
    // required.
    //
    // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
    [UAirship takeOff:takeOffOptions];
    
    // Set the icon badge to zero on startup (optional)
    [[UAPush shared] resetBadge];
    
    // Register for remote notfications with the UA Library. This call is required.
    [[UAPush shared] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeSound |
                                                         UIRemoteNotificationTypeAlert)];
    
    // Handle any incoming incoming push notifications.
    // This will invoke `handleBackgroundNotification` on your UAPushNotificationDelegate.
    [[UAPush shared] handleNotification:[launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey]
                       applicationState:application.applicationState];

    


    

    return YES;
    
    
    // Override point for customization after application launch.
    return YES;
}
-(void)customizeAppearance
{
   // [[UINavigationBar appearance]setTitleView:[UIImage imageNamed:@"logo.png"] forBarMetrics:UIBarMetricsDefault ];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Updates the device token and registers the token with UA.
    NSString *yourAlias = @"YOUR NICK";
    [UAPush shared].alias = yourAlias;
    [[UAPush shared] registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // TestFlight API
  //  TESTFLIGHT_CHECKPOINT(@"Receive Remote Notification");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getPush" object:nil];
    
    // Urban Airship
    [[UAPush shared] handleNotification:userInfo applicationState:application.applicationState];
    [[UAPush shared] resetBadge];
    
    NSDictionary *lastMessage=[userInfo objectForKey:@"aps"];
    // shakeLabel.text=[lastMessage objectForKey:@"shakeLabel"];
    
    
    
    if([lastMessage objectForKey:@"pubDate"])
    {

        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *messageArray = nil;
        NSMutableArray *message;
        
        
        if ([standardUserDefaults objectForKey:@"pushMessage"])
            messageArray = [standardUserDefaults objectForKey:@"pushMessage"];
        

        if (messageArray==nil) {

            message=[[NSMutableArray alloc]initWithObjects:userInfo, nil];
            [standardUserDefaults setObject:message forKey:@"pushMessage"];
            [standardUserDefaults synchronize];
        }
        else{

            message=[NSMutableArray arrayWithArray:messageArray];
            [message addObject:userInfo];
        }

        [standardUserDefaults setObject:message forKey:@"pushMessage"];
        [standardUserDefaults synchronize];


    }
    [UAInboxPushHandler handleNotification:userInfo];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    if([UIApplication sharedApplication].applicationIconBadgeNumber>0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getPush" object:nil];
    }
    
    
    [[UAPush shared] resetBadge];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appDidBecomeActive" object:nil];

  
     // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [UAirship land];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) updateInterfaceWithReachability: (Reachability*) curReach {
    self.netStatus = [curReach currentReachabilityStatus];
}

- (void) reachabilityChanged: (NSNotification* )note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability: curReach];
}


@end
