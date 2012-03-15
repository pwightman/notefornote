//
//  NCGuitarViewController.m
//  NoteConverter
//
//  Created by Parker Wightman on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCGuitarViewController.h"

#pragma mark -
#pragma mark Private Interface
@interface NCGuitarViewController ()
@end

#pragma mark -
@implementation NCGuitarViewController

#pragma mark Constructors
- (id) initWithModel:(NCNotesModel*)model
{
    self = [super initWithModel:model strings:[self normalTuningNotes] andFrets:12];
    if (self == nil)
        return nil;
	
	/* Setup the guitar images with the superview varaibles! */
	// Start up the correct sound manager for the guitar
	[self initSoundManagerWithType:NCSoundGuitarCollin];
    
    [_soundManager setGain:0.6f];
    
	// Get all the right pictures in place
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

#pragma mark -
#pragma mark Methods
- (NSArray*) normalTuningNotes
{
	NCNote* noteLowE = [[NCNote alloc] initWithType:NCNoteE octave:2];
	NCNote* noteLowA = [[NCNote alloc] initWithType:NCNoteA octave:2];
	NCNote* noteLowD = [[NCNote alloc] initWithType:NCNoteD octave:3];
	NCNote* noteLowG = [[NCNote alloc] initWithType:NCNoteG octave:3];
	NCNote* noteLowB = [[NCNote alloc] initWithType:NCNoteB octave:3];
	NCNote* notehighE = [[NCNote alloc] initWithType:NCNoteE octave:4];
	
	NSArray* stringsArray = [NSArray arrayWithObjects:
							 notehighE,
							 noteLowB,
							 noteLowG,
							 noteLowD,
							 noteLowA,
							 noteLowE
							 , nil];
	
	[noteLowE release];
	[noteLowA release];
	[noteLowD release];
	[noteLowG release];
	[noteLowB release];
	[notehighE release];
	
	return stringsArray;
}

- (void) initImages
{	
	NCStringedView* view = [self stringedView];
	[view setNeckImage:[UIImage imageNamed:@"guitarNeck"]];
	[view setFretImage:[UIImage imageNamed:@"guitarFretBar"]];
	[view setNutImage:[UIImage imageNamed:@"guitarNut"]];
	[view setNeckShadowImage:[UIImage imageNamed:@"guitarNeckShadow"]];
	[view setHeadImage:[UIImage imageNamed:@"guitarOpen"]];
	
	NSMutableArray* inlayArray = [NSMutableArray arrayWithCapacity:4];

	[inlayArray addObject:[UIImage imageNamed:@"guitarInlayDot"]];
	[inlayArray addObject:[UIImage imageNamed:@"guitarInlayDot"]];
	[inlayArray addObject:[UIImage imageNamed:@"guitarInlayDot"]];
	//	[inlayArray addObject:[UIImage imageNamed:@"guitarInlayDot"]];
	[inlayArray addObject:[UIImage imageNamed:@"guitarInlay12th"]];
	
	[view setInlayImages:inlayArray];
	
	NSMutableArray* stringsArray = [NSMutableArray arrayWithCapacity:[_notes count]];
	
	for (int i = 0; i < [_notes count]; i++)
		[stringsArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"guitar%istring", i]]];

	NSMutableArray* stringShadows = [NSMutableArray arrayWithCapacity:[_notes count]];
	
	for (int i = 0; i < [_notes count]; i++)
		[stringShadows addObject:[UIImage imageNamed:[NSString stringWithFormat:@"guitar%istringShadow", i]]];
	

	[view setStringImages:stringsArray];
	[view setStringShadowImages:stringShadows];
}

@end
