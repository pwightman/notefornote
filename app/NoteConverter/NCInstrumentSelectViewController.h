//
//  NCInstrumentSelectViewControllerViewController.h
//  NoteConverter
//
//  Created by Parker Wightman on 3/14/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCToolbarViewController.h"

@interface NCInstrumentSelectViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray* instrumentTypes;
@property (nonatomic, assign) NSObject<NCToolbarViewDelegate>* delegate;
@property (nonatomic) NCInstrumentRole role;
@property (nonatomic, assign) UIPopoverController* popover;

- (id) initWithStyle:(UITableViewStyle)style withControlDelegate:(NSObject<NCToolbarViewDelegate>*)controlsDelegate andRole:(NCInstrumentRole)instrumentRole;
- (NSString*) stringForInstrumentType:(NCInstrumentType)instrumentType;

@end
