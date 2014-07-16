//
//  time.h
//  BridgeSPB
//
//  Created by Stas on 12.03.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mytime : NSObject<NSCoding>

@property (nonatomic) NSInteger  hourOpen;
@property (nonatomic) NSInteger minOpen;
@property (nonatomic) NSInteger  hourClose;
@property (nonatomic) NSInteger  minClose;
@property (nonatomic,strong) NSString * hourOpS;
@property (nonatomic,strong) NSString * minOpS;
@property (nonatomic,strong) NSString * hourClS;
@property (nonatomic,strong) NSString * minClS;

+(Mytime*)MakeTimeWithHourOP:(NSInteger)hourOP minOP:(NSInteger)minOP hourCl:(NSInteger)hourCl minCl:(NSInteger)minCL;
+(Mytime*)MAkeTimeWIthOpenTime:(NSInteger) openTime andCloseTime:(NSInteger) closeTime;

@end
