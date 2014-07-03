//
//  BRPushCell.h
//  BridgeSPB
//
//  Created by Stas on 12.04.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRPushCell : UITableViewCell
{
    UILabel *timePush;
    UITextView *infoPush;
}

@property (nonatomic, strong) IBOutlet UILabel *timePush;
@property (strong, nonatomic) IBOutlet UITextView *infoPush;
@end
