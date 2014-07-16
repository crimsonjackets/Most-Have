//
//  MHBridgeInfo.h
//  Most Have
//
//  Created by Max on 15.07.14.
//  Copyright (c) 2014 Stas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHBridgeInfo : NSObject <NSCoding>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, readwrite) BOOL isOpenedTwoTimes;
@property (nonatomic, readwrite) CGFloat openTime; // minutes;
@property (nonatomic, readwrite) CGFloat closeTime; // minutes;
@property (nonatomic, readwrite) CGFloat openTime2; // minutes;
@property (nonatomic, readwrite) CGFloat closeTime2; // minutes;


- (id) initOnlyWithName:(NSString *) newName;
- (id) initWithName:(NSString *) newName andOpenTime:(CGFloat) newOpenTime andCloseTime:(CGFloat) newCloseTime andIsOpenedTwoTimes:(BOOL) flag andOpenTime2:(CGFloat) newOpenTime2 andCloseTime2:(CGFloat) newCloseTime2;
@end
