//
//  SCSearchObjectView.m
//  Showcase
//
//  Created by Julius Eckert on 05.05.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SCSearchObjectView.h"


@implementation SCSearchObjectView

-(void) setParentSel:(QSMySearchObject*)so {
	parentSelector = [so retain];
}

-(void) drawRect:(NSRect)rect {
	rect = [self convertRect:[self frame] fromView:[self superview]];
	
	if ([[self window] firstResponder] == self)
		[[NSColor colorWithCalibratedWhite:0.1 alpha:0.9] setFill];
	else
		[[NSColor colorWithCalibratedWhite:0.3 alpha:0.9] setFill];
	
	NSBezierPath *roundRect = [NSBezierPath bezierPath];
	[roundRect appendBezierPathWithRoundedRectangle:rect withRadius:NSHeight(rect) /9];
	[roundRect fill];
	
	[[self cell] drawInteriorWithFrame:[[self cell] drawingRectForBounds:rect] inView:self];
}

@end
