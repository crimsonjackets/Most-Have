//
//  BRPushCell.m
//  BridgeSPB
//
//  Created by Stas on 12.04.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import "BRPushCell.h"

@implementation BRPushCell

@synthesize timePush;
@synthesize infoPush;

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
