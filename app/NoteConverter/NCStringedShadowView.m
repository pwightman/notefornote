//
//  NCStringedShadowView.m
//  NoteConverter
//
//  Created by Parker Wightman on 4/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCStringedShadowView.h"

#pragma mark -
#pragma mark Private Interface
@interface NCStringedShadowView ()
@end

#pragma mark -

@implementation NCStringedShadowView



#pragma mark Constructors
- (id) init
{
    self = [super init];
    if (self == nil)
        return nil;
    _shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] retain];
	[self setOpaque:FALSE];
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

+ (NCStringedShadowView*) shadowViewWithType:(NCStringedShadowType)type
{
	NCStringedShadowView* view = [[[NCStringedShadowView alloc] init] autorelease];
	
	[view setType:type];
	
	return view;
}

#pragma mark -
#pragma mark Accessors
@synthesize type;
#pragma mark -
#pragma mark Methods

- (void) setVariableCoordinate:(float)coordinate
{
	if ([self type] & NCStringedShadowMaskHorizontal) {
		//		CGRect rect = self.frame;
	}
}

- (void) drawRect:(CGRect)rect
{
	CGContextRef c = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColorWithColor(c, _shadowColor.CGColor);
	
	
	CGPoint startPoint = CGPointZero;
	CGPoint endPoint = CGPointZero;
	
	if (self.type == NCStringedShadowLeftGradient) 
	{
		startPoint = CGPointMake(self.frame.size.width - 30, self.center.y);
		endPoint = CGPointMake(self.frame.size.width, self.center.y);
		rect.size.width -= 30;
	}
	else if (self.type == NCStringedShadowRightGradient)
	{
		rect.origin.x += 30;
		rect.size.width += 30;
		startPoint = CGPointMake(30, self.center.y);
		endPoint = CGPointMake(0, self.center.y);
	}
	
	
	CGContextFillRect(c, rect);
	
	// TODO: Adding and subtracting 30 like this might not be the best thing...
	rect.size.width += 30;
	
	NSArray* colors = [NSArray arrayWithObjects:
					   (id)[_shadowColor CGColor], 
					   (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor], 
					   nil];

	
	
	
	CGGradientRef gradient = CGGradientCreateWithColors(NULL, (CFArrayRef)colors, NULL);
	CGContextDrawLinearGradient(c, 
								gradient, 
								startPoint, 
								endPoint,
								0);
	
	CGGradientRelease(gradient);
	/*
	colors = [NSArray arrayWithObjects:
			  (id)[[UIColor colorWithHue:0.0 saturation:1 brightness:0 alpha:1] CGColor], 
			  (id)[[UIColor colorWithHue:0.0 saturation:1 brightness:0 alpha:0] CGColor], 
			  nil];
	
	
	gradient = CGGradientCreateWithColors(NULL, (CFArrayRef)colors, NULL);
	CGContextDrawLinearGradient(c, 
								gradient, 
								CGPointMake(0, 0), 
								CGPointMake(self.frame.size.width, 0), 
								0);
*/
}


@end
