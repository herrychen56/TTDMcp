//
//  TTDTextField.m
//  TTD
//
//  Created by Mark Hao on 8/5/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import "TTDTextField.h"

@implementation TTDTextField

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitializer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitializer];
    }
    return self;
}

- (void)commonInitializer
{
    self.layer.cornerRadius = 4.0;
    self.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.9].CGColor;
    self.layer.borderWidth = 1.0;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 0);
}

@end
