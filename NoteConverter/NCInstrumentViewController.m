//
//  NCInstrumentController.m
//  NoteConverter
//
//  Created by Parker Wightman on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCInstrumentViewController.h"
#import "NCPianoViewController.h"
#import "NCGuitarViewController.h"
#import "NCBassViewController.h"
#import "NCInstrumentSelectViewController.h"
#import "NCLoadingView.h"

#pragma mark -
#pragma mark Private Interface
@interface NCInstrumentViewController ()


@end

#pragma mark -
@implementation NCInstrumentViewController

#pragma mark Constructors
- (id) initWithModel:(NCNotesModel*)model andType:(NCInstrumentType)instrumentType
{
    NCInstrumentViewController* cont;
    switch (instrumentType) {
        case NCInstrumentTypePiano:
            cont = [[NCPianoViewController alloc] initWithModel:model];
            break;
        case NCInstrumentType6StringGuitar:
            cont = [[NCGuitarViewController alloc] initWithModel:model];
            break;
        case NCInstrumentType6StringBass:
            cont = [[NCBassViewController alloc] initWithModel:model andStrings:6];
            break;
        case NCInstrumentType5StringBass:
            cont = [[NCBassViewController alloc] initWithModel:model andStrings:5];
            break;
        case NCInstrumentType4StringBass:
            cont = [[NCBassViewController alloc] initWithModel:model andStrings:4];
            break;
            
        default:
            break;
    }
    
    cont.type = instrumentType;
    
    return cont;
}

- (id) initWithModel:(NCNotesModel*)model
{
    self = [super init];
    if (self == nil)
        return nil;
    [model retain];
    
	_model = model;
    self.active = NO;
    self.loadingView = [[[NCLoadingView alloc] init] autorelease];
    
	
    return self;
}

@synthesize soundManager = _soundManager;
@synthesize type;
@synthesize active;

- (id) init
{
	return nil;
}

- (void) setModel:(NCNotesModel *)model
{
	[_model release];
	_model = model;
}

- (void) dealloc
{
	[_model release];
	[_soundManager release];
    [super dealloc];
}

#pragma mark - Accessors
@synthesize lowNote = _lowNote;
@synthesize highNote;
@synthesize loadingView;
#pragma mark - Methods

- (void) notesModel:(NCNotesModel *)source notePressed:(NCNote *)note relativeOctave:(NSInteger)relativeOctave
{
	
}

- (void) notesModel:(NCNotesModel *)source noteReleased:(NCNote *)note relativeOctave:(NSInteger)relativeOctave
{
	
}

- (void) setLoadingViewState:(BOOL)state
{
    if (state)
    {
        loadingView.frame = self.view.frame;
        [[self view] addSubview:loadingView];
    }
    else 
    {
        [loadingView removeFromSuperview];
    }
}


- (void) initSoundManagerWithType:(NCSoundType)soundType
{
	_soundManager = [[NCSoundManager alloc] initWithType:soundType andRange:NSRangeFromString([NSString stringWithFormat:@"{%i, %i}", [self lowNote].absValue, [self highNote].absValue])];
}

@end
