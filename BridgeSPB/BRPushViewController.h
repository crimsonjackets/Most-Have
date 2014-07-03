//
//  BRPushViewController.h
//  BridgeSPB
//
//  Created by Stas on 09.04.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "Bridge.h"
#import "BRBridgeViewController.h"

@interface BRPushViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) Bridge * bridges;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *lineSepar;



@end
