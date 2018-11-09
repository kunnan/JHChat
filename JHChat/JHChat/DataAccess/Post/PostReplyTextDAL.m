//
//  PostReplyTextDAL.m
//  LeadingCloud
//
//  Created by wang on 17/2/27.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "PostReplyTextDAL.h"

@implementation PostReplyTextDAL


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostReplyTextDAL *)shareInstance{
    
    static PostReplyTextDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[PostReplyTextDAL alloc] init];
    }
    return instance;

}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createPostReplyTextTableIfNotExists{
    
    NSString *tableName = @"post_reply_text";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2017-02-27日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[pid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[text] [text] NULL,"
                                         "[firends] [data] NULL,"
                                         "[uids] [data] NULL);",
                                         tableName]];
        
    }

}
/**
 *  升级数据库
 */
-(void)updatePostReplyTextTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    
}


/**
 添加临时文本
 
 @param text   文本
 @param people @好友
 @param pid    动态id
 */
- (void)addTempText:(NSString*)text Peoples:(NSArray*)peoples Firends:(NSDictionary*)firends Pid:(NSString*)pid{
    
    
    
    NSData *firendsData=[NSJSONSerialization dataWithJSONObject:firends options:NSJSONWritingPrettyPrinted error:nil];
    NSData *peoplesData=[NSJSONSerialization dataWithJSONObject:peoples options:NSJSONWritingPrettyPrinted error:nil];

    
    [[self getDbQuene:@"post_reply_text" FunctionName:@"addTempText:(NSString*)text Peoples:(NSArray*)peoples Firends:(NSDictionary*)firends Pid:(NSString*)pid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *sql = @"INSERT OR REPLACE INTO post_reply_text(pid,text,uids,firends)"
        "VALUES (?,?,?,?)";
        isOK = [db executeUpdate:sql,pid,text,peoplesData,firendsData];
        
        if (!isOK) {
            DDLogError(@"插入失败");
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post_reply_text" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
        
    }];

    
}



/**
 删除动态临时文本
 
 @param pid 动态id
 */
- (void)deleTempTextPid:(NSString*)pid{
    
    [[self getDbQuene:@"post_reply_text" FunctionName:@"deleTempTextPid:(NSString*)pid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from post_reply_text where pid=?";
        isOK = [db executeUpdate:sql,pid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post_reply_text" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}


/**
 得到动态临时文本
 
 @param pid 动态id
 */
- (NSDictionary*)getTempReplyTextPostID:(NSString*)pid{
    
    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
    [[self getDbQuene:@"post_reply_text" FunctionName:@"getTempReplyTextPostID:(NSString*)pid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM post_reply_text WHERE pid=?"];
        FMResultSet *resultSet=[db executeQuery:sql,pid];

        while ([resultSet next]) {
            
            NSString *text = [resultSet stringForColumn:@"text"];
            NSData *uids = [resultSet dataForColumn:@"uids"];
            NSData *firends = [resultSet dataForColumn:@"firends"];
            if (!uids) {
                uids = [NSData data];
            }
            if (!firends) {
                firends = [NSData data];
            }

            NSDictionary *firendDic=[NSJSONSerialization JSONObjectWithData:firends options:NSJSONReadingMutableContainers error:nil];
            NSArray *uidsArr=[NSJSONSerialization JSONObjectWithData:uids options:NSJSONReadingMutableContainers error:nil];

            [temp setValue:text forKey:@"text"];
            [temp setValue:uidsArr forKey:@"uids"];
            [temp setValue:firendDic forKey:@"firends"];

            
        }
        [resultSet close];
    }];

    return  temp;
}
@end
