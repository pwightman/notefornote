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
@synthesize toolbarController;

- (void) setPrimaryInstrumentController:(NCInstrumentViewController *)primaryInstrumentController
{
	
	// Notify the controller it should be playable
	[_primaryInstrumentController willBecomeActive];
	
	[primaryInstrumentController retain];
	_primaryInstrumentController = primaryInstrumentController;
	[[self splitView] setPrimaryInstrument:[_primaryInstrumentController view]];
}

- (void) setSecondaryInstrumentController:(NCInstrumentViewController *)secondaryInstrumentController
{
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
    toolbarController = [[NCToolbarViewController alloc] init];
    [self.toolbarController setDelegate:self];
	NCSplitView* view = [[[NCSplitView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] andControlsView:[self.toolbarController view]] autorelease];
//	NCControlsView* controlsView = (NCControlsView*)[view controlsView];
//	[controlsView setDelegate:self];
	[view setUserInteractionEnabled:TRUE];
	[view setImage:[UIImage imageNamed:@"background"]];
	//	[view setBackgroundColor:[UIColor whiteColor]];
	[self setView:view];

}

- (NCControlsView*) controlsView {
    return (NCControlsView*)[[self splitView] controlsView];
}

# pragma mark - NCControlsViewDelegate methods

- (void) presentModal:(UIViewController *)controller
{
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
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
        if (_primaryInstrumentController.type == instrumentType)
        {
            return;
        }
        /* This does not work yet because loading is taking place on the main thread... */
        [_primaryInstrumentController setLoadingViewState:YES];
        newController = [[NCInstrumentViewController alloc] initWithModel:self.model andType:instrumentType];
        [newController willBecomeActive];
        [self setPrimaryInstrumentController:newController];
    }
    else {
        if (_secondaryInstrumentController.type == instrumentType)
        {
            return;
        }
        /* This does not work yet because loading takes place on the main thread... */
        [_secondaryInstrumentController setLoadingViewState:YES];
        newController = [[NCInstrumentViewController alloc] initWithModel:self.model andType:instrumentType];
        [newController willBecomeInactive];
        [self setSecondaryInstrumentController:newController];
    }
    
    [[self model] clearDelegates];
	[[self model] addDelegate:_primaryInstrumentController];
	[[self model] addDelegate:_secondaryInstrumentController];
    [[self toolbarController] setPressedStates];
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
	[[self toolbarController] setPressedStates];
	
	[[self splitView] setNeedsLayout];
}

- (NCInstrumentType) primaryInstrumentType
{
    return [self primaryInstrumentController].type;
}

- (NCInstrumentType) secondaryInstrumentType
{
    return [self secondaryInstrumentController].type;
}


- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
