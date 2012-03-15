//
//  NCNote.h
//  NoteConverter
//
//  Created by Parker Wightman on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
typedef enum {
	NCNoteABSMIN = 0,
	NCNoteMIN = 0,
	NCNoteC = 0,
	NCNoteCsharp = 1,
	NCNoteDflat = 1,
	NCNoteD = 2,
	NCNoteDsharp = 3,
	NCNoteEflat = 3,
	NCNoteE = 4,
	NCNoteF = 5,
	NCNoteFsharp = 6,
	NCNoteGflat = 6,
	NCNoteG = 7,
	NCNoteGsharp = 8,
	NCNoteAflat = 8,
	NCNoteA = 9,
	NCNoteAsharp = 10,
	NCNoteBflat = 10,
	NCNoteB = 11,
	NCNoteMAX = 11,
	NCNoteABSMAX = 127
} NCNoteType;

@interface NCNote : NSObject <NSCopying>
{
	NCNoteType _type;
	NSInteger _octave;
	NSInteger _absValue;
}

@property (readonly) NCNoteType type;
@property (readonly) NSInteger octave;
@property (readonly) NSInteger absValue;

- (id) initWithType:(NCNoteType)type octave:(NSInteger)octave;
- (id) initWithValue:(NSInteger)absValue;
- (NSString*) typeToString;
- (NSComparisonResult) compare:(NCNote*)other;
+ (NSArray*) whiteKeyNotes;
+ (NSArray*) blackKeyNotes;
+ (UIColor*) colorForNote:(NCNote*)note;

/**
 * Returns an absolute value of the note, can be used to
 * compare whether some note is "higher" or "lower" than another
 */


@end
