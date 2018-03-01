//
//  MessageUserListViewController.h
//  TTD
//
//  Created by andy on 13-10-11.
//  Copyright (c) 2013年 totem. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
@interface MessageUserListViewController : BaseViewController <UITabBarControllerDelegate,UITableViewDataSource,KKChatDelegate>
{
    BOOL shouldReload;

}
//Scroll By Andy
- (id)initWithSectionIndexes:(BOOL)showSectionIndexes;

- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated; // Implemented by the subclasses
@property(nonatomic, assign, readonly) BOOL showSectionIndexes;
@property(nonatomic, assign, readonly) BOOL showGroup;
@property(nonatomic, strong, readonly) UISearchBar *searchBar;

// Scroll End

- (IBAction)btnSignOut:(id)sender;
@property (nonatomic,strong, readonly) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *signOut;
@property (weak, nonatomic) IBOutlet UILabel *newtitlab;

@property (weak, nonatomic) IBOutlet UIButton *newbut;




@end
