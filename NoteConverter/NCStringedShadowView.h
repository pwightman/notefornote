//
//  NCStringedShadowView.h
//  NoteConverter
//
//  Created by Parker Wightman on 4/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 * Used to compute the location of the gradient in the view
 */
typedef enum
{
	NCStringedShadowRightGradient = 2,
	NCStringedShadowLeftGradient = 3,
	NCStringedShadowTopGradient = 0,
	NCStringedShadowBottomGradient = 1,
	NCStringedShadowNoGradient
} NCStringedShadowType;

/*
 * Vertical and Horizontal refer to the variable of change in the view
 * TODO: This is perhaps not the best way to implement this ask
 *       It may be too ambiguous
 */
typedef enum
{
	NCStringedShadowMaskVertical = 0, // Top and bottom 
	NCStringedShadowMaskHorizontal = 2 // Left and right
} NCStringedShadowMask;

/*
 * Draws a slightly transparent background
 */
@interface NCStringedShadowView : UIView
{
    UIColor* _shadowColor;
}

/* Convenience constructor */
+ (NCStringedShadowView*) shadowViewWithType:(NCStringedShadowType)type;
- (void) setVariableCoordinate:(float)coordinate;
@property (nonatomic) NCStringedShadowType type;
//@property (nonatomic
@end
