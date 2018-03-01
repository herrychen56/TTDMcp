//
//  WCMessageObject.m
//  微信
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "WCMessageObject.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseQueue.h"

@implementation WCMessageObject
@synthesize messageContent,messageDate,messageFrom,messageTo,messageType,messageId,username,messageState,messageCount,userNickname,userHead,group,userId,messagesendType,messageaudioTimes;

+(WCMessageObject *)messageWithType:(int)aType{
    WCMessageObject *msg=[[WCMessageObject alloc]init];
    [msg setMessageType:[NSNumber numberWithInt:aType]];
    return  msg;
}
+(WCMessageObject*)messageFromDictionary:(NSDictionary*)aDic {
    WCMessageObject *msg=[[WCMessageObject alloc]init];
    [msg setMessageFrom:[aDic objectForKey:kMESSAGE_FROM]];
    [msg setMessageTo:[aDic objectForKey:kMESSAGE_TO]];
    [msg setMessageContent:[aDic objectForKey:kMESSAGE_CONTENT]];
    [msg setUsername:[aDic objectForKey:kMESSAGE_USERNAME]];
    [msg setMessageDate:[aDic objectForKey:kMESSAGE_DATE]];
    [msg setMessageType:[aDic objectForKey:kMESSAGE_TYPE]];
    [msg setMessageState:[aDic objectForKey:kMESSAGE_STATE]];
    [msg setMessagesendType:[aDic objectForKey:kMESSAGE_SendType]];
    return  msg;
}


//将对象转换为字典
-(NSDictionary*)toDictionary {
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:messageId,kMESSAGE_ID,messageFrom,kMESSAGE_FROM,messageTo,kMESSAGE_TO,messageContent,kMESSAGE_TYPE,messageDate,kMESSAGE_DATE,messageType,kMESSAGE_TYPE,username,kMESSAGE_USERNAME,messageType,kMESSAGE_STATE,messagesendType,kMESSAGE_SendType,messageaudioTimes,kMEssAGE_AudioTime, nil];
    return dic;
    
}

//增删改查

+(BOOL)save:(WCMessageObject*)aMessage {
    
    
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    
    NSString *createStr=@"CREATE  TABLE  IF NOT EXISTS 'wcMessage' ('messageId' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL  UNIQUE , 'messageFrom' VARCHAR, 'messageTo' VARCHAR, 'messageContent' VARCHAR, 'username' VARCHAR, 'messageDate' DATETIME,'messageType' INTEGER,'messageState' VARCHAR,'messagesendType' INTEGER ,'messageaudioTimes' VARCHAR )";
    
    BOOL worked = [db executeUpdate:createStr];
    FMDBQuickCheck(worked);
    
    
    
    NSString *insertStr=@"INSERT INTO 'wcMessage' ('messageFrom','messageTo','messageContent','username','messageDate','messageType','messageState','messagesendType','messageaudioTimes') VALUES (?,?,?,?,?,?,?,?,?)";
    worked = [db executeUpdate:insertStr,aMessage.messageFrom,aMessage.messageTo,aMessage.messageContent,aMessage.username,aMessage.messageDate,aMessage.messageType,aMessage.messageState,aMessage.messagesendType,aMessage.messageaudioTimes];
//    worked = [db executeUpdate:insertStr,aMessage.messageFrom,aMessage.messageTo,aMessage.messageContent,aMessage.username,aMessage.messageDate,aMessage.messageType,aMessage.messageState];
    FMDBQuickCheck(worked);
    
    
    [db close];
    //发送全局通知
    [[NSNotificationCenter defaultCenter]postNotificationName:kXMPPNewMsgNotifaction object:aMessage ];
    [aMessage release];

    
    return worked;
}

+(int)fetchMessageListWithUserCount:(NSString *)userFrom username:(NSString *)messageusername {
   
    
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return 0;
    }
    
    NSString *queryString=@"select count(*) as messageCount  from wcMessage where (messageFrom=? or messageTo=?) and username=? order by messageDate  ";
    
    FMResultSet *rs=[db executeQuery:queryString,userFrom,userFrom,messageusername];
    int messageCount=0;
    while ([rs next]) {
        messageCount=[rs intForColumn:@"messageCount"];
        NSLog(@"messageCount:%d",messageCount);
    }
    return messageCount;
}

//获取某联系人聊天记录
+(NSMutableArray*)fetchMessageListWithUser:(NSString *)userFrom username:(NSString *)messageusername byPage:(int)pageIndex {
    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return messageList;
    }
    //NSString *queryString=@"select  * from wcMessage where (messageFrom=? or messageTo=?) and username=? order by messageDate  ";
    //NSString *queryString=@"select top ? * from wcMessage where select top ? * from wcMessage where (messageFrom=? or messageTo=?) and username=? order by messageDate  ";
    //FMResultSet *rs=[db executeQuery:SelectTop,queryString,userFrom,userFrom,messageusername];
    //FMResultSet *rs=[db executeQuery:queryString,[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],[NSNumber numberWithInt:pageIndex-1]];
    NSString *queryString=@"select * from (select * from wcMessage  where  (messageFrom=? or messageTo=?) and username=? order by messageDate desc limit ?,10) as wc order by messageDate asc";
    FMResultSet *rs=[db executeQuery:queryString,userFrom,userFrom,messageusername,[NSNumber numberWithInt:(pageIndex*10)]];
    WCMessageObject *message=[[[WCMessageObject alloc]init]autorelease];
    while ([rs next]) {
//        dispatch_group_async(dispatch_group_create(), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [message setMessageId:[rs objectForColumnName:kMESSAGE_ID]];
                [message setMessageContent:[rs stringForColumn:kMESSAGE_CONTENT]];
                [message setMessageDate:[rs dateForColumn:kMESSAGE_DATE]];
                [message setMessageFrom:[rs stringForColumn:kMESSAGE_FROM]];
                [message setMessageTo:[rs stringForColumn:kMESSAGE_TO]];
                [message setMessageType:[rs objectForColumnName:kMESSAGE_TYPE]];
                [message setUsername:[rs stringForColumn:kMESSAGE_USERNAME]];
                [message setMessageState:[rs stringForColumn:kMESSAGE_STATE]];
        [message setMessagesendType:[rs objectForColumnName:kMESSAGE_SendType]];
        [message setMessageaudioTimes:[rs stringForColumn:kMEssAGE_AudioTime]];
//        });
//        dispatch_group_notify(dispatch_group_create(), dispatch_get_main_queue(), ^{
            [messageList addObject:message];
//        });
    }
    return  messageList;
}
+(NSMutableArray*)fetchMessageListWithUserOrderByDesc:(NSString *)userId username:(NSString *)messageusername byPage:(int)pageInde {
    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return messageList;
    }
    
    NSString *queryString=@"select  * from wcMessage where (messageFrom=? or messageTo=?) and username=? order by messageDate desc limit 0,1";
    FMResultSet *rs=[db executeQuery:queryString,userId,userId,messageusername];
    while ([rs next]) {
        WCMessageObject *message=[[[WCMessageObject alloc]init]autorelease];
        [message setMessageId:[rs objectForColumnName:kMESSAGE_ID]];
        [message setMessageContent:[rs stringForColumn:kMESSAGE_CONTENT]];
        [message setMessageDate:[rs dateForColumn:kMESSAGE_DATE]];
        [message setMessageFrom:[rs stringForColumn:kMESSAGE_FROM]];
        [message setMessageTo:[rs stringForColumn:kMESSAGE_TO]];
        [message setMessageType:[rs objectForColumnName:kMESSAGE_TYPE]];
        [message setUsername:[rs stringForColumn:kMESSAGE_USERNAME]];
        [message setMessageState:[rs stringForColumn:kMESSAGE_STATE]];
        
        [message setMessagesendType:[rs objectForColumnName:kMESSAGE_SendType]];
        [message setMessageaudioTimes:[rs objectForColumnName:kMEssAGE_AudioTime]];
        
        [messageList addObject:message];
    }
    return  messageList;
}


/**
查询所有人最后一条和未读条数
 */
+(NSMutableArray *)fetchAllUserMessageInfo:(NSString *)username {
    NSMutableArray *resultArr=[[NSMutableArray alloc]init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return resultArr;
    };
    
    FMResultSet *rs=[db executeQuery:@"select DISTINCT(userId),u.userNickname,u.\"group\",u.userHead,u.username,max(m.messageId) as messageId,m.messageFrom,m.messageTo,m.messageContent,sum(messageState) as messageStateCount,m.messageType,m.messageDate,m.messageState  from wcUser u left join wcMessage m on m.username=u.username and (m.messageFrom=u.userId or m.messageTo=u.userId)                      where u.username=?  GROUP BY userId  order by m.messageDate desc ",username];
    int i=0;
    while ([rs next]) {
        WCMessageObject *message=[[WCMessageObject alloc]init];
        [message setMessageId:[rs objectForColumnName:kMESSAGE_ID]];
        [message setMessageFrom:[rs objectForColumnName:kMESSAGE_FROM]];
        [message setMessageTo:[rs objectForColumnName:kMESSAGE_TO]];
        [message setMessageDate:[rs objectForColumnName:kMESSAGE_DATE]];
        [message setMessageState:[rs objectForColumnName:kMESSAGE_STATE]];
        [message setMessageContent:[rs objectForColumnName:kMESSAGE_CONTENT]];
        [message setMessageCount:[rs objectForColumnName:kMESSAGE_Count]];
        [message setMessageType:[rs objectForColumnName:kMESSAGE_TYPE]];
        
        [message setUserNickname:[rs objectForColumnName:kUSER_NICKNAME]];
        [message setGroup:[rs objectForColumnName:kUSER__GROUP]];
        [message setUserHead:[rs objectForColumnName:kUSER_USERHEAD]];
        [message setUsername:[rs objectForColumnName:kUSER__USERNAME]];
        [message setUserId:[rs objectForColumnName:kUSER_ID]];
        
        [message setMessagesendType:[rs objectForColumnName:kMESSAGE_SendType]];
        [message setMessageaudioTimes:[rs objectForColumnName:kMEssAGE_AudioTime]];
        
        [resultArr addObject:message];
        i++;
//        NSLog(@" ===Mess数据库===kUSER_USERHEAD:%@ name:%@ i:%d",[rs objectForColumnName:kUSER_USERHEAD] ,[rs stringForColumn:kUSER_ID],i);
    }
    
    
//    NSMutableArray *resultArrTemp=[[NSMutableArray alloc]init];
//    
//    int g=0;
//    rs=[db executeQuery:@"select * from wcUser where username=?",username];
//    while ([rs next]) {
//        WCUserObject *user=[[WCUserObject alloc]init];
//        user.userId=[rs stringForColumn:kUSER_ID];
//        user.userNickname=[rs stringForColumn:kUSER_NICKNAME];
//        user.userHead=[rs stringForColumn:kUSER_USERHEAD];
//        user.userDescription=[rs stringForColumn:kUSER_DESCRIPTION];
//        user.friendFlag=[NSNumber numberWithInt:1];
//        user.username=[rs stringForColumn:kUSER__USERNAME];
//        user.group=[rs stringForColumn:kUSER__GROUP];
//        [resultArrTemp addObject:user];
//        g++;
//        NSLog(@"db2 kUSER_USERHEAD:%@ name:%@ g:%d",[rs objectForColumnName:kUSER_USERHEAD] ,[rs stringForColumn:kUSER_ID],g);
//
//    }
    
    [rs close];
   
    
    return resultArr;
    
}
+(BOOL)deleteMessageById:(NSNumber*)aMessageId
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return false;
    }
    
    return  false;
}
//删除某联系人聊天记录
+(BOOL)delMessageListWithUser:(NSString *)FromTo UserName:(NSString *)ByUserName {
    
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return false;
    }
    NSString *queryString=@"select  * from wcMessage where (messageFrom=? or messageTo=?) and username=? and messageType=2";
    FMResultSet *rs=[db executeQuery:queryString,FromTo,FromTo,ByUserName];
     while ([rs next]) {
         [[NSFileManager defaultManager] removeItemAtPath:[rs stringForColumn:kMESSAGE_CONTENT] error:nil];
     }
    [db executeUpdate:@"delete from wcMessage where (messageFrom=? or messageTo=?) and username=? ",FromTo,FromTo,ByUserName];
    
    return true;
}

/**
 修改数据库

 @param FromTo 我发给对方
 @param ByUserName 对方name
 @return yes？no
 */
+(BOOL)UpdataMessageState:(NSString *)FromTo UserName:(NSString *)ByUserName {
    
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return false;
    }
    [db executeUpdate:@"update wcMessage set messageState=0 where (messageFrom=? or messageTo=?) and username=? and messageState='1' ",FromTo,FromTo,ByUserName];
    return true;
}

// sendtype == no
+(BOOL)UpdataMessageSendErrorType:(NSString *)FromTo {
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return false;
    }
    BOOL updata= [db executeUpdate:@"update wcMessage set messagesendType = 2 where messageId = ? ",FromTo];
    if (updata == YES) {
        NSLog(@"更新数据成功！！！！！！！！！");
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"chattabreload" object:nil];
    return true;
}
// sendtype == yes;
+(BOOL)UpdataMessageSendYesType:(NSString *)date {
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return false;
    }

    NSLog(@"date==%@",date);
     BOOL updata= [db executeUpdate:@"update wcMessage set messagesendType = 0 where messageId = ? ",date];
    if (updata == YES) {
        NSLog(@"更新数据成功！！！！！！！！！");
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"chattabreload" object:nil];
    
    return true;
    
}







+(int*)CountMessageState:(NSString *)FromTo UserName:(NSString *)ByUserName {
    
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return 0;
    }
    FMResultSet *rs=[db executeQuery:@"select count(*) as messageStateCount from wcMessage where (messageFrom=? or messageTo=?) and username=? and messageState='1' ",FromTo,FromTo,ByUserName];
    int messageStateCount=0;
    while ([rs next]) {
        messageStateCount=[rs intForColumn:@"messageStateCount"];
        NSLog(@"%d",messageStateCount);
    }
    return messageStateCount;
}

//获取最近联系人
+(NSMutableArray *)fetchRecentChatByPage:(int)pageIndex {
    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return messageList;
    }
    
    NSString *queryString=@"select * from wcMessage as m ,wcUser as u where u.userId<>? and ( u.userId=m.messageFrom or u.userId=m.messageTo ) group by u.userId  order by m.messageDate desc limit ?,10";
    FMResultSet *rs=[db executeQuery:queryString,[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],[NSNumber numberWithInt:pageIndex-1]];
    while ([rs next]) {
        WCMessageObject *message=[[[WCMessageObject alloc]init]autorelease];
        [message setMessageId:[rs objectForColumnName:kMESSAGE_ID]];
        [message setMessageContent:[rs stringForColumn:kMESSAGE_CONTENT]];
        [message setMessageDate:[rs dateForColumn:kMESSAGE_DATE]];
        [message setMessageFrom:[rs stringForColumn:kMESSAGE_FROM]];
        [message setMessageTo:[rs stringForColumn:kMESSAGE_TO]];
        [message setMessageType:[rs objectForColumnName:kMESSAGE_TYPE]];
        [message setUsername:[rs stringForColumn:kMESSAGE_USERNAME]];
        
        [message setMessagesendType:[rs objectForColumnName:kMESSAGE_SendType]];
        [message setMessageaudioTimes:[rs objectForColumnName:kMEssAGE_AudioTime]];
        
        WCUserObject *user=[[[WCUserObject alloc]init]autorelease];
        [user setUserId:[rs stringForColumn:kUSER_ID]];
        [user setUserNickname:[rs stringForColumn:kUSER_NICKNAME]];
        [user setUserHead:[rs stringForColumn:kUSER_USERHEAD]];
        [user setUserDescription:[rs stringForColumn:kUSER_DESCRIPTION]];
        [user setFriendFlag:[rs objectForColumnName:kUSER_FRIEND_FLAG]];
        
        
        
        WCMessageUserUnionObject *unionObject=[WCMessageUserUnionObject unionWithMessage:message andUser:user ];
        
        [ messageList addObject:unionObject];
        
    }
    return  messageList;

}



@end
