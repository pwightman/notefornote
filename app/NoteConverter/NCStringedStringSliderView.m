//
//  NCStringedStringSliderView.m
//  NoteConverter
//
//  Created by Parker Wightman on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCStringedStringSliderView.h"

#pragma mark -
#pragma mark Private Interface
@interface NCStringedStringSliderView ()
@end

#pragma mark -
@implementation NCStringedStringSliderView

#pragma mark Constructors
- (id) init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize delegate;
#pragma mark -
#pragma mark Methods

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	CGPoint point = [[touches anyObject] locationInView:[self superview]];
	
	if(![delegate stringSliderTouched:self atPoint:point])
		return;
	
	self.center = CGPointMake(self.center.x, point.y);
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint point = [[touches anyObject] locationInView:[self superview]];
	if (![delegate stringSliderMoved:self toPoint:point]) {
		return;
	}
	
	self.center = CGPointMake(self.center.x, point.y);
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint point = [[touches anyObject] locationInView:[self superview]];
	[delegate stringSliderReleased:self atPoint:point];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesEnded:touches withEvent:event];
}


@end
