//
//  NCNotesModel.h
//  NoteConverter
//
//  Created by Parker Wightman on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "NCNote.h"

typedef enum {
	NCNotesModelModeNormal,
	NCNotesModelModeChord,
	NCNotesModelModeScale
} NCNotesModelMode;


@class NCNotesModel;

@protocol NCNotesModelDelegate <NSObject>

@optional
- (void) notesModel:(NCNotesModel*)source noteReleased:(NCNote*)note relativeOctave:(NSInteger)relativeOctave;
- (void) notesModel:(NCNotesModel*) source notePressed:(NCNote*)note relativeOctave:(NSInteger)relativeOctave;
- (NCNote*) getLowestNoteForNotesModel:(NCNotesModel*)source;
/*
 * This can be implemented if the instrument cares to know what the opposing instruments
 * lowest range is being modified to
 */
- (void) notesModel:(NCNotesModel*)source lowestNoteHint:(NCNote*)note;

@end

@interface NCNotesModel : NSObject 
{
    NSMutableSet* _notes;
	NSMutableArray* _delegates;
}

@property (nonatomic) NCNotesModelMode mode;
@property (nonatomic) BOOL showNotes;

// Relative octave is passed around to give some indication of where on the source instrument
// the note was pressed without having to identify which kind of instrument it is
- (void) instrument:(NSObject<NCNotesModelDelegate>*)source submitNotePressed:(NCNote *)note relativeOctave:(NSInteger)relativeOctave;
- (void) instrument:(NSObject<NCNotesModelDelegate>*)source submitNoteReleased:(NCNote *)note relativeOctave:(NSInteger)relativeOctave;
- (void) instrument:(NSObject<NCNotesModelDelegate> *)source lowestNoteChanged:(NCNote*)note;
- (void) addDelegate:(id<NCNotesModelDelegate>)delegate;
- (void) clearDelegates;

/*
 * Returns an array of the notes in ascending order
 */
- (NSArray*)notes;

@end
