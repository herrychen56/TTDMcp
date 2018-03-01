//
//  TTDVolunteerCommunity.h
//  TTD
//
//  Created by Mark Hao on 8/21/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface TTDVolunteerCommunity : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *activityId;
@property (nonatomic, strong) NSNumber *studentId;
@property (nonatomic, strong) NSString *eaName;
@property (nonatomic, strong) NSString *eaType;
@property (nonatomic, strong) NSNumber *hoursPerWeek;
@property (nonatomic, strong) NSNumber *weeksPerYear;
@property (nonatomic, strong) NSNumber *numberOfYears;
@property (nonatomic, strong) NSNumber *totalHours;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSNumber *grade9EA;
@property (nonatomic, strong) NSNumber *grade10EA;
@property (nonatomic, strong) NSNumber *grade11EA;
@property (nonatomic, strong) NSNumber *grade12EA;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSNumber *planned;
@property (nonatomic, strong) NSNumber *eaCategoryID;
@property (nonatomic, strong) NSNumber *rank;
@property (nonatomic, strong) NSNumber *volunteer;
@property (nonatomic, strong) NSString *prepDescription;
@property (nonatomic, strong) NSNumber *isStuAdd;
@property (nonatomic, strong) NSNumber *gradeC1EA;
@property (nonatomic, strong) NSNumber *gradeC2EA;
@property (nonatomic, strong) NSNumber *gradeC3EA;
@property (nonatomic, strong) NSString *leadership;
@property (nonatomic, strong) NSString *plannedStr;
@property (nonatomic, strong) NSNumber *eaOrder;
@property (nonatomic, strong) NSNumber *startDate;
@property (nonatomic, strong) NSNumber *endDate;
@property (nonatomic, strong) NSString *grades;
@property (nonatomic, strong) NSString *leadershipName;

@end
