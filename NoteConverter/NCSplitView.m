//
//  NCSplitView.m
//  NoteConverter
//
//  Created by Parker Wightman on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCSplitView.h"


#pragma mark -
#pragma mark Private Interface
@interface NCSplitView ()
	
@end

#pragma mark -
@implementation NCSplitView

#pragma mark Constructors
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	if (self == nil)
		return nil;
	_primaryInstrument = nil;
	_secondaryInstrument = nil;
	_controlsView = [[NCControlsView alloc] init];
	[self setExclusiveTouch:FALSE];
    [self setMultipleTouchEnabled:TRUE];
	[self addSubview:_controlsView];
	ratio = 9;
    return self;
}

- (void) dealloc 
{
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize primaryInstrument = _primaryInstrument;
- (void) setPrimaryInstrument:(UIView *)primaryInstrument
{
	if (_primaryInstrument != nil) {
		[_primaryInstrument removeFromSuperview];
		[_primaryInstrument release];
	}
	
	[primaryInstrument retain];
	_primaryInstrument = primaryInstrument;
	
	[self addSubview:_primaryInstrument];
	[self setNeedsLayout];
}

@synthesize secondaryInstrument = _secondaryInstrument;
- (void) setSecondaryInstrument:(UIView *)secondaryInstrument
{
	if (_secondaryInstrument != nil) {
		[_secondaryInstrument removeFromSuperview];
		[_secondaryInstrument release];
	}
	
	[secondaryInstrument retain];
	_secondaryInstrument = secondaryInstrument;
	
	[self addSubview:_secondaryInstrument];
	[self setNeedsLayout];
}

@synthesize controlsView = _controlsView;
- (void ) setControlsView:(UIImageView *)controlsView
{
	if (_controlsView != nil) {
		[_controlsView removeFromSuperview];
		[_controlsView release];
	}
	
	[_controlsView retain];
	_controlsView = controlsView;
	
	[self addSubview:_controlsView];
	[self setNeedsLayout];

}
#pragma mark -
#pragma mark Methods
- (void) swapViews
{
	UIView* temp = _primaryInstrument;
	_primaryInstrument = _secondaryInstrument;
	_secondaryInstrument = temp;
	
	CGPoint primaryCenter = [_primaryInstrument center];
	CGPoint secondaryCenter = [_secondaryInstrument center];
	
	[UIView animateWithDuration:0.3
						  delay: 0.0
						options: UIViewAnimationCurveEaseIn
					 animations:^{
						 [_primaryInstrument setCenter:secondaryCenter];
						 [_secondaryInstrument setCenter:primaryCenter];
					 }
					 completion:^(BOOL finished){ }];

}
#pragma mark UIView Methods
- (void) layoutSubviews
{
	if(_primaryInstrument != nil && _secondaryInstrument != nil && _secondaryInstrument != nil)
	{
		[_primaryInstrument setFrame:[self primaryInstrumentRect]];
		// Make sure the correct instrument is responding to user touches
		[_secondaryInstrument setFrame:[self secondaryInstrumentRect]];
		[_controlsView setFrame:[self controlsViewRect]];
		[self bringSubviewToFront:_controlsView];
		//				[_primaryInstrument setNeedsLayout];
	}
	
}

- (CGRect) primaryInstrumentRect
{
	int section = (int)ratio/2;
	return CGRectMake(0, self.bounds.size.height*((float)(section + 1)/ratio), self.bounds.size.width, self.bounds.size.height*((float)section/ratio));
}

- (CGRect) secondaryInstrumentRect
{
	int section = (int)ratio/2;
	return CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height*((float)section/ratio));
}

- (CGRect) controlsViewRect
{
	float dy = _controlsView.image.size.height - self.bounds.size.height*(1.0f/ratio);
	int section = (int)ratio/2;
	return CGRectMake(0, self.bounds.size.height*((float)(section)/ratio) - dy + 20, _controlsView.image.size.width, _controlsView.image.size.height);
	
}

@end
