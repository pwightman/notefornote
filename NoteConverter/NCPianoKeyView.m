//
//  NCPianoKeyView.m
//  NoteConverter
//
//  Created by Parker Wightman on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCPianoKeyView.h"

#pragma mark -
#pragma mark Private Interface
@interface NCPianoKeyView ()
@end

#pragma mark -
@implementation NCPianoKeyView

#pragma mark Constructors
- (id) initWithFrame:(CGRect)frame andStyle:(NCPianoKeyStyle)style
{
    self = [super initWithFrame:frame];
	if (self == nil)
		return nil;
	
	[self setStyle:style];
	if(style == NCPianoKeyStyleBlack)
	{
		pressedImage = [[UIImage imageNamed:@"blackKeyDepressed"] retain];
		depressedImage = [[UIImage imageNamed:@"blackKey"] retain];
		keyColor = [UIColor blackColor];
	}
	else
	{
		pressedImage = [[UIImage imageNamed:@"whiteKeyDepressed"] retain];
		depressedImage = [[UIImage imageNamed:@"whiteKey"] retain];
		keyColor = [UIColor whiteColor];
	}
	[self setExclusiveTouch:FALSE];
	[self setImage:depressedImage];
	
	// View will not respond to touch events without this line
	[self setUserInteractionEnabled:TRUE];
	
	[self setPressed:FALSE];
	
    return self;
}

- (void) dealloc 
{
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize type;
@synthesize octave;
@synthesize pressed = _pressed;
@synthesize style;

- (void) setPressed:(BOOL)pressed
{
	_pressed = pressed;
	if (_pressed) {
		[self setImage:pressedImage];
	}
	else
		[self setImage:depressedImage];
}
#pragma mark -
#pragma mark Methods

#pragma mark UIView Methods

- (NSString*) description
{
	return [NSString stringWithFormat:@"%i%i", [self type], [self octave]];
}

@end
