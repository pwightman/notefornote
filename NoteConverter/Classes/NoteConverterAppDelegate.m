//
//  NoteConverterAppDelegate.m
//  NoteConverter
//
//  Created by Parker Wightman on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NoteConverterAppDelegate.h"
#import "AVFoundation/AVAudioSession.h"
#import "NCNotesModel.h"
#import "NCNote.h"


@implementation NoteConverterAppDelegate

#pragma mark UIApplicationDelegate Methods
- (void) applicationDidFinishLaunching:(UIApplication*)application 
{   
	
	// Runs all the unit tests
	[self runTests];
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	_model = [[NCNotesModel alloc] init];
    
	_splitViewController = [[NCSplitViewController alloc] init];
	
    _pianoViewController = [[NCInstrumentViewController alloc] initWithModel:_model andType:NCInstrumentTypePiano];
	
	_guitarViewController = [[NCInstrumentViewController alloc] initWithModel:_model andType:NCInstrumentType6StringGuitar];

    [_guitarViewController willBecomeInactive];
	
	[_model addDelegate:_pianoViewController];
	[_model addDelegate:_guitarViewController];
	
	// Add for iPad functionality
	[_splitViewController setPrimaryInstrumentController:_pianoViewController];
	[_splitViewController setSecondaryInstrumentController:_guitarViewController];
	[_splitViewController setModel:_model];
	[_window addSubview:[_splitViewController view]];
	
	[_pianoViewController release];
	[_guitarViewController release];

    [_window makeKeyAndVisible];
    
    // Animate in...
    float animationDistance = 1024.0f;
    CGRect rect = [[_guitarViewController view] frame];
    rect.origin.x += animationDistance;
    [[_guitarViewController view] setFrame:rect];
    
    CGRect rect2 = [[_pianoViewController view] frame];
    rect2.origin.x -= animationDistance;
    [[_pianoViewController view] setFrame:rect2];
    
    [[_splitViewController controlsView] setAlpha:0.0f];

    [_window makeKeyAndVisible];
    [UIView animateWithDuration:0.5f animations:^(void) {
        CGRect rect = [[_guitarViewController view] frame];
        rect.origin.x -= animationDistance;
        [[_guitarViewController view] setFrame:rect];
        
        CGRect rect2 = [[_pianoViewController view] frame];
        rect2.origin.x += animationDistance;
        [[_pianoViewController view] setFrame:rect2];
        
        [[_splitViewController controlsView] setAlpha:1.0f];
    }];
}

- (void) runTests
{
	NCNoteUnitTest* noteTests = [[NCNoteUnitTest alloc] init];

	[noteTests runAllTests];
	[noteTests release];
}

- (void) applicationWillTerminate:(UIApplication*)application
{
	[_pianoViewController release];
	[_guitarViewController release];
	[_splitViewController release];
	[_model release];
	[_model release];
	[_finch release];
    [_window release];
}

- (void) applicationWillResignActive:(UIApplication*)application
{
}

- (void) applicationDidEnterBackground:(UIApplication*)application
{
}

- (void) applicationWillEnterForeground:(UIApplication*)application
{
}

- (void) applicationDidBecomeActive:(UIApplication*)application
{
}

@end
