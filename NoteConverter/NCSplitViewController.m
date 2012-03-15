//
//  NCSplitViewController.m
//  NoteConverter
//
//  Created by Parker Wightman on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCSplitViewController.h"

#pragma mark -
#pragma mark Private Interface
@interface NCSplitViewController ()
@end

#pragma mark -
@implementation NCSplitViewController

#pragma mark Constructors
- (id) init
{
    self = [super init];
    if (self == nil)
        return nil;
    _primaryInstrumentController = nil;
	_secondaryInstrumentController = nil;
	
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (NCSplitView*) splitView
{
	return (NCSplitView*)[self view];
}

#pragma mark -
#pragma mark Accessors
@synthesize primaryInstrumentController = _primaryInstrumentController;
@synthesize secondaryInstrumentController = _secondaryInstrumentController;
@synthesize model;

- (void) setPrimaryInstrumentController:(NCInstrumentViewController *)primaryInstrumentController
{
	if (_primaryInstrumentController != nil) {
		[_primaryInstrumentController autorelease];
	}
	
	// Notify the controller it should be playable
	[_primaryInstrumentController willBecomeActive];
	
	[primaryInstrumentController retain];
	_primaryInstrumentController = primaryInstrumentController;
	[[self splitView] setPrimaryInstrument:[_primaryInstrumentController view]];
}

- (void) setSecondaryInstrumentController:(NCInstrumentViewController *)secondaryInstrumentController
{
	if (_secondaryInstrumentController != nil) {
		[_secondaryInstrumentController autorelease];
	}
	// Notify the controller it shouldn't be playable
	[_secondaryInstrumentController willBecomeInactive];
	[secondaryInstrumentController retain];
	_secondaryInstrumentController = secondaryInstrumentController;
	[[self splitView] setSecondaryInstrument:[_secondaryInstrumentController view]];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	if (toInterfaceOrientation != UIInterfaceOrientationPortrait && toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown) {
		return TRUE;
	}
	else
		return FALSE;
}


#pragma mark -
#pragma mark Methods
- (void) loadView
{
	NCSplitView* view = [[[NCSplitView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	NCControlsView* controlsView = (NCControlsView*)[view controlsView];
	[controlsView setDelegate:self];
	[view setUserInteractionEnabled:TRUE];
	[view setImage:[UIImage imageNamed:@"background"]];
	//	[view setBackgroundColor:[UIColor whiteColor]];
	[self setView:view];

}

- (NCControlsView*) controlsView {
    return (NCControlsView*)[[self splitView] controlsView];
}

/*
 * Not very robust, need to find a better way for the controls view to
 * communicate these changes to the model
 */
- (BOOL) toggleMode
{
	if ([self model].mode == NCNotesModelModeNormal) {
		[[self model] setMode:NCNotesModelModeScale];
		return TRUE;
	}
	else
	{
		self.model.mode = NCNotesModelModeNormal;
		return FALSE;
	}
}

- (void) setInstrumentType:(NCInstrumentType)instrumentType forRole:(NCInstrumentRole)instrumentRole
{
    NCInstrumentViewController* newController;
    if (instrumentRole == NCInstrumentRolePrimary) {
        newController = [[NCInstrumentViewController alloc] initWithModel:self.model andType:instrumentType];
        [newController willBecomeActive];
        [self setPrimaryInstrumentController:newController];
    }
    else {
        newController = [[NCInstrumentViewController alloc] initWithModel:self.model andType:instrumentType];
        [newController willBecomeInactive];
        [self setSecondaryInstrumentController:newController];
    }
    
    [[self model] clearDelegates];
	[[self model] addDelegate:_primaryInstrumentController];
	[[self model] addDelegate:_secondaryInstrumentController];
}

- (void) swapViews
{
	[_primaryInstrumentController willBecomeInactive];
	[_secondaryInstrumentController willBecomeActive];
	
	/* Swap the view references */
	NCInstrumentViewController* temp = _primaryInstrumentController;
	_primaryInstrumentController = _secondaryInstrumentController;
	_secondaryInstrumentController = temp;
	
	// Swapping the controllers does not necessarily mean the views were switched
	// in the splitView!
	[[self splitView] swapViews];
	
	
	[[self splitView] setNeedsLayout];
}


@end
