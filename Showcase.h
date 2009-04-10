//
//  Showcase.h
//  Showcase
//
//  Created by Julius Eckert on 31.12.07.
//  Copyright __MyCompanyName__ 2007. All rights reserved.
//
//  QS Interface template by Vacuous Virtuoso
//

#import <Cocoa/Cocoa.h>
#import <QSInterface/QSResizingInterfaceController.h>
#import "QSMySearchObject.h"
#import "SCCollectingSearchObject.h"
#import "SCSearchObjectView.h"

@interface Showcase : QSResizingInterfaceController {
	IBOutlet QSMySearchObject* searcher;
}
-(void)updateDetailsString;
@end