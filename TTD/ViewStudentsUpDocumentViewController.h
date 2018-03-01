//
//  ViewStudentsUpDocumentViewController.h
//  TTD
//
//  Created by andy on 15/3/31.
//  Copyright (c) 2015年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UploadDocumentDelegate;

@interface ViewStudentsUpDocumentViewController : BaseViewController<UIActionSheetDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    NSInteger editingRow;
    IBOutlet UITextField* studentDocumentTypeField;
    int studentDocumentTypeFieldId;
    IBOutlet UILabel* fileImageName;
    IBOutlet NSString* fileImageBytes;
    
}

@property (nonatomic, weak) id<UploadDocumentDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIButton* btClose;
@property (nonatomic, strong) IBOutlet UIButton* btsubmit;
@property (nonatomic, strong) IBOutlet UIToolbar* toolBar;
@property (nonatomic, strong) IBOutlet UIPickerView* studentDocumentTypePickerView;
@property (nonatomic, strong) NSMutableArray *studentDocumentTypeArray;
@property (nonatomic, strong) IBOutlet UISwitch* studentDocumentSensitive;
@property (nonatomic, strong) IBOutlet UIImageView* studentDocumentFileImage;
@property (nonatomic, strong) IBOutlet UIButton* studentDocumentFileImageName;
@property (nonatomic, strong) IBOutlet UIButton* btUpload;
@property (nonatomic, strong) IBOutlet UITextView* studentDocumentFileNotes;
@property (strong, nonatomic) StudentDetail* studentDetail;

@end

@protocol UploadDocumentDelegate <NSObject>

- (void)uploadCompleted;

@end
