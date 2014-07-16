//
//  BridgeTableViewCell.h
//  BridgeTable
//
//  Created by Алексей on 09.07.14.
//  Copyright (c) 2014 Алексей. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BridgeTimeLineView.h"

@interface BridgeTableViewCell : UITableViewCell
@property(nonatomic, strong) IBOutlet UIImageView *imageView;
@property(nonatomic, strong) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) IBOutlet BridgeTimeLineView *timeLine;

@end
