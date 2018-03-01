//
//  AcademicViewController.m
//  TTD
//
//  Created by Mark Hao on 8/16/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import "AcademicViewController.h"
#import "AcademicTableViewCell.h"
#import "TTDEA.h"
#import "TTDEducationalPrep.h"
#import "TTDVolunteerCommunity.h"
#import "TTDExtracurricular.h"
#import "TTDCourseworkOther.h"
#import "TTDAwardsAndHonors.h"
#import "TTDWorkExperience.h"
#import "AwardsAndHonorsDetailViewController.h"
#import "ExtraCurriculaDetailViewController.h"
#import "EducationalPrepDetailViewController.h"
#import "CourseworkOtherDetailViewController.h"
#import "WorkExperienceDetailViewController.h"
#import "VolunteerCommunityDetailViewController.h"

@interface AcademicViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *eaTableView;
@property (strong, nonatomic) TTDEA *ea;

@end

@implementation AcademicViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getEAInfo];

    self.eaTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.eaTableView registerNib:[UINib nibWithNibName:NSStringFromClass([AcademicTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AcademicTableViewCell class])];
}

- (void) getEAInfo {
    
    if([SharedAppDelegate.role isEqualToString:@"student"]) {
        self.selectRow_StudentId=[[NSString alloc] init];
        self.selectRow_StudentId=@"0";
    }
    
    NSURL *url = [NSURL URLWithString:@"https://consulting.ttlhome.com/WebService/StudentInfo.asmx"];
    
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            SharedAppDelegate.username, @"username",
                            SharedAppDelegate.password, @"password",
                            self.selectRow_StudentId, @"studentId",nil];
    NSMutableURLRequest *request = [client requestWithFunction:FUNC_GET_EAS_ALL parameters:params];
    
    __weak typeof(self) wself = self;
    AFKissXMLRequestOperation *operation =
    [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:(NSURLRequest *)request
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, DDXMLDocument *XMLDocument)
     {
         NSDictionary *jsonDictionary = [TTDEA easWithDDXMLDocument:XMLDocument];
         NSError *error;
         TTDEA *ea = [MTLJSONAdapter modelOfClass:[TTDEA class] fromJSONDictionary:jsonDictionary error:&error];
         
         if (error != nil) {
             NSLog(@"Error parsing documents: %@", error.localizedDescription);
         } else {
             wself.ea = ea; //parsedDictionary;
             dispatch_async(dispatch_get_main_queue(), ^{
                 [wself.eaTableView reloadData];
             });
         }
         [self hiddenHUD];
         
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, DDXMLDocument *XMLDocument)
     {
         [self hiddenHUD];
         [self showAlertWithTitle:nil andMessage:@"No Network"];
     }];
    [operation start];
    [self showHUD];
    [self showLoadingViewWithMessage:@"Loading EA Info..."];
}

#pragma mark - UITableView Delegate & Data Source

/* -------- EA ORDER ----------

 1. Educational Prep List
 2. Work Experience List
 3. Volunteer Community List
 4. Awards and Honors List
 5. Course Work List
 6. Extra Curricular List
 
  ---------- END --------------- */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.ea ? 6 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return self.ea.educationalPrepList.count;
            break;
        case 1:
            return self.ea.workExperienceList.count;
            break;
        case 2:
            return self.ea.volunteerCommunityList.count;
            break;
        case 3:
            return self.ea.awardsAndHonorsList.count;
            break;
        case 4:
            return self.ea.courseworkOtherList.count;
            break;
        case 5:
            return self.ea.extracurricularList.count;
            break;
        default:
            return 0;
            break;
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Educational Preparation";
            break;
        case 1:
            return @"Work Experience";
            break;
        case 2:
            return @"Volunteer Communities";
            break;
        case 3:
            return @"Awards and Honors";
            break;
        case 4:
            return @"Course Works";
            break;
        case 5:
            return @"Extra Curricular";
            break;
        default:
            return nil;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AcademicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AcademicTableViewCell class]) forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
        {
            TTDEducationalPrep *ep = [self.ea.educationalPrepList objectAtIndex:indexPath.row];
            cell.titleLabel.text = [self trimString:ep.eaName];
            return cell;
        }
            break;
        case 1:
        {
            TTDWorkExperience *we = [self.ea.workExperienceList objectAtIndex:indexPath.row];
            cell.titleLabel.text = [self trimString:we.eaName];
            return cell;
        }
            break;
        case 2:
        {
            TTDVolunteerCommunity *vc = [self.ea.volunteerCommunityList objectAtIndex:indexPath.row];
            cell.titleLabel.text = [self trimString:vc.eaName];
            return cell;
        }
            break;
        case 3:
        {
            TTDAwardsAndHonors *ah = [self.ea.awardsAndHonorsList objectAtIndex:indexPath.row];
            cell.titleLabel.text = [self trimString:ah.awardDescription];
            return cell;
        }
            break;
        case 4:
        {
            TTDCourseworkOther *co = [self.ea.courseworkOtherList objectAtIndex:indexPath.row];
            cell.titleLabel.text = [self trimString:co.eaName];
            return cell;
        }
            break;
        case 5:
        {
            TTDExtracurricular *ec = [self.ea.extracurricularList objectAtIndex:indexPath.row];
            cell.titleLabel.text = [self trimString:ec.eaName];
            return cell;
        }
            break;
        default:
            return cell;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            TTDEducationalPrep *ep = [self.ea.educationalPrepList objectAtIndex:indexPath.row];
            EducationalPrepDetailViewController *detailVC = [EducationalPrepDetailViewController new];
            detailVC.ep = ep;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        case 1:
        {
            TTDWorkExperience *we = [self.ea.workExperienceList objectAtIndex:indexPath.row];
            WorkExperienceDetailViewController *detailVC = [WorkExperienceDetailViewController new];
            detailVC.we = we;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        case 2:
        {
            TTDVolunteerCommunity *vc = [self.ea.volunteerCommunityList objectAtIndex:indexPath.row];
            VolunteerCommunityDetailViewController *detailVC = [VolunteerCommunityDetailViewController new];
            detailVC.vc = vc;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        case 3:
        {
            TTDAwardsAndHonors *ah = [self.ea.awardsAndHonorsList objectAtIndex:indexPath.row];
            AwardsAndHonorsDetailViewController *detailVC = [AwardsAndHonorsDetailViewController new];
            detailVC.ah = ah;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        case 4:
        {
            TTDCourseworkOther *co = [self.ea.courseworkOtherList objectAtIndex:indexPath.row];
            CourseworkOtherDetailViewController *detailVC = [CourseworkOtherDetailViewController new];
            detailVC.co = co;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        case 5:
        {
            TTDExtracurricular *ec = [self.ea.extracurricularList objectAtIndex:indexPath.row];
            ExtraCurriculaDetailViewController *detailVC = [ExtraCurriculaDetailViewController new];
            detailVC.ec = ec;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        default:
            break;
    }
}


- (NSString *)trimString: (NSString *)str {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
