//
//  NCPianoViewController.h
//  NoteConverter
//
//  Created by Parker Wightman on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCInstrumentViewController.h"
#import "NCPianoKeyView.h"

@interface NCPianoViewController : NCInstrumentViewController
{
}

- (void) keyTouched:(NCPianoKeyView*)view;
- (void) keyReleased:(NCPianoKeyView*)view;
- (NCNote*) fittedNote:(NCNote*)note relativeOctave:(NSInteger)relativeOctave;

@end
