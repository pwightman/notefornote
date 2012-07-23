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
	// [self runTests];
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	_model = [[NCNotesModel alloc] init];
    
	_splitViewController = [[NCSplitViewController alloc] init];
	
    _primaryViewController = [[NCInstrumentViewController alloc] initWithModel:_model andType:NCInstrumentTypePiano];
	
	_secondaryViewController = [[NCInstrumentViewController alloc] initWithModel:_model andType:NCInstrumentType6StringGuitar];

    [_secondaryViewController willBecomeInactive];
	
	[_model addDelegate:_primaryViewController];
	[_model addDelegate:_secondaryViewController];
	
	// Add for iPad functionality
	[_splitViewController setPrimaryInstrumentController:_primaryViewController];
	[_splitViewController setSecondaryInstrumentController:_secondaryViewController];
	[_splitViewController setModel:_model];
	[_window addSubview:[_splitViewController view]];
	
	[_primaryViewController release];
	[_secondaryViewController release];

    [_window makeKeyAndVisible];
    [self animateIn];
}

- (void) animateIn
{
    // Animate in...
    float animationDistance = 1024.0f;
    CGRect rect = [[_secondaryViewController view] frame];
    rect.origin.x += animationDistance;
    [[_secondaryViewController view] setFrame:rect];
    
    CGRect rect2 = [[_primaryViewController view] frame];
    rect2.origin.x -= animationDistance;
    [[_primaryViewController view] setFrame:rect2];
    
    [[_splitViewController controlsView] setAlpha:0.0f];

    [UIView animateWithDuration:0.5f animations:^(void) {
        CGRect rect = [[_secondaryViewController view] frame];
        rect.origin.x -= animationDistance;
        [[_secondaryViewController view] setFrame:rect];
        
        CGRect rect2 = [[_primaryViewController view] frame];
        rect2.origin.x += animationDistance;
        [[_primaryViewController view] setFrame:rect2];
        
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
	[_primaryViewController release];
	[_secondaryViewController release];
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
