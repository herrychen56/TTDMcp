//
//  TTDAwardsAndHonors.h
//  TTD
//
//  Created by Mark Hao on 8/21/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface TTDAwardsAndHonors : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *studentID;
@property (nonatomic, strong) NSString *awardType;
@property (nonatomic, strong) NSNumber *yearReceived;
@property (nonatomic, strong) NSString *awardDescription;
@property (nonatomic, strong) NSNumber *awardID;
@property (nonatomic, strong) NSNumber *awardImportanceID;
@property (nonatomic, strong) NSString *description1;
@property (nonatomic, strong) NSNumber *awardOrder;
@property (nonatomic, strong) NSNumber *isStuAdd;
@property (nonatomic, strong) NSString *awardImportanceDescription;

@end
