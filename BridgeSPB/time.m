//
//  time.m
//  BridgeSPB
//
//  Created by Stas on 12.03.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import "time.h"

@implementation Mytime

@synthesize hourClose,hourOpen,minClose,minOpen,hourClS,hourOpS,minClS,minOpS;

+(Mytime*)MakeTimeWithHourOP:(NSInteger)hourOP minOP:(NSInteger)minOP hourCl:(NSInteger)hourCl minCl:(NSInteger)minCL
{
    Mytime *time=[self new];
    if(hourOP<10)
        time.hourOpS=@"0";
    else
        time.hourOpS=@"";
    if(minOP<10)
        time.minOpS=@"0";
    else
        time.minOpS=@"";
    if(hourCl<10)
        time.hourClS=@"0";
    else
        time.hourClS=@"";
    if(minCL<10)
        time.minClS=@"0";
    else
        time.minClS=@"";
    time.hourOpen=hourOP;
    time.minOpen=minOP;
    time.minClose=minCL;
    time.hourClose=hourCl;
    return time;
}
+(Mytime*)MAkeTimeWIthOpenTime:(NSInteger) openTime andCloseTime:(NSInteger) closeTime
{
    return [self MakeTimeWithHourOP:closeTime / 60 minOP: closeTime % 60 hourCl:openTime / 60 minCl:openTime % 60];
}



-(void) encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeInteger:hourClose forKey:@"hourClose"];
    [aCoder encodeInteger:minClose forKey:@"minClose"];
    [aCoder encodeInteger:hourOpen forKey:@"hourOpen"];
    [aCoder encodeInteger:minOpen forKey:@"minOpen"];
    [aCoder encodeObject:hourOpS forKey:@"hourOpS"];
    [aCoder encodeObject:minOpS forKey:@"minOpS"];
    [aCoder encodeObject:hourClS forKey:@"hourClS"];
    [aCoder encodeObject:minClS forKey:@"minClS"];
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.hourClose = [aDecoder decodeIntegerForKey:@"hourClose"];
        self.minClose = [aDecoder decodeIntegerForKey:@"minClose"];
        self.hourOpen = [aDecoder decodeIntegerForKey:@"hourOpen"];
        self.minOpen = [aDecoder decodeIntegerForKey:@"minOpen"];
        self.hourOpS = [aDecoder decodeObjectForKey:@"hourOpS"];
        self.minOpS = [aDecoder decodeObjectForKey:@"minOpS"];
        self.hourClS = [aDecoder decodeObjectForKey:@"hourClS"];
        self.minClS = [aDecoder decodeObjectForKey:@"minClS"];
    }
    return self;
}

@end
