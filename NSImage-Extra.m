//
//  NSImage-Extra.m
//  SmallGame
//
//  Created by Julius Eckert on 21.12.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "NSImage-Extra.h"


@implementation NSImage (Extra)

- (CGImageRef) cgImage
{
	// I'm open to better ideas. :)
	
	NSData* data = [self TIFFRepresentation];
	return CreateCGImageFromData(data);
}

- (NSSize)proportionalSizeForTargetSize:(NSSize)targetSize
{
    NSSize imageSize = [self size];
    float width  = imageSize.width;
    float height = imageSize.height;

    float targetWidth  = targetSize.width;
    float targetHeight = targetSize.height;

    // scaleFactor will be the fraction that we'll
    // use to adjust the size. For example, if we shrink
    // an image by half, scaleFactor will be 0.5. the
    // scaledWidth and scaledHeight will be the original,
    // multiplied by the scaleFactor.
    //
    // IMPORTANT: the "targetHeight" is the size of the space
    // we're drawing into. The "scaledHeight" is the height that
    // the image actually is drawn at, once we take into
    // account the idea of maintaining proportions

    float scaleFactor  = 0.0;                
    float scaledWidth  = targetWidth;
    float scaledHeight = targetHeight;

    // since not all images are square, we want to scale
    // proportionately. To do this, we find the longest
    // edge and use that as a guide.

    if ( NSEqualSizes( imageSize, targetSize ) == NO )
    {            
        // use the longeset edge as a guide. if the
        // image is wider than tall, we'll figure out
        // the scale factor by dividing it by the
        // intended width. Otherwise, we'll use the
        // height.
        
        float widthFactor;
        float heightFactor;
        
		widthFactor  = targetWidth / width;
		heightFactor = targetHeight / height;
        
        if ( widthFactor < heightFactor )
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;

        // ex: 500 * 0.5 = 250 (newWidth)
        
        scaledWidth  = width  * scaleFactor;
        scaledHeight = height * scaleFactor;
    }

	return NSMakeSize(scaledWidth,scaledHeight);
}

- (NSImage*)imageByScalingProportionallyToSize:(NSSize)targetSize
{
    return [self imageByScalingProportionallyToSize:targetSize
                                            flipped:NO];
}

- (NSImage*)imageByScalingProportionallyToSize:(NSSize)targetSize
                                       flipped:(BOOL)isFlipped
{
    return [self imageByScalingProportionallyToSize:targetSize
                                            flipped:isFlipped
                                           addFrame:NO
                                          addShadow:NO];
}

- (NSImage*)imageByScalingProportionallyToSize:(NSSize)targetSize
                                       flipped:(BOOL)isFlipped
                                      addFrame:(BOOL)shouldAddFrame
                                     addShadow:(BOOL)shouldAddShadow
{
    return [self imageByScalingProportionallyToSize:targetSize
                                            flipped:isFlipped
                                           addFrame:NO
                                          addShadow:NO
                                           addSheen:YES];
}

- (NSImage*)imageByScalingProportionallyToSize:(NSSize)targetSize
                                       flipped:(BOOL)isFlipped
                                      addFrame:(BOOL)shouldAddFrame
                                     addShadow:(BOOL)shouldAddShadow
                                      addSheen:(BOOL)shouldAddSheen
{
    NSImage* sourceImage = self;

	NSImageRep* rep = [sourceImage bestRepresentationForDevice:nil];
	NSInteger pixelsWide = [rep pixelsWide];
	NSInteger pixelsHigh = [rep pixelsHigh];
	[sourceImage setSize:NSMakeSize(pixelsWide,pixelsHigh)];

    NSImage* newImage = nil;
    if ([sourceImage isValid] == NO) return nil;

    // settings for shadow
    float shadowRadius = 4.0;
    NSSize shadowTargetSize = targetSize;
    if ( shouldAddShadow )
    {
        shadowTargetSize.width  -= (shadowRadius * 2);
        shadowTargetSize.height -= (shadowRadius * 2);
    }
 
    NSSize imageSize = [sourceImage size];
    float width  = imageSize.width;
    float height = imageSize.height;

    float targetWidth  = targetSize.width;
    float targetHeight = targetSize.height;

    // scaleFactor will be the fraction that we'll
    // use to adjust the size. For example, if we shrink
    // an image by half, scaleFactor will be 0.5. the
    // scaledWidth and scaledHeight will be the original,
    // multiplied by the scaleFactor.
    //
    // IMPORTANT: the "targetHeight" is the size of the space
    // we're drawing into. The "scaledHeight" is the height that
    // the image actually is drawn at, once we take into
    // account the idea of maintaining proportions

    float scaleFactor  = 0.0;                
    float scaledWidth  = targetWidth;
    float scaledHeight = targetHeight;

    NSPoint thumbnailPoint = NSMakePoint(0,0);

    // since not all images are square, we want to scale
    // proportionately. To do this, we find the longest
    // edge and use that as a guide.

    if ( NSEqualSizes( imageSize, targetSize ) == NO )
    {            
        // use the longeset edge as a guide. if the
        // image is wider than tall, we'll figure out
        // the scale factor by dividing it by the
        // intended width. Otherwise, we'll use the
        // height.
        
        float widthFactor;
        float heightFactor;
        
        if ( shouldAddShadow ) {
            widthFactor  = shadowTargetSize.width / width;
            heightFactor = shadowTargetSize.height / height;                                
        } else {
            widthFactor  = targetWidth / width;
            heightFactor = targetHeight / height;                                
        }
        
        if ( widthFactor < heightFactor )
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;

        // ex: 500 * 0.5 = 250 (newWidth)
        
        scaledWidth  = width  * scaleFactor;
        scaledHeight = height * scaleFactor;

        // center the thumbnail in the frame. if
        // wider than tall, we need to adjust the
        // vertical drawing point (y axis)
        
        if ( widthFactor < heightFactor )
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;

        else if ( widthFactor > heightFactor )
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;

    }

    // create a new image to draw into        
    newImage = [[NSImage alloc] initWithSize:targetSize];
    [newImage setCacheMode:NSImageCacheNever];
    [newImage setFlipped:isFlipped];

    // once focus is locked, all drawing goes into this NSImage instance
    // directly, not to the screen. It also receives its own graphics
    // context.
    //
    // Also, keep in mind that we're doing this in a background thread.
    // You only want to draw to the screen in the main thread, but
    // drawing to an offscreen image is (apparently) okay.

    [newImage lockFocus];
    
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
        
        // create the properly-scaled rect
        NSRect thumbnailRect;
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width = scaledWidth;
        thumbnailRect.size.height = scaledHeight;
        
        // add shadow below the image?
        if ( shouldAddShadow )
        {
            // we need to adjust the y coordinate to make sure
            // the image ends up in the right place in a flipped
            // coordinate system.
            if ( isFlipped && height > width )
                thumbnailRect.origin.y += (shadowRadius * 2);
            
            // draw the shadow where the image will be
            NSShadow* shadow = [[NSShadow alloc] init];
            [shadow setShadowColor:[NSColor colorWithCalibratedWhite:0.0 alpha:0.5]];
            if (isFlipped)
                [shadow setShadowOffset:NSMakeSize(shadowRadius,shadowRadius)];
            else
                [shadow setShadowOffset:NSMakeSize(shadowRadius,-shadowRadius)];
            [shadow setShadowBlurRadius:shadowRadius];                                
            [NSGraphicsContext saveGraphicsState];                
                [shadow set];
                [[NSColor whiteColor] set];
                [NSBezierPath fillRect:thumbnailRect];                    
            [NSGraphicsContext restoreGraphicsState];                
            [shadow release];                                
        }
            
        // draw the actual image
        [sourceImage drawInRect: thumbnailRect
                       fromRect: NSZeroRect
                      operation: NSCompositeSourceOver
                       fraction: 1.0];                
        
        // add a frame above the image content?            
        if ( shouldAddFrame )
        {   
            // draw the larger internal frame
            NSRect insetFrameRect = NSInsetRect(thumbnailRect,3,3);
            NSBezierPath* insetFrame = [NSBezierPath bezierPathWithRect:insetFrameRect];
            [insetFrame setLineWidth:6.0];
            [[NSColor whiteColor] set];
            [insetFrame stroke];

            // draw the external bounding frame with no anti-aliasing
            [[NSColor colorWithCalibratedWhite:0.60 alpha:1.0] set];
            NSBezierPath* outsetFrame = [NSBezierPath bezierPathWithRect:thumbnailRect];
            [NSGraphicsContext saveGraphicsState];
                [[NSGraphicsContext currentContext] setShouldAntialias:NO];
                [outsetFrame setLineWidth:1.0];
                [outsetFrame stroke];                
            [NSGraphicsContext restoreGraphicsState];                
        }

		if ( shouldAddSheen )
		{
	            NSRect sheenRect = NSInsetRect(thumbnailRect,7,7);
				CGFloat originalHeight = sheenRect.size.height;
				sheenRect.size.height = originalHeight * 0.75;
				sheenRect.origin.y += originalHeight * 0.25;

				NSBezierPath* sheenPath = [NSBezierPath bezierPath];
				NSPoint point1 = NSMakePoint ( sheenRect.origin.x + sheenRect.size.width, sheenRect.origin.y + sheenRect.size.height );
				NSPoint point2 = NSMakePoint ( sheenRect.origin.x, sheenRect.origin.y + sheenRect.size.height );
				NSPoint point3 = NSMakePoint ( sheenRect.origin.x, sheenRect.origin.y );
			
				NSPoint controlPoint1 = point2;
				NSPoint controlPoint2 = point1;
			
				//[sheenPath moveToPoint:point1];
				[sheenPath moveToPoint:point1];
				[sheenPath lineToPoint:point2];
				[sheenPath lineToPoint:point3];
				[sheenPath curveToPoint:point1 controlPoint1:controlPoint1 controlPoint2:controlPoint2];

				NSGradient* gradient = [[NSGradient alloc] initWithColorsAndLocations:
						[NSColor colorWithCalibratedWhite:1.0 alpha:0.60], 0.00,
						[NSColor colorWithCalibratedWhite:1.0 alpha:0.40], 0.15,
						[NSColor colorWithCalibratedWhite:1.0 alpha:0.20], 0.28,
						[NSColor colorWithCalibratedWhite:1.0 alpha:0.01], 0.85, nil]; 
		
	            [gradient drawInBezierPath:sheenPath angle:285.0];
	            [gradient release];

		}

    [newImage unlockFocus];
    return [newImage autorelease];
}

@end

// from http://developer.apple.com/technotes/tn2005/tn2143.html

CGImageRef CreateCGImageFromData(NSData* data)
{
    CGImageRef        imageRef = NULL;
    CGImageSourceRef  sourceRef;

    sourceRef = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    if(sourceRef) {
        imageRef = CGImageSourceCreateImageAtIndex(sourceRef, 0, NULL);
        CFRelease(sourceRef);
    }

    return imageRef;
}
