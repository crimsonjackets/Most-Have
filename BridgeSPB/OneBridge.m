//
//  OneBridge.m
//  BridgeSPB
//
//  Created by Stas on 07.03.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import "OneBridge.h"

@implementation OneBridge
@synthesize location,imageForTitle,imageBackGr,name,info,statys,coord,time1,time2,moreinfo,bridgeGraph;

-(NSInteger)convertHour:(NSInteger)hour andMin:(NSInteger)min
{
    return hour*60+min;
}
-(BOOL)OpenWithHour:(NSInteger)hour andMin:(NSInteger)min
{
    NSInteger minCur=[self convertHour:hour andMin:min];
    NSInteger minOp=[self convertHour:time1.hourOpen andMin:time1.minOpen];
    NSInteger minCl=[self convertHour:time1.hourClose andMin:time1.minClose];
    NSInteger minOp1=[self convertHour:time2.hourOpen andMin:time2.minOpen];
    NSInteger minCl1=[self convertHour:time2.hourClose andMin:time2.minClose];
    if((minCl<=minCur && minOp>=minCur)||(minCl1<=minCur && minOp1>=minCur))
    {
        return NO;
    }
    return YES;
}
-(NSInteger)timeToCloseWithHour:(NSInteger)hour andMin:(NSInteger)min
{
    NSInteger minCur=[self convertHour:hour andMin:min];
    NSInteger minCl=[self convertHour:time1.hourClose andMin:time1.minClose];
    NSInteger minCl1=[self convertHour:time2.hourClose andMin:time2.minClose];
    if(minCl>minCur)
    {
        return minCl-minCur;
    }
    else
    {
        return minCl1-minCur;
    }
    return -1;
}
-(NSInteger)timeToOpenWithHour:(NSInteger)hour andMin:(NSInteger)min
{
    NSInteger minCur=[self convertHour:hour andMin:min];
    NSInteger minOp=[self convertHour:time1.hourOpen andMin:time1.minOpen];
    NSInteger minOp1=[self convertHour:time2.hourOpen andMin:time2.minOpen];
    if(minOp>minCur)
    {
        return minOp-minCur;
    }
    else
    {
        return minOp1-minCur;
    }
    return -1;
}

@end
