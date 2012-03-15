//
//  NCNotesModel.m
//  NoteConverter
//
//  Created by Parker Wightman on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCNotesModel.h"




#pragma mark -
#pragma mark Private Interface
@interface NCNotesModel ()
@end

#pragma mark -
@implementation NCNotesModel

#pragma mark Constructors
- (id) init
{
    self = [super init];
    if (self == nil)
        return nil;
	
	_notes = [[NSMutableSet alloc] initWithCapacity:10];
	_delegates = [[NSMutableArray alloc] init];
    self.mode = NCNotesModelModeNormal;
	[self setShowNotes:TRUE];
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize mode;
@synthesize showNotes;
#pragma mark -
#pragma mark Methods
- (void) instrument:(NSObject<NCNotesModelDelegate>*)source 
  submitNotePressed:(NCNote *)note 
	relativeOctave:(NSInteger)relativeOctave
{
	//	// NSAssert(note.absValue >= NCNoteABSMIN || note.absValue <= NCNoteABSMAX, @"Bad note: %i", note.absValue);
	[_notes addObject:note];
	for (int i = 0; i < [_delegates count]; i++) 
	{
		if ([_delegates objectAtIndex:i] != source) 
		{
			[[_delegates objectAtIndex:i] notesModel:self notePressed:note relativeOctave:relativeOctave];
		}
	}
}

- (void) instrument:(NSObject<NCNotesModelDelegate>*)source 
 submitNoteReleased:(NCNote *)note
	 relativeOctave:(NSInteger)relativeOctave
{
	//	// NSAssert(note.absValue >= NCNoteABSMIN && note.absValue <= NCNoteABSMAX, @"Bad note: %i", note.absValue);
	[_notes removeObject:note];
	for (int i = 0; i < [_delegates count]; i++) 
	{
		if ([_delegates objectAtIndex:i] != source) 
		{
			[[_delegates objectAtIndex:i] notesModel:self noteReleased:note relativeOctave:relativeOctave];
		}
	}
}

- (void) instrument:(NSObject<NCNotesModelDelegate> *)source lowestNoteChanged:(NCNote*)note
{
	for (int i = 0; i < [_delegates count]; i++) 
	{
		NSObject<NCNotesModelDelegate>* newDelegate = [_delegates objectAtIndex:i];
		if (newDelegate != source) {
			if([newDelegate respondsToSelector:@selector(notesModel:lowestNoteHint:)])
				[newDelegate notesModel:self lowestNoteHint:note];
		}
	}
}

- (void) clearDelegates
{
	[_delegates release];
	[_notes release];
	_delegates = [[NSMutableArray alloc] init];
	_notes = [[NSMutableSet alloc] init];
}

- (void) addDelegate:(id<NCNotesModelDelegate>)delegate
{
	[_delegates addObject:delegate];
    
    /* Update the status of all the other delegates by notifying about the lowest note hint */
	if ([_delegates count] >= 2) {
        
        for (id<NCNotesModelDelegate> delegate in _delegates)
        {
            NCNote* delegateLowest = nil;		
            if([delegate respondsToSelector:@selector(getLowestNoteForNotesModel:)])
                delegateLowest = [delegate getLowestNoteForNotesModel:self];	
            
            if (delegateLowest != nil) 
                for (id<NCNotesModelDelegate> otherDelegate in _delegates)
                {
                    if ([otherDelegate respondsToSelector:@selector(notesModel:lowestNoteHint:)] && otherDelegate != delegate)
                        [otherDelegate notesModel:self lowestNoteHint:delegateLowest];
                }


        }
	}
}


- (NSArray*) notes
{
	NSArray* notesArray = [_notes allObjects];
	
	// Sort the notes by ascending value
	NSSortDescriptor *sortDescriptor;
	sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"absValue"
												  ascending:YES] autorelease];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	NSArray *sortedArray;
	sortedArray = [notesArray sortedArrayUsingDescriptors:sortDescriptors];
	
	return sortedArray;
}

@end
