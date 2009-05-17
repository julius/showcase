/* CGSPrivate.h -- Header file for undocumented CoreGraphics stuff. */

/* DesktopManager -- A virtual desktop provider for OS X
 *
 * Copyright (C) 2003, 2004 Richard J Wareham <richwareham@users.sourceforge.net>
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 2 of the License, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
 * for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc., 675
 * Mass Ave, Cambridge, MA 02139, USA.
 */

#include <Carbon/Carbon.h>

/* These functions all return a status code. Typical CoreGraphics replies are:
	kCGErrorSuccess = 0,
	kCGErrorFirst = 1000,
	kCGErrorFailure = kCGErrorFirst,
	kCGErrorIllegalArgument = 1001,
	kCGErrorInvalidConnection = 1002,
*/

// Internal CoreGraphics typedefs
typedef int		CGSConnection;
typedef int		CGSWindow;
typedef int		CGSValue;

//// CONSTANTS ////

/* Window ordering mode. */
typedef enum _CGSWindowOrderingMode {
	kCGSOrderAbove = 1, // Window is ordered above target.
	kCGSOrderBelow = -1, // Window is ordered below target.
	kCGSOrderOut = 0  // Window is removed from the on-screen window list.
} CGSWindowOrderingMode;

// Internal CoreGraphics functions.

/* Retrieve the workspace number associated with the workspace currently
 * being shown.
 *
 * cid -- Current connection.
 * workspace -- Pointer to int value to be set to workspace number.
 */
extern OSStatus CGSGetWorkspace(const CGSConnection cid, int *workspace);

/* Retrieve workspace number associated with the workspace a particular window
 * resides on.
 *
 * cid -- Current connection.
 * wid -- Window number of window to examine.
 * workspace -- Pointer to int value to be set to workspace number.
 */
extern OSStatus CGSGetWindowWorkspace(const CGSConnection cid, const CGSWindow wid, int *workspace);

/* Show workspace associated with a workspace number.
 *
 * cid -- Current connection.
 * workspace -- Workspace number.
 */
extern OSStatus CGSSetWorkspace(const CGSConnection cid, int workspace);

typedef enum {
	CGSNone = 0, 	// No transition effect.
	CGSFade, 		// Cross-fade.
	CGSZoom, 		// Zoom/fade towards us.
	CGSReveal, 		// Reveal new desktop under old.
	CGSSlide, 		// Slide old out and new in.
	CGSWarpFade, 	// Warp old and fade out revealing new.
	CGSSwap, 		// Swap desktops over graphically.
	CGSCube, 		// The well-known cube effect.
	CGSWarpSwitch, // Warp old, switch and un-warp.
	CGSFlip
} CGSTransitionType;

typedef enum {
	CGSDown, 				// Old desktop moves down.
	CGSLeft, 				// Old desktop moves left.
	CGSRight, 				// Old desktop moves right.
	CGSInRight, 				// CGSSwap: Old desktop moves into screen,
							//			new comes from right.
	CGSBottomLeft = 5, 		// CGSSwap: Old desktop moves to bl,
							//			new comes from tr.
	CGSBottomRight, 			// Old desktop to br, New from tl.
	CGSDownTopRight, 		// CGSSwap: Old desktop moves down, new from tr.
	CGSUp, 					// Old desktop moves up.
	CGSTopLeft, 				// Old desktop moves tl.

	CGSTopRight, 			// CGSSwap: old to tr. new from bl.
	CGSUpBottomRight, 		// CGSSwap: old desktop up, new from br.
	CGSInBottom, 			// CGSSwap: old in, new from bottom.
	CGSLeftBottomRight, 		// CGSSwap: old one moves left, new from br.
	CGSRightBottomLeft, 		// CGSSwap: old one moves right, new from bl.
	CGSInBottomRight, 		// CGSSwap: onl one in, new from br.
	CGSInOut				// CGSSwap: old in, new out.
} CGSTransitionOption;

typedef enum {
	CGSTagExposeFade	 = 0x0002, // Fade out when Expose activates.
	CGSTagNoShadow		 = 0x0008, // No window shadow.
	CGSTagTransparent = 0x0200, // Transparent to mouse clicks.
	CGSTagSticky		 = 0x0800, // Appears on all workspaces.
} CGSWindowTag;

extern OSStatus CGSSetWorkspaceWithTransition(const CGSConnection cid,
	int workspaceNumber, CGSTransitionType transition, CGSTransitionOption subtype,
	float time);

/* Get the default connection for the current process. */
extern CGSConnection _CGSDefaultConnection(void);

typedef struct {
	uint32_t unknown1;
	CGSTransitionType type;
	CGSTransitionOption option;
	CGSWindow wid; /* Can be 0 for full-screen */
	float *backColour; /* Null for black otherwise pointer to 3 float array with RGB value */
} CGSTransitionSpec;

/* Transition handling. */
extern OSStatus CGSNewTransition(const CGSConnection cid, const CGSTransitionSpec* spec, int *pTransitionHandle);
extern OSStatus CGSInvokeTransition(const CGSConnection cid, int transitionHandle, float duration);
extern OSStatus CGSReleaseTransition(const CGSConnection cid, int transitionHandle);

// thirtyTwo must = 32 for some reason. tags is pointer to
//array ot ints (size 2?) . First entry holds window tags.
// 0x0800 is sticky bit.
extern OSStatus CGSGetWindowTags(const CGSConnection cid, const CGSWindow wid,
	CGSWindowTag *tags, int thirtyTwo);
extern OSStatus CGSSetWindowTags(const CGSConnection cid, const CGSWindow wid,
	CGSWindowTag *tags, int thirtyTwo);
extern OSStatus CGSClearWindowTags(const CGSConnection cid, const CGSWindow wid,
	CGSWindowTag *tags, int thirtyTwo);
extern OSStatus CGSGetWindowEventMask(const CGSConnection cid, const CGSWindow wid, uint32_t *mask);
extern OSStatus CGSSetWindowEventMask(const CGSConnection cid, const CGSWindow wid, uint32_t mask);

// Get on-screen window counts and lists.
extern OSStatus CGSGetWindowCount(const CGSConnection cid, CGSConnection targetCID, int* outCount);
extern OSStatus CGSGetWindowList(const CGSConnection cid, CGSConnection targetCID,
  int count, int* list, int* outCount);

// Get on-screen window counts and lists.
extern OSStatus CGSGetOnScreenWindowCount(const CGSConnection cid, CGSConnection targetCID, int* outCount);
extern OSStatus CGSGetOnScreenWindowList(const CGSConnection cid, CGSConnection targetCID,
  int count, int* list, int* outCount);

// Per-workspace window counts and lists.
extern OSStatus CGSGetWorkspaceWindowCount(const CGSConnection cid, int workspaceNumber, int *outCount);
extern OSStatus CGSGetWorkspaceWindowList(const CGSConnection cid, int workspaceNumber, int count,
	int* list, int* outCount);

// Gets the level of a window
extern OSStatus CGSGetWindowLevel(const CGSConnection cid, CGSWindow wid,
		int *level);

// Window ordering
extern OSStatus CGSOrderWindow(const CGSConnection cid, const CGSWindow wid,
	CGSWindowOrderingMode place, CGSWindow relativeToWindowID /* can be NULL */);

// Gets the screen rect for a window.
extern OSStatus CGSGetScreenRectForWindow(const CGSConnection cid, CGSWindow wid,
		CGRect *outRect);

// Window appearance/position
extern OSStatus CGSSetWindowAlpha(const CGSConnection cid, const CGSWindow wid, float alpha);
extern OSStatus CGSSetWindowListAlpha(const CGSConnection cid, CGSWindow *wids, int count, float alpha);
extern OSStatus CGSGetWindowAlpha(const CGSConnection cid, const CGSWindow wid, float* alpha);
extern OSStatus CGSMoveWindow(const CGSConnection cid, const CGSWindow wid, CGPoint *point);
extern OSStatus CGSSetWindowTransform(const CGSConnection cid, const CGSWindow wid, CGAffineTransform transform);
extern OSStatus CGSGetWindowTransform(const CGSConnection cid, const CGSWindow wid, CGAffineTransform * outTransform);
extern OSStatus CGSSetWindowTransforms(const CGSConnection cid, CGSWindow *wids, CGAffineTransform *transform, int n);

extern OSStatus CGSMoveWorkspaceWindows(const CGSConnection connection, int toWorkspace, int fromWorkspace);
extern OSStatus CGSMoveWorkspaceWindowList(const CGSConnection connection, CGSWindow *wids, int count,
	int toWorkspace);

// extern OSStatus CGSConnectionGetPID(const CGSConnection cid, pid_t *pid, CGSConnection b);

extern OSStatus CGSGetWindowProperty(const CGSConnection cid, CGSWindow wid, CGSValue key,
	CGSValue *outValue);

//extern OSStatus CGSWindowAddRectToDirtyShape(const CGSConnection cid, const CGSWindow wid, CGRect *rect);
extern OSStatus CGSUncoverWindow(const CGSConnection cid, const CGSWindow wid);
extern OSStatus CGSFlushWindow(const CGSConnection cid, const CGSWindow wid, int unknown /* 0 works */ );

extern OSStatus CGSGetWindowOwner(const CGSConnection cid, const CGSWindow wid, CGSConnection *ownerCid);
extern OSStatus CGSConnectionGetPID(const CGSConnection cid, pid_t *pid, const CGSConnection ownerCid);

// Values
extern CGSValue CGSCreateCStringNoCopy(const char *str);
extern char* CGSCStringValue(CGSValue string);
extern int CGSIntegerValue(CGSValue intVal);

//#define CGSTransparentBackgroundMask (1 << 7)

typedef struct CGPointWarp CGPointWarp;

struct CGPointWarp {
	CGPoint local;
	CGPoint global;
} ;

extern CGError CGSSetWindowWarp(const CGSConnection cid, const CGSWindow wid, int w, int h, CGPointWarp mesh[h] [w]);
extern OSStatus CGSSetWindowListBrightness(const CGSConnection cid, CGSWindow *wids, float *brightness, int count);

#define CGSConnectionID CGSConnection
#define CGSWindowID CGSWindow

//extern OSStatus CGSNewCIFilter(const CGSConnection cid, CGSWindow *wids, float *brightness, int count);
//extern OSStatus CGSMoveWindow(const CGSConnection cid, CGSWindow *wids, float *brightness, int count);
//extern OSStatus CGSSetCIFilterValues(const CGSConnection cid, CGSWindow *wids, float *brightness, int count);
//extern OSStatus CGSSetCIFilterValuesFromDictionary(const CGSConnection cid, CGSWindow *wids, float *brightness, int count);

//CGSIntersectRegionWithRect
//CGSSetWindowTransformsAtPlacement
//CGSSetWindowListGlobalClipShape

/*
 *  Created by Jason Harris on 11/19/05.
 *  Copyright 2005 Geekspiff. All rights reserved.
 */

//typedef void *CGSConnectionID;
//extern CGSConnectionID _CGSDefaultConnection();
//extern CGError CGSDisableUpdate(CGSConnectionID cid);
//extern CGError CGSReenableUpdate(CGSConnectionID cid);

typedef void *CGSRegionRef;
extern CGError CGSNewRegionWithRect(CGRect const *inRect, CGSRegionRef *outRegion);
extern CGError CGSNewEmptyRegion(CGSRegionRef *outRegion);
extern CGError CGSReleaseRegion(CGSRegionRef region);

//typedef void *CGSWindowID;
extern CGError CGSNewWindowWithOpaqueShape(CGSConnectionID cid, int always2, float x, float y, CGSRegionRef shape, CGSRegionRef opaqueShape, int unknown1, void *unknownPtr, int always32, CGSWindowID *outWID);
extern CGError CGSReleaseWindow(CGSConnectionID cid, CGSWindowID wid);
extern CGContextRef CGWindowContextCreate(CGSConnectionID cid, CGSWindowID wid, void *unknown);
//extern CGError CGSSetWindowTransform(CGSConnectionID cid, CGSWindowID wid, CGAffineTransform t);
extern CGError CGSSetWindowLevel(CGSConnectionID cid, CGSWindowID wid, CGWindowLevel level);
//extern CGError CGSOrderWindow(CGSConnectionID cid, CGSWindowID wid1, int ordering, CGSWindowID wid2);
extern CGError CGSGetWindowBounds(CGSConnectionID cid, CGSWindowID wid, CGRect *outBounds);

typedef void *CGSWindowFilterRef;
extern CGError CGSNewCIFilterByName(CGSConnectionID cid, CFStringRef filterName, CGSWindowFilterRef *outFilter);
extern CGError CGSAddWindowFilter(CGSConnectionID cid, CGSWindowID wid, CGSWindowFilterRef filter, int flags);
extern CGError CGSRemoveWindowFilter(CGSConnectionID cid, CGSWindowID wid, CGSWindowFilterRef filter);
extern CGError CGSReleaseCIFilter(CGSConnectionID cid, CGSWindowFilterRef filter);
extern CGError CGSSetCIFilterValuesFromDictionary(CGSConnectionID cid, CGSWindowFilterRef filter, CFDictionaryRef filterValues);
