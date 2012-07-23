//
//  NoteConverterAppDelegate.h
//  NoteConverter
//
//  Created by Parker Wightman on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "NCInstrumentViewController.h"
/* Stringed Instrument imports */
#import "NCStringedViewController.h"
#import "NCGuitarViewController.h"
#import "NCBassViewController.h"
/* keyed instrument imports */
#import "NCPianoViewController.h"
#import "NCSplitViewController.h"
#import "NCNoteUnitTest.h"
#import "Finch.h"

@interface NoteConverterAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow* _window;
	NCInstrumentViewController* _primaryViewController;
	NCInstrumentViewController* _secondaryViewController;
	NCSplitViewController* _splitViewController;
	NCNotesModel* _model;
	Finch* _finch;
}

- (void) runTests;
- (void) animateIn;

@end
