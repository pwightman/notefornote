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
@synthesize bottomButtons;
@synthesize topButtons, delegate;

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (void)dealloc {
    [bottomButtons release];
    [topButtons release];
    [super dealloc];
}
@end
