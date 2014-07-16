//
//  BridgeTimeLineView.h
//  BridgeTable
//
//  Created by Алексей on 09.07.14.
//  Copyright (c) 2014 Алексей. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BridgeTimeLineView : UIView

@property(nonatomic, readwrite) CGFloat bridgeOpen;
@property(nonatomic, readwrite) CGFloat bridgeOpen2;
@property(nonatomic, readwrite) CGFloat bridgeClose;
@property(nonatomic, readwrite) CGFloat bridgeClose2;
@property(nonatomic, readwrite) BOOL bridgeIsOpenedTwoTimes;

@property(nonatomic, readwrite) CGFloat progress;

/*-(void) changeState:(CGFloat) touchPointX;
-(void) changeStateToSmall;
*/
@end
