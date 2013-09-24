//
//  Bridge.h
//  BridgeSPB
//
//  Created by Stas on 01.03.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OneBridge.h"
#import <CoreLocation/CoreLocation.h>

@interface Bridge : NSObject
{
    NSInteger count;
    UIView * view;
    IBOutlet CLLocationManager *locationManager;
}
@property (nonatomic,strong) NSMutableDictionary	*bridges;
@property (strong,nonatomic) NSMutableArray *locBridges;
@property (strong,nonatomic) NSArray *timeInterval;
//@property (strong,nonatomic) NSMutableArray *bridgesScrollView;
@property (strong,nonatomic) UILabel *info;
@property (strong,nonatomic) NSArray *mostOnTime;
@property (strong,nonatomic) NSArray *infoOnTime;
@property (strong,nonatomic) NSArray *timeIntervalForInfo;

-(UIImage *) findAnnImage:(NSInteger)index;

-(NSArray *) getListOfMostwithCalendar:(NSCalendar *)calendar;

-(void)hideBridge:(BOOL)hiden;
-(void)ChandeStatys:(NSInteger)index withCalendar:(NSCalendar *)calendar
;
-(NSInteger)findBridge:(CGPoint)point;
-(void)Information:(NSInteger)index;
-(void)refreshLoad:(BOOL)load;
+(Bridge*)initWithView:(UIView*)view belowBiew:(UIView*)upView;
-(NSInteger)beforeAfterwithCalendar:(NSCalendar *)calendar;
-(NSArray *)getInfoTitlewithCalendar:(NSCalendar *)calendar;
//-(void)ChangeView:(BOOL)up;
@end
