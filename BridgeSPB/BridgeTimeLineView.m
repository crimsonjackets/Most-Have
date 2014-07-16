//
//  BridgeTimeLineView.m
//  BridgeTable
//
//  Created by Алексей on 09.07.14.
//  Copyright (c) 2014 Алексей. All rights reserved.
//

#import "BridgeTimeLineView.h"


@interface BridgeTimeLineView()
@property(nonatomic, strong) NSString *state; // state for scaling; @"small" @"big" @"leftBig" @"rightBig"
@property(nonatomic, readwrite) CGFloat lineX;
@property(nonatomic, readwrite) CGFloat lineY;
@property(nonatomic, readwrite) CGFloat start;
@property(nonatomic, readwrite) CGFloat end;


@end


@implementation BridgeTimeLineView
@synthesize state;
@synthesize lineX;
@synthesize lineY;
@synthesize bridgeOpen;
@synthesize bridgeOpen2;
@synthesize bridgeClose;
@synthesize bridgeClose2;
@synthesize bridgeIsOpenedTwoTimes;
@synthesize start;
@synthesize end;
@synthesize progress;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self performInitializations];
        
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self){
        [self performInitializations];
    }
    return self;
}


- (void) performInitializations
{
    self.state = @"small";
    self.lineX = 0.0f;
    self.lineY = 20.0f;
    self.start = 60.0f;//minutes
    self.end  = 360.0f;//minutes
    self.bridgeOpen = 85.0f;//minutes
    self.bridgeClose = 170.0f;//minutes
    self.bridgeOpen2 = 190.0f;//minutes
    self.bridgeClose2 = 345.0f;//minutes
    self.bridgeIsOpenedTwoTimes = YES;
}

- (NSString *)makeTimeString:(CGFloat)time
{
    NSInteger hours = (int) time / 60;
    NSInteger minutes = (int) time % 60;
    NSString *minutesStr;
    if (minutes < 10){
        minutesStr = [NSString  stringWithFormat:@"0%d", minutes];
    } else {
        minutesStr = [NSString  stringWithFormat:@"%d", minutes];
    }
    return [NSString stringWithFormat:@"%d:%@",hours,minutesStr];
    
}

- (void) drawSection:(CGContextRef) context fromX:(CGFloat) x1 toX:(CGFloat) x2 withOpenTime:(CGFloat) timeOpen andCloseTime: (CGFloat) timeClose
            fontSize:(CGFloat) fontSize isLeftSection:(BOOL) isLeftSection
{
    CGContextSetAlpha(context, 1.0);
    
    CGFloat openSybmolSize = 8.0f;
    UIFont *font = [UIFont boldSystemFontOfSize: fontSize];//[UIFont fontWithName:@"Thonburi-Bold" size: fontSize];
    NSMutableDictionary  *attributes = [[NSMutableDictionary alloc]  init];
    [attributes setValue:font forKey:NSFontAttributeName];
    
    CGFloat lineWidth = 3.0f;
    
    CGFloat lineLength = self.bounds.size.width - self.lineX * 2;//280.0f; // points
    CGFloat bridgeOpenPointX = (timeOpen - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
    CGFloat bridgeClosePointX = (timeClose - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
    
    if ([self.state  isEqualToString: @"big"]){
        bridgeOpenPointX =  (70 - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
        bridgeClosePointX = (320 - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
    }
    
    if ([self.state  isEqualToString: @"leftBig"]){
        if (isLeftSection){
            bridgeOpenPointX =  (70 - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
            bridgeClosePointX = (200 - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
        } else {
            bridgeOpenPointX =  (270 - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
            bridgeClosePointX = (330 - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
        }
    }
    if ([self.state  isEqualToString: @"rightBig"]){
        if (isLeftSection){
            bridgeOpenPointX =  (70 - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
            bridgeClosePointX = (120 - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
        } else {
            bridgeOpenPointX =  (170 - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
            bridgeClosePointX = (320 - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
        }
    }
    
    //line while open
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextMoveToPoint(context, bridgeOpenPointX, self.lineY);
    CGContextAddLineToPoint(context, bridgeClosePointX, self.lineY);
    CGContextStrokePath(context);
    
    
    //line before open
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextMoveToPoint(context, x1, self.lineY);
    CGContextAddLineToPoint(context, bridgeOpenPointX, self.lineY);
    CGContextStrokePath(context);
    
    // Open bridge symbol
    CGContextSetLineWidth(context, lineWidth);
    if (self.progress  > timeOpen){
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    } else {
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    }
    CGContextMoveToPoint(context, bridgeOpenPointX, self.lineY);
    CGContextAddLineToPoint(context, bridgeOpenPointX + openSybmolSize, self.lineY - openSybmolSize);
    CGContextStrokePath(context);
    
    
    //Close bridge symbol
    CGContextSetLineWidth(context, lineWidth);
    if (self.progress  > timeClose){
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    } else {
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    }
    CGContextMoveToPoint(context, bridgeClosePointX - openSybmolSize, self.lineY - openSybmolSize);
    CGContextAddLineToPoint(context, bridgeClosePointX, self.lineY);
    CGContextStrokePath(context);
    
    //line after close
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextMoveToPoint(context, bridgeClosePointX, self.lineY);
    CGContextAddLineToPoint(context, x2, self.lineY);
    CGContextStrokePath(context);
    
    
    //draw open/close times
    //if ([self.state  isEqualToString: @"small"]){
        if (self.progress > timeOpen){
            [attributes setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
        } else {
            [attributes setValue:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        }
        
        
        NSString *openTime = [self makeTimeString: timeOpen];
        [openTime drawAtPoint:CGPointMake(bridgeOpenPointX + openSybmolSize + 1.0f, self.lineY - fontSize - 2.0f) withAttributes: attributes];
        
        if (self.progress > timeClose){
            [attributes setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
        } else {
            [attributes setValue:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        }
        
        NSString *closeTime = [self makeTimeString: timeClose];
        if (timeClose > 330 || timeClose == 170 || timeClose == 165) {
            [closeTime drawAtPoint:CGPointMake(bridgeClosePointX - 34.0f, self.lineY - fontSize - 2.0f) withAttributes: attributes];
            
        } else {
            [closeTime drawAtPoint:CGPointMake(bridgeClosePointX, self.lineY - fontSize - 2.0f) withAttributes: attributes];
        }
    //}
    /*
    if ([self.state  isEqualToString: @"big"]){
        if (self.progress > timeOpen){
            [attributes setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
        } else {
            [attributes setValue:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        }
        
        
        NSString *openTime = [self makeTimeString: timeOpen];
        [openTime drawAtPoint:CGPointMake(bridgeOpenPointX + openSybmolSize + 1.0f, self.lineY - fontSize - 2.0f) withAttributes: attributes];
        
        if (self.progress > timeClose){
            [attributes setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
        } else {
            [attributes setValue:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        }
        
        NSString *closeTime = [self makeTimeString: timeClose];
        [closeTime drawAtPoint:CGPointMake(bridgeClosePointX, self.lineY - fontSize - 2.0f) withAttributes: attributes];
        
    }
    
    
    
    if ([self.state  isEqualToString: @"leftBig"]){
        
        if (self.progress > timeOpen){
            [attributes setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
        } else {
            [attributes setValue:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        }
        
        NSString *openTime = [self makeTimeString: timeOpen];
        [openTime drawAtPoint:CGPointMake(bridgeOpenPointX + openSybmolSize + 1.0f, self.lineY - fontSize - 2.0f) withAttributes: attributes];
        
        if (progress > timeClose){
            [attributes setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
        } else {
            [attributes setValue:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        }
        
        NSString *closeTime = [self makeTimeString: timeClose];
        [closeTime drawAtPoint:CGPointMake(bridgeClosePointX, self.lineY - fontSize- 2.0f) withAttributes: attributes];
    }
    if ([self.state  isEqualToString: @"rightBig"]){
        
        if (self.progress > timeOpen){
            [attributes setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
        } else {
            [attributes setValue:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        }
        
        NSString *openTime = [self makeTimeString: timeOpen];
        [openTime drawAtPoint:CGPointMake(bridgeOpenPointX + openSybmolSize + 1.0f, self.lineY - fontSize- 2.0f) withAttributes: attributes];
        
        if (self.progress > timeClose){
            [attributes setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
        } else {
            [attributes setValue:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        }
        
        NSString *closeTime = [self makeTimeString: timeClose];
        [closeTime drawAtPoint:CGPointMake(bridgeClosePointX, self.lineY - fontSize- 2.0f) withAttributes: attributes];
    }
     */
    
}

/*
- (void) changeStateToSmall{
    self.state = @"small";
    [self setNeedsDisplay];
}

- (void) changeState:(CGFloat) touchPointX
{
    touchPointX -= 20;
    if(self.bridgeIsOpenedTwoTimes){
        CGFloat lineLength = self.bounds.size.width - self.lineX * 2;//280.0f; // points
        CGFloat bridgeClosePointX = (self.bridgeClose - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
        CGFloat bridgeOpen2PointX =  (self.bridgeOpen2 - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
        CGFloat bridgeMiddlePointX = (bridgeClosePointX + bridgeOpen2PointX) / 2.0f; //points
        NSLog(@"closeX = %f openX = %f middleX = %f", bridgeClosePointX, bridgeOpen2PointX, bridgeMiddlePointX);
        if ([self.state isEqualToString:@"leftBig"]){
            bridgeMiddlePointX = (240 - self.start) / (self.end - self.start) * lineLength + self.lineX;
        }
        if ([self.state isEqualToString:@"rightBig"]){
            bridgeMiddlePointX = (140 - self.start) / (self.end - self.start) * lineLength + self.lineX;
        }
        
        if (touchPointX < bridgeMiddlePointX) {
            if([self.state isEqualToString:@"leftBig"]){
                self.state = @"small";
            }else{
                self.state = @"leftBig";
            }
        }  else {
            if ([self.state isEqualToString:@"rightBig"]){
                self.state = @"small";
            }else{
                self.state = @"rightBig";
            }
        }
        NSLog(@"State changed to %@", self.state);
        
    } else {
        if ([self.state  isEqual: @"small"]){
            self.state = @"big";
        } else {
            self.state = @"small";
        }
        
    }
    [self  setNeedsDisplay];
    
}
*/

- (void) drawProgress:(CGContextRef) context value:(CGFloat) timeNow lineLength:(CGFloat) lineLength
{
    CGFloat lineWidth = 3.0f;
    NSLog(@"Progress == %f", timeNow);
    //time in minutes
    if (timeNow > self.start && timeNow < self.end){
        CGContextSetLineWidth(context, lineWidth);
        CGContextSetAlpha(context, 0.85f); //alpha
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextMoveToPoint(context, self.lineX, self.lineY);
        CGFloat timePointX = (timeNow - self.start) / (self.end -  self.start) * lineLength + self.lineX;
        CGContextAddLineToPoint(context, timePointX, self.lineY);
        CGContextStrokePath(context);
        /*
        //vertical line
        CGContextSetLineWidth(context, lineWidth / 2.0);
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextMoveToPoint(context, timePointX, lineY - 5.0);
        CGContextAddLineToPoint(context, timePointX, lineY + 5.0);
        CGContextStrokePath(context);
        */
        
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, 1.0f);
    
    NSLog(@"bridgeOpen = %f",self.bridgeOpen);
    CGFloat lineLength = self.bounds.size.width - self.lineX * 2;//280.0f; // points
    
    CGFloat progressValue = self.progress; //minutes
    CGFloat bridgeOpenPointX =  (self.bridgeOpen - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
    CGFloat bridgeClosePointX = (self.bridgeClose - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
    
    CGFloat bridgeOpen2PointX =  (self.bridgeOpen2 - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
    CGFloat bridgeClose2PointX = (self.bridgeClose2 - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
    CGFloat bridgeMiddlePointX = (bridgeClosePointX + bridgeOpen2PointX) / 2.0f; //points
    
    /*
    //scale
    CGFloat scaleHeight = 8.0f;
    CGContextSetLineWidth(context, 1.0f);
    for (int i = 60; i <= 360; i += 60){
        CGFloat pointX = ((CGFloat) i - 60.0f) / (300.0f) * lineLength + lineX; //points
        CGContextMoveToPoint(context, pointX, lineY - scaleHeight / 2.0f);
        CGContextAddLineToPoint(context, pointX, lineY + scaleHeight / 2.0f);
        
        if (self.progress > i){
            CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
            
        } else {
            CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
            
        }
        CGContextStrokePath(context);
    }
    */
    
    //if ([self.state  isEqual: @"small"]){
        if (!bridgeIsOpenedTwoTimes){
            [self drawSection:context fromX:self.lineX toX:lineLength withOpenTime:self.bridgeOpen andCloseTime:self.bridgeClose
                     fontSize:13.0f isLeftSection:NO];
        }else{
            [self drawSection:context fromX:self.lineX toX:bridgeMiddlePointX withOpenTime:self.bridgeOpen andCloseTime:self.bridgeClose
                     fontSize:13.0f isLeftSection:YES];
            [self drawSection:context fromX:bridgeMiddlePointX toX:lineLength + self.lineX withOpenTime:self.bridgeOpen2 andCloseTime:self.bridgeClose2 fontSize:13.0f isLeftSection:NO];
        }
        //progress bar
        [self drawProgress:context value:progressValue lineLength:lineLength];
   // }
    /*
    if ([self.state  isEqual: @"big"]){
        if (progressValue <= self.bridgeOpen){
            progressValue = (progressValue - self.start) * 10.0f / (self.bridgeOpen - self.start) + self.start;
        } else
            if (progressValue <= self.bridgeClose){
                progressValue = (progressValue - self.bridgeOpen) * 250.0f / (self.bridgeClose - self.bridgeOpen) + 70.0f;
            } else
                if (progressValue <= 360.0f){
                    progressValue = (progressValue - self.bridgeClose) * 40.0f / (360.0f - self.bridgeClose) + 320.0f;
                }
        
        [self drawSection:context fromX:self.lineX toX:lineLength withOpenTime:self.bridgeOpen andCloseTime:self.bridgeClose
                 fontSize:17.0f isLeftSection:NO];
        
        //progress bar
        [self drawProgress:context value:progressValue lineLength:lineLength];
    }
    
    if ([self.state  isEqual: @"leftBig"] && self.bridgeIsOpenedTwoTimes){

        //count progressValue
        CGFloat bridgeMiddle = (self.bridgeOpen2 + self.bridgeClose) / 2.0f;
        NSLog(@"Bridge Middle = %f", bridgeMiddle);
        if (progressValue <= self.bridgeOpen){
            progressValue = (progressValue - self.start) * 10.0f / (self.bridgeOpen - self.start) + self.start;
        } else
            if (progressValue <= self.bridgeClose){
                progressValue = (progressValue - self.bridgeOpen) * 130.0f / (self.bridgeClose - self.bridgeOpen) + 70.0f;
            } else
                if (progressValue <= bridgeMiddle){
                    progressValue = (progressValue - self.bridgeClose) * 40.0f / (bridgeMiddle - self.bridgeClose) + 200.0f;
                } else
                    if (progressValue <= self.bridgeOpen2){
                        progressValue = (progressValue - bridgeMiddle) * 30.0f / (self.bridgeOpen2 - bridgeMiddle) + 240.0f;
                    } else
                        if (progressValue <= self.bridgeClose2){
                            progressValue = (progressValue - self.bridgeOpen2) * 60.0f / (self.bridgeClose2 - self.bridgeOpen2) + 270.0f;
                        } else
                            if (progressValue <= 360.0f){
                                progressValue = (progressValue - self.bridgeClose2) * 30.0f / (360.0f - self.bridgeClose2) + 330.0f;
                            }
        
        
        bridgeMiddlePointX = (240 - self.start) / (self.end - self.start) * lineLength + self.lineX;
        [self drawSection:context fromX:self.lineX toX:bridgeMiddlePointX withOpenTime:self.bridgeOpen andCloseTime:self.bridgeClose fontSize:17.0f isLeftSection:YES];
        [self drawSection:context fromX:bridgeMiddlePointX toX:lineLength + self.lineX withOpenTime:self.bridgeOpen2 andCloseTime:self.bridgeClose2 fontSize:11.0f isLeftSection:NO];
        //progress bar
        [self drawProgress:context value:progressValue lineLength:lineLength];
        NSLog(@"Left is drawn");
    }
    if ([self.state  isEqual: @"rightBig"] && self.bridgeIsOpenedTwoTimes){
        
        //count progressValue
        CGFloat bridgeMiddle = (self.bridgeOpen2 + self.bridgeClose) / 2.0f;
        NSLog(@"Bridge Middle = %f", bridgeMiddle);
        if (progressValue <= self.bridgeOpen){
            progressValue = (progressValue - self.start) * 10.0f / (self.bridgeOpen - self.start) + self.start;
        } else
            if (progressValue <= self.bridgeClose){
                progressValue = (progressValue - self.bridgeOpen) * 50.0f / (self.bridgeClose - self.bridgeOpen) + 70.0f;
            } else
                if (progressValue <= bridgeMiddle){
                    progressValue = (progressValue - self.bridgeClose) * 20.0f / (bridgeMiddle - self.bridgeClose) + 120.0f;
                } else
                    if (progressValue <= self.bridgeOpen2){
                        progressValue = (progressValue - bridgeMiddle) * 30.0f / (self.bridgeOpen2 - bridgeMiddle) + 140.0f;
                    } else
                        if (progressValue <= self.bridgeClose2){
                            progressValue = (progressValue - self.bridgeOpen2) * 150.0f / (self.bridgeClose2 - self.bridgeOpen2) + 170.0f;
                        } else
                            if (progressValue <= 360.0f){
                                progressValue = (progressValue - self.bridgeClose2) * 40.0f / (360.0f - self.bridgeClose2) + 320.0f;
                            }
        
        bridgeMiddlePointX = (140 - self.start) / (self.end - self.start) * lineLength + self.lineX;
        [self drawSection:context fromX:self.lineX toX:bridgeMiddlePointX withOpenTime:self.bridgeOpen
             andCloseTime:self.bridgeClose fontSize:11.0f isLeftSection:YES];
        [self drawSection:context fromX:bridgeMiddlePointX toX:lineLength + self.lineX withOpenTime:self.bridgeOpen2 andCloseTime:self.bridgeClose2 fontSize:17.0f isLeftSection:NO];
        //progress bar
        [self drawProgress:context value:progressValue lineLength:lineLength];
        NSLog(@"Right is drawn");
        
    }
    */
    
    NSLog(@"Width = %f; Height = %f\n", self.bounds.size.width, self.bounds.size.height);
}


@end
