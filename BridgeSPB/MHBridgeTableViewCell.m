//
//  MHBridgeTableViewCell.m
//  Most Have
//
//  Created by Max on 15.07.14.
//  Copyright (c) 2014 Stas. All rights reserved.
//

#import "MHBridgeTableViewCell.h"

@implementation MHBridgeTableViewCell
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
