//
//  BRBridgeViewController.h
//  BridgeSPB
//
//  Created by Stas on 06.03.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bridge.h"
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import <MapKit/MapKit.h>

@interface BRBridgeViewController : UIViewController<MKAnnotation,MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *goToCur;

@property (weak, nonatomic) IBOutlet UIView *viewWithHelp;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (nonatomic, strong) OneBridge * bridge;
@property (nonatomic, strong) ECSlidingViewController * slidingViewController;
@property (weak, nonatomic) IBOutlet UITextView *moreInfotext;
//@property (weak, nonatomic) IBOutlet UIImageView *imageTimeOff;
@property (weak, nonatomic) IBOutlet UIView *menu;
@property (weak, nonatomic) IBOutlet UIButton *laftBut;
@property (weak, nonatomic) IBOutlet UIButton *button;
- (IBAction)goBrGraph:(id)sender;
- (IBAction)goMap:(id)sender;


@property (weak, nonatomic) IBOutlet UIImageView *imageBridge;
@property (weak, nonatomic) IBOutlet UILabel *NameBr;
- (IBAction)moreInfo:(id)sender;
@property (nonatomic, strong) Bridge * bridges;
@property (weak, nonatomic) IBOutlet UIView *AllView;

@property (weak, nonatomic) IBOutlet UIButton *butMoreInfo;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (nonatomic) NSInteger allIndex;
- (IBAction)showCurrentLocation;
@end
