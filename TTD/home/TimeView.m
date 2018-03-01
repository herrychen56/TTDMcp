//
//  TimeView.m
//  TTD
//
//  Created by guligei on 12/10/12.
//  Copyright (c) 2012 totem. All rights reserved.
//

#import "TimeView.h"
#import "DataModel.h"
#import "NSString+URLEncoding.h"

#define kLastCellBgOriginHeight         42
#define kNoteTextViewOriginHeight       34
#define kSelfOriginHeight               163

@implementation TimeView
@synthesize mDelegate;
@synthesize timePicker, datePicker, durationPicker, toolBar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    return self;
}

- (void)setCellEditable:(BOOL)editable
{
    self.dateField.enabled = editable;
    self.timeField.enabled = editable;
    self.noteTextView.editable = editable;
    self.durationField.enabled = editable;
    self.arrawOne.hidden = !editable;
    self.arrawTwo.hidden = !editable;
    self.arrawThree.hidden = !editable;
}

- (void)setDate:(NSDate *)date
{
    if ([date isKindOfClass:[NSDate class]]) {
//        self.timePicker.date = date;
        self.datePicker.date = date;
//        [self pickerSelectedAction:self.timePicker];
        [self pickerSelectedAction:self.datePicker];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setAMSymbol:@"AM"];
        [formatter setPMSymbol:@"PM"];
        [formatter setDateFormat:@"a"];
        NSString* AMPM = [formatter stringFromDate:date];
        [formatter setDateFormat:@"hh"];
        NSString* HR = [formatter stringFromDate:date];
        [formatter setDateFormat:@"mm"];
        NSString* MIN = [formatter stringFromDate:date];
        if (HR.length == 1) {
            HR = [NSString stringWithFormat:@"0%@", HR];
        }
        if (MIN.length == 1) {
            MIN = [NSString stringWithFormat:@"0%@", MIN];
        }
        self.timeField.text = [NSString stringWithFormat:@"%@:%@ %@", HR, MIN, AMPM];
        if ([AMPM isEqualToString:@"AM"]) {
            [self.mTimePicker selectRow:0 inComponent:2 animated:NO];
        }
        else {
            [self.mTimePicker selectRow:1 inComponent:2 animated:NO];
        }
        self.timeField.text = [NSString stringWithFormat:@"%@:%@ %@", HR, MIN, AMPM];
        if ([AMPM isEqualToString:@"AM"]) {
            [self.mTimePicker selectRow:0 inComponent:2 animated:NO];
        }
        else {
            [self.mTimePicker selectRow:1 inComponent:2 animated:NO];
        }
        [self.mTimePicker selectRow:[HR intValue]-1 inComponent:0 animated:NO];
        [self.mTimePicker selectRow:[MIN intValue] inComponent:1 animated:NO];
    }
}

- (void)setDuration:(NSString *)dur
{
    for (int i = 0; i < self.durationArray.count; i++) {
        DurationInfo* duration = [self.durationArray objectAtIndex:i];
        if (duration.durationID == [dur floatValue]) {
            self.durationField.text = duration.durationString;
        }
    }
}

- (void)setNote:(NSString *)note
{
    
  
    shouldNotifyDelegate = NO;
    self.noteTextView.text = note;

    
    //计算文本的高度
    CGSize constraintSize;
    constraintSize.width = self.noteTextView.frame.size.width-16;
    constraintSize.height = MAXFLOAT;
    CGSize sizeFrame =[self.noteTextView.text sizeWithFont:self.noteTextView.font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    //重新调整高度
    //textView
    self.noteTextView.frame = CGRectMake(self.noteTextView.frame.origin.x,self.noteTextView.frame.origin.y,self.noteTextView.frame.size.width,sizeFrame.height+25);
    //lastCellBG
     lastCellBG.frame=CGRectMake(lastCellBG.frame.origin.x,lastCellBG.frame.origin.y,lastCellBG.frame.size.width,lastCellBG.frame.size.height+sizeFrame.height);
    //self.frame
     self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height+sizeFrame.height+15);
    
}

- (void)reset
{
    [self awakeFromNib];
}


- (NSDictionary*)collectParams
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setValue:self.dateField.text forKey:@"Date"];

    
    [dic setValue:[NSString stringWithFormat:@"%ld", [self.mTimePicker selectedRowInComponent:0] + 1] forKey:@"Hr"];
    [dic setValue:[NSString stringWithFormat:@"%ld", (long)[self.mTimePicker selectedRowInComponent:1]] forKey:@"Min"];
    [dic setValue:[self.mTimePicker selectedRowInComponent:2] == 0?@"AM":@"PM" forKey:@"AMPM"];
    if (self.durationField.text.length == 0) {
        return nil;
    }
    for (int i = 0; i < self.durationArray.count; i++) {
        DurationInfo* duration = [self.durationArray objectAtIndex:i];
        if ([duration.durationString isEqualToString:self.durationField.text]) {
            [dic setValue:[NSString stringWithFormat:@"%0.2f", duration.durationID] forKey:@"Duration"];
        }
    }
    NSString* notes = [self.noteTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dic setValue:notes forKey:@"Notes"];
    NSLog(@"dic:%@", dic);
    return dic;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [self.signature.studentField resignFirstResponder];
    [self.signature.passwordField resignFirstResponder];
    NewSessionTrackerViewController *conrell = [[NewSessionTrackerViewController alloc]init];
    [conrell.subjectField resignFirstResponder];
    [conrell.locationField resignFirstResponder];
    [conrell.rotioField resignFirstResponder];
    if (!self.durationArray) {
        self.durationArray = SharedAppDelegate.durationArray;
    }
    [durationPicker reloadAllComponents];
}

- (IBAction)doneAction:(id)sender
{
//    [self pickerSelectedAction:timePicker];
    [self pickerSelectedAction:datePicker];
    [self pickerView:self.durationPicker didSelectRow:[self.durationPicker selectedRowInComponent:0] inComponent:0];
    [self pickerView:self.mTimePicker didSelectRow:[self.mTimePicker selectedRowInComponent:0] inComponent:0];
    [self.dateField resignFirstResponder];
    [self.timeField resignFirstResponder];
    [self.durationField resignFirstResponder];
    [self.noteTextView resignFirstResponder];
}

- (IBAction)pickerSelectedAction:(id)sender
{
    UIDatePicker* picker = (UIDatePicker*)sender;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setAMSymbol:@"AM"];
    [formatter setPMSymbol:@"PM"];
    if (picker == datePicker) {
        [formatter setDateFormat:@"MM/dd/yyyy"];
        self.dateField.text = [formatter stringFromDate:picker.date];
    }
    else {

    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dateField.inputAccessoryView = toolBar;
    self.timeField.inputAccessoryView = toolBar;
    self.durationField.inputAccessoryView = toolBar;
    self.dateField.inputView = datePicker;
    self.timeField.inputView = self.mTimePicker;
    self.durationField.inputView = durationPicker;
    NSDate* currentDate = [NSDate date];
    NSDate* startDate = [NSDate dateWithTimeInterval:-3600 sinceDate:currentDate];
    datePicker.date = startDate;
    [self pickerSelectedAction:datePicker];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setAMSymbol:@"AM"];
    [formatter setPMSymbol:@"PM"];
    [formatter setDateFormat:@"a"];
    NSString* AMPM = [formatter stringFromDate:startDate];
    [formatter setDateFormat:@"hh"];
    NSString* HR = [formatter stringFromDate:startDate];
    [formatter setDateFormat:@"mm"];
    NSString* MIN = [formatter stringFromDate:startDate];
    if (HR.length == 1) {
        HR = [NSString stringWithFormat:@"0%@", HR];
    }
    if (MIN.length == 1) {
        MIN = [NSString stringWithFormat:@"0%@", MIN];
    }
    self.timeField.text = [NSString stringWithFormat:@"%@:%@ %@", HR, MIN, AMPM];
    if ([AMPM isEqualToString:@"AM"]) {
        [self.mTimePicker selectRow:0 inComponent:2 animated:NO];
    }
    else {
        [self.mTimePicker selectRow:1 inComponent:2 animated:NO];
    }
    [self.mTimePicker selectRow:[HR intValue]-1 inComponent:0 animated:NO];
    [self.mTimePicker selectRow:[MIN intValue] inComponent:1 animated:NO];
    self.noteTextView.text = nil;
    self.durationArray = SharedAppDelegate.durationArray;
    self.durationField.text = @"1:00";
    [self.durationPicker selectRow:3 inComponent:0 animated:NO];
    UIImage* image = [[UIImage imageNamed:@"table_bottom_part.png"] stretchableImageWithLeftCapWidth:100 topCapHeight:20];
    lastCellBG.image = image;
    height = 34;
    shouldNotifyDelegate = YES;
    CGRect frame = lastCellBG.frame;
    frame.size.height = kLastCellBgOriginHeight;
    lastCellBG.frame = frame;
    frame = self.noteTextView.frame;
    frame.size.height = kNoteTextViewOriginHeight;
    self.noteTextView.frame = frame;
    frame = self.frame;
    frame.size.height = kSelfOriginHeight;
    self.frame = frame;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    //计算文本的高度
    CGSize constraintSize;
    constraintSize.width = self.noteTextView.frame.size.width-16;
    constraintSize.height = MAXFLOAT;
    CGSize sizeFrame =[self.noteTextView.text sizeWithFont:self.noteTextView.font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    //重新调整高度
    //textView
    self.noteTextView.frame = CGRectMake(self.noteTextView.frame.origin.x,self.noteTextView.frame.origin.y,self.noteTextView.frame.size.width,sizeFrame.height+25);
    
    NSLog(@"size: %f", textView.contentSize.height);
//Disable Code By Andy 2014-11-21 Xcode 5.1.1 Bug
    CGFloat lastHeight = height;
    //height = textView.contentSize.height;
    height=sizeFrame.height+25;
    if (lastHeight != height) {
        CGRect frame = lastCellBG.frame;
        frame.size.height = height + 12;
        lastCellBG.frame = frame;
        frame = self.noteTextView.frame;
        frame.size.height = height;
        self.noteTextView.frame = frame;
        frame = self.frame;
        frame.size.height = height + 129;
        self.frame = frame;
        if (!shouldNotifyDelegate) {
            shouldNotifyDelegate = YES;
            return;
        }
        if (self.mDelegate) {
            [self.mDelegate timeView:self resized:height - lastHeight];
        }
    }
   

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == self.durationPicker) {
        return 1;
    }
    else {
        return 3;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.durationPicker) {
        if (self.durationArray.count > 0) {
            return self.durationArray.count;
        }
        return 1;
    }
    else {
        if (component == 2) {
            return 2;
        }
        else if (component == 0) {
            return 12;
        }
        else {
            return 60;
        }
    }
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.durationPicker) {
        if (self.durationArray.count > 0) {
            DurationInfo* duration = [self.durationArray objectAtIndex:row];
            return duration.durationString;
        }
        return @"";
    }
    else {
        if (component == 2) {
            if (row == 0) {
                return @"AM";
            }
            else {
                return @"PM";
            }
        }
        else if (component == 0) {
            return [NSString stringWithFormat:@"%ld", row + 1];
        }
        else {
            return [NSString stringWithFormat:@"%ld", row];
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.durationPicker) {
        if (self.durationArray.count > row) {
            DurationInfo* duration = [self.durationArray objectAtIndex:row];
            self.durationField.text = duration.durationString;
        }
    }
    else {
        NSString* HR;
        NSInteger hr = [self.mTimePicker selectedRowInComponent:0] + 1;
        if (hr >= 10) {
            HR = [NSString stringWithFormat:@"%ld", hr];
        }
        else {
            HR = [NSString stringWithFormat:@"0%ld", hr];
        }
        NSString* MIN;
        NSInteger min = [self.mTimePicker selectedRowInComponent:1];
        if (min >= 10) {
            MIN = [NSString stringWithFormat:@"%ld", min];
        }
        else {
            MIN = [NSString stringWithFormat:@"0%ld", min];
        }
        self.timeField.text = [NSString stringWithFormat:@"%@:%@ %@",HR, MIN,[self.mTimePicker selectedRowInComponent:2] == 0?@"AM":@"PM"];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (pickerView == self.mTimePicker) {
        return 50;
    }
    else {
        return 150;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if (pickerView == self.mTimePicker) {
        return 35;
    }
    else {
        return 40;
    }
}

@end
