//
//  ImGroupDAL.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/2.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-12-02
 Version: 1.0
 Description: 分组数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ImGroupDAL.h"
#import "FMDatabaseQueue.h"
#import "ImGroupModel.h"
#import "ImGroupUserDAL.h"
#import "NSString+IsNullOrEmpty.h"

#define instanceColumns @"igid,name,createdate,createuser,renamestate,im_type,showindex,relatetype,relatename,relateid,face,lastmsgdate,lastmsguser,usercount,ifnull(isclosed,0) as isclosed,ifnull(disturb,0) as disturb,ifnull(showmode,0) as showmode,relateopencode,isshow,isnottemp,isshowinlist,isloadmsg,groupresource,imgrouprobots"

@implementation ImGroupDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImGroupDAL *)shareInstance{
    static ImGroupDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[ImGroupDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createImGroupTableIfNotExists{
    NSString *tableName = @"im_group";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                                                     "[igid] [varchar](50) PRIMARY KEY NOT NULL,"
                                                                     "[name] [varchar](50) NULL,"
                                                                     "[createdate] [date] NULL,"
                                                                     "[createuser] [varchar](50) NULL,"
                                                                     "[renamestate] [integer] NULL,"
                                                                     "[im_type] [integer] NULL,"
                                                                     "[showindex] [integer] NULL,"
                                                                     "[relatetype] [integer] NULL,"
                                                                     "[relatename] [varchar](100) NULL,"
                                                                     "[relateid] [varchar](50) NULL,"
                                                                     "[face] [varchar](50) NULL,"
                                                                     "[lastmsgdate] [date] NULL,"
                                                                     "[lastmsguser] [varchar](50) NULL,"
                                         "[usercount] [integer] NULL,"
                                         "[isclosed] [integer] NULL,"
                                         "[disturb] [integer] NULL);",
                                         tableName]];
        
    }
}

/**
 *  升级数据库
 */
-(void)updateImGroupTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 25:{
                [self AddColumnToTableIfNotExist:@"im_group" columnName:@"[showmode]" type:@"[integer]"];
                break;
            }
            case 47:{
                [self AddColumnToTableIfNotExist:@"im_group" columnName:@"[relateopencode]" type:@"[varchar](50)"];
                break;
            }
            case 60:{
                [self AddColumnToTableIfNotExist:@"im_group" columnName:@"[isshow]" type:@"[integer]"];
                [self AddColumnToTableIfNotExist:@"im_group" columnName:@"[isnottemp]" type:@"[integer]"];
                [self AddColumnToTableIfNotExist:@"im_group" columnName:@"[isshowinlist]" type:@"[integer]"];
                break;
            }
            case 85:{
                [self AddColumnToTableIfNotExist:@"im_group" columnName:@"[isloadmsg]" type:@"[integer]"];
                break;
            }
            case 90:{
                [self AddColumnToTableIfNotExist:@"im_group" columnName:@"[groupresource]" type:@"[text]"];
                break;
            }
            case 91:{
                [self AddColumnToTableIfNotExist:@"im_group" columnName:@"[imgrouprobots]" type:@"[text]"];
                break;
            }
        }
    }
}
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithImGroupArray:(NSMutableArray *)imGroupArray{
    
    [[self getDbQuene:@"im_group" FunctionName:@"addDataWithImGroupArray:(NSMutableArray *)imGroupArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        for (int i = 0; i< imGroupArray.count;  i++) {
            ImGroupModel *groupModel = [imGroupArray objectAtIndex:i];
            
            NSString *igid = groupModel.igid;
            NSString *name = groupModel.name;
            NSDate *createdate = groupModel.createdate;
            NSString *createuser = groupModel.createuser;
            NSNumber *imType = [NSNumber numberWithInteger:groupModel.imtype];
            NSNumber *renamestate = [NSNumber numberWithInteger:groupModel.renamestate];
            NSNumber *showindex = [NSNumber numberWithInteger:groupModel.showindex];
            NSNumber *relatetype = [NSNumber numberWithInteger:groupModel.relatetype];
            NSString *relatename = groupModel.relatename;
            NSString *relateid = groupModel.relateid;
            NSString *face = groupModel.face;
            NSDate *lastmsgdate = groupModel.lastmsgdate;
            NSString *lastmsguser = groupModel.lastmsguser;
            NSNumber *usercount = [NSNumber numberWithInteger:groupModel.usercount];
            NSNumber *isclosed = [NSNumber numberWithInteger:groupModel.isclosed];
            NSNumber *disturb = [NSNumber numberWithInteger:groupModel.disturb];
            NSNumber *showmode = [NSNumber numberWithInteger:groupModel.showmode];
            NSString *relateopencode = groupModel.relateopencode;
            NSNumber *isshow = [NSNumber numberWithInteger:groupModel.isshow];
            NSNumber *isnottemp = [NSNumber numberWithInteger:groupModel.isnottemp];
            NSNumber *isshowinlist = [NSNumber numberWithInteger:groupModel.isshowinlist];
            NSNumber *isloadmsg = [NSNumber numberWithInteger:groupModel.isloadmsg];
            NSString *groupresource = groupModel.groupresource;
            NSString *imgrouprobots = groupModel.imgrouprobots;
            
            NSString *sql = @"INSERT OR REPLACE INTO im_group(igid,name,createdate,createuser,renamestate,im_type,showindex,relatetype,relatename,relateid,face,lastmsgdate,lastmsguser,usercount,isclosed,disturb,showmode,relateopencode,isshow,isnottemp,isshowinlist,isloadmsg,groupresource,imgrouprobots)"
            "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            isOK = [db executeUpdate:sql,igid,name,createdate,createuser,renamestate,imType,showindex,relatetype,relatename,relateid,face,lastmsgdate,lastmsguser,usercount,isclosed,disturb,showmode,relateopencode,isshow,isnottemp,isshowinlist,isloadmsg,groupresource,imgrouprobots];
            if (!isOK) {
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group" Sql:sql Error:@"插入失败" Other:nil];

                DDLogError(@"插入失败");
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
-(BOOL)addImGroupModel:(ImGroupModel *)groupModel{
    __block BOOL isSaveSuccess = YES;
    [[self getDbQuene:@"im_group" FunctionName:@"addImGroupModel:(ImGroupModel *)groupModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *igid = groupModel.igid;
        NSString *name = groupModel.name;
        NSDate *createdate = groupModel.createdate;
        NSString *createuser = groupModel.createuser;
        NSNumber *imType = [NSNumber numberWithInteger:groupModel.imtype];
        NSNumber *renamestate = [NSNumber numberWithInteger:groupModel.renamestate];
        NSNumber *showindex = [NSNumber numberWithInteger:groupModel.showindex];
        NSNumber *relatetype = [NSNumber numberWithInteger:groupModel.relatetype];
        NSString *relatename = groupModel.relatename;
        NSString *relateid = groupModel.relateid;
        NSString *face = groupModel.face;
        NSDate *lastmsgdate = groupModel.lastmsgdate;
        NSString *lastmsguser = groupModel.lastmsguser;
        NSNumber *usercount = [NSNumber numberWithInteger:groupModel.usercount];
        NSNumber *isclosed = [NSNumber numberWithInteger:groupModel.isclosed];
        NSNumber *disturb = [NSNumber numberWithInteger:groupModel.disturb];
        NSNumber *showmode = [NSNumber numberWithInteger:groupModel.showmode];
        NSString *relateopencode = groupModel.relateopencode;
        NSNumber *isshow = [NSNumber numberWithInteger:groupModel.isshow];
        NSNumber *isnottemp = [NSNumber numberWithInteger:groupModel.isnottemp];
        NSNumber *isshowinlist = [NSNumber numberWithInteger:groupModel.isshowinlist];
        NSNumber *isloadmsg = [NSNumber numberWithInteger:groupModel.isloadmsg];
        NSString *groupresource = groupModel.groupresource;
        NSString *imgrouprobots = groupModel.imgrouprobots;
        
        NSString *sql = @"INSERT OR REPLACE INTO im_group(igid,name,createdate,createuser,renamestate,im_type,showindex,relatetype,relatename,relateid,face,lastmsgdate,lastmsguser,usercount,isclosed,disturb,showmode,relateopencode,isshow,isnottemp,isshowinlist,isloadmsg,groupresource,imgrouprobots)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,igid,name,createdate,createuser,renamestate,imType,showindex,relatetype,relatename,relateid,face,lastmsgdate,lastmsguser,usercount,isclosed,disturb,showmode,relateopencode,isshow,isnottemp,isshowinlist,isloadmsg,groupresource,imgrouprobots];
        if (!isOK) {
            DDLogError(@"插入失败");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group" Sql:sql Error:@"插入失败" Other:nil];
            isSaveSuccess = NO;
        }

        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
    return isSaveSuccess;
}

#pragma mark - 删除数据

/**
 *  清空所有群组及群组人员数据---（登录后删除旧数据）
    2017-07-07修改：登录时删除isshowinlist=1的群组信息，重新获取
 */
-(void)deleteAllShowGroup{
    [[self getDbQuene:@"im_group" FunctionName:@"deleteAllShowGroup"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
//        NSString *sql = @"delete from im_group_user Where igid in (select igid from im_group where (im_type=1 or (im_type=2 and (relatetype=0 or relatetype=3 or relatetype=4))))";
        NSString *sql = @"delete from im_group_user Where igid in (select igid from im_group where isshowinlist=1)";
        [db executeUpdate:sql];
        //where (im_type=1 or (im_type=2 and (relatetype=0 or relatetype=3 or relatetype=4)))
        /* 讨论组群或者工作组群中的群组、部门、企业 */
//        sql = @"delete from im_group where (im_type=1 or (im_type=2 and (relatetype=0 or relatetype=3 or relatetype=4)))";
        sql = @"delete from im_group where isshowinlist=1";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除群和群成员失败 - deleteAllShowGroup");
        }
    }];
}

-(void)deleteAllShowGroupUser{
    [[self getDbQuene:@"im_group" FunctionName:@"deleteAllShowGroupUser"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from im_group_user Where igid in (select igid from im_group where isshowinlist=1)";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除群和群成员失败 - deleteAllShowGroup");
        }
    }];
}

/**
 删除im_type为2的组群信息
 */
- (void)deleteGroupInfoImTypeIsTwo {
    [[self getDbQuene:@"im_group" FunctionName:@"deleteGroupInfoImTypeIsTwo"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete FROM im_group where im_type = 2";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group" Sql:sql Error:@"删除失败" Other:nil];
            DDLogError(@"群信息清除成功");
        }
    }];
}

/**
 *  删除特定批次的群组及其人员数据---（登录后删除旧数据）
 */
-(void)deleteWithImGroupArray:(NSMutableArray *)imGroupArray{    
    [[self getDbQuene:@"im_group" FunctionName:@"deleteWithImGroupArray:(NSMutableArray *)imGroupArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        for (int i = 0; i< imGroupArray.count;  i++) {
            ImGroupModel *groupModel = [imGroupArray objectAtIndex:i];
            NSString *igid = groupModel.igid;
            
            NSString *sql = @"delete from im_group_user where igid=?";
            [db executeUpdate:sql,igid];
            
            sql = @"delete from im_group where igid=?";
            isOK = [db executeUpdate:sql,igid];
            
            if (!isOK) {
                DDLogError(@"删除失败");
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group" Sql:sql Error:@"删除失败" Other:nil];

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
 *  删除群
 *
 *  @param igid 群ID
 */
-(BOOL)deleteGroupWithIgid:(NSString *)igid isDeleteImRecent:(BOOL)isdeleteimrecent{
    __block BOOL isSaveSuccess = YES;
    [[self getDbQuene:@"im_group" FunctionName:@"deleteGroupWithIgid:(NSString *)igid isDeleteImRecent:(BOOL)isdeleteimrecent"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from im_group_user where igid=?";
        isOK = [db executeUpdate:sql,igid];
        if (!isOK) {
            isSaveSuccess = NO;
        }
        
        sql = @"delete from im_group where igid=?";
        isOK = [db executeUpdate:sql,igid];
        
        if (!isOK) {
            DDLogError(@"删除群成员 - deleteGroupUserWithIgid");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group" Sql:sql Error:@"删除失败" Other:nil];
            isSaveSuccess = NO;
        }
        else {
            if(isdeleteimrecent){
                sql = @"delete from im_recent Where contactid=?";
                isOK = [db executeUpdate:sql,igid];
                if (!isOK) {
                    isSaveSuccess = NO;
                }
            }
        }
    }];
    return isSaveSuccess;
}
/* 清空群聊数据和群成员数据 */
- (void)deleteGroupAndGroupUserData {
    [[self getDbQuene:@"im_group" FunctionName:@"deleteGroupAndGroupUserData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from im_group_user";
        [db executeUpdate:sql];
        
        sql = @"delete from im_group";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除群成员 - deleteGroupUserWithIgid");
        }
    }];
}


#pragma mark - 修改数据

/**
 *  更新群组名称
 *
 *  @param igid      群ID
 *  @param groupname 群名称
 *  @param isrename  是否为重命名
 */
-(void)updateGroupNameWithIgid:(NSString *)igid groupName:(NSString *)groupname isRename:(BOOL)isrename{
    
    [[self getDbQuene:@"im_group" FunctionName:@"updateGroupNameWithIgid:(NSString *)igid groupName:(NSString *)groupname isRename:(BOOL)isrename"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"";
        if(!isrename){
            sql = @"update im_group set name=? Where igid=?";
        }
        else {
            sql = @"update im_group set name=?,renamestate=1 Where igid=?";
        }
        isOK = [db executeUpdate:sql,groupname,igid];
        
        if (!isOK) {
            DDLogError(@"更新失败 - updateMsgId");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group" Sql:sql Error:@"更新失败" Other:nil];

        }
        else {
            sql = @"update im_recent set contactname=? Where contactid=?";
            [db executeUpdate:sql,groupname,igid];
        }
    }];
    
}

/**
 *  修改群管理员
 *
 *  @param uid  新管理员ID
 *  @param igid 群ID
 */
-(void)updateGroupCreateUser:(NSString *)uid groupid:(NSString *)igid{
    
    [[self getDbQuene:@"im_group" FunctionName:@"updateGroupCreateUser:(NSString *)uid groupid:(NSString *)igid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update im_group set createuser=? Where igid=?";
        isOK = [db executeUpdate:sql,uid,igid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateGroupCreateUser");
        }
    }];
}
/**
 *  修改群机器人
 *
 *  @param 
 *  @param igid 群ID
 */
-(void)updateGroupGroupRobot:(NSString *)groupRobot groupid:(NSString *)igid{
    
    [[self getDbQuene:@"im_group" FunctionName:@"updateGroupGroupRobot:(NSString *)groupRobot groupid:(NSString *)igid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update im_group set imgrouprobots=? Where igid=?";
        isOK = [db executeUpdate:sql,groupRobot,igid];
        
        if (!isOK) {
            [[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group" Sql:sql Error:@"更新失败" Other:nil];
            
            DDLogError(@"更新失败 - updateGroupCreateUser");
        }
    }];
}
/**
 *  添加群组人员加，添加数量
 */
-(void)updateGroupUserForAddCount:(NSInteger)newcount igid:(NSString *)igid{
    DDLogVerbose(@"群组中人员个数发生改动");
    [[self getDbQuene:@"im_group" FunctionName:@"updateGroupUserForAddCount:(NSInteger)newcount igid:(NSString *)igid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        
        NSString *sql = [NSString stringWithFormat:@"Update im_group Set usercount=usercount+%ld Where igid='%@'",newcount,igid];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"添加群组人员加，添加数量 - updateGroupUserForAddCount");
        }
    }];
}

/**
 *  减少群组人员加，减少的数量
 */
-(void)updateGroupUserForReduceCount:(NSInteger)reducecount igid:(NSString *)igid{
    DDLogVerbose(@"群组中人员个数发生改动");
    [[self getDbQuene:@"im_group" FunctionName:@"updateGroupUserForReduceCount:(NSInteger)reducecount igid:(NSString *)igid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        
        NSString *sql = [NSString stringWithFormat:@"Update im_group Set usercount=usercount-%ld Where igid='%@'",reducecount,igid];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"减少群组人员加，减少的数量 - updateGroupUserForReduceCount");
        }
    }];
}

/**
 *  更新群组人员数量
 */
-(void)updateGroupUserCount:(NSInteger)usercount igid:(NSString *)igid{
    DDLogVerbose(@"群组中人员个数发生改动");
    [[self getDbQuene:@"im_group" FunctionName:@"updateGroupUserCount:(NSInteger)usercount igid:(NSString *)igid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        
        NSString *sql = [NSString stringWithFormat:@"Update im_group Set usercount=%ld Where igid='%@'",usercount,igid];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新群组人员数量 - updateGroupUserCount");
        }
    }];
}

/**
 *  打开、关闭群组
 */
-(void)updateGroupIsClosed:(NSInteger)isclosed igid:(NSString *)igid{
    [[self getDbQuene:@"im_group" FunctionName:@"updateGroupIsClosed:(NSInteger)isclosed igid:(NSString *)igid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        
        NSString *sql = [NSString stringWithFormat:@"Update im_group Set isclosed=%ld Where igid='%@'",isclosed,igid];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"打开、关闭群组 - updateGroupIsClosed");
        }
    }];
}

/**
 *  更新消息免打扰状态
 *
 *  @param igid 群ID
 *  @param role 状态
 */
-(void)updateDisturbRole:(NSString *)igid role:(NSInteger)role{
    [[self getDbQuene:@"im_group" FunctionName:@"updateDisturbRole:(NSString *)igid role:(NSInteger)role"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        
        NSString *sql = [NSString stringWithFormat:@"Update im_group Set disturb=%ld Where igid='%@'",role,igid];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"打开、关闭群组 - updateGroupIsClosed");
        }
    }];
}

/**
 更新是否保存通讯录

 @param igid
 @param show
 */
- (void)updateIsSaveToAddress:(NSString *)igid show:(NSInteger)show {
    [[self getDbQuene:@"im_group" FunctionName:@"updateIsSaveToAddress:(NSString *)igid show:(NSInteger)show"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        
        NSString *sql = [NSString stringWithFormat:@"Update im_group Set isshow=%ld,isshowinlist=%ld Where igid='%@'",show,show,igid];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"保存通讯录失败");
        }
    }];
}

/**
 更新其他群组为临时状态
 */
- (void)updateOtherGroupWithTempStatus {
    [[self getDbQuene:@"im_group" FunctionName:@"updateOtherGroupWithTempStatus"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = [NSString stringWithFormat:@"Update im_group Set isnottemp=0 Where isshowinlist=0"];
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新其他群组为临时状态");
        }
    }];
}

/**
 *  更新新成员加入是否加载聊天记录
 *
 *  @param contactid 联系人id
 */
-(void)updateIsLoadMsg:(NSString *)igid state:(NSString *)isLoadMsg {
    if(![NSString isNullOrEmpty:igid]){
        [[self getDbQuene:@"im_group" FunctionName:@"updateIsLoadMsg:(NSString *)igid state:(NSString *)isLoadMsg"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
            BOOL isOK = NO;
            
            NSString *newState = isLoadMsg;
            if([NSString isNullOrEmpty:newState]){
                newState = @"0";
            }
            
            NSString *sql = [NSString stringWithFormat:@"Update im_group Set isloadmsg=%ld Where igid='%@'",(long)[newState integerValue], igid];
            isOK = [db executeUpdate:sql];
            
            if (!isOK) {
                DDLogError(@"更新新成员加入是否加载聊天记录 - updateIsLoadMsg");
            }
        }];
    }
}

#pragma mark - 查询数据
/**
 *  获取所有的聊天群组
    2017-07-07修改：只显示isshow=1的群组
 *  @return
 */
-(NSArray<ImGroupModel *> *)getImGroups{
    NSMutableArray<ImGroupModel *> *tmpDataArray = [[NSMutableArray alloc]init];
    [[self getDbQuene:@"im_group" FunctionName:@"getImGroups"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        NSString *sqlString = [NSString stringWithFormat:@"SELECT %@ FROM im_group WHERE (im_type=1 or (im_type=2 and (relatetype=0 or relatetype=3 or relatetype=4))) and ifnull(isclosed,0)=0 and ifnull(showmode,0)<>1 order by createdate desc",instanceColumns];
        NSString *sqlString = [NSString stringWithFormat:@"SELECT %@ FROM im_group WHERE isshowinlist=1 and ifnull(isclosed,0)=0 and ifnull(showmode,0)<>1 order by createdate desc",instanceColumns];
        FMResultSet *resultSet=[db executeQuery:sqlString];
        while ([resultSet next]) {
            ImGroupModel *imGroupModel=[self convertResultSet2Model:resultSet];
            
            /* 判断当前人是否被移出群组 */
            NSString *sql= [NSString stringWithFormat:@"select count(0) count from im_recent Where contactid='%@' and ifnull(isexistsgroup,1)=0",imGroupModel.igid];
            FMResultSet *groupSet=[db executeQuery:sql];
            if ([groupSet next]) {
                NSInteger count = [groupSet intForColumn:@"count"];
                if(count>0){
                    continue;
                }
            }
            [tmpDataArray addObject:imGroupModel];
            [groupSet close];
        }
        [resultSet close];
    }];
    return tmpDataArray;
}

/**
 *  获取type为1的聊天群组
 *  @return
 */
-(NSArray<ImGroupModel *> *)getImGroupsTypeIsOne{
    NSMutableArray<ImGroupModel *> *tmpDataArray = [[NSMutableArray alloc]init];
    [[self getDbQuene:@"im_group" FunctionName:@"getImGroupsTypeIsOne"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlString = [NSString stringWithFormat:@"Select %@,(select count(0) from im_group_user Where igid = im_group.igid) as reallycount  From im_group where im_type=1 and usercount<=%ld and usercount<=reallycount and ifnull(showmode,0)<>1 ",instanceColumns,(long)ImGroup_Default_DownUserCount];
        FMResultSet *resultSet=[db executeQuery:sqlString];
        while ([resultSet next]) {
            ImGroupModel *imGroupModel=[self convertResultSet2Model:resultSet];
            [tmpDataArray addObject:imGroupModel];
        }
        [resultSet close];
    }];
    
    return tmpDataArray;
}
/**
 *  根据群组ID获取群组信息
 *
 *  @param igid 群组ID
 *
 *  @return 群信息Model
 */
-(ImGroupModel *)getImGroupWithIgid:(NSString *)igid
{
    __block ImGroupModel *imGroupModel = nil;
    
	[[self getDbQuene:@"im_group" FunctionName:@"getImGroupWithIgid:(NSString *)igid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select %@ From im_group Where igid='%@'", instanceColumns, igid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            imGroupModel=[self convertResultSet2Model:resultSet];
        }
        [resultSet close];
    }];
    
    return imGroupModel;
}

/**
 *  根据工作组ID获取群组ID
 *
 *  @param gid 工作组ID
 *
 *  @return  群ID
 */
-(NSString *)getImGroupWithIgidFromWorkGroup:(NSString *)gid{
    
    __block NSString *igid = nil;
    
    [[self getDbQuene:@"im_group" FunctionName:@"getImGroupWithIgidFromWorkGroup:(NSString *)gid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select igid"
                       " From im_group Where relateid='%@'", gid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            igid=[resultSet stringForColumn:@"igid"];
        }
        [resultSet close];
    }];
    
    return igid;
    
}

/**
 *  通过群组的ID获取每一个群组的成员ID
 *
 *  @param groupID 群组ID
 *
 *  @return 数组
 */
-(NSMutableArray<ImGroupUserModel *> *) getUserIDEveryGroup:(NSString *) groupID {
    NSMutableArray<ImGroupUserModel *> *tmpArray=[[NSMutableArray alloc]init];
    
    [[self getDbQuene:@"im_group" FunctionName:@"getUserIDEveryGroup:(NSString *) groupID"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"SELECT uid FROM im_group_user WHERE igid =  '%@' ORDER BY uid;", groupID];
        FMResultSet *resultSet=[db executeQuery:sql];
        
        while ([resultSet next]) {
            ImGroupUserModel *model=[[ImGroupUserModel alloc]init];
            
            model.uid=[resultSet stringForColumn:@"uid"];
            
            [tmpArray addObject:model];
        }
        [resultSet close];
    }];
    return [tmpArray copy];
}
/**
 *  搜索群组
 *  @param seachText 搜索关键字
 *  @return
 */
-(NSMutableArray *)searchGroupWithSearchText:(NSString *)seachText {
    NSMutableArray<ContactRootSearchModel2 *> *retArray=[NSMutableArray array];
    //      SELECT * FROM im_group WHERE relatetype!=1 AND relatetype!=2
    NSString *sqlString=@"select igid,name,im_type,face,relatetype from im_group"
    "                                         where (relatetype!=1 AND relatetype!=2) and (name like '%%%@%%%') and ifnull(showmode,0)<>1 order by createdate asc";
    seachText=[seachText uppercaseString];
    sqlString=[NSString stringWithFormat:sqlString,seachText,seachText,seachText,seachText];
    [[self getDbQuene:@"im_group" FunctionName:@"searchGroupWithSearchText:(NSString *)seachText"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *resultSet=[db executeQuery:sqlString];
        while ([resultSet next]) {
            ContactRootSearchModel2 *cellModel = [[ContactRootSearchModel2 alloc] init];
            cellModel.gid = [resultSet stringForColumn:@"igid"];
            cellModel.groupName = [resultSet stringForColumn:@"name"];
            cellModel.des = @"";
            cellModel.face = [resultSet stringForColumn:@"face"];
            cellModel.imType = [resultSet intForColumn:@"im_type"];
            cellModel.relateType = [resultSet intForColumn:@"relatetype"];
            [retArray addObject:cellModel];
        }
        [resultSet close];
    }];
    return [retArray copy];
}

/**
 *  搜索我的群组列表
 *  @param seachText 搜索关键字
 *  @return
 */
-(NSMutableArray<ImGroupModel *> *)searchGroupListBySearchText:(NSString *)seachText {
    NSMutableArray<ImGroupModel *> *tmpDataArray = [[NSMutableArray alloc]init];
    NSString *sqlString = [NSString stringWithFormat:@"select %@ from im_group"
                           "                                         where (relatetype!=1 AND relatetype!=2) and (name like '%%%@%%') and ifnull(showmode,0)<>1 order by createdate asc", instanceColumns, seachText];
//    seachText=[seachText uppercaseString];
//    sqlString=[NSString stringWithFormat:sqlString,seachText,seachText,seachText];
    [[self getDbQuene:@"im_group" FunctionName:@"searchGroupListBySearchText:(NSString *)seachText"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *resultSet=[db executeQuery:sqlString];
        while ([resultSet next]) {
            ImGroupModel *imGroupModel=[self convertResultSet2Model:resultSet];
            [tmpDataArray addObject:imGroupModel];
        }
        [resultSet close];
    }];
    return tmpDataArray;
}
/**
 *  判断群组人员是否加载完
 */
-(BOOL)checkIsLoadAllUser:(NSString *)igid{
    ImGroupModel *imGroupModel = [self getImGroupWithIgid:igid];
    /* 获取GroupUser表中的人员数量 */
    NSInteger count = [[ImGroupUserDAL shareInstance] getGroupUserCountWithIgid:igid];
    
    return imGroupModel.usercount>=count;
}

/**
 *  判断此群对于当前用户是否为免打扰
 *
 *  @param igid 群ID
 *
 *  @return 是否免打扰
 */
-(BOOL)checkCurrentUserIsDisturb:(NSString *)igid{
    
    __block BOOL isDisturb = NO;
    [[self getDbQuene:@"im_group" FunctionName:@"checkCurrentUserIsDisturb:(NSString *)igid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql= [NSString stringWithFormat:@"select count(0) count from im_group Where igid='%@' and ifnull(disturb,0)=1",igid];
        FMResultSet *groupSet=[db executeQuery:sql];
        if ([groupSet next]) {
            NSInteger count = [groupSet intForColumn:@"count"];
            if(count>0){
                isDisturb = YES;
            }
        }
        [groupSet close];
    }];
    
    return isDisturb;
}

/**
 判断群聊是否保存到通讯录中

 @param igid
 @return
 */
- (BOOL)checkGroupIsSaveToAddress:(NSString *)igid {
    __block BOOL isSaveToAddress = NO;
    [[self getDbQuene:@"im_group" FunctionName:@"checkGroupIsSaveToAddress:(NSString *)igid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select count(0) count from im_group Where igid='%@' and ifnull(isshowinlist,0)=1",igid];
        FMResultSet *groupSet = [db executeQuery:sql];
        if ([groupSet next]) {
            NSInteger count = [groupSet intForColumn:@"count"];
            if (count > 0) {
                isSaveToAddress = YES;
            }
        }
        [groupSet close];
    }];
    return isSaveToAddress;
}
/* 判断新成员加入是否需要加载消息 */
- (BOOL)checkIsLoadMsg:(NSString *)contactid {
    __block BOOL isLoadMsg = NO;
    [[self getDbQuene:@"im_group" FunctionName:@"checkIsLoadMsg:(NSString *)contactid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select count(0) count from im_group Where igid='%@' and isloadmsg!=0",contactid];
        FMResultSet *resultSet = [db executeQuery:sql];
        if ([resultSet next]) {
            NSInteger count = [resultSet intForColumn:@"count"];
            if (count > 0) {
                isLoadMsg = YES;
            }
        }
    }];
    return isLoadMsg;
}

#pragma mark 将查询结果集转换为Model对象

/**
 *  将查询结果集转换为Model对象
 *  @param resultSet
 *  @return
 */
-(ImGroupModel *)convertResultSet2Model:(FMResultSet *)resultSet{
    ImGroupModel *model=[[ImGroupModel alloc]init];
    // igid,name,createdate,createuser,renamestate,im_type,showindex,relatetype,relatename,relateid,lastmsgdate,lastmsguser
    model.igid=[resultSet stringForColumn:@"igid"];
    model.name=[resultSet stringForColumn:@"name"];
    model.createdate=[LZFormat String2Date:[resultSet stringForColumn:@"createdate"]];
    model.createuser=[resultSet stringForColumn:@"createuser"];
    model.renamestate=[LZFormat Safe2Int32:[resultSet stringForColumn:@"renamestate"]];
    model.imtype=[LZFormat Safe2Int32:[resultSet stringForColumn:@"im_type"]];
    model.showindex=[LZFormat Safe2Int32:[resultSet stringForColumn:@"showindex"]];
    model.relatetype=[LZFormat Safe2Int32:[resultSet stringForColumn:@"relatetype"]];
    model.relatename=[resultSet stringForColumn:@"relatename"];
    model.relateid=[resultSet stringForColumn:@"relateid"];
    model.face=[resultSet stringForColumn:@"face"];
    model.createdate=[LZFormat String2Date:[resultSet stringForColumn:@"lastmsgdate"]];
    model.lastmsguser=[resultSet stringForColumn:@"lastmsguser"];
    model.usercount=[LZFormat Safe2Int32:[resultSet stringForColumn:@"usercount"]];
    model.isclosed=[resultSet intForColumn:@"isclosed"];
    model.disturb=[resultSet intForColumn:@"disturb"];
    model.showmode=[resultSet intForColumn:@"showmode"];
    model.relateopencode = [resultSet stringForColumn:@"relateopencode"];
    model.isshow = [resultSet intForColumn:@"isshow"];
    model.isnottemp = [resultSet intForColumn:@"isnottemp"];
    model.isshowinlist = [resultSet intForColumn:@"isshowinlist"];
    model.isloadmsg = [resultSet intForColumn:@"isloadmsg"];
    model.groupresource = [resultSet stringForColumn:@"groupresource"];
    model.imgrouprobots = [resultSet stringForColumn:@"imgrouprobots"];
    
    return model;
}

@end
