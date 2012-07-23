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
- (NCInstrumentType) primaryInstrumentType;
- (NCInstrumentType) secondaryInstrumentType;
- (void) setInstrumentType:(NCInstrumentType)instrumentType forRole:(NCInstrumentRole)instrumentRole;
- (void) presentModal:(UIViewController*)controller;

@end

@interface NCToolbarViewController : UIViewController

#pragma mark IBActions
- (IBAction)swapPressed:(id)sender;
- (IBAction)chordsPressed:(id)sender;

- (IBAction)guitarPressed:(id)sender;
- (IBAction)bassPressed:(id)sender;
- (IBAction)pianoPressed:(id)sender;
- (IBAction)helpPressed:(id)sender;

#pragma mark Instance Methods
- (NCInstrumentRole) roleForSender:(id)sender;
- (NSSet*) guitarInstruments;
- (NSSet*) bassInstruments;
- (NSSet*) pianoInstruments;
- (void) setPressedStates;

/* All instruments buttons for the bottom are contained in here */
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *bottomButtons;
@property (retain, nonatomic) IBOutlet UIButton *bottomGuitar;
@property (retain, nonatomic) IBOutlet UIButton *bottomBass;
@property (retain, nonatomic) IBOutlet UIButton *bottomPiano;

/* All instruments buttons for the top are contained in here */
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *topButtons;
@property (retain, nonatomic) IBOutlet UIButton *topGuitar;
@property (retain, nonatomic) IBOutlet UIButton *topBass;
@property (retain, nonatomic) IBOutlet UIButton *topPiano;

@property (assign, nonatomic) NSObject<NCToolbarViewDelegate>* delegate;

@property (retain, nonatomic) UIButton* topSelectedButton;
@property (retain, nonatomic) UIButton* bottomSelectedButton;

@end
