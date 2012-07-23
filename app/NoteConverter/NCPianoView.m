//
//  NCPianoView.m
//  NoteConverter
//
//  Created by Parker Wightman on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCPianoView.h"
#import "NCPianoKeyView.h"

#pragma mark -
#pragma mark Private Interface
@interface NCPianoView ()
- (void) animateNotes;
@end

#pragma mark -
@implementation NCPianoView

#pragma mark Constructors
- (id) initWithFrame:(CGRect)frame andWhiteKeys:(NSUInteger)whiteKeys
{
    self = [super initWithFrame:frame];
	if (self == nil)
		return nil;
	_animating = NO;
	_totalWhiteKeys = whiteKeys;
	[self setExclusiveTouch:FALSE];
	[self setMultipleTouchEnabled:TRUE];
	_keys = [[NSMutableDictionary alloc] initWithCapacity:(_totalWhiteKeys + (_totalWhiteKeys /7)*5)];
	_blackKeys = [[NSMutableArray alloc] initWithCapacity:13];

	// TODO: We shouldn't have to changed this manually!
	_lowestNote = [[NCNote alloc] initWithType:NCNoteE octave:2];
	
    return self;
}

- (void) dealloc 
{
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (void) setLowestNote:(NCNote *)note withAnimation:(BOOL)animated
{
//	if (_lowestNote != nil) {
//		[_lowestNote release];
//	}
	
	_lowestNote = note;
//	[_lowestNote retain];
	
	if (animated) {
		[self animateNotes];
	}
	else
		[self setNeedsLayout];
}
#pragma mark -
#pragma mark Methods


- (void) setKey:(NCNote*)note toPressedState:(BOOL)pressed
{
	NCPianoKeyView* view = [_keys valueForKey:[NSString stringWithFormat:@"%i%i", note.type, note.octave]];
    [view setIndicatorImage:note.image];
	[view setPressed:pressed];
}

- (void) clearKeys
{
	NSArray* keys = [_keys allValues];
	for (int i = 0; i < [keys count]; i++) {
		[[keys objectAtIndex:i] setPressed:FALSE];
	}
}
#pragma mark UIView Methods

- (void) layoutSubviews
{
	if (_animating) {
		return;
	}
	// Clear out the view of all previous keys
	[[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

	[_blackKeys removeAllObjects];

	
	[_keys release];
	_keys = [[NSMutableDictionary alloc] init];
	
	float width = self.bounds.size.width;
	float height = self.bounds.size.height;
	NCPianoKeyView* key;
	NSInteger currentOctave = _lowestNote.octave;
	NCNoteType currentType = _lowestNote.type;
	NSInteger numWhiteKeys = 0;
	
	float keyX = 0, keyY = 0, keyWidth = 0, keyHeight = 0;
	NCPianoKeyStyle style;
	
	while (numWhiteKeys != _totalWhiteKeys) 
	{
		switch (currentType) {
			case NCNoteC:
			case NCNoteD:
			case NCNoteE:
			case NCNoteF:
			case NCNoteG:
			case NCNoteA:
			case NCNoteB:
				keyY = 0;
				keyWidth = width * (1.0f/_totalWhiteKeys);
				keyX = (keyWidth*numWhiteKeys);
				keyHeight = height;
				style = NCPianoKeyStyleWhite;
				numWhiteKeys++;
				break;
			case NCNoteCsharp:
			case NCNoteDsharp:
			case NCNoteFsharp:
			case NCNoteGsharp:
			case NCNoteAsharp:
				keyWidth = [UIImage imageNamed:@"blackKey"].size.width;
				keyX = (width/_totalWhiteKeys)*(numWhiteKeys) - (keyWidth/2);
				keyY = 0;
				keyHeight = [UIImage imageNamed:@"blackKey"].size.height;
				style = NCPianoKeyStyleBlack;
			default:
				break;
		}
		
		CGRect newFrame = CGRectMake(keyX, keyY, keyWidth, keyHeight);
		key = [[NCPianoKeyView alloc] initWithFrame:newFrame andStyle:style];
		[self addSubview:key];
		[key setType:currentType];
		[key setOctave:currentOctave];
		[_keys setValue:key forKey:[NSString stringWithFormat:@"%i%i", [key type], [key octave]]];
		if (key.style == NCPianoKeyStyleBlack) {
			[_blackKeys addObject:key];
		}

		// Free the memorry since the view and dictionary retain it
		[key release];
		
		currentType++;
		if (currentType > NCNoteMAX) {
			currentType = NCNoteMIN;
			currentOctave++;
		}
		
	
		
	}
	
	for (int i = 0; i < [[self subviews] count]; i++) {
		NCPianoKeyView* view = [[self subviews] objectAtIndex:i];
		if ([view style] == NCPianoKeyStyleBlack) {
			[self bringSubviewToFront:view];
		}
	}
	
}

/*
 * Animates the movement of notes based off the _lowestNote instances variable (which has
 * presumably been changed or there would be no reason to animate the notes). It calculates
 * which black keys can be moved to their new location, and how many would need to appear/
 * disappear, then commits the animations. Works great!
 */
- (void) animateNotes
{
    // This helps mitigate the problem where when the piano first appears, the keys
    // are invisible for a second.
    if (_keys.count == 0) {
        return;
    }
	_animating = YES;
	
	// For convenience...
	float width = self.bounds.size.width;
	
	NCPianoKeyView* key;
	NSInteger currentOctave = _lowestNote.octave;
	NCNoteType currentType = _lowestNote.type;
	NSInteger numWhiteKeys = 0;
	
	NSMutableArray* appearingKeys = [[NSMutableArray alloc] initWithCapacity:5];
	NSMutableArray* disappearingKeys = [[NSMutableArray alloc] initWithCapacity:5];
	NSMutableArray* rearrangedKeyRects = [[NSMutableArray alloc] initWithCapacity:[_blackKeys count]];
	
	float keyX, keyY, keyWidth, keyHeight;
	NCPianoKeyStyle style;
	
	while (numWhiteKeys != _totalWhiteKeys) 
	{
		switch (currentType) {
			case NCNoteC:
			case NCNoteD:
			case NCNoteE:
			case NCNoteF:
			case NCNoteG:
			case NCNoteA:
			case NCNoteB:
				// This is basically just here to get it to keep going
				// No action needs to be taken for white keys
				style = NCPianoKeyStyleWhite;
				numWhiteKeys++;
				currentType++;
				if (currentType > NCNoteMAX) {
					currentType = NCNoteMIN;
					currentOctave++;
				}
				continue;
				break;
			case NCNoteCsharp:
			case NCNoteDsharp:
			case NCNoteFsharp:
			case NCNoteGsharp:
			case NCNoteAsharp:
				keyWidth = [UIImage imageNamed:@"blackKey"].size.width;
				keyX = (width/_totalWhiteKeys)*(numWhiteKeys) - (keyWidth/2);
				keyY = 0;
				keyHeight = [UIImage imageNamed:@"blackKey"].size.height;
				style = NCPianoKeyStyleBlack;
			default:
				break;
		}
		
		CGRect newFrame = CGRectMake(keyX, keyY, keyWidth, keyHeight);
		// This is if there are still keys left that can be rearranged
		// instead of appearing or disappearing
		if ([_blackKeys count] > [rearrangedKeyRects count]) 
		{
			[rearrangedKeyRects addObject:[NSValue valueWithCGRect:newFrame]];
			// Get out the corresponding key and update its values
			NCPianoKeyView* view = [_blackKeys objectAtIndex:[rearrangedKeyRects count] - 1];
			[view setType:currentType];
			[view setOctave:currentOctave];
		
		}
		else // Otherwise, there were more than are currently available so add them
		{
			key = [[NCPianoKeyView alloc] initWithFrame:newFrame andStyle:style];
			key.alpha = 0.0f; // The animation will make it appear
			[self addSubview:key];
			[appearingKeys addObject:key];
			[key setType:currentType];
			[key setOctave:currentOctave];
			[key release];
		}
		

		
		// Free the memorry since the view and dictionary retain it
		
		
		currentType++;
		if (currentType > NCNoteMAX) 
		{
			currentType = NCNoteMIN;
			currentOctave++;
		}
	}
	
	// If there are still more black keys than the new ones
	// then they need to disappear
	if ([_blackKeys count] > [rearrangedKeyRects count]) 
	{
		for (int i = [rearrangedKeyRects count]; i < [_blackKeys count]; i++) 
		{
			[disappearingKeys addObject:[_blackKeys objectAtIndex:i]];
		}
	}
	
	
	// Swap out the values of the old keys with the new ones (loop)
	//[_keys setValue:key forKey:[NSString stringWithFormat:@"%i%i", [key type], [key octave]]];
	
	// Add new keys to the dictionary
	
	// commit animation
	
	[UIView animateWithDuration:0.5
						  delay: 0.0
						options: UIViewAnimationCurveEaseInOut
					 animations:^{
						 // Change the rects of existing keys
						 for (int i = 0; i < MIN([rearrangedKeyRects count], [_blackKeys count]) ; i++) 
						 {
							 NCPianoKeyView* view = [_blackKeys objectAtIndex:i];
							 view.frame = [[rearrangedKeyRects objectAtIndex:i] CGRectValue];
						 }
						 // disappear any extra keys
						 for (int i = 0; i < [disappearingKeys count]; i++) 
						 {
							 NCPianoKeyView* view = [disappearingKeys objectAtIndex:i];
							 view.alpha = 0.0f;
						 }
						 // appear any new keys
						 for (int i = 0; i < [appearingKeys count]; i++) 
						 {
							 NCPianoKeyView* view = [appearingKeys objectAtIndex:i];
							 view.alpha = 1.0f;
						 }
					 }
					 completion:^(BOOL finished){
						 
						 // Do some clean up and make sure the number of black keys is
						 // correct (this is actually slightly unneccessary since layoutSubviews
						 // will clean most of this up, but it helps for debugging)
						 [_blackKeys removeObjectsInArray:disappearingKeys];
						 [_blackKeys addObjectsFromArray:appearingKeys];
						 
						 // Remove the disappeared keys from the superview
						 for (int i = 0; i < [disappearingKeys count]; i++)
						 {
							 NCPianoKeyView* view = [disappearingKeys objectAtIndex:i];
							 [view removeFromSuperview];
						 }
						 _animating = NO;
						 [self setNeedsLayout];
						 [appearingKeys release];
						 [disappearingKeys release];
						 [rearrangedKeyRects release];
					 }];

}


@end
