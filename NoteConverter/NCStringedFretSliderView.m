//
//  NCStringedSliderView.m
//  NoteConverter
//
//  Created by Parker Wightman on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCStringedFretSliderView.h"



#pragma mark -
#pragma mark Private Interface
@interface NCStringedFretSliderView ()
@end

#pragma mark -
@implementation NCStringedFretSliderView

#pragma mark Constructors
- (id) init
{
    self = [super init];
    if (self == nil)
        return nil;
	
	[self setImage:[UIImage imageNamed:@"sliderFrets"]];
	_lightUp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fretboardIndicator"]];
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize delegate;
@synthesize fretPosition;
@synthesize lightUp = _lightUp;
#pragma mark -
#pragma mark Methods

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	CGPoint point = [[touches anyObject] locationInView:[self superview]];
	
	if(![delegate fretSliderTouched:self atPoint:point])
		return;

	self.center = CGPointMake(point.x, self.center.y);
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint point = [[touches anyObject] locationInView:[self superview]];
	if (![delegate fretSliderMoved:self toPoint:point]) {
		return;
	}

	self.center = CGPointMake(point.x, self.center.y);
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint point = [[touches anyObject] locationInView:[self superview]];
	[delegate fretSliderReleased:self atPoint:point];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesEnded:touches withEvent:event];
}

@end
