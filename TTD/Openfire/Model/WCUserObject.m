//
//  WCUserObject.m
//  微信
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "WCUserObject.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "XMPPHelper.h"
@implementation WCUserObject
@synthesize userDescription,userHead,userId,userNickname,friendFlag,username,group;


+(BOOL)saveNewUser:(WCUserObject*)aUser
{
    
    
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    //NSString *ss=DATABASE_PATH;
    //NSLog(@"database path is %@",DATABASE_PATH);
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    
    [WCUserObject checkTableCreatedInDb:db];
    
    
    
    NSString *insertStr=@"INSERT INTO 'wcUser' ('userId','userNickname','userDescription','userHead','friendFlag','username','group') VALUES (?,?,?,?,?,?,?)";
    BOOL worked = [db executeUpdate:insertStr,aUser.userId,aUser.userNickname,aUser.userDescription,aUser.userHead,aUser.friendFlag,aUser.username,aUser.group];
    // FMDBQuickCheck(worked);
    
    
    
    [db close];
    
    
    return worked;
}

+(BOOL)haveSaveUserById:(NSString*)userId userName:(NSString *)ByUserName
{
    

    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return YES;
    };
    [WCUserObject checkTableCreatedInDb:db];
    
    FMResultSet *rs=[db executeQuery:@"select count(*) from wcUser where userId=? and username=? ",userId,ByUserName];
    while ([rs next]) {
        int count= [rs intForColumnIndex:0];
        
        if (count!=0){
            [rs close];
            return YES;
        }else
        {
            [rs close];
            return NO;
        }
        
    };
    [rs close];
    return YES;
    
}
+(BOOL)deleteUserById:(NSMutableArray*)userList userName:(NSString *)ByUserName
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        return false;
    }
    if(userList.count>0)
    {
        NSString *userId=@"";
        for (int i=0;i<userList.count;i++){            
            NSArray *strs=[[userList objectAtIndex:i] componentsSeparatedByString:@"@"];
            userId=[userId stringByAppendingFormat:@"'%@',",strs[0]];
            
        }
        NSMutableString *str_sql=[[NSMutableString alloc] initWithString:userId];
        [str_sql deleteCharactersInRange:NSMakeRange(str_sql.length-1, 1)];        
        //[db executeUpdate:@"delete from wcUser where userid not in (?) and username=?",str_sql,ByUserName];
        NSString* sql=@"delete from wcUser where userid not in (";
        sql=[sql stringByAppendingString:str_sql];
        sql=[sql stringByAppendingString:@")"];
        sql=[sql stringByAppendingString:@" and username='"];
        sql=[sql stringByAppendingString:ByUserName];
        sql=[sql stringByAppendingString:@"'"];
        [db executeUpdate:sql];
        return  true;
    }else
    {
        return true;
    }
    
}

+(BOOL)updateUser:(WCUserObject*)newUser
{
    
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [WCUserObject checkTableCreatedInDb:db];
    //BOOL worked=[db executeUpdate:@"update wcUser set userNickname=?,userHead=? where userId=? and username=? ",newUser.userNickname,newUser.userHead,newUser.userId,newUser.username];
    BOOL worked=[db executeUpdate:@"update wcUser set userNickname=? where userId=? and username=? ",newUser.userNickname,newUser.userId,newUser.username];
    
    return worked;
    
}
+(BOOL)updateUserHead:(WCUserObject*)newUser userHead:(NSString *)userHeadby
{
    
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [WCUserObject checkTableCreatedInDb:db];
    BOOL worked=[db executeUpdate:@"update wcUser set userHead=? where userId=? and username=? ",userHeadby,newUser.userId,newUser.username];
    
    return worked;
    
}
+(NSMutableArray*)fetchAllFriendsFromLocal
{
    NSMutableArray *resultArr=[[NSMutableArray alloc]init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return resultArr;
    };
    [WCUserObject checkTableCreatedInDb:db];
    
    FMResultSet *rs=[db executeQuery:@"select * from wcUser where friendFlag=?",[NSNumber numberWithInt:1]];
    while ([rs next]) {
        WCUserObject *user=[[WCUserObject alloc]init];
        user.userId=[rs stringForColumn:kUSER_ID];
        user.userNickname=[rs stringForColumn:kUSER_NICKNAME];
        user.userHead=[rs stringForColumn:kUSER_USERHEAD];
        user.userDescription=[rs stringForColumn:kUSER_DESCRIPTION];
        user.friendFlag=[NSNumber numberWithInt:1];
        user.username=[rs stringForColumn:kUSER__USERNAME];
        user.group=[rs stringForColumn:kUSER__GROUP];
        [resultArr addObject:user];
    }
    [rs close];
    return resultArr;
    
}

+(NSMutableArray*)fetchAllFromUsername:(NSString *)username
{
    NSMutableArray *resultArr=[[NSMutableArray alloc]init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        
        return resultArr;
    };
    [WCUserObject checkTableCreatedInDb:db];
    
    //FMResultSet *messagers=[db executeQuery:@"select distinct messageTo from wcMessage where username=?  order by messageState desc,messageDate desc ",username];
    FMResultSet *messagers=[db executeQuery:@"select messageName from( select  messageName,max(messageDate)  maxdate from  ( select messageFrom messageName,messageDate  from wcMessage where username=? UNION  select messageTo messageName,messageDate from wcMessage where username=? ) group by messageName ) a order by a.maxdate desc",username,username];
    NSString *caseStr;
    int messageCount = 0;
    caseStr=@" case userId ";
    while ([messagers next]) {
        messageCount++;
        caseStr =[caseStr stringByAppendingString:@" when "];       
        caseStr =[caseStr stringByAppendingFormat:@"'%@'",[messagers stringForColumn:@"messageName"]];
        caseStr =[caseStr stringByAppendingFormat:@" then '%d' ",messageCount];       
    }
    SharedAppDelegate.RecentContactNumber=messageCount;
    caseStr =[caseStr stringByAppendingFormat:@" else '%d' end",messageCount+1];
    //NSLog(@"casestr%@:",caseStr);
    [messagers close];
    
    //FMResultSet *rs=[db executeQuery:@"select * from wcUser where username=? order by (?),userNickname asc ",username,caseStr];
    NSString *sql=@"select * from wcUser";
    if (messageCount>0) {
        sql=[sql stringByAppendingFormat:@" where username='%@' order by ( %@ ),userNickname asc ",username,caseStr];
    }else
    {
        sql=[sql stringByAppendingFormat:@" where username='%@' order by userNickname asc ",username];
    }
    //NSLog(@"sql%@: ",sql);
    FMResultSet *rs=[db executeQuery:sql];
    while ([rs next]) {
        WCUserObject *wco=[WCUserObject alloc];
        wco.userId=[rs stringForColumn:kUSER_ID];
        wco.userHead=[rs stringForColumn:kUSER_USERHEAD];
        wco.username=[rs stringForColumn:kUSER__USERNAME];
        wco.userNickname=[rs stringForColumn:kUSER_NICKNAME];
        wco.userDescription=[rs stringForColumn:kUSER_DESCRIPTION];
        wco.group=[rs stringForColumn:kUSER__GROUP];
        [resultArr addObject:wco];
        //[resultArr addObject:[rs stringForColumn:kUSER_ID]];
        //NSLog(@"kUSER_ID: %@ | %@ | %@",[rs stringForColumn:kUSER_ID],[rs stringForColumn:kUSER_NICKNAME],[rs stringForColumn:kUSER__USERNAME]);
    }
    [rs close];
    return resultArr;
}
+(WCUserObject*)fetchAllFriendsFromUserID:(NSString *)UserID username:(NSString *)ByUserName
{
    NSMutableArray *resultArr=[[NSMutableArray alloc]init];
    WCUserObject *user=[[WCUserObject alloc]init];
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        //return resultArr;
    };
    [WCUserObject checkTableCreatedInDb:db];
    
    FMResultSet *rs=[db executeQuery:@"select * from wcUser where userId=? and username=?",UserID,ByUserName];
    while ([rs next]) {
        
        user.userId=[rs stringForColumn:kUSER_ID];
        user.userNickname=[rs stringForColumn:kUSER_NICKNAME];
        user.userHead=[rs stringForColumn:kUSER_USERHEAD];
        user.userDescription=[rs stringForColumn:kUSER_DESCRIPTION];
        user.friendFlag=[NSNumber numberWithInt:1];
        user.username=[rs stringForColumn:kUSER__USERNAME];
        user.group=[rs stringForColumn:kUSER__GROUP];
        [resultArr addObject:user];
    }
    [rs close];
    return user;
    
}

+(WCUserObject*)userFromDictionary:(NSDictionary*)aDic
{
    WCUserObject *user=[[[WCUserObject alloc]init]autorelease];
    [user setUserId:[[aDic objectForKey:kUSER_ID]stringValue]];
    [user setUserHead:[aDic objectForKey:kUSER_USERHEAD]];
    [user setUserDescription:[aDic objectForKey:kUSER_DESCRIPTION]];
    [user setUserNickname:[aDic objectForKey:kUSER_NICKNAME]];
    [user setUsername:[aDic objectForKey:kUSER__USERNAME]];
    [user setGroup:[aDic objectForKey:kUSER__GROUP]];
    return user;
}

-(NSDictionary*)toDictionary
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:userId,kUSER_ID,userNickname,kUSER_NICKNAME,userDescription,kUSER_DESCRIPTION,userHead,kUSER_USERHEAD,friendFlag,kUSER_FRIEND_FLAG, username,kUSER__USERNAME,group,kUSER__GROUP,nil];
    return dic;
}


+(BOOL)checkTableCreatedInDb:(FMDatabase *)db
{
   // NSString *createStr=@"CREATE  TABLE  IF NOT EXISTS 'wcUser' ('userId' VARCHAR PRIMARY KEY  NOT NULL  UNIQUE , 'userNickname' VARCHAR, 'userDescription' VARCHAR, 'userHead' VARCHAR,'friendFlag' INT,'username',VARCHAR)";
    NSString *createStr=@"CREATE  TABLE  IF NOT EXISTS 'wcUser' ('userId' VARCHAR, 'userNickname' VARCHAR, 'userDescription' VARCHAR, 'userHead' text,'friendFlag' INT,'username' VARCHAR,'group' VARCHAR)";

    
    BOOL worked = [db executeUpdate:createStr];
    FMDBQuickCheck(worked);
    
    createStr=@"CREATE  TABLE  IF NOT EXISTS 'wcMessage' ('messageId' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL  UNIQUE , 'messageFrom' VARCHAR, 'messageTo' VARCHAR, 'messageContent' VARCHAR, 'username' VARCHAR, 'messageDate' DATETIME,'messageType' INTEGER,'messageState' VARCHAR ,'messageaudiotimes' VARCHAR ,'messagesendType' INTEGER )";
    
    worked = [db executeUpdate:createStr];
    FMDBQuickCheck(worked);
    
    return worked;
    
}

@end
