//
//  TTDEA.m
//  TTD
//
//  Created by Jeff Tang on 8/18/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import "TTDEA.h"
#import "TTDWorkExperience.h"
#import "TTDAwardsAndHonors.h"
#import "TTDCourseworkOther.h"
#import "TTDEducationalPrep.h"
#import "TTDExtracurricular.h"
#import "TTDVolunteerCommunity.h"

@implementation TTDEA

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"courseworkOtherList" : @"CourseworkOtherList",
             @"educationalPrepList" : @"EducationalPrepList",
             @"volunteerCommunityList" : @"VolunteerCommunityList",
             @"workExperienceList" : @"WorkExperienceList",
             @"awardsAndHonorsList" : @"AwardsAndHonorsList",
             @"extracurricularList" : @"ExtracurricularList"             };
}

+ (NSDictionary *)easWithDDXMLDocument:(DDXMLDocument*)ea
{
    DDXMLElement* rootElement = [ea rootElement];
    if (!rootElement) {
        return nil;
    }
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return nil;
    }
    DDXMLElement* bodyElement = [enveElement elementForName:@"GetEAsAllResponse"];
    if (!bodyElement) {
        return nil;
    }
    DDXMLElement* resultElement = [bodyElement elementForName:@"GetEAsAllResult"];
    if (!resultElement) {
        return nil;
    }
    NSString *jsonString = [resultElement stringValue];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    return jsonDictionary;
}

+ (NSValueTransformer *)educationalPrepListJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[TTDEducationalPrep class]];
}

+ (NSValueTransformer *)awardsAndHonorsListJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[TTDAwardsAndHonors class]];
}

+ (NSValueTransformer *)extracurricularListJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[TTDExtracurricular class]];
}

+ (NSValueTransformer *)volunteerCommunityListJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[TTDVolunteerCommunity class]];
}

+ (NSValueTransformer *)workExperienceListJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[TTDWorkExperience class]];
}

+ (NSValueTransformer *)courseworkOtherListJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[TTDCourseworkOther class]];
}


@end
