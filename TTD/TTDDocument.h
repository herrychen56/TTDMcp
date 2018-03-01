//
//  TTDDocument.h
//  TTD
//
//  Created by Mark Hao on 8/17/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTDDocument : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *studentID;
@property (nonatomic, strong) NSNumber *docID;
@property (nonatomic, strong) NSString *createdBy;
@property (nonatomic, strong) NSNumber *documentType;
@property (nonatomic, strong) NSNumber *sensitive;
@property (nonatomic, strong) NSString *documentName;
@property (nonatomic, strong) NSString *uploadedByRole;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *fileSource;
@property (nonatomic, strong) NSData *fileData;
@property (nonatomic, strong) NSString *documentTypeName;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *uploadedById;
@property (nonatomic, strong) NSNumber *isOwner;
@property (nonatomic, strong) NSDate *uploadedTime;
@property (nonatomic, strong) NSString *uploadedDate;
@property (nonatomic, strong) NSData *fileThumbnail;

+ (NSArray *)documentsWithDDXMLDocument:(DDXMLDocument*)document;
+ (NSArray *)documentsListByStudentWithDDXMLDocument:(DDXMLDocument*)document;
+ (NSData *)documentThumbnailWithDDXMLDocument:(DDXMLDocument*)document;
+ (NSData *)documentDataWithDDXMLDocument:(DDXMLDocument*)document;

@end


