//
//  ObjectRep.m
//  QSTest
//
//  Created by Julius Eckert on 30.12.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "ObjectRep.h"


@implementation ObjectRep
@synthesize inUse;

-(ObjectRep*) initWithLayer:(CALayer*)pLayer {
	if (self = [super init]) {
		inUse = false;
		
		mainLayer = [CALayer layer];
		mainLayer.name = @"repLayer";
		mainLayer.anchorPoint = CGPointMake(0.5,0);
		mainLayer.delegate = self;
		[pLayer addSublayer:mainLayer];

		textLayer = [CATextLayer layer];
		textLayer.name = @"textLayer";
		textLayer.font                  = [NSFont boldSystemFontOfSize:20.0];
		textLayer.fontSize              = 20;
		textLayer.shadowOffset          = CGSizeMake ( 0, 0 );
		textLayer.shadowOpacity         = 0.6;
		textLayer.shadowColor			= CGColorCreateGenericRGB(255, 255, 255, 255);
		textLayer.shadowRadius			= 4;
		textLayer.bounds = CGRectMake( 0, 0, 400, 30 );
		textLayer.alignmentMode         = kCAAlignmentRight;
		textLayer.anchorPoint = CGPointMake(1.0, 0.5);
		[mainLayer addSublayer:textLayer];

		detailLayer = [CATextLayer layer];
		detailLayer.name = @"textLayer";
		detailLayer.font                  = [NSFont boldSystemFontOfSize:10.0];
		detailLayer.fontSize              = 10;
		detailLayer.shadowOffset          = CGSizeMake ( 0, 0 );
		detailLayer.shadowOpacity         = 0.6;
		detailLayer.shadowColor			= CGColorCreateGenericRGB(255, 255, 255, 255);
		detailLayer.shadowRadius			= 2;
		detailLayer.bounds = CGRectMake( 0, 0, 400, 30 );
		detailLayer.alignmentMode         = kCAAlignmentRight;
		detailLayer.anchorPoint = CGPointMake(1.0, 0.5);
		[mainLayer addSublayer:detailLayer];
	}
	return self;
}

-(void) setZ:(int)z fast:(bool)now {
	[CATransaction begin];
	if (now) {
		[CATransaction setValue:(id)kCFBooleanTrue
						 forKey:kCATransactionDisableActions];
	} else {
		[CATransaction setValue:[NSNumber numberWithFloat:0.5f]
						 forKey:kCATransactionAnimationDuration];
	}
	mainLayer.zPosition = z;
	[CATransaction commit];
}


-(void) show: (QSBasicObject*)obj useSize:(NSSize)size {
	inUse = true;
	
	if (image != nil) [image release];
	[obj loadIcon];
	image = [[obj icon] retain];
	[image setSize: NSMakeSize(96, 96)];
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];

	textLayer.string = [obj displayName];
	textLayer.position = CGPointMake(-20, 150);
	
	detailLayer.string = [obj details];
	detailLayer.position = CGPointMake(-20, 120);
	
	mainLayer.bounds = CGRectMake(0, 0, image.size.width, image.size.height*2);
	mainLayer.position = CGPointMake(490, -20);
	mainLayer.transform = CATransform3DIdentity;
	mainLayer.opacity = 1.0;
	[mainLayer setNeedsDisplay];
	
	[CATransaction commit];
	[self setZ:0 fast:true];
}

-(void) hideWithSize: (NSSize)size {
	inUse = false;
	[self setZ: -1500 fast:false];
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:0.6f]
					 forKey:kCATransactionAnimationDuration];
	mainLayer.transform = CATransform3DMakeTranslation(-200.0, 0, 0);
	mainLayer.opacity = 0.0;
	[CATransaction commit];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)cgContext;
{    
    if ( [layer.name isEqualToString:@"repLayer"] )
	{
		[NSGraphicsContext saveGraphicsState];
		NSRect drawingRect = NSRectFromCGRect( CGContextGetClipBoundingBox( cgContext ) );
		NSGraphicsContext* context = [NSGraphicsContext graphicsContextWithGraphicsPort:cgContext flipped:NO];
		[NSGraphicsContext setCurrentContext:context];
		[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];

		NSRect topRect, bottomRect;
		NSDivideRect(drawingRect, &topRect, &bottomRect, NSHeight(drawingRect) /2, NSMaxYEdge);

		if ([image isFlipped]) [image setFlipped:false];
		[image drawInRect:topRect fromRect:rectFromSize([image size]) operation:NSCompositeSourceOver fraction:1.0];		
		
		[image setFlipped:true];
		[image drawInRect:bottomRect fromRect:rectFromSize([image size]) operation:NSCompositeSourceOver fraction:1.0];		

		NSColor* color1 = [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:1.0];//.87];
		NSColor* color2 = [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:.7];//1.0];
		NSGradient* gradient = [[NSGradient alloc] initWithStartingColor:color1 endingColor:color2];
		
		//[[NSGraphicsContext currentContext] setCompositingOperation:NSCompositeSourceOver];
		[gradient drawInRect:bottomRect angle:90];
		
    	[NSGraphicsContext restoreGraphicsState];        

	} else {
        [super drawLayer:layer inContext:cgContext];
	}
}


@end
