/*!
	@header NSURL+NDCarbonUtilities.h
	@abstract Provides method for interacting with Carbon APIs.
	@discussion The methods in <tt>NSURL(NDCarbonUtilities) </tt> are simply wrappers for functions that can bew found within the carbon API.

	Created by nathan on Wed Dec 05 2001.
	Copyright &#169; 2001 Nathan Day. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

/*!
	@category NSURL(NDCarbonUtilities)
	@abstract Provides method for interacting with Carbon APIs.
	@discussion Methods for dealing with <tt>FSRef</tt>&rsquo; s, <tt>FSSpec</tt> and other useful carbon stuff.
 */
@interface NSURL (NDCarbonUtilities)

/*!
	@method URLWithFSRef:
	@abstract Alloc and intialize a <tt>NSURL</tt>.
	@discussion Returns a file url for the file refered to by a <tt>FSRef</tt>.
	@param fsRef A pointer to a <tt>FSRef</tt>.
	@result A <tt>NSURL</tt> containing a file url.
 */
+ (NSURL *)URLWithFSRef:(const FSRef *)fsRef;

	/*!
@method URLWithFileSystemPathHFSStyle:
	 @abstract Alloc and intialize a <tt>NSURL</tt>.
	 @discussion Returns a file url for the file refered to by a HFS style path.
	 @param hfsString A <tt>NSString</tt> containing a HFS style path.
	 @result A <tt>NSURL</tt> containing a file url.
	 */
+ (NSURL *)URLWithFileSystemPathHFSStyle:(NSString *)hfsString;
	/*!
	@method getFSRef:
	@abstract Get a <tt>FSRef</tt>.
	@discussion Obtain a <tt>FSRef</tt> for a file url.
	@param fsRef A pointer to a <tt>FSRef</tt> struct, to be filled by the method.
	@result Returns <tt>YES</tt> if successful, if the method returns <tt>NO</tt> then <tt>fsRef</tt> contains garbage.
 */
- (BOOL)getFSRef:(FSRef *)fsRef;

/*!
	@method getFSSpec:
	@abstract Get a <tt>FSSpec</tt>.
	@discussion Obtain a <tt>FSSpec</tt> for a file url.
	@param fsSpec A pointer to a <tt>FSSpec</tt> struct, to be filled by the method.
	@result Returns <tt>YES</tt> if successful, if the method returns <tt>NO</tt> then <tt>fsSpec</tt> contains garbage.
 */
- (BOOL)getFSSpec:(FSSpec *)fsSpec;

/*!
	@method URLByDeletingLastPathComponent
	@abstract Delete last component of a url.
	@discussion Returns a new <tt>NSURL</tt> equivelent to the receiver with the last component removed.
	@result A new <tt>NSURL</tt>
 */
- (NSURL *)URLByDeletingLastPathComponent;

/*!
	@method fileSystemPathHFSStyle
	@abstract Returns a HFS style path.
	@discussion Returns a <tt>NSString</tt> containg a HFS style path (e.g. <tt>Macitosh HD:Users:</tt>) useful for display purposes.
	@result A new <tt>NSString</tt> containing a HFS style path for the same file or directory as the receiver.
 */
- (NSString *)fileSystemPathHFSStyle;

/*!
	@method resolveAliasFile
	@abstract Resolve an alias file.
	@discussion Returns an file url <tt>NSURL</tt> refered to by the receveive if the receveive refers to an alias file. If it does not refer to an alias file the a url identical to the receveive is returned.
	@result An file url <tt>NSURL</tt>.
 */
- (NSURL *)resolveAliasFile;

/*!
	@method finderInfoFlags:type:creator:
	@abstract Get finder info flags creator and type.
	@discussion The bits of the finder info flag are
	<blockquote>
	<table border = "1"  width = "90%">
		<thead >< tr >< th>Name</th >< th>Description</th >< /tr >< /thead>
		<tr >< td align = "center" >< tt>kIsOnDesk</tt >< /td >< td>Files and folders (System 6) </td >< tr>
		<tr >< td align = "center" >< tt>kColor</tt >< /td >< td>Files and folders</td >< tr>
		<tr >< td align = "center" >< tt>kIsShared</tt >< /td >< td>Files only (Applications only) <br>
					If clear, the application needs to write to its resource fork, and therefore cannot be shared on a server</td >< tr>
		<tr >< td align = "center" >< tt>kHasNoINITs</tt >< /td >< td>Files only (Extensions/Control Panels only) <br>
					This file contains no INIT resource</td >< tr>
		<tr >< td align = "center" >< tt>kHasBeenInited</tt >< /td >< td>Files only<br>
					Clear if the file contains desktop database resources ('BNDL', 'FREF', 'open', 'kind'...) that have not been added yet. Set only by the Finder</td >< tr>
		<tr >< td align = "center" >< tt>kHasCustomIcon</tt >< /td >< td>Files and folders</td >< tr>
		<tr >< td align = "center" >< tt>kIsStationery</tt >< /td >< td>Files only</td >< tr>
		<tr >< td align = "center" >< tt>kNameLocked</tt >< /td >< td>Files and folders</td >< tr>
		<tr >< td align = "center" >< tt>kHasBundle</tt >< /td >< td>Files only</td >< tr>
		<tr >< td align = "center" >< tt>kIsInvisible</tt >< /td >< td>Files and folders</td >< tr>
		<tr >< td align = "center" >< tt>kIsAlias</tt >< /td >< td>Files only.</td >< tr>
	</table>
	</blockquote>
	@param flags Contains finder flags on return.
	@param type Contains finder type on return.
	@param creator Contains creator on return.
	@result Return <tt>YES</tt> if successful, otherwise <tt>NO</tt> and the returned values are invalid.
 */
- (BOOL)finderInfoFlags:(UInt16*)flags type:(OSType*)type creator:(OSType*)creator;

/*!
	@method finderLocation
	@abstract Return a finder items location.
	@discussion Returns a finder items location within its parent window.
	@result A <tt>NSPoint</tt>
 */
- (NSPoint) finderLocation;

/*!
	@method setFinderInfoFlags:mask:type:creator:
	@abstract Set finder info flags, creator and type.
	@discussion The bits of the finder info flag are
	<blockquote>
		<table border = "1"  width = "90%">
		<thead >< tr >< th>Name</th >< th>Description</th >< /tr >< /thead>
		<tr >< td align = "center" >< tt>kIsOnDesk</tt >< /td >< td>Files and folders (System 6) </td >< tr>
		<tr >< td align = "center" >< tt>kColor</tt >< /td >< td>Files and folders</td >< tr>
		<tr >< td align = "center" >< tt>kIsShared</tt >< /td >< td>Files only (Applications only) <br>
		If clear, the application needs to write to its resource fork, and therefore cannot be shared on a server</td >< tr>
		<tr >< td align = "center" >< tt>kHasNoINITs</tt >< /td >< td>Files only (Extensions/Control Panels only) <br>
		This file contains no INIT resource</td >< tr>
		<tr >< td align = "center" >< tt>kHasBeenInited</tt >< /td >< td>Files only<br>
		Clear if the file contains desktop database resources ('BNDL', 'FREF', 'open', 'kind'...) that have not been added yet. Set only by the Finder</td >< tr>
		<tr >< td align = "center" >< tt>kHasCustomIcon</tt >< /td >< td>Files and folders</td >< tr>
		<tr >< td align = "center" >< tt>kIsStationery</tt >< /td >< td>Files only</td >< tr>
		<tr >< td align = "center" >< tt>kNameLocked</tt >< /td >< td>Files and folders</td >< tr>
		<tr >< td align = "center" >< tt>kHasBundle</tt >< /td >< td>Files only</td >< tr>
		<tr >< td align = "center" >< tt>kIsInvisible</tt >< /td >< td>Files and folders</td >< tr>
		<tr >< td align = "center" >< tt>kIsAlias</tt >< /td >< td>Files only.</td >< tr>
		</table>
	</blockquote>
	@param flags Finder flags.
	@param aMask Mask for Finder flags
	@param type The Finder file type
	@param creator The application creator code
	@result Returns <tt>YES</tt> if successful.
 */
- (BOOL)setFinderInfoFlags:(UInt16)flags mask:(UInt16)aMask type:(OSType)type creator:(OSType)creator;

/*!
	@method setFinderLocation:
	@abstract Sets the location a finder item.
	@discussion Set the location of a finder item within in container.
	@param location The location
	@result Returns <tt>YES</tt> if successful.
 */
- (BOOL)setFinderLocation:(NSPoint)location;


@end

/*!
	@category NSURL(NDCarbonUtilitiesInfoFlags)
	@abstract Adds methods to <tt>NSURL</tt>
	@discussion Adds methods to simplify testing of the flags returned from <tt>finderInfoFlags:type:creator:</tt>
 */
@interface NSURL (NDCarbonUtilitiesInfoFlags)
/*!
	@method hasCustomIcon
	@abstract Test if a file has a custom icon.
	@discussion Test to see if the file refered to by the receiver has a custom icon. The is equivelent to testing for the <tt>kHasCustomIcon</tt> flag
	@result Returns <tt>YES</tt> if the file has a custom icon.
 */
- (BOOL)hasCustomIcon;

@end
