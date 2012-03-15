//
//  NCPianoView.h
//  NoteConverter
//
//  Created by Parker Wightman on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCNote.h"

@interface NCPianoView : UIView 
{
	NSMutableDictionary* _keys;
	NSInteger _totalWhiteKeys;
	NCNote* _lowestNote;
	NSMutableArray* _blackKeys;
	BOOL _animating;
}

- (id) initWithFrame:(CGRect)frame andWhiteKeys:(NSUInteger)whiteKeys;



/**
 * This view takes care of setting one of its subview key views
 * to a "pressed" or "not pressed" state
 */
- (void) setKey:(NCNote*)note toPressedState:(BOOL)pressed;
- (void) clearKeys;
- (void) setLowestNote:(NCNote*)note withAnimation:(BOOL)animated;


@end
