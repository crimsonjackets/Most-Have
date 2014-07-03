//
//  BRNewsViewController.h
//  BridgeSPB
//
//  Created by Stas on 09.04.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "Bridge.h"
#import "BRBridgeViewController.h"
#import "BRCellNewsCell.h"

@interface BRNewsViewController : UIViewController<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate> {
    NSMutableData *rssData;
    NSMutableArray *news;
    NSString * currentElement;
    NSMutableString *currentTitle;
    NSMutableString *pubDate;
}



@property (nonatomic, strong) Bridge * bridges;
@property (nonatomic, retain) NSMutableData *rssData;
@property (nonatomic, retain) NSArray *news;
@property (nonatomic, retain) NSString * currentElement;
@property (nonatomic, retain) NSMutableString *currentTitle;
@property (nonatomic, retain) NSMutableString *pubDate;
@property (nonatomic, retain) NSMutableString *infoNew;
@property (weak, nonatomic) IBOutlet UIImageView *lineSep;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
