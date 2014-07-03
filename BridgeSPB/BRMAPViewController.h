//
//  BRMAPViewController.h
//  BridgeSPB
//
//  Created by Stas on 12.03.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Bridge.h"
#import "BRViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

@interface BRMAPViewController : UIViewController<MKMapViewDelegate, MKAnnotation>
- (IBAction)toGraph:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *menu;
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIButton *goToCur;

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *laftBut;
@property (weak, nonatomic) IBOutlet UIView *viewInfoMap;
@property (nonatomic, strong) Bridge * bridges;
@end
