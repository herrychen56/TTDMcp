//
//  TTDAwardsAndHonors.m
//  TTD
//
//  Created by Mark Hao on 8/21/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import "TTDAwardsAndHonors.h"

@implementation TTDAwardsAndHonors

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"studentID" : @"studentID",
             @"awardType": @"awardType",
             @"yearReceived": @"yearReceived",
             @"awardDescription": @"awardDescription",
             @"awardID": @"awardID",
             @"awardImportanceID": @"awardImportanceID",
             @"description1": @"description1",
             @"awardOrder": @"awardorder",
             @"isStuAdd": @"isstuAdd",
             @"awardImportanceDescription": @"awardImportanceDescription"
             };
}

@end
