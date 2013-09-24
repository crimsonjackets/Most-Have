//
//  pushBut.m
//  BridgeSPB
//
//  Created by Stas on 10.04.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import "pushBut.h"

@implementation pushBut

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)viewDidLoad
{
    [self setImage:[UIImage imageNamed:@"buttonImage.png"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"buttonImageBackrgound.png"] forState:UIControlStateNormal];
    [self setTitle:@"Hello" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self addTarget:self action:@selector(pressBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)drawRect:(CGRect)rect
{


}


@end
