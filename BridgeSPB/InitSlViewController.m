//
//  InitSlViewController.m
//  Pesok
//
//  Created by Stas on 26.03.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import "InitSlViewController.h"

@interface InitSlViewController ()

@end

@implementation InitSlViewController
@synthesize controller;
- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *storyboard;
    storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    if([controller isEqualToString:@"PUSHTop"])
        self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"PUSHTop"];
    else
        self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"FirstTop"];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end

