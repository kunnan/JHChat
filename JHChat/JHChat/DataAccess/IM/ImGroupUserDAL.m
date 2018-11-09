//
//  ImGroupUserDAL.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/2.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-12-02
 Version: 1.0
 Description: 分组成员数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ImGroupUserDAL.h"
#import "FMDatabaseQueue.h"
#import "ImGroupUserModel.h"
#import "ImGroupDAL.h"
#import "ImGroupModel.h"

#define instanceColumns @"iguid,igid,uid,username,igremark,quancheng,jiancheng,face,disturb,jointime"

@implementation ImGroupUserDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImGroupUserDAL *)shareInstance{
    static ImGroupUserDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[ImGroupUserDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createImGroupUserTableIfNotExists{
    NSString *tableName = @"im_group_user";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                                                     "[iguid] [varchar](50) PRIMARY KEY NOT NULL,"
                                                                     "[igid] [varchar](50) NULL,"
                                                                     "[uid] [varchar](50) NULL,"
                                                                     "[username] [varchar](50) NULL,"
                                                                     "[igremark] [varchar](50) NULL,"
                                                                     "[quancheng] [varchar](50) NULL,"
                                                                     "[jiancheng] [varchar](50) NULL,"
                                                                     "[disturb] [integer] NULL,"
                                                                     "[face] [varchar](50) NULL,"
                                         "[jointime] [date] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateImGroupUserTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
//        switch (i) {
//            case 3:
//                [self AddColumnToTableIfNotExist:@"im_group_user" columnName:@"jointime" type:@"[date]"];
//                break;
//        }
    }
}
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(BOOL)addDataWithImGroupUserArray:(NSMutableArray *)imGroupUserArray{
    __block BOOL isSaveSuccess = YES;
    [[self getDbQuene:@"im_group_user" FunctionName:@"addDataWithImGroupUserArray:(NSMutableArray *)imGroupUserArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        for (int i = 0; i< imGroupUserArray.count;  i++) {
            ImGroupUserModel *groupUserModel = [imGroupUserArray objectAtIndex:i];
            
            NSString *iguid = groupUserModel.iguid;
            NSString *igid = groupUserModel.igid;
            NSString *uid = groupUserModel.uid;
            NSString *username = groupUserModel.username;
            NSString *igremark = groupUserModel.igremark;
            NSString *quancheng = groupUserModel.quancheng;
            NSString *jiancheng = groupUserModel.jiancheng;
            NSString *face = groupUserModel.face;
            NSNumber *disturb = [NSNumber numberWithInteger:groupUserModel.disturb];
            NSDate *jointime = groupUserModel.jointime;
            
            NSString *sql = @"INSERT OR REPLACE INTO im_group_user(iguid,igid,uid,username,igremark,quancheng,jiancheng,face,disturb,jointime)"
                            "VALUES (?,?,?,?,?,?,?,?,?,?)";
            isOK = [db executeUpdate:sql,iguid,igid,uid,username,igremark,quancheng,jiancheng,face,disturb,jointime];
            if (!isOK) {
                DDLogError(@"插入失败");
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group_user" Sql:sql Error:@"插入失败" Other:nil];
                isSaveSuccess = NO;
                break;
            }
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
 *  删除群成员
 *
 *  @param igid 群ID
 *  @param uid  用户ID
 */
-(void)deleteGroupUserWithIgid:(NSString *)igid uid:(NSString *)uid{
    
    [[self getDbQuene:@"im_group_user" FunctionName:@"deleteGroupUserWithIgid:(NSString *)igid uid:(NSString *)uid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from im_group_user where igid=? and uid=?";
        isOK = [db executeUpdate:sql,igid,uid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group_user" Sql:sql Error:@"删除失败" Other:nil];
			
			
            DDLogError(@"删除群成员 - deleteGroupUserWithIgid");
        }
    }];
    
}

/**
 *  批量删除群成员
 *
 *  @param igid 群ID
 *  @param uid  用户ID数组
 */
-(void)deleteGroupUserWithIgid:(NSString *)igid uidArr:(NSMutableArray *)uidArr{
    
    [[self getDbQuene:@"im_group_user" FunctionName:@"deleteGroupUserWithIgid:(NSString *)igid uidArr:(NSMutableArray *)uidArr"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
		NSString *sql = @"delete from im_group_user where igid=? and uid=?";

        for(int i=0;i<uidArr.count;i++){
            NSString *uid = [uidArr objectAtIndex:i];
            isOK = [db executeUpdate:sql,igid,uid];
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_group_user" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"批量删除群成员 - deleteGroupUserWithIgid");
        }
    }];
    
}

#pragma mark - 修改数据

///**
// *  更新消息免打扰状态
// *
// *  @param igid 群ID
// *  @param role 状态
// */
//-(void)updateDisturbRole:(NSString *)igid role:(NSString *)role{
//    NSString *currentUid = [[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
//    [[self getDbQuene] inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        BOOL isOK = NO;
//        
//        NSString *sql = [NSString stringWithFormat:@"Update im_group_user Set disturb='%@' Where igid='%@' and uid='%@' ",role, igid, currentUid];
//        isOK = [db executeUpdate:sql];
//        
//        if (!isOK) {
//            DDLogError(@"更新消息免打扰状态 - updateDisturbRole");
//        }
//    }];
//}


#pragma mark - 查询数据

/**
 *  获取群组下面的所有人员
 *
 *  @param igid 群组ID
 *
 *  @return 所有人员信息
 */
-(NSMutableArray *)getGroupUsersWithIgid:(NSString *)igid withNum:(NSInteger)num
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"im_group_user" FunctionName:@"getGroupUsersWithIgid:(NSString *)igid withNum:(NSInteger)num"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select %@"
                       " From im_group_user Where igid='%@' order by quancheng asc",instanceColumns,igid];
        if(num!=-1){
            sql=[NSString stringWithFormat:@"Select %@"
                 " From im_group_user Where igid='%@' order by quancheng asc limit 0,%ld",instanceColumns,igid,num];
        }
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;
}

/**
 *  获取群组下面的所有人员ID
 *
 *  @param igid 群组ID
 *
 *  @return 所有人员ID
 */
-(NSMutableArray *)getGroupUserIDsWithIgid:(NSString *)igid
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"im_group_user" FunctionName:@"getGroupUserIDsWithIgid:(NSString *)igid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select %@"
                       " From im_group_user Where igid='%@'",instanceColumns,igid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            NSString *uid = [resultSet stringForColumn:@"uid"];
            [result addObject:uid];
        }
        [resultSet close];
    }];
    
    return result;
}

/**
 *  获取群组下的人员数量
 *
 *  @param igid 群组ID
 *
 *  @return 人员数量
 */
-(NSInteger)getGroupUserCountWithIgid:(NSString *)igid
{
    __block NSInteger count = 0;
    [[self getDbQuene:@"im_group_user" FunctionName:@"getGroupUserCountWithIgid:(NSString *)igid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select count(0) as count From im_group_user Where igid='%@'",igid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            count = [resultSet intForColumn:@"count"];
        }
        [resultSet close];
    }];
    
    return count;
}

/**
 *  获取群成员列表数据源
 *
 *  @param igid 群组ID
 *  @param hideUid 不需显示的人员ID
 *
 *  @return 字典
 */
-(NSMutableDictionary*)getGroupUsersListForAllWithIgid:(NSString *)igid hideUid:(NSString *)hideUid{

    NSMutableDictionary *sectionDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *indexArr=[NSMutableArray array];
    
    ImGroupModel *groupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:igid];
    NSString *manageUid = groupModel.createuser;
    
    /* 需要不显示的人员非管理员 */
    if(![hideUid isEqualToString:manageUid]){
        [indexArr addObject:@""];
    }
    
    [[self getDbQuene:@"im_group_user" FunctionName:@"getGroupUsersListForAllWithIgid:(NSString *)igid hideUid:(NSString *)hideUid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select DISTINCT SUBSTR(ifnull(jiancheng,'#'),1,1) a From im_group_user Where igid='%@' and uid<>'%@' and uid<>'%@' order by a asc ",igid,hideUid,manageUid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            NSString *a = [[resultSet stringForColumn:@"a"] uppercaseString];
            a = [AppUtils getRightFirstChar:a];
            
            NSMutableArray *array=[NSMutableArray array];
            [sectionDic setObject:array forKey:a];
            
            [indexArr addObject:a];
        }
        [resultSet close];
    }];
    
    [[self getDbQuene:@"im_group_user" FunctionName:@"getGroupUsersListForAllWithIgid:(NSString *)igid hideUid:(NSString *)hideUid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select SUBSTR(ifnull (jiancheng,'#'),1,1) a, %@  From im_group_user  Where igid='%@' and uid<>'%@' order by jiancheng asc ",instanceColumns,igid,hideUid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            NSString *a = [[resultSet stringForColumn:@"a"] uppercaseString];
            a = [AppUtils getRightFirstChar:a];
            
            ImGroupUserModel *userModel = [self convertResultSetToModel:resultSet];
            
            if( [userModel.uid isEqualToString:manageUid] ){
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                [arr addObject:userModel];
                [sectionDic setObject:arr forKey:@"creater"];
            }
            else {
                NSMutableArray *arr=[sectionDic objectForKey:a];
                [arr addObject:userModel];
                [sectionDic setObject:arr forKey:a];
            }
        }
        [resultSet close];
    }];
    
    if([indexArr containsObject:@"#"]){
        [indexArr removeObject:@"#"];
        [indexArr addObject:@"#"];
    }
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:indexArr forKey:@"index"];
    [result setObject:sectionDic forKey:@"section"];
    return result;
}

/**
 *  获取群成员列表数据源 - 未下载完
 *
 *  @param igid 群组ID
 *  @param conditon 条件
 *
 *  @return 字典
 */
-(NSMutableArray *)getGroupUsersListForNotGetAllWithIgid:(NSString *)igid conditon:(NSString *)condition{

    NSMutableArray *resultArr=[NSMutableArray array];
    
    [[self getDbQuene:@"im_group_user" FunctionName:@"getGroupUsersListForNotGetAllWithIgid:(NSString *)igid conditon:(NSString *)condition"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        // 原来是按照加入时间排序，现在按照全称
        NSString *sql=[NSString stringWithFormat:@"Select %@  From im_group_user  Where igid='%@' %@ order by quancheng asc ",instanceColumns,igid,condition];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            ImGroupUserModel *userModel = [self convertResultSetToModel:resultSet];
            [resultArr addObject:userModel];
        }
        [resultSet close];
    }];
    return resultArr;
}

/**
 *  根据Uid获取用户信息
 *
 *  @param uid UID
 *
 *  @return 用户信息
 */
-(ImGroupUserModel *)getGroupUserModelWithUid:(NSString *)uid
{
    __block ImGroupUserModel *groupUserModel = nil;
    [[self getDbQuene:@"im_group_user" FunctionName:@"getGroupUserModelWithUid:(NSString *)uid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select %@"
                       " From im_group_user Where uid='%@'",instanceColumns,uid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            groupUserModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return groupUserModel;
}

///**
// *  判断此群对于当前用户是否为免打扰
// *
// *  @param igid 群ID
// *
// *  @return 是否免打扰
// */
//-(BOOL)checkCurrentUserIsDisturb:(NSString *)igid{
//    NSString *currentUid = [[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
//    
//    __block BOOL isDisturb = NO;
//    [[self getDbQuene] inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        NSString *sql= [NSString stringWithFormat:@"select count(0) count from im_group_user Where igid='%@' and uid='%@' and ifnull(disturb,0)=1",igid,currentUid];
//        FMResultSet *groupSet=[db executeQuery:sql];
//        if ([groupSet next]) {
//            NSInteger count = [groupSet intForColumn:@"count"];
//            if(count>0){
//                isDisturb = YES;
//            }
//        }
//    }];
//    
//    return isDisturb;
//}

#pragma mark - Private Function

/**
 *  将FMResultSet转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return ImGroupUserModel
 */
-(ImGroupUserModel *)convertResultSetToModel:(FMResultSet *)resultSet{

    NSString *iguid = [resultSet stringForColumn:@"iguid"];
    NSString *igid = [resultSet stringForColumn:@"igid"];
    NSString *uid = [resultSet stringForColumn:@"uid"];
    NSString *username = [resultSet stringForColumn:@"username"];
    NSString *igremark = [resultSet stringForColumn:@"igremark"];
    NSString *quancheng = [resultSet stringForColumn:@"quancheng"];
    NSString *jiancheng = [resultSet stringForColumn:@"jiancheng"];
    NSString *face = [resultSet stringForColumn:@"face"];
    NSInteger disturb = [resultSet intForColumn:@"disturb"];
    NSDate *jointime = [resultSet dateForColumn:@"jointime"];
    
    ImGroupUserModel *imGroupUserModel = [[ImGroupUserModel alloc] init];
    imGroupUserModel.iguid = iguid;
    imGroupUserModel.igid = igid;
    imGroupUserModel.uid = uid;
    imGroupUserModel.username = username;
    imGroupUserModel.igremark = igremark;
    imGroupUserModel.quancheng = quancheng;
    imGroupUserModel.jiancheng = jiancheng;
    imGroupUserModel.face = face;
    imGroupUserModel.disturb = disturb;
    imGroupUserModel.jointime = jointime;
    
    return imGroupUserModel;
}

@end
