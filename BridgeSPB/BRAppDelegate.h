//
//  BRAppDelegate.h
//  BridgeSPB
//
//  Created by Stas on 01.03.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "BRMAPViewController.h"

@interface BRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary *pushMessage;
@property (assign, nonatomic) NetworkStatus netStatus;
@property (strong, nonatomic) Reachability  *hostReach;


- (void)updateInterfaceWithReachability: (Reachability*) curReach;
+ (void) getRSS;

@end
