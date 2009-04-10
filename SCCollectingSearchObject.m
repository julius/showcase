//
//  SCCollectingSearchObject.m
//  Showcase
//
//  Created by Julius Eckert on 04.05.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SCCollectingSearchObject.h"


@implementation SCCollectingSearchObject

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

- (void)transmogrifyWithText:(NSString *)string {
	if ([[self window] firstResponder] != self) return;
	[super transmogrifyWithText:string];
	
	NSView* edView = [editor enclosingScrollView];
	[[[self window] contentView] addSubview:edView];
	[edView setFrame:NSInsetRect([parentSelector frame], 30, 35)];
	[editor setContinuousSpellCheckingEnabled:NO];
	//[self someEffect:true];
	[parentSelector setHidden:true];
	[parentSelector activatedEditor:self];
}

- (void)textDidEndEditing:(NSNotification *)aNotification {
	[super textDidEndEditing:aNotification];
	[parentSelector setHidden:false];
	//[self someEffect:false];
}


- (BOOL)performKeyEquivalent:(NSEvent *)theEvent {
	if (([theEvent keyCode] == 53) && ([[self window] firstResponder] == editor)) {
		[parentSelector deactivatedEditor];
		return true;
	}
	return [super performKeyEquivalent:theEvent];
}/**/

@end
