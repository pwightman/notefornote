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
		pressedImage = [UIImage imageNamed:@"blackKeyDepressed"];
		depressedImage = [UIImage imageNamed:@"blackKey"];
		keyColor = [UIColor blackColor];
    }
	else
	{
		pressedImage = [UIImage imageNamed:@"whiteKeyDepressed"];
		depressedImage = [UIImage imageNamed:@"whiteKey"];
		keyColor = [UIColor whiteColor];
	}
    
    [pressedImage retain];
    [depressedImage retain];
    
    self.indicatorView = [[[UIImageView alloc] init] autorelease];
    
    [self addSubview:self.indicatorView];
    
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

- (void) layoutSubviews
{
    CGSize indicatorSize = [UIImage imageNamed:@"indicator_A"].size;
    CGRect frame = CGRectMake(pressedImage.size.width/2.0f - indicatorSize.width/2.0f, 100.0f, indicatorSize.width, indicatorSize.height);
    if (style == NCPianoKeyStyleBlack)
    {
        frame.origin.y = 50.0f;
    }
    else if (style == NCPianoKeyStyleWhite)
    {
        frame.origin.y = 200.0f;
        
        // Bit twiddling...
        frame.origin.x -= 5.0f; 
    }
    
    indicatorView.frame = frame;

}

#pragma mark -
#pragma mark Accessors
@synthesize type;
@synthesize octave;
@synthesize pressed = _pressed;
@synthesize style;
@synthesize indicatorImage;
@synthesize indicatorView;

- (void) setPressed:(BOOL)pressed
{
	_pressed = pressed;
	if (_pressed) {
		[self setImage:pressedImage];
        self.indicatorView.image = self.indicatorImage;
        [self.indicatorView setAlpha:1.0f];
	}
	else {
		[self setImage:depressedImage];
        [self.indicatorView setAlpha:0.0f];
    }
}
#pragma mark -
#pragma mark Methods

#pragma mark UIView Methods

- (NSString*) description
{
	return [NSString stringWithFormat:@"%i%i", [self type], [self octave]];
}

@end
