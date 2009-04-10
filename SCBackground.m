//
//  SCBackground.m
//  Showcase
//
//  Created by Julius Eckert on 05.05.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SCBackground.h"


@implementation SCBackground

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

/*
- (void)drawRect:(NSRect)rect {
	NSColor* color1 = [NSColor colorWithCalibratedWhite:1.0 alpha:1.0];
	NSColor* color2 = [NSColor colorWithCalibratedWhite:0.9 alpha:1.0];
	
	NSGradient* gradient = [[NSGradient alloc] initWithStartingColor:color1 endingColor:color2];
	[gradient drawInRect:rect angle:90];
}/**/

@end
