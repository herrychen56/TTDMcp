//
//  SignatureView.m
//  TTD
//
//  Created by guligei on 12/10/12.
//  Copyright (c) 2012 totem. All rights reserved.
//

#import "SignatureView.h"
#import "DataModel.h"
#import "NSString+Base64Addition.h"
#import "NewSessionTrackerViewController.h"
#define kDefaultOriginX     8
#define kDefaultWidth       304

@implementation SignatureView
@synthesize studentArray = _studentArray;
@synthesize NoShowArray=_NoShowArray;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.passwordField.delegate = self;
    }
    return self;
}

//[{"StudentId":"5764","StudentPassword":"fghj","Signature":""}]

- (NSDictionary*)collectParams:(BOOL)shouldCheck
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    if (self.studentField.text.length == 0) {
        if (shouldCheck) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"'Student' cannot be empty!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return nil;
        }
    }
    else {
        for (int i = 0; i < self.studentArray.count; i++) {
            StudentInfo* info = [self.studentArray objectAtIndex:i];
            if ([info.studentName isEqualToString:self.studentField.text]) {
                [dic setValue:[NSString stringWithFormat:@"%d", info.studentId] forKey:@"StudentId"];
            }
        }
        if (![dic valueForKey:@"StudentId"]) {
            if (shouldCheck) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"'Student' cannot be empty!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return nil;
            }
        }
    }
    if (self.NoShowSwitch.on)
    {
        [dic setValue:[NSString stringWithFormat:@"%@",@"Y"] forKey:@"NoShow"];
    }
    else
    {
        [dic setValue:[NSString stringWithFormat:@"%@",@"N"] forKey:@"NoShow"];
    }
    
    if (![dic valueForKey:@"NoShow"]) {
        if (shouldCheck) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"'NoShow' cannot be empty!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return nil;
        }
    }
    /*
     if(self.NoShowField.text.length==0)
    {
        if (shouldCheck) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"'No Show' cannot be empty!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return nil;
        }
    }else
    {
        for (int i = 0; i < self.NoShowArray.count; i++) {
            NoShowInfo* info = [self.NoShowArray objectAtIndex:i];
            if ([info.NoShowString isEqualToString:self.NoShowField.text]) {
                [dic setValue:[NSString stringWithFormat:@"%@", info.NoShowValue] forKey:@"NoShow"];
            }
        }
        
        if (![dic valueForKey:@"NoShow"]) {
            if (shouldCheck) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"'NoShow' cannot be empty!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return nil;
            }
        }
    }
    */
    if (self.passwordField.text.length == 0) {
        if (shouldCheck) {
            if (self.studentFieldId>=0&&self.NoShowSwitch.on==false) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"'Password' cannot be empty!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                return nil;
            }
        }
        [dic setValue:@"" forKey:@"StudentPassword"];
    }
    else {
        [dic setValue:self.passwordField.text forKey:@"StudentPassword"];
    }
    NSData* data = UIImageJPEGRepresentation(self.signImageView.image, 0.5f);
    if (!data) {
        [dic setValue:@"" forKey:@"Signature"];
        if (shouldCheck) {
            if (self.studentFieldId>=0&&self.NoShowSwitch.on==false) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"'Signature' cannot be empty!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                return nil;
            }
        }
    }
    else {
        NSString* signString = [NSString base64StringFromData:data length:data.length];
        [dic setValue:signString forKey:@"Signature"];
    }
    return dic;
}

- (NSString*)getStudentString
{
    for (int i = 0; i < SharedAppDelegate.studentArray.count; i++) {
        StudentInfo* info = [SharedAppDelegate.studentArray objectAtIndex:i];
        NSRange range = [info.studentName rangeOfString:self.studentField.text];
        if (range.location == 0) {
            return [NSString stringWithFormat:@"%d", info.studentId];
        }
    }
    return nil;
}
- (NSInteger)getStudentId
{
    for (int i = 0; i < SharedAppDelegate.studentArray.count; i++) {
        StudentInfo* info = [SharedAppDelegate.studentArray objectAtIndex:i];
        NSRange range = [info.studentName rangeOfString:self.studentField.text];
        if (range.location == 0) {
            return info.studentId;
        }
    }
    return nil;
}
- (NSString*)getNoShowString
{
    if (self.NoShowSwitch.on)
    {
        return [NSString stringWithFormat:@"%@", @"Y"];
    }
    else
    {
        return [NSString stringWithFormat:@"%@", @"N"];
    }
    /*for (int i = 0; i < SharedAppDelegate.NoShowArray.count; i++) {
        NoShowInfo* info = [SharedAppDelegate.NoShowArray objectAtIndex:i];
        NSRange range = [info.NoShowString rangeOfString:self.NoShowField.text];
        if (range.location == 0) {
            return [NSString stringWithFormat:@"%@", info.NoShowValue];
        }
    }*/
    return nil;
}
- (BOOL *)getNoShowBool
{
    if (self.NoShowSwitch.on)
    {
        return true;
    }
    else
    {
        return false;
    }
    return nil;

}
- (void)setCellEditable:(BOOL)editable
{
    self.studentField.enabled = editable;
    self.arrawImageView.hidden = !editable;
    
    self.NoShowField.enabled=editable;
    self.NoShowDrImageView.hidden=!editable;
}
- (void)setNoShowArray:(NSMutableArray *)NoShowArrays
{
    self.NoShowSwitch.on=false;
   /* _NoShowArray = NoShowArrays;
    if (self.LoadTimesheet)
    {
        if(self.NoShowField.text==NULL)
        {
        NoShowInfo* info = [self.NoShowArray objectAtIndex:0];
        self.NoShowField.text = info.NoShowString;
        self.NoShowFieldValue=info.NoShowValue;
        }
    }
    else
    {
        NoShowInfo* info = [self.NoShowArray objectAtIndex:0];
        self.NoShowField.text = info.NoShowString;
        self.NoShowFieldValue=info.NoShowValue;
    }*/
}
- (void)setStudentArray:(NSMutableArray *)studentArrays
{
    _studentArray = studentArrays;
    if (_studentArray.count > 0) {
        NSInteger index = self.tag - 100;
        if (self.studentArray.count >= index) {
            StudentInfo* info = [self.studentArray objectAtIndex:index - 1];
            //self.studentField.text = info.studentName;
            //self.studentFieldId=info.studentId;
            if (self.LoadTimesheet)
            {
                if(self.studentField.text==NULL)
                {
                    self.studentField.text = info.studentName;
                    self.studentFieldId=info.studentId;
                }
            }
            else
            {
                self.studentField.text = info.studentName;
                self.studentFieldId=info.studentId;
                
                if(index==1)
                {
                //-----------
                NSString *strstuid = [NSString stringWithFormat:@"%d",info.studentId];
                // NSString*returnStr=
                [self TimesheetSubjectAndLocation:strstuid];
                }

                //----------
                
            }
            
        }
    }
    [self.pickerView reloadAllComponents];
}

- (void)setStudentArray:(NSMutableArray *)studentsArray autoSelect:(BOOL)autoSelect
{
    if (autoSelect) {
        [self setStudentArray:studentsArray];
    }
    else {
        _studentArray = studentsArray;
        if (_studentArray.count > 0) {
            StudentInfo* info = [self.studentArray objectAtIndex:0];
            self.studentField.text = info.studentName;
            self.studentFieldId=info.studentId;
        }
        [self.pickerView reloadAllComponents];
    }
}

- (void)setPosition:(NSInteger)position
{
    self.seperatorView.hidden = NO;
    switch (position) {
        case 0:
            self.bgImageView.frame = CGRectMake(kDefaultOriginX, 0, kDefaultWidth, 44);
            self.seperatorView.hidden = YES;
            break;
        case 1:
        {
            
            self.bgImageView.frame = CGRectMake(kDefaultOriginX, 0, kDefaultWidth, 44);;
            
            break;
        }
        case 2:
        {
            self.bgImageView.frame = CGRectMake(kDefaultOriginX, 0, kDefaultWidth, 44);
           
            break;
        }
        case 3:
        {
            self.bgImageView.frame = CGRectMake(kDefaultOriginX, 0, kDefaultWidth, 44);
            
            self.seperatorView.hidden = YES;
            break;
        }
        default:
            break;
    }
    
    self.NoShowarrawImageView.frame=CGRectMake(kDefaultOriginX, self.NoShowarrawImageView.frame.origin.y, self.NoShowarrawImageView.frame.size.width-1.5f, self.NoShowarrawImageView.frame.size.height);
    self.NoShowarrawImageView.image = [[UIImage imageNamed:@"table_part_bottom.png"] stretchableImageWithLeftCapWidth:100 topCapHeight:20];
    
    self.secondPartView.hidden = YES;
    self.bgImageView.image = [[UIImage imageNamed:@"table_part_up.png"] stretchableImageWithLeftCapWidth:100 topCapHeight:20];
    self.seperatorView.frame = CGRectMake(kDefaultOriginX+1.5f, self.frame.size.height - 0.5f, kDefaultWidth-3, 0.5f);
    self.seperatorView.hidden=YES;
    self.studentLabel.text = @"Student";
    
    CGRect frame = self.frame;
    frame.size.height = 89;
    
    if(self.NoShowSwitch.enabled==false&&self.NoShowSwitch.on==false)
    {
        frame.size.height = 46;
        self.bgImageView.image = [[UIImage imageNamed:@"table_head.png"] stretchableImageWithLeftCapWidth:100 topCapHeight:20];
        self.NoShowarrawImageView.hidden=YES;

    }
    if ([self.studentField.text isEqualToString:@"No Student" ]) {
        frame.size.height = 46;
        self.bgImageView.image = [[UIImage imageNamed:@"table_head.png"] stretchableImageWithLeftCapWidth:100 topCapHeight:20];
        self.NoShowarrawImageView.hidden=YES;
    }
    self.frame = frame;
}

- (void)setStudentArray:(NSMutableArray *)studentsArray selectedContent:(int)content
{
    _studentArray = studentsArray;
    if (_studentArray.count > 0) {
        [self.pickerView reloadAllComponents];
        for (int i = 0; i < self.studentArray.count; i++) {
            StudentInfo* obj = [self.studentArray objectAtIndex:i];
            if (obj.studentId == content) {
                self.studentField.text = obj.studentName;
                self.studentFieldId=obj.studentId;
                NSLog(@"setStudentArraystudentField:%@", obj.studentName);
                NSLog(@"setStudentArraystudentFieldId:%d", obj.studentId);
            }
        }
    }
}

- (void)setNoShowArray:(NSMutableArray *)NoShowArray selectedContent:(NSString *) content
{
    if ([content isEqualToString:@"Y"]) {
        self.NoShowSwitch.on=true;
    }
    else if([content isEqualToString:@"N"])
    {
       self.NoShowSwitch.on=false;
    }
    /*
    _NoShowArray = NoShowArray;
    if (_NoShowArray.count > 0) {
        for (int i = 0; i < self.NoShowArray.count; i++) {
            NoShowInfo* obj = [self.NoShowArray objectAtIndex:i];
            if (obj.NoShowValue == content) {
                self.NoShowField.text = obj.NoShowString;
                self.NoShowFieldValue=obj.NoShowValue;
                NSLog(@"setNoShowArrayNoshowField:%@", obj.NoShowString);
                NSLog(@"setNoShowArrayNoshowFieldId:%@", obj.NoShowValue);
            }
        }
    }
    */
}
- (void)reloadPicker
{
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
}

- (void)reset
{
    self.passwordField.text = nil;
    self.signImageView.image = nil;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    UIImage* image = [[UIImage imageNamed:@"table_part_bottom.png"] stretchableImageWithLeftCapWidth:40 topCapHeight:20];
    self.lastPartView.image = image;
    self.studentField.inputAccessoryView = self.toolBar;
    self.studentField.inputView = self.pickerView;
    self.passwordField.inputAccessoryView = self.toolBar;
    self.NoShowField.inputAccessoryView=self.toolBar;
    self.NoShowField.inputView=self.pickerView;
}

- (IBAction)taped:(id)sender
{
    if (self.mDelegate) {
        [self.passwordField resignFirstResponder];
        [self.mDelegate signatureViewTaped:self];
    }
}

- (IBAction)doneAction:(id)sender
{
    [self pickerView:self.pickerView didSelectRow:[self.pickerView selectedRowInComponent:0] inComponent:0];
    [self.studentField resignFirstResponder];
    [self.NoShowField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    editingRow = textField.tag;
    if(editingRow == 1)
    {
               [self.pickerView reloadAllComponents];
                
    }
    else if (editingRow == 2) {
        
        if (self.NoShowArray.count == 0) {
           
            
        }
        [self.pickerView reloadAllComponents];
        if (self.NoShowField.text.length > 0) {
            for (int i = 0; i < SharedAppDelegate.NoShowArray.count; i++) {
                NoShowInfo* subject = [SharedAppDelegate.NoShowArray objectAtIndex:i];
                NSLog(@"info:%@", subject.NoShowString);
                if ([self.NoShowField.text isEqualToString:subject.NoShowString]) {
                    [self.pickerView selectRow:i inComponent:0 animated:NO];
                    break;
                }
            }
        }
        
    }
    

}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (editingRow == 1) {
        if (self.studentArray.count > 0) {
            return self.studentArray.count;
        }
        return 1;
    }
    else if (editingRow == 2) {
        if (self.NoShowArray.count > 0) {
            return self.NoShowArray.count;
        }
        return 1;
    }
    return 0;
    
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (editingRow == 1) {
        if (self.studentArray.count > 0) {
            StudentInfo* info = [self.studentArray objectAtIndex:row];
            return info.studentName;
        }
    }
    else if (editingRow == 2) {
        if (self.NoShowArray.count > 0) {
            NoShowInfo* info = [self.NoShowArray objectAtIndex:row];
            return info.NoShowString;
        }
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //NSLog(@"editingRow:%d", editingRow);
    //NSLog(@"didSelectRow:%d", row);

    if (editingRow == 1) {
        if(self.studentArray.count>0)
        {
            StudentInfo* info = [self.studentArray objectAtIndex:row];
            //若为第一个学生则默认subject和location
            if (self.tag==101)
            {
                NSString *strstuid = [NSString stringWithFormat:@"%d",info.studentId];
                [self TimesheetSubjectAndLocation:strstuid];
            }
            

            if (![self.studentField.text isEqualToString:info.studentName] && self.studentFieldId!=info.studentId)
            {
               

                self.studentField.text = info.studentName;
                self.studentFieldId=info.studentId;
                if (self.mDelegate && self.studentField.text.length > 0)
                {
                    [self.mDelegate signatureView:self studentSelected:self.studentField.text studentId:self.studentFieldId];
                }
                
            }
        }
    }
    else if (editingRow == 2)
    {
        if(self.NoShowArray.count>0)
        {
            NoShowInfo* info = [self.NoShowArray objectAtIndex:row];
            //NSLog(@"self.NoShowField.text:%@",info.NoShowString);
            if ([info.NoShowValue isEqualToString:@"Y"])
            {
                self.NoShowSwitch.on=true;
            }
            else
            {
                self.NoShowSwitch.on=false;
            }
            //self.NoShowField.text = info.NoShowString;
            //self.NoShowFieldValue = info.NoShowValue;
            [self.mDelegate NoShowXY];
        }
        
        
    }
    
}
- (IBAction)IBActionNoShowSwitch:(id)sender {
    [self.mDelegate NoShowXY];
}

- (void)TimesheetSubjectAndLocation:(NSString *)stuid
{
    __block NSString *returnStrr=@"";
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.role,@"role",
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            stuid, @"stuid",nil];
    NSMutableURLRequest *request = [client requestWithFunction:GetTimesheetSunjectAndLocation parameters:params];
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         
         TimeSheetSubjectAndLoction *timesheetsubjectandlocation = [TimeSheetSubjectAndLoction timeSheetSubjectAndLoctionWithDDXMLDocument:XMLDocument];
         
         returnStrr=timesheetsubjectandlocation.returnStr;
         if (returnStrr != nil && returnStrr != NULL &&![returnStrr isEqualToString:@""]) {
         
         NSArray *arry=[returnStrr componentsSeparatedByString:@"|"];

             [self.mDelegate setSubjectAndLocation:arry[0] location: arry[1]];
         }

         
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         
     }];
    [operation start];
    
    }

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.passwordField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    return [textField resignFirstResponder];
}

@end
