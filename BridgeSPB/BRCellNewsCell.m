//
//  BRCellNewsCell.m
//  BridgeSPB
//
//  Created by Stas on 11.04.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import "BRCellNewsCell.h"

@implementation BRCellNewsCell

@synthesize timeNews;
@synthesize titleNews;
@synthesize infoNews;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
