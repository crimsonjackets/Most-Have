//
//  MoreInfoViewController.h
//  BridgeSPB
//
//  Created by Stas on 28.03.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRViewController.h"
#import "Bridge.h"
#import "BRBridgeViewController.h"
#import "OneBridge.h"
#import "BRMAPViewController.h"
#import "UAirship.h"
#import "UAPush.h"
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"


@interface MoreInfoViewController : UIViewController<UIScrollViewAccessibilityDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *abbrView;
@property (weak, nonatomic) IBOutlet UIView *viewWithHelp;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (nonatomic, strong) Bridge * bridge;
@property (weak, nonatomic) IBOutlet UIImageView *grafic;
@property (weak, nonatomic) IBOutlet UIView *menu;
@property(nonatomic) int yMenu;
@property (weak, nonatomic) IBOutlet UIButton *button;
- (IBAction)goMap:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *laftBut;

@end
