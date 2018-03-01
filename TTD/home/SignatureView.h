//
//  SignatureView.h
//  TTD
//
//  Created by guligei on 12/10/12.
//  Copyright (c) 2012 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmoothLineView.h"

@class SignatureView;

@protocol SignatureViewDelegate <NSObject>
@optional
- (void)signatureViewTaped:(SignatureView*)signview;
- (void)signatureView:(SignatureView*) signView studentSelected:(NSString*)studentName studentId:(NSInteger) studentId;
- (void)NoShowXY;
- (void)setSubjectAndLocation:(NSString *)subjectName location:(NSString *)location;
@end

@interface SignatureView : UIView <UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate>
{
    NSMutableArray* _studentArray;
    NSMutableArray* _NoShowArray;
    NSInteger editingRow;
  
}
- (IBAction)IBActionNoShowSwitch:(id)sender;
@property (nonatomic, strong) IBOutlet UIToolbar* toolBar;
@property (nonatomic, strong) IBOutlet UIPickerView* pickerView;
@property (strong, nonatomic) IBOutlet UITextField* studentField;
@property (strong, nonatomic) IBOutlet UIImageView* signImageView;
@property (strong, nonatomic) IBOutlet UITextField* passwordField;
@property (strong, nonatomic) IBOutlet UIImageView* arrawImageView;

@property (strong, nonatomic) IBOutlet UITextField* NoShowField;
@property (strong, nonatomic) IBOutlet UIImageView* NoShowarrawImageView;
@property (nonatomic, strong) IBOutlet UIPickerView* NoShowpickerView;
@property (strong, nonatomic) IBOutlet UIImageView* NoShowDrImageView;
@property (strong, nonatomic) IBOutlet UISwitch* NoShowSwitch;

@property (assign, nonatomic) id<SignatureViewDelegate> mDelegate;
@property (strong, nonatomic) NSMutableArray* studentArray;
@property (strong, nonatomic) NSMutableArray* NoShowArray;
@property (strong, nonatomic) IBOutlet UIImageView* bgImageView;
@property (strong, nonatomic) IBOutlet UIImageView* seperatorView;
@property (strong, nonatomic) IBOutlet UIImageView* secondPartView;
@property (strong, nonatomic) IBOutlet UILabel* studentLabel;
@property (strong, nonatomic) IBOutlet UIView* studentView;
@property (strong, nonatomic) IBOutlet UIView* signView;
@property (nonatomic) NSInteger studentFieldId;
@property (nonatomic) bool LoadTimesheet;
@property (nonatomic) NSString* NoShowFieldValue;
- (NSDictionary*)collectParams:(BOOL)shouldCheck;
- (void)reset;
- (void)reloadPicker;
- (void)setStudentArray:(NSMutableArray *)studentArray autoSelect:(BOOL)autoSelect;
- (void)setStudentArray:(NSMutableArray *)studentsArray selectedContent:(NSInteger)content;

- (void)setNoShowArray:(NSMutableArray *)NoShowArray selectedContent:(NSString *) content;
- (void)setPosition:(int)position;
- (NSString*)getStudentString;
- (NSString*)getNoShowString;
- (BOOL*)getNoShowBool;
- (NSInteger)getStudentId;
- (void)setCellEditable:(BOOL)editable;
@property (weak, nonatomic) IBOutlet UIImageView *lastPartView;

@end
