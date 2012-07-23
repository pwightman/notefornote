//
//  NCStringedStringSliderView.h
//  NoteConverter
//
//  Created by Parker Wightman on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class NCStringedStringSliderView;

@protocol NCStringedStringSliderDelegate <NSObject>

- (BOOL) stringSliderTouched:(NCStringedStringSliderView*)slider atPoint:(CGPoint)point;
- (BOOL) stringSliderMoved:(NCStringedStringSliderView*)slider toPoint:(CGPoint)point;
- (BOOL) stringSliderReleased:(NCStringedStringSliderView*)slider atPoint:(CGPoint)point;

@end

@interface NCStringedStringSliderView : UIImageView 
{
    
}

@property (nonatomic, retain) NSObject<NCStringedStringSliderDelegate>* delegate;

@end
