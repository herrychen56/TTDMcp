//
//  StudentListViewController.m
//  TTD
//
//  Created by Jeff Tang on 8/24/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import "StudentListViewController.h"
#import "URL.h"
#import "DataModel.h"
#import "Photo.h"
#import "AcademicViewController.h"
#import "StudentMainViewController.h"

@interface StudentListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *studentsTableView;
@end

@implementation StudentListViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.studentsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"studentListCell"];
    self.studentsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if ([SharedAppDelegate.role isEqualToString:@"parent"]) {
        [self loadStudentsByParent];
    } else if([SharedAppDelegate.role isEqualToString:@"consultant"] || [SharedAppDelegate.role isEqualToString:@"manager"]) {
        [self loadStudentsByConsultantOrManager];
    }

}

- (void)loadStudentsByConsultantOrManager {
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            SharedAppDelegate.role, @"role",
                            
                            // for demo only; TODO: replace with the commented lines above after consultant has more students to show.
//                            @"testmanager", @"username",
//                            SharedAppDelegate.password, @"password",
//                            @"manager", @"role",
                            
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_VIEWSTUDENTS parameters:params];
    __weak typeof(self) wself = self;
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
             self.studentArray = [ManagerViewStudents managerViewStudentsWithDDXMLDocument:XMLDocument];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [wself.studentsTableView reloadData];             
//                 NSString *savedStudentID = [[NSUserDefaults standardUserDefaults] stringForKey:SELECTED_STUDENT_ID];
//                 int i = 0;
//                 for (ManagerViewStudents *student in self.studentArray) {
//                     if ([student.stu_id isEqualToString:savedStudentID]) {
//                         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:i];
//                         [wself.studentsTableView selectRowAtIndexPath:indexPath
//                                                              animated:YES
//                                                        scrollPosition:UITableViewScrollPositionNone];
//                         [self tableView:wself.studentsTableView didSelectRowAtIndexPath:indexPath];
//                         break;
//                     }
//                     i++;
//                 }
                 
                 [self hiddenHUD];
                 
             });
         });
     }                                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         NSLog(@"error:%@", error);
         [self showAlertWithTitle:nil andMessage:@"No Network"];
     }];
    [operation start];
    [self showHUD];
}

- (void)loadStudentsByParent
{
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            nil];
    NSMutableURLRequest *request = [client requestWithFunction:Func_STUDENTBY_PARENT parameters:params];
    __weak typeof(self) wself = self;
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
             self.studentArray =[SelectStudentByParent  selectStudentByParentWithDDXMLDocument:XMLDocument];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [wself.studentsTableView reloadData];
                 [self hiddenHUD];
                 
             });
         });
     }                                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         NSLog(@"error:%@", error);
         [self showAlertWithTitle:nil andMessage:@"No Network"];
     }];
    [operation start];
    [self showHUD];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Students";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.studentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"studentListCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([SharedAppDelegate.role isEqualToString:@"parent"]) {
        SelectStudentByParent *student = [self.studentArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",student.firstName, student.lastName];
        cell.detailTextLabel.text = student.studentId;
    } else if ([SharedAppDelegate.role isEqualToString:@"consultant"] || [SharedAppDelegate.role isEqualToString:@"manager"]) {
        ManagerViewStudents *student = [self.studentArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",student.studentname];
        cell.detailTextLabel.text = student.stu_id;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // show the Academic EA info of the student

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StudentDetail *studentDetail = [StudentDetail new];
    if ([SharedAppDelegate.role isEqualToString:@"parent"]) {
        SelectStudentByParent *student = [self.studentArray objectAtIndex:indexPath.row];
        studentDetail.stu_id = student.studentId;
        [[NSUserDefaults standardUserDefaults] setValue:student.studentId forKey:SELECTED_STUDENT_ID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //这里处理跳转
    else if ([SharedAppDelegate.role isEqualToString:@"consultant"] || [SharedAppDelegate.role isEqualToString:@"manager"]) {
        ManagerViewStudents *student = [self.studentArray objectAtIndex:indexPath.row];
        studentDetail.stu_id = student.stu_id;
        [[NSUserDefaults standardUserDefaults] setValue:student.stu_id forKey:SELECTED_STUDENT_ID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        StudentMainViewController * stumain = [[StudentMainViewController alloc]init];
        stumain.userIDs = student.stu_id;
       
        return  [self.navigationController pushViewController:stumain animated:YES];
    }
    
    
    if ([self.currentTab isEqualToString:@"Academic"]) {
        AcademicViewController *vc = [[AcademicViewController alloc] init];
        vc.navigationItem.titleView = nil;
        
        if ([SharedAppDelegate.role isEqualToString:@"parent"]) {
            SelectStudentByParent *student = [self.studentArray objectAtIndex:indexPath.row];
            vc.navigationItem.title = [NSString stringWithFormat:@"%@ %@ (%@)", student.firstName, student.lastName, student.studentId];
            vc.selectRow_StudentId=student.studentId;
        }else if ([SharedAppDelegate.role isEqualToString:@"student"]) {
            vc.selectRow_StudentId=0;
        }
        else if ([SharedAppDelegate.role isEqualToString:@"consultant"] || [SharedAppDelegate.role isEqualToString:@"manager"]) {
            ManagerViewStudents *student = [self.studentArray objectAtIndex:indexPath.row];
            vc.navigationItem.title = [NSString stringWithFormat:@"%@ (%@)", student.studentname, student.stu_id];
            vc.selectRow_StudentId=student.stu_id;
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        DocumentsViewController *vc = [DocumentsViewController new];
        vc.studentDetail = studentDetail;
        vc.navigationItem.titleView = nil;
        if ([SharedAppDelegate.role isEqualToString:@"parent"]) {
            SelectStudentByParent *student = [self.studentArray objectAtIndex:indexPath.row];
            vc.title = [NSString stringWithFormat:@"%@ %@ (%@)", student.firstName, student.lastName, student.studentId];
        }
        else if ([SharedAppDelegate.role isEqualToString:@"consultant"] || [SharedAppDelegate.role isEqualToString:@"manager"]) {
            ManagerViewStudents *student = [self.studentArray objectAtIndex:indexPath.row];
            vc.title = [NSString stringWithFormat:@"%@ (%@)", student.studentname, student.stu_id];
            vc.selectRow_StudentId=student.stu_id;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
