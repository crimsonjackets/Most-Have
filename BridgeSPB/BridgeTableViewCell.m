//
//  BridgeTableViewCell.m
//  BridgeTable
//
//  Created by Алексей on 09.07.14.
//  Copyright (c) 2014 Алексей. All rights reserved.
//

#import "BridgeTableViewCell.h"

@implementation BridgeTableViewCell
@synthesize imageView;
@synthesize nameLabel;
@synthesize timeLine;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
