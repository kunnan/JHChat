//
//  ResBagDAL.m
//  LeadingCloud
//
//  Created by SY on 16/4/5.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "ResBagDAL.h"


@implementation ResBagDAL
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ResBagDAL *)shareInstance{
    static ResBagDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[ResBagDAL alloc] init];
    }
    return instance;
}
#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createResBagTableIfNotExists
{
    NSString *tableName = @"res_bag";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[rid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[expandinfo] [varchar](80) NULL,"
                                         "[name] [varchar](100) NULL,"
                                         "[rpid] [varchar](50) NULL,"
                                         "[classid] [varchar](50) NULL,"
                                         "[icon] [varchar](50) NULL,"
                                         "[iconurl] [varchar](50) NULL,"
                                         "[updateusername] [varchar](50) NULL,"
                                         "[updatedate] [date] NULL,"
                                         "[version] [integer] NULL,"
                                         "[versionid] [varchar](50) NULL,"
                                         "[showversion] [varchar](50) NULL,"
                                         "[rtype] [integer] NULL,"
                                         "[sortindex] [integer] NULL,"
                                         "[iscurrentversion] [integer] NULL,"
                                         "[exptype] [varchar](100) NULL,"
                                         "[size] [integer] NULL,"
                                         "[expid] [varchar](50) NULL,"
                                         "[description] [text] NULL,"
                                         "[subcount] [integer] NULL,"
                                         "[uploadstatus] [integer] NULL,"
                                         "[downloadstatus] [integer] NULL,"
                                         "[fileinfo] [text] NULL,"
                                         "[isdel] [integer] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateResBagTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}
#pragma mark - 删除数据
/**
 *  删除数据库中所有对象
 */
-(void)deleteAllData {
    
    [[self getDbQuene:@"res_bag" FunctionName:@"deleteAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from res_bag";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res_bag" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];

    
    
}
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)resArray{
    
    [[self getDbQuene:@"res_bag" FunctionName:@"addDataWithArray:(NSMutableArray *)resArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO res_bag(rid,expandinfo,name,rpid,classid,icon,iconurl,updateusername,updatedate,version,versionid,showversion,rtype,sortindex,iscurrentversion,exptype,size,expid,description,subcount,uploadstatus,downloadstatus,fileinfo,isdel)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
        for (int i = 0; i< resArray.count;  i++) {
            ResModel *resModel = [resArray objectAtIndex:i];
            
            NSString *rid = resModel.rid;
            NSString *expandinfo = resModel.expandinfo;
            NSString *name = resModel.name;
            NSString *rpid = resModel.rpid;
            NSString *classid = resModel.classid;
            NSString *icon = resModel.icon;
            NSString *iconurl = resModel.iconurl;
            NSString *updateusername = resModel.updateusername;
            NSDate *updatedate = resModel.updatedate;
            NSNumber *version = [NSNumber numberWithInteger:resModel.version];
            NSString *versionid = resModel.versionid;
            NSString *showversion =  resModel.showversion;
            NSNumber *rtype = [NSNumber numberWithInteger:resModel.rtype];
            NSNumber *iscurrentversion = [NSNumber numberWithInteger:resModel.iscurrentversion];
            NSNumber *sortindex = [NSNumber numberWithInteger:resModel.sortindex];
            NSString *exptype = resModel.exptype;
            NSNumber *size = [NSNumber numberWithLongLong:resModel.size];
            NSString *expid = resModel.expid;
            NSString *description = resModel.descript;
            NSNumber *subcount = [NSNumber numberWithInteger:resModel.subcount];
            NSNumber *uploadstatus = [NSNumber numberWithInteger:resModel.uploadstatus];
            NSNumber *downloadstatus = [NSNumber numberWithInteger:resModel.downloadstatus];
            NSString *fileinfo = resModel.fileinfo;
            NSNumber *isdel = [NSNumber numberWithInteger:resModel.isdel];
			
            isOK = [db executeUpdate:sql,rid,expandinfo,name,rpid,classid,icon,iconurl,updateusername,updatedate,version,versionid,showversion,rtype,sortindex,iscurrentversion,exptype,size,expid,description,subcount,uploadstatus,downloadstatus,fileinfo,isdel];
            if (!isOK) {
                DDLogError(@"插入失败");
                break;
            }
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"res_bag" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
    
}
#pragma mark - 查询数据
/**
 *  查询本地文件包里的文件
 *
 *  @param versonid 文件包的rid == 文件包里的版本id
 *
 *  @return 文件包里的内容
 */
-(NSMutableArray *)getResBagModelsWithClassid:(ResModel *)resModel
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    
	[[self getDbQuene:@"res_bag" FunctionName:@"getResBagModelsWithClassid:(ResModel *)resModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select rid,expandinfo,name,rpid,classid,icon,iconurl,updateusername,updatedate,version,versionid,showversion,rtype,sortindex,iscurrentversion,exptype,size,expid,description,subcount,ifnull(downloadstatus,0) downloadstatus,fileinfo,isdel"
                       " From res_bag Where versionid='%@'"
                       ,resModel.rid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;
}
/**
 *  将FMResultSet转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return resmodel
 */
-(ResModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    


    NSString *rid = [resultSet stringForColumn:@"rid"];
    NSString *expandinfo = [resultSet stringForColumn:@"expandinfo"];
    NSString *name = [resultSet stringForColumn:@"name"];
    NSString *rpid = [resultSet stringForColumn:@"rpid"];
    NSString *classid = [resultSet stringForColumn:@"classid"];
    NSString *icon =[resultSet stringForColumn:@"icon"];
    NSString *iconurl = [resultSet stringForColumn:@"iconurl"];
    NSString *updateuser = [resultSet stringForColumn:@"updateuser"];
    NSString *updateusername = [resultSet stringForColumn:@"updateusername"];
    NSDate *updatedate = [resultSet dateForColumn:@"updatedate"];
    NSInteger version = [resultSet intForColumn:@"version"];
    NSString *versionid = [resultSet stringForColumn:@"versionid"];
    NSInteger iscurrentversion = [resultSet intForColumn:@"iscurrentversion"];
    NSInteger sortindex = [resultSet intForColumn:@"sortindex"];
    NSInteger rtype = [resultSet intForColumn:@"rtype"];
    NSString *exptype = [resultSet stringForColumn:@"exptype"];;
    long long size = [resultSet longLongIntForColumn:@"size"];
    NSString *expid = [resultSet stringForColumn:@"expid"];
    NSString *descript = [resultSet stringForColumn:@"description"];
    NSInteger subcount = [resultSet intForColumn:@"subcount"];
    NSInteger downloadstatus = [resultSet intForColumn:@"downloadstatus"];
    NSString *fileinfo = [resultSet stringForColumn:@"fileinfo"];
    NSInteger isdel = [resultSet intForColumn:@"isdel"];
    
    ResModel *resModel = [[ResModel alloc] init];
    resModel.rid = rid;
    resModel.name = name;
    resModel.expandinfo = expandinfo;
    resModel.icon = icon;
    resModel.iconurl = iconurl;
    resModel.sortindex = sortindex;
    resModel.rpid = rpid;
    resModel.classid = classid;
    resModel.updateuser = updateuser;
    resModel.updateusername = updateusername;
    resModel.updatedate = updatedate;
    resModel.version = version;
    resModel.versionid = versionid;
    resModel.rtype = rtype;
    resModel.iscurrentversion = iscurrentversion;
    resModel.exptype = exptype;
    resModel.size = size;
    resModel.expid = expid;
    resModel.descript = descript;
    resModel.subcount = subcount;
    resModel.downloadstatus = downloadstatus;
    resModel.fileinfo = fileinfo;
    resModel.isdel = isdel;
    
    return resModel;
}

@end
