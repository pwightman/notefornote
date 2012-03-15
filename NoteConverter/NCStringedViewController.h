//
//  NCStringedViewController.h
//  NoteConverter
//
//  Created by Parker Wightman on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCInstrumentViewController.h"
#import "NCStringedView.h"
#import "NCNotesModel.h"


@interface NCStringedViewController : NCInstrumentViewController <NCStringedViewDelegate>
{
	NSMutableArray* _notes;
	NSArray* _strings;
}


/*
 * Should be overridden by subclasses to provide the normal tuning for an instrument
 */
- (NSArray*) normalTuningNotes;

/*** Constructor ***
 * Initializes with strings and their tunings and the number of frets
 *
 * Inputs:
 * [NSArray*] strings : Array of NCNote objects enums detailing what note each
 *                      string is tuned to. 0th position is lowest string
 *                      going up from there
 * [NSUInteger] frets : number of frets (or note positions) on the neck
 ***/
- (id) initWithModel:(NCNotesModel*)model strings:(NSArray*)strings andFrets:(NSUInteger)frets;

/* Helper Functions */

/* returns an x,y point where:
 *     x = fret
 *     y = string
 *
 * returns { -1, -1 } if none is found
 *
 * This method searches forward 4 or less frets forward (depending where the fret sliders are)
 * for each note, starting on the lowest string and fret in the fret- and stringRange. Checks
 * all frets on a string before moving to the next string
 */
- (CGPoint) findNextNote:(NCNote*)note startingAt:(CGPoint)startingPoint inFretRange:(NSRange)fretRange andStringRange:(NSRange)stringRange relativeToOctave:(NSInteger)octave;
- (NCStringedView*) stringedView;

/*
 * Finds all notes in the given fret and string range.
 * The returned array has been autoreleased. The array will contain
 * NSValue objects which contain CGPoints objects, which can be accessed like so:
 * 
 *    CGPoint point = [[array objectAtIndex:0] CGPointValue];
 *
 * Essentially works the same as findNextNote except it returns all notes
 * that match irrespective of octave
 */
- (NSArray*) findAllNotes:(NCNote*)note startingAt:(CGPoint)startingPoint inFretRange:(NSRange)fretRange andStringRange:(NSRange)stringRange;



/*
 * This function references the model to determine which "mode" it is in and makes the right
 * notes show up accordingly
 */
- (void) executeNoteLogic:(NCNotesModel*) source notePressed:(NCNote*)note relativeOctave:(NSInteger)relativeOctave withPressedState:(BOOL)pressed;


- (NCStringedView*) stringedView;

/*
 * This method should be overridden in subclasses in order to load up the appropriate images
 * for an instrument
 */
- (void) initImages;

/*
 * Does the logic to tell the model that the lowest note has changed. Helps keep the code dry.
 *   BOOL active - if the view is active, lowest note should always be  0, otherwise, grab
 *                 it from the stringed view.
 */
- (void) updateLowestNote:(BOOL)active;


@end
