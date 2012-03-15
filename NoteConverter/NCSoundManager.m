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

@synthesize gain;

#pragma mark Constructors
- (id) initWithType:(NCSoundType)type andRange:(NSRange)range
{
    self = [super init];
    if (self == nil)
        return nil;
    
    gain = 1.0f;

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

- (void) playSound:(NSUInteger)midiValue
{
	NSString* filename = [self fileString:midiValue];

	/* Only play the sound if it's not already being played */
	if ([_playingSounds objectForKey:filename] == nil) {
        [self updateGain];
        id<ALSoundSource> source = [[OALSimpleAudio sharedInstance] playEffect:filename];
		[_playingSounds setValue:source forKey:filename];
	}

}

- (void) updateGain
{
    // Plus 1 because this is usually called just before another note gets added.	
    NSUInteger count = _playingSounds.count + 1;
    float newGain = 0.8f;
    if (count > 6)
        newGain -= 0.6f;
    else if (count > 2)
        newGain -= 0.4f;
    else if (count > 1)
        newGain -= 0.3f;
    
    [[OALSimpleAudio sharedInstance] setEffectsVolume:newGain];
 
    //NSLog(@"number of sounds: %i", _playingSounds.count);
    //NSLog(@"new gain: %f", newGain);
}

- (void) stopAllSounds
{
    for (id<ALSoundSource> source in _playingSounds)
    {
        [source stop];
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
