//
//  TTDGenericDataEntryItemFactory.h
//  TTD
//
//  Created by Yu Qi Hao on 8/22/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTDAwardsAndHonors.h"
#import "TTDExtracurricular.h"
#import "TTDEducationalPrep.h"
#import "TTDVolunteerCommunity.h"
#import "TTDCourseworkOther.h"
#import "TTDWorkExperience.h"

typedef enum : NSUInteger {
    TTDGenericDataEntryDataTypeUnknown,
    TTDGenericDataEntryDataTypeString,
    TTDGenericDataEntryDataTypeLongString,
    TTDGenericDataEntryDataTypeNumber
} TTDGenericDataEntryDataType;

@interface TTDGenericDataEntryItem : NSObject

@property (nonatomic, strong) NSString *dataKeyPath;

@property (nonatomic) TTDGenericDataEntryDataType dataType;
@property (nonatomic, strong) NSString *dataTitle;
@property (nonatomic, strong) NSString *placeholderText;

@property (nonatomic, strong) id defaultValue;
@property (nonatomic, strong) id result;

@property (nonatomic, readonly) NSString *valueDisplayText;

@end

@interface TTDGenericDataEntryGroup : NSObject

@property (nonatomic, strong) NSString *groupTitle;
@property (nonatomic, readonly) NSMutableArray *entryItems;

- (void)addDataEntryItem:(TTDGenericDataEntryItem *)item;

@end

@interface TTDGenericDataEntryItemFactory : NSObject

+ (TTDGenericDataEntryItemFactory *)sharedInstance;

+ (NSMutableArray *)awardsAndHonorsDataEntryGroupWithInfo:(TTDAwardsAndHonors *)ahInfo;
+ (NSMutableArray *)educationalPrepDataEntryGroupWithInfo:(TTDEducationalPrep *)epInfo;
+ (NSMutableArray *)extraCurricularDataEntryGroupWithInfo:(TTDExtracurricular *)ecInfo;
+ (NSMutableArray *)workExperienceDataEntryGroupWithInfo:(TTDWorkExperience *)weInfo;
+ (NSMutableArray *)volunteerCommunityDataEntryGroupWithInfo:(TTDVolunteerCommunity *)vcInfo;
+ (NSMutableArray *)courseworkOtherDataEntryGroupWithInfo:(TTDCourseworkOther *)coInfo;

@end
