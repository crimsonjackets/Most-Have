//
//  BRAppHelpers.m
//  BridgeSPB
//
//  Created by Stas on 02.04.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import "BRAppHelpers.h"
#import "time.h"

@implementation BRAppHelpers




+ (UIView*)addHeadonView:(UIView*)myView andImages:(NSArray*)imageArray withTarget:(id)target
{
    
    [[NSNotificationCenter defaultCenter] addObserver:target
                                             selector:@selector(goToPush)
                                                 name:@"getPush"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:target
                                             selector:@selector(updateStuff)
                                                 name:@"appDidBecomeActive"
                                               object:nil];
    UIButton * butOpCl=[[UIButton alloc]initWithFrame:CGRectMake(255, 5, 50, 40)];

    [butOpCl addTarget:target action:@selector(hideBridge:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:butOpCl];
    
    UIImageView *leftImage=[imageArray objectAtIndex:1];
    UIButton * leftBut=[[UIButton alloc]initWithFrame:CGRectMake(1, 1, 50, 50)];

    leftImage.image=[UIImage imageNamed:@"leftbut.png"];
    [leftBut addTarget:target action:@selector(leftMenu:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:leftImage];
    [myView addSubview:leftBut];
    UIImageView *rightImage=[imageArray objectAtIndex:0];
    rightImage.image=[UIImage imageNamed:@"butOpen.png"];
    [myView addSubview:rightImage];
    
    UIButton * backBut=[[UIButton alloc]initWithFrame:CGRectMake(110, 20, 100, 31)];
    [backBut addTarget:target action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:backBut];
    
    return myView;
}

+(NSString *) archivePaths{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return [path stringByAppendingPathComponent:@"times.archive"];
}

+ (NSString *)archivePathForGraphics
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return [path stringByAppendingPathComponent:@"graphic.archive"];
}

-(void)parsRSSBridge
{
    NSURL *url = [NSURL URLWithString:@"http://crimsonjackets.ru/mosthave/feed.rss"];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        rssData = [NSMutableData data];
        
    } 
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [rssData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSXMLParser *rssParser = [[NSXMLParser alloc] initWithData:rssData];
    rssParser.delegate = self;
    
    [rssParser parse];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    [parser abortParsing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict  {
    // NSLog(@"%@",elementName);
    //    if ([elementName isEqualToString:@"enclosure"])
    //    {
    //        NSString *url = [attributeDict objectForKey:@"url"];
    //        NSLog(@"%@",url);
    //    }
    currentElement = elementName;
    if ([elementName isEqualToString:@"item"]) {
        currentTitle = [NSMutableString string];
        pubDate = [NSMutableString string];
        infoNew = [NSMutableString string];
        newGraphic = [NSMutableString string];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    //  NSLog(@"gfhfhf%@",string);
    //   NSLog(@"%@ %@",currentElement,string);
    if ([currentElement isEqualToString:@"url"]) {
        
        [newGraphic appendString:string];
    }
    if ([currentElement isEqualToString:@"title"]) {
		[currentTitle appendString:string];
	} else if ([currentElement isEqualToString:@"pubDate"]) {
		[pubDate appendString:string];
    }else if ([currentElement isEqualToString:@"description"]) {
		[infoNew appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
       // NSLog(@"%@ - newGraphic",newGraphic);
        if([currentTitle hasPrefix:@"change"])
        {
            if([newGraphic length]>1)
            {
                newGraphic=[newGraphic stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
             //   newGraphic = [newGraphic stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSURL *url=[NSURL URLWithString:newGraphic];
                NSData *data = [NSData dataWithContentsOfURL : url];
                UIImage *image = [UIImage imageWithData: data];
                [NSKeyedArchiver archiveRootObject:image
                                            toFile:[BRAppHelpers archivePathForGraphics]];
               // NSLog(@"%@ - newGraphic",url);
                //[standardUserDefaults synchronize];
            }
            
            
            NSInteger index = [[currentTitle substringWithRange:NSMakeRange(6, 1)] integerValue];
            
            NSInteger count = [[currentTitle substringWithRange:NSMakeRange(7, 1)] integerValue];
            
            
            NSMutableArray *myTimes = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:[BRAppHelpers archivePaths]]];
            
            NSMutableArray *time1=[NSMutableArray arrayWithArray: myTimes[0]];
            NSInteger newTimeStr1=[[currentTitle substringWithRange:NSMakeRange(8, 4)] integerValue];
            NSInteger newTimeStr2=[[currentTitle substringWithRange:NSMakeRange(12, 4)] integerValue];

            Mytime *newTime1=[Mytime MakeTimeWithHourOP:newTimeStr2/100 minOP:newTimeStr2%100 hourCl:newTimeStr1/100 minCl:(newTimeStr1%100)];
            [time1 replaceObjectAtIndex:index withObject:newTime1];
            [myTimes replaceObjectAtIndex:0 withObject:time1];
            if(count>1)
            {
                //NSLog(@"%i",count);
                NSMutableArray *time2=[NSMutableArray arrayWithArray: myTimes[1]];
                newTimeStr1=[[currentTitle substringWithRange:NSMakeRange(16, 4)] integerValue];
                newTimeStr2=[[currentTitle substringWithRange:NSMakeRange(20, 4)] integerValue];
                Mytime *newTime2=[Mytime MakeTimeWithHourOP:newTimeStr2/100 minOP:newTimeStr2%100 hourCl:newTimeStr1/100 minCl:(newTimeStr1%100)];
                [time2 replaceObjectAtIndex:index withObject:newTime2];
                [myTimes replaceObjectAtIndex:1 withObject:time2];
            }
            else
            {
                NSMutableArray *time2=[NSMutableArray arrayWithArray: myTimes[1]];

                [time2 replaceObjectAtIndex:index withObject:newTime1];
                [myTimes replaceObjectAtIndex:1 withObject:time2];
            }
            
            
            [NSKeyedArchiver archiveRootObject:myTimes
                                        toFile:[BRAppHelpers archivePaths]];
      //      NSLog(@"change it!, %i",index);
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
           // [parser abortParsing];
        }
        currentTitle = nil;
        pubDate = nil;
        currentElement = nil;
        infoNew = nil;
        newGraphic=nil;
    }

}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    


}

@end
