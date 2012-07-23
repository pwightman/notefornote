//
//  NCStringedOverlayView.h
//  NoteConverter
//
//  Created by Parker Wightman on 4/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 * These values can be be masked and are set up in the following way
 *
 * 0 0 Low fret
 * 0 1 High fret
 * 1 0 Low string
 * 1 1 High string
 *
 * The bit in the 2's place is used to determine if it's fret/string
 * The bit in the 1's place is used to determine if it's low/high
 *
 * NOTE: While a Mask can be masked against the Type enum to determine the Type's type (for lack of a
 *       better phrase), they should not be used to test for inequality, only for bit-masking!
 */
typedef enum 
{
	NCStringedSliderLowFretSlider = 0,
	NCStringedSliderHighFretSlider = 1,
	NCStringedSliderLowStringSlider = 2,
	NCStringedSliderHighStringSlider = 3
} NCStringedSliderType;

typedef enum
{
	NCStringedOverlayMaskFret = 0,
	NCStringedSliderMaskString = 2,
	NCStringedSliderMaskLow = 0,
	NCStringedSliderMaskHigh = 1
} NCStringedSliderMask;

@class NCStringedOverlayView;

/*
 * NOTE: This class will always deal in its own coordinate system, it is the job of the
 *       delegate to convert the points before/after sending/recieving points to/from this
 *       view. (This is because the delegate will know about this object, but this object
 *       will not know about its delegate)
 */
@protocol NCStringedOverlayViewDelegate

/* The range here is interpreted as location is the starting point of a slider and the
 * ending point is location + length
 */
- (NSRange) overlayView:(NCStringedOverlayView*)view getRangeForSliderMask:(NCStringedSliderMask)sliderMask;

- (float) overlayView:(NCStringedOverlayView*)view 
getFretCoordinateClosestTo:(UITouch*)touch;

- (float) overlayView:(NCStringedOverlayView*)view 
getStringCoordinateClosestTo:(UITouch *)touch;

- (void)  overlayView:(NCStringedOverlayView*)view slider:(NCStringedSliderType) glowJumped:(float)coordinate;

- (void) overlayView:(NCStringedOverlayView*)view 
			  slider:(NCStringedSliderType) 
			released:(float)coordinate;


@end

/*
 * This overlay view is meant to be used to "decorate" the fretboard with features such
 * as sliders, as well as any other graphical ornaments deemed necessary like shadowing
 * effects attached to the sliders
 */
@interface NCStringedOverlayView : NSObject 
{
    
}

@end
