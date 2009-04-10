//
//  SCCollectingSearchObject.h
//  Showcase
//
//  Created by Julius Eckert on 04.05.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "QSCollectingSearchObjectView.h"
#import "QSMySearchObject.h"

@interface SCCollectingSearchObject : QSCollectingSearchObjectView {
	QSMySearchObject* parentSelector;
}


-(void) drawRect:(NSRect)rect;
-(void) setParentSel:(QSMySearchObject*)so;

@end
