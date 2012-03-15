//
//  NCNoteUnitTest.h
//  NoteConverter
//
//  Created by Parker Wightman on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCNote.h"

@interface NCNoteUnitTest : NSObject 
{
    
}

/* Runs all tests in the file*/
- (void) runAllTests;
/* Unit test for making sure notes created using absolute notes
 * have the correct type and octave
 */
- (void) absToTypeAndOctave;
/*
 * Unit test for making sure notes created using type and octave return
 * the correct absolute value
 */
- (void) typeAndOctaveToAbsValue;

/*
 * Tests the copying of notes to make sure they return the right value
 */
- (void) copyTest;

@end
