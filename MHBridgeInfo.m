//
//  MHBridgeInfo.m
//  Most Have
//
//  Created by Max on 15.07.14.
//  Copyright (c) 2014 Stas. All rights reserved.
//

#import "MHBridgeInfo.h"

NSString *const kIsOpenedTwoTimesKey = @"isOpenedTwoTimes";
NSString *const kOpenTimeKey = @"openTime";
NSString *const kOpenTime2Key = @"openTime2";
NSString *const kCloseTimeKey = @"closeTime";
NSString *const kCloseTime2Key = @"closeTime2";
NSString *const kNameKey = @"name";

@implementation MHBridgeInfo
@synthesize isOpenedTwoTimes;
@synthesize name;
@synthesize openTime;
@synthesize closeTime;
@synthesize openTime2;
@synthesize closeTime2;


- (id) initOnlyWithName: (NSString *) newName{
    self = [super init];
    if (self != nil){
        self.name = newName;
    }
    return self;
}

- (id) initWithName:(NSString *) newName andOpenTime:(CGFloat) newOpenTime andCloseTime:(CGFloat) newCloseTime andIsOpenedTwoTimes:(BOOL) flag andOpenTime2:(CGFloat) newOpenTime2 andCloseTime2:(CGFloat) newCloseTime2 {
    self = [super init];
    if (self != nil){
        self.name = newName;
        self.openTime = newOpenTime;
        self.closeTime = newCloseTime;
        self.isOpenedTwoTimes = flag;
        if (flag){
            self.openTime2 = newOpenTime2;
            self.closeTime2 = newCloseTime2;
        }
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeBool:self.isOpenedTwoTimes forKey:kIsOpenedTwoTimesKey];
    [aCoder encodeFloat: self.openTime forKey:kOpenTimeKey];
    [aCoder encodeFloat: self.openTime2 forKey:kOpenTime2Key];
    [aCoder encodeFloat: self.closeTime forKey:kCloseTimeKey];
    [aCoder encodeFloat: self.closeTime2 forKey:kCloseTime2Key];
    [aCoder encodeObject:self.name forKey:kNameKey];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self != nil){
        self.isOpenedTwoTimes = [aDecoder decodeBoolForKey:kIsOpenedTwoTimesKey];
        self.openTime = [aDecoder decodeFloatForKey:kOpenTimeKey];
        self.openTime2 = [aDecoder decodeFloatForKey:kOpenTime2Key];
        self.closeTime = [aDecoder decodeFloatForKey:kCloseTimeKey];
        self.closeTime2 = [aDecoder decodeFloatForKey:kCloseTime2Key];
        self.name = [aDecoder decodeObjectForKey:kNameKey];
    }
    return self;
}

@end
