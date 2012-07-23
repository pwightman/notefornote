//
//  NCStringedNoteView.h
//  NoteConverter
//
//  Created by Parker Wightman on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface NCStringedNoteView : UIImageView 
{
	BOOL _pressed;
	UIImage* _indicator;
	UIImage* _currentImage;
	UILabel* _textView;
}

@property (nonatomic) NSUInteger string;
@property (nonatomic) NSUInteger fret;
@property (nonatomic) BOOL pressed;
@property (nonatomic, retain) UIImage* indicator;

/* 
 * It is the job of the user of this class to determine these values
 * They default to empty and white for the color
 */
- (void) setText:(NSString*)text;
- (void) setTextColor:(UIColor*)color;

@end
