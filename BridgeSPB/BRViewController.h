//
//  BRViewController.h
//  BridgeSPB
//
//  Created by Stas on 01.03.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "Bridge.h"
#import "BRAppDelegate.h"

@interface BRViewController : UIViewController<UIScrollViewAccessibilityDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *shakeLabel;
@property (strong, nonatomic) IBOutlet UIView *allView;
@property (weak, nonatomic) IBOutlet UILabel *firstLabelInfo;
@property (weak, nonatomic) IBOutlet UILabel *lastLabelInfo;


@property (weak, nonatomic) IBOutlet UIView *viewWithLabels;

@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (nonatomic, strong) Bridge * bridge;
@property (nonatomic) NSInteger allIndex;
@property (weak, nonatomic) IBOutlet UIView *viewWithTimer;
@property (weak, nonatomic) IBOutlet UILabel *firstMost;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabelbefor;

@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UILabel *beforeAfter;

- (UIColor *) randomColor;

//extern NSDictionary *pushMessage;


@end
