//
//  QSMySearchObject.h
//  QSTest
//
//  Created by Julius Eckert on 30.12.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QSInterface/QSSearchObjectView.h>

#import <QuartzCore/QuartzCore.h>
#import "ObjectRep.h"
#import "SmallObjectRep.h"

@interface QSMySearchObject : QSSearchObjectView {
	CALayer* mainLayer;
	CATextLayer* textLayer;
	ObjectRep* rep1;
	ObjectRep* rep2;
	
	SmallObjectRep* rep_a;
	SmallObjectRep* rep_i;
	
	QSBasicObject* lastObj;
	
	NSResponder* controlBeforeEditor;
}

- (void) drawRect: (NSRect) rect;
-(void) updateD:(QSBasicObject*)d_obj A:(QSBasicObject*)a_obj I:(QSBasicObject*)i_obj;

-(void) activatedEditor:(NSResponder*)sender;
-(void) deactivatedEditor;

@end
