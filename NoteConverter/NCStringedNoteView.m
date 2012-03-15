//
//  NCStringedNoteView.m
//  NoteConverter
//
//  Created by Parker Wightman on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCStringedNoteView.h"

#pragma mark -
#pragma mark Private Interface
@interface NCStringedNoteView ()
@end

#pragma mark -
@implementation NCStringedNoteView

#pragma mark Constructors
- (id) initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
	if (self == nil)
		return nil;

	_textView = [[UILabel alloc] initWithFrame:[self frame]];

	[_textView setBackgroundColor:[UIColor clearColor]];
	[_textView setFont:[UIFont fontWithName:@"Optima-BoldItalic" size:20.0f]];
	[_textView setUserInteractionEnabled:TRUE];
    [self setExclusiveTouch:FALSE];
    [_textView setExclusiveTouch:FALSE];
    [_textView setMultipleTouchEnabled:TRUE];
    [self setMultipleTouchEnabled:TRUE];
	[self addSubview:_textView];
	[_textView setTextAlignment:UITextAlignmentCenter];
	[_textView setTextColor:[UIColor whiteColor]];
	//	[self bringSubviewToFront:_textView];
	
	[self setBackgroundColor:[UIColor clearColor]];
	[self setUserInteractionEnabled:TRUE];

	[self setContentMode:UIViewContentModeCenter];
	[self setImage:nil];
	[_textView setHidden:TRUE];
    return self;
}

- (void) dealloc 
{
	[_indicator release];
	[_textView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize string;
@synthesize fret;
@synthesize indicator = _indicator;
@synthesize  pressed = _pressed;
- (void) setPressed:(BOOL)pressed
{
	_pressed = pressed;
	if (_pressed) {
		[self setImage:_indicator];
		//[_textView setHidden:FALSE];
	}
	else
	{
		[self setImage:nil];
		//[_textView setHidden:TRUE];
	}
	[self setNeedsDisplay];
}
#pragma mark -
#pragma mark Methods

#pragma mark UIView Methods

- (void) layoutSubviews
{
	[_textView setFrame:[self bounds]];
}

- (void) setText:(NSString *)text
{
	[_textView setText:text];
}

- (void) setTextColor:(UIColor*)color
{
	[_textView setTextColor:color];
}


@end
