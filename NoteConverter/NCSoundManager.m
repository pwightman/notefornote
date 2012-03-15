//
//  NCSoundManager.m
//  NoteConverter
//
//  Created by Parker Wightman on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCSoundManager.h"
#import <AVFoundation/AVFoundation.h>
//#import "Sound.h"


#pragma mark -
#pragma mark Private Interface
@interface NCSoundManager ()
@end

#pragma mark -
@implementation NCSoundManager

#pragma mark Constructors
- (id) initWithType:(NCSoundType)type andRange:(NSRange)range
{
    self = [super init];
    if (self == nil)
        return nil;

	_playingSounds = [[NSMutableDictionary alloc] initWithCapacity:10];
	
	if (type == NCSoundBassJared) {
		_fileName = @"jared_bass_";
	}
	else if (type == NCSoundGuitarCollin)
		_fileName = @"collin_guitar_";

	_lowestNote = range.location;
	
	for( int i = range.location; i <= range.length; i++ )
	{
		[[OALSimpleAudio sharedInstance] preloadEffect:[self fileString:i]];
	}
    return self;
}

- (void) setSampleGain:(float)gain
{
	_gain = gain;
}

- (void) playSound:(NSUInteger)midiValue
{
	NSString* filename = [self fileString:midiValue];

	/* Only play the sound if it's not already being played */
	if ([_playingSounds objectForKey:filename] == nil) {
		id<ALSoundSource> source = [[OALSimpleAudio sharedInstance] playEffect:filename];
		[_playingSounds setValue:source forKey:filename];
	}

}

- (void) stopSound:(NSUInteger)midiValue
{
	id<ALSoundSource> source = [_playingSounds objectForKey:[self fileString:midiValue]];
	[_playingSounds removeObjectForKey:[self fileString:midiValue]];
	[source stop];
}

- (NSString*) fileString:(NSUInteger)midiValue
{
	return [NSString stringWithFormat:@"%@%i.wav", _fileName, midiValue];
}

- (void) dealloc
{
	[_fileName release];
	[_playingSounds release];
	[[OALSimpleAudio sharedInstance] unloadAllEffects];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

#pragma mark -
#pragma mark Methods

@end
