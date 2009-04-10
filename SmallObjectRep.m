//
//  SmallObjectRep.m
//  QSTest
//
//  Created by Julius Eckert on 31.12.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "SmallObjectRep.h"


@implementation SmallObjectRep

-(SmallObjectRep*) initWithLayer:(CALayer*)pLayer {
	if (self = [super init]) {
		mainLayer = [CALayer layer];
		mainLayer.name = @"repLayer";
		[pLayer addSublayer:mainLayer];

		imgLayer = [CALayer layer];
		imgLayer.name = @"imgLayer";
		[mainLayer addSublayer:imgLayer];

		mirrorLayer = [CALayer layer];
		mirrorLayer.name = @"mirrorLayer";

		[mainLayer addSublayer:mirrorLayer];

		gradientLayer = [CALayer layer];
		gradientLayer.name = @"gradientLayer";
		gradientLayer.bounds = CGRectMake(0, 0, 100, 100);
		gradientLayer.delegate = self;

		[mainLayer addSublayer:gradientLayer];
		
		textLayer = [CATextLayer layer];
		textLayer.name = @"textLayer";
		textLayer.font                  = [NSFont boldSystemFontOfSize:14.0];
		textLayer.fontSize              = 14;
		textLayer.shadowOffset          = CGSizeMake ( 0, 0 );
		textLayer.shadowOpacity         = 0.6;
		textLayer.shadowColor			= CGColorCreateGenericRGB(255, 255, 255, 255);
		textLayer.shadowRadius			= 4;
		textLayer.bounds = CGRectMake( 0, 0, 400, 30 );
		textLayer.alignmentMode         = kCAAlignmentLeft;
		textLayer.anchorPoint = CGPointMake(0.0, 0.5);
		[mainLayer addSublayer:textLayer];
	}
	return self;
}

-(void) show: (QSBasicObject*)obj useSize:(NSSize)size at:(NSPoint)pos {
	NSImage* img = [obj icon];
	[img setSize: NSMakeSize(32, 32)];
	CGImageRef cgImg = [img cgImage];

	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
                 forKey:kCATransactionDisableActions];
		imgLayer.contents = (id)cgImg;
		imgLayer.bounds = CGRectMake(0, 0, img.size.width, img.size.height);

		mirrorLayer.contents = (id)cgImg;
		mirrorLayer.bounds = CGRectMake(0, 0, img.size.width, img.size.height);
		mirrorLayer.position = CGPointMake(0, -(img.size.height));
		mirrorLayer.transform = CATransform3DMakeRotation(pi, 1, 0, 0);

		CGImageRelease(cgImg);

		gradientLayer.bounds = CGRectMake(0, 0, img.size.width, img.size.height);
		gradientLayer.position = mirrorLayer.position;
		[gradientLayer setNeedsDisplay];

		textLayer.string = [obj displayName];
		textLayer.position = CGPointMake(+img.size.width/2+5, -5);

		mainLayer.position = CGPointMake(pos.x, pos.y);
		mainLayer.transform = CATransform3DIdentity;
		mainLayer.opacity = 1.0;

	[CATransaction commit];
}

-(void) hideWithSize: (NSSize)size {
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:0.4f]
                 forKey:kCATransactionAnimationDuration];
		//mainLayer.position = CGPointMake(mainLayer.position.x, -100);
		mainLayer.transform =CATransform3DMakeScale(10.0, 0.1, 1.0);
		mainLayer.opacity = 0.0;
//		mainLayer.transform =CATransform3DScale(CATransform3DMakeRotation(pi/3, 0, 1, 0), 0.01, 0.01, 0.01);
	[CATransaction commit];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)cgContext;
{    
        
    if ( [layer.name isEqualToString:@"gradientLayer"] )
	{
		[NSGraphicsContext saveGraphicsState];

            NSRect drawingRect = NSRectFromCGRect( CGContextGetClipBoundingBox( cgContext ) );
			NSRect blackRect = NSMakeRect(drawingRect.origin.x, drawingRect.origin.y, drawingRect.size.width,
								abs(drawingRect.size.height*0.4));
			NSRect gradientRect = NSMakeRect(blackRect.origin.x, blackRect.origin.y + blackRect.size.height,
								blackRect.size.width, drawingRect.size.height - blackRect.size.height);
			
            NSGraphicsContext* context = [NSGraphicsContext graphicsContextWithGraphicsPort:cgContext flipped:NO];
		    [NSGraphicsContext setCurrentContext:context];

			NSColor* colorM = [NSColor blackColor];
            NSColor* color1 = [colorM colorWithAlphaComponent:1.0];
            NSColor* color2 = [colorM colorWithAlphaComponent:0.4];
			
            NSGradient* gradient = [[NSGradient alloc] initWithStartingColor:color1 endingColor:color2];

            CGFloat angle   = 90;
            [gradient drawInRect:gradientRect angle:angle];
            	                          
			NSBezierPath* bRect = [NSBezierPath bezierPath];
			[bRect appendBezierPathWithRect:blackRect];
			[bRect fill];
    	[NSGraphicsContext restoreGraphicsState];        
		
	} else {
        [super drawLayer:layer inContext:cgContext];
	}
}


@end
