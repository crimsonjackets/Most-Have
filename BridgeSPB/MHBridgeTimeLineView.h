//
//  MHBridgeTimeLineView.h
//  Most Have
//
//  Created by Max on 15.07.14.
//  Copyright (c) 2014 Stas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHBridgeTimeLineView : UIView
@property(nonatomic, readwrite) CGFloat bridgeOpen;
@property(nonatomic, readwrite) CGFloat bridgeOpen2;
@property(nonatomic, readwrite) CGFloat bridgeClose;
@property(nonatomic, readwrite) CGFloat bridgeClose2;
@property(nonatomic, readwrite) BOOL bridgeIsOpenedTwoTimes;

@property(nonatomic, readwrite) CGFloat progress;
@end
