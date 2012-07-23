//
//  NCSplitViewController.h
//  NoteConverter
//
//  Created by Parker Wightman on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "NCInstrumentViewController.h"
#import "NCGuitarViewController.h"
#import "NCBassViewController.h"
#import "NCControlsView.h"
#import "NCSplitView.h"
#import "NCToolbarViewController.h"

@interface NCSplitViewController : UIViewController <NCToolbarViewDelegate>
{
    NCInstrumentViewController* _primaryInstrumentController;
	NCInstrumentViewController* _secondaryInstrumentController;
}

@property (nonatomic, retain) NCInstrumentViewController* primaryInstrumentController;
@property (nonatomic, retain) NCInstrumentViewController* secondaryInstrumentController;
@property (nonatomic, retain) NCNotesModel* model;

@property (nonatomic, retain) NCToolbarViewController* toolbarController;

- (NCControlsView*) controlsView;


@end
