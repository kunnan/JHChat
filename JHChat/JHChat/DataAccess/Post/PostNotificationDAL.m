//
//  PostNotificationDAL.m
//  LeadingCloud
//
//  Created by wang on 16/3/23.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "PostNotificationDAL.h"

@implementation PostNotificationDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostNotificationDAL *)shareInstance{
    static PostNotificationDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[PostNotificationDAL alloc] init];
    }
    return instance;

}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createPostNotificationTableIfNotExists{
    NSString *tableName = @"post_notification";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[nid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[expandtag] [varchar](50) NULL,"
                                         "[expandtagtype] [varchar](50) NULL,"
                                         "[notificationtype] [varchar](50) NULL,"
                                         "[senddatetime] [date] NULL,"
                                         "[receiverid] [varchar](50) NULL,"
                                         "[notificationparamsdic] [data] NULL,"
                                         "[notificationparams] [varchar](50) NULL,"
                                         "[receivepid] [varchar](50) NULL,"
                                         "[uid] [varchar](50) NULL,"
                                         "[userface] [varchar](50) NULL,"
                                         "[username] [integer] NULL);",
                                         tableName]];
        
    }

}
/**
 *  升级数据库
 */
-(void)updatePostNotificationTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
//            case 24:{
//                [self AddColumnToTableIfNotExist:@"post_notification" columnName:@"notificationparams" type:@"[varchar](50)"];
//                [self AddColumnToTableIfNotExist:@"post_notification" columnName:@"receivepid" type:@"[varchar](50)"];
//                [self AddColumnToTableIfNotExist:@"post_notification" columnName:@"uid" type:@"[varchar](50)"];
//                [self AddColumnToTableIfNotExist:@"post_notification" columnName:@"userface" type:@"[varchar](50)"];
//                [self AddColumnToTableIfNotExist:@"post_notification" columnName:@"username" type:@"[integer]"];
//                break;
//            }

        }
    }
}
-(void)addDataWithArray:(NSMutableArray *)pArray{
    
    
    [[self getDbQuene:@"post_notification" FunctionName:@"addDataWithArray:(NSMutableArray *)pArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO post_notification(nid,expandtag,expandtagtype,notificationtype,receiverid,senddatetime,notificationparamsdic)"
		"VALUES (?,?,?,?,?,?,?)";
		
        for (int i = 0; i< pArray.count;  i++) {
            PostNotificationModel *nModel = [pArray objectAtIndex:i];
           
            NSString *nid=nModel.nid;
            NSString *expandtag=nModel.expandtag;
            NSString *expandtagtype=nModel.expandtagtype;
            NSString *notificationtype=nModel.notificationtype;
            NSString *receiverid=nModel.receiverid;
            NSDate *senddatetime=nModel.senddatetime;
            NSData *notificationparamsdic=[NSJSONSerialization dataWithJSONObject:nModel.notificationparamsdic options:NSJSONWritingPrettyPrinted error:nil];
			
            isOK = [db executeUpdate:sql,nid,expandtag,expandtagtype,notificationtype,receiverid,senddatetime,notificationparamsdic];
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post_notification" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
        
    }];
    
}

#pragma mark - 查询数据
/**
 得到动态提醒
 *  @param count      数据
 
 */
-(NSMutableArray*)getPostNotificationArrStart:(NSInteger)start Count:(NSInteger)count{
    NSMutableArray *results=[NSMutableArray array];
    
    [[self getDbQuene:@"post_notification" FunctionName:@"getPostNotificationArrStart:(NSInteger)start Count:(NSInteger)count"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select  * FROM post_notification ORDER BY senddatetime desc limit %ld,%ld",start,count];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            
            NSString *nid = [resultSet stringForColumn:@"nid"];
            NSString *expandtag = [resultSet stringForColumn:@"expandtag"];
            NSString *expandtagtype = [resultSet stringForColumn:@"expandtagtype"];
            NSString *notificationtype = [resultSet stringForColumn:@"notificationtype"];
            NSDate *senddatetime = [resultSet dateForColumn:@"senddatetime"];
            NSString *receiverid  =[resultSet stringForColumn:@"receiverid"];
            NSData *notificationparamsdic=[resultSet dataForColumn:@"notificationparamsdic"];

            
            PostNotificationModel *nModel = [[PostNotificationModel alloc] init];
            nModel.nid=nid;
            nModel.expandtag=expandtag;
            nModel.expandtagtype=expandtagtype;
            nModel.notificationtype=notificationtype;
            nModel.senddatetime=senddatetime;
            nModel.receiverid=receiverid;
            nModel.notificationparamsdic=[NSJSONSerialization JSONObjectWithData:notificationparamsdic options:NSJSONReadingMutableContainers error:nil];
            
            PostNotificationParamModel *pModel=[[PostNotificationParamModel alloc]init];
            [pModel serializationWithDictionary:nModel.notificationparamsdic];
            nModel.paramModel=pModel;
            [results addObject:nModel];
        }
        [resultSet close];
    }];

    return results;
}
@end
