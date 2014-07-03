//
//  BRCellNewsCell.h
//  BridgeSPB
//
//  Created by Stas on 11.04.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRCellNewsCell : UITableViewCell
{
    UILabel *titleNews;
    UILabel *timeNews;
    UITextView *infoNews;
}
@property (nonatomic, strong) IBOutlet UILabel *titleNews;
@property (nonatomic, strong) IBOutlet UILabel *timeNews;
@property (strong, nonatomic) IBOutlet UITextView *infoNews;

@end
