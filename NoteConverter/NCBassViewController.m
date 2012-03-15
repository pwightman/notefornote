//
//  NCBassViewController.m
//  NoteConverter
//
//  Created by Parker Wightman on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCBassViewController.h"

#pragma mark -
#pragma mark Private Interface
@interface NCBassViewController ()

@end

#pragma mark -
@implementation NCBassViewController

#pragma mark Constructors
- (id) initWithModel:(NCNotesModel *)model andStrings:(NSInteger)strings
{
    self = [super initWithModel:model strings:[self normalTuningNotes:strings] andFrets:12];
    if (self == nil)
        return nil;


	// Start up the correct sound manager for the guitar
	[self initSoundManagerWithType:NCSoundBassJared];
    
    [_soundManager setGain:0.9f];
    
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
- (NSArray*) normalTuningNotes:(NSInteger)strings
{
	NCNote* noteLowB = [[NCNote alloc] initWithType:NCNoteB octave:0];
	NCNote* noteLowE = [[NCNote alloc] initWithType:NCNoteE octave:1];
	NCNote* noteLowA = [[NCNote alloc] initWithType:NCNoteA octave:1];
	NCNote* noteLowD = [[NCNote alloc] initWithType:NCNoteD octave:2];
	NCNote* noteLowG = [[NCNote alloc] initWithType:NCNoteG octave:2];
	NCNote* noteLowC = [[NCNote alloc] initWithType:NCNoteC octave:3];
    
	NSMutableArray* stringsArray = [NSMutableArray arrayWithCapacity:strings];
    if (strings == 6)
        [stringsArray addObject:noteLowC]; 
    [stringsArray addObject:noteLowG];
    [stringsArray addObject:noteLowD];
    [stringsArray addObject:noteLowA];
    [stringsArray addObject:noteLowE];
    if (strings >= 5)
        [stringsArray addObject:noteLowB];
    
	[noteLowB release];
	[noteLowE release];
	[noteLowA release];
	[noteLowD release];
	[noteLowG release];
	[noteLowC release];
	
	return stringsArray;
}

- (void) initImages
{
	NCStringedView* view = [self stringedView];
	[view setNeckImage:[UIImage imageNamed:@"6stringBassFretboard"]];
	[view setFretImage:[UIImage imageNamed:@"6stringBassFretBar"]];
	[view setNutImage:[UIImage imageNamed:@"6stringBassNut"]];
	[view setNeckShadowImage:[UIImage imageNamed:@"guitarNeckShadow"]];
	[view setHeadImage:[UIImage imageNamed:@"bassOpen"]];
	
	NSMutableArray* inlayArray = [NSMutableArray arrayWithCapacity:4];
	
	[inlayArray addObject:[UIImage imageNamed:@"6stringBassInlay3rd"]];
	[inlayArray addObject:[UIImage imageNamed:@"6stringBassInlay5th"]];
	[inlayArray addObject:[UIImage imageNamed:@"6stringBassInlay7th"]];
	[inlayArray addObject:[UIImage imageNamed:@"6stringBassInlay12th"]];
	[inlayArray addObject:[UIImage imageNamed:@"6stringBassInlay12th"]];
	
	[view setInlayImages:inlayArray];
	
	NSMutableArray* stringsArray = [NSMutableArray arrayWithCapacity:[_notes count]];
	
	for (int i = 0; i < [_notes count]; i++)
		[stringsArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"bass%istring", i]]];
	
	NSMutableArray* stringShadows = [NSMutableArray arrayWithCapacity:[_notes count]];
	
	for (int i = 0; i < [_notes count]; i++)
		[stringShadows addObject:[UIImage imageNamed:[NSString stringWithFormat:@"bass%istringShadow", i]]];

	
	[view setStringImages:stringsArray];
	[view setStringShadowImages:stringShadows];
	// TODO: Add string shadow array!

}

@end
