//
//  SelfAppDAL.m
//  LeadingCloud
//
//  Created by dfl on 17/4/14.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2017-04-14
 Version: 1.0
 Description: 自建应用数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "SelfAppDAL.h"

@implementation SelfAppDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(SelfAppDAL *)shareInstance{
    static SelfAppDAL *instance = nil;
    
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[SelfAppDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createSelfAppTableIfNotExists
{
    NSString *tableName = @"self_app";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[osappid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[osappcode] [varchar](100) NULL,"
                                         "[descriptions] [text] NULL,"
                                         "[name] [varchar](50) NULL,"
                                         "[osappcolour] [varchar](100) NULL,"
                                         "[oslogo] [varchar](100) NULL,"
                                         "[logorid] [text] NULL,"
                                         "[issupportpc] [integer] NULL,"
                                         "[pcurl] [varchar](500) NULL,"
                                         "[issupportmobile] [integer] NULL,"
                                         "[mobileurl] [varchar](500) NULL,"
                                         "[orgid] [varchar](100) NULL,"
                                         "[createuserid] [varchar](100) NULL,"
                                         "[createtime] [date] NULL,"
                                         "[isavailable] [integer] NULL,"
                                         "[handlertype] [integer] NULL,"
                                         "[permissionslist] [text] NULL);",
                                         tableName]];
    }
}
/**
 *  升级数据库
 */
-(void)updateSelfAppTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 55:{
                [self AddColumnToTableIfNotExist:@"self_app" columnName:@"[noworgid]" type:@"[varchar](50)"];
                [self AddColumnToTableIfNotExist:@"self_app" columnName:@"[nowosappid]" type:@"[varchar](50)"];
                break;
            }
            case 58:{
                [self AddColumnToTableIfNotExist:@"self_app" columnName:@"[version]" type:@"[text]"];
                break;
            }
            case 64:{
                [self AddColumnToTableIfNotExist:@"self_app" columnName:@"[remindnumber]" type:@"[integer]"];
                break;
            }
        }
    }
}

#pragma mark - 添加数据

-(void)addDataWithSelfAppArray:(NSMutableArray *)selfAppArray{
    [[self getDbQuene:@"self_app" FunctionName:@"addDataWithSelfAppArray:(NSMutableArray *)selfAppArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO self_app(osappid,osappcode,descriptions,name,osappcolour,oslogo,logorid,issupportpc,pcurl,issupportmobile,mobileurl,orgid,createuserid,createtime,isavailable,handlertype,permissionslist,noworgid,nowosappid,version,remindnumber)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        for (int i = 0; i< selfAppArray.count;  i++) {
            SelfAppModel *selfAppModel=[selfAppArray objectAtIndex:i];
            
            NSString *osappid=selfAppModel.osappid;
            NSString *osappcode=selfAppModel.osappcode;
            NSString *descriptions=selfAppModel.descriptions;
            NSString *name=selfAppModel.name;
            NSString *osappcolour=selfAppModel.osappcolour;
            NSString *oslogo=selfAppModel.oslogo;
            NSString *logorid=selfAppModel.logorid;
            NSNumber *issupportpc=[NSNumber numberWithInteger:selfAppModel.issupportpc];
            NSString *pcurl=selfAppModel.pcurl;
            NSNumber *issupportmobile=[NSNumber numberWithInteger:selfAppModel.issupportmobile];
            NSString *mobileurl=selfAppModel.mobileurl;
            NSString *orgid=selfAppModel.orgid;
            NSString *createuserid=selfAppModel.createuserid;
            NSDate *createtime = selfAppModel.createtime;
            NSNumber *isavailable=[NSNumber numberWithInteger:selfAppModel.isavailable];
            NSNumber *handlertype=[NSNumber numberWithInteger:selfAppModel.handlertype];
            NSString *permissionslist=selfAppModel.permissionslist;
            NSString *noworgid = selfAppModel.noworgid;
            NSString *nowosappid = selfAppModel.nowosappid;
            NSString *version = selfAppModel.version;
            NSNumber *remindnumber = [NSNumber numberWithInteger:selfAppModel.remindnumber];
			
            isOK = [db executeUpdate:sql,osappid,osappcode,descriptions,name,osappcolour,oslogo,logorid,issupportpc,pcurl,issupportmobile,mobileurl,orgid,createuserid,createtime,isavailable,handlertype,permissionslist,noworgid,nowosappid,version,remindnumber];
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"self_app" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
    
}

/**
 *  插入单条数据
 *
 *  @param model SelfAppModel
 */
-(void)addSelfAppModel:(SelfAppModel *)model{
    [[self getDbQuene:@"self_app" FunctionName:@"addSelfAppModel:(SelfAppModel *)model"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *osappid=model.osappid;
        NSString *osappcode=model.osappcode;
        NSString *descriptions=model.descriptions;
        NSString *name=model.name;
        NSString *osappcolour=model.osappcolour;
        NSString *oslogo=model.oslogo;
        NSString *logorid=model.logorid;
        NSNumber *issupportpc=[NSNumber numberWithInteger:model.issupportpc];
        NSString *pcurl=model.pcurl;
        NSNumber *issupportmobile=[NSNumber numberWithInteger:model.issupportmobile];
        NSString *mobileurl=model.mobileurl;
        NSString *orgid=model.orgid;
        NSString *createuserid=model.createuserid;
        NSDate *createtime = model.createtime;
        NSNumber *isavailable=[NSNumber numberWithInteger:model.isavailable];
        NSNumber *handlertype=[NSNumber numberWithInteger:model.handlertype];
        NSString *permissionslist=model.permissionslist;
        NSString *noworgid = model.noworgid;
        NSString *nowosappid = model.nowosappid;
        NSString *version = model.version;
        NSNumber *remindnumber = [NSNumber numberWithInteger:model.remindnumber];
        
        NSString *sql = @"INSERT OR REPLACE INTO self_app(osappid,osappcode,descriptions,name,osappcolour,oslogo,logorid,issupportpc,pcurl,issupportmobile,mobileurl,orgid,createuserid,createtime,isavailable,handlertype,permissionslist,noworgid,nowosappid,version,remindnumber)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,osappid,osappcode,descriptions,name,osappcolour,oslogo,logorid,issupportpc,pcurl,issupportmobile,mobileurl,orgid,createuserid,createtime,isavailable,handlertype,permissionslist,noworgid,nowosappid,version,remindnumber];
        if (!isOK) {
            DDLogError(@"插入失败");
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"self_app" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
}

#pragma mark - 删除数据
/**
 *  清空所有数据
 */
-(void)deleteAllData{
    [[self getDbQuene:@"self_app" FunctionName:@"deleteAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
	  BOOL isOK = NO;
       isOK = [db executeUpdate:@"DELETE FROM self_app"];
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"self_app" Sql:@"DELETE FROM self_app" Error:@"删除失败" Other:nil];
			
			DDLogError(@"删除失败 - updateMsgId");
		}
    }];
}

/**
 * 根据orgid删除数据
 *
 *  @param orgid
 */
-(void)deleteSelfAppWithOrgid:(NSString*)orgid{
    
    [[self getDbQuene:@"self_app" FunctionName:@"deleteSelfAppWithOrgid:(NSString*)orgid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from self_app where noworgid=?";
        isOK = [db executeUpdate:sql,orgid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"self_app" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
}

#pragma mark - 查询数据

-(NSMutableArray *)getUserAllSelfApp{
    __block SelfAppModel *selfAppModel=nil;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"self_app" FunctionName:@"getUserAllSelfApp"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From self_app where noworgid=%@",[AppUtils GetCurrentOrgID]];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            selfAppModel = [self convertResultSetToModel:resultSet];
            [result addObject:selfAppModel];
        }
        [resultSet close];
    }];
    
    return result;
}

/**
 *  根据id获取SelfAppModel
 *
 *  @param osappid 应用osappid
 *
 *  @return 应用信息
 */
-(SelfAppModel *)getSelfAppModelWithOsAppId:(NSString *)osappid{
    __block SelfAppModel *selfAppModel=nil;
    [[self getDbQuene:@"self_app" FunctionName:@"getSelfAppModelWithOsAppId:(NSString *)osappid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From self_app where nowosappid=%@ and noworgid=%@",osappid,[AppUtils GetCurrentOrgID]];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            selfAppModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return selfAppModel;
}



#pragma mark - Private Function

/**
 *  将FMResultSet转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return ImChatLogModel
 */
-(SelfAppModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    
    NSString *osappid=[resultSet stringForColumn:@"osappid"];
    NSString *osappcode=[resultSet stringForColumn:@"osappcode"];
    NSString *descriptions=[resultSet stringForColumn:@"descriptions"];
    NSString *name=[resultSet stringForColumn:@"name"];
    NSString *osappcolour=[resultSet stringForColumn:@"osappcolour"];
    NSString *oslogo=[resultSet stringForColumn:@"oslogo"];
    NSString *logorid=[resultSet stringForColumn:@"logorid"];
    NSInteger issupportpc=[resultSet intForColumn:@"issupportpc"];
    NSString *pcurl=[resultSet stringForColumn:@"pcurl"];
    NSInteger issupportmobile=[resultSet intForColumn:@"issupportmobile"];
    NSString *mobileurl=[resultSet stringForColumn:@"mobileurl"];
    NSString *orgid=[resultSet stringForColumn:@"orgid"];
    NSString *createuserid=[resultSet stringForColumn:@"createuserid"];
    NSDate *createtime = [resultSet dateForColumn:@"createtime"];
    NSInteger isavailable=[resultSet intForColumn:@"isavailable"];
    NSInteger handlertype=[resultSet intForColumn:@"handlertype"];
    NSString *permissionslist = [resultSet stringForColumn:@"permissionslist"];
    NSString *noworgid = [resultSet stringForColumn:@"noworgid"];
    NSString *nowosappid = [resultSet stringForColumn:@"nowosappid"];
    NSString *version = [resultSet stringForColumn:@"version"];
    NSInteger remindnumber = [resultSet intForColumn:@"remindnumber"];
    
    SelfAppModel *selfAppModel = [[SelfAppModel alloc]init];
    selfAppModel.osappid=osappid;
    selfAppModel.osappcode=osappcode;
    selfAppModel.descriptions=descriptions;
    selfAppModel.name=name;
    selfAppModel.osappcolour=osappcolour;
    selfAppModel.oslogo=oslogo;
    selfAppModel.logorid=logorid;
    selfAppModel.issupportpc=issupportpc;
    selfAppModel.pcurl=pcurl;
    selfAppModel.issupportmobile=issupportmobile;
    selfAppModel.mobileurl=mobileurl;
    selfAppModel.orgid=orgid;
    selfAppModel.createuserid=createuserid;
    selfAppModel.createtime=createtime;
    selfAppModel.isavailable=isavailable;
    selfAppModel.handlertype = handlertype;
    selfAppModel.permissionslist = permissionslist;
    selfAppModel.noworgid = noworgid;
    selfAppModel.nowosappid = nowosappid;
    selfAppModel.version = version;
    selfAppModel.remindnumber = remindnumber;
    
    return selfAppModel;
}

@end
