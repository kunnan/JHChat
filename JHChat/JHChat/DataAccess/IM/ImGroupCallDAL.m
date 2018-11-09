//
//  ImGroupCallDAL.m
//  LeadingCloud
//
//  Created by gjh on 2017/8/4.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "ImGroupCallDAL.h"
#import "ImGroupCallModel.h"
#import "AppDateUtil.h"
#import "LZFormat.h"

#define instanceColumns @"groupid,status,chatusers,usercout,starttime,updatetime,roomname,realchatusers,realusercount,iscallother,initiateuid"

@implementation ImGroupCallDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImGroupCallDAL *)shareInstance{
    static ImGroupCallDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[ImGroupCallDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createImGroupCallTableIfNotExists{
    NSString *tableName = @"im_group_call";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[groupid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[status] [varchar](50) NULL,"
                                         "[chatusers] [varchar](50) NULL,"
                                         "[starttime] [date] NULL,"
                                         "[updatetime] [date] NULL,"
                                         "[usercout] [integer] NULL,"
                                         "[roomname] [varchar](50) NULL);",
                                         tableName]];
        
    }
}

/**
 *  升级数据库
 */
-(void)updateImGroupCallTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 67:{
                [self AddColumnToTableIfNotExist:@"im_group_call" columnName:@"[realchatusers]" type:@"[varchar](50)"];
                [self AddColumnToTableIfNotExist:@"im_group_call" columnName:@"[realusercount]" type:@"[integer]"];
                break;
            }
            case 88:{
                [self AddColumnToTableIfNotExist:@"im_group_call" columnName:@"[iscallother]" type:@"[varchar](50)"];
                break;
            }
            case 89:{
                [self AddColumnToTableIfNotExist:@"im_group_call" columnName:@"[initiateuid]" type:@"[varchar](50)"];
                break;
            }
        }
    }
}
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithImGroupCallArray:(NSMutableArray *)imGroupCallArray{
    
    [[self getDbQuene:@"im_group_call" FunctionName:@"addDataWithImGroupCallArray:(NSMutableArray *)imGroupCallArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        for (int i = 0; i< imGroupCallArray.count;  i++) {
            ImGroupCallModel *groupCallModel = [imGroupCallArray objectAtIndex:i];
            
            NSString *groupid = groupCallModel.groupid;
            NSString *status = groupCallModel.status;
            NSDate *starttime = groupCallModel.starttime;
            NSDate *updatetime = groupCallModel.updatetime;
            NSString *chatusers = groupCallModel.chatusers;
            NSNumber *usercout = [NSNumber numberWithInteger:groupCallModel.usercout];
            NSString *roomname = groupCallModel.roomname;
            NSString *realchatusers = groupCallModel.realchatusers;
            NSNumber *realusercount = [NSNumber numberWithInteger:groupCallModel.realusercount];
            NSString *iscallother = groupCallModel.iscallother;
            NSString *initiateuid = groupCallModel.initiateuid;
            
            NSString *sql = @"INSERT OR REPLACE INTO im_group_call(groupid,status,chatusers,usercout,starttime,updatetime,roomname,realchatusers,realusercount,iscallother,initiateuid)"
            "VALUES (?,?,?,?,?,?,?,?,?,?,?)";
            isOK = [db executeUpdate:sql,groupid,status,chatusers,usercout,starttime,updatetime,roomname,realchatusers,realusercount,iscallother,initiateuid];
            if (!isOK) {
                DDLogError(@"插入失败");
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group_call" Sql:sql Error:@"插入失败" Other:nil];

                break;
            }
        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
    
}

/**
 *  批量数据
 */
-(void)addImGroupCallModel:(ImGroupCallModel *)groupCallModel{
    
    [[self getDbQuene:@"im_group_call" FunctionName:@"addImGroupCallModel:(ImGroupCallModel *)groupCallModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *groupid = groupCallModel.groupid;
        NSString *status = groupCallModel.status;
        NSDate *starttime = groupCallModel.starttime;
        NSDate *updatetime = groupCallModel.updatetime;
        NSString *chatusers = groupCallModel.chatusers;
        NSNumber *usercout = [NSNumber numberWithInteger:groupCallModel.usercout];
        NSString *roomname = groupCallModel.roomname;
        NSString *realchatusers = groupCallModel.realchatusers;
        NSNumber *realusercount = [NSNumber numberWithInteger:groupCallModel.realusercount];
        NSString *iscallother = groupCallModel.iscallother;
        NSString *initiateuid = groupCallModel.initiateuid;
        
        NSString *sql = @"INSERT OR REPLACE INTO im_group_call(groupid,status,chatusers,usercout,starttime,updatetime,roomname,realchatusers,realusercount,iscallother,initiateuid)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,groupid,status,chatusers,usercout,starttime,updatetime,roomname,realchatusers,realusercount,iscallother,initiateuid];
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group_call" Sql:sql Error:@"插入失败" Other:nil];

            DDLogError(@"插入失败");
        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
    
}
#pragma mark - 删除
/* 根据群组id删除对应的数据 */
- (void)deleteImGroupCallModelWithGroupId:(NSString *)groupId {
    [[self getDbQuene:@"im_group_call" FunctionName:@"deleteImGroupCallModelWithGroupId:(NSString *)groupId"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from im_group_call where groupid=?";
        isOK = [db executeUpdate:sql,groupId];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group_call" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - deleteImGroupCallModelWithGroupId");
        }
    }];
}

/**
 删除12小时之前的僵尸数据
 */
- (void)deleteImGroupCallMOdelBeforeOneDay {
    __block ImGroupCallModel *imGroupCallModel = nil;
    
    [[self getDbQuene:@"im_group_call" FunctionName:@"deleteImGroupCallMOdelBeforeOneDay"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = [NSString stringWithFormat:@"select %@ from im_group_call",instanceColumns];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            imGroupCallModel = [self convertResultSetToModel:resultSet];
            if (imGroupCallModel != nil) {
                NSString *sendDateTime = [LZFormat Date2String:imGroupCallModel.starttime format:nil];
                /* 当前时间 */
                NSString *currentDate = [AppDateUtil GetCurrentDateForString];
                /* 两个时间点相差分钟数 */
                NSInteger intervalMinutes = [AppDateUtil IntervalMinutesForString:sendDateTime endDate:currentDate];
                if (intervalMinutes > 720) {
                    NSString *sql = @"delete from im_group_call where starttime=?";
                    isOK = [db executeUpdate:sql,imGroupCallModel.starttime];
                    if (!isOK) {
                        DDLogError(@"删除失败 - deleteImGroupCallMOdelBeforeOneDay");
						[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group_call" Sql:sql Error:@"删除失败" Other:nil];

                    }
                }
            }
        }
    }];
}

#pragma mark - 更新
/* 更新表中数据 */
- (void)updateImGroupCallModelWithGroupId:(ImGroupCallModel *)groupCallModel {
    [[self getDbQuene:@"im_group_call" FunctionName:@"updateImGroupCallModelWithGroupId:(ImGroupCallModel *)groupCallModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
//        NSInteger remind = isRemind==YES ? 1 : 0;
        NSString *sql = [NSString stringWithFormat:@"Update im_group_call Set status='%@', chatusers='%@', updatetime='%@', usercout=%ld Where groupid='%@'",groupCallModel.status, groupCallModel.chatusers, groupCallModel.updatetime, groupCallModel.usercout, groupCallModel.groupid];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group_call" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新@状态 - updateImGroupCallModelWithGroupId");
        }
    }];
}
/* 更新真正在通话中的人 */
- (void)updateImGroupCallRealChatWithGroupId:(ImGroupCallModel *)groupCallModel {
    [[self getDbQuene:@"im_group_call" FunctionName:@"updateImGroupCallRealChatWithGroupId:(ImGroupCallModel *)groupCallModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        //        NSInteger remind = isRemind==YES ? 1 : 0;
        NSString *sql = [NSString stringWithFormat:@"Update im_group_call Set realchatusers='%@', realusercount=%ld Where groupid='%@'",groupCallModel.realchatusers, groupCallModel.realusercount, groupCallModel.groupid];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group_call" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新@状态 - updateImGroupCallRealChatWithGroupId");
        }
    }];
}

- (void)updateImGroupCallIsCallOtherWithGroupId:(NSString *)iscallother groupid:(NSString *)groupid {
    [[self getDbQuene:@"im_group_call" FunctionName:@"updateImGroupCallIsCallOtherWithGroupId:(NSString *)iscallother groupid:(NSString *)groupid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = [NSString stringWithFormat:@"update im_group_call set iscallother='%@' where groupid='%@'",iscallother, groupid];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
            [[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group_call" Sql:sql Error:@"更新失败" Other:nil];
            DDLogError(@"更新@状态 - updateImGroupCallIsCallOtherWithGroupId");
        }
    }];
}

#pragma make - 获取
/**
 *  根据groupid获取ImGroupCallModel
 *
 *  @param groupid 联系人ID
 *
 *  @return ImGroupCallModel
 */
- (ImGroupCallModel *)getimGroupCallModelWithGroupid:(NSString *)groupid
{
    __block ImGroupCallModel *imGroupCallModel = nil;
    
    [[self getDbQuene:@"im_group_call" FunctionName:@"getimGroupCallModelWithGroupid:(NSString *)groupid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select %@ from im_group_call Where groupid='%@'",instanceColumns, groupid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            imGroupCallModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return imGroupCallModel;
}

/**
 *  将UserInfoModel转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return ImTemplateDetailModel
 */
-(ImGroupCallModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    
    ImGroupCallModel *imGroupCallModel=[[ImGroupCallModel alloc]init];
    
    imGroupCallModel.groupid=[resultSet stringForColumn:@"groupid"];
    imGroupCallModel.status=[resultSet stringForColumn:@"status"];
    imGroupCallModel.chatusers=[resultSet stringForColumn:@"chatusers"];
    imGroupCallModel.usercout=[resultSet intForColumn:@"usercout"];
    imGroupCallModel.starttime = [resultSet dateForColumn:@"starttime"];
    imGroupCallModel.updatetime = [resultSet dateForColumn:@"updatetime"];
    imGroupCallModel.roomname = [resultSet stringForColumn:@"roomname"];
    imGroupCallModel.realchatusers = [resultSet stringForColumn:@"realchatusers"];
    imGroupCallModel.realusercount = [resultSet intForColumn:@"realusercount"];
    imGroupCallModel.iscallother = [resultSet stringForColumn:@"iscallother"];
    imGroupCallModel.initiateuid = [resultSet stringForColumn:@"initiateuid"];
    
    return imGroupCallModel;
}

@end
