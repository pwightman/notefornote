//
//  NCSplitView.h
//  NoteConverter
//
//  Created by Parker Wightman on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "NCControlsView.h"
#import "NCNotesModel.h"
@interface NCSplitView : UIImageView
{
	UIView* _primaryInstrument;
	UIView* _secondaryInstrument;
	UIView* _controlsView;
	float ratio;
}

- (id) initWithFrame:(CGRect)frame andControlsView:(UIView*)controlsView;

@property (nonatomic, retain) UIView* primaryInstrument;
@property (nonatomic, retain) UIView* secondaryInstrument;
@property (nonatomic, retain) UIView* controlsView;

- (void) swapViews;

- (CGRect) primaryInstrumentRect;
- (CGRect) secondaryInstrumentRect;
- (CGRect) controlsViewRect;


@end
