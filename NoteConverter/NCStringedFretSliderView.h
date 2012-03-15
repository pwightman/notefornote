//
//  NCStringedSliderView.h
//  NoteConverter
//
//  Created by Parker Wightman on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
@class NCStringedFretSliderView;

@protocol NCStringedFretSliderDelegate <NSObject>

- (BOOL) fretSliderTouched:(NCStringedFretSliderView*)slider atPoint:(CGPoint)point;
- (BOOL) fretSliderMoved:(NCStringedFretSliderView*)slider toPoint:(CGPoint)point;
- (BOOL) fretSliderReleased:(NCStringedFretSliderView*)slider atPoint:(CGPoint)point;

@end

@interface NCStringedFretSliderView : UIImageView 
{
    UIImageView* _lightUp;
}

@property (nonatomic, retain) NSObject<NCStringedFretSliderDelegate>* delegate;
@property (nonatomic) NSInteger fretPosition;
@property (readonly) UIImageView* lightUp;

@end
