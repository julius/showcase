//
//  SCSearchObjectView.h
//  Showcase
//
//  Created by Julius Eckert on 05.05.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QSInterface/QSSearchObjectView.h>
#import "QSMySearchObject.h"


@interface SCSearchObjectView : QSSearchObjectView {
	QSMySearchObject* parentSelector;
}
-(void) drawRect:(NSRect)rect;
-(void) setParentSel:(QSMySearchObject*)so;

@end
