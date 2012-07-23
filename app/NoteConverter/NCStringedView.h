//
//  NCStringedView.h
//  NoteConverter
//
//  Created by Parker Wightman on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
@class NCStringedView;

@protocol NCStringedViewDelegate <NSObject>

- (void) stringedView:(NCStringedView*)view modifiedFretRangeLow:(NSUInteger)low high:(NSUInteger)high;
- (void) stringedView:(NCStringedView*)view modifiedStringRangeLow:(NSUInteger)low high:(NSUInteger)high;
- (void) stringedView:(NCStringedView*)view notePressedFret:(NSUInteger)fret string:(NSUInteger)string;
- (void) stringedView:(NCStringedView*)view noteReleasedFret:(NSUInteger)fret string:(NSUInteger)string;
- (NSString*) stringedView:(NCStringedView *)view getNoteNameAtFret:(NSUInteger)fret string:(NSUInteger)string;
- (UIColor*) stringedView:(NCStringedView *)view getColorForNoteAtFret:(NSUInteger)fret string:(NSUInteger)string;

@end

#import "NCStringedNoteView.h"
#import "NCStringedFretSliderView.h"
#import "NCStringedStringSliderView.h"
#import "NCStringedShadowView.h"

@interface NCStringedView : UIView <NCStringedFretSliderDelegate, NCStringedStringSliderDelegate>
{
	UIImageView* _neck;
	UIImageView* _neckBackground;
	UIImageView* _head;
	UIImageView* _nutView;
	NSMutableArray* _notes;
	NSMutableArray* _frets;
	NSMutableArray* _stringViews;
	NSMutableArray* _stringShadowViews;
	NSMutableArray* _inlayViews;
	/* These images can/should be replaced by subclass wanting to customize content */
	UIImage* _neckImage;
	UIImage* _neckShadowImage;
	UIImage* _fretImage;
	UIImage* _nutImage;
	UIImage* _headImage;
	NSArray* _stringImages; /* from highest pitch to lowest */
	NSArray* _stringShadowImages; /* from highest pitch to lowest */
	NSArray* _inlayImages; /* 3rd fret to 12th fret, in that order */
    
	float _fretboardSize; // This is the width used whenever laying stuff out so that there can be
                        // A little extra space at the end of the fretboard
	float headOffset;
    
    BOOL _playable;

	/* TODO: Put these views in the Overlay View */
	NCStringedStringSliderView* _lowStringSlider;
	NCStringedFretSliderView* _highFretSlider;
	NCStringedStringSliderView* _highStringSlider;
	NCStringedFretSliderView* _lowFretSlider;
	NCStringedShadowView* _leftShadowView;
	NCStringedShadowView* _rightShadowView;
	
	
	NSInteger _glowPosition;	
}

@property (nonatomic, retain) NSObject<NCStringedViewDelegate>* delegate;
@property (nonatomic, retain) UIImage* neckImage;
@property (nonatomic, retain) UIImage* neckShadowImage;
@property (nonatomic, retain) UIImage* fretImage;
@property (nonatomic, retain) UIImage* nutImage;
@property (nonatomic, retain) UIImage* headImage;
@property (nonatomic, retain) NSArray* stringImages;
@property (nonatomic, retain) NSArray* stringShadowImages;
/* Inlays are the images on the 3rd/5th/7th/12th frets */
@property (nonatomic, retain) NSArray* inlayImages;

- (id) initWithStrings:(NSUInteger)strings frets:(NSUInteger)frets;
- (void) setNotePressed:(BOOL)pressed onString:(NSUInteger)string andFret:(NSUInteger)fret;
- (void) setPlayable:(BOOL)playable;
- (BOOL) playable;

- (void) setSliderState:(BOOL) enabled withAnimation:(BOOL)animated;

- (NSRange) getFretRange;
- (NSRange) getStringRange;

/* Tests to see, when moving the slider to the new point, if they are too close together */
- (BOOL) slidersTooClose:(CGPoint)newPoint withMovedSlider:(NCStringedFretSliderView*)slider;

- (void) initNotes;

/* TODO: Put this in the Overlay View */
- (void) adjustShadowRects;

@end
