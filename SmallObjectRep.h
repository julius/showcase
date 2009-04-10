//
//  SmallObjectRep.h
//  QSTest
//
//  Created by Julius Eckert on 31.12.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "NSImage-Extra.h"

@interface SmallObjectRep : NSObject {
	CALayer* mainLayer;
	CALayer* imgLayer;
	CALayer* mirrorLayer;
	CALayer* gradientLayer;
	CATextLayer* textLayer;
}

-(SmallObjectRep*) initWithLayer:(CALayer*)pLayer;
-(void) show: (QSBasicObject*)obj useSize:(NSSize)size at:(NSPoint)pos;
-(void) hideWithSize: (NSSize)size;

@end
