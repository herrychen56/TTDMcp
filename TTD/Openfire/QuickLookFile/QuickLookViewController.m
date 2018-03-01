//
//  QuickLookViewController.m
//  TTD
//
//  Created by andy on 14-4-29.
//  Copyright (c) 2014年 totem. All rights reserved.
//

#import "QuickLookViewController.h"
#import "AppDelegate.h"
#import "BCTabBarController.h"
@interface QuickLookViewController ()
@property(nonatomic,strong)NSMutableArray *dirArray;

@end

@implementation QuickLookViewController
@synthesize quickTableView;

@synthesize docInteractionController;
@synthesize docPath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    quickTableView.delegate=self;
    NSFileManager *fileManager = [NSFileManager defaultManager];

    
    NSString *documentDir =self.docPath;
	NSError *error = nil;
	NSArray *fileList = [[NSArray alloc] init];
	//fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
	fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
	
	//    以下这段代码则可以列出给定一个文件夹里的所有子文件夹名
	//	NSLog(@"------------------------%@",fileList);
    
    
	self.dirArray = [[NSMutableArray alloc] init];
	for (NSString *file in fileList)
	{

		[self.dirArray addObject:file];

	}
    NSLog(@"Every Thing in the dir:%@",fileList);
	
	
	
	[quickTableView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    if (self.docInteractionController == nil)
    {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
    }
    else
    {
        self.docInteractionController.URL = url;
    }
}
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGesture
{
    if (longPressGesture.state == UIGestureRecognizerStateBegan)
    {
        NSIndexPath *cellIndexPath = [quickTableView indexPathForRowAtPoint:[longPressGesture locationInView:quickTableView]];
		
		NSURL *fileURL;
		if (cellIndexPath.section == 0)
        {
            // for section 0, we preview the docs built into our app
            fileURL = [self.dirArray objectAtIndex:cellIndexPath.row];
		}
        else
        {
            // for secton 1, we preview the docs found in the Documents folder
            fileURL = [self.dirArray objectAtIndex:cellIndexPath.row];
		}
        self.docInteractionController.URL = fileURL;
		
		[self.docInteractionController presentOptionsMenuFromRect:longPressGesture.view.frame
                                                           inView:longPressGesture.view
                                                         animated:YES];
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellName = @"CellName";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellName];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellName];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	NSURL *fileURL= nil;
//	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentDir = [documentPaths objectAtIndex:0];
    NSString *documentDir = self.docPath;
	NSString *path = [documentDir stringByAppendingPathComponent:[self.dirArray objectAtIndex:indexPath.row]];
	fileURL = [NSURL fileURLWithPath:path];
	
	[self setupDocumentControllerWithURL:fileURL];
	cell.textLabel.text = [self.dirArray objectAtIndex:indexPath.row];
	NSInteger iconCount = [self.docInteractionController.icons count];
    if (iconCount > 0)
    {
        cell.imageView.image = [self.docInteractionController.icons objectAtIndex:iconCount - 1];
    }
    
    NSString *fileURLString = [self.docInteractionController.URL path];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileURLString error:nil];
    NSInteger fileSize = [[fileAttributes objectForKey:NSFileSize] intValue];
    NSString *fileSizeStr = [NSByteCountFormatter stringFromByteCount:fileSize
                                                           countStyle:NSByteCountFormatterCountStyleFile];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", fileSizeStr, self.docInteractionController.UTI];
	UILongPressGestureRecognizer *longPressGesture =
	[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [cell.imageView addGestureRecognizer:longPressGesture];
    cell.imageView.userInteractionEnabled = YES;    // this is by default NO, so we need to turn it on
    
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
  	return [self.dirArray count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.delegate = self;
    
    // start previewing the document at the current section index
    previewController.currentPreviewItemIndex = indexPath.row;
   

    [[self navigationController] pushViewController:previewController animated:YES];
    //	[self presentViewController:previewController animated:YES completion:nil];
}



#pragma mark - UIDocumentInteractionControllerDelegate

- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}


#pragma mark - QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    //    NSInteger numToPreview = 0;
    //
    //	numToPreview = [self.dirArray count];
    //
    //    return numToPreview;
    
	return [self.dirArray count];
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BCTabBarController *tab =  (BCTabBarController *)app.window.rootViewController.presentedViewController;
    tab.tabBar.hidden = NO;;
    
  //  controller.navigationController.navigationBarHidden=YES;
  //  [self.navigationController setWantsFullScreenLayout:NO];
   // [self.navigationController setToolbarHidden:YES];
   // [self.navigationController setPreferredContentSize:CGSizeMake(320, 480)];
    [self.navigationController setNavigationBarHidden:YES];
  
    //self.navigationController.prefersStatusBarHidden=YES;
    // if the preview dismissed (done button touched), use this method to post-process previews
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    if([[[UIDevice currentDevice]systemVersion]floatValue]<7.0)
    {
        [self.navigationController setToolbarHidden:YES];
    }

    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BCTabBarController *tab =  (BCTabBarController *)app.window.rootViewController.presentedViewController;
    tab.tabBar.hidden = YES;
    
    
       [self.navigationController setNavigationBarHidden:NO];
	   
    NSURL *fileURL = nil;
    NSIndexPath *selectedIndexPath = [quickTableView indexPathForSelectedRow];
//	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentDir = [documentPaths objectAtIndex:0];
    NSString *documentDir = self.docPath;
	NSString *path = [documentDir stringByAppendingPathComponent:[self.dirArray objectAtIndex:selectedIndexPath.row]];
	fileURL = [NSURL fileURLWithPath:path];
    return fileURL;
}



- (IBAction)btnBack:(id)sender {
    
     [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];

    
}
@end
