//
//  NCLoadingView.m
//  NoteConverter
//
//  Created by Parker Wightman on 3/15/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//

#import "NCLoadingView.h"

@implementation NCLoadingView

@synthesize indicator;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:indicator];
        [self setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f]];
    }
    return self;
}

- (void) layoutSubviews
{
    indicator.center = self.center;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
