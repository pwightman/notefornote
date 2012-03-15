//
//  NCStringedViewController.m
//  NoteConverter
//
//  Created by Parker Wightman on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCStringedViewController.h"

#pragma mark -
#pragma mark Private Interface
@interface NCStringedViewController ()
- (void) keyPressed:(NCNote*)note;
- (void) keyReleased:(NCNote*)note;
@end

#pragma mark -
@implementation NCStringedViewController

#pragma mark Constructors
- (id) initWithModel:(NCNotesModel*)model strings:(NSArray*)strings andFrets:(NSUInteger)frets
{
    self = [super initWithModel:model];
    if (self == nil)
        return nil;
	
	_notes = [[NSMutableArray alloc] initWithCapacity:[_strings count]];
	_strings = [strings retain];
	_soundManager = nil;
	
	
	for(int i = 0; i < strings.count; i++)
	{
		NSMutableArray* newArray = [NSMutableArray arrayWithCapacity:frets];
		NCNote* note = [strings objectAtIndex:i];
		NSInteger currentOctave = note.octave;
		NSInteger currentNote = note.type;
        
        // + 1 frets to account for the open string.
		for( int i = 0; i < frets + 1; i++ )
		{
			NCNote* newNote = [[[NCNote alloc] initWithType:currentNote octave:currentOctave] autorelease];
			[newArray addObject:newNote];
			if (currentNote == NCNoteMAX) {
				currentNote = NCNoteMIN;
				currentOctave++;
			}
			else
				currentNote++;
		}
		[_notes addObject:newArray];
	}
	
	[self setLowNote:[[_notes objectAtIndex:[_notes count] - 1] objectAtIndex:0]];
	[self setHighNote:[[_notes objectAtIndex:0] objectAtIndex:frets - 1]];
	
	[self initImages];
		
    return self;
}

// Can't initialize without strings and frets
- (id) init { return nil; }

- (void) dealloc
{
	[_notes release];
	[_strings release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (NCStringedView*) stringedView
{
	return (NCStringedView*)[self view];
}


#pragma mark Methods

#pragma mark -
#pragma mark UIViewController Methods
- (void) loadView
{
    
    // NOTE: Passing - 1 into frets is necessary because there's some weird, messed up naming crap in this project.
    //       When you pass in the number of frets, _notes.count is actually going to be one more than the number of
    //       frets because it's accounting for the open string. This should be fixed eventually.
	NCStringedView* view = [[[NCStringedView alloc] initWithStrings:[_strings count] frets:[[_notes objectAtIndex:0] count] - 1] autorelease];
	[view setDelegate:self];
    [view initNotes];

	[self setView:view];
}

#pragma mark Event Handling Methods

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![[self stringedView] playable]) {
        return;
    }
	NSArray* touchesArray = [touches allObjects];
	for( int i = 0; i < [touchesArray count]; i++ )
	{
		UITouch* touch = [touchesArray objectAtIndex:i];
		NCStringedNoteView* touchedView = (NCStringedNoteView*)[[self view] hitTest:[touch locationInView:[self view]] withEvent:event];
		
		// TODO: Kind of a hack... This hack is necessary because there's a chance
		// that there will be the marker on the key (which is a UILabel) so we actually
		// need its superview which is the actual NCStringedNoteView
		if ([touchedView isMemberOfClass:[UILabel class]])
			touchedView = (NCStringedNoteView*)[touchedView superview];
		
		
		if ([touchedView isMemberOfClass:[NCStringedNoteView class]]) 
		{
			NCNote* note = [[_notes objectAtIndex:touchedView.string] objectAtIndex:touchedView.fret];
			[[self stringedView] setNotePressed:TRUE onString:touchedView.string andFret:touchedView.fret];
			
			// NOTE: CHANGE RELATIVE OCTAVE
			[_model instrument:self submitNotePressed:note relativeOctave:0];
			[_soundManager playSound:[note absValue]];
			
		}
		
	}

}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![[self stringedView] playable]) {
        return;
    }
	NSArray* touchesArray = [touches allObjects];
	for (int i = 0; i < [touchesArray count]; i++) 
	{
		
		UITouch* touch = [touchesArray objectAtIndex:i];
		NCStringedNoteView* currentView = (NCStringedNoteView*)[[self view] hitTest:[touch locationInView:[self view]] withEvent:event];
		
		// Hack...
		if ([currentView isMemberOfClass:[UILabel class]])
			currentView = (NCStringedNoteView*)[currentView superview];
		
		NCStringedNoteView* previousView = (NCStringedNoteView*)[[self view] hitTest:[touch previousLocationInView:[self view]] withEvent:event];
		
		// TODO: Hack...
		if ([previousView isMemberOfClass:[UILabel class]])
			previousView = (NCStringedNoteView*)[previousView superview];
		
		// If it's not the right type of view, something is wrong! Disable the previous view
		// if it was a note view
		if (![previousView isMemberOfClass:[NCStringedNoteView class]] || ![currentView isMemberOfClass:[NCStringedNoteView class]]	) {
			if ([previousView isMemberOfClass:[NCStringedNoteView class]]) {
				[[self stringedView] setNotePressed:FALSE onString:previousView.string andFret:previousView.fret];
			}
			continue;
		}

		
		[[self stringedView] setNotePressed:FALSE onString:currentView.string andFret:currentView.fret];
		NCNote* note = [[_notes objectAtIndex:currentView.string] objectAtIndex:currentView.fret];
		[_model instrument:self submitNoteReleased:note relativeOctave:0];
		[_soundManager stopSound:[note absValue]];
		
		// Release the previous note pressed if it's different than the current note
		if (previousView != currentView) {
			[[self stringedView] setNotePressed:FALSE onString:previousView.string andFret:previousView.fret];
			NCNote* note = [[_notes objectAtIndex:previousView.string] objectAtIndex:previousView.fret];
			[_model instrument:self submitNoteReleased:note relativeOctave:0];
			[_soundManager stopSound:[note absValue]];
		}
		
		
		// TODO: CHANGE RELATIVE OCTAVE LATER
	}
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesEnded:touches withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![[self stringedView] playable]) {
        return;
    }
    
	NSArray* touchesArray = [touches allObjects];
	for (int i = 0; i < [touchesArray count]; i++) 
	{
		UITouch* touch = [touchesArray objectAtIndex:i];
		NCStringedNoteView* currentView = (NCStringedNoteView*)[[self view] hitTest:[touch locationInView:[self view]] withEvent:event];
		
		// Hack...
		if ([currentView isMemberOfClass:[UILabel class]])
			currentView = (NCStringedNoteView*)[currentView superview];
		
		NCStringedNoteView* previousView = (NCStringedNoteView*)[[self view] hitTest:[touch previousLocationInView:[self view]] withEvent:event];
		
		// TODO: Hack...
		if ([previousView isMemberOfClass:[UILabel class]])
			previousView = (NCStringedNoteView*)[previousView superview];
		
		// If it's not the right type of view, something is wrong! Disable the previous view
		// if it was a note view
		if (![previousView isMemberOfClass:[NCStringedNoteView class]] || ![currentView isMemberOfClass:[NCStringedNoteView class]]	) {
			if ([previousView isMemberOfClass:[NCStringedNoteView class]]) {
				[[self stringedView] setNotePressed:FALSE onString:previousView.string andFret:previousView.fret];
				NCNote* note = [[_notes objectAtIndex:previousView.string] objectAtIndex:previousView.fret];
				
				// TODO: CHANGE RELATIVE OCTAVE LATER
				[_model instrument:self submitNoteReleased:note relativeOctave:0];
				[_soundManager stopSound:[note absValue]];
			}
			continue;
		}
		
		// If this block executes, it denotes that the touch has changed from one note to another,
		// So releasing the previous key and pressing the new key is in order.
		if (currentView != previousView) {
			[[self stringedView] setNotePressed:FALSE onString:previousView.string andFret:previousView.fret];
			NCNote* note = [[_notes objectAtIndex:previousView.string] objectAtIndex:previousView.fret];
			
			// TODO: CHANGE RELATIVE OCTAVE LATER
			[_model instrument:self submitNoteReleased:note relativeOctave:0];
			[_soundManager stopSound:[note absValue]];
			[[self stringedView] setNotePressed:TRUE onString:currentView.string andFret:currentView.fret];
			note = [[_notes objectAtIndex:currentView.string] objectAtIndex:currentView.fret];
			
			// TODO: CHANGE RELATIVE OCTAVE LATER
			[_model instrument:self submitNotePressed:note relativeOctave:0];
			[_soundManager playSound:[note absValue]];
			
		}
	}
}

- (void) keyPressed:(NCNote *)note
{
	
}

- (void) keyReleased:(NCNote *)note
{
	
}

#pragma mark NCStringedViewDelegate Methods

- (void) stringedView:(NCStringedView *)view modifiedFretRangeLow:(NSUInteger)low high:(NSUInteger)high
{
	[self updateLowestNote:NO];
}

- (void) stringedView:(NCStringedView *)view modifiedStringRangeLow:(NSUInteger)low high:(NSUInteger)high
{
	[self updateLowestNote:NO];
}

- (void) updateLowestNote:(BOOL)active
{
	NSUInteger fret = [[self stringedView] getFretRange].location;
	NSUInteger string = [[self stringedView] getStringRange].location;
	NCNote* newNote;
    if (active)
        newNote = [[_notes objectAtIndex:[_notes count] - string - 1] objectAtIndex:0];
    else
        newNote = [[_notes objectAtIndex:[_notes count] - string - 1] objectAtIndex:fret];
	[self setLowNote:newNote];
	[_model instrument:self lowestNoteChanged:newNote];
}

- (void) stringedView:(NCStringedView *)view notePressedFret:(NSUInteger)fret string:(NSUInteger)string
{
	NCNote* note = [[_notes objectAtIndex:string] objectAtIndex:fret];
	[_model instrument:self submitNotePressed:note relativeOctave:0];
}

- (void) stringedView:(NCStringedView *)view noteReleasedFret:(NSUInteger)fret string:(NSUInteger)string
{
	NCNote* note = [[_notes objectAtIndex:string] objectAtIndex:fret];
	[_model instrument:self submitNoteReleased:note relativeOctave:0];
}

- (NSString*) stringedView:(NCStringedView *)view getNoteNameAtFret:(NSUInteger)fret string:(NSUInteger)string
{
	if ([_model showNotes]) {
		NSArray* notes = [_notes objectAtIndex:string];
        NCNote* note = [notes objectAtIndex:fret];
		return [note typeToString];
	}
	else
		return @"";
}
- (UIColor*) stringedView:(NCStringedView *)view getColorForNoteAtFret:(NSUInteger)fret string:(NSUInteger)string
{
	// Get out the note and find its color from the NCNote class
	return [NCNote colorForNote:[[_notes objectAtIndex:string] objectAtIndex:fret]];
}


#pragma mark NCNotesModelDelegate Methods
- (void) notesModel:(NCNotesModel*)source noteReleased:(NCNote*)note relativeOctave:(NSInteger)relativeOctave
{
	[self executeNoteLogic:source notePressed:note relativeOctave:relativeOctave withPressedState:FALSE];	
}
- (void) notesModel:(NCNotesModel*) source notePressed:(NCNote*)note relativeOctave:(NSInteger)relativeOctave
{
	[self executeNoteLogic:source notePressed:note relativeOctave:relativeOctave withPressedState:TRUE];
}

- (NCNote*) getLowestNoteForNotesModel:(NCNotesModel *)source
{
	return self.lowNote;
}

- (void) executeNoteLogic:(NCNotesModel*) source notePressed:(NCNote*)note relativeOctave:(NSInteger)relativeOctave withPressedState:(BOOL)pressed
{
	/* Normal mode execution path */
	if (source.mode == NCNotesModelModeNormal) 
	{		
		//NSArray* notes = [source notes];
		// Send in the note that was pressed
		CGPoint newPoint = [self findNextNote:note 
                                   startingAt:CGPointMake([[self stringedView] getFretRange].location, [[self stringedView] getStringRange].location) 
                                   inFretRange:[[self stringedView] getFretRange] 
                                   andStringRange:[[self stringedView] getStringRange] 
                                   relativeToOctave:relativeOctave];
		if ((NSInteger)newPoint.x == -1) {
			return;
		}
		[[self stringedView] setNotePressed:pressed onString:(NSInteger)newPoint.y andFret:(NSInteger)newPoint.x];
		NCNote* newNote = [[_notes objectAtIndex:newPoint.y] objectAtIndex:newPoint.x];
        
		// This is the choke point for making sure all sounds get started and stopped.
		if (pressed)
			[_soundManager playSound:newNote.absValue];
		else
			[_soundManager stopSound:newNote.absValue];
	}
	
	/* Scale mode execution path */
	else if (source.mode == NCNotesModelModeScale)
	{
		// Get all notes matching the passed in note
		NSArray* notes = [self findAllNotes:note startingAt:CGPointMake([[self stringedView] getFretRange].location, [[self stringedView] getStringRange].location) inFretRange:[[self stringedView] getFretRange] andStringRange:[[self stringedView] getStringRange]];
		
		// Display each of those notes
		for(int i = 0; i < notes.count; i++)
		{
			CGPoint newPoint = [[notes objectAtIndex:i] CGPointValue];
			[[self stringedView] setNotePressed:pressed onString:(NSInteger)newPoint.y andFret:(NSInteger)newPoint.x];
			NCNote* newNote = [[_notes objectAtIndex:newPoint.y] objectAtIndex:newPoint.x];
			if (pressed)
				[_soundManager playSound:newNote.absValue];
			else
				[_soundManager stopSound:newNote.absValue];
		}
	}
}

#pragma mark -
- (CGPoint) findNextNote:(NCNote*)note startingAt:(CGPoint)startingPoint inFretRange:(NSRange)fretRange andStringRange:(NSRange)stringRange relativeToOctave:(NSInteger)octave
{
	// Get out the lowest note in the range since the octave will be relative to it.
	//NCNote* lowestNote = [[_notes objectAtIndex:stringRange.location + stringRange.length - 1] objectAtIndex:fretRange.location];
	
	NSInteger count = 0;
    
    // (-1, -1) indicates no note found
	CGPoint lastFoundNote = CGPointMake(-1, -1);
    
	/* 
	 * Searching for the first note on the guitar whose type matches the passed in note.
	 * Tries to match the relative octave as best as possible
	 *
	 * TODO: This can probably be optimized to not use a loop but rather determine the location
	 * of any note based on the fret range and what the first note of the range is
	 */
	for (NSUInteger i = stringRange.location; i < stringRange.location  + stringRange.length; i++) 
	{
		NSArray* stringArray = [_notes objectAtIndex:(_notes.count - 1 - i)];
		for (int j = fretRange.location; j < fretRange.location + MIN(fretRange.length, 5); j++) 
		{
			NCNote* newNote = [stringArray objectAtIndex:j];
			if ( newNote.type == note.type)
			{
				// Considers the octave and relative octave to try to find a note
				// that most closely matches what the user wants
				if (count == octave) {
					return CGPointMake(j, (_notes.count - 1 - i));
				}
				else
				{
					// Keep track of the last note so you can return
					// it if you don't find any other ones
					lastFoundNote = CGPointMake(j, (_notes.count - 1 - i));
					count++;
				}
			}
		}
	}
	
	return lastFoundNote;
}

- (NSArray*) findAllNotes:(NCNote*)note startingAt:(CGPoint)startingPoint inFretRange:(NSRange)fretRange andStringRange:(NSRange)stringRange
{
	NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:10];

	/*
	 * Essentially the same code as findNextNote except it store all occurences
	 * into an array and returns them all
	 */
	for (NSUInteger i = stringRange.location; i < stringRange.location  + stringRange.length; i++) 
	{
		NSArray* stringArray = [_notes objectAtIndex:i];
		for (int j = fretRange.location; j < fretRange.location + fretRange.length; j++) 
		{
			NCNote* newNote = [stringArray objectAtIndex:j];
			if ( newNote.type == note.type)
			{
				[array addObject:[NSValue valueWithCGPoint:CGPointMake(j, i)]];
			}
		}
	}
	return [array autorelease];
}

#pragma mark NCInstrumentViewController Abstract Methods

- (void) willBecomeInactive
{
	[[self stringedView] setPlayable:NO];
    [self updateLowestNote:NO];

}

- (void) willBecomeActive
{
	[[self stringedView] setPlayable:YES];
    [self updateLowestNote:YES];
}


@end
