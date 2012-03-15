//
//  NCSoundManager.h
//  NoteConverter
//
//  Created by Parker Wightman on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ObjectAL.h"

typedef enum
{
	NCSoundGuitarCollin,
	NCSoundBassJared
} NCSoundType;


@interface NCSoundManager : NSObject 
{
	NSUInteger _lowestNote;		// Necessary for accessing the array at the right location
	float _gain; // Defaults to 1.0f
	NSString* _fileName;
	NSMutableDictionary* _playingSounds;
}

- (id) initWithType:(NCSoundType)type andRange:(NSRange)range;
- (void) playSound:(NSUInteger)midiValue;
- (void) stopSound:(NSUInteger)midiValue;
- (void) setSampleGain:(float)gain;
- (NSString*) fileString:(NSUInteger)midiValue;


@end
