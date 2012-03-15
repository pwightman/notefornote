//
//  NCControlsView.h
//  NoteConverter
//
//  Created by Parker Wightman on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@protocol NCControlsViewDelegate <NSObject>

/* Returns the new toggled state */
- (BOOL) toggleMode;
- (void) swapViews;
- (void) setGuitarAsSecondary;
- (void) setBassAsSecondary;
- (void) setInstrumentType:(NCInstrumentType)instrumentType forRole:(NCInstrumentRole)instrumentRole;

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

- (void) setupLabel:(UILabel*)label atPoint:(CGPoint)point withText:(NSString*)string;
- (void) setupButton:(UIButton*)button atPoint:(CGPoint)point;

- (void) instrumentPopoverForRole:(NCInstrumentRole)role fromView:(UIView*)view;

@end
