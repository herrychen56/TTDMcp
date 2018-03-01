//
//  DataModel.m
//  TTD
//
//  Created by ZhangChuntao on 12/10/12.
//  Copyright (c) 2012 totem. All rights reserved.
//

#import "DataModel.h"
#import "NSObject+SBJson.h"

@implementation NSDictionary (NullReplace)

- (id)valueForKeyNotNull:(NSString*)key
{
    id value = [self valueForKey:key];
    if ([value isKindOfClass:[NSDictionary class]] ||
        [value isKindOfClass:[NSArray class]] ||
        [value isKindOfClass:[NSNumber class]] ||
        [value isKindOfClass:[NSString class]]) {
        return value;
    }
    return nil;
}

@end

@implementation LoginResponse
@synthesize state, responseMessage;



//<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
//<soap:Body>
//<UserLoginResponse xmlns="http://tempuri.org/">
//    <UserLoginResult>true</UserLoginResult>
//</UserLoginResponse>
//</soap:Body>
//</soap:Envelope>

+ (id)responseWithDDXMLDocument:(DDXMLDocument *)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    LoginResponse* mresponse = [[LoginResponse alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"UserLoginReturnRoleResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"UserLoginReturnRoleResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                mresponse.responseMessage = [resultElement stringValue];
                if ([mresponse.responseMessage isEqualToString:@"true"]) {
                    mresponse.state = YES;
                }
                else if ([mresponse.responseMessage isEqualToString:@"tutor"]) {
                    mresponse.state = YES;
                }
                else if ([mresponse.responseMessage isEqualToString:@"manager"]) {
                    mresponse.state = YES;
                }
                else if ([mresponse.responseMessage isEqualToString:@"parent"]) {
                    mresponse.state = YES;
                }
                else if ([mresponse.responseMessage isEqualToString:@"student"]) {
                    mresponse.state = YES;
                }
                else if ([mresponse.responseMessage isEqualToString:@"consultant"]) {
                    mresponse.state = YES;
                }

            }
        }
    }
    return mresponse;
}

@end
//zn 新建 getmettings
@implementation ZNgetmettings
+(id)responseWithDDXMLDocument:(DDXMLDocument *)document{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
     ZNgetmettings* mresponse = [[ZNgetmettings alloc] init];
     NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"getMeetingsResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"getMeetingsResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                mresponse.getMettingsStr = [resultElement stringValue];
            }
        }
    }
    
    return mresponse;
}

@end
//获取tokboxSeeeson
@implementation ZNgetTokBoxSession
+(id)responseWithDDXMLDocument:(DDXMLDocument *)document{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    ZNgetTokBoxSession* tokboxsession = [[ZNgetTokBoxSession alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"getTokboxSessionByMobileResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"getTokboxSessionByMobileResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                tokboxsession.tokgetTokboxSessionByMobile = [resultElement stringValue];
            }
        }
    }
    
    return tokboxsession;
}

@end
//获取tokbox token
@implementation ZNgetTokBoxToken
+(id)responseWithDDXMLDocument:(DDXMLDocument *)document{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    ZNgetTokBoxToken* tokboxtoken = [[ZNgetTokBoxToken alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSLog(@"envelop =%@",envelop);
        NSArray* body = [enveElement elementsForName:@"getTokboxTokenByMobileResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"getTokboxTokenByMobileResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                tokboxtoken.getTokBoxToken = [resultElement stringValue];
            }
        }
    }
    
    return tokboxtoken;
}

@end
//获取顾问经理首页2
@implementation ZNgetAllToDoTasks
+(id)responseWithDDXMLDocument:(DDXMLDocument *)document {
    DDXMLElement * rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    ZNgetAllToDoTasks * alltodoTasks = [[ZNgetAllToDoTasks alloc]init];
    NSArray * envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count >0) {
         DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"getAllToDoTasksResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"getAllToDoTasksResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                alltodoTasks. getAllToDoTasks= [resultElement stringValue];
            }
    }
    }
        return alltodoTasks;
}
@end
//获取顾问经理首页1
@implementation ZNgetConsultantThinktanKlearningService
+(id)responseWithDDXMLDocument:(DDXMLDocument *)document {
    DDXMLElement * rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    ZNgetConsultantThinktanKlearningService * constulant = [[ZNgetConsultantThinktanKlearningService alloc]init];
    NSArray * envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count >0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"getConsultantThinktankLearningServiceResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"getConsultantThinktankLearningServiceResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                constulant. getconstultant= [resultElement stringValue];
            }
        }
    }
    return constulant;
    
}
@end
//获取顾问经理首页3
@implementation ZNgetUPCOMINGMEETING
+(id)responseWithDDXMLDocument:(DDXMLDocument *)document {
    DDXMLElement * rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    ZNgetUPCOMINGMEETING * upcomingmetting = [[ZNgetUPCOMINGMEETING alloc]init];
    NSArray * envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count >0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"getUPCOMINGMEETINGResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"getUPCOMINGMEETINGResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                upcomingmetting. getupcomingmetting= [resultElement stringValue];
            }
        }
    }
    return upcomingmetting;
}
@end
//获取getALLEA
@implementation ZNgetALLEA
+(id)responseWithDDXMLDocument:(DDXMLDocument *)document {
    DDXMLElement * rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    ZNgetALLEA * getallea = [[ZNgetALLEA alloc]init];
    NSArray * envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count >0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"getAllEAResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"getAllEAResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                getallea. getALLEA= [resultElement stringValue];
            }
        }
    }
    return getallea;
}
@end
//get tests
@implementation ZNgetTests
+(id)responseWithDDXMLDocument:(DDXMLDocument *)document {
    DDXMLElement * rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    ZNgetTests * gettest = [[ZNgetTests alloc]init];
    NSArray * envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count >0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"getTestsResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"getTestsResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                gettest. getTests= [resultElement stringValue];
            }
        }
    }
    return gettest;
}
@end
//get all infro
@implementation ZNgetStudentAllInfo
+(id)responseWithDDXMLDocument:(DDXMLDocument *)document {
    DDXMLElement * rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    ZNgetStudentAllInfo * allinfo = [[ZNgetStudentAllInfo alloc]init];
    NSArray * envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count >0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"getStudentAllInfoResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"getStudentAllInfoResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                allinfo. getallinfo= [resultElement stringValue];
            }
        }
    }
    return allinfo;
}
@end
//get student progress
@implementation ZNgetStudentProgress
+(id)responseWithDDXMLDocument:(DDXMLDocument *)document {
    DDXMLElement * rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    ZNgetStudentProgress * znprogress = [[ZNgetStudentProgress alloc]init];
    NSArray * envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count >0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"getStudentProgressResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"getStudentProgressResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                znprogress. getProgress= [resultElement stringValue];
            }
        }
    }
    return znprogress;
}
@end
// getStudentTasks
@implementation ZNgetStudentTasks
+(id)responseWithDDXMLDocument:(DDXMLDocument *)document {
    DDXMLElement * rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    ZNgetStudentTasks * Tasks = [[ZNgetStudentTasks alloc]init];
    NSArray * envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count >0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"getStudentTasksResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"getStudentTasksResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                Tasks. getStudentTasks= [resultElement stringValue];
            }
        }
    }
    return Tasks;
}
@end
//ZNgetStudentAcademics
@implementation ZNgetStudentAcademics
+(id)responseWithDDXMLDocument:(DDXMLDocument *)document {
    DDXMLElement * rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    ZNgetStudentAcademics * Tasks = [[ZNgetStudentAcademics alloc]init];
    NSArray * envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count >0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"getStudentAcademicsResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"getStudentAcademicsResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                Tasks. getStudentAcademics= [resultElement stringValue];
            }
        }
    }
    return Tasks;
}
@end
//deleas
@implementation ZNDelEAs
+(id)responseWithDDXMLDocument:(DDXMLDocument *)document {
    DDXMLElement * rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    ZNDelEAs * delas = [[ZNDelEAs alloc]init];
    NSArray * envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count >0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"DelEAsResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"DelEAsResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                delas. deleas= [resultElement stringValue];
            }
        }
    }
    return delas;
}
@end
//getchatnew
@implementation ZNgetChatNews
+(id)responseWithDDXMLDocument:(DDXMLDocument *)document {
    DDXMLElement * rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    ZNgetChatNews * news = [[ZNgetChatNews alloc]init];
    NSArray * envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count >0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"getChatNewsResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"getChatNewsResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                news. chatnews= [resultElement stringValue];
            }
        }
    }
    return news;
}
@end
//setToDoTasks
@implementation ZNsetToDoTasks
+(id)responseWithDDXMLDocument:(DDXMLDocument *)document {
    DDXMLElement * rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    ZNsetToDoTasks * news = [[ZNsetToDoTasks alloc]init];
    NSArray * envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count >0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"setToDoTasksResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"setToDoTasksResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                news. setToDoTasks= [resultElement stringValue];
            }
        }
    }
    return news;
}
@end
//AddExtracurricularActivitiesByVCS
@implementation ZNAddExtracurricularActivitiesByVCS
+(id)responseWithDDXMLDocument:(DDXMLDocument *)document {
    DDXMLElement * rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    ZNAddExtracurricularActivitiesByVCS * news = [[ZNAddExtracurricularActivitiesByVCS alloc]init];
    NSArray * envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count >0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"AddExtracurricularActivitiesByVCSResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"AddExtracurricularActivitiesByVCSResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                news. AddExtracurricularActivitiesByVCS= [resultElement stringValue];
            }
        }
    }
    return news;
}
@end
//AddExtracurricularActivitiesByWE
@implementation ZNAddExtracurricularActivitiesByWE
+(id)responseWithDDXMLDocument:(DDXMLDocument *)document {
    DDXMLElement * rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    ZNAddExtracurricularActivitiesByWE * news = [[ZNAddExtracurricularActivitiesByWE alloc]init];
    NSArray * envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count >0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"AddExtracurricularActivitiesByEAResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"AddExtracurricularActivitiesByEAResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                news. AddExtracurricularActivitiesByWE= [resultElement stringValue];
            }
        }
    }
    return news;
}
@end
//AddExtracurricularActivitiesByEA
@implementation ZNAddExtracurricularActivitiesByEA
+(id)responseWithDDXMLDocument:(DDXMLDocument *)document {
    DDXMLElement * rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    ZNAddExtracurricularActivitiesByEA * news = [[ZNAddExtracurricularActivitiesByEA alloc]init];
    NSArray * envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count >0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"AddExtracurricularActivitiesByEAResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"AddExtracurricularActivitiesByEAResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                news. AddExtracurricularActivitiesByEA= [resultElement stringValue];
            }
        }
    }
    return news;
}
@end


@implementation UserFullNameResponse

+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    UserFullNameResponse* mresponse = [[UserFullNameResponse alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"GetUserFullNameResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"GetUserFullNameResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                mresponse.userFullName = [resultElement stringValue];
            }
        }
    }
    return mresponse;
}

@end

@implementation OpengfireChangeUserPasswordResponse

+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    OpengfireChangeUserPasswordResponse* mresponse = [[OpengfireChangeUserPasswordResponse alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"OpengfireChangeUserPasswordResult"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"OpengfireChangeUserPasswordResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                mresponse.info = [resultElement stringValue];
            }
        }
    }
    return mresponse;
}

@end

@implementation OpenfireUserResponse

+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    OpenfireUserResponse* mresponse = [[OpenfireUserResponse alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"OpenfireUserResult"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"OpenfireUserResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                mresponse.info = [resultElement stringValue];
            }
        }
    }
    return mresponse;
}

@end

@implementation LocationInfo

+ (NSMutableArray*)locationArrayWithXMLDocument:(DDXMLDocument *)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    NSMutableArray* locationArray = [[NSMutableArray alloc] init];
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return locationArray;
    }
    DDXMLElement* bodyElement = [enveElement elementForName:@"LocationResponse"];
    if (!bodyElement) {
        return locationArray;
    }
    DDXMLElement* resultElement = [bodyElement elementForName:@"LocationResult"];
    if (!resultElement) {
        return locationArray;
    }
    NSString* string = [resultElement description];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:diffgram" withString:@"diff"];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:before" withString:@"diff_before"];
    DDXMLDocument* doc = [[DDXMLDocument alloc] initWithXMLString:string options:0 error:nil];
    resultElement = [doc rootElement];
    DDXMLElement* diffElement = [resultElement elementForName:@"diff"];
    if (!diffElement) {
        return locationArray;
    }
    DDXMLElement* arrarElement = [diffElement elementForName:@"NewDataSet"];
    if (!arrarElement) {
        return locationArray;
    }
    NSArray* arrays = [arrarElement elementsForName:@"Table"];
    if (arrays.count > 0) {
        for (int i = 0; i < arrays.count; i++) {
            DDXMLElement* location = [arrays objectAtIndex:i];
            LocationInfo* info = [[LocationInfo alloc] init];
            DDXMLElement* loc_id = [location elementForName:@"loc_ID"];
            info.locId = [[loc_id stringValue] intValue];
            DDXMLElement* loc_name = [location elementForName:@"loc_name"];
            info.locName = [loc_name stringValue];
            [locationArray addObject:info];
            NSLog(@"location:%d, %@", info.locId, info.locName);
        }
    }
    {
        DDXMLElement* arrarElement = [diffElement elementForName:@"diff_before"];
        if (!arrarElement) {
            return locationArray;
        }
        NSArray* arrays = [arrarElement elementsForName:@"Table"];
        if (arrays.count > 0) {
            for (int i = 0; i < arrays.count; i++) {
                DDXMLElement* location = [arrays objectAtIndex:i];
                LocationInfo* info = [[LocationInfo alloc] init];
                DDXMLElement* loc_id = [location elementForName:@"loc_ID"];
                info.locId = [[loc_id stringValue] intValue];
                DDXMLElement* loc_name = [location elementForName:@"loc_name"];
                info.locName = [loc_name stringValue];
                [locationArray addObject:info];
            }
        }
    }
    NSLog(@"loc:%lu", (unsigned long)locationArray.count);
    return locationArray;
}

@end

@implementation RatioInfo

+ (NSMutableArray*)arrayWithXMLDocument:(DDXMLDocument *)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    NSMutableArray* locationArray = [[NSMutableArray alloc] init];
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return locationArray;
    }
    DDXMLElement* bodyElement = [enveElement elementForName:@"TimesheetStudentTutorRatioResponse"];
    if (!bodyElement) {
        return locationArray;
    }
    DDXMLElement* resultElement = [bodyElement elementForName:@"TimesheetStudentTutorRatioResult"];
    if (!resultElement) {
        return locationArray;
    }
    NSString* string = [resultElement description];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:diffgram" withString:@"diff"];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:before" withString:@"diff_before"];
    DDXMLDocument* doc = [[DDXMLDocument alloc] initWithXMLString:string options:0 error:nil];
    resultElement = [doc rootElement];
    DDXMLElement* diffElement = [resultElement elementForName:@"diff"];
    if (!diffElement) {
        return locationArray;
    }
    DDXMLElement* arrarElement = [diffElement elementForName:@"NewDataSet"];
    if (!arrarElement) {
        return locationArray;
    }
    NSArray* arrays = [arrarElement elementsForName:@"Table"];
    if (arrays.count > 0) {
        for (int i = 0; i < arrays.count; i++) {
            DDXMLElement* location = [arrays objectAtIndex:i];
            RatioInfo* info = [[RatioInfo alloc] init];
            DDXMLElement* loc_id = [location elementForName:@"StudentTutorRatioValue"];
            info.ratioId = [[loc_id stringValue] intValue];
            DDXMLElement* loc_name = [location elementForName:@"StudentTutorRatioString"];
            info.type = [loc_name stringValue];
            [locationArray addObject:info];
            NSLog(@"%d, %@", info.ratioId, info.type);
        }
    }
    {
        DDXMLElement* arrarElement = [diffElement elementForName:@"diff_before"];
        if (!arrarElement) {
            return locationArray;
        }
        NSArray* arrays = [arrarElement elementsForName:@"Table"];
        if (arrays.count > 0) {
            for (int i = 0; i < arrays.count; i++) {
                DDXMLElement* location = [arrays objectAtIndex:i];
                RatioInfo* info = [[RatioInfo alloc] init];
                DDXMLElement* loc_id = [location elementForName:@"StudentTutorRatioValue"];
                info.ratioId = [[loc_id stringValue] intValue];
                DDXMLElement* loc_name = [location elementForName:@"StudentTutorRatioString"];
                info.type = [loc_name stringValue];
                [locationArray addObject:info];
                NSLog(@"%d, %@", info.ratioId, info.type);
            }
        }
        NSLog(@"loc:%d", locationArray.count);
    }
    return locationArray;
}

@end

@implementation StudentInfo

+ (NSMutableArray*)studentsArrayWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    NSMutableArray* locationArray = [[NSMutableArray alloc] init];
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return locationArray;
    }
    DDXMLElement* bodyElement = [enveElement elementForName:@"TimesheetStudentResponse"];
    if (!bodyElement) {
        return locationArray;
    }
    DDXMLElement* resultElement = [bodyElement elementForName:@"TimesheetStudentResult"];
    if (!resultElement) {
        return locationArray;
    }
    NSString* string = [resultElement description];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:diffgram" withString:@"diff"];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:before" withString:@"diff_before"];
    DDXMLDocument* doc = [[DDXMLDocument alloc] initWithXMLString:string options:0 error:nil];
    resultElement = [doc rootElement];
    DDXMLElement* diffElement = [resultElement elementForName:@"diff"];
    if (!diffElement) {
        return locationArray;
    }
    DDXMLElement* arrarElement = [diffElement elementForName:@"NewDataSet"];
    if (!arrarElement) {
        return locationArray;
    }
    NSArray* arrays = [arrarElement elementsForName:@"Table"];
    if (arrays.count > 0) {
        for (int i = 0; i < arrays.count; i++) {
            DDXMLElement* location = [arrays objectAtIndex:i];
            StudentInfo* info = [[StudentInfo alloc] init];
            DDXMLElement* loc_id = [location elementForName:@"stu_ID"];
            info.studentId = [[loc_id stringValue] intValue];
            DDXMLElement* loc_name = [location elementForName:@"studentname"];
            info.studentName = [loc_name stringValue];
            [locationArray addObject:info];
            NSLog(@"%d, %@", info.studentId, info.studentName);
        }
    }
    {
        DDXMLElement* arrarElement = [diffElement elementForName:@"diff_before"];
        if (!arrarElement) {
            return locationArray;
        }
        NSArray* arrays = [arrarElement elementsForName:@"Table"];
        if (arrays.count > 0) {
            for (int i = 0; i < arrays.count; i++) {
                DDXMLElement* location = [arrays objectAtIndex:i];
                StudentInfo* info = [[StudentInfo alloc] init];
                DDXMLElement* loc_id = [location elementForName:@"stu_ID"];
                info.studentId = [[loc_id stringValue] intValue];
                DDXMLElement* loc_name = [location elementForName:@"studentname"];
                info.studentName = [loc_name stringValue];
                [locationArray addObject:info];
                NSLog(@"%d, %@", info.studentId, info.studentName);

            }
        }
    }
    NSLog(@"loc:%ld", locationArray.count);
    return locationArray;
}

@end



@implementation DurationInfo

+ (NSMutableArray*)arrayWithXMLDocument:(DDXMLDocument *)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    NSMutableArray* locationArray = [[NSMutableArray alloc] init];
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return locationArray;
    }
    DDXMLElement* bodyElement = [enveElement elementForName:@"TimesheetDurationResponse"];
    if (!bodyElement) {
        return locationArray;
    }
    DDXMLElement* resultElement = [bodyElement elementForName:@"TimesheetDurationResult"];
    if (!resultElement) {
        return locationArray;
    }
    NSString* string = [resultElement description];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:diffgram" withString:@"diff"];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:before" withString:@"diff_before"];
    DDXMLDocument* doc = [[DDXMLDocument alloc] initWithXMLString:string options:0 error:nil];
    resultElement = [doc rootElement];
    DDXMLElement* diffElement = [resultElement elementForName:@"diff"];
    if (!diffElement) {
        return locationArray;
    }
    DDXMLElement* arrarElement = [diffElement elementForName:@"NewDataSet"];
    if (!arrarElement) {
        return locationArray;
    }
    NSArray* arrays = [arrarElement elementsForName:@"Table"];
    if (arrays.count > 0) {
        for (int i = 0; i < arrays.count; i++) {
            DDXMLElement* location = [arrays objectAtIndex:i];
            DurationInfo * info = [[DurationInfo alloc] init];
            DDXMLElement* loc_id = [location elementForName:@"DurationValue"];
            info.durationID = [[loc_id stringValue] floatValue];
            DDXMLElement* loc_name = [location elementForName:@"DurationString"];
            info.durationString = [loc_name stringValue];
            [locationArray addObject:info];
            NSLog(@"%f, %@", info.durationID, info.durationString);
        }
    }
    NSLog(@"loc:%d", locationArray.count);
    return locationArray;
}

@end


@implementation NoShowInfo

+ (NSMutableArray*)NoShowArrayWithXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    NSMutableArray* NoShowInfoArray = [[NSMutableArray alloc] init];
    
    return NoShowInfoArray;
}

@end

@implementation SubjectInfo

+ (NSMutableArray*)subjectsArrayWithXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    NSMutableArray* locationArray = [[NSMutableArray alloc] init];
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return locationArray;
    }
    DDXMLElement* bodyElement = [enveElement elementForName:@"TimesheetSubjectResponse"];
    if (!bodyElement) {
        return locationArray;
    }
    DDXMLElement* resultElement = [bodyElement elementForName:@"TimesheetSubjectResult"];
    if (!resultElement) {
        return locationArray;
    }
    NSString* string = [resultElement description];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:diffgram" withString:@"diff"];
    DDXMLDocument* doc = [[DDXMLDocument alloc] initWithXMLString:string options:0 error:nil];
    resultElement = [doc rootElement];
    NSLog(@"resultEle:%@", [resultElement description]);
    DDXMLElement* arrarElement = [resultElement elementForName:@"diff"];
    arrarElement = [arrarElement elementForName:@"NewDataSet"];
    if (!arrarElement) {
        return locationArray;
    }
    NSArray* arrays = [arrarElement elementsForName:@"Table"];
    if (arrays.count > 0) {
        for (int i = 0; i < arrays.count; i++) {
            DDXMLElement* location = [arrays objectAtIndex:i];
            SubjectInfo* info = [[SubjectInfo alloc] init];
            DDXMLElement* loc_id = [location elementForName:@"sub_ID"];
            info.subjectId = [[loc_id stringValue] intValue];
            DDXMLElement* tutor_id = [location elementForName:@"tutor_ID"];
            info.tutorId = [[tutor_id stringValue] intValue];
            DDXMLElement* loc_name = [location elementForName:@"sub_name"];
            info.subjectName = [loc_name stringValue];
            [locationArray addObject:info];
            NSLog(@"%d, %@", info.subjectId, info.subjectName);
        }
    }

    NSLog(@"loc:%ld", locationArray.count);
    return locationArray;
}

@end

@implementation TimeSheetSummary

+ (id)timeSheetSummaryWithDDXMLDocument:(DDXMLDocument *)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    NSMutableArray* locationArray = [[NSMutableArray alloc] init];
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return locationArray;
    }
    DDXMLElement* bodyElement = [enveElement elementForName:@"SelectTutorTimesheetsPageResponse"];
    if (!bodyElement) {
        return locationArray;
    }
    DDXMLElement* resultElement = [bodyElement elementForName:@"SelectTutorTimesheetsPageResult"];
    if (!resultElement) {
        return locationArray;
    }
    NSString* string = [resultElement description];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:diffgram" withString:@"diff"];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:before" withString:@"diff_before"];
    DDXMLDocument* doc = [[DDXMLDocument alloc] initWithXMLString:string options:0 error:nil];
    resultElement = [doc rootElement];
    DDXMLElement* diffElement = [resultElement elementForName:@"diff"];
    if (!diffElement) {
        return locationArray;
    }
//    <ts_ID>12493</ts_ID>
//    <tutor_ID>471</tutor_ID>
//    <location>TTL Cupertino</location>
//    <sub_ID>53</sub_ID>
//    <app_status>T</app_status>
//    <sub_name>Economics</sub_name>
    DDXMLElement* arrarElement = [diffElement elementForName:@"NewDataSet"];
    if (!arrarElement) {
        return locationArray;
    }
    NSArray* arrays = [arrarElement elementsForName:@"Table"];
    if (arrays.count > 0) {
        for (int i = 0; i < arrays.count; i++) {
            DDXMLElement* location = [arrays objectAtIndex:i];
            TimeSheetSummary* info = [[TimeSheetSummary alloc] init];
            DDXMLElement* loc_id = [location elementForName:@"sub_ID"];
            info.subjectId = [loc_id stringValue];
            DDXMLElement* tutor_id = [location elementForName:@"tutor_ID"];
            info.totur = [tutor_id stringValue];
            DDXMLElement* loc_name = [location elementForName:@"app_status"];
            info.timeSheetState = [loc_name stringValue];
            DDXMLElement* loc_name1 = [location elementForName:@"location"];
            info.location = [loc_name1 stringValue];
            DDXMLElement* loc_name2 = [location elementForName:@"sub_name"];
            info.subName = [loc_name2 stringValue];
            DDXMLElement* loc_name3 = [location elementForName:@"ts_ID"];
            info.timeSheetId = [loc_name3 stringValue];
            DDXMLElement* loc_name4 = [location elementForName:@"students"];
            info.students = [loc_name4 stringValue];
            DDXMLElement* loc_name5 = [location elementForName:@"submit_datetime"];
            if (loc_name5 && ![loc_name5 isKindOfClass:[NSNull class]]) {
                NSString* dateS = [loc_name5 stringValue];
                dateS = [dateS substringToIndex:16];
                dateS = [dateS stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                NSLog(@"dates:%@", dateS);
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSDate* date = [formatter dateFromString:dateS];
                if (date) {
                    [formatter setDateFormat:@"MM/dd/yyyy HH:mm"];
                    info.timeSheetDate = [formatter stringFromDate:date];
                }
            }
            DDXMLElement* loc_name6 = [location elementForName:@"source"];
            info.source = [loc_name6 stringValue];
            NSLog(@"%@", info.source);
            if (info.source.length == 0) {
                info.source = @"Web";
            }
            [locationArray addObject:info];
        }
    }
    
    NSLog(@"loc:%ld", locationArray.count);
    return locationArray;
}

@end

@implementation InsertTimeSheetResponse

+ (id)insertTimeSheetResponseWithDDXMLDocument:(DDXMLDocument *)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    InsertTimeSheetResponse* mresponse = [[InsertTimeSheetResponse alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"InsertTimesheetResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"InsertTimesheetResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                mresponse.responseMessage = [resultElement stringValue];
                if ([mresponse.responseMessage isEqualToString:@"true"]) {
                    mresponse.succeed = YES;
                }
                else if ([mresponse.responseMessage isEqualToString:@"false"]) {
                    mresponse.responseMessage = @"Upload failed!";
                }
                else if ([mresponse.responseMessage isEqualToString:@"-1"]) {
                    mresponse.responseMessage = @"Totur login error!";
                }
                else if ([mresponse.responseMessage isEqualToString:@"-2"]) {
                    mresponse.responseMessage = @"Student password incorrect!";
                }
            }
        }
    }
    return mresponse;
}

@end

@implementation UpdateTimeSheetResponse

+ (id)updateTimeSheetResponseWithDDXMLDocument:(DDXMLDocument*)document type:(int)type
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    UpdateTimeSheetResponse* mresponse = [[UpdateTimeSheetResponse alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        if (type == 1) {
            NSArray* body = [enveElement elementsForName:@"UpdateTimesheetByMobileResponse"];
            if (body.count > 0) {
                DDXMLElement* bodyElement = [body objectAtIndex:0];
                NSArray* response = [bodyElement elementsForName:@"UpdateTimesheetByMobileResult"];
                if (response.count > 0) {
                    DDXMLDocument* resultElement = [response objectAtIndex:0];
                    mresponse.responseMessage = [resultElement stringValue];
                    if ([mresponse.responseMessage isEqualToString:@"true"]) {
                        mresponse.succeed = YES;
                    }
                    else if ([mresponse.responseMessage isEqualToString:@"false"]) {
                        mresponse.responseMessage = @"Upload failed!";
                    }
                    else if ([mresponse.responseMessage isEqualToString:@"-1"]) {
                        mresponse.responseMessage = @"Totur login error!";
                    }
                    else if ([mresponse.responseMessage isEqualToString:@"-2"]) {
                        mresponse.responseMessage = @"Students password error!";
                    }
                }
            }
        }
        else {
            NSArray* body = [enveElement elementsForName:@"UpdateTimesheetByWebResponse"];
            if (body.count > 0) {
                DDXMLElement* bodyElement = [body objectAtIndex:0];
                NSArray* response = [bodyElement elementsForName:@"UpdateTimesheetByWebResult"];
                if (response.count > 0) {
                    DDXMLDocument* resultElement = [response objectAtIndex:0];
                    mresponse.responseMessage = [resultElement stringValue];
                    if ([mresponse.responseMessage isEqualToString:@"true"]) {
                        mresponse.succeed = YES;
                    }
                    else if ([mresponse.responseMessage isEqualToString:@"false"]) {
                        mresponse.responseMessage = @"Upload failed!";
                    }
                    else if ([mresponse.responseMessage isEqualToString:@"-1"]) {
                        mresponse.responseMessage = @"Totur login error!";
                    }
                    else if ([mresponse.responseMessage isEqualToString:@"-2"]) {
                        mresponse.responseMessage = @"Students password error!";
                    }
                }
            }
        }
    }
    return mresponse;
}

@end

@implementation TimeSheetSession


@end

@implementation TimeSheet

+ (TimeSheet*)timeSheetWithXMLDoc:(DDXMLDocument*)document type:(int)type
{
    TimeSheet* timeSheet = [[TimeSheet alloc] init];
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return nil;
    }
    if (type == 0) {
        DDXMLElement* bodyElement = [enveElement elementForName:@"UpLoadTimesheetByWebResponse"];
        if (!bodyElement) {
            return nil;
        }
        DDXMLElement* resultElement = [bodyElement elementForName:@"UpLoadTimesheetByWebResult"];
        if (!resultElement) {
            return nil;
        }
        NSDictionary* timeSheetDic = [[resultElement stringValue] JSONValue];
        NSLog(@"dic:%@", timeSheetDic);
        TimeSheetSummary* info = [[TimeSheetSummary alloc] init];
        info.subjectId = [timeSheetDic valueForKeyNotNull:@"Subject"];
        info.location = [timeSheetDic valueForKeyNotNull:@"Location"];
        info.totur = [timeSheetDic valueForKeyNotNull:@"StudentTutorRatio"];
        info.students = [timeSheetDic valueForKeyNotNull:@"Student"];
        info.noshow=[timeSheetDic valueForKeyNotNull:@"NoShow"];
        info.app_status=[timeSheetDic valueForKeyNotNull:@"App_Status"];
        info.studentname=[timeSheetDic valueForKeyNotNull:@"StudentName"];
        timeSheet.summary = info;
        NSArray* sessions = [timeSheetDic valueForKeyNotNull:@"TimesheetSessions"];
        if ([sessions isKindOfClass:[NSArray class]]) {
            timeSheet.sessionArray = [NSMutableArray array];
            for ( int i = 0; i < sessions.count; i++) {
                NSDictionary* dic = [sessions objectAtIndex:i];
                TimeSheetSession* session = [[TimeSheetSession alloc] init];
                session.duration = [dic valueForKeyNotNull:@"Duration"];
                session.studentId = [dic valueForKeyNotNull:@"StuId"];
                session.note = [dic valueForKeyNotNull:@"Notes"];
                session.noshow=[dic valueForKeyNotNull:@"NoShow"];
                NSString* date = [dic valueForKeyNotNull:@"Date"];
                NSString* hr = [dic valueForKeyNotNull:@"Hr"];
                NSString* min = [dic valueForKeyNotNull:@"Min"];
                NSString* AMPM = [dic valueForKeyNotNull:@"AMPM"];
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy/M/d h:m a"];
                NSString* timeString = [NSString stringWithFormat:@"%@ %@:%@ %@", date, hr, min, AMPM];
                NSLog(@"string:%@", timeString);
                session.date = [formatter dateFromString:timeString];
                NSLog(@"%@", [formatter stringFromDate:session.date]);
                [timeSheet.sessionArray addObject:session];
            }
        }
    }
    else {
//        <Subject>29</Subject>
//        <Location>Other</Location>
//        <StudentTutorRatio>1</StudentTutorRatio>
//        <Student>3771</Student>
//        <Date>2012-12-21T00:00:00-08:00</Date>
//        <Hr>3</Hr>
//        <Min>40</Min>
//        <AMPM>PM</AMPM>
//        <Duration>1.75</Duration>
//        <Notes>test</Notes>
//        </Table>
//        </NewDataSet>
//        </diffgr:diffgram>
//        </UpLoadTimesheetByMobileResult>
        DDXMLElement* bodyElement = [enveElement elementForName:@"UpLoadTimesheetByMobileResponse"];
        if (!bodyElement) {
            return nil;
        }
        DDXMLElement* resultElement = [bodyElement elementForName:@"UpLoadTimesheetByMobileResult"];
        if (!resultElement) {
            return nil;
        }
        NSString* string = [resultElement description];
        string = [string stringByReplacingOccurrencesOfString:@"diffgr:diffgram" withString:@"diff"];
        DDXMLDocument* doc = [[DDXMLDocument alloc] initWithXMLString:string options:0 error:nil];
        resultElement = [doc rootElement];
        DDXMLElement* diffElement = [resultElement elementForName:@"diff"];
        if (!diffElement) {
            return nil;
        }
        DDXMLElement* arrarElement = [diffElement elementForName:@"NewDataSet"];
        if (!arrarElement) {
            return nil;
        }
        NSArray* sessionArray = [arrarElement elementsForName:@"Table"];
        if (sessionArray.count > 0) {
            for (int i = 0; i < 1; i++) {
                timeSheet.summary = [[TimeSheetSummary alloc] init];
                DDXMLElement* cellElement = [sessionArray objectAtIndex:i];
                NSLog(@"cellElement:%@", [cellElement description]);
                DDXMLElement* ele = [cellElement elementForName:@"Subject"];
                timeSheet.summary.subjectId = [ele stringValue];
                ele = [cellElement elementForName:@"Location"];
                timeSheet.summary.location = [ele stringValue];
                ele = [cellElement elementForName:@"StudentTutorRatio"];
                timeSheet.summary.totur = [ele stringValue];
                ele = [cellElement elementForName:@"Student"];
                timeSheet.summary.students = [ele stringValue];
                
                ele = [cellElement elementForName:@"NoShow"];
                timeSheet.summary.noshow = [ele stringValue];
                
                ele = [cellElement elementForName:@"App_Status"];
                timeSheet.summary.app_status = [ele stringValue];
                
                ele = [cellElement elementForName:@"StudentName"];
                timeSheet.summary.studentname = [ele stringValue];
                
                ele = [cellElement elementForName:@"Date"];
                NSString* dateS = [ele stringValue];
                ele = [cellElement elementForName:@"Hr"];
                NSString* hr = [ele stringValue];
                ele = [cellElement elementForName:@"Min"];
                NSString* min = [ele stringValue];
                ele = [cellElement elementForName:@"AMPM"];
                NSString* ampm = [ele stringValue];
                dateS = [dateS substringToIndex:10];
                dateS = [dateS stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                if (hr.length == 1) {
                    hr = [NSString stringWithFormat:@"0%@", hr];
                }
                if (min.length == 1) {
                    min = [NSString stringWithFormat:@"0%@", min];
                }
                [formatter setPMSymbol:@"PM"];
                [formatter setAMSymbol:@"AM"];
                [formatter setDateFormat:@"yyyy-MM-dd hh:mm aa"];
                dateS = [dateS stringByAppendingFormat:@" %@:%@ %@", hr, min, ampm];
                NSLog(@"dates:%@", dateS);
                NSDate* date111 = [formatter dateFromString:dateS];
                timeSheet.sessionArray = [NSMutableArray array];
                TimeSheetSession* session = [[TimeSheetSession alloc] init];
                session.date = date111;
                ele = [cellElement elementForName:@"Notes"];
                session.note = [ele stringValue];
                ele = [cellElement elementForName:@"Duration"];
                session.duration = [ele stringValue];
                [timeSheet.sessionArray addObject:session];
            }
        }
    }
    timeSheet.type = type;
    return timeSheet;
}

@end

@implementation UserInfo

+ (UserInfo*)userInfoWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    UserInfo* userInfo = [[UserInfo alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"GetUserInfoResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"GetUserInfoResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                NSString* jsonString = [resultElement stringValue];
                NSDictionary* dic = [jsonString JSONValue];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    userInfo.firstName = [dic valueForKeyNotNull:@"FirstName"];
                    userInfo.lastName = [dic valueForKeyNotNull:@"LastName"];
                    userInfo.avatarUrl = [dic valueForKeyNotNull:@"HeadPhoto"];
                    userInfo.userFullName = [dic valueForKeyNotNull:@"Username"];
                }
            }
        }
    }
    return userInfo;
}

@end

@implementation UpdateInfo

//<?xml version="1.0" encoding="UTF-8"?>
//<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><UpdateResponse xmlns="http://tempuri.org/"><UpdateResult>https://itunes.apple.com/cn/app/bai-du-de-tu-yu-yin-dao-hang/id452186370?mt=8</UpdateResult></UpdateResponse></soap:Body></soap:Envelope>

+ (UpdateInfo*)updateInfoWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    UpdateInfo* updateInfo = [[UpdateInfo alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"UpdateResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"UpdateResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                NSString* jsonString = [resultElement stringValue];
                updateInfo.updateUrl = jsonString;
                if (![updateInfo.updateUrl isEqualToString:@"false"]) {
                    updateInfo.hasNewVersion = YES;
                }
            }
        }
    }
    return updateInfo;
}

@end

@implementation ViewStudentsBySearch

+ (id)ViewStudentsBySearchWithDDXMLDocument:(DDXMLDocument *)document		{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    NSMutableArray* locationArray = [[NSMutableArray alloc] init];
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return locationArray;
    }
    DDXMLElement* bodyElement = [enveElement elementForName:@"ViewStudentsBySearchResponse"];
    if (!bodyElement) {
        return locationArray;
    }
    DDXMLElement* resultElement = [bodyElement elementForName:@"ViewStudentsBySearchResult"];
    if (!resultElement) {
        return locationArray;
    }
    NSString* string = [resultElement description];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:diffgram" withString:@"diff"];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:before" withString:@"diff_before"];
    DDXMLDocument* doc = [[DDXMLDocument alloc] initWithXMLString:string options:0 error:nil];
    resultElement = [doc rootElement];
    DDXMLElement* diffElement = [resultElement elementForName:@"diff"];
    if (!diffElement) {
        return locationArray;
    }
    
    DDXMLElement* arrarElement = [diffElement elementForName:@"NewDataSet"];
    if (!arrarElement) {
        return locationArray;
    }
    NSArray* arrays = [arrarElement elementsForName:@"Table"];
    if (arrays.count > 0) {
        for (int i = 0; i < arrays.count; i++) {
            DDXMLElement* location = [arrays objectAtIndex:i];
            ManagerViewStudents* info = [[ManagerViewStudents alloc] init];
            DDXMLElement* username = [location elementForName:@"username"];
            info.username = [username stringValue];
            DDXMLElement* studentname = [location elementForName:@"studentname"];
            info.studentname = [studentname stringValue];
            DDXMLElement* stu_id = [location elementForName:@"stu_ID"];
            info.stu_id = [stu_id stringValue];
            DDXMLElement* email = [location elementForName:@"email"];
            info.email = [email stringValue];
            DDXMLElement* phone = [location elementForName:@"phone"];
            info.phone = [phone stringValue];
            DDXMLElement* loc_name = [location elementForName:@"loc_name"];
            info.loc_name = [loc_name stringValue];
            DDXMLElement* photo = [location elementForName:@"photo"];
            info.photo = [photo stringValue];
            
            [locationArray addObject:info];
        }
    }
    
    NSLog(@"loc:%ld", locationArray.count);
    return locationArray;
}

@end

@implementation ManagerViewStudents

+ (id)managerViewStudentsWithDDXMLDocument:(DDXMLDocument *)document		{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    NSMutableArray* locationArray = [[NSMutableArray alloc] init];
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return locationArray;
    }
    DDXMLElement* bodyElement = [enveElement elementForName:@"ViewStudentsResponse"];
    if (!bodyElement) {
        return locationArray;
    }
    DDXMLElement* resultElement = [bodyElement elementForName:@"ViewStudentsResult"];
    if (!resultElement) {
        return locationArray;
    }
    NSString* string = [resultElement description];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:diffgram" withString:@"diff"];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:before" withString:@"diff_before"];
    DDXMLDocument* doc = [[DDXMLDocument alloc] initWithXMLString:string options:0 error:nil];
    resultElement = [doc rootElement];
    DDXMLElement* diffElement = [resultElement elementForName:@"diff"];
    if (!diffElement) {
        return locationArray;
    }

    DDXMLElement* arrarElement = [diffElement elementForName:@"NewDataSet"];
    if (!arrarElement) {
        return locationArray;
    }
    NSArray* arrays = [arrarElement elementsForName:@"Table"];
    if (arrays.count > 0) {
        for (int i = 0; i < arrays.count; i++) {
            DDXMLElement* location = [arrays objectAtIndex:i];
            ManagerViewStudents* info = [[ManagerViewStudents alloc] init];
            DDXMLElement* username = [location elementForName:@"username"];
            info.username = [username stringValue];
            DDXMLElement* studentname = [location elementForName:@"studentname"];
            info.studentname = [studentname stringValue];
            DDXMLElement* stu_id = [location elementForName:@"stu_ID"];
            info.stu_id = [stu_id stringValue];
            DDXMLElement* email = [location elementForName:@"email"];
            info.email = [email stringValue];
            DDXMLElement* phone = [location elementForName:@"phone"];
            info.phone = [phone stringValue];
            DDXMLElement* loc_name = [location elementForName:@"loc_name"];
            info.loc_name = [loc_name stringValue];
            DDXMLElement* photo = [location elementForName:@"photo"];
            info.photo = [photo stringValue];
        
            [locationArray addObject:info];
        }
    }
    
    NSLog(@"loc:%ld", locationArray.count);
    return locationArray;
}

@end

@implementation StudentDetail

+ (id)StudentDetailWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    StudentDetail* studentinfo = [[StudentDetail alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"GetStudentInfoResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"GetStudentInfoResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                NSString* jsonString = [resultElement stringValue];
                NSDictionary* dic = [jsonString JSONValue];
                               
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    NSLog(@"isKindOfClass");
                    studentinfo.username = [dic valueForKeyNotNull:@"username"];
                    studentinfo.stu_id = [dic valueForKeyNotNull:@"stu_id"];
                    studentinfo.email = [dic valueForKeyNotNull:@"email"];
                    studentinfo.loc_name = [dic valueForKeyNotNull:@"location"];
                    studentinfo.phone = [dic valueForKeyNotNull:@"phone"];
                    studentinfo.parent = [dic valueForKeyNotNull:@"parent"];
                    studentinfo.parent_home_phone = [dic valueForKeyNotNull:@"parent_home_phone"];
                    studentinfo.parent_contact_phone = [dic valueForKeyNotNull:@"parent_contact_phone"];
                    studentinfo.parent_email = [dic valueForKeyNotNull:@"parent_email"];
                    studentinfo.language = [dic valueForKeyNotNull:@"language"];
                    studentinfo.address = [dic valueForKeyNotNull:@"address"];
                    studentinfo.photo = [dic valueForKeyNotNull:@"photo"];
                }
            }
        }
    }    
    return studentinfo;
}

@end

//Get Login Info
@implementation SelectLoginInfo
@synthesize  email;
@synthesize  photo;

+ (id)SelectLoginInfoWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    NSMutableArray* loginInfoArray = [[NSMutableArray alloc] init];
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return loginInfoArray;
    }
    DDXMLElement* bodyElement = [enveElement elementForName:@"UserLoginReturnLoginInfoResponse"];
    if (!bodyElement) {
        return loginInfoArray;
    }
    DDXMLElement* resultElement = [bodyElement elementForName:@"UserLoginReturnLoginInfoResult"];
    if (!resultElement) {
        return loginInfoArray;
    }
    NSString* string = [resultElement description];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:diffgram" withString:@"diff"];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:before" withString:@"diff_before"];
    DDXMLDocument* doc = [[DDXMLDocument alloc] initWithXMLString:string options:0 error:nil];
    resultElement = [doc rootElement];
    DDXMLElement* diffElement = [resultElement elementForName:@"diff"];
    if (!diffElement) {
        return loginInfoArray;
    }
    DDXMLElement* arrarElement = [diffElement elementForName:@"NewDataSet"];
    NSArray* arrays = [arrarElement elementsForName:@"Table"];
    
    if (arrays.count > 0) {
        for (int i = 0; i < arrays.count; i++) {
            
            DDXMLElement* request = [arrays objectAtIndex:i];
            SelectLoginInfo* info = [[SelectLoginInfo alloc] init];
            DDXMLElement* email = [request elementForName:@"email"];
            //NSString *id=[studid stringValue];
            info.email = [email stringValue];
            
            
            DDXMLElement* photo = [request elementForName:@"photo"];
            info.photo = [photo stringValue];
            
            
            [loginInfoArray addObject:info];
        }
    }
    
    NSLog(@"loc:%ld", loginInfoArray.count);
    return loginInfoArray[0];
    
    
}

@end

//OpengfireServerInfo
@implementation OpengfireServerInfo

+ (id)OpengfireServerInfoWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    OpengfireServerInfo* _OpengfireServerInfo = [[OpengfireServerInfo alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"OpengfireServerInfoResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"OpengfireServerInfoResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                NSString* jsonString = [resultElement stringValue];
                NSDictionary* dic = [jsonString JSONValue];                
                if ([dic isKindOfClass:[NSDictionary class]]) {                    
                    _OpengfireServerInfo.OpengfireServerInfo = [dic valueForKeyNotNull:@"OpengfireServerInfo"];
                    _OpengfireServerInfo.Openfire_HostName = [dic valueForKeyNotNull:@"Openfire_HostName"];
                }
            }
        }
    }
    return _OpengfireServerInfo;
}

@end

//
@implementation UserPhoto

+ (id)UserPhotoWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    UserPhoto* userphoto = [[UserPhoto alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"UserPhotoResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"UserPhotoResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                 userphoto.photo = [resultElement stringValue];
            }
        }
    }
    return userphoto;
}

@end
//InsertStudentDocumentationGetIDResponse
@implementation InsertStudentDocumentationGetIDResponse
@synthesize InsertStudentDocumentationGetIDMessage;

+ (id)InsertStudentDocumentationGetIDResponseWithDDXMLDocument:(DDXMLDocument*)document
{
    
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    InsertStudentDocumentationGetIDResponse* studentDocumentActionResponse = [[InsertStudentDocumentationGetIDResponse alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"InsertStudentDocumentationGetIDResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"InsertStudentDocumentationGetIDResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                studentDocumentActionResponse.InsertStudentDocumentationGetIDMessage = [resultElement stringValue];
                
            }
        }
    }
    return studentDocumentActionResponse;
}

@end

//20140209herry
@implementation UpdateHeadPhotoResponse

@synthesize updateHeadPhotoMessage;
+ (id)updateHeadPhotoResponseWithDDXMLDocument:(DDXMLDocument*)document
{
    
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    UpdateHeadPhotoResponse* headphotoponse = [[UpdateHeadPhotoResponse alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"UserHeadPhotoResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"UserHeadPhotoResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                headphotoponse.updateHeadPhotoMessage = [resultElement stringValue];
                
            }
        }
    }
    return headphotoponse;
}

@end

@implementation UpdateUserNameResponse
@synthesize updateUsernameMessage;

+ (id)updateUserNameResponseWithDDXMLDocument:(DDXMLDocument*)document
{
    
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    UpdateUserNameResponse* usernameponse = [[UpdateUserNameResponse alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"ChangeUsernameResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"ChangeUsernameResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                usernameponse.updateUsernameMessage = [resultElement stringValue];
                
            }
        }
    }
    return usernameponse;
    
}
@end


@implementation UpdatepasswordResponse

@synthesize  updatePasswordMessage;

+ (id)updatePasswordResponseWithDDXMLDocument:(DDXMLDocument*)document
{
    
    
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    UpdatepasswordResponse* passwordponse = [[UpdatepasswordResponse alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"ChangePasswordResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"ChangePasswordResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                passwordponse.updatePasswordMessage = [resultElement stringValue];
                
            }
        }
    }
    return passwordponse;
    
    
}

@end



//SetMobileToken
@implementation SetMobileTokenResponse

+ (id)SetMobileTokenResponseWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    SetMobileTokenResponse* mresponse = [[SetMobileTokenResponse alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"SetMobileTokenResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"SetMobileTokenResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                mresponse.SetMobileToken = [resultElement stringValue];
            }
        }
    }
    return mresponse;
}

@end


//user login out

@implementation  UserLoginOutResponse

@synthesize userLoginOutMessage;

+ (id)userLoginOutResponseWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    UserLoginOutResponse* userLoginOutReponse = [[UserLoginOutResponse alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"UserLoginOutResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"UserLoginOutResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                userLoginOutReponse.userLoginOutMessage = [resultElement stringValue];
                
            }
        }
    }
    return userLoginOutReponse;
    
}

@end


//SelecRequestStudentInfoByRequestId
@implementation SelecRequestStudentInfoByRequestId
@synthesize studentId;
@synthesize lastName;
@synthesize firstName;
@synthesize locationName;


+ (NSMutableArray*)SelecRequestStudentInfoByRequestIdWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    NSMutableArray* studentRequestInfoArray = [[NSMutableArray alloc] init];
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return studentRequestInfoArray;
    }
    DDXMLElement* bodyElement = [enveElement elementForName:@"GetTutorReauestStudentByRequestIdResponse"];
    if (!bodyElement) {
        return studentRequestInfoArray;
    }
    DDXMLElement* resultElement = [bodyElement elementForName:@"GetTutorReauestStudentByRequestIdResult"];
    if (!resultElement) {
        return studentRequestInfoArray;
    }
    NSString* string = [resultElement description];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:diffgram" withString:@"diff"];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:before" withString:@"diff_before"];
    DDXMLDocument* doc = [[DDXMLDocument alloc] initWithXMLString:string options:0 error:nil];
    resultElement = [doc rootElement];
    DDXMLElement* diffElement = [resultElement elementForName:@"diff"];
    if (!diffElement) {
        return studentRequestInfoArray;
    }
    DDXMLElement* arrarElement = [diffElement elementForName:@"NewDataSet"];
    NSArray* arrays = [arrarElement elementsForName:@"Table"];
    
    if (arrays.count > 0) {
        for (int i = 0; i < arrays.count; i++) {
            
            DDXMLElement* request = [arrays objectAtIndex:i];
            SelecRequestStudentInfoByRequestId* info = [[SelecRequestStudentInfoByRequestId alloc] init];
            DDXMLElement* studid = [request elementForName:@"stu_ID"];
            //NSString *id=[studid stringValue];
            info.studentId = [studid stringValue];
            
            DDXMLElement* lastname = [request elementForName:@"last_name"];
            // NSString *fiame=[lastname stringValue];
            
            info.lastName = [lastname stringValue];
            
            DDXMLElement* firstName = [request elementForName:@"first_name"];
            info.firstName = [firstName stringValue];
            DDXMLElement* location = [request elementForName:@"loc_name"];
            info.locationName = [location stringValue];
            DDXMLElement* gradYear = [request elementForName:@"hs_grad"];
            info.stuGradYear = [gradYear stringValue];
            DDXMLElement* gradSchool = [request elementForName:@"school"];
            info.stuGradSchool = [gradSchool stringValue];
            
            DDXMLElement* stuPhone = [request elementForName:@"phone"];
            info.stuPhone = [stuPhone stringValue];
            DDXMLElement* pHomePhone = [request elementForName:@"home_phone"];
            info.homePhone = [pHomePhone stringValue];
            
            DDXMLElement* pContactPhone = [request elementForName:@"contact_phone"];
            info.contactPhone = [pContactPhone stringValue];
            DDXMLElement* pName = [request elementForName:@"pname"];
            info.parentName = [pName stringValue];
            DDXMLElement* pEmail = [request elementForName:@"pemail"];
            info.parentEmail = [pEmail stringValue];
            DDXMLElement* stuEmail = [request elementForName:@"semail"];
            info.stuEmail = [stuEmail stringValue];
            
            
            [studentRequestInfoArray addObject:info];
        }
    }
    
    NSLog(@"loc:%ld", studentRequestInfoArray.count);
    return studentRequestInfoArray;
    
}

@end


@implementation SelectWaitingRequestBytutor
@synthesize studentName;
@synthesize studentId;
@synthesize subjectName;
@synthesize locationName;
@synthesize requestId;
@synthesize createDate;
@synthesize isRead;
+ (NSMutableArray*)SelectWaitingRequestBytutorWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    NSMutableArray* waitingRequestArray = [[NSMutableArray alloc] init];
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return waitingRequestArray;
    }
    DDXMLElement* bodyElement = [enveElement elementForName:@"GetTuturWaitingReauestResponse"];
    if (!bodyElement) {
        return waitingRequestArray;
    }
    DDXMLElement* resultElement = [bodyElement elementForName:@"GetTuturWaitingReauestResult"];
    if (!resultElement) {
        return waitingRequestArray;
    }
    NSString* string = [resultElement description];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:diffgram" withString:@"diff"];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:before" withString:@"diff_before"];
    DDXMLDocument* doc = [[DDXMLDocument alloc] initWithXMLString:string options:0 error:nil];
    resultElement = [doc rootElement];
    DDXMLElement* diffElement = [resultElement elementForName:@"diff"];
    if (!diffElement) {
        return waitingRequestArray;
    }
    DDXMLElement* arrarElement = [diffElement elementForName:@"NewDataSet"];
    NSArray* arrays = [arrarElement elementsForName:@"Table"];
    if (arrays.count > 0) {
        for (int i = 0; i < arrays.count; i++) {
            DDXMLElement* request = [arrays objectAtIndex:i];
            SelectWaitingRequestBytutor* info = [[SelectWaitingRequestBytutor alloc] init];
            DDXMLElement* studentId = [request elementForName:@"stu_id"];
            info.studentId = [studentId stringValue];
            
            DDXMLElement* studentFullName = [request elementForName:@"sfull_name"];
            info.studentName = [studentFullName stringValue];
            NSLog(@"student full name is :%@", info.studentName);
            
            DDXMLElement* location_Name = [request elementForName:@"loc_name"];
            info.locationName = [location_Name stringValue];
            DDXMLElement* subject_Name = [request elementForName:@"sub_name"];
            info.subjectName = [subject_Name stringValue];
            DDXMLElement* requestid= [request elementForName:@"tr_ID"];
            info.requestId = [requestid stringValue];
            DDXMLElement* createTime= [request elementForName:@"create_time"];
            info.createDate = [createTime stringValue];
            
            DDXMLElement* readState= [request elementForName:@"read"];
            info.isRead = [readState stringValue];
            
            [waitingRequestArray addObject:info];
        }
    }
    
    NSLog(@"loc:%ld", waitingRequestArray.count);
    return waitingRequestArray;
    
    
}
@end


@implementation SelecRequestInfoByRequestId
@synthesize subjectName;
@synthesize firstmeetingtime;
@synthesize note;

+ (NSMutableArray*)SelecRequestInfoByRequestIdWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    NSMutableArray* requestInfoArray = [[NSMutableArray alloc] init];
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return requestInfoArray;
    }
    DDXMLElement* bodyElement = [enveElement elementForName:@"GetReauestByRequestIdResponse"];
    if (!bodyElement) {
        return requestInfoArray;
    }
    DDXMLElement* resultElement = [bodyElement elementForName:@"GetReauestByRequestIdResult"];
    if (!resultElement) {
        return requestInfoArray;
    }
    NSString* string = [resultElement description];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:diffgram" withString:@"diff"];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:before" withString:@"diff_before"];
    DDXMLDocument* doc = [[DDXMLDocument alloc] initWithXMLString:string options:0 error:nil];
    resultElement = [doc rootElement];
    DDXMLElement* diffElement = [resultElement elementForName:@"diff"];
    if (!diffElement) {
        return requestInfoArray;
    }
    DDXMLElement* arrarElement = [diffElement elementForName:@"NewDataSet"];
    NSArray* arrays = [arrarElement elementsForName:@"Table"];
    if (arrays.count > 0) {
        for (int i = 0; i < arrays.count; i++) {
            DDXMLElement* request = [arrays objectAtIndex:i];
            SelecRequestInfoByRequestId* info = [[SelecRequestInfoByRequestId alloc] init];
            DDXMLElement* subjectName = [request elementForName:@"sub_name"];
            info.subjectName = [subjectName stringValue];
            DDXMLElement* note = [request elementForName:@"notes"];
            info.note = [note stringValue];
            DDXMLElement* firstmeettime = [request elementForName:@"meet_time"];
            //
            
            
            if (firstmeettime && ![firstmeettime isKindOfClass:[NSNull class]]) {
                NSString* dateS = [firstmeettime stringValue];
                dateS = [dateS substringToIndex:16];
                dateS = [dateS stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                NSLog(@"dates:%@", dateS);
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSDate* date = [formatter dateFromString:dateS];
                if (date) {
                    [formatter setDateFormat:@"MM/dd/yyyy HH:mm"];
                    info.firstmeetingtime = [firstmeettime stringValue];
                }
            }
            [requestInfoArray addObject:info];
        }
    }
    
    NSLog(@"loc:%ld", requestInfoArray.count);
    return requestInfoArray;
    
}
@end

@implementation SelectMatchedStudentFortutor
@synthesize studentName;
@synthesize studentId;
@synthesize email;
@synthesize phone;
@synthesize gradyear;
@synthesize gradschool;

+ (NSMutableArray*)SelectMatchedStudentFortutorWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    NSMutableArray* matchedStudentArray = [[NSMutableArray alloc] init];
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return matchedStudentArray;
    }
    DDXMLElement* bodyElement = [enveElement elementForName:@"GetStudentByTutorIdResponse"];
    if (!bodyElement) {
        return matchedStudentArray;
    }
    DDXMLElement* resultElement = [bodyElement elementForName:@"GetStudentByTutorIdResult"];
    if (!resultElement) {
        return matchedStudentArray;
    }
    NSString* string = [resultElement description];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:diffgram" withString:@"diff"];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:before" withString:@"diff_before"];
    DDXMLDocument* doc = [[DDXMLDocument alloc] initWithXMLString:string options:0 error:nil];
    resultElement = [doc rootElement];
    DDXMLElement* diffElement = [resultElement elementForName:@"diff"];
    if (!diffElement) {
        return matchedStudentArray;
    }
    DDXMLElement* arrarElement = [diffElement elementForName:@"NewDataSet"];
    NSArray* arrays = [arrarElement elementsForName:@"Table"];
    if (arrays.count > 0) {
        for (int i = 0; i < arrays.count; i++) {
            DDXMLElement* request = [arrays objectAtIndex:i];
            SelectMatchedStudentFortutor* info = [[SelectMatchedStudentFortutor alloc] init];
            DDXMLElement* studentId = [request elementForName:@"stu_ID"];
            info.studentId = [studentId stringValue];
            
            DDXMLElement* studentFullName = [request elementForName:@"full_name"];
            info.studentName = [studentFullName stringValue];
            NSLog(@"student full name is :%@", info.studentName);
            
            DDXMLElement* phone = [request elementForName:@"phone"];
            info.phone = [phone stringValue];
            DDXMLElement* email = [request elementForName:@"email"];
            info.email = [email stringValue];
            DDXMLElement* gradYear = [request elementForName:@"hs_grad"];
            info.gradyear = [gradYear stringValue];
            DDXMLElement* gradSchool = [request elementForName:@"school"];
            info.gradschool = [gradSchool stringValue];
            [matchedStudentArray addObject:info];
        }
    }
    
    NSLog(@"loc:%ld", matchedStudentArray.count);
    return matchedStudentArray;
    
}

@end


@implementation UpdateTutorAccept

@synthesize updateAcceptMessage;

+ (id)updateTutorAcceptWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    UpdateTutorAccept* tutorAccept = [[UpdateTutorAccept alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"AccpptRequestBytutorResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"AccpptRequestBytutorResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                tutorAccept.updateAcceptMessage = [resultElement stringValue];
                // NSString *s=[resultElement stringValue];
                
                
            }
        }
    }
    return tutorAccept;
    
}

@end



//GetTutorRecentPaymentAndTutorTotalHour

@implementation GetTutorPaymentAndTotalHour
@synthesize tutorPaymentAndHour;
+(id)tutorPaymentAndTotalHourWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }

    GetTutorPaymentAndTotalHour *getTutorPaymentAndTotalHour=[[GetTutorPaymentAndTotalHour alloc]init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"GetTutorRecentPaymentAndTutorTotalHourResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"GetTutorRecentPaymentAndTutorTotalHourResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                getTutorPaymentAndTotalHour.tutorPaymentAndHour = [resultElement stringValue];
                // NSString *s=[resultElement stringValue];
                
                
            }
        }
    }
    return getTutorPaymentAndTotalHour.tutorPaymentAndHour;

}



@end


//parent
@implementation SelectMeetingMinuteByStudent

+ (NSMutableArray *)selectMeetingMinuteByStudentWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    NSMutableArray* locationArray = [[NSMutableArray alloc] init];
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return locationArray;
    }
    DDXMLElement* bodyElement = [enveElement elementForName:@"GetMeetingMinuteResponse"];
    if (!bodyElement) {
        return locationArray;
    }
    DDXMLElement* resultElement = [bodyElement elementForName:@"GetMeetingMinuteResult"];
    if (!resultElement) {
        return locationArray;
    }
    NSString* string = [resultElement description];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:diffgram" withString:@"diff"];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:before" withString:@"diff_before"];
    DDXMLDocument* doc = [[DDXMLDocument alloc] initWithXMLString:string options:0 error:nil];
    resultElement = [doc rootElement];
    DDXMLElement* diffElement = [resultElement elementForName:@"diff"];
    if (!diffElement) {
        return locationArray;
    }
    DDXMLElement* arrarElement = [diffElement elementForName:@"NewDataSet"];
    NSArray* arrays = [arrarElement elementsForName:@"Table"];
    if (arrays.count > 0) {
        for (int i = 0; i < arrays.count; i++) {
            DDXMLElement* location = [arrays objectAtIndex:i];
            SelectMeetingMinuteByStudent* info = [[SelectMeetingMinuteByStudent alloc] init];
            DDXMLElement* loc_id = [location elementForName:@"student_ID"];
            info.studentId = [loc_id stringValue];
            //DDXMLElement* tutor_id = [location elementForName:@"tutor_ID"];
            // info.studentName = [tutor_id stringValue];
            DDXMLElement* loc_note = [location elementForName:@"notes"];
            info.note = [loc_note stringValue];
            NSLog(@"note is :%@", info.note);
            //DDXMLElement* loc_name1 = [location elementForName:@"location"];
            /// info.avatarUrl = [loc_name1 stringValue];
            // DDXMLElement* loc_name2 = [location elementForName:@"sub_name"];
            DDXMLElement* loc_date = [location elementForName:@"interview_date"];
            if (loc_date && ![loc_date isKindOfClass:[NSNull class]]) {
                NSString* dateS = [loc_date stringValue];
                dateS = [dateS substringToIndex:16];
                dateS = [dateS stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                NSLog(@"dates:%@", dateS);
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSDate* date = [formatter dateFromString:dateS];
                if (date) {
                    [formatter setDateFormat:@"MM/dd/yyyy"];
                    info.interDate =[formatter stringFromDate:date];
                }
            }
            [locationArray addObject:info];
        }
    }
    
    NSLog(@"loc:%ld", locationArray.count);
    return locationArray;
    
}
@end

@implementation SelectStudentByParent
@synthesize studentId;
@synthesize lastName;
@synthesize firstName;
@synthesize stuPhoto;

+ (NSMutableArray *)selectStudentByParentWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    NSMutableArray* locationArray = [[NSMutableArray alloc] init];
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return locationArray;
    }
    DDXMLElement* bodyElement = [enveElement elementForName:@"SelectStudentByParentResponse"];
    if (!bodyElement) {
        return locationArray;
    }
    DDXMLElement* resultElement = [bodyElement elementForName:@"SelectStudentByParentResult"];
    if (!resultElement) {
        return locationArray;
    }
    NSString* string = [resultElement description];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:diffgram" withString:@"diff"];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:before" withString:@"diff_before"];
    DDXMLDocument* doc = [[DDXMLDocument alloc] initWithXMLString:string options:0 error:nil];
    resultElement = [doc rootElement];
    DDXMLElement* diffElement = [resultElement elementForName:@"diff"];
    if (!diffElement) {
        return locationArray;
    }
    DDXMLElement* arrarElement = [diffElement elementForName:@"NewDataSet"];
    NSArray* arrays = [arrarElement elementsForName:@"Table"];
    if (arrays.count > 0) {
        for (int i = 0; i < arrays.count; i++) {
            DDXMLElement* location = [arrays objectAtIndex:i];
            SelectStudentByParent* info = [[SelectStudentByParent alloc] init];
            DDXMLElement* stuid = [location elementForName:@"stu_ID"];
            info.studentId = [stuid stringValue];
            
            DDXMLElement* firstname = [location elementForName:@"first_name"];
            info.firstName = [firstname stringValue];
            
            DDXMLElement* lastname = [location elementForName:@"last_name"];
            info.lastName = [lastname stringValue];

            DDXMLElement* stuPhoto = [location elementForName:@"photo"];
            info.stuPhoto = [stuPhoto stringValue];
            
            [locationArray addObject:info];
        }
    }
    
    NSLog(@"loc:%ld", locationArray.count);
    return locationArray;
    
}
@end

@implementation studentDocumentTypeInfo

+ (NSMutableArray*)studentDocumentTypeArrayWithXMLDocument:(DDXMLDocument *)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    NSMutableArray* studentDocumentTypeArray = [[NSMutableArray alloc] init];
    DDXMLElement* enveElement = [rootElement elementForName:@"soap:Body"];
    if (!enveElement) {
        return studentDocumentTypeArray;
    }
    DDXMLElement* bodyElement = [enveElement elementForName:@"StudentDocumentTypeResponse"];
    if (!bodyElement) {
        return studentDocumentTypeArray;
    }
    DDXMLElement* resultElement = [bodyElement elementForName:@"StudentDocumentTypeResult"];
    if (!resultElement) {
        return studentDocumentTypeArray;
    }
    NSString* string = [resultElement description];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:diffgram" withString:@"diff"];
    string = [string stringByReplacingOccurrencesOfString:@"diffgr:before" withString:@"diff_before"];
    DDXMLDocument* doc = [[DDXMLDocument alloc] initWithXMLString:string options:0 error:nil];
    resultElement = [doc rootElement];
    DDXMLElement* diffElement = [resultElement elementForName:@"diff"];
    if (!diffElement) {
        return studentDocumentTypeArray;
    }
    DDXMLElement* arrarElement = [diffElement elementForName:@"NewDataSet"];
    if (!arrarElement) {
        return studentDocumentTypeArray;
    }
    NSArray* arrays = [arrarElement elementsForName:@"Table"];
    if (arrays.count > 0) {
        for (int i = 0; i < arrays.count; i++) {
            DDXMLElement* studentDocumentType = [arrays objectAtIndex:i];
            studentDocumentTypeInfo* info = [[studentDocumentTypeInfo alloc] init];
            DDXMLElement* document_type_id = [studentDocumentType elementForName:@"document_type_id"];
            info.document_type_id = [[document_type_id stringValue] intValue];
            DDXMLElement* document_type_name = [studentDocumentType elementForName:@"document_type_name"];
            info.document_type_name = [document_type_name stringValue];
            [studentDocumentTypeArray addObject:info];
            NSLog(@"studentDocumentType:%d, %@", info.document_type_id, info.document_type_name);
        }
    }
    {
        DDXMLElement* arrarElement = [diffElement elementForName:@"diff_before"];
        if (!arrarElement) {
            return studentDocumentTypeArray;
        }
        NSArray* arrays = [arrarElement elementsForName:@"Table"];
        if (arrays.count > 0) {
            for (int i = 0; i < arrays.count; i++) {
                DDXMLElement* studentDocumentType = [arrays objectAtIndex:i];
                studentDocumentTypeInfo* info = [[studentDocumentTypeInfo alloc] init];
                DDXMLElement* document_type_id = [studentDocumentType elementForName:@"document_type_id"];
                info.document_type_id = [[document_type_id stringValue] intValue];
                DDXMLElement* document_type_name = [studentDocumentType elementForName:@"document_type_name"];
                info.document_type_name = [document_type_name stringValue];
                [studentDocumentTypeArray addObject:info];
            }
        }
    }
    NSLog(@"studentDocumentTypeCount:%ld", studentDocumentTypeArray.count);
    return studentDocumentTypeArray;
}

@end

//ConsultantTypeResponse
@implementation ConsultantTypeResponse
@synthesize info;

+ (id)ConsultantTypeResponseWithDDXMLDocument:(DDXMLDocument*)document
{
    
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    ConsultantTypeResponse* _consultantTypeResponse = [[ConsultantTypeResponse alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"ConsultantTypeResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"ConsultantTypeResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                _consultantTypeResponse.info = [resultElement stringValue];
                
            }
        }
    }
    return _consultantTypeResponse;
}

@end

//timesheet student's subject and location

@implementation TimeSheetSubjectAndLoction

@synthesize returnStr;

+ (id)timeSheetSubjectAndLoctionWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    TimeSheetSubjectAndLoction* timesheetInfo = [[TimeSheetSubjectAndLoction alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"TimesheetSubjectAndLocationResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"TimesheetSubjectAndLocationResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
               timesheetInfo.returnStr = [resultElement stringValue];
               
            }
        }
    }
    return timesheetInfo;
}

@end

//CreatedContract

@implementation CreatedContract

@synthesize returnStr;

+ (id)CreatedContractWithDDXMLDocument:(DDXMLDocument*)document
{
    DDXMLElement* rootElement = [document rootElement];
    if (!rootElement) {
        return nil;
    }
    CreatedContract* createdContract = [[CreatedContract alloc] init];
    NSArray* envelop = [rootElement elementsForName:@"soap:Body"];
    if (envelop.count > 0) {
        DDXMLElement* enveElement = [envelop objectAtIndex:0];
        NSArray* body = [enveElement elementsForName:@"CreatedContractResponse"];
        if (body.count > 0) {
            DDXMLElement* bodyElement = [body objectAtIndex:0];
            NSArray* response = [bodyElement elementsForName:@"CreatedContractResult"];
            if (response.count > 0) {
                DDXMLDocument* resultElement = [response objectAtIndex:0];
                createdContract.returnStr = [resultElement stringValue];
                
            }
        }
    }
    return createdContract;
}

@end

