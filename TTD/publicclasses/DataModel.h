//
//  DataModel.h
//  TTD
//
//  Created by ZhangChuntao on 12/10/12.
//  Copyright (c) 2012 totem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXMLDocument.h"

#define STATUS_DRAFT        @"Draft"
#define STATUS_PENDING      @"Pengind"
#define STATUS_FIRST_APPROVAL   @"First Approval"
#define STATUS_REJECTED         @"Rejected"
#define STATUS_DELETED          @"Deleted"
#define STATUS_FINAL_APPROVAL   @"Final Approval"

@interface NSDictionary (NullReplace)

- (id)valueForKeyNotNull:(NSString*)key;

@end

@interface LoginResponse : NSObject
@property (nonatomic) BOOL state;
@property (strong, nonatomic) NSString* responseMessage;

+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;

@end

//zn 新建Metting 接口
@interface ZNgetmettings : NSObject
@property (strong, nonatomic) NSString* getMettingsStr;
+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;

@end

// 获取tokboxsession
@interface ZNgetTokBoxSession :NSObject
@property (strong,nonatomic)NSString * tokgetTokboxSessionByMobile;
+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;
@end
//获取tokboxtoken
@interface ZNgetTokBoxToken :NSObject
@property (strong,nonatomic)NSString * getTokBoxToken;
+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;
@end
//获取经理顾问首页接口数据2
@interface ZNgetAllToDoTasks :NSObject
@property (strong,nonatomic)NSString * getAllToDoTasks;
+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;
@end
//获取经理顾问首页接口数据1
@interface ZNgetConsultantThinktanKlearningService:NSObject
@property (strong,nonatomic)NSString * getconstultant;
+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;
@end
//获取经理顾问首页接口数据3
@interface ZNgetUPCOMINGMEETING:NSObject
@property (strong,nonatomic)NSString * getupcomingmetting;
+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;
@end
//获取getALLEA
@interface ZNgetALLEA:NSObject
@property (strong,nonatomic)NSString * getALLEA;
+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;
@end
//获取gettest
@interface ZNgetTests:NSObject
@property (strong,nonatomic)NSString * getTests;
+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;
@end
//学生allinfo
@interface ZNgetStudentAllInfo:NSObject
@property (strong,nonatomic)NSString * getallinfo;
+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;
@end
//学生progress
@interface ZNgetStudentProgress:NSObject
@property (strong,nonatomic)NSString * getProgress;
+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;
@end
//学生getStudentTasks
@interface ZNgetStudentTasks:NSObject
@property (strong,nonatomic)NSString *getStudentTasks;
+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;
@end
//学生getStudentAcademics
@interface ZNgetStudentAcademics:NSObject
@property (strong,nonatomic)NSString *getStudentAcademics;
+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;
@end
//DelEas
@interface ZNDelEAs:NSObject
@property (strong,nonatomic)NSString * deleas;
+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;
@end
//getchatnews
@interface ZNgetChatNews:NSObject
@property (nonatomic,strong)NSString *chatnews;
+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;
@end
//setToDoTasks
@interface ZNsetToDoTasks:NSObject
@property (nonatomic,strong)NSString * setToDoTasks;
+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;
@end
//AddExtracurricularActivitiesByVCS
@interface ZNAddExtracurricularActivitiesByVCS:NSObject
@property (nonatomic,strong)NSString *AddExtracurricularActivitiesByVCS;
+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;
@end
//AddExtracurricularActivitiesByWE
@interface ZNAddExtracurricularActivitiesByWE:NSObject
@property (nonatomic,strong)NSString *AddExtracurricularActivitiesByWE;
+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;
@end
//AddExtracurricularActivitiesByEA
@interface ZNAddExtracurricularActivitiesByEA:NSObject
@property (nonatomic,strong)NSString *AddExtracurricularActivitiesByEA;
+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;
@end


@interface UserFullNameResponse : NSObject
@property (nonatomic, strong) NSString* userFullName;

+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;

@end

@interface OpenfireUserResponse : NSObject
@property (nonatomic, strong) NSString* info;

+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;

@end

@interface OpengfireChangeUserPasswordResponse : NSObject
@property (nonatomic, strong) NSString* info;

+ (id)responseWithDDXMLDocument:(DDXMLDocument*)document;

@end

@interface LocationInfo : NSObject
@property (nonatomic) int locId;
@property (nonatomic, strong) NSString* locName;

+ (NSMutableArray*)locationArrayWithXMLDocument:(DDXMLDocument*)document;

@end

@interface RatioInfo : NSObject
@property (nonatomic, strong) NSString* type;
@property (nonatomic) int ratioId;

+ (NSMutableArray*)arrayWithXMLDocument:(DDXMLDocument*)document;

@end

@interface DurationInfo : NSObject
@property (nonatomic, strong) NSString* durationString;
@property (nonatomic) CGFloat durationID;

+ (NSMutableArray*)arrayWithXMLDocument:(DDXMLDocument*)document;

@end

@interface StudentInfo : NSObject

@property (strong, nonatomic) NSString* studentName;
@property (nonatomic) int studentId;

+ (NSMutableArray*)studentsArrayWithDDXMLDocument:(DDXMLDocument*)document;

@end

@interface NoShowInfo : NSObject

@property (strong, nonatomic) NSString* NoShowString;
@property (strong, nonatomic) NSString* NoShowValue;
+ (NSMutableArray*)NoShowArrayWithXMLDocument:(DDXMLDocument*)document;
@end

@interface SubjectInfo : NSObject

@property (strong, nonatomic) NSString* subjectName;
@property (nonatomic) int subjectId;
@property (nonatomic) int tutorId;

+ (NSMutableArray*)subjectsArrayWithXMLDocument:(DDXMLDocument*)document;

@end

@interface TimeSheetSummary : NSObject
@property (nonatomic, strong) NSString* location;
@property (nonatomic, strong) NSString* timeSheetDate;
@property (nonatomic, strong) NSString* students;
@property (nonatomic, strong) NSString* timeSheetState;
@property (nonatomic, strong) NSString* timeSheetId;
@property (nonatomic, strong) NSString* subjectId;
@property (nonatomic, strong) NSString* subName;
@property (nonatomic, strong) NSString* totur;
@property (nonatomic, strong) NSString* source;
@property (nonatomic, strong) NSString* noshow;
@property (nonatomic, strong) NSString* app_status;
@property (nonatomic, strong) NSString* studentname;
+ (id)timeSheetSummaryWithDDXMLDocument:(DDXMLDocument*)document;

@end

@interface InsertTimeSheetResponse : NSObject
@property (nonatomic, strong) NSString* responseMessage;
@property (nonatomic) BOOL succeed;

+ (id)insertTimeSheetResponseWithDDXMLDocument:(DDXMLDocument*)document;

@end

@interface UpdateTimeSheetResponse : NSObject
@property (nonatomic, strong) NSString* responseMessage;
@property (nonatomic) BOOL succeed;

+ (id)updateTimeSheetResponseWithDDXMLDocument:(DDXMLDocument*)document type:(int)type;

@end

@interface TimeSheetSession : NSObject
@property (nonatomic, strong) NSDate* date;
@property (nonatomic, strong) NSString* note;
@property (nonatomic, strong) NSString* studentId;
@property (nonatomic, strong) NSString* duration;
@property (nonatomic, strong) NSString* noshow;
@end

@interface TimeSheet : NSObject
@property (strong, nonatomic) NSMutableArray* sessionArray;
@property (strong, nonatomic) TimeSheetSummary* summary;
@property (nonatomic) int type;
//type 0:web   1:mobile
+ (TimeSheet*)timeSheetWithXMLDoc:(DDXMLDocument*)document type:(int)type;

@end

@interface UserInfo : NSObject
@property (strong, nonatomic) NSString* avatarUrl;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* userFullName;

+ (UserInfo*)userInfoWithDDXMLDocument:(DDXMLDocument*)document;

@end

@interface UpdateInfo : NSObject
@property (nonatomic, strong) NSString* updateUrl;
@property (nonatomic) BOOL hasNewVersion;

+ (UpdateInfo*)updateInfoWithDDXMLDocument:(DDXMLDocument*)document;

@end




@interface ManagerViewStudents : NSObject
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* studentname;
@property (nonatomic, strong) NSString* photo;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* loc_name;
@property (nonatomic, strong) NSString* phone;
@property (nonatomic, strong) NSString* stu_id;

+ (id)managerViewStudentsWithDDXMLDocument:(DDXMLDocument*)document;
@end

@interface ViewStudentsBySearch : NSObject
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* studentname;
@property (nonatomic, strong) NSString* photo;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* loc_name;
@property (nonatomic, strong) NSString* phone;
@property (nonatomic, strong) NSString* stu_id;

+ (id)ViewStudentsBySearchWithDDXMLDocument:(DDXMLDocument*)document;
@end

@interface StudentDetail: NSObject
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* stu_id;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* loc_name;
@property (nonatomic, strong) NSString* phone;
@property (nonatomic, strong) NSString* parent;
@property (nonatomic, strong) NSString* parent_home_phone;
@property (nonatomic, strong) NSString* parent_contact_phone;
@property (nonatomic, strong) NSString* parent_email;
@property (nonatomic, strong) NSString* language;
@property (nonatomic, strong) NSString* address;
@property (nonatomic, strong) NSString* photo;
+ (id)StudentDetailWithDDXMLDocument:(DDXMLDocument*)document;
@end

//Andy

@interface OpengfireServerInfo : NSObject
@property (nonatomic, strong) NSString* OpengfireServerInfo;
@property (nonatomic, strong) NSString* Openfire_HostName;
+ (OpengfireServerInfo*)OpengfireServerInfoWithDDXMLDocument:(DDXMLDocument*)document;

@end

@interface UserPhoto : NSObject
@property (nonatomic, strong) NSString* photo;
+ (UserPhoto*)UserPhotoWithDDXMLDocument:(DDXMLDocument*)document;

@end

//herry add--------------

//修改用户名
@interface UpdateUserNameResponse : NSObject

@property (strong, nonatomic) NSString* updateUsernameMessage;

+ (id)updateUserNameResponseWithDDXMLDocument:(DDXMLDocument*)document;

@end
//修改密码
@interface UpdatepasswordResponse : NSObject

@property (strong, nonatomic) NSString* updatePasswordMessage;

+ (id)updatePasswordResponseWithDDXMLDocument:(DDXMLDocument*)document;

@end


@interface InsertStudentDocumentationGetIDResponse : NSObject

@property (strong, nonatomic) NSString* InsertStudentDocumentationGetIDMessage;

+ (id)InsertStudentDocumentationGetIDResponseWithDDXMLDocument:(DDXMLDocument*)document;

@end

//修改头像
@interface UpdateHeadPhotoResponse : NSObject

@property (strong, nonatomic) NSString* updateHeadPhotoMessage;

+ (id)updateHeadPhotoResponseWithDDXMLDocument:(DDXMLDocument*)document;

@end

//Get Login Info
@interface SelectLoginInfo: NSObject

@property (strong, nonatomic) NSString* email;
@property (strong, nonatomic) NSString* photo;

+ (id)SelectLoginInfoWithDDXMLDocument:(DDXMLDocument*)document;

@end

//SetMobileToken
@interface SetMobileTokenResponse : NSObject

@property (strong, nonatomic) NSString* SetMobileToken;

+ (id)SetMobileTokenResponseWithDDXMLDocument:(DDXMLDocument*)document;

@property (strong, nonatomic) NSString* userLoginOutMessage;

+ (id)userLoginOutResponseWithDDXMLDocument:(DDXMLDocument*)document;

@end


//user login out

@interface UserLoginOutResponse : NSObject

@property (strong, nonatomic) NSString* userLoginOutMessage;

+ (id)userLoginOutResponseWithDDXMLDocument:(DDXMLDocument*)document;

@end


//SelecRequestStudentInfoByRequestId
@interface SelecRequestStudentInfoByRequestId : NSObject
@property (strong, nonatomic) NSString* studentId;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSString* firstName;
@property (nonatomic, strong) NSString* locationName;
@property (nonatomic, strong) NSString* stuEmail;
@property (nonatomic, strong) NSString* parentName;
@property (nonatomic, strong) NSString* parentEmail;
@property (nonatomic, strong) NSString* homePhone;
@property (nonatomic, strong) NSString* contactPhone;
@property (nonatomic, strong) NSString* stuGradYear;
@property (nonatomic, strong) NSString* stuGradSchool;
@property (nonatomic, strong) NSString* stuPhone;
+ (NSMutableArray*)SelecRequestStudentInfoByRequestIdWithDDXMLDocument:(DDXMLDocument*)document;

@end

//waiting request
@interface SelectWaitingRequestBytutor : NSObject
@property (strong, nonatomic) NSString* studentName;
@property (strong, nonatomic) NSString* studentId;
@property (nonatomic, strong) NSString* subjectName;
@property (nonatomic, strong) NSString* locationName;
@property (nonatomic, strong) NSString* requestId;
@property (nonatomic, strong) NSString* isRead;

@property(nonatomic,strong) NSString* createDate;

+ (NSMutableArray*)SelectWaitingRequestBytutorWithDDXMLDocument:(DDXMLDocument*)document;

@end

//SelecRequestInfoByRequestId
@interface SelecRequestInfoByRequestId : NSObject
@property (strong, nonatomic) NSString* subjectName;
@property (strong, nonatomic) NSString* firstmeetingtime;
@property (nonatomic, strong) NSString* note;

+ (NSMutableArray*)SelecRequestInfoByRequestIdWithDDXMLDocument:(DDXMLDocument*)document;

@end



//Matched Student For Tutor
@interface SelectMatchedStudentFortutor : NSObject
@property (strong, nonatomic) NSString* studentName;
@property (strong, nonatomic) NSString* studentId;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* phone;
@property (nonatomic, strong) NSString* gradyear;
@property (nonatomic, strong) NSString* gradschool;

+ (NSMutableArray*)SelectMatchedStudentFortutorWithDDXMLDocument:(DDXMLDocument*)document;

@end

//Tutor Accept Request
@interface UpdateTutorAccept : NSObject

@property (strong, nonatomic) NSString* updateAcceptMessage;

+ (id)updateTutorAcceptWithDDXMLDocument:(DDXMLDocument*)document;

@end

//GetTutorRecentPaymentAndTutorTotalHour

@interface GetTutorPaymentAndTotalHour : NSObject
@property(strong,nonatomic)NSString*tutorPaymentAndHour;
+(id)tutorPaymentAndTotalHourWithDDXMLDocument:(DDXMLDocument*)document;

@end

//herry add parent mode---------

//
@interface SelectMeetingMinuteByStudent : NSObject
@property (strong, nonatomic) NSString* avatarUrl;
@property (strong, nonatomic) NSString* studentName;
@property (strong, nonatomic) NSString* studentId;
@property (nonatomic, strong) NSString* interDate;
@property (nonatomic, strong) NSString* note;

+ (NSMutableArray*)selectMeetingMinuteByStudentWithDDXMLDocument:(DDXMLDocument*)document;

@end

//
@interface SelectStudentByParent : NSObject
@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSString* studentId;
@property (strong, nonatomic) NSString* stuPhoto;


+ (NSMutableArray*)selectStudentByParentWithDDXMLDocument:(DDXMLDocument*)document;

@end

@interface studentDocumentTypeInfo : NSObject
@property (nonatomic) int document_type_id;
@property (nonatomic, strong) NSString* document_type_name;

+ (NSMutableArray*)studentDocumentTypeArrayWithXMLDocument:(DDXMLDocument*)document;

@end

@interface ConsultantTypeResponse : NSObject

@property (strong, nonatomic) NSString* info;

+ (id)ConsultantTypeResponseWithDDXMLDocument:(DDXMLDocument*)document;

@end


@interface TimeSheetSubjectAndLoction : NSObject

@property (strong, nonatomic) NSString* returnStr;


+ (id)timeSheetSubjectAndLoctionWithDDXMLDocument:(DDXMLDocument*)document;

@end

// CreatedContract
@interface CreatedContract : NSObject

@property (strong, nonatomic) NSString* returnStr;


+ (id)CreatedContractWithDDXMLDocument:(DDXMLDocument*)document;

@end

