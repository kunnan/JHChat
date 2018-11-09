//
//  ResDAL.m
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 资源数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ResDAL.h"
#import "ResModel.h"
#import "NSObject+JsonSerial.h"
#import "NSString+SerialToDic.h"
#import "PostFileModel.h"
@implementation ResDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ResDAL *)shareInstance{
    static ResDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[ResDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createResTableIfNotExists
{
    NSString *tableName = @"res";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[rid] [varchar](50) PRIMARY KEY NOT NULL,"
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
                                         "[updatedate] [date] NULL,"
                                         "[version] [integer] NULL,"
                                         "[versionid] [varchar](50) NULL,"
                                         "[rtype] [integer] NULL,"
                                         "[ismain] [integer] NULL,"
                                         "[iscurrentversion] [integer] NULL,"
                                         "[exptype] [varchar](100) NULL,"
                                         "[size] [integer] NULL,"
                                         "[expid] [varchar](50) NULL,"
                                         "[description] [text] NULL,"
                                         "[subcount] [integer] NULL,"
                                         "[uploadstatus] [integer] NULL,"
                                         "[downloadstatus] [integer] NULL,"
                                         "[filePhysicalName] [varchar](50) NULL,"
                                         "[fileinfo] [text] NULL,"
                                         "[isdel] [integer] NULL,"
                                         "[isfavorite] [integer] NULL,"
                                         "[favoritesDic] [text] NULL,"
                                         "[issave] [integer] NULL,"
                                         "[expandinfo] [varchar](100) NULL,"
                                         "[icon] [varchar](50) NULL,"
                                         "[iconurl] [varchar](100) NULL,"
                                         "[sortindex] [integer] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateResTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
           
            case 75:
            
                [self AddColumnToTableIfNotExist:@"res" columnName:@"[operateauthority]" type:@"[integer]"];
                break;
        }
    }
}
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)resArray{
    
	[[self getDbQuene:@"res" FunctionName:@"addDataWithArray:(NSMutableArray *)resArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO res(rid,clienttempid,partitiontype,name,rpid,classid,createuser,createusername,createdate,updateuser,updateusername,updatedate,version,versionid,rtype,ismain,iscurrentversion,exptype,size,expid,description,filePhysicalName,subcount,uploadstatus,downloadstatus,fileinfo,isdel,isfavorite,favoritesDic,expandinfo,icon,iconurl,sortindex,operateauthority)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
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
            NSNumber *version = [NSNumber numberWithInteger:resModel.version];
            NSString *versionid = resModel.versionid;
            NSNumber *rtype = [NSNumber numberWithInteger:resModel.rtype];
            NSNumber *ismain = [NSNumber numberWithInteger:resModel.ismain];
            NSNumber *iscurrentversion = [NSNumber numberWithInteger:resModel.iscurrentversion];
            NSString *exptype = resModel.exptype;
            NSNumber *size = [NSNumber numberWithLongLong:resModel.size];
            NSString *expid = resModel.expid;
            NSString *description = resModel.descript;
            NSNumber *subcount = [NSNumber numberWithInteger:resModel.subcount];
            NSNumber *uploadstatus = [NSNumber numberWithInteger:resModel.uploadstatus];
            NSNumber *downloadstatus = [NSNumber numberWithInteger:resModel.downloadstatus];
            NSString *fileinfo = resModel.fileinfo;
            NSString *filePhysicalName = resModel.filePhysicalName;
            NSNumber *isdel = [NSNumber numberWithInteger:resModel.isdel];
            NSNumber *isfavorite = [NSNumber numberWithInteger:resModel.isfavorite];
            NSString *expandinfo = resModel.expandinfo;
            NSNumber *operateauthority = [NSNumber numberWithInteger:resModel.operateauthority];
            
            NSString *icon = resModel.icon;
            NSString *iconurl = resModel.iconurl;
            NSNumber *sortindex = [NSNumber numberWithInteger:resModel.sortindex];
            
            NSString *favoriteJson = [NSString string];
            favoriteJson = [favoriteJson dictionaryToJson:resModel.favoritesDic];
			
            isOK = [db executeUpdate:sql,rid,clienttempid,partitiontype,name,rpid,classid,createuser,createusername,createdate,updateuser,updateusername,updatedate,version,versionid,rtype,ismain,iscurrentversion,exptype,size,expid,description,filePhysicalName,subcount,uploadstatus,downloadstatus,fileinfo,isdel,isfavorite,favoriteJson,expandinfo,icon,iconurl,sortindex,operateauthority];
            if (!isOK) {
                DDLogError(@"插入失败");
                break;
            }
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
    
}
-(void)addPostFileModel:(PostFileModel*)resModel {
    [[self getDbQuene:@"res" FunctionName:@"addPostFileModel:(PostFileModel*)resModel "] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *rid = resModel.rid;
        NSString *name = resModel.name;
        NSString *rpid = resModel.rpid;
        NSString *classid = resModel.classid;
        NSString *updateusername = resModel.updateusername;
        NSDate *updatedate = resModel.updatedate;
        NSNumber *version = [NSNumber numberWithInteger:[resModel.version integerValue]] ;
        NSString *versionid = resModel.versionid;
        NSNumber *rtype = [NSNumber numberWithInteger:resModel.rtype];
        NSNumber *iscurrentversion = [NSNumber numberWithInteger:resModel.iscurrentversion];
        NSString *exptype = resModel.exptype;
        NSNumber *size = [NSNumber numberWithLongLong:resModel.size];
        NSString *expid = resModel.expid;
        NSNumber *subcount = [NSNumber numberWithInteger:resModel.subcount];
        NSString *expandinfo = resModel.expandinfo;
       
        
        
        NSString *icon = resModel.icon;
        NSString *iconurl = resModel.iconurl;
        NSNumber *sortindex = [NSNumber numberWithInteger:resModel.sortindex];
        
        NSString *sql = @"INSERT OR REPLACE INTO res(rid,clienttempid,partitiontype,name,rpid,classid,createuser,createusername,createdate,updateuser,updateusername,updatedate,version,versionid,rtype,ismain,iscurrentversion,exptype,size,expid,description,filePhysicalName,subcount,uploadstatus,downloadstatus,fileinfo,isdel,isfavorite,favoritesDic,expandinfo,icon,iconurl,sortindex)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,rid,nil,nil,name,rpid,classid,nil,nil,nil,nil,updateusername,updatedate,version,versionid,rtype,nil,iscurrentversion,exptype,size,expid,nil,nil,subcount,nil,nil,nil,nil,nil,nil,expandinfo,icon,iconurl,sortindex];
        if (!isOK) {
            DDLogError(@"插入失败");
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
}
/**
 *  根据ResModel添加资源
 */
-(void)addDataWithModel:(ResModel *)resModel{
    
    [[self getDbQuene:@"res" FunctionName:@"addDataWithModel:(ResModel *)resModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
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
        NSNumber *version = [NSNumber numberWithInteger:resModel.version];
        NSString *versionid = resModel.versionid;
        NSNumber *rtype = [NSNumber numberWithInteger:resModel.rtype];
        NSNumber *ismain = [NSNumber numberWithInteger:resModel.ismain];
        NSNumber *iscurrentversion = [NSNumber numberWithInteger:resModel.iscurrentversion];
        NSString *exptype = resModel.exptype;
        NSNumber *size = [NSNumber numberWithLongLong:resModel.size];
        NSString *expid = resModel.expid;
        NSString *description = resModel.descript;
        NSNumber *subcount = [NSNumber numberWithInteger:resModel.subcount];
        NSNumber *uploadstatus = [NSNumber numberWithInteger:resModel.uploadstatus];
        NSNumber *downloadstatus = [NSNumber numberWithInteger:resModel.downloadstatus];
        NSString *fileinfo = resModel.fileinfo;
         NSString *filePhysicalName = resModel.filePhysicalName;
        NSNumber *isdel = [NSNumber numberWithInteger:resModel.isdel];
        NSNumber *isfavorite = [NSNumber numberWithInteger:resModel.isfavorite];
        NSString *expandinfo = resModel.expandinfo;
        NSNumber *operateauthority = [NSNumber numberWithInteger:resModel.operateauthority];
        
        NSString *icon = resModel.icon;
        NSString *iconurl = resModel.iconurl;
        NSNumber *sortindex = [NSNumber numberWithInteger:resModel.sortindex];

        NSString *favoriteJson = [NSString string];
        favoriteJson = [favoriteJson dictionaryToJson:resModel.favoritesDic];
        
        NSString *sql = @"INSERT OR REPLACE INTO res(rid,clienttempid,partitiontype,name,rpid,classid,createuser,createusername,createdate,updateuser,updateusername,updatedate,version,versionid,rtype,ismain,iscurrentversion,exptype,size,expid,description,filePhysicalName,subcount,uploadstatus,downloadstatus,fileinfo,isdel,isfavorite,favoritesDic,expandinfo,icon,iconurl,sortindex,operateauthority)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,rid,clienttempid,partitiontype,name,rpid,classid,createuser,createusername,createdate,updateuser,updateusername,updatedate,version,versionid,rtype,ismain,iscurrentversion,exptype,size,expid,description,filePhysicalName,subcount,uploadstatus,downloadstatus,fileinfo,isdel,isfavorite,favoriteJson,expandinfo,icon,iconurl,sortindex,operateauthority];
        if (!isOK) {
            DDLogError(@"插入失败");
        }

        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
    
}

#pragma mark - 删除数据

/**
 *  根据Rid删除资源
 *
 *  @param rid rid
 */
-(void)deleteResWithRid:(NSString *)rid{
    
    [[self getDbQuene:@"res" FunctionName:@"deleteResWithRid:(NSString *)rid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from res where rid=?";
        isOK = [db executeUpdate:sql,rid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
}
/**
 *  根据Rpid删除资源
 *
 *  @param rid rpid
 */
-(void)deleteAllResWithRpid:(NSString *)rpid withClassid:(NSString*)classid{
    
    [[self getDbQuene:@"res" FunctionName:@"deleteAllResWithRpid:(NSString *)rpid withClassid:(NSString*)classid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from res where rpid=? AND classid = ?";
        isOK = [db executeUpdate:sql,rpid,classid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
    
}
/**
 *  根据Rpid删除资源
 *
 *  @param rid rpid
 */
-(void)deleteAllResWithClassid:(NSString*)classid{
    
    [[self getDbQuene:@"res" FunctionName:@"deleteAllResWithClassid:(NSString*)classid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from res where classid = ? AND uploadstatus = ?";
        isOK = [db executeUpdate:sql,classid,@"0"];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
    
}
/**
 *  根据Rpid删除资源
 *
 *  @param rid rpid
 */
-(void)deleteAllResWithRpid:(NSString*)rpid{
    
    [[self getDbQuene:@"res" FunctionName:@"deleteAllResWithRpid:(NSString*)rpid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from res where rpid = ? AND uploadstatus = ?";
        isOK = [db executeUpdate:sql,rpid,@"0"];
        
        if (!isOK) {
            [[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res" Sql:sql Error:@"删除失败" Other:nil];
            
            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
    
}
#pragma mark - 修改数据

/**
 *  根据clienttempid修改资源信息
 */
-(void)UpdateResWithClientID:(ResModel *)resModel{
    
    [[self getDbQuene:@"res" FunctionName:@"UpdateResWithClientID:(ResModel *)resModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
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
        NSNumber *version = [NSNumber numberWithInteger:resModel.version];
        NSString *versionid = resModel.versionid;
        NSNumber *rtype = [NSNumber numberWithInteger:resModel.rtype];
        NSNumber *ismain = [NSNumber numberWithInteger:resModel.ismain];
        NSNumber *iscurrentversion = [NSNumber numberWithInteger:resModel.iscurrentversion];
        NSString *exptype = resModel.exptype;
        NSNumber *size = [NSNumber numberWithLongLong:resModel.size];
        NSString *expid = resModel.expid;
        NSString *description = resModel.descript;
        NSNumber *subcount = [NSNumber numberWithInteger:resModel.subcount];
        NSNumber *uploadstatus = [NSNumber numberWithInteger:resModel.uploadstatus];
        NSNumber *downloadstatus = [NSNumber numberWithInteger:resModel.downloadstatus];
        NSString *fileinfo = resModel.fileinfo;
        NSNumber *isdel = [NSNumber numberWithInteger:resModel.isdel];
         NSNumber *isfavorite = [NSNumber numberWithInteger:resModel.isfavorite];
        NSString *expandinfo = resModel.expandinfo;
        NSNumber *operateauthority= [NSNumber numberWithInteger:resModel.operateauthority];
        
        NSString *icon = resModel.icon;
        NSString *iconurl = resModel.iconurl;
        NSNumber *sortindex = [NSNumber numberWithInteger:resModel.sortindex];
        
        NSString *favoriteJson = [NSString string];
        favoriteJson = [favoriteJson dictionaryToJson:resModel.favoritesDic];
        NSString *sql = @"Update res set rid=?,partitiontype=?,name=?,rpid=?,classid=?,createuser=?,createusername=?,createdate=?,updateuser=?,updateusername=?,updatedate=?,version=?,versionid=?,rtype=?,ismain=?,iscurrentversion=?,exptype=?,size=?,expid=?,description=?,subcount=?,uploadstatus=?,downloadstatus=?,fileinfo=?,isdel=?,isfavorite=?,favoritesDic=?,expandinfo =?,icon=?,iconurl=?,sortindex = ?,operateauthority = ? Where clienttempid=?";
        isOK = [db executeUpdate:sql,rid,partitiontype,name,rpid,classid,createuser,createusername,createdate,updateuser,updateusername,updatedate,version,versionid,rtype,ismain,iscurrentversion,exptype,size,expid,description,subcount,uploadstatus,downloadstatus,fileinfo,isdel,isfavorite,favoriteJson,expandinfo,icon,iconurl,sortindex,operateauthority,clienttempid];
        if (!isOK) {
            DDLogError(@"修改失败");
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res" Sql:sql Error:@"更新失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
    
}
/**
 *  根据rid修改资源信息 文件升级用
 */
-(void)UpdateUpgradeFileWithRid:(ResModel *)resModel{
    
    [[self getDbQuene:@"res" FunctionName:@"UpdateUpgradeFileWithRid:(ResModel *)resModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *rid = resModel.rid;
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
        NSNumber *version = [NSNumber numberWithInteger:resModel.version];
        NSString *versionid = resModel.versionid;
        NSNumber *rtype = [NSNumber numberWithInteger:resModel.rtype];
        NSNumber *ismain = [NSNumber numberWithInteger:resModel.ismain];
        NSNumber *iscurrentversion = [NSNumber numberWithInteger:resModel.iscurrentversion];
        NSString *exptype = resModel.exptype;
        NSNumber *size = [NSNumber numberWithLongLong:resModel.size];
        NSString *expid = resModel.expid;
        NSString *description = resModel.descript;
        NSNumber *subcount = [NSNumber numberWithInteger:resModel.subcount];
        NSNumber *uploadstatus = [NSNumber numberWithInteger:resModel.uploadstatus];
        NSNumber *downloadstatus = [NSNumber numberWithInteger:resModel.downloadstatus];
        NSString *fileinfo = resModel.fileinfo;
        NSNumber *isdel = [NSNumber numberWithInteger:resModel.isdel];
         NSNumber *isfavorite = [NSNumber numberWithInteger:resModel.isfavorite];
        NSString *expandinfo = resModel.expandinfo;
        NSNumber *operateauthority = [NSNumber numberWithInteger:resModel.operateauthority];
        
        NSString *icon = resModel.icon;
        NSString *iconurl = resModel.iconurl;
        NSNumber *sortindex = [NSNumber numberWithInteger:resModel.sortindex];
        
        NSString *favoritemodel = [NSString string];
        favoritemodel = [favoritemodel dictionaryToJson:resModel.favoritesDic];
        NSString *sql = @"Update res set rid=?,partitiontype=?,name=?,rpid=?,classid=?,createuser=?,createusername=?,createdate=?,updateuser=?,updateusername=?,updatedate=?,version=?,versionid=?,rtype=?,ismain=?,iscurrentversion=?,exptype=?,size=?,expid=?,description=?,subcount=?,uploadstatus=?,downloadstatus=?,fileinfo=?,isdel=?,isfavorite=?,favoritesDic=?,expandinfo=?,icon=?,iconurl = ?,sortindex = ? ,operateauthority = ? Where rid=?";
        isOK = [db executeUpdate:sql,rid,partitiontype,name,rpid,classid,createuser,createusername,createdate,updateuser,updateusername,updatedate,version,versionid,rtype,ismain,iscurrentversion,exptype,size,expid,description,subcount,uploadstatus,downloadstatus,fileinfo,isdel,isfavorite,favoritemodel,expandinfo,icon,iconurl,sortindex,operateauthority,rid];
        if (!isOK) {
            DDLogError(@"修改失败");
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res" Sql:sql Error:@"更新失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
    
}
/**
 *  修改保存到云盘的文件资源
 *
 *  @param classid 保存过后新的classid
 *  @param rpid    保存过后新的rpid
 *  @param rid     要保存的文件rid
 */
-(void)updateSaveRescource:(NSString *)classid andRpid:(NSString*)rpid withRid:(NSString*)rid{
    
    [[self getDbQuene:@"res" FunctionName:@"updateSaveRescource:(NSString *)classid andRpid:(NSString*)rpid withRid:(NSString*)rid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *sql = @"Update res set classid=? , rpid = ? Where rid=?";
        isOK = [db executeUpdate:sql,classid,rpid,rid];
        if (!isOK) {
            DDLogError(@"修改失败");
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res" Sql:sql Error:@"更新失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
    
}


/**
 *  更新资源的上传状态
 */
-(void)updateResUploadStatus:(ResModel *)resModel status:(NSInteger)uploadStatus{
    
    [[self getDbQuene:@"res" FunctionName:@"updateResUploadStatus:(ResModel *)resModel status:(NSInteger)uploadStatus"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;

        NSNumber *uploadstatus = [NSNumber numberWithInteger:uploadStatus];
        NSString *sql = @"Update res set uploadstatus=? Where rid=?";
        isOK = [db executeUpdate:sql,uploadstatus,resModel.rid];
        if (!isOK) {
            DDLogError(@"修改失败");
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res" Sql:sql Error:@"更新失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
    
}
/**
 *  重命名文件
 */
 - (void) updateResFileName:(NSString *) name withRid:(NSString *)rid
{
    [[self getDbQuene:@"res" FunctionName:@"updateResFileName:(NSString *) name withRid:(NSString *)rid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *sql = @"Update res set name=? Where rid=?";
        isOK = [db executeUpdate:sql,name,rid];
        if (!isOK) {
            DDLogError(@"修改失败");
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res" Sql:sql Error:@"更新失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];

}

/**
 *  更新资源的下载状态
 */
-(void)updateResDownloadStatus:(ResModel *)resModel status:(NSInteger)downloadStatus{
    
    [[self getDbQuene:@"res" FunctionName:@"updateResDownloadStatus:(ResModel *)resModel status:(NSInteger)downloadStatus"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSNumber *uploadstatus = [NSNumber numberWithInteger:downloadStatus];
        NSString *sql = @"";
        if(downloadStatus == App_NetDisk_File_DownloadSuccess){
            sql = @"Update res set downloadstatus=?,fileinfo=? Where rid=?";
            isOK = [db executeUpdate:sql,uploadstatus,resModel.fileinfo,resModel.rid];
        }
        else if(downloadStatus == App_NetDisk_File_DownloadFail){
            sql = @"Update res set downloadstatus=? Where rid=?";
            isOK = [db executeUpdate:sql,uploadstatus,resModel.rid];
        }
        
        if (!isOK) {
            DDLogError(@"修改失败");
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res" Sql:sql Error:@"更新失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
    
}
/**
 *  文件移动修改classID
 */
-(void)updateFileClassid:(ResModel*) fileModel
{
    [[self getDbQuene:@"res" FunctionName:@"updateFileClassid:(ResModel*) fileModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *sql = @"Update res set classid=? Where rid=?";
        isOK = [db executeUpdate:sql,fileModel.classid,fileModel.rid];
        if (!isOK) {
            DDLogError(@"修改失败");
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res" Sql:sql Error:@"更新失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];

    
    
}
// 修改已经收藏的文件的字段
-(void)updateFavoriteFileWithIsfavorite:(NSString*)isfavorite objectid:(NSString*)objectid
{

    [[self getDbQuene:@"res" FunctionName:@"updateFavoriteFileWithIsfavorite:(NSString*)isfavorite objectid:(NSString*)objectid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *sql = @"Update res set isfavorite = ? Where rid=?";
        
        isOK = [db executeUpdate:sql,isfavorite,objectid];
        if (!isOK) {
            DDLogError(@"修改失败");
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res" Sql:sql Error:@"更新失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
    
    
    
}

#pragma mark - 查询数据

/**
 *  获取资源列表
 *
 *  @param classid  文件夹ID
 *  @param start    起始条目
 *  @param count    需要获取的条目数量
 *  @param sortDic  排序规则
 *
 *  @return 资源记录数组
 */
-(NSMutableArray *)getChildModelsWithClassid:(NSString *)classid startNum:(NSInteger)start queryCount:(NSInteger)count sort:(NSMutableDictionary *)sortDic
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    /* 排序信息 */
    NSString *column = [sortDic objectForKey:@"column"];
    NSString *sortrule = [sortDic objectForKey:@"sortrule"];
    NSString *secondSort = [self secondParamertSortWithCurSort:column];
    
    [[self getDbQuene:@"res" FunctionName:@"getChildModelsWithClassid:(NSString *)classid startNum:(NSInteger)start queryCount:(NSInteger)count sort:(NSMutableDictionary *)sortDic"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select rid,clienttempid,partitiontype,name,rpid,classid,createuser,createusername,createdate,updateuser,updateusername,updatedate,version,versionid,rtype,ismain,iscurrentversion,exptype,size,expid,description,filePhysicalName,subcount,ifnull(uploadstatus,0) uploadstatus,ifnull(downloadstatus,0) downloadstatus,fileinfo,isdel,isfavorite,favoritesDic,expandinfo,icon,iconurl,sortindex,operateauthority"
                       " From res Where ifnull(uploadstatus,0)=0 and classid='%@'"
                       " Order by %@ %@,%@ %@ limit %ld,%ld",classid,column,sortrule,secondSort,sortrule,(long)start,count];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {

            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;
}
/**
 *  协作-工作组-文件
 *
 *  @param classid 根文件夹id
 *  @param sortDic 排序
 *
 *  @return 文件数组
 */
-(NSMutableArray *)getChildModelsWithClassid:(NSString *)classid sort:(NSMutableDictionary *)sortDic {
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    /* 排序信息 */
    NSString *column = [sortDic objectForKey:@"column"];
    NSString *sortrule = [sortDic objectForKey:@"sortrule"];
     NSString *secondSort = [self secondParamertSortWithCurSort:column];
    
    [[self getDbQuene:@"res" FunctionName:@"getChildModelsWithClassid:(NSString *)classid sort:(NSMutableDictionary *)sortDic"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select rid,clienttempid,partitiontype,name,rpid,classid,createuser,createusername,createdate,updateuser,updateusername,updatedate,version,versionid,rtype,ismain,iscurrentversion,exptype,size,expid,description,filePhysicalName,subcount,ifnull(uploadstatus,0) uploadstatus,ifnull(downloadstatus,0) downloadstatus,fileinfo,isdel,isfavorite,favoritesDic,expandinfo,icon,iconurl,sortindex,operateauthority"
                       " From res Where ifnull(uploadstatus,0)=0 and classid='%@'"
                       " Order by %@ %@,%@ %@",classid,column,sortrule,secondSort,sortrule];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;
}
/**
 *  获取未上传成功的文件
 *
 *  @param classid  文件夹ID
 *
 *  @return 资源记录数组
 */
-(NSMutableArray *)getNoUploadSuccessModels:(NSString *)classid
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"res" FunctionName:@"getNoUploadSuccessModels:(NSString *)classid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select rid,clienttempid,partitiontype,name,rpid,classid,createuser,createusername,createdate,updateuser,updateusername,updatedate,version,versionid,rtype,ismain,iscurrentversion,exptype,size,expid,description,filePhysicalName,subcount,ifnull(uploadstatus,0) uploadstatus,ifnull(downloadstatus,0) downloadstatus,fileinfo,isdel,isfavorite,favoritesDic,expandinfo,icon,iconurl,sortindex,operateauthority"
                       " From res Where ifnull(uploadstatus,0)<>0 and classid='%@'"
                       " Order by createdate asc",classid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;
}

/**
 *  获取特定资源
 *
 *  @param resid  资源ID
 *  @param clienttempid  客户端临时ID
 *
 *  @return 资源对象
 */
-(ResModel *)getResModelWithResid:(NSString *)resid orClientTempId:(NSString *)clienttempid
{
    __block ResModel *resModel = nil;
    
    [[self getDbQuene:@"res" FunctionName:@"getResModelWithResid:(NSString *)resid orClientTempId:(NSString *)clienttempid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select rid,clienttempid,partitiontype,name,rpid,classid,createuser,createusername,createdate,updateuser,updateusername,updatedate,version,versionid,rtype,ismain,iscurrentversion,exptype,size,expid,description,filePhysicalName,subcount,ifnull(uploadstatus,0) uploadstatus,ifnull(downloadstatus,0) downloadstatus,fileinfo,isdel,isfavorite,favoritesDic,expandinfo,icon,iconurl,sortindex,operateauthority"
                       " From res Where rid='%@' or clienttempid='%@'",resid,clienttempid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
        
           resModel = [self convertResultSetToModel:resultSet];
            
        }
        [resultSet close];
    }];
    
    return resModel;
}
/**
 *  获取特定资源（文件收藏用到 有时候蹦到这里）
 *
 *  @param resid  资源ID
 *
 *  @return 资源对象
 */
-(ResModel *)getResModelWithResid:(NSString *)resid
{
    __block ResModel *resModel = nil;
    
    [[self getDbQuene:@"res" FunctionName:@"getResModelWithResid:(NSString *)resid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select *"
                       " From res Where rid='%@' ",resid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            
          resModel = [self convertResultSetToModel:resultSet];
            
        }
        [resultSet close];
    }];
    
    return resModel;
}
/**
 *  获取图片资源
 *
 *  @param rpid   资源次id
 *  @param rid    资源id
 *  @param extype 文件类型
 *
 *  @return 图片文件model
 */
- (ResModel *) getImageArrayWithRpid:(NSString *)rpid rid:(NSString *)rid extype:(NSString*)extype{
    __block ResModel *resModel = nil;
    
    [[self getDbQuene:@"res" FunctionName:@"getImageArrayWithRpid:(NSString *)rpid rid:(NSString *)rid extype:(NSString*)extype"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select rid,clienttempid,partitiontype,name,rpid,classid,createuser,createusername,createdate,updateuser,updateusername,updatedate,version,versionid,rtype,ismain,iscurrentversion,exptype,size,expid,description,filePhysicalName,subcount,ifnull(uploadstatus,0) uploadstatus,ifnull(downloadstatus,0) downloadstatus,fileinfo,isdel,isfavorite,favoritesDic,expandinfo,icon,iconurl,sortindex,operateauthority"
                       " From res Where rid='%@' and rpid = '%@' and exptype = '%@'",rid,rpid,extype];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            
            resModel = [self convertResultSetToModel:resultSet];
            
        }
        [resultSet close];
    }];
    
    return resModel;

    
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
    NSInteger version = [resultSet intForColumn:@"version"];
    NSString *versionid = [resultSet stringForColumn:@"versionid"];
    NSInteger rtype = [resultSet intForColumn:@"rtype"];
    NSInteger ismain = [resultSet intForColumn:@"ismain"];
    NSInteger iscurrentversion = [resultSet intForColumn:@"iscurrentversion"];
    NSString *exptype = [resultSet stringForColumn:@"exptype"];;
    NSInteger size = [resultSet longLongIntForColumn:@"size"];
    NSString *expid = [resultSet stringForColumn:@"expid"];
    NSString *descript = [resultSet stringForColumn:@"description"];
    NSInteger subcount = [resultSet intForColumn:@"subcount"];
    NSInteger uploadstatus = [resultSet intForColumn:@"uploadstatus"];
    NSInteger downloadstatus = [resultSet intForColumn:@"downloadstatus"];
    NSString *fileinfo = [resultSet stringForColumn:@"fileinfo"];
    NSInteger isdel = [resultSet intForColumn:@"isdel"];
    NSString *filePhysicalName = [resultSet stringForColumn:@"filePhysicalName"];
    NSInteger isfavorite = [resultSet intForColumn:@"isfavorite"];
    NSString *favoriteM = [resultSet stringForColumn:@"favoritesDic"];
    NSString *expandinfo = [resultSet stringForColumn:@"expandinfo"];
    
    NSString *icon = [resultSet stringForColumn:@"icon"];
    NSString *iconurl = [resultSet stringForColumn:@"iconurl"];
    NSInteger sortindex = [resultSet intForColumn:@"sortindex"];
    NSInteger operateauthority = [resultSet intForColumn:@"operateauthority"];
    
    
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
    resModel.ismain = ismain;
    resModel.iscurrentversion = iscurrentversion;
    resModel.exptype = exptype;
    resModel.size = size;
    resModel.expid = expid;
    resModel.descript = descript;
    resModel.subcount = subcount;
    resModel.uploadstatus = uploadstatus;
    resModel.downloadstatus = downloadstatus;
    resModel.fileinfo = fileinfo;
    resModel.isdel = isdel;
    resModel.filePhysicalName = filePhysicalName;
    resModel.isfavorite = isfavorite;
    resModel.expandinfo = expandinfo;
    resModel.icon = icon;
    resModel.iconurl =iconurl;
    resModel.sortindex = sortindex;
    resModel.operateauthority = operateauthority;
    
    NSMutableDictionary *favoriteD = [[NSMutableDictionary alloc] initWithDictionary:[favoriteM seriaToDic]];
    resModel.favoritesDic = favoriteD;
    
    return resModel;

}

#pragma mark - 第二字段排序
-(NSString *) secondParamertSortWithCurSort:(NSString *)sortStr {
    if ([sortStr isEqualToString:@"updatedate"]) {
        return @"name";
    }
    else if ([sortStr isEqualToString:@"name"]) {
        return @"updatedate";
    }
    else if ( [sortStr isEqualToString:@"size"]) {
        return @"name";
    }
    return sortStr;
}
@end
