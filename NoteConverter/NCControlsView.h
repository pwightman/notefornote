//
//  NCControlsView.h
//  NoteConverter
//
//  Created by Parker Wightman on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class NCToolbarViewController;

@protocol NCControlsViewDelegate <NSObject>

/* Returns the new toggled state */
- (BOOL) toggleMode;
- (void) swapViews;
- (void) setGuitarAsSecondary;
- (void) setBassAsSecondary;
- (void) setInstrumentType:(NCInstrumentType)instrumentType forRole:(NCInstrumentRole)instrumentRole;
- (void) presentModal:(UIViewController*)controller;

@end

@interface NCControlsView : UIImageView 
{
	// TODO: HACKS HACKS HACKS!!!
	BOOL nextState;
    UIView* _modeContainer;
	UIButton* _modeButton;
	UILabel* _modeLabel;
	UIButton* _swapButton;
	UILabel* _swapLabel;
    UIButton* _primarySwitchButton;
	UILabel* _primarySwitchLabel;
    UIButton* _secondarySwitchButton;
	UILabel* _secondarySwitchLabel;
    NCToolbarViewController* _topToolbarController;
    UIButton* _helpButton;
	UILabel* _helpLabel;
    

    
    NSMutableArray* labels;
    NSMutableArray* buttons;
	NSObject<NCControlsViewDelegate>* _delegate;
}

@property (nonatomic, retain) NSObject<NCControlsViewDelegate>* delegate;

- (void) modeButtonPressed;
- (void) swapButtonPressed;
- (void) nextButtonPressed;
- (void) primarySwitchPressed;
- (void) secondarySwitchPressed;
- (void) helpButtonPressed;

- (void) setupLabel:(UILabel*)label atPoint:(CGPoint)point withText:(NSString*)string;
- (void) setupButton:(UIButton*)button atPoint:(CGPoint)point;

- (void) instrumentPopoverForRole:(NCInstrumentRole)role fromView:(UIView*)view;

@end
