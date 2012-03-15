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
	if ([_delegates count] >= 2) {
		NSObject<NCNotesModelDelegate>* firstDelegate = [_delegates objectAtIndex:0];
		NSObject<NCNotesModelDelegate>* secondDelegate = [_delegates objectAtIndex:1];
		NCNote* firstDelegateLowest = nil;
		NCNote* secondDelegateLowest = nil;		
		if([firstDelegate respondsToSelector:@selector(getLowestNoteForNotesModel:)])
			firstDelegateLowest = [firstDelegate getLowestNoteForNotesModel:self];	
		if([secondDelegate respondsToSelector:@selector(getLowestNoteForNotesModel:)])
			secondDelegateLowest = [secondDelegate getLowestNoteForNotesModel:self];
		
		if (secondDelegateLowest != nil) {
			if ([firstDelegate respondsToSelector:@selector(notesModel:lowestNoteHint:)])
				[firstDelegate notesModel:self lowestNoteHint:secondDelegateLowest];
		}
		
		if (firstDelegateLowest != nil) {
			if ([secondDelegate respondsToSelector:@selector(notesModel:lowestNoteHint:)])
				[secondDelegate notesModel:self lowestNoteHint:firstDelegateLowest];
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
