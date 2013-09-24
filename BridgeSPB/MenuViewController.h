//
//  MenuViewController.h
//  BridgeSPB
//
//  Created by Stas on 26.03.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import <MessageUI/MessageUI.h>

@interface MenuViewController : UIViewController <UITableViewDataSource, UITabBarControllerDelegate,MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *crimsonJack;
@property (weak, nonatomic) IBOutlet UIButton *crimsBut;
@property (weak, nonatomic) IBOutlet UIButton *sotrudBut;

- (IBAction)openMail:(id)sender;
- (IBAction)goSite:(id)sender;
@end
