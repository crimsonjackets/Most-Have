//
//  BRAppHelpers.h
//  BridgeSPB
//
//  Created by Stas on 02.04.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRAppHelpers : NSObject<NSXMLParserDelegate>
{
    NSMutableData *rssData;
    NSString * currentElement;
    NSMutableString *currentTitle;
    NSMutableString *pubDate;
    NSMutableString *infoNew;
    NSMutableString *newGraphic;
}
+ (UIView*)addHeadonView:(UIView*)myView andImages:(NSArray*)imageArray withTarget:(id)target;
+ (NSString *)archivePaths;
+ (NSString *)archivePathForGraphics;
- (void)parsRSSBridge;



@end
