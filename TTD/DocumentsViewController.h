//
//  DocumentsViewController.h
//  TTD
//
//  Created by Mark Hao on 8/15/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import "BaseViewController.h"

@interface DocumentsViewController : BaseViewController

@property (strong, nonatomic) StudentDetail *studentDetail;
@property (strong, nonatomic) NSString* selectRow_StudentId;

@property (weak, nonatomic) IBOutlet UIButton *AddButton;

@end
