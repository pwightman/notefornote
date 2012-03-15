//
//  NCToolbarViewController.h
//  NoteConverter
//
//  Created by Parker Wightman on 3/15/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NCToolbarViewDelegate <NSObject>

/* Returns the new toggled state */
- (BOOL) toggleMode;
- (void) swapViews;
- (void) setGuitarAsSecondary;
- (void) setBassAsSecondary;
- (void) setInstrumentType:(NCInstrumentType)instrumentType forRole:(NCInstrumentRole)instrumentRole;
- (void) presentModal:(UIViewController*)controller;

@end

@interface NCToolbarViewController : UIViewController

- (IBAction)swapPressed:(id)sender;
- (IBAction)chordsPressed:(id)sender;

- (IBAction)guitarPressed:(id)sender;
- (IBAction)bassPressed:(id)sender;
- (IBAction)pianoPressed:(id)sender;
- (IBAction)helpPressed:(id)sender;

- (NCInstrumentRole) roleForSender:(id)sender;

/* All instruments buttons for the bottom are contained in here */
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *bottomButtons;

/* All instruments buttons for the top are contained in here */
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *topButtons;

@property (retain, nonatomic) NSObject<NCToolbarViewDelegate>* delegate;

@end
