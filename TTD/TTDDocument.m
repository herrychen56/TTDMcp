//
//  TTDDocument.m
//  TTD
//
//  Created by Mark Hao on 8/17/17.
//  Copyright © 2017 totem. All rights reserved.
//

#import "TTDDocument.h"

@implementation TTDDocument

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"studentID" : @"studentID",
             @"docID" : @"docID",
             @"createdBy" : @"created_by",
             @"documentType" : @"documenttype",
             @"sensitive" : @"sensitive",
             @"uploadedByRole" : @"uploadedbyrole",
             @"documentName" : @"documentname",
             @"notes" : @"notes",
             @"documentTypeName" : @"documenttypename",
             @"status" : @"status",
             @"uploadedById" : @"uploadedbyid",
             @"isOwner" : @"IsOwner",
             @"uploadedTime" : @"UploadedTime",
             @"uploadedDate" : @"uploadeddate",
             @"fileData" : @"filedata",
             @"fileSource" : @"filesource",
             @"fileThumbnail" : @"filethumbnail"
             };
}
//GetDocumentList
+ (NSArray *)documentsWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return nil;
    }
    DDXMLElement* bodyElement = [enveElement elementForName:@"GetDocumentListResponse"];
    if (!bodyElement) {
        return nil;
    }
    DDXMLElement* resultElement = [bodyElement elementForName:@"GetDocumentListResult"];
    if (!resultElement) {
        return nil;
    }
    NSString *jsonString = [resultElement stringValue];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    return jsonArray;
}
//GetDocumentListByStudent
+ (NSArray *)documentsListByStudentWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return nil;
    }
    DDXMLElement* bodyElement = [enveElement elementForName:@"GetDocumentListByStudentResponse"];
    if (!bodyElement) {
        return nil;
    }
    DDXMLElement* resultElement = [bodyElement elementForName:@"GetDocumentListByStudentResult"];
    if (!resultElement) {
        return nil;
    }
    NSString *jsonString = [resultElement stringValue];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    return jsonArray;
}
//LoadDocumentThumbnail
+ (NSData *)documentThumbnailWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return nil;
    }
    DDXMLElement* bodyElement = [enveElement elementForName:@"LoadDocumentThumbnailResponse"];
    if (!bodyElement) {
        return nil;
    }
    DDXMLElement* resultElement = [bodyElement elementForName:@"LoadDocumentThumbnailResult"];
    if (!resultElement) {
        return nil;
    }
    NSString *dataString = [resultElement stringValue];
    NSData *data = [[NSData alloc]initWithBase64EncodedString:dataString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

+ (NSData *)documentDataWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return nil;
    }
    DDXMLElement* bodyElement = [enveElement elementForName:@"DownLoadDocumentFileResponse"];
    if (!bodyElement) {
        return nil;
    }
    DDXMLElement* resultElement = [bodyElement elementForName:@"DownLoadDocumentFileResult"];
    if (!resultElement) {
        return nil;
    }
    NSString *dataString = [resultElement stringValue];
    //NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [[NSData alloc]initWithBase64EncodedString:dataString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}


@end
