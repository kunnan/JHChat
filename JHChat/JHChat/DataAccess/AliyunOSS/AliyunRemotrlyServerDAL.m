//
//  AliyunRemotrlyServerDAL.m
//  LeadingCloud
//
//  Created by SY on 2017/6/29.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "AliyunRemotrlyServerDAL.h"
#import "RemotelyServerModel.h"
#import "AppDelegate.h"
#import "LZBaseAppDelegate.h"
#import "AliyunOSS.h"
@implementation AliyunRemotrlyServerDAL
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(AliyunRemotrlyServerDAL *)shareInstance{
    static AliyunRemotrlyServerDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[AliyunRemotrlyServerDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createAliServerTableIfNotExists
{
    NSString *tableName = @"aliyun_server";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[rfsid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[rfsname] [varchar](50) NULL,"
                                         "[rfstype] [varchar](50) NULL,"
                                         "[rfsurl] [varchar](50) NULL,"
                                         "[bucket] [varchar](50) NULL,"
                                         "[path] [varchar](50) NULL,"
                                         "[logopath] [varchar](50) NULL,"
                                         "[iconpath] [varchar](50) NULL,"
                                         "[qcpath] [varchar](50) NULL,"
                                         "[minpartition] [varchar](50) NULL,"
                                         "[maxpartition] [varchar](50) NULL,"
                                         "[activationstatus] [integer] NULL,"
                                         "[filetype_allow] [varchar](50) NULL,"
                                         "[filetype_unallow] [varchar](50) NULL,"
                                         "[callbackurl] [varchar](50) NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateAliyunTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 80:
                
                [self AddColumnToTableIfNotExist:@"aliyun_server" columnName:@"[cname]" type:@"[integer]"];
                break;

            case 87:
                
                [self AddColumnToTableIfNotExist:@"aliyun_server" columnName:@"[cnamereadrfsurl]" type:@"[varchar](100)"];
                [self AddColumnToTableIfNotExist:@"aliyun_server" columnName:@"[readbucket]" type:@"[varchar](50)"];
                [self AddColumnToTableIfNotExist:@"aliyun_server" columnName:@"[synchronizetype]" type:@"[integer]"];
            break;
        }
    }
}
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)serverArray{
    [[self getDbQuene:@"aliyun_server" FunctionName:@"addDataWithArray:(NSMutableArray *)serverArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO aliyun_server(rfsid,rfsname,rfstype,rfsurl,bucket,path,logopath,iconpath,qcpath,minpartition,maxpartition,activationstatus,filetype_allow,filetype_unallow,callbackurl,cname,cnamereadrfsurl,readbucket,synchronizetype)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        for (int i = 0; i< serverArray.count;  i++) {
            
            RemotelyServerModel *serverModel = [serverArray objectAtIndex:i];
            NSString *rfsid = serverModel.rfsid;
            NSString *rfsname =serverModel.rfsname;
            NSString *rfstype = serverModel.rfstype;
            NSString *rfsurl =serverModel.rfsurl;
            NSString *bucket = serverModel.bucket;
            NSString *path =serverModel.path;
            NSString *logopath = serverModel.logopath;
            NSString *iconpath =serverModel.iconpath;
            NSString *qcpath = serverModel.qcpath;
            NSString *minpartition =serverModel.minpartition;
            NSString *maxpartition = serverModel.maxpartition;
            NSNumber *activationstatus =[NSNumber numberWithInteger:serverModel.activationstatus];
            NSString * filetype_allow =serverModel.filetype_allow;
            NSString * filetype_unallow =serverModel.filetype_unallow;
            NSString * callbackurl =serverModel.callbackurl;
            NSNumber *cname =[NSNumber numberWithInteger:serverModel.cname] ;
            NSString * cnamereadrfsurl =serverModel.cnamereadrfsurl;
            NSString * readbucket =serverModel.readbucket;
            NSNumber *synchronizetype =[NSNumber numberWithInteger:serverModel.synchronizetype] ;
            isOK = [db executeUpdate:sql,rfsid,rfsname,rfstype,rfsurl,bucket,path,logopath,iconpath,qcpath,minpartition,maxpartition,activationstatus,filetype_allow,filetype_unallow,callbackurl,cname,cnamereadrfsurl,readbucket,synchronizetype];
            if (!isOK) {
                DDLogError(@"插入失败");
                break;
            }
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"aliyun_server" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.lzGlobalVariable.aliyunServerModel = nil;
    [AliyunOSS setInstanceToNil];
}
#pragma mark - 删除数据
-(void)deleteServer{
    
    [[self getDbQuene:@"aliyun_server" FunctionName:@"deleteServer"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from aliyun_server";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"aliyun_server" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.lzGlobalVariable.aliyunServerModel = nil;
    //[AliyunOSS setInstanceToNil];
}

#pragma mark - 查询数据

/**
 查询相应服务器model

 @param rfstype oss：阿里云  lzy:理正云
 @return
 */
-(RemotelyServerModel*)getServerModelWithRfsType:(NSString*)rfstype {

//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AppDelegate *appDelegate = [LZBaseAppDelegate shareInstance].appDelegate;
    __block RemotelyServerModel *serverModel = nil;
    
    if([rfstype isEqualToString:@"oss"]){
        serverModel = appDelegate.lzGlobalVariable.aliyunServerModel;
    }
    
    if (!serverModel) {
		[[self getDbQuene:@"aliyun_server" FunctionName:@"getServerModelWithRfsType:(NSString*)rfstype"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql=[NSString stringWithFormat:@"Select rfsid,rfsname,rfstype,rfsurl,bucket,path,logopath,iconpath,qcpath,minpartition,maxpartition,activationstatus,filetype_allow,filetype_unallow,callbackurl,cname,cnamereadrfsurl,readbucket,synchronizetype"
                           " From aliyun_server Where rfstype='%@'",rfstype];
            FMResultSet *resultSet=[db executeQuery:sql];
            if ([resultSet next]) {
                
                serverModel = [self convertResultSetToModel:resultSet];
                
            }
            [resultSet close];
        }];
        
        if([rfstype isEqualToString:@"oss"]){
            appDelegate.lzGlobalVariable.aliyunServerModel = serverModel;
        }
    }
    
    return serverModel;
}
-(RemotelyServerModel *)convertResultSetToModel:(FMResultSet *)resultSet
{
    NSString *rfsid = [resultSet stringForColumn:@"rfsid"];
    NSString *rfsname = [resultSet stringForColumn:@"rfsname"];
    NSString *rfstype = [resultSet stringForColumn:@"rfstype"];
    NSString *rfsurl = [resultSet stringForColumn:@"rfsurl"];
    NSString *bucket = [resultSet stringForColumn:@"bucket"];
    NSString *path = [resultSet stringForColumn:@"path"];
    NSString *logopath = [resultSet stringForColumn:@"logopath"];
    NSString *iconpath = [resultSet stringForColumn:@"iconpath"];
    NSString *qcpath = [resultSet stringForColumn:@"qcpath"];
    NSString *minpartition = [resultSet stringForColumn:@"minpartition"];
    NSInteger activationstatus = [resultSet intForColumn:@"activationstatus"];
    NSString *maxpartition = [resultSet stringForColumn:@"maxpartition"];;
    NSString *filetype_allow = [resultSet stringForColumn:@"filetype_allow"];
    NSString *callbackurl = [resultSet stringForColumn:@"callbackurl"];
    NSString *filetype_unallow = [resultSet stringForColumn:@"filetype_unallow"];
    NSInteger cname =[resultSet intForColumn:@"cname"];
    NSString *cnamereadrfsurl = [resultSet stringForColumn:@"cnamereadrfsurl"];
    NSString *readbucket = [resultSet stringForColumn:@"readbucket"];
    NSInteger synchronizetype =[resultSet intForColumn:@"synchronizetype"];
    
    RemotelyServerModel *resModel = [[RemotelyServerModel alloc] init];
    resModel.rfsid = rfsid;
    resModel.rfsname = rfsname;
    resModel.rfstype = rfstype;
    resModel.rfsurl = rfsurl;
    resModel.bucket = bucket;
    resModel.path = path;
    resModel.logopath = logopath;
    resModel.iconpath = iconpath;
    resModel.qcpath = qcpath;
    resModel.minpartition = minpartition;
    resModel.activationstatus = activationstatus;
    resModel.maxpartition = maxpartition;
    resModel.filetype_allow = filetype_allow;
    resModel.callbackurl = callbackurl;
    resModel.filetype_unallow = filetype_unallow;
    resModel.cname = cname;
    resModel.cnamereadrfsurl = cnamereadrfsurl;
    resModel.readbucket = readbucket;
    resModel.synchronizetype = synchronizetype;
    return resModel;
    
}


@end
