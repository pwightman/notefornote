//
//  NCStringedView.m
//  NoteConverter
//
//  Created by Parker Wightman on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCStringedView.h"

#pragma mark -
#pragma mark Private Interface
@interface NCStringedView ()
- (void) setFretGlowPosition:(CGPoint)point forView:(NCStringedFretSliderView*)view;
- (void) setStringGlowPosition:(CGPoint)point forView:(NCStringedStringSliderView*)view;
@end

#pragma mark -
@implementation NCStringedView

#pragma mark Constructors
- (id) initWithStrings:(NSUInteger)strings frets:(NSUInteger)frets
{
	_leftShadowView = [[NCStringedShadowView shadowViewWithType:NCStringedShadowLeftGradient] retain];
	_rightShadowView = [[NCStringedShadowView shadowViewWithType:NCStringedShadowRightGradient] retain];
	
    self = [super init];
	if (self == nil)
		return nil;
	
    [self setExclusiveTouch:FALSE];
	[self setMultipleTouchEnabled:TRUE];
	
	_lowFretSlider = [[NCStringedFretSliderView alloc] init];
	_highFretSlider = [[NCStringedFretSliderView alloc] init];
	

	
	[self addSubview:_lowFretSlider];
	[self addSubview:_highFretSlider];
	
	_head = [[UIImageView alloc] init];
	[self addSubview:_head];

	_neckBackground = [[UIImageView alloc] init];
	[self addSubview:_neckBackground];
	
	_neck = [[UIImageView alloc] init];
	[self addSubview:_neck];

	
	_inlayViews = [[NSMutableArray alloc] initWithCapacity:strings];
	
	// Create inlay views
	for (int i = 0; i < strings; i++) {
		UIImageView* newImageView = [[UIImageView alloc] init];
		[_inlayViews addObject:newImageView];
		[_neck addSubview:newImageView];
		[newImageView release];
	}
	
	/*
	 * Create all the fret views and store them
	 */
	_frets = [[NSMutableArray alloc] initWithCapacity:frets];
	_nutView = [[UIImageView alloc] init];
	[_neck addSubview:_nutView];
	[_nutView release];
	for( int fret = 0; fret < frets; fret++ )
	{
		UIImageView* fretView = [[UIImageView alloc] init];
		[_frets addObject:fretView];
		[_neck addSubview:fretView];
		[fretView release];
	}
	
	// Create string views themselves
	_stringViews = [[NSMutableArray alloc] initWithCapacity:strings];
	for (int i = 0; i < strings; i++) 
	{
		UIImageView* stringView = [[UIImageView alloc] init];
		[_stringViews addObject:stringView];
		[_neck addSubview:stringView];
		[stringView release];
	}
	
	_stringShadowViews = [[NSMutableArray alloc] initWithCapacity:strings];
	for (int i = 0; i < strings; i++) 
	{
		UIImageView* stringView = [[UIImageView alloc] init];
		[_stringShadowViews addObject:stringView];
		[_neck addSubview:stringView];
		[stringView release];
	}
	
	/*
	 * Add all the notes to the fretboard	
	 */
	_notes = [[NSMutableArray alloc] initWithCapacity:strings];
	for( int string = 0; string < strings; string++)
	{
		NSMutableArray* array = [NSMutableArray arrayWithCapacity:frets + 1];
        // NOTE: + 1 here because when laying out the notes, you have to include the
        // open string, which isn't necessary when laying out the visual stuff, just
        // the playable notes.
		for (int fret = 0; fret < frets + 1; fret++) {
			NCStringedNoteView* view = [[NCStringedNoteView alloc] init];
            [view setMultipleTouchEnabled:TRUE];
			[view setFret:fret];
			[view setString:string];
			[array addObject:view];
			[self addSubview:view];
			[view release];
			
		}
		[_notes addObject:array];
	}
	
	/* Debugging controls, ought to be removed in the end */
    return self;
}

- (void) dealloc 
{
	[_neck release];
	[_lowFretSlider release];
	[_lowStringSlider release];
	[_highFretSlider release];
	[_highStringSlider release];
	[_notes release];
	[_frets release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize delegate;
@synthesize neckImage = _neckImage;
@synthesize neckShadowImage = _neckShadowImage;
@synthesize fretImage = _fretImage;
@synthesize nutImage = _nutImage;
@synthesize stringImages = _stringImages;
@synthesize stringShadowImages = _stringShadowImages;
@synthesize inlayImages = _inlayImages;
@synthesize headImage = _headImage;
#pragma mark -
#pragma mark Methods

- (void) setPlayable:(BOOL)playable
{
    _playable = playable;
    [self setSliderState:!playable withAnimation:YES];
}

- (BOOL) playable
{
    return _playable;
}

- (void) setSliderState:(BOOL) enabled withAnimation:(BOOL)animated
{
    float newValue = enabled ? 1.0f : 0.0f;
    float duration = animated ? 0.3f : 0.0f;
    
    [UIView animateWithDuration:duration animations:^(void) {
        [_lowFretSlider setAlpha:newValue];
        [_highFretSlider setAlpha:newValue];
        [_leftShadowView setAlpha:newValue];
        [_rightShadowView setAlpha:newValue];
    }];
    
    [_lowFretSlider setUserInteractionEnabled:enabled];
    [_highFretSlider setUserInteractionEnabled:enabled];
}

#pragma mark UIView Methods
- (void) layoutSubviews
{
	// Set the frame of the guitar shadow
	[_head setImage:_headImage];
	// TODO: The + 2 here is a hack since the images aren't lining up
	[_head setFrame:CGRectIntegral(CGRectIntegral(CGRectMake(0, self.bounds.size.height/2 - _head.image.size.height/2 + 2, _head.image.size.width, _head.image.size.height)))];
	[self addSubview:_head];
	headOffset = _head.image.size.width;
	
	// This will proportion the neck appropriately
	[_neckBackground setImage:_neckShadowImage];
	
	[_neckBackground setFrame:CGRectIntegral(CGRectMake(headOffset, self.bounds.size.height/2 - _neckBackground.image.size.height/2, _neckBackground.image.size.width, _neckBackground.image.size.height))];
	
	// Set the frame of the neck of the guitar
	[_neck setImage:_neckImage];
	[_neck setFrame:CGRectIntegral(CGRectMake(headOffset, self.bounds.size.height/2.0f - _neck.image.size.height/2.0f, _neck.image.size.width, _neck.image.size.height))];
	
	// Add the frets to the neck
	// NOTE: First object in the array is the nut, it must be laid out differently
	
	[_nutView setImage:_nutImage];
	[_nutView setFrame:CGRectIntegral(CGRectMake(0, 0, _nutView.image.size.width, _nutView.image.size.height))];
	
	int inlayCount = 0;
    _fretboardSize = _neck.bounds.size.width - 20;
	
	/* Layout the frets and the fretboard inlays */
	for( int i = 0; i < [_frets count]; i++ )
	{

		UIImageView* fretView = [_frets objectAtIndex:i];
		[fretView setImage:_fretImage];
		float fretOffset = fretView.image.size.width / 2.0f;
		[fretView setFrame:CGRectIntegral(CGRectMake(_fretboardSize*(i + 1)*(1.0f/[_frets count]) - fretView.image.size.width/2.0f, 0, fretView.image.size.width, fretView.image.size.height))];
		UIImageView* tempInlayView;
		UIImage* tempInlayImage;
		switch (i) {
			case 2: 
			case 4: 
			case 6: 
			case 11:
				tempInlayView = [_inlayViews objectAtIndex:inlayCount];
				tempInlayImage = [_inlayImages objectAtIndex:inlayCount];
				[tempInlayView setImage:tempInlayImage];
				float neckX = _fretboardSize*(i + 1)*(1.0f/[_frets count]) - fretView.image.size.width/2.0f;
				float fretHalfWidth = _fretboardSize*(1.0f/[_frets count]) / 2.0f;
				
				float inlayHalfWidth = tempInlayView.image.size.width / 2.0f;
				float neckHalfHeight = _neck.bounds.size.height / 2.0f;
				float inlayHalfHeight = tempInlayView.image.size.height / 2.0f;
				[tempInlayView setFrame:CGRectIntegral(CGRectMake(neckX - fretHalfWidth - inlayHalfWidth + fretOffset, neckHalfHeight - inlayHalfHeight, tempInlayImage.size.width, tempInlayImage.size.height))];
				inlayCount++;
				break;
				
			default:
				break;
		}
		
	}
	
//	for (int i = 0; i < [_inlayViews count]; i++) {
//		[_neck bringSubviewToFront:[_inlayViews objectAtIndex:i] ];
//	}
	
	float noteHeight = _neck.bounds.size.height/[_stringViews count];
	// Layout string shadows
	for (int string = 0; string < [_stringShadowViews count]; string++) {
		UIImageView* stringView = [_stringShadowViews objectAtIndex:string];
		[stringView setImage:[_stringShadowImages objectAtIndex:string]];
		[stringView setFrame:CGRectIntegral(CGRectMake(0, noteHeight*string + noteHeight/2 + 3, stringView.image.size.width, stringView.image.size.height))];
		[self bringSubviewToFront:stringView];
	}
	
	// Layout the string views
	for (int string = 0; string < [_stringViews count]; string++) {
		UIImageView* stringView = [_stringViews objectAtIndex:string];
		[stringView setImage:[_stringImages objectAtIndex:string]];
		[stringView setFrame:CGRectIntegral(CGRectMake(0, noteHeight*string + noteHeight/2 - 5, stringView.image.size.width, stringView.image.size.height))];
		[self bringSubviewToFront:stringView];
	}
	

	
	// Layout all the notes
	for( int string = 0; string < [_notes count]; string++)
	{
		NSArray* frets = [_notes objectAtIndex:string];
        for (int fret = 0; fret < [frets count]; fret++) {
			NCStringedNoteView* noteView = [frets objectAtIndex:fret];
            float fretX;
            /* Accommodate for the special case of the open string */
            if (fret == 0) {
                fretX = 0;
            }
            else
                fretX = _fretboardSize*(fret - 1)*(1.0f/[_frets count]) + headOffset;
            
			[noteView setFrame:CGRectIntegral(
                                              CGRectMake(
                                                         fretX, 
                                                         string*_neck.bounds.size.height*(1.0f/[_notes count]) - 3 + _neck.frame.origin.y, 
                                                         _fretboardSize*(1.0f/[_frets count]),
                                                         _neck.bounds.size.height*(1.0f/[_notes count])
                                                         )
                                              )
             ];
			
            [self bringSubviewToFront:noteView];
		}
	}
	
	
	
	// Layout sliders
	[_lowFretSlider setFrame:CGRectIntegral(CGRectMake(/*_neck.frame.origin.x - _lowFretSlider.image.size.width/2*/ 0 , _neck.frame.origin.x - _lowFretSlider.image.size.height*0.66, _lowFretSlider.image.size.width, _lowFretSlider.image.size.height))];
	[_lowFretSlider setContentMode:UIViewContentModeCenter];
	[_lowFretSlider setDelegate:self];
	[_lowFretSlider setUserInteractionEnabled:TRUE];
	[_lowFretSlider setFretPosition:0];
	[[_lowFretSlider lightUp] setAlpha:0.0];
	[_neck addSubview:[_lowFretSlider lightUp]];
	
	// TODO: Remove the hack from here and above where I'm adding 20/2 and 20 to increase the width
	// of the sliders
	[_highFretSlider setFrame:CGRectIntegral(CGRectMake(_fretboardSize + headOffset  - _highFretSlider.image.size.width/2, _neck.frame.origin.x - _highFretSlider.image.size.height*0.66, _highFretSlider.image.size.width, _highFretSlider.image.size.height))];
	[_highFretSlider setContentMode:UIViewContentModeCenter];
	[_highFretSlider setDelegate:self];
	[_highFretSlider setFretPosition:[_frets count]];
	[_highFretSlider setUserInteractionEnabled:TRUE];
	[[_highFretSlider lightUp] setAlpha:0.0];
	[_neck addSubview:[_highFretSlider lightUp]];
	
	/* Shadows */
	[_leftShadowView setFrame:CGRectMake(0, 0, 0, _neck.bounds.size.height)];
	
	[_rightShadowView setFrame:CGRectMake(_fretboardSize, 0, 0, _neck.bounds.size.height)];
	[_neck addSubview:_leftShadowView];
	[_neck addSubview:_rightShadowView];
	

	[self bringSubviewToFront:_lowFretSlider];
	[self bringSubviewToFront:_highFretSlider];
    
    [self sendSubviewToBack:_head];
	
	/* Debugging controls layout */

}

/* Assumes the view was set correctly the first time */
- (void) adjustShadowRects
{
	CGRect newRect = _leftShadowView.frame;
//    if (_lowFretSlider.center.x < headOffset) {
//        newRect.size.width = 0;
//    }
//    else
        newRect.size.width = _lowFretSlider.center.x;   
    
    newRect.origin.x = 0 - headOffset;

	_leftShadowView.frame = newRect;
	
	newRect = _rightShadowView.frame;
	newRect.origin.x = _highFretSlider.center.x - headOffset;
	newRect.size.width = self.bounds.size.width - newRect.origin.x ;

	[_rightShadowView setFrame:newRect];
	
	[_leftShadowView setNeedsDisplay];
	[_rightShadowView setNeedsDisplay];
}

- (void) setFretGlowPosition:(CGPoint)point 
				 forView:(NCStringedFretSliderView*)view
{
	float fretSize = (_fretboardSize/[_frets count]);
	int fretBar = (int)(point.x/fretSize);
	
	float location = point.x - _headImage.size.width - fretSize*fretBar;
	
	CGPoint newPoint = point;
	
    // Hack to account for the 0th fret (open notes)
    if (point.x < headOffset*0.66f) {
        newPoint.x = 0 - headOffset;
        _glowPosition = 0;
    }
	else if (location < fretSize/2) {
		// Need to add head width to accomodate the neck being moved slightly
		newPoint.x = (int)(fretSize*fretBar);
		_glowPosition = fretBar;
	}
	else
	{
		newPoint.x = (int)(fretSize*(fretBar + 1));
		_glowPosition = fretBar + 1;
	}
	newPoint.y = 0;
	
	[[view lightUp] setCenter: newPoint];

}



// TODO: Get collision detection working!
- (BOOL) fretSliderTouched:(NCStringedFretSliderView *)slider atPoint:(CGPoint)point
{
	[[slider lightUp] setAlpha:0.5];
	[self setFretGlowPosition:point forView:slider];
	[self adjustShadowRects];
	return TRUE;
}

- (BOOL) fretSliderMoved:(NCStringedFretSliderView *)slider toPoint:(CGPoint)point
{
    /* If the sliders are too close, don't move it any closer! */
    if ([self slidersTooClose:point withMovedSlider:slider]) {
        return FALSE;
    }
	[self setFretGlowPosition:point forView:slider];
	[self adjustShadowRects];
	if (point.x > _neck.frame.origin.x + _fretboardSize) {
		return FALSE;
	}

	return TRUE;
}

- (void) initNotes
{
    for(int i = 0; i < _notes.count; i++)
    {
        NSArray* arr = [_notes objectAtIndex:i];
        for(int j = 0; j < arr.count; j++)
        {
            [[arr objectAtIndex:j] setIndicator:[UIImage imageNamed:[NSString stringWithFormat:@"indicator_%@", [delegate stringedView:self getNoteNameAtFret:j string:i]]]];
        }
    }
}

- (BOOL) slidersTooClose:(CGPoint)newPoint withMovedSlider:(NCStringedFretSliderView *)slider
{
    float fretSize = _fretboardSize/[_frets count];
    float highSliderX = _highFretSlider.center.x;
    float lowSliderX = _lowFretSlider.center.x;
    if (_highFretSlider == slider) {
        highSliderX = newPoint.x;
    }
    else
        lowSliderX = newPoint.x;
    
    float distance = highSliderX - lowSliderX;
    
    if (distance <= fretSize) {
        return TRUE;
    }

    return FALSE;
}

- (BOOL) fretSliderReleased:(NCStringedFretSliderView *)slider atPoint:(CGPoint)point
{
    /* If the sliders are too close, just move it to where the slider already is */
    if ([self slidersTooClose:point withMovedSlider:slider]) {
        point.x = slider.center.x;
    }
    
	float fretSize = (_fretboardSize/[_frets count]);

	int fretBar = (int)(point.x/fretSize);
	
	float location = point.x  - _headImage.size.width - fretSize*fretBar;

    CGPoint newPoint = point;
	NSInteger fretPos;
    // This is hack to make it possible to change the fret position to the 0th position
    if (point.x < headOffset*0.66f) {
        newPoint.x = 0;
        fretPos = 0;
    }
    else if (location < fretSize/2) {
		newPoint.x = (int)(fretSize*fretBar) + _headImage.size.width;
		fretPos = fretBar + 1;
	}
	else
	{
		newPoint.x = (int)(fretSize*(fretBar + 1)) + _headImage.size.width;;
		fretPos = fretBar + 2;
	}
	newPoint.y = slider.center.y;
	
	[UIView animateWithDuration:0.1f
						  delay: 0.0f
						options: UIViewAnimationCurveEaseIn
					 animations:^{
						 [slider setCenter:newPoint];
						 [[slider lightUp] setAlpha:0.0f];
						 [self adjustShadowRects];
					 }
					 completion:^(BOOL finished){ }];


	
	
	[slider setFretPosition:fretPos];
	
	[delegate stringedView:self modifiedFretRangeLow:[_lowFretSlider fretPosition] high:[_highFretSlider fretPosition]];
	
	

	return TRUE;
}

- (void) setNotePressed:(BOOL)pressed onString:(NSUInteger)string andFret:(NSUInteger)fret
{
	//// NSAssert(string >= 0 && string <= _notes.count, @"NCStringedView: Illegal access of string %i and fret %i", string, fret);
	//	// NSAssert(fret >= 0 && fret <= [[_notes objectAtIndex:string] count], @"NCStringedView: Illegal access of string %i and fret %i", string, fret);
	NCStringedNoteView* view = [[_notes objectAtIndex:string] objectAtIndex:fret];
	if (pressed) 
	{
		[view setTextColor:[[self delegate] stringedView:self getColorForNoteAtFret:fret string:string]];
		[view setText:[delegate stringedView:self getNoteNameAtFret:fret string:string]];
	}
	[view setPressed:pressed];
}

#pragma mark NCStringedNoteViewDelegate Methods

- (NSRange) getFretRange
{
    NSLog(@"fret position: %i", _lowFretSlider.fretPosition);
	return NSRangeFromString([NSString stringWithFormat:@"{%i, %i}", _lowFretSlider.fretPosition, _highFretSlider.fretPosition - _lowFretSlider.fretPosition]);
}
- (NSRange) getStringRange
{
	return NSRangeFromString([NSString stringWithFormat:@"{0, %i}", _notes.count]);
}




@end
