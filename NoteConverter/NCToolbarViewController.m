//
//  NCToolbarViewController.m
//  NoteConverter
//
//  Created by Parker Wightman on 3/15/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "NCToolbarViewController.h"
#import "NCHelpViewController.h"
#import "NCInstrumentSelectViewController.h"

@interface NCToolbarViewController ()

@end

@implementation NCToolbarViewController
@synthesize bottomGuitar;
@synthesize bottomBass;
@synthesize bottomPiano;
@synthesize topGuitar;
@synthesize topBass;
@synthesize topPiano;
@synthesize bottomButtons, topButtons, delegate, topSelectedButton, bottomSelectedButton;

- (id)init
{
    self = [super initWithNibName:@"NCToolbarViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setBottomButtons:nil];
    [self setTopButtons:nil];
    [self setBottomSelectedButton:nil];
    [self setTopSelectedButton:nil];
    [self setTopGuitar:nil];
    [self setTopBass:nil];
    [self setTopPiano:nil];
    [self setBottomGuitar:nil];
    [self setBottomBass:nil];
    [self setBottomPiano:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {
    [self setPressedStates];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)swapPressed:(id)sender {
    [delegate swapViews];
}

- (IBAction)chordsPressed:(id)sender {
    if ([delegate toggleMode])
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"optionsButtonPressed"] forState:UIControlStateNormal];
    }
    else {
        [sender setBackgroundImage:[UIImage imageNamed:@"optionsButton"] forState:UIControlStateNormal];
    }
}

- (IBAction)guitarPressed:(id)sender {
    NCInstrumentRole role = [self roleForSender:sender];
    
    [delegate setInstrumentType:NCInstrumentType6StringGuitar forRole:role];
}

- (IBAction)bassPressed:(id)sender {
    NCInstrumentRole role = [self roleForSender:sender];
    NCInstrumentSelectViewController* controller = [[NCInstrumentSelectViewController alloc] initWithStyle:UITableViewStylePlain withControlDelegate:delegate andRole:role];
    
    NSMutableArray* array = [NSArray arrayWithObjects:
                       [NSNumber numberWithInt:NCInstrumentType4StringBass], 
                       [NSNumber numberWithInt:NCInstrumentType5StringBass], 
                       [NSNumber numberWithInt:NCInstrumentType6StringBass], 
                       nil];
    
    [controller setInstrumentTypes:array];

    
    UIPopoverController* popover = [[UIPopoverController alloc] initWithContentViewController:controller];

    [controller setPopover:popover];
    
    [popover presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    
    controller.contentSizeForViewInPopover = [[controller tableView] contentSize];
}

- (IBAction)pianoPressed:(id)sender {
    NCInstrumentRole role = [self roleForSender:sender];
    
    [delegate setInstrumentType:NCInstrumentTypePiano forRole:role];
}

- (IBAction)helpPressed:(id)sender {
    NCHelpViewController* controller = [[NCHelpViewController alloc] initWithNibName:@"NCHelpViewController" bundle:[NSBundle mainBundle]];
    
    [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [delegate presentModal:controller];
    
}

- (NCInstrumentRole) roleForSender:(id)sender
{
    NCInstrumentRole role;
    if ([bottomButtons containsObject:sender])
    {
        role = NCInstrumentRolePrimary;
    }
    else {
        role = NCInstrumentRoleSecondary;
    }

    return role;
}

- (NSSet*) guitarInstruments
{
    return [NSSet setWithObject:[NSNumber numberWithInt:NCInstrumentType6StringGuitar]];
}

- (NSSet*) bassInstruments
{
    return [NSSet setWithObjects:
            [NSNumber numberWithInt:NCInstrumentType4StringBass],
            [NSNumber numberWithInt:NCInstrumentType5StringBass],
            [NSNumber numberWithInt:NCInstrumentType6StringBass],
            nil];
                                
}

- (NSSet*) pianoInstruments
{
    return [NSSet setWithObject:[NSNumber numberWithInt:NCInstrumentTypePiano]];
}

- (void) setPressedStates
{
    [bottomSelectedButton setSelected:FALSE];
    UIButton* selected = nil;
    if ([[self guitarInstruments] containsObject:[NSNumber numberWithInt:[delegate primaryInstrumentType]]]) {
        selected = self.bottomGuitar;
    }
    else if ([[self bassInstruments] containsObject:[NSNumber numberWithInt:[delegate primaryInstrumentType]]]) {
        selected = self.bottomBass;
    }
    else if ([[self pianoInstruments] containsObject:[NSNumber numberWithInt:[delegate primaryInstrumentType]]]) {
        selected = self.bottomPiano;
    }
    
    [selected setSelected:TRUE];
    [self setBottomSelectedButton:selected];
    
    [topSelectedButton setSelected:FALSE];
    selected = nil;
    if ([[self guitarInstruments] containsObject:[NSNumber numberWithInt:[delegate secondaryInstrumentType]]]) {
        selected = self.topGuitar;
    }
    else if ([[self bassInstruments] containsObject:[NSNumber numberWithInt:[delegate secondaryInstrumentType]]]) {
        selected = self.topBass;
    }
    else if ([[self pianoInstruments] containsObject:[NSNumber numberWithInt:[delegate secondaryInstrumentType]]]) {
        selected = self.topPiano;
    }
    
    [selected setSelected:TRUE];
    [self setTopSelectedButton:selected];
    
    if ([delegate primaryInstrumentType] == NCInstrumentTypePiano) {
        [topPiano setEnabled:FALSE];
    }
    else {
        [topPiano setEnabled:TRUE];
    }

    if ([delegate secondaryInstrumentType] == NCInstrumentTypePiano) {
        [bottomPiano setEnabled:FALSE];
    }
    else {
        [bottomPiano setEnabled:TRUE];        
    }
}

- (void)dealloc {
    [bottomButtons release];
    [topButtons release];
    [topSelectedButton release];
    [bottomSelectedButton release];
    [topGuitar release];
    [topBass release];
    [topPiano release];
    [bottomGuitar release];
    [bottomBass release];
    [bottomPiano release];
    [super dealloc];
}
@end
