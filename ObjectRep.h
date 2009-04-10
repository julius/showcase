//
//  ObjectRep.h
//  QSTest
//
//  Created by Julius Eckert on 30.12.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "NSImage-Extra.h"

@interface ObjectRep : NSObject {
	CALayer* mainLayer;
	//CALayer* imgLayer;
	//CALayer* mirrorLayer;
	//CALayer* gradientLayer;
	CATextLayer* textLayer;
	CATextLayer* detailLayer;
	bool inUse;
	NSImage* image;
}

@property (readonly) bool inUse;

-(ObjectRep*) initWithLayer:(CALayer*)pLayer;
-(void) show: (QSBasicObject*)obj useSize:(NSSize)size;
-(void) hideWithSize: (NSSize)size;

@end
