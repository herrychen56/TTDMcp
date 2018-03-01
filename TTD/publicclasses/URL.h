//
//  URL.h
//  TTD
//
//  Created by guligei on 12/7/12.
//  Copyright (c) 2012 totem. All rights reserved.
//

////Test1 Server
//#define SERVER_URL                @"http://test.ttlearning.com.cn/MobileAppWebService/MobileWebService.asmx"
//#define WEBTTD_URL                @"http://test.ttlearning.com.cn/login/login.aspx"

//Test1 Server
//#define SERVER_URL                @"http://quweijie.51mypc.cn/MobileAppWebService/MobileWebService.asmx"
//#define WEBTTD_URL                @"http://quweijie.51mypc.cn/login/login.aspx"

//Test2 Server
//#define SERVER_URL                  @"http://ttdserver.ttlearning.com.cn/MobileAppWebService/MobileWebService.asmx"
//#define WEBTTD_URL                  @"http://ttdserver.ttlearning.com.cn/login/login.aspx"




//TTLHOME Server
#define SERVER_URL                @"https://www.ttlhome.com/MobileAppWebService/MobileWebService.asmx"
#define WEBTTD_URL                @"https://www.ttlhome.com/login/login.aspx"
//#define WEBRTC_URL                @"https://consulting.ttlhome.com/WebService/Document.asmx"
#define WEBRTC_URL                @"https://consulting.ttlhome.com/WebService/MeetingDay.asmx"
#define ZNWEBRTC_URL              @"https://consulting.ttlhome.com/WebService/Document.asmx"

//TTLCHINA Server
//#define SERVER_URL                @"http://ttd.ttlearning.com.cn/MobileAppWebService/MobileWebService.asmx"
//#define WEBTTD_URL                @"http://ttd.ttlearning.com.cn/login/login.aspx"




//Test3 Server  http://testrtc.ttlhome.com
//#define SERVER_URL                @"http://test.ttlhome.com/MobileAppWebService/MobileWebService.asmx"
//#define WEBTTD_URL                @"http://test.ttlhome.com/login/login.aspx"
//#define WEBRTC_URL                @"http://testrtc.ttlhome.com/WebService/MeetingDay.asmx"
//#define ZNWEBRTC_URL              @"http://testrtc.ttlhome.com/WebService/Document.asmx"


//Test3 Server  http://testrtc.ttlhome.com
//#define SERVER_URL                @"http://192.168.1.6:807/MobileAppWebService/MobileWebService.asmx"
//#define WEBTTD_URL                @"http://124.126.203.247:807/login/login.aspx"
//#define WEBRTC_URL                @"http://124.126.203.247:808/WebService/MeetingDay.asmx"
//#define ZNWEBRTC_URL                @"http://124.126.203.247:808/WebService/Document.asmx"

//#define WEBRTC_URL                @"http://testrtc.ttlhome.com/WebService/MeetingDay.asmx"
//WebService Function
#define FUNC_LOGIN                   @"UserLogin"
#define FUNC_GET_USER_FULL_NAME      @"GetUserFullName"
#define FUNC_GET_USER_INFO           @"GetUserInfo"
#define FUNC_UPDATE_INFO             @"UpdateInfo"
#define FUNC_LOCATION                @"Location"
#define FUNC_TIMESHEET_DURATION      @"TimeSheetDuration"
#define FUNC_TIMESHEET_TOTIO         @"TimeSheetTotio"
#define FUNC_TIMESHEET_SUBJECT       @"TimeSheetSubject"
#define FUNC_TIMESHEET_LIST          @"TimeSheetList"
#define FUNC_TIMESHEET_STUDENT       @"TimeSheetStudent"
#define FUNC_TIMESHEET_SUMMARY       @"TimeSheetList"
#define FUNC_INSERT_TIMESHEET        @"InsertTimesheet"
#define FUNC_TIMESHEET_MOBILE_DETAIL @"UploadTimeSheetByMobile"
#define FUNC_TIMESHEET_WEB_DETAIL    @"UploadTimeSheetByWeb"
#define FUNC_VIEWSTUDENTS            @"ViewStudents"
#define FUNC_VIEWSTUDENTSBYSEARCH    @"ViewStudentsBySearch"
#define FUNC_TIMESHEET_LISTPAGE      @"TimeSheetListPage"
#define FUNC_UPDATE_TIMESHEET        @"UpdateTimeSheetByMobile"
#define FUNC_UPDATE_TIMESHEET_WEB    @"UpdateTimeSheetByWeb"
#define FUNC_INSERTLOG               @"InsertLog"
#define FUNC_GET_STUDENT_INFO        @"GetStudentInfo"
#define FUNC_INSERT_STUDENT_DOCUMENTACTIONGETID @"InsertStudentDocumentationGetID"
#define FUNC_UPLOAD_DOCUMENT_FILE    @"UploadDocumentFile"
#define FUNC_STUDENTDOCUMENTTYPE     @"StudentDocumentType"
#define FUNC_CONSULTANTYPE           @"ConsultantType"
#define FUNC_GET_DOCUMENT_LIST       @"GetDocumentList"
#define FUNC_LOAD_DOCUMENT_THUMBNAIL @"LoadDocumentThumbnail"
#define FUNC_DOWNLOAD_DOCUMENT_FILE  @"DownLoadDocumentFile"
#define FUNC_GET_EAS_ALL             @"GetEAsAll"
#define FUNC_GET_MEETING_DAY         @"GetMeetingDay"
#define FUNC_GET_MEETINGS            @"getMeetings"
#define FUNC_GET_TokboxTokenByMobile    @"getTokboxTokenByMobile"
#define FUNC_GET_TkboxSessionByMobile   @"getTokboxSessionByMobile"
#define FUNC_GET_AllToDoTasks        @"getAllToDoTasks"
#define FUNC_GET_ConsultantThinkTankLearningService @"getConsultantThinktankLearningService"
#define FUNC_GET_UPCOMINGMEETING        @"getUPCOMINGMEETING"
#define FUNC_GET_ALLEA                 @"getALLEA"
#define FUNC_GET_Tests                  @"getTests"
#define FUNC_GET_StudentAllInfo         @"getStudentAllInfo"
#define FUNC_GET_StudentProgress        @"getStudentProgress"
#define FUNC_CGET_StudentTasks          @"getStudentTasks"
#define FUNC_GET_StudentAcademics       @"getStudentAcademics"
#define FUNC_DEL_EAS                    @"DelEAs"
#define FUNC_GET_ChatNews               @"getChatNews"
#define FUNC_GET_setToDoTasks           @"setToDoTasks"
#define FUNC_GET_AddExtracurricularActivitiesByVCS         @"AddExtracurricularActivitiesByVCS"
#define FUNC_GET_AddExtracurricularActivitiesByWE           @"AddExtracurricularActivitiesByWE"
#define FUNC_GET_AddExtracurricularActivitiesByEA           @"AddExtracurricularActivitiesByEA"

//Upload Type
#define UPLOAD_TYPE_SUBMIT           @"Submit"
#define UPLOAD_TYPE_SAVE_DRAFT       @"Save Draft"

#define SOURCE_WEB                   @"Web"
#define SOURCE_MOBILE                @"Mobile"

#define FUNC_USERPHOTO               @"UserPhoto"

//Openfire
#define FUNC_OPENFIRECHENGUSERPASSWORD @"OpenfireChangeUserPassword"
#define FUNC_OPENFIREUSER           @"OpenfireUser"
	
//---------------------Herry 添加--------------

#define FUNC_LOGINRETURN_ROLE               @"LoginReturnRole"
#define Update_UserName            @"UpdateUserName"
#define Update_Password            @"UpdatePassword"
#define Update_Phototext           @"UploadUpdatePhoto"
#define SelectLogin   @"GetLoginInfo"

#define FUNC_SETMOBILETOKEN        @"SetMobileToken"

#define User_LoginOut            @"UserLoginOut"

//tutor

#define    GetRequestInfoByRequestId @"GetTutroRequestInfoByRequestId"
#define Func_WaitingRequest_BY_Tutor   @"TutorWaitingRequest"
#define Func_MatchedStudent_BY_Tutor   @"MatchedStudentForTutor"
#define  GetRequestStudentInfoByRequestId     @"TutorReauestStudentInfo"
#define AcceptRequestByTutor   @"UpdateTutorAccept"

#define GetTutorRecentPaymentAndTutorTotalHour @"GetTutorRecentPaymentAndTutorTotalHour"

#define UpdateTutorReadState @"UpdateTutorRequestReadState"
#define GetTimesheetSunjectAndLocation @"GetTimesheetSunjectAndLocation"

//parent
#define Func_GETMettingMinute_BY_STUDENT   @"GetMettingMinuteByStudent"

#define Func_STUDENTBY_PARENT   @"GetStudentByParent"

//manager

#define FUNC_CREATEDCONTRACT @"CreatedContract"

//Doument
#define FUNC_GET_DOCUMENT_LIST_By_Student       @"GetDocumentListByStudent"
