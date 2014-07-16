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
#import "MHBridgeInfo.h"

@implementation BRAppDelegate
@synthesize netStatus;
@synthesize hostReach;
@synthesize pushMessage;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    sleep(1);
    [self initBridges];
    [self getBridgesInfo];
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


- (void) getBridgesInfo
{
    //Saving to UserDefaults forKey:@"bridgesInfo"
    NSString *urlAsString = @"http://www.mostotrest.com";
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                            timeoutInterval:30.0f]; //waiting for 30 seconds
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error) {
         if ([data length] >0  &&
             error == nil){
             NSString *html = [[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding];
             //NSLog(@"HTML = %@", html);
             [self parse: html];
         }
         else if ([data length] == 0 &&
                  error == nil){
             NSLog(@"Nothing was downloaded.");
             [self updateBridgesInfo];
         }
         else if (error != nil){
             NSLog(@"Error happened = %@", error);
             [self updateBridgesInfo];
         }
     }];
}

- (void) parse:(NSString *) html
{
    //creating an array with existing information
    // !!!read from file
    NSMutableArray *bridges = [NSMutableArray arrayWithObjects:
                               [[MHBridgeInfo alloc ]initOnlyWithName:@"Благовещенский"],
                               [[MHBridgeInfo alloc ]initOnlyWithName:@"Дворцовый"],
                               [[MHBridgeInfo alloc ]initOnlyWithName:@"Биржевой"],
                               [[MHBridgeInfo alloc ]initOnlyWithName:@"Тучков"],
                               [[MHBridgeInfo alloc ]initOnlyWithName:@"Троицкий"],
                               [[MHBridgeInfo alloc ]initOnlyWithName:@"Литейный"],
                               [[MHBridgeInfo alloc ]initOnlyWithName:@"Большеохтинский"],
                               [[MHBridgeInfo alloc ]initOnlyWithName:@"Ал.Невского"],
                               [[MHBridgeInfo alloc ]initOnlyWithName:@"Володарский"],
                               [[MHBridgeInfo alloc ]initOnlyWithName:@"Финляндский"],
                               [[MHBridgeInfo alloc ]initOnlyWithName:@"Сампсониевский"],
                               [[MHBridgeInfo alloc ]initOnlyWithName:@"Гренадерский"],
                               [[MHBridgeInfo alloc ]initOnlyWithName:@"Кантемировский"],
                               nil];
    //searching information in html for each bridge
    
    BOOL noError = YES;
    int hour, min1, min2;
    for (int i = 0; i < [bridges count] - 3; i++){
        NSString * toFind = [NSString stringWithFormat:@"%@</span>", ((MHBridgeInfo *)bridges[i]).name];
        NSRange range = [html rangeOfString:toFind];
        
        //Open time
        hour = [html characterAtIndex:(range.location + range.length + 32)] - 48;
        min1 = [html characterAtIndex:(range.location + range.length + 34)] - 48;
        min2 = [html characterAtIndex:(range.location + range.length + 35)] - 48;
        if (hour >= 0 && hour < 10 && min1 >= 0 && min1 < 10 && min2 >= 0 && min2 < 10){
            ((MHBridgeInfo *)bridges[i]).openTime = hour * 60 + min1 * 10 + min2;
            NSLog(@"open time = %f", ((MHBridgeInfo *)bridges[i]).openTime);
        } else {
            NSLog(@"!!!Bridge name = %@",((MHBridgeInfo *)bridges[i]).name);
            noError = NO;
            break;
        }
        
        //Close time
        hour = [html characterAtIndex:(range.location + range.length + 40)] - 48;
        min1 = [html characterAtIndex:(range.location + range.length + 42)] - 48;
        min2 = [html characterAtIndex:(range.location + range.length + 43)] - 48;
        if (hour >= 0 && hour < 10 && min1 >= 0 && min1 < 10 && min2 >= 0 && min2 < 10){
            ((MHBridgeInfo *)bridges[i]).closeTime = hour * 60 + min1 * 10 + min2;
            NSLog(@"close time = %f", ((MHBridgeInfo *)bridges[i]).closeTime);
        } else {
            NSLog(@"!!!Bridge name = %@",((MHBridgeInfo *)bridges[i]).name);
            noError = NO;
            break;
        }
        
        //Open time2
        hour = [html characterAtIndex:(range.location + range.length + 52)] - 48;
        min1 = [html characterAtIndex:(range.location + range.length + 54)] - 48;
        min2 = [html characterAtIndex:(range.location + range.length + 55)] - 48;
        if (hour >= 0 && hour < 10 && min1 >= 0 && min1 < 10 && min2 >= 0 && min2 < 10){
            ((MHBridgeInfo *)bridges[i]).isOpenedTwoTimes = YES;
            ((MHBridgeInfo *)bridges[i]).openTime2 = hour * 60 + min1 * 10 + min2;
            NSLog(@"open time 2 = %f", ((MHBridgeInfo *)bridges[i]).openTime2);
        } else {
            ((MHBridgeInfo *)bridges[i]).isOpenedTwoTimes = NO;
            continue;
        }
        
        //Close time2
        hour = [html characterAtIndex:(range.location + range.length + 60)] - 48;
        min1 = [html characterAtIndex:(range.location + range.length + 62)] - 48;
        min2 = [html characterAtIndex:(range.location + range.length + 63)] - 48;
        if (hour >= 0 && hour < 10 && min1 >= 0 && min1 < 10 && min2 >= 0 && min2 < 10){
            ((MHBridgeInfo *)bridges[i]).closeTime2 = hour * 60 + min1 * 10 + min2;
            NSLog(@"close time 2 = %f", ((MHBridgeInfo *)bridges[i]).closeTime2);
        } else {
            ((MHBridgeInfo *)bridges[i]).isOpenedTwoTimes = NO;
            continue;
        }
        NSLog(@"isOpenedTwoTimes = %d",((MHBridgeInfo *)bridges[i]).isOpenedTwoTimes);
        
    }
    NSString * toFind = @"Кантемировского мостов производится с ";
    NSRange range = [html rangeOfString:toFind];
    hour = [html characterAtIndex:(range.location + range.length + 0)] - 48;
    min1 = [html characterAtIndex:(range.location + range.length + 2)] - 48;
    min2 = [html characterAtIndex:(range.location + range.length + 3)] - 48;

    if (hour >= 0 && hour < 10 && min1 >= 0 && min1 < 10 && min2 >= 0 && min2 < 10){
        for (int i = [bridges count] - 3; i < [bridges count]; i++){
            ((MHBridgeInfo *)bridges[i]).isOpenedTwoTimes = NO;
            ((MHBridgeInfo *)bridges[i]).openTime = hour * 60 + min1 * 10 + min2;
            NSLog(@"open time = %f", ((MHBridgeInfo *)bridges[i]).openTime);
        }
    } else {
        NSLog(@"!!!Bridge name = %@",((MHBridgeInfo *)bridges[11]).name);
        noError = NO;
    }
    hour = [html characterAtIndex:(range.location + range.length + 11)] - 48;
    min1 = [html characterAtIndex:(range.location + range.length + 13)] - 48;
    min2 = [html characterAtIndex:(range.location + range.length + 14)] - 48;
    if (hour >= 0 && hour < 10 && min1 >= 0 && min1 < 10 && min2 >= 0 && min2 < 10){
        for (int i = [bridges count] - 3; i < [bridges count]; i++){
            ((MHBridgeInfo *)bridges[i]).closeTime = hour * 60 + min1 * 10 + min2;
            NSLog(@"close time = %f", ((MHBridgeInfo *)bridges[i]).closeTime);
        }
    } else {
        NSLog(@"!!!Bridge name = %@",((MHBridgeInfo *)bridges[11]).name);
        noError = NO;
    }
    
    
    NSLog(@"Parse error: %d", noError);
    if (noError){
        //Updating bridges Info
        
        NSLog(@"bridges = %@", bridges);
        for (int i = 0; i < [bridges count]; i++){
            NSLog(@"Bridge[%d].name == %@; \nopenTime == %f \nopenTime == %f \nopenTime == %f \nopenTime == %f", i,
                  ((MHBridgeInfo *)bridges[i]).name,
                  ((MHBridgeInfo *)bridges[i]).openTime ,
                  ((MHBridgeInfo *)bridges[i]).closeTime,
                  ((MHBridgeInfo *)bridges[i]).openTime2,
                  ((MHBridgeInfo *)bridges[i]).closeTime2);
        }
         
        //store data
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:bridges];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"bridgesInfo"];
        
    }
    [self updateBridgesInfo];
    /*
     else {
     NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"bridgesInfo"];
     NSArray *newBridges = [NSKeyedUnarchiver unarchiveObjectWithData:data];
     
     NSLog(@"newBridges = %@", newBridges);
     if ([bridges count] == [newBridges count]){
     NSLog(@"Read the array back from disk just fine.");
     for (int i = 0; i < [newBridges count]; i++){
     NSLog(@"Bridge[%d].name == %@ openTime == %f", i,((Bridge *)newBridges[i]).name,((Bridge *)newBridges[i]).openTime );
     }
     
     } else {
     NSLog(@"Not EQUAL.");
     }
     
     }
     */
    
}
- (void) initBridges
{
    BOOL isFisrtRun = ![[NSUserDefaults standardUserDefaults] boolForKey:@"firstRun"];
    NSLog(@"Is first run %d", isFisrtRun);
    if (isFisrtRun){
        
        NSMutableArray *bridges = [NSMutableArray arrayWithObjects:
                                   [[MHBridgeInfo alloc ]initWithName:@"Благовещенский" andOpenTime: 85.0 andCloseTime: 165.0 andIsOpenedTwoTimes: YES
                                                   andOpenTime2: 190.0 andCloseTime2: 300.0],
                                   [[MHBridgeInfo alloc ]initWithName:@"Дворцовый" andOpenTime: 85.0 andCloseTime: 170.0 andIsOpenedTwoTimes: YES
                                                         andOpenTime2: 190.0 andCloseTime2: 295.0],
                                   [[MHBridgeInfo alloc ]initWithName:@"Биржевой" andOpenTime: 120.0 andCloseTime: 295.0 andIsOpenedTwoTimes: NO
                                                         andOpenTime2: 0.0 andCloseTime2: 0.0],
                                   [[MHBridgeInfo alloc ]initWithName:@"Тучков" andOpenTime: 120.0 andCloseTime: 175.0 andIsOpenedTwoTimes: YES
                                                         andOpenTime2: 215.0 andCloseTime2: 295.0],
                                   [[MHBridgeInfo alloc ]initWithName:@"Троицкий" andOpenTime: 95.0 andCloseTime: 290.0 andIsOpenedTwoTimes: NO
                                                   andOpenTime2: 0.0 andCloseTime2: 0.0],
                                   [[MHBridgeInfo alloc ]initWithName:@"Литейный" andOpenTime: 100.0 andCloseTime: 295.0 andIsOpenedTwoTimes: NO
                                                   andOpenTime2: 0.0 andCloseTime2: 0.0],
                                   [[MHBridgeInfo alloc ]initWithName:@"Большеохтинский" andOpenTime: 120.0 andCloseTime: 300.0 andIsOpenedTwoTimes: NO
                                                   andOpenTime2: 0.0 andCloseTime2: 0.0],
                                   [[MHBridgeInfo alloc ]initWithName:@"Ал.Невского" andOpenTime: 140.0 andCloseTime: 310.0 andIsOpenedTwoTimes: NO
                                                   andOpenTime2: 0.0 andCloseTime2: 0.0],
                                   [[MHBridgeInfo alloc ]initWithName:@"Володарский" andOpenTime: 120.0 andCloseTime: 225.0 andIsOpenedTwoTimes: YES
                                                   andOpenTime2: 255.0 andCloseTime2: 345.0],
                                   
                                   [[MHBridgeInfo alloc ]initWithName:@"Финляндский" andOpenTime: 140.0 andCloseTime: 330.0 andIsOpenedTwoTimes: NO
                                                         andOpenTime2: 0.0 andCloseTime2: 0.0],
                                   [[MHBridgeInfo alloc ]initWithName:@"Сампсониевский" andOpenTime: 90.0 andCloseTime: 270.0 andIsOpenedTwoTimes: NO
                                                         andOpenTime2: 0.0 andCloseTime2: 0.0],
                                   [[MHBridgeInfo alloc ]initWithName:@"Гренадерский" andOpenTime: 90.0 andCloseTime: 270.0 andIsOpenedTwoTimes: NO
                                                   andOpenTime2: 0.0 andCloseTime2: 0.0],
                                   [[MHBridgeInfo alloc ]initWithName:@"Кантемировский" andOpenTime: 90.0 andCloseTime: 270.0 andIsOpenedTwoTimes: NO
                                                         andOpenTime2: 0.0 andCloseTime2: 0.0],
                                   nil];
        //store bridges
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:bridges];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"bridgesInfo"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstRun"];
        NSLog(@"Bridges initialized and stored");
    }
}
- (void) updateBridgesInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBridgesInfo" object:nil];
    
}

@end
