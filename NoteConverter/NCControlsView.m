//
//  NCControlsView.m
//  NoteConverter
//
//  Created by Parker Wightman on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCControlsView.h"
#import "NCInstrumentSelectViewController.h"

#pragma mark -
#pragma mark Private Interface
@interface NCControlsView ()
@end

#pragma mark -
@implementation NCControlsView

#pragma mark Constructors
- (id) init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    labels = [[NSMutableArray alloc] initWithCapacity:7];
    buttons = [[NSMutableArray alloc] initWithCapacity:7];
	
	[self setImage:[UIImage imageNamed:@"optionsBar"]];
    _modeContainer = [[UIView alloc] init];
	_modeButton = [[UIButton alloc] init];
	_modeLabel = [[UILabel alloc] init];
	_swapLabel = [[UILabel alloc] init];
	_swapButton = [[UIButton alloc] init];
    _primarySwitchLabel = [[UILabel alloc] init];
    _secondarySwitchLabel = [[UILabel alloc] init];
    _primarySwitchButton = [[UIButton alloc] init];
    _secondarySwitchButton = [[UIButton alloc] init];
	
	nextState = TRUE;

	[self setUserInteractionEnabled:TRUE];
	[_modeButton addTarget:self action:@selector(modeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[_swapButton addTarget:self action:@selector(swapButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_primarySwitchButton addTarget:self action:@selector(primarySwitchPressed) forControlEvents:UIControlEventTouchUpInside];
    [_secondarySwitchButton addTarget:self action:@selector(secondarySwitchPressed) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (void) dealloc
{
    [_modeContainer release];
	[_modeButton release];
	[_modeLabel release];
	[_swapLabel release];
	[_swapButton release];
    [_primarySwitchLabel release];
    [_primarySwitchButton release];
    [_secondarySwitchLabel release];
    [_secondarySwitchButton release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize delegate = _delegate;
#pragma mark -
#pragma mark Methods

- (void) primarySwitchPressed
{
    [self instrumentPopoverForRole:NCInstrumentRolePrimary fromView:_primarySwitchButton];
}

- (void) instrumentPopoverForRole:(NCInstrumentRole)role fromView:(UIView*)view
{
    NCInstrumentSelectViewController* instrumentCont = [[NCInstrumentSelectViewController alloc] initWithStyle:UITableViewStylePlain withControlDelegate:self.delegate andRole:role];
    
    UIPopoverController* cont = [[UIPopoverController alloc] initWithContentViewController:instrumentCont];
    
    instrumentCont.popover = cont;
    
    [cont presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    
    instrumentCont.contentSizeForViewInPopover = [[instrumentCont tableView] contentSize];
}

- (void) secondarySwitchPressed
{
    [self instrumentPopoverForRole:NCInstrumentRoleSecondary fromView:_secondarySwitchButton];
}

- (void) modeButtonPressed
{
	if ([_delegate toggleMode]) {
		[_modeButton setImage:[UIImage imageNamed:@"optionsButtonPressed"] forState:UIControlStateNormal];
	}
	else
		[_modeButton setImage:[UIImage imageNamed:@"optionsButton"] forState:UIControlStateNormal];
}

- (void) swapButtonPressed
{
	[[self delegate] swapViews];
}

- (void) addModeButton:(UIButton*)button
{
	[_modeContainer addSubview:button];
}

- (void) layoutSubviews
{
    float buttonWidth = [UIImage imageNamed:@"optionsButton"].size.width;
	
    [self setupButton:_modeButton atPoint:CGPointMake(900, 50)];
	[self setupLabel:_modeLabel atPoint:CGPointMake(900, 50) withText:@"Chords"];
	
	[self setupButton:_swapButton atPoint:CGPointMake(900 - buttonWidth, 50)];
	[self setupLabel:_swapLabel atPoint:CGPointMake(900 - buttonWidth, 50) withText:@"Swap"];
    
    [self setupButton:_primarySwitchButton atPoint:CGPointMake(30, 50)];
    [self setupLabel:_primarySwitchLabel atPoint:CGPointMake(30, 50) withText:@"Primary"];
    [self setupButton:_secondarySwitchButton atPoint:CGPointMake(30 + buttonWidth, 50)];
    [self setupLabel:_secondarySwitchLabel atPoint:CGPointMake(30 + buttonWidth, 50) withText:@"Secondary"];
    
    for (UIButton *button in buttons) {
        [self addSubview:button];
    }
    
    for (UILabel *label in labels) {
        [self addSubview:label];
    }
    

}

- (void) setupLabel:(UILabel*)label atPoint:(CGPoint)point withText:(NSString*)string
{
    [label setFrame:CGRectMake(point.x, point.y, [UIImage imageNamed:@"optionsButton"].size.width, [UIImage imageNamed:@"optionsButton"].size.height)];
	[label setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:20.f]];
	[label setTextColor:[UIColor whiteColor]];
	[label setText:string];
	[label setTextAlignment:UITextAlignmentCenter];
	[label setBackgroundColor:[UIColor clearColor]];
    [labels addObject:label];
}

- (void) setupButton:(UIButton*)button atPoint:(CGPoint)point
{
    [button setFrame:CGRectMake(point.x, point.y, [UIImage imageNamed:@"optionsButton"].size.width, [UIImage imageNamed:@"optionsButton"].size.height)];
    [button setImage:[UIImage imageNamed:@"optionsButton"] forState:UIControlStateNormal];
    [buttons addObject:button];
}

@end
