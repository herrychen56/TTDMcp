//
//  ViewStudentsUpDocumentViewController.m
//  TTD
//
//  Created by andy on 15/3/31.
//  Copyright (c) 2015年 totem. All rights reserved.
//
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "Photo.h"
#import "ViewStudentsUpDocumentViewController.h"
#import "BCTabBarController.h"
#define Screen_height   [[UIScreen mainScreen] bounds].size.height
#define Screen_width    [[UIScreen mainScreen] bounds].size.width
@interface ViewStudentsUpDocumentViewController () <UIImagePickerControllerDelegate>

@end

@implementation ViewStudentsUpDocumentViewController
@synthesize studentDocumentTypePickerView;
@synthesize toolBar,studentDocumentTypeArray,studentDocumentSensitive,studentDocumentFileImage,studentDocumentFileImageName,studentDetail,studentDocumentFileNotes,btsubmit,btClose,btUpload;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDocumentInfo];
    studentDocumentFileNotes.delegate=self;
    studentDocumentTypeField.inputAccessoryView = toolBar;
    studentDocumentTypeField.inputView=studentDocumentTypePickerView;
    //    [btsubmit setBackgroundColor:[UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0]];
    //    [btsubmit.layer setCornerRadius:3];
    //    [btsubmit.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    //    [btsubmit.layer setBorderWidth:1.0];
    
    //    UIImageView *btCloseImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"closeBlack@2x.png"]];
    //    btCloseImage.frame=CGRectMake(0, 0, 15, 15);
    //    [btClose addSubview:btCloseImage];
//        UIImageView *btUploadImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Jiahao.png"]];
//        btUploadImage.frame=CGRectMake(0, 0, 25, 25);
//        [btUpload addSubview:btUploadImage];
    
    //UIImage *btCloseImage=[UIImage imageNamed:@"chahao.png"];
    //[btCloseImage drawInRect:CGRectMake(0, 0, 15, 15)];
    //[btClose setImage:btCloseImage forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *maskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnMaskView)];
    maskTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:maskTap];
    
    UIView *contentView = (UIView *)[self.view viewWithTag:101];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.frame=CGRectMake(0, Screen_height-contentView.frame.size.height, Screen_width, Screen_height);
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidHidden:) name:UIKeyboardDidHideNotification object:nil];
}
-(void)handleKeyboardDidShow:(NSNotification *)paramNotification
{
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    NSDictionary *userInfo = [paramNotification userInfo];
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self showKeyboardPopupConroller:-keyboardRect.size.height+20+40];
}
-(void)handleKeyboardDidHidden:(NSNotification *)notification
{
    NSLog(@"DocumenthandleKeyboardDidHidden.");
    [self showKeyboardPopupConroller:0];
}
- (void)showKeyboardPopupConroller:(CGFloat)PopupConrollerFrameOriginY {
    NSLog(@"documentFrameY:%f",self.view.frame.origin.y);
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view needsUpdateConstraints];
                         [self.view layoutIfNeeded];
                         self.view.frame=CGRectMake(self.view.frame.origin.x,PopupConrollerFrameOriginY, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
- (IBAction)submitStudentDocument:(id)sender
{
    [self StudentDocumentaction];
    
}
- (IBAction)doneClickedStudentDocumentType:(id)sender
{
    if ([studentDocumentTypeField isFirstResponder]) {
        [studentDocumentTypeField resignFirstResponder];
        //[studentDocumentTypePickerView reloadAllComponents];
        [self pickerView:self.studentDocumentTypePickerView didSelectRow:[self.studentDocumentTypePickerView selectedRowInComponent:0] inComponent:0];
    } else {
        [studentDocumentTypeField becomeFirstResponder];
    }
}
- (IBAction)FileUpload:(id)sender
{
    [self.view endEditing:YES];
    //    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Choose from photo library",nil];
    //    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [self uploadPhotoClicked];
    
}
-(IBAction)CloseView:(id)sender
{
    [self.view removeFromSuperview];
}
#pragma mark - UIPickerViewDataSource
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (editingRow == 100) {
        if (self.studentDocumentTypeArray.count > 0) {
            studentDocumentTypeInfo* info = [self.studentDocumentTypeArray objectAtIndex:row];
            return info.document_type_name;
        }
    }
    
    return @"";
}
#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (editingRow==100)
    {
        
        if (self.studentDocumentTypeArray.count > row)
        {
            studentDocumentTypeInfo *fileType = [studentDocumentTypeArray objectAtIndex:row];
            studentDocumentTypeField.text = fileType.document_type_name;
            studentDocumentTypeFieldId=fileType.document_type_id;
        }
    }
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (editingRow==100)
    {
        return self.studentDocumentTypeArray.count;
    }
    else
    {
        return 0;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    editingRow = textField.tag;
    if (editingRow==100) {
        [studentDocumentTypePickerView reloadAllComponents];
        if (studentDocumentTypeField.text.length > 0) {
            for (int i = 0; i < studentDocumentTypeArray.count; i++) {
                studentDocumentTypeInfo* info = [studentDocumentTypeArray objectAtIndex:i];
                if ([studentDocumentTypeField.text isEqualToString:info.document_type_name]) {
                    [studentDocumentTypePickerView selectRow:i inComponent:0 animated:NO];
                    break;
                }
            }
        }
    }else if (editingRow==101)
    {
        
    }
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    editingRow = textField.tag;
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    editingRow = textView.tag;
    if (editingRow==102)
    {
        if ([studentDocumentFileNotes.text isEqualToString:@"Notes"]) {
            studentDocumentFileNotes.text=@"";
        }
        
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    editingRow = textView.tag;
    if (editingRow==102)
    {
        if ([studentDocumentFileNotes.text isEqualToString:@""]) {
            studentDocumentFileNotes.text=@"Notes";
        }
        
    }
}
-(void) loadDocumentInfo
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            SharedAppDelegate.role, @"role",nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_STUDENTDOCUMENTTYPE parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         
         self.studentDocumentTypeArray = [studentDocumentTypeInfo studentDocumentTypeArrayWithXMLDocument:XMLDocument];
         if(self.studentDocumentTypeArray.count>0)
         {
             studentDocumentTypeInfo *typeInfo=[self.studentDocumentTypeArray objectAtIndex:0];
             studentDocumentTypeField.text=typeInfo.document_type_name;
             studentDocumentTypeFieldId=typeInfo.document_type_id;
         }
         [self hiddenHUD];
         
     }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         //NSLog(@"result, error:%@",error);
     }];
    [operation start];
    [self showHUD];
}

#pragma mark ----------图片选择完成-------------
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self showHUD];
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            NSString *fileName = [representation filename];
            UIImage  *chosedImage=[info objectForKey:@"UIImagePickerControllerEditedImage"];
            if (chosedImage==nil) {
                chosedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
                if (fileName==nil) {
                    fileName=@"Camera.JPG";
                }
            }
            NSString *dataStr = [Photo image2String:chosedImage];
            fileImageName.text=fileName;
            UIImageView *UserPhoto2=[[UIImageView alloc] init];
            UserPhoto2.layer.masksToBounds = YES;
            UserPhoto2.layer.cornerRadius = 6.0;
            UserPhoto2.layer.borderWidth = 1.0;
            UserPhoto2.layer.borderColor = [[UIColor whiteColor] CGColor];
            studentDocumentFileImage.layer.shadowColor=[UIColor grayColor].CGColor;
            studentDocumentFileImage.layer.shadowOffset=CGSizeMake(0, 0);
            studentDocumentFileImage.layer.shadowOpacity=0.5;
            studentDocumentFileImage.layer.shadowRadius=2;
            [studentDocumentFileImage addSubview:UserPhoto2];
            UIImage *Image2=[Photo string2Image:dataStr];
            self.studentDocumentFileImage.image=Image2;
            NSData *data = UIImageJPEGRepresentation(Image2, 1.0);
            fileImageBytes=data.base64Encoding;
            Image2=nil;
            
            [self hiddenHUD];
            
        };
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURL
                       resultBlock:resultblock
                      failureBlock:nil];
        
        
        
    }];
    
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BCTabBarController *tab =  (BCTabBarController *)app.window.rootViewController.presentedViewController;
    tab.tabBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BCTabBarController *tab =  (BCTabBarController *)app.window.rootViewController.presentedViewController;
    tab.tabBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
    
}

-(void)StudentDocumentaction
{
    
    if ([studentDocumentTypeField.text isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]  initWithTitle:@"" message:@"The file type cannot be empty." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if ([studentDocumentFileNotes.text isEqualToString:@"Notes"]) {
        studentDocumentFileNotes.text=@"";
    }
    if (fileImageBytes.length<=0) {
        UIAlertView *alert=[[UIAlertView alloc]  initWithTitle:@"" message:@"Please select a file." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSString *studentId=studentDetail.stu_id;
    //NSString *studentId=@"4676";
    NSString *typeId=[NSString stringWithFormat:@"%d",studentDocumentTypeFieldId];
    NSString *txtNotes=studentDocumentFileNotes.text;//[self utf8ToUnicode:studentDocumentFileNotes.text];
    
    NSString *sensitve=@"false";
    if (studentDocumentSensitive.on==YES) {
        sensitve=@"true";
    }
    if ([studentId isKindOfClass:[NSNull class]] || studentId.length<1) {
        studentId =@"0";
    }
    NSString *document_name=fileImageName.text;
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            SharedAppDelegate.role, @"currentrole",
                            studentId,@"studentId",
                            typeId,@"typeId",
                            txtNotes,@"txtNotes",
                            sensitve,@"sensitive",
                            document_name,@"document_name",
                            fileImageBytes,@"file_data",
                            nil];
    
    //NSDictionary * param =@{@"username":SharedAppDelegate.username,@"password":SharedAppDelegate.password,@"currentrole":SharedAppDelegate.role,@"studentId":studentId,@"typeId":typeId,@"txtNotes":txtNotes,@"sensitive":sensitve,@"document_name":document_name,@"file_data":fileImageBytes};
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_INSERT_STUDENT_DOCUMENTACTIONGETID parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         InsertStudentDocumentationGetIDResponse* res = [InsertStudentDocumentationGetIDResponse InsertStudentDocumentationGetIDResponseWithDDXMLDocument:XMLDocument];
         
         [self hiddenHUD];
         if ([res.InsertStudentDocumentationGetIDMessage isEqualToString:@"true" ])
         {
             [self showToastMessage:@"Succeed" duration:3.0f];
             [self.delegate uploadCompleted];
             [self.view removeFromSuperview];
         }
         else if ([res.InsertStudentDocumentationGetIDMessage isEqualToString:@"false" ])
         {
//             UIAlertView *alert=[[UIAlertView alloc]  initWithTitle:@"" message:@"The document upload failed." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//             [alert show];
             [LEEAlert alert].config
             .LeeTitle(@"")
             .LeeContent(@"The document upload failed.")
             .LeeAction(@"Ok", ^{
                 
             })
             .LeeShow();
             return;
         }
         else
         {
//             UIAlertView *alert=[[UIAlertView alloc]  initWithTitle:@"" message:res.InsertStudentDocumentationGetIDMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//             [alert show];
             
             [LEEAlert alert].config
             .LeeTitle(@"")
             .LeeContent(res.InsertStudentDocumentationGetIDMessage)
             .LeeAction(@"Ok", ^{
                 
             })
             .LeeShow();
             
             
             return;
         }
         
         
     }
      failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         NSLog(@"error:%@", error);
         [self showAlertWithTitle:nil andMessage:@"No Network"];
     }];
    [operation start];
    [self showHUD];
    
}

- (void)uploadPhotoClicked {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select a photo" message:@"Where do you want to choose from?" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickerForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self showImagePickerForSourceType: UIImagePickerControllerSourceTypeCamera];
        } else {
            NSLog(@"There is not a camera on this device");
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showImagePickerForSourceType: (UIImagePickerControllerSourceType)type {
    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
    imgPicker.delegate = (id)self;
    [imgPicker setAllowsEditing:NO];
    imgPicker.sourceType = type;
    [self presentViewController:imgPicker animated:YES completion:nil];
}

//-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex==0) {
//
//        //检查相机是否可用
//        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//        {
//            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Warm Tips" message:@"The camera is not found or current camera is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            return;
//        }
//        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//        {
//            AVAuthorizationStatus authStatus=[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//            if(authStatus !=AVAuthorizationStatusAuthorized)
//            {
//                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"The camera is not authorized" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//                [alert show];
//                return;
//            }
//        }
//        [self showCamera];
//
//    }else if (buttonIndex==1)
//    {
//        [self showHUD];
//        UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
//        [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//        [imgPicker setDelegate:(id)self];
//        [imgPicker setAllowsEditing:NO];
//
//        //[self presentViewController:imgPicker animated:YES completion:^{
//        //}];
//        //[self.view.window.rootViewController presentViewController:imgPicker animated:YES completion:nil];
//        [[self navigationController] presentViewController:imgPicker animated:YES completion:nil];
//
//        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        BCTabBarController *tab =  (BCTabBarController *)app.window.rootViewController.presentedViewController;
//        tab.tabBar.hidden = YES;
//        [self hiddenHUD];
//    }
//}
-(void)showCamera{
    [self showHUD];
    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imgPicker setDelegate:(id)self];
    [imgPicker setAllowsEditing:NO];
    //    if([[[UIDevice
    //          currentDevice] systemVersion] floatValue]>=8.0) {
    //        //imgPicker.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    //        double delayInSeconds = 0.1;
    //        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    //             [[self navigationController] presentViewController:imgPicker animated:YES completion:nil];
    //        });
    //    }else
    //    {
    [[self navigationController] presentViewController:imgPicker animated:YES completion:nil];
    //    }
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BCTabBarController *tab =  (BCTabBarController *)app.window.rootViewController.presentedViewController;
    tab.tabBar.hidden = YES;
    
    
    
    [self hiddenHUD];
}
-(void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didTapOnMaskView {
    [self.view endEditing:YES];
}
-(NSString *) utf8ToUnicode:(NSString *)string
{
    NSUInteger length = [string length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++)
    {
        unichar _char = [string characterAtIndex:i];
        //判断是否为英文和数字
        if (_char <= '9' && _char >='0')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }
        else if(_char >='a' && _char <= 'z')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
            
        }
        else if(_char >='A' && _char <= 'Z')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }
        else
        {
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
        }
    }
    return s;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
// Returns interface orientation masks.
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
-(BOOL)shouldAutorotat
{
    return NO;
}
//-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
//{
////    if([UIMenuController sharedMenuController]){
////        [UIMenuController sharedMenuController].menuVisible=NO;
////    }
////    return NO;
//}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

