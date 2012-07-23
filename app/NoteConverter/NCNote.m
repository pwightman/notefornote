//
//  NCNote.m
//  NoteConverter
//
//  Created by Parker Wightman on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "NCNote.h"

#pragma mark -
#pragma mark Private Interface
@interface NCNote ()
- (void) computeAbsValue;
- (void) computeTypeAndOctave;
@end

#pragma mark -
@implementation NCNote

#pragma mark Constructors
- (id) init { return nil; }
- (id) initWithType:(NCNoteType)type octave:(NSInteger)octave
{
    self = [super init];
    if (self == nil)
        return nil;
	
	// NSAssert(type >= NCNoteC && type <= NCNoteB, @"NCNote: Invalid type: %i", type);
	// NSAssert(octave >= -1 && octave <= 9, @"NCNote: Invalid octave: %i", octave);
	
	_type = type;
	_octave = octave;
	[self computeAbsValue];
	
    return self;
}

- (id) initWithValue:(NSInteger)absValue
{
	self = [super init];
    if (self == nil)
        return nil;
	
	// NSAssert(absValue >= NCNoteABSMIN && absValue <= NCNoteABSMAX, @"NCNote: Invalid absValue: %i", absValue);
	
	_absValue = absValue;
	[self computeTypeAndOctave];
	
    return self;
}


- (void) dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

@synthesize type = _type;
@synthesize octave = _octave;
@synthesize absValue = _absValue;
#pragma mark -
#pragma mark Methods

- (void) computeAbsValue
{
	int temp = (_octave + 1) * 12;
	_absValue = temp + _type;

}

- (void) computeTypeAndOctave
{
	_type = _absValue % 12;
	_octave = _absValue / 12 - 1;
	
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"%@%i", [self typeToString], self.octave];
	//return [NSString stringWithFormat:@"Type: %@ Octave: %i", [self typeToString:[self type]], [self octave]];
}

- (NSString*) typeToString;
{
	NSString* newString;
	switch (self.type) {
		case NCNoteC:
			newString = @"C";
			break;
		case NCNoteCsharp:
			newString= @"C#";
			break;
		case NCNoteD:
			newString= @"D";
			break;
		case NCNoteDsharp:
			newString= @"D#";
			break;
		case NCNoteE:
			newString= @"E";
			break;
		case NCNoteF:
			newString= @"F";
			break;
		case NCNoteFsharp:
			newString= @"F#";
			break;
		case NCNoteG:
			newString= @"G";
			break;
		case NCNoteGsharp:
			newString= @"G#";
			break;
		case NCNoteA:
			newString= @"A";
			break;
		case NCNoteAsharp:
			newString= @"A#";
			break;
		case NCNoteB:
			newString= @"B";
			break;
		default:
			//NSAssert(FALSE, @"Bad type sent to typeToString: %i", type);
			break;
	}
	
	return newString;
}

- (BOOL) isEqual:(id)object
{
	NCNote* note = (NCNote*)object;
	return note.absValue == self.absValue ;
}

- (NSComparisonResult) compare:(NCNote *)other
{
	if (self.absValue > other.absValue)
		return NSOrderedAscending;
	else if (self.absValue < other.absValue )
		return NSOrderedDescending;
	else
		return NSOrderedSame;
}

- (id) copyWithZone:(NSZone *)zone
{
	NCNote* note = [[NCNote alloc] initWithValue:self.absValue];
	return note;
}

+ (NSArray*) whiteKeyNotes
{
	NSMutableArray* array = [[[NSMutableArray alloc] initWithCapacity:7] autorelease];
	[array addObject:[NSNumber numberWithInt: NCNoteC]];
	[array addObject:[NSNumber numberWithInt: NCNoteD]];
	[array addObject:[NSNumber numberWithInt: NCNoteE]];
	[array addObject:[NSNumber numberWithInt: NCNoteF]];
	[array addObject:[NSNumber numberWithInt: NCNoteG]];
	[array addObject:[NSNumber numberWithInt: NCNoteA]];
	[array addObject:[NSNumber numberWithInt: NCNoteB]];
	return array;

}

+ (NSArray*) blackKeyNotes
{
	NSMutableArray* array = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
	[array addObject:[NSNumber numberWithInt: NCNoteCsharp]];
	[array addObject:[NSNumber numberWithInt: NCNoteDsharp]];
	[array addObject:[NSNumber numberWithInt: NCNoteFsharp]];
	[array addObject:[NSNumber numberWithInt: NCNoteGsharp]];
	[array addObject:[NSNumber numberWithInt: NCNoteAsharp]];
	
	return array;
}

+ (UIColor*)colorForNote:(NCNote*)note
{
	UIColor* color;
	switch (note.type) {
		case NCNoteC:
			color = [UIColor redColor];
			break;
		case NCNoteCsharp:
			color = [UIColor blueColor];
			break;
		case NCNoteD:
			color = [UIColor greenColor];
			break;
		case NCNoteDsharp:
			color = [UIColor yellowColor];
			break;
		case NCNoteE:
			color = [UIColor orangeColor];
			break;
		case NCNoteF:
			color = [UIColor purpleColor];
			break;
		case NCNoteFsharp:
			color = [UIColor cyanColor];
			break;
		case NCNoteG:
			color = [UIColor brownColor];
			break;
		case NCNoteGsharp:
			color = [UIColor magentaColor];
			break;
		case NCNoteA:
			color = [UIColor lightGrayColor];
			break;
		case NCNoteAsharp:
			color = [UIColor whiteColor];
			break;
		case NCNoteB:
			color = [UIColor darkGrayColor];
			break;
		default:
			//NSAssert(FALSE, @"Bad type sent to typeToString: %i", type);
			break;
	}
	return color;
}

- (UIImage*) image
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"indicator_%@",[self typeToString]]];
}

- (NSInteger) octavesFrom:(NCNote *)other
{
    NSInteger difference = other.absValue - self.absValue;
    
    return difference / (NCNoteMAX + 1);
}


@end
