//
//  NCBassViewController.h
//  NoteConverter
//
//  Created by Parker Wightman on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCStringedViewController.h"

@interface NCBassViewController : NCStringedViewController 
{
}

- (id) initWithModel:(NCNotesModel *)model andStrings:(NSInteger)strings;
- (NSArray*) normalTuningNotes:(NSInteger)strings;

@end
