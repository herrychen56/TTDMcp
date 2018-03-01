//
//  TTDEA.h
//  TTD
//
//  Created by Jeff Tang on 8/18/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTDEA : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSArray *courseworkOtherList;
@property (nonatomic, strong) NSArray *educationalPrepList;
@property (nonatomic, strong) NSArray *volunteerCommunityList;
@property (nonatomic, strong) NSArray *workExperienceList;
@property (nonatomic, strong) NSArray *awardsAndHonorsList;
@property (nonatomic, strong) NSArray *extracurricularList;

+ (NSDictionary *)easWithDDXMLDocument:(DDXMLDocument*)ea;

@end
