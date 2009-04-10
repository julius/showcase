//
//  QSMySearchObject.m
//  QSTest
//
//  Created by Julius Eckert on 30.12.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "QSMySearchObject.h"


@implementation QSMySearchObject

-(void) awakeFromNib {
	[super awakeFromNib];
	
	CGRect viewFrame = NSRectToCGRect(self.frame);
	viewFrame.origin.y = 0;

	mainLayer = [CALayer layer];
	self.layer = mainLayer;
	self.wantsLayer = YES;
	mainLayer.name = @"mainLayer";
	mainLayer.frame = viewFrame;
	mainLayer.delegate = self;
	
	CATransform3D sublayerTransform = CATransform3DIdentity; 
	sublayerTransform.m34 = 1. / -340.;
	
	[mainLayer setSublayerTransform:sublayerTransform];
	[mainLayer setNeedsDisplay];
	
	textLayer = [CATextLayer layer];
	textLayer.name = @"textLayer";
	textLayer.font                  = [NSFont boldSystemFontOfSize:28.0];
	textLayer.fontSize              = 28;
	textLayer.shadowOffset          = CGSizeMake ( 0, 0 );
	textLayer.shadowOpacity         = 0.6;
	textLayer.shadowColor			= CGColorCreateGenericRGB(255, 255, 255, 255);
	textLayer.shadowRadius			= 4;
	textLayer.bounds = CGRectMake( 0, 0, 600, 60 );
	textLayer.alignmentMode         = kCAAlignmentLeft;
	textLayer.anchorPoint = CGPointMake(0, 1.0);
	
	textLayer.string = @"QuickSilver - Showcase";
	textLayer.position = CGPointMake(80, 120);
	[mainLayer addSublayer:textLayer];


	rep1 = [[ObjectRep alloc] initWithLayer:mainLayer];
	rep2 = [[ObjectRep alloc] initWithLayer:mainLayer];
	//*
	rep_a = [[SmallObjectRep alloc] initWithLayer:mainLayer];
	rep_i = [[SmallObjectRep alloc] initWithLayer:mainLayer];
	 /**/
}

-(void) updateD:(QSBasicObject*)d_obj A:(QSBasicObject*)a_obj I:(QSBasicObject*)i_obj {
	if (d_obj == nil) return;
	NSSize size = self.frame.size;

	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:1.2f]
                 forKey:kCATransactionAnimationDuration];
	
	textLayer.opacity = 0.1;
	textLayer.position = CGPointMake(10, size.height-10);
	textLayer.fontSize = 20;
	textLayer.string = @"Showcase";
	
	[CATransaction commit];
	
	bool redraw = true;
	if (lastObj)
		if ([d_obj icon] == [lastObj icon]) redraw = false;
	if (redraw) {
		lastObj = d_obj;
		
		if ([rep1 inUse]) {
			[rep1 hideWithSize:size];
			[rep2 show:d_obj useSize:size];
		} else {
			[rep2 hideWithSize:size];
			[rep1 show:d_obj useSize:size];
		}
	}
	
	//*
	if (a_obj == nil) {
		[rep_i hideWithSize:size];
		[rep_a hideWithSize:size];
		return;
	}
	[rep_a show:a_obj useSize:size at:NSMakePoint(50, 50)];
	
	if (i_obj == nil) {
		[rep_i hideWithSize:size];
		return;
	}
	[rep_i show:i_obj useSize:size at:NSMakePoint(300, 50)];
	 /**/
}

//*
-(void) drawRect: (NSRect)rect {
	[[NSColor blackColor] set];
	NSBezierPath *roundRect = [NSBezierPath bezierPath];
	rect = [self frame];
	rect.origin = NSZeroPoint;
	[roundRect appendBezierPathWithRect:rect];
	[roundRect fill];
}	
/**/	


-(void) activatedEditor:(NSResponder*)sender {
	controlBeforeEditor = sender;
}

-(void) deactivatedEditor {
	if (controlBeforeEditor == nil) return;
	
	[[self window] makeFirstResponder:controlBeforeEditor];
}

@end
