//
//  NCInstrumentSelectViewControllerViewController.m
//  NoteConverter
//
//  Created by Parker Wightman on 3/14/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "NCInstrumentSelectViewController.h"

@interface NCInstrumentSelectViewController ()

@end

@implementation NCInstrumentSelectViewController

@synthesize instrumentTypes, delegate, role, popover;

- (id)initWithStyle:(UITableViewStyle)style withControlDelegate:(NSObject<NCToolbarViewDelegate> *)controlsDelegate andRole:(NCInstrumentRole)instrumentRole;
{
    self = [super initWithStyle:style];
    if (self) {
        self.instrumentTypes = [[NSMutableArray alloc] initWithCapacity:7];
        [instrumentTypes addObject:[NSNumber numberWithInt:NCInstrumentType4StringBass]];
        [instrumentTypes addObject:[NSNumber numberWithInt:NCInstrumentType5StringBass]];
        [instrumentTypes addObject:[NSNumber numberWithInt:NCInstrumentType6StringBass]];
        [instrumentTypes addObject:[NSNumber numberWithInt:NCInstrumentType6StringGuitar]];
        [instrumentTypes addObject:[NSNumber numberWithInt:NCInstrumentTypePiano]];
        self.delegate = controlsDelegate;
        self.role = instrumentRole;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [instrumentTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    [[cell textLabel] setText:[self stringForInstrumentType:[[instrumentTypes objectAtIndex:indexPath.row] intValue]]];
    
    return cell;
}

- (NSString*) stringForInstrumentType:(NCInstrumentType)instrumentType
{
    NSString* string;
    switch (instrumentType) {
        case NCInstrumentTypePiano:
            string = @"Piano";
            break;
        case NCInstrumentType6StringBass:
            string = @"6-String Bass";
            break;
        case NCInstrumentType5StringBass:
            string = @"5-String Bass";
            break;
        case NCInstrumentType4StringBass:
            string = @"4-String Bass";
            break;
        case NCInstrumentType6StringGuitar:
            string = @"Guitar";
            break;
            
        default:
            string = @"";
            break;
    }
    return string;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [delegate setInstrumentType:[[instrumentTypes objectAtIndex:indexPath.row] intValue] forRole:self.role];
    [self.popover dismissPopoverAnimated:YES];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
