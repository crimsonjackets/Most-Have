//
//  TimeLine.m
//  Most Have
//
//  Created by Max on 11.07.14.
//  Copyright (c) 2014 Max. All rights reserved.
//

#import "TimeLine.h"

@interface TimeLine()
@property(nonatomic, readwrite) CGFloat progressValue;
@end


@implementation TimeLine
@synthesize progressValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setProgress:(CGFloat) newProgressValue
{
    self.progressValue = newProgressValue;
    [self setNeedsDisplay];
}

- (void) drawProgress:(CGContextRef) context value:(CGFloat) timeNow lineLength:(CGFloat) lineLength
{
    CGFloat lineX = 20.0f;
    CGFloat lineY = 15.0f;
    CGFloat lineWidth = 2.0f;
    NSLog(@"Progress == %f", timeNow);
    //time in minutes/Users/aleksej/Documents/BridgeTable/BridgeTimeLineView.m
    if (timeNow > 60.0f && timeNow < 360.0f){
        CGContextSetLineWidth(context, lineWidth);
        CGContextSetAlpha(context, 0.8f); //alpha
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextMoveToPoint(context, lineX, lineY);
        CGFloat timePointX = (timeNow - 60.f) / (300.0f) * lineLength + lineX;
        CGContextAddLineToPoint(context, timePointX, lineY);
        CGContextStrokePath(context);
    }
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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    CGFloat fontSize = 11.0f;
    UIFont *hourFont = [UIFont boldSystemFontOfSize: fontSize];//UIFont *font = [UIFont fontWithName:@"Thonburi" size: fontSize];
    UIFont *minutesFont = [UIFont boldSystemFontOfSize: fontSize - 3];
    NSMutableDictionary  *attributes = [[NSMutableDictionary alloc]  init];
    [attributes setValue:hourFont forKey:NSFontAttributeName];
    
    CGFloat lineX = 20.0f;
    CGFloat lineY = 15.0f;
    CGFloat lineLength = self.bounds.size.width - lineX * 2; //280.0f; // points

    


    //scale and time
    CGFloat scaleHeight = 8.0f;
    CGContextSetLineWidth(context, 1.0f);
    for (int i = 60; i <= 360; i += 60){
        CGFloat pointX = ((CGFloat) i - 60.0f) / (300.0f) * lineLength + lineX; //points
        
        
        CGContextMoveToPoint(context, pointX, lineY - scaleHeight / 2.0f);
        CGContextAddLineToPoint(context, pointX , lineY + scaleHeight / 2.0f);
        
        if (self.progressValue > i){
            [attributes setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
            CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);

        } else {
            [attributes setValue:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
            CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);

        }
        
        NSString *hour = [NSString  stringWithFormat:@"%d", i / 60];
        NSString *zeros = @":00";
        [attributes setValue:hourFont forKey:NSFontAttributeName];
        if (i == 360){
            [hour drawAtPoint:CGPointMake(pointX - 20.0f, lineY - fontSize - 2.0f) withAttributes: attributes];
            [attributes setValue:minutesFont forKey:NSFontAttributeName];
            [zeros drawAtPoint:CGPointMake(pointX - 14.0f, lineY - fontSize - 2.0f) withAttributes: attributes];
            
        }else{
            [hour drawAtPoint:CGPointMake(pointX + 2.0f, lineY - fontSize - 2.0f) withAttributes: attributes];
            [attributes setValue:minutesFont forKey:NSFontAttributeName];
            [zeros drawAtPoint:CGPointMake(pointX + 8.0f, lineY - fontSize - 2.0f) withAttributes: attributes];
        }
        
        CGContextStrokePath(context);
        
    }
    
    
    //dashing line
    CGFloat lenghts[2];
    lenghts[0] = 4.0f;
    lenghts[1] = 3.0f;
    CGContextSetLineDash(context, 0, lenghts, 2);
    CGContextSetLineWidth(context, 2.0f);
    CGContextMoveToPoint(context, lineX, lineY);
    CGContextAddLineToPoint(context,lineLength + lineX, lineY);
    
    CGContextStrokePath(context);
    
    [self drawProgress:context value:progressValue lineLength:lineLength];

}


@end
