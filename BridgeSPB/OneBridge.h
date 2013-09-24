//
//  OneBridge.h
//  BridgeSPB
//
//  Created by Stas on 07.03.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "time.h"
@interface OneBridge : UIImageView

@property (nonatomic) CGPoint location;
@property (nonatomic) CGPoint coord;
@property (nonatomic,strong) UIImage * imageForTitle;
@property (nonatomic,strong) NSString * imageBackGr;
@property (nonatomic,strong) NSString * bridgeGraph;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * info;
@property (nonatomic,strong) NSString * moreinfo;
@property (nonatomic,strong) Mytime *time1;
@property (nonatomic,strong) Mytime *time2;

@property (nonatomic) BOOL statys;

-(BOOL)OpenWithHour:(NSInteger)hour andMin:(NSInteger)min;
-(NSInteger)timeToCloseWithHour:(NSInteger)hour andMin:(NSInteger)min;
-(NSInteger)timeToOpenWithHour:(NSInteger)hour andMin:(NSInteger)min;
@end
