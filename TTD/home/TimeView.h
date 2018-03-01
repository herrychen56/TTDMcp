//
//  TimeView.h
//  TTD
//
//  Created by guligei on 12/10/12.
//  Copyright (c) 2012 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewSessionTrackerViewController.h"
#import "SignatureView.h"
#define kTimeViewOriginHeight       163

@class TimeView;
@protocol TimeViewResizeDelegate <NSObject>

- (void)timeView:(TimeView*)timeView resized:(CGFloat)height;

@end

@interface TimeView : UIView <UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, UITextFieldDelegate>
{
    BOOL shouldNotifyDelegate;
    IBOutlet UIImageView* lastCellBG;
    NSMutableArray* timeArray;
    CGFloat height;
}

@property (strong, nonatomic) IBOutlet UIDatePicker* datePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker* timePicker;
@property (strong, nonatomic) IBOutlet UIPickerView* mTimePicker;
@property (strong, nonatomic) IBOutlet UIPickerView* durationPicker;
@property (strong, nonatomic) IBOutlet UIToolbar* toolBar;
@property (strong, nonatomic) IBOutlet UITextField* dateField;
@property (strong, nonatomic) IBOutlet UITextField* timeField;
@property (strong, nonatomic) IBOutlet UITextField* durationField;
@property (strong, nonatomic) IBOutlet UITextView* noteTextView;

@property (strong, nonatomic) IBOutlet UIImageView* arrawOne;
@property (strong, nonatomic) IBOutlet UIImageView* arrawTwo;
@property (strong, nonatomic) IBOutlet UIImageView* arrawThree;

@property (strong, nonatomic) NSMutableArray* durationArray;
@property (strong, nonatomic) NSDate* defaultDate;

@property (assign, nonatomic) id<TimeViewResizeDelegate> mDelegate;
@property (nonatomic, strong) SignatureView *signature;
- (NSDictionary*)collectParams;
- (void)setDate:(NSDate*)date;
- (void)setDuration:(NSString*)duration;
- (void)setNote:(NSString*)note;
- (void)reset;
- (void)setCellEditable:(BOOL)editable;

@end
