//
//  QuickLookViewController.h
//  TTD
//
//  Created by andy on 14-4-29.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
@interface QuickLookViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate,
UIDocumentInteractionControllerDelegate>
- (IBAction)btnBack:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *quickTableView;

@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;
@property(nonatomic,retain)NSString *docPath;
@end
