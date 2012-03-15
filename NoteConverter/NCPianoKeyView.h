//
//  NCPianoKeyView.h
//  NoteConverter
//
//  Created by Parker Wightman on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCNote.h"

typedef enum {
	NCPianoKeyStyleWhite,
	NCPianoKeyStyleBlack	
} NCPianoKeyStyle;

@interface NCPianoKeyView : UIImageView 
{
	UIColor* keyColor;
	BOOL _pressed;
	UIImage* pressedImage;
	UIImage* depressedImage;
}

- (id) initWithFrame:(CGRect)frame andStyle:(NCPianoKeyStyle)style;

@property (nonatomic) NCNoteType type;
@property (nonatomic) NCPianoKeyStyle style;
@property (nonatomic) NSInteger octave;
@property (nonatomic) BOOL pressed;
@property (nonatomic, retain) UIImage* indicatorImage;
@property (nonatomic, retain) UIImageView* indicatorView;

@end
