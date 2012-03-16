//
//  NCPianoViewController.m
//  NoteConverter
//
//  Created by Parker Wightman on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCPianoViewController.h"
#import "NCPianoView.h"
#import "NCPianoKeyView.h"

#define NUMPIANOKEYS 16 // this is used when creating the piano view in loadView

#pragma mark -
#pragma mark Private Interface
@interface NCPianoViewController ()

@end

#pragma mark -
@implementation NCPianoViewController

#pragma mark Constructors

- (id) initWithModel:(NCNotesModel *)model
{
	self = [super initWithModel:model];
	if (self != nil) {
		// TODO: We should not have to set this manually!
		NCNote* newNote = [[NCNote alloc] initWithType:NCNoteC octave:4];
        NCNote* highNote = [[NCNote alloc] initWithType:NCNoteB octave:5];
        [self setHighNote:highNote];
		[self setLowNote:newNote];
//		[newNote release];
	}
	return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

#pragma mark -
#pragma mark Methods

- (void) loadView
{
		 
	CGRect rect = [[UIScreen mainScreen] applicationFrame];
	CGRect newRect = CGRectMake(0, 0, rect.size.height, rect.size.width);
	NCPianoView* view = [[NCPianoView alloc ] initWithFrame:newRect andWhiteKeys:NUMPIANOKEYS];
	[view setLowestNote:[self lowNote] withAnimation:FALSE];
	[self setView:view];
	[view release];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	if (toInterfaceOrientation != UIInterfaceOrientationPortrait && toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown) {
		return TRUE;
	}
	else
		return FALSE;
}

- (NCPianoView*) pianoView
{
	return (NCPianoView*)[self view];
}

#pragma mark NCNotesModelDelegate Methods

/*
 * Model communicates changes from the other instruments via these methods
 */
- (void) notesModel:(NCNotesModel *)source notePressed:(NCNote *)note relativeOctave:(NSInteger)relativeOctave
{
	[[self pianoView] setKey:[self fittedNote:note relativeOctave:relativeOctave] toPressedState:TRUE];
}

- (void) notesModel:(NCNotesModel *)source noteReleased:(NCNote *)note relativeOctave:(NSInteger)relativeOctave
{
	[[self pianoView] setKey:[self fittedNote:note relativeOctave:relativeOctave] toPressedState:FALSE];
}

- (void) notesModel:(NCNotesModel *)source lowestNoteHint:(NCNote *)note
{
	[self setLowNote:note];
	[[self pianoView] setLowestNote:note withAnimation:YES];
}

- (void) setLowNote:(NCNote *)lowNote
{
    _lowNote = lowNote;
    [self setHighNote:[[NCNote alloc] initWithType:(lowNote.type + 1) % 12 octave:lowNote.octave + 2]];
}

- (NCNote*) fittedNote:(NCNote*)note relativeOctave:(NSInteger)relativeOctave
{
    // Not being used...
//    NSInteger lowOctave = [[self lowNote] octave];
    NSInteger highOctave = [[self highNote] octave];
    
    /* Make sure the octave fits within the range */
    NSInteger fittedOctave = [note octave];
    if (fittedOctave > highOctave) {
        fittedOctave = highOctave;
    }
    return [[[NCNote alloc] initWithType:[note type] octave:fittedOctave] autorelease];
}

- (void) flushNotes
{
    [[self pianoView] clearKeys];
}


#pragma mark - Touch Event Handling

/**************************
 * Touch event handling
 **************************/
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSArray* touchArray = [touches allObjects];
	
	// Register all touches and key events
	for (int i = 0; i < [touchArray count]; i++) {
		UITouch* touch = [touches anyObject];
		NCPianoKeyView* newView = (NCPianoKeyView*)[[self view] hitTest:[touch locationInView:[self view]] withEvent:nil];
		[self keyTouched:newView];
	}
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{	
	NSArray* touchesArray = [touches allObjects];
    
	// Check all touches to see if they haved moved to a different view
	for (int i = 0; i < [touches count]; i++) 
	{
		UITouch* touch = [touchesArray objectAtIndex:i];
		NCPianoKeyView* currentView = (NCPianoKeyView*)[[self view] hitTest:[touch locationInView:[self view]] withEvent:nil];
		NCPianoKeyView* previousView = (NCPianoKeyView*)[[self view] hitTest:[touch previousLocationInView:[self view]] withEvent:nil];
		
		/*
		 * If the currently pressed view is not a piano key, then the previous touch should be
		 * cancelled/released
		 */
		if (![currentView isMemberOfClass:[NCPianoKeyView class]]) 
        {
			if ([previousView isMemberOfClass:[NCPianoKeyView class]]) 
            {
				[self keyReleased:previousView];
			}
			continue;
		}
		
		// If it has moved, release previous and press current
		if( currentView != previousView )
		{
			[self keyReleased:previousView];
			[self keyTouched:currentView];
		}
	}
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	// Tell the Model that the note represented by the view is released
	NSArray* touchArray = [touches allObjects];
	for( int i = 0; i < [touchArray count]; i++ )
	{
		UITouch* touch = [touches anyObject];
		NCPianoKeyView* newView = (NCPianoKeyView*)[[self view] hitTest:[touch locationInView:[self view]] withEvent:nil];
		NCPianoKeyView* previousView = (NCPianoKeyView*)[[self view] hitTest:[touch previousLocationInView:[self view]] withEvent:nil];
		
		if ([newView isMemberOfClass:[NCPianoKeyView class]]) {
			[self keyReleased:newView];
		}
		
		// Make sure to release the previous view as well
		// NOTE: This may be unnecessary -- UPDATE: It's not! This fixes the sticky keys in the piano
		if ([previousView isMemberOfClass:[NCPianoKeyView class]] && previousView != newView) {
			[self keyReleased:previousView];
		}
		
	}
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesEnded:[event allTouches] withEvent:event];
}

/**************************************************************************
 * Helper methods for registering key touches to the view and the model
 * (Called by the touch event methods)
 **************************************************************************/
- (void) keyTouched:(NCPianoKeyView*)view
{
	// Register the key touch with the view and the model
	NCNote* note = [[NCNote alloc] initWithType:[view type] octave:[view octave]];
	[[self pianoView] setKey:note toPressedState:TRUE];
	[_model instrument:self submitNotePressed:note];
	[note release];
	
	return;
	
}

- (void) keyReleased:(NCPianoKeyView*)view
{
	NCNote* note = [[NCNote alloc] initWithType:[view type] octave:[view octave]];
	[_model instrument:self submitNoteReleased:note];
	[[self pianoView] setKey:note toPressedState:FALSE];
	[note release];
}

- (NSUInteger) relativeOctave:(NCNote *)note
{
    return (note.absValue - self.lowNote.absValue)/(NCNoteMAX + 1);
}

/*
 * Disables/Enables the entire view
 */
- (void) willBecomeActive
{
    self.active = YES;
	[[self pianoView] setUserInteractionEnabled:TRUE];
}

- (void) willBecomeInactive
{
    self.active = NO;
	[[self pianoView] setUserInteractionEnabled:FALSE];
}

- (NCNote*) getLowestNoteForNotesModel:(NCNotesModel *)source
{
	return self.lowNote;
}

@end
