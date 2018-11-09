//
//  ResHistoryVersionDAL.m
//  LeadingCloud
//
//  Created by SY on 16/4/11.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  sy
 Date：   2016-04-11
 Version: 1.0
 Description: 【云盘】历史版本文件数据库
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ResHistoryVersionDAL.h"

@implementation ResHistoryVersionDAL
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ResHistoryVersionDAL *)shareInstance{
    static ResHistoryVersionDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[ResHistoryVersionDAL alloc] init];
    }
    return instance;
}
#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createResHistoryVersionTableIfNotExists
{
    NSString *tableName = @"res_historyversion";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[rid] [varchar](50)  NULL,"
                                         "[clienttempid] [varchar](50) NULL,"
                                         "[partitiontype] [integer] NULL,"
                                         "[name] [varchar](100) NULL,"
                                         "[rpid] [varchar](50) NULL,"
                                         "[classid] [varchar](50) NULL,"
                                         "[createuser] [varchar](50) NULL,"
                                         "[createusername] [varchar](50) NULL,"
                                         "[createdate] [date] NULL,"
                                         "[updateuser] [varchar](50) NULL,"
                                         "[updateusername] [varchar](50) NULL,"
                                         "[updatedate] [date] PRIMARY KEY NOT NULL,"
                                         "[showversion] [varchar](50) NULL,"
                                         "[version] [integer] NULL,"
                                         "[versionid] [varchar](50) NULL,"
                                         "[rtype] [integer] NULL,"
                                         "[iscurrentversion] [integer] NULL,"
                                         "[exptype] [varchar](100) NULL,"
                                         "[size] [integer] NULL,"
                                         "[expid] [varchar](50) NULL,"
                                         "[subcount] [integer] NULL,"
                                          "[downloadstatus] [integer] NULL,"
                                         "[description] [text] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateResHistoryVersionTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)resArray{
    
    [[self getDbQuene:@"res_historyversion" FunctionName:@"addDataWithArray:(NSMutableArray *)resArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		
		NSString *sql = @"INSERT OR REPLACE INTO res_historyversion(rid,clienttempid,partitiontype,name,rpid,classid,createuser,createusername,createdate,updateuser,updateusername,updatedate,showversion,version,versionid,rtype,iscurrentversion,exptype,size,expid,subcount,downloadstatus,description)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
        for (int i = 0; i< resArray.count;  i++) {
            ResModel *resModel = [resArray objectAtIndex:i];
            
            NSString *rid = resModel.rid;
            NSString *clienttempid = resModel.clienttempid;
            NSNumber *partitiontype = [NSNumber numberWithInteger:resModel.partitiontype];
            NSString *name = resModel.name;
            NSString *rpid = resModel.rpid;
            NSString *classid = resModel.classid;
            NSString *createuser = resModel.createuser;
            NSString *createusername = resModel.createusername;
            NSDate *createdate = resModel.createdate;
            NSString *updateuser = resModel.updateuser;
            NSString *updateusername = resModel.updateusername;
            NSDate *updatedate = resModel.updatedate;
            NSString *showVersion = resModel.showversion;
            NSNumber *version = [NSNumber numberWithInteger:resModel.version];
            NSString *versionid = resModel.versionid;
            NSNumber *rtype = [NSNumber numberWithInteger:resModel.rtype];
            NSNumber *iscurrentversion = [NSNumber numberWithInteger:resModel.iscurrentversion];
            NSString *exptype = resModel.exptype;
            NSNumber *size = [NSNumber numberWithLongLong:resModel.size];
            NSString *expid = resModel.expid;
            NSString *description = resModel.descript;
            NSNumber *subcount = [NSNumber numberWithInteger:resModel.subcount];
           
            NSNumber *downloadstatus = [NSNumber numberWithInteger:resModel.downloadstatus];
			
            isOK = [db executeUpdate:sql,rid,clienttempid,partitiontype,name,rpid,classid,createuser,createusername,createdate,updateuser,updateusername,updatedate,showVersion,version,versionid,rtype,iscurrentversion,exptype,size,expid,subcount,downloadstatus,description];
            if (!isOK) {
                DDLogError(@"插入失败");
                break;
            }
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res_historyversion" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
    
}
#pragma mark - 删除数据
-(void)deleteHistoryVersionWithRid:(NSString*)rid {
    [[self getDbQuene:@"res_historyversion" FunctionName:@"deleteHistoryVersionWithRid:(NSString*)rid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from res_historyversion where rid = ?";
        isOK = [db executeUpdate:sql,rid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res_historyversion" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];

    
    
    
}
#pragma mark - 查询数据

/**
 *  获取本地历史版本
 *
 *  @param rid  资源id
 *  @param rpid 资源次id
 *
 *  @return 历史文件
 */
-(NSMutableArray *)getResHistoryVersionModelsWithRid:(NSString *)rid rpid:(NSString*)rpid {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"res_historyversion" FunctionName:@"getResHistoryVersionModelsWithRid:(NSString *)rid rpid:(NSString*)rpid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select rid,clienttempid,partitiontype,name,rpid,classid,createuser,createusername,createdate,updateuser,updateusername,updatedate,showversion,version,versionid,rtype,iscurrentversion,exptype,size,expid,description,subcount,ifnull(downloadstatus,0) downloadstatus"
                       " From res_historyversion Where rid = '%@' and rpid='%@'"
                      ,rid,rpid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;
}


#pragma mark - Private Function

/**
 *  将FMResultSet转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return ImChatLogModel
 */
-(ResModel *)convertResultSetToModel:(FMResultSet *)resultSet
{
    NSString *rid = [resultSet stringForColumn:@"rid"];
    NSString *clienttempid = [resultSet stringForColumn:@"clienttempid"];
    NSInteger partitiontype = [resultSet intForColumn:@"partitiontype"];
    NSString *name = [resultSet stringForColumn:@"name"];
    NSString *rpid = [resultSet stringForColumn:@"rpid"];
    NSString *classid = [resultSet stringForColumn:@"classid"];
    NSString *createuser = [resultSet stringForColumn:@"createuser"];
    NSString *createusername = [resultSet stringForColumn:@"createusername"];
    NSDate *createdate = [resultSet dateForColumn:@"createdate"];
    NSString *updateuser = [resultSet stringForColumn:@"updateuser"];
    NSString *updateusername = [resultSet stringForColumn:@"updateusername"];
    NSDate *updatedate = [resultSet dateForColumn:@"updatedate"];
    NSString *showversion = [resultSet stringForColumn:@"showversion"];
    NSInteger version = [resultSet intForColumn:@"version"];
    NSString *versionid = [resultSet stringForColumn:@"versionid"];
    NSInteger rtype = [resultSet intForColumn:@"rtype"];
    NSInteger iscurrentversion = [resultSet intForColumn:@"iscurrentversion"];
    NSString *exptype = [resultSet stringForColumn:@"exptype"];;
    long long size = [resultSet longLongIntForColumn:@"size"];
    NSString *expid = [resultSet stringForColumn:@"expid"];
    NSString *descript = [resultSet stringForColumn:@"description"];
    NSInteger subcount = [resultSet intForColumn:@"subcount"];
    NSInteger downloadstatus = [resultSet intForColumn:@"downloadstatus"];
    
    ResModel *resModel = [[ResModel alloc] init];
    resModel.rid = rid;
    resModel.clienttempid = clienttempid;
    resModel.partitiontype = partitiontype;
    resModel.name = name;
    resModel.rpid = rpid;
    resModel.classid = classid;
    resModel.createuser = createuser;
    resModel.createusername = createusername;
    resModel.createdate = createdate;
    resModel.updateuser = updateuser;
    resModel.updateusername = updateusername;
    resModel.updatedate = updatedate;
    resModel.version = version;
    resModel.versionid = versionid;
    resModel.rtype = rtype;
    resModel.showversion = showversion;
    resModel.iscurrentversion = iscurrentversion;
    resModel.exptype = exptype;
    resModel.size = size;
    resModel.expid = expid;
    resModel.descript = descript;
    resModel.subcount = subcount;
    resModel.downloadstatus = downloadstatus;
    
    return resModel;
    
}

@end
