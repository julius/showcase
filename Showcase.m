//
//  Showcase.m
//  Showcase
//
//  Created by Julius Eckert on 31.12.07.
//  Copyright __MyCompanyName__ 2007. All rights reserved.
//
//  QS Interface template by Vacuous Virtuoso
//

#import <QSEffects/QSWindow.h>
#import <QSInterface/QSSearchObjectView.h>
#import <QSInterface/QSObjectCell.h>

#import "Showcase.h"

@implementation Showcase

- (id)init {
	return [self initWithWindowNibName:@"Showcase"];
}

- (void) windowDidLoad {

	[super windowDidLoad];

	QSWindow *window=(QSWindow *)[self window];

    [[self window] setLevel:NSModalPanelWindowLevel];
    [[self window] setFrameAutosaveName:@"ShowcaseWindow"];

	// If it's off the screen, bring it back in
    [[self window]setFrame:constrainRectToRect([[self window]frame],[[[self window]screen]visibleFrame]) display:NO];


// How much the interface moves when it's showing / hiding
// Tip: set "hide offset" = -"show offset" so the window doesn't gradually get displaced from its original position
	[window setHideOffset:NSMakePoint(0,0)];
	[window setShowOffset:NSMakePoint(0,0)];

	[window setShowEffect:[NSDictionary dictionaryWithObjectsAndKeys:@"QSBingeEffect",@"transformFn",@"show",@"type",[NSNumber numberWithFloat:0.08],@"duration",nil]];
	[window setHideEffect:[NSDictionary dictionaryWithObjectsAndKeys:@"QSShrinkEffect",@"transformFn",@"hide",@"type",[NSNumber numberWithFloat:.1],@"duration",nil]];

	// setWindowProperty returns an error, unfortunately... ignore it
	[window setWindowProperty:[NSDictionary dictionaryWithObjectsAndKeys:@"QSExplodeEffect",@"transformFn",@"hide",@"type",[NSNumber numberWithFloat:0.2],@"duration",nil] forKey:kQSWindowExecEffect];

    NSArray *theControls=[NSArray arrayWithObjects:dSelector,aSelector,iSelector,nil];
    foreach(theControl,theControls){

		[theControl setPreferredEdge:NSMinYEdge];
		[theControl setResultsPadding:NSMinY([dSelector frame])];

		NSCell *theCell=[theControl cell];
		[(QSObjectCell *)theCell setTextColor:[NSColor whiteColor]];
		[(QSObjectCell *)theCell setHighlightColor:[NSColor colorWithCalibratedWhite:0.1 alpha:0.9]];
		[(QSObjectCell *)theCell setAlignment:NSCenterTextAlignment];
		// If yes, will show info under the title (eg. path)
		[(QSObjectCell *)theCell setShowDetails:NO];
	}
	
	[(SCCollectingSearchObject*)dSelector setParentSel:searcher];
	[(SCSearchObjectView*)aSelector setParentSel:searcher];
	[(SCCollectingSearchObject*)iSelector setParentSel:searcher];

/* Example bindings. */
/*	[[[self window] contentView] bind:@"highlightColor"
							 toObject:[NSUserDefaultsController sharedUserDefaultsController]
						  withKeyPath:@"values.interface.glassColor"
							  options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName
																  forKey:@"NSValueTransformerName"]];
	[[[self window] contentView] bind:@"borderWidth"
							 toObject:[NSUserDefaultsController sharedUserDefaultsController]
						  withKeyPath:@"values.interface.borderWidth"
							  options:nil];*/
	
// Just a reminder that you can do normal NSWindow-ey things...
//    [[self window]setMovableByWindowBackground:NO];

}

- (NSSize)maxIconSize{
    return NSMakeSize(128,128);
}

- (void)showMainWindow:(id)sender{
	if ([[self window]isVisible])[[self window]pulse:self];
	[super showMainWindow:sender];
}

- (void)hideMainWindow:(id)sender{
	[[self window] saveFrameUsingName:@"ShowcaseWindow"];
	[super hideMainWindow:sender];
}

/*
*  If you want an effect such as an animation
*  when the indirect selector shows up,
*  the next three methods are for you to subclass.
*/

- (void)showIndirectSelector:(id)sender{
    [super showIndirectSelector:sender];
}

- (void)expandWindow:(id)sender{ 
    [super expandWindow:sender];
}

- (void)contractWindow:(id)sender{
    [super contractWindow:sender];
}

// When something changes, update the command string
- (void)firstResponderChanged:(NSResponder *)aResponder{
	[super firstResponderChanged:aResponder];
	[self updateDetailsString];
}
- (void)searchObjectChanged:(NSNotification*)notif{
	[super searchObjectChanged:notif];	
	[self updateDetailsString];

	QSBasicObject* d_obj = (QSBasicObject*)[dSelector objectValue];
	QSBasicObject* a_obj = (QSBasicObject*)[aSelector objectValue];
	QSBasicObject* i_obj = (QSBasicObject*)[iSelector objectValue];

	[searcher updateD:d_obj A:a_obj I:i_obj];
}

// The method to update the command string
// Get rid of it if you're not having a commandView outlet
-(void)updateDetailsString{
	NSString *command=[[self currentCommand]description];
	[commandView setStringValue:command?command:@""];
}

// Uncomment if you're having a customize button + pref pane
/*- (IBAction)customize:(id)sender{
	[[NSClassFromString(@"QSPreferencesController") sharedInstance]showPaneWithIdentifier:@"QSFumoInterfacePrefPane"];
}*/


- (void)actionActivate:(id)sender{
	[super actionActivate:sender];
}
- (void)updateViewLocations{
    [super updateViewLocations];
}

@end
