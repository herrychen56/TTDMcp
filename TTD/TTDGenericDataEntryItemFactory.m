//
//  TTDGenericDataEntryItemFactory.m
//  TTD
//
//  Created by Yu Qi Hao on 8/22/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import "TTDGenericDataEntryItemFactory.h"


@implementation TTDGenericDataEntryItemFactory

+ (TTDGenericDataEntryItemFactory *)sharedInstance
{
    static TTDGenericDataEntryItemFactory *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [TTDGenericDataEntryItemFactory new];
    });
    return _sharedInstance;
}


+ (NSMutableArray *)awardsAndHonorsDataEntryGroupWithInfo:(TTDAwardsAndHonors *)ahInfo
{
    
    NSMutableArray *groups = [NSMutableArray new];
    
    TTDGenericDataEntryGroup *group = [TTDGenericDataEntryGroup new];
    group.groupTitle = @"Award & Honor Info";
    
    TTDGenericDataEntryItem *item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeString;
    item.dataTitle = @"Description";
    item.defaultValue = [self trimString:ahInfo.awardDescription];
    [group addDataEntryItem:item];
    
    item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeString;
    item.dataTitle = @"Id";
    item.defaultValue = [ahInfo.awardID stringValue];
    [group addDataEntryItem:item];
    
    item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeString;
    item.dataTitle = @"Type";
    item.defaultValue = [self trimString:ahInfo.awardType];
    [group addDataEntryItem:item];
    
    [groups addObject:group];
    
    group = [TTDGenericDataEntryGroup new];
    group.groupTitle = @"Award & Honor Detail";
    
    item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeString;
    item.dataTitle = @"Year Received";
    item.defaultValue = [ahInfo.yearReceived stringValue];
    [group addDataEntryItem:item];
    
    item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeLongString;
    item.defaultValue = [self trimString:ahInfo.description1];
    [group addDataEntryItem:item];
    
    [groups addObject:group];
    
    return groups;
    
}

+ (NSMutableArray *)extraCurricularDataEntryGroupWithInfo:(TTDExtracurricular *)ecInfo
{
    
    NSMutableArray *groups = [NSMutableArray new];
    
    TTDGenericDataEntryGroup *group = [TTDGenericDataEntryGroup new];
    group.groupTitle = @"Extra Curricular Info";
    
    TTDGenericDataEntryItem *item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeString;
    item.dataTitle = @"Name";
    item.defaultValue = [self trimString:ecInfo.eaName];
    [group addDataEntryItem:item];
    
    item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeString;
    item.dataTitle = @"Id";
    item.defaultValue = [ecInfo.activityId stringValue];
    [group addDataEntryItem:item];
    
    item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeString;
    item.dataTitle = @"Position";
    item.defaultValue = [self trimString:ecInfo.position];
    [group addDataEntryItem:item];
    
    item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeLongString;
    item.defaultValue = [self trimString:ecInfo.prepDescription];
    [group addDataEntryItem:item];
    
    [groups addObject:group];
    
    return groups;
    
}

+ (NSMutableArray *)educationalPrepDataEntryGroupWithInfo:(TTDEducationalPrep *)epInfo
{
    
    NSMutableArray *groups = [NSMutableArray new];
    
    TTDGenericDataEntryGroup *group = [TTDGenericDataEntryGroup new];
    group.groupTitle = @"Educational Preparation Info";
    
    TTDGenericDataEntryItem *item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeString;
    item.dataTitle = @"Name";
    item.defaultValue = [self trimString:epInfo.eaName];
    [group addDataEntryItem:item];
    
    item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeString;
    item.dataTitle = @"Id";
    item.defaultValue = [epInfo.activityId stringValue];
    [group addDataEntryItem:item];
    
    item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeString;
    item.dataTitle = @"Position";
    item.defaultValue = [self trimString:epInfo.position];
    [group addDataEntryItem:item];
    
    item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeLongString;
    item.defaultValue = [self trimString:epInfo.prepDescription];
    [group addDataEntryItem:item];
    
    [groups addObject:group];
    
    return groups;
    
}

+ (NSMutableArray *)courseworkOtherDataEntryGroupWithInfo:(TTDCourseworkOther *)coInfo
{
    
    NSMutableArray *groups = [NSMutableArray new];
    
    TTDGenericDataEntryGroup *group = [TTDGenericDataEntryGroup new];
    group.groupTitle = @"Other Course Work Info";
    
    TTDGenericDataEntryItem *item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeString;
    item.dataTitle = @"Name";
    item.defaultValue = [self trimString:coInfo.eaName];
    [group addDataEntryItem:item];
    
    item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeString;
    item.dataTitle = @"Id";
    item.defaultValue = [coInfo.activityId stringValue];
    [group addDataEntryItem:item];
    
    item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeString;
    item.dataTitle = @"Position";
    item.defaultValue = [self trimString:coInfo.position];
    [group addDataEntryItem:item];
    
    item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeLongString;
    item.defaultValue = [self trimString:coInfo.prepDescription];
    [group addDataEntryItem:item];
    
    [groups addObject:group];
    
    return groups;
    
}

+ (NSMutableArray *)volunteerCommunityDataEntryGroupWithInfo:(TTDVolunteerCommunity *)vcInfo
{
    
    NSMutableArray *groups = [NSMutableArray new];
    
    TTDGenericDataEntryGroup *group = [TTDGenericDataEntryGroup new];
    group.groupTitle = @"Volunteer Community Info";
    
    TTDGenericDataEntryItem *item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeString;
    item.dataTitle = @"Name";
    item.defaultValue = [self trimString:vcInfo.eaName];
    [group addDataEntryItem:item];
    
    item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeString;
    item.dataTitle = @"Id";
    item.defaultValue = [vcInfo.activityId stringValue];
    [group addDataEntryItem:item];
    
    item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeString;
    item.dataTitle = @"Position";
    item.defaultValue = [self trimString:vcInfo.position];
    [group addDataEntryItem:item];
    
    item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeLongString;
    item.defaultValue = [self trimString:vcInfo.prepDescription];
    [group addDataEntryItem:item];
    
    [groups addObject:group];
    
    return groups;
    
}

+ (NSMutableArray *)workExperienceDataEntryGroupWithInfo:(TTDWorkExperience *)weInfo
{
    
    NSMutableArray *groups = [NSMutableArray new];
    
    TTDGenericDataEntryGroup *group = [TTDGenericDataEntryGroup new];
    group.groupTitle = @"Work Experience Info";
    
    TTDGenericDataEntryItem *item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeString;
    item.dataTitle = @"Name";
    item.defaultValue = [self trimString:weInfo.eaName];
    [group addDataEntryItem:item];
    
    item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeString;
    item.dataTitle = @"Id";
    item.defaultValue = [weInfo.activityId stringValue];
    [group addDataEntryItem:item];
    
    item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeString;
    item.dataTitle = @"Position";
    item.defaultValue = [self trimString:weInfo.position];
    [group addDataEntryItem:item];
    
    item = [TTDGenericDataEntryItem new];
    item.dataType = TTDGenericDataEntryDataTypeLongString;
    item.defaultValue = [self trimString:weInfo.prepDescription];
    [group addDataEntryItem:item];
    
    [groups addObject:group];
    
    return groups;
    
}

+ (NSString *)trimString: (NSString *)str {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


@end


@implementation TTDGenericDataEntryItem

- (NSString *)valueDisplayText
{
    switch (self.dataType) {
        case TTDGenericDataEntryDataTypeLongString:
            return self.result;
            break;
        case TTDGenericDataEntryDataTypeNumber:
            return [[TTDGenericDataEntryItem defaultNumberFormatter] stringFromNumber:self.result];
            break;
        case TTDGenericDataEntryDataTypeString:
            return self.result;
            break;
        case TTDGenericDataEntryDataTypeUnknown:
        default:
            return nil;
            break;
    }
}

- (void)setDefaultValue:(id)defaultValue
{
    if (_defaultValue != defaultValue) {
        _defaultValue = defaultValue;
        
        if (defaultValue) {
            self.result = defaultValue;
        }
    }
}


+ (NSNumberFormatter *)defaultNumberFormatter
{
    static NSNumberFormatter *_numberFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _numberFormatter = [NSNumberFormatter new];
        _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    });
    return _numberFormatter;
}
@end


@interface TTDGenericDataEntryGroup ()

@property (nonatomic, strong) NSMutableArray *entryItems;

@end

@implementation TTDGenericDataEntryGroup

- (NSMutableArray *)entryItems
{
    if (!_entryItems) {
        _entryItems = [NSMutableArray new];
    }
    return _entryItems;
}

- (void)addDataEntryItem:(TTDGenericDataEntryItem *)item
{
    [self.entryItems addObject:item];
}

@end
