//
//  BRAboutViewController.h
//  Most Have
//
//  Created by Stas on 30.04.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "Bridge.h"
#import "BRBridgeViewController.h"



@interface BRAboutViewController : UIViewController<MFMailComposeViewControllerDelegate>


@property (nonatomic, strong) Bridge * bridges;

@property (weak, nonatomic) IBOutlet UIImageView *lineSep;
@property (weak, nonatomic) IBOutlet UIView *about;
- (IBAction)goToCrims:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *goToCrimson;
- (IBAction)sendMail:(id)sender;




@end
