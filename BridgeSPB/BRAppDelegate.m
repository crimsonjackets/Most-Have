//
//  BRAppDelegate.m
//  BridgeSPB
//
//  Created by Stas on 01.03.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import "BRAppDelegate.h"
#import "BRPushViewController.h"
#import "MHBridgeInfo.h"

#import "PushWizard.h"

static NSString *kAppKey = @"53d0b77ea3fc27f22b8b4585";



@implementation BRAppDelegate
@synthesize netStatus;
@synthesize hostReach;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    sleep(1);
    [self initBridges];
    [self initMessage];
    [self getBridgesInfo];
    [BRAppDelegate getRSS];
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
    
   
    
    
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes: (UIRemoteNotificationTypeAlert |
                                          UIRemoteNotificationTypeBadge |
                                          UIRemoteNotificationTypeSound)];
    
    

    
    NSDictionary *pushNotificationPayload = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(pushNotificationPayload){
        NSLog(@"APP lauched with PUSH = %@", pushNotificationPayload);
        [self application:application didReceiveRemoteNotification:pushNotificationPayload];
    }
    
    // Override point for customization after application launch.
    return YES;
}
-(void)customizeAppearance
{
   // [[UINavigationBar appearance]setTitleView:[UIImage imageNamed:@"logo.png"] forBarMetrics:UIBarMetricsDefault ];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSArray *arr = [[NSArray alloc] initWithObjects:@"value1", @"value2", @"value3", @"value4", @"value5", nil];
    [PushWizard startWithToken:deviceToken andAppKey:kAppKey andValues:arr];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"[PUSH] Remote notification recieved");
    NSLog(@"userInfo: %@", userInfo);
    NSString *title = [userInfo objectForKey:@"t"];
    NSString *message = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"];
    
    NSDictionary *newPush = @{@"title": title,
                              @"message": message};
    
    NSMutableArray *pushMessage = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"pushMessage"]];
    if (!pushMessage){
        pushMessage = [[NSMutableArray alloc] init];
    }
    [pushMessage addObject: newPush];
    [[NSUserDefaults standardUserDefaults] setObject:pushMessage forKey:@"pushMessage"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatePush" object:nil];
    [PushWizard handleNotification:userInfo];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    NSArray *arr = [[NSArray alloc] initWithObjects:@"value1", @"value2", @"value3", @"value4", @"value5", nil];
    [PushWizard updateSessionWithValues:arr];

  
     // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
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
    dispatch_sync(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBridgesInfo" object:nil];
    });
}


+(void) getRSS
{
    NSString *urlAsString = @"http://mostotrest.com/press_center/news/rss/";
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
             NSString *rss = [[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding];
             NSLog(@"RSS = %@", rss);
             [self parseRSS: rss];
         }
         else if ([data length] == 0 &&
                  error == nil){
             NSLog(@"Nothing was downloaded.");
             
         }
         else if (error != nil){
             NSLog(@"Error happened = %@", error);
             
         }
     }];

}

+(void) parseRSS: (NSString *) rss
{
    //getting message
    NSString * toFind = @"<yandex:full-text>";
    NSRange range = [rss rangeOfString:toFind];
    int beginIndex = range.location + range.length;
    toFind = @"</yandex:full-text>";
    range = [rss rangeOfString:toFind];
    int endIndex = range.location;
    range.location = beginIndex;
    range.length = endIndex - beginIndex;
    NSString *message = [rss substringWithRange: range];
    
    
    
    
    //getting currDate
    toFind = @"в ночь на ";
    range = [message rangeOfString:toFind];
    range.location += range.length;
    range.length = 10;
    NSString *currDate = [message substringWithRange:range];
    //making current date <strong>
    message = [NSString stringWithFormat:@"%@&lt;strong&gt;%@&lt;/strong&gt;%@",[message substringToIndex:range.location], currDate,
               [message substringFromIndex:range.location + range.length]];
    
    NSLog(@"[RSS] Message = %@", message);
    NSLog(@"[RSS] CurrDate = %@", currDate);
    
    [[NSUserDefaults standardUserDefaults] setObject:message forKey:@"messageRSS"];
    [[NSUserDefaults standardUserDefaults] setObject:currDate forKey:@"currDateRSS"];
    
    [self updateRSS];
    
}

+(void) updateRSS
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateRSS" object:nil];
    });
}

-(void) initMessage
{
    [[NSUserDefaults standardUserDefaults] setObject:@"Ой! Не удалось загрузить новость дня." forKey:@"messageRSS"];
    [[NSUserDefaults standardUserDefaults] setObject:@"01.01" forKey:@"currDateRSS"];
    NSLog(@"Message initialized.");
}

@end
