//
//  NCInstrumentController.h
//  NoteConverter
//
//  Created by Parker Wightman on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "NCNotesModel.h"
#import "NCNote.h"
#import "NCSoundManager.h"

@protocol NCInstrumentViewDelegate <NSObject>

- (void) notePressedWithType:(NCNoteType)type andOctave:(NSInteger)octave;
- (void) noteReleasedWithType:(NCNoteType)type andOctave:(NSInteger)octave;

@end



@interface NCInstrumentViewController : UIViewController  <NCNotesModelDelegate>
{
    NCNotesModel* _model;
	NCSoundManager* _soundManager;
    NCNote* _lowNote;
}

- (void) setModel:(NCNotesModel*)model;
- (id) initWithModel:(NCNotesModel*)model andType:(NCInstrumentType)instrumentType;
- (id) initWithModel:(NCNotesModel*)model;
- (void) initSoundManagerWithType:(NCSoundType)soundType;

/*
 * These represent the range of notes on an instrument
 */
@property (nonatomic, retain) NCNote* lowNote;
@property (nonatomic, retain) NCNote* highNote;
@property (nonatomic, retain) NCSoundManager* soundManager;
@property (nonatomic) NCInstrumentType type;

@end

/*
 * Abstract interface! Woohoo! It does exist in Obj-C!
 */
@interface NCInstrumentViewController (Abstract)

- (void) willBecomeInactive;
- (void) willBecomeActive;

/* Helper method which should return the relative octave of a note on the instrument */
- (NSUInteger) relativeOctave:(NCNote*)note;

@end 
