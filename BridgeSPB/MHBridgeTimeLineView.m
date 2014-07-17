//
//  BridgeTimeLineView.m
//  BridgeTable
//
//  Created by Алексей on 09.07.14.
//  Copyright (c) 2014 Алексей. All rights reserved.
//

#import "MHBridgeTimeLineView.h"


@interface MHBridgeTimeLineView()
@property(nonatomic, strong) NSString *state; // state for scaling; @"small" @"big" @"leftBig" @"rightBig"
@property(nonatomic, readwrite) CGFloat lineX;
@property(nonatomic, readwrite) CGFloat lineY;
@property(nonatomic, readwrite) CGFloat start;
@property(nonatomic, readwrite) CGFloat end;


@end


@implementation MHBridgeTimeLineView
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
    if (self.progress  >= timeOpen && self.progress < 360 && self.progress > 60){
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    } else {
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    }
    CGContextMoveToPoint(context, bridgeOpenPointX, self.lineY);
    CGContextAddLineToPoint(context, bridgeOpenPointX + openSybmolSize, self.lineY - openSybmolSize);
    CGContextStrokePath(context);
    
    
    //Close bridge symbol
    CGContextSetLineWidth(context, lineWidth);
    if (self.progress  >= timeClose && self.progress < 360 && self.progress > 60){
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
    if (self.progress >= timeOpen && self.progress < 360 && self.progress > 60){
        [attributes setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    } else {
        [attributes setValue:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    }
    
    
    NSString *openTime = [self makeTimeString: timeOpen];
    [openTime drawAtPoint:CGPointMake(bridgeOpenPointX + openSybmolSize + 1.0f, self.lineY - fontSize - 2.0f) withAttributes: attributes];
    
    if (self.progress >= timeClose && self.progress < 360 && self.progress > 60){
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
    
}



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
    //CGFloat bridgeOpenPointX =  (self.bridgeOpen - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
    CGFloat bridgeClosePointX = (self.bridgeClose - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
    
    CGFloat bridgeOpen2PointX =  (self.bridgeOpen2 - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
    //CGFloat bridgeClose2PointX = (self.bridgeClose2 - self.start) / (self.end - self.start) * lineLength + self.lineX; //points
    CGFloat bridgeMiddlePointX = (bridgeClosePointX + bridgeOpen2PointX) / 2.0f; //points
    
    
    
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
    
    
    NSLog(@"Width = %f; Height = %f\n", self.bounds.size.width, self.bounds.size.height);
}


@end
