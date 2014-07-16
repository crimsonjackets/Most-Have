//
//  MHBridgeTableViewCell.h
//  Most Have
//
//  Created by Max on 15.07.14.
//  Copyright (c) 2014 Stas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHBridgeTimeLineView.h"

@interface MHBridgeTableViewCell : UITableViewCell
@property(nonatomic, strong) IBOutlet UIImageView *imageView;
@property(nonatomic, strong) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) IBOutlet MHBridgeTimeLineView *timeLine;
@end
