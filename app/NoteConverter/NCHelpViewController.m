//
//  NCHelpViewController.m
//  NoteConverter
//
//  Created by Parker Wightman on 3/15/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "NCHelpViewController.h"

@interface NCHelpViewController ()

@end

@implementation NCHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)donePressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
