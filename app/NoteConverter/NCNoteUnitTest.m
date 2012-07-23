//
//  NCNoteUnitTest.m
//  NoteConverter
//
//  Created by Parker Wightman on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCNoteUnitTest.h"

#pragma mark -
#pragma mark Private Interface
@interface NCNoteUnitTest ()
@end

#pragma mark -
@implementation NCNoteUnitTest

#pragma mark Constructors
- (id) init
{
    self = [super init];
    if (self == nil)
        return nil;
    
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

- (void) runAllTests
{
	[self absToTypeAndOctave];
	[self typeAndOctaveToAbsValue];
	[self copyTest];
    [self relativeOctaveTests];
}

- (void) absToTypeAndOctave
{
	for(int i = 0; i < 128; i++)
	{
		NCNote* note = [[NCNote alloc] initWithValue:i];
		
		// NSAssert(note.type == (i%12) && note.octave == (i/12 - 1), @"NCNoteUnitTest: inconsistency where absValue is %i and type and octave are %@ %i", note.absValue, [note typeToString:note.type], note.octave);
		[note release];
	}
}

- (void) typeAndOctaveToAbsValue
{
	for(int i = 0; i < 128; i++)
	{
		NCNote* note = [[NCNote alloc] initWithType:i%12 octave:i/12 - 1];
		
		// NSAssert(note.absValue == i, @"NCNoteUnitTest: inconsistency where absValue is %i and type and octave are %@ %i", note.absValue, [note typeToString:note.type], note.octave);
		[note release];
	}
}

- (void) copyTest
{
	NCNote* oldNote = [[NCNote alloc] initWithValue:10];
	NCNote* note = [oldNote copy];
	// NSAssert(note.type == NCNoteAsharp && note.octave == -1 && note.absValue == 10, @"NCNoteUnitTest: note value doesn't match 10: type - %i, octave - %i, absValue - %i", note.type, note.octave, note.absValue);
	[oldNote release];
	[note release];
}

- (void) relativeOctaveTests
{
    NCNote* note_g1 = [[NCNote alloc] initWithType:NCNoteG octave:1];
    
    NCNote* note_a1 = [[NCNote alloc] initWithType:NCNoteA octave:1];
    NCNote* note_c2 = [[NCNote alloc] initWithType:NCNoteC octave:2];
    NCNote* note_fsharp2 = [[NCNote alloc] initWithType:NCNoteFsharp octave:2];
    NCNote* note_g2 = [[NCNote alloc] initWithType:NCNoteG octave:2];
    
    test([note_g1 octavesFrom:note_a1] ==  0, @"g1 should be 0 octaves from a1");
    test([note_g1 octavesFrom:note_c2] == 0, @"g1 should be 0 octaves from c2");
    test([note_g1 octavesFrom:note_fsharp2] == 0, @"g1 should be 0 octaves from fsharp2");
    test([note_g1 octavesFrom:note_g2] == 1, @"g1 should be 1 octaves from g2");
}



@end

void test(bool condition, NSString* test)
{
    if (!condition)
    {
        NSLog(@"FAILED %@\n\nExpected:", test);
    }
}
