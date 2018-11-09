//
//  UserContactDAL.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/3.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2015-12-02
 Version: 1.0
 Description: 联系人数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "UserContactDAL.h"
#import "AppDateUtil.h"
#import "FMDatabaseQueue.h"
#import "UserDAL.h"
#import "NSString+IsNullOrEmpty.h"
#import "AppUtils.h"

@implementation UserContactDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(UserContactDAL *)shareInstance
{
    static UserContactDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[UserContactDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createUserContactTableIfNotExists
{
    NSString *tableName = @"user_contact";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[ucid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[ctid] [varchar](50) NULL,"
                                         "[remark] [varchar](50) NULL,"
                                         "[addtime] [date] NULL,"
                                         "[especially] [integer] NULL,"
                                         "[isvalid] [integer] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateUserContactTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)userContactArray{

    [[self getDbQuene:@"user_contact" FunctionName:@"addDataWithArray:(NSMutableArray *)userContactArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO user_contact(ucid,ctid,remark,addtime,especially,isvalid)"
		"VALUES (?,?,?,?,?,?)";
        for (int i = 0; i< userContactArray.count;  i++) {
            UserContactModel *userContactModel = [userContactArray objectAtIndex:i];
            
            NSString *ucid = userContactModel.ucid;
            NSString *ctid = userContactModel.ctid;
            NSString *remark = userContactModel.remark;
            NSDate   *addtime = [AppDateUtil GetCurrentDate];
            NSNumber *isvalid = [NSNumber numberWithInt:1];
            NSNumber *especially = [NSNumber numberWithInteger:userContactModel.especially];

            isOK = [db executeUpdate:sql,ucid,ctid,remark,addtime,especially,isvalid];
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user_contact" Sql:sql Error:@"插入失败" Other:nil];

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
    [[self getDbQuene:@"user_contact" FunctionName:@"deleteAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = NO;
        isOK = [db executeUpdate:@"DELETE FROM user_contact"];
		if (!isOK) {
			
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user_contact" Sql:@"DELETE FROM user_contact" Error:@"删除失败" Other:nil];

		}
    }];
}

/**
 *  根据主键，删除记录
 *  @param ucId
 */
-(void)deleteUserContactByUCId:(NSString *)ucId{
    [[self getDbQuene:@"user_contact" FunctionName:@"deleteUserContactByUCId:(NSString *)ucId"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = NO;
       NSString *sqlString=@"DELETE FROM user_contact WHERE ucid=?";
       isOK = [db executeUpdate:sqlString,ucId];
		
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user_contact" Sql:sqlString Error:@"删除失败" Other:nil];

		}
    }];
}

/**
 *  根据用户ID，删除记录
 *  @param ctId
 */
-(void)deleteUserContactByCTId:(NSString *)ctId{
    [[self getDbQuene:@"user_contact" FunctionName:@"deleteUserContactByCTId:(NSString *)ctId"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlString=@"DELETE FROM user_contact WHERE ctid=?";
		BOOL isOK = NO;
       isOK = [db executeUpdate:sqlString,ctId];
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user_contact" Sql:sqlString Error:@"删除失败" Other:nil];
		}
    }];
}



#pragma mark - 修改数据
/**
 *  更新联系人的【星标好友】标记
 *  @param isEspecially 是否是星标好友
 *  @param ucId 联系人id
 */
-(void)setContactEspeciallyValue:(Boolean) isEspecially ucId:(NSString *)ucId{
    [[self getDbQuene:@"user_contact" FunctionName:@"setContactEspeciallyValue:(Boolean) isEspecially ucId:(NSString *)ucId"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
       NSString *sqlString=@"UPDATE user_contact SET especially=? WHERE ucid=?";
		
        NSNumber *tmpValue=[NSNumber numberWithInt:isEspecially?1:0];
		BOOL isOK = NO;

		isOK = [db executeUpdate:sqlString,tmpValue,ucId];
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user_contact" Sql:sqlString Error:@"更新失败" Other:nil];

		}
    }];
}

/**
 *  更新联系人的【星标好友】标记
 *  @param isEspecially 是否是星标好友
 *  @param ctId 好友id
 */
-(void)setContactEspeciallyValueByCtId:(Boolean)isEspecially ctId:(NSString *)ctId{
    [[self getDbQuene:@"user_contact" FunctionName:@"setContactEspeciallyValueByCtId:(Boolean)isEspecially ctId:(NSString *)ctId"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlString=@"UPDATE user_contact SET especially=? WHERE ctid=?";
        NSNumber *tmpValue=[NSNumber numberWithInt:isEspecially?1:0];
		BOOL isOK = NO;

        isOK = [db executeUpdate:sqlString,tmpValue,ctId];
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user_contact" Sql:sqlString Error:@"更新失败" Other:nil];
			
		}
    }];
}


#pragma mark - 查询数据

/**
 *  根据用户id获取好友信息
 *  @param userId 用户id
 *  @return
 */
-(UserContactModel *)getUserContactByUId:(NSString *)userId{
    __block UserContactModel *model=nil;
    [[self getDbQuene:@"user_contact" FunctionName:@"getUserContactByUId:(NSString *)userId"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlString=@"SELECT * FROM user_contact WHERE ctid=?";
        FMResultSet *resultSet=[db executeQuery:sqlString,userId];
        if([resultSet next]){
            model = [self convertResultSet2Model:resultSet];
        }
        [resultSet close];
    }];
    return model;
}

/**
 *  获取好友(分组模式)
 */
-(NSMutableDictionary *)getFriendUserGroupModel
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *index = [[NSMutableArray alloc] init];
    NSMutableDictionary *section = [[NSMutableDictionary alloc] init];
    
    /* 星标好友 */
    NSMutableArray *especiallyResult = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"user_contact" FunctionName:@"getFriendUserGroupModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From User Where uid in (Select ctid From user_contact Where ifnull(especially,0)=1)"];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            UserModel *model = [[UserDAL shareInstance] convertResultSet2Model:resultSet];
            [especiallyResult addObject:model];
        }
        [resultSet close];
    }];
    if(especiallyResult.count>0){
        [index addObject:@"星标好友"];
        [section setObject:especiallyResult forKey:@"星标好友"];
    }
    
    /* 普通好友 */
    [[self getDbQuene:@"user_contact" FunctionName:@"getFriendUserGroupModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select SUBSTR(ifnull(quancheng,'#'),1,1) a,* From User Where uid in (Select ctid From user_contact ) Order by quancheng"];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            NSString *aShowindex = [[resultSet stringForColumn:@"a"] uppercaseString];
            aShowindex = [AppUtils getRightFirstChar:aShowindex];
            
            if(![index containsObject:aShowindex]){
                [index addObject:aShowindex];
            }
            
            UserModel *model = [[UserDAL shareInstance] convertResultSet2Model:resultSet];
            if( [[section allKeys] containsObject:aShowindex] ){
                NSMutableArray *arr=[section objectForKey:aShowindex];
                [arr addObject:model];
                [section setObject:arr forKey:aShowindex];
            }
            else {
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                [arr addObject:model];
                [section setObject:arr forKey:aShowindex];
            }
        }
        [resultSet close];
    }];
    
    if([index containsObject:@"#"]){
        [index removeObject:@"#"];
        [index addObject:@"#"];
    }
    
    /* 返回结果 */
    [result setObject:index forKey:@"index"];
    [result setObject:section forKey:@"section"];
    
    return result;
}

#pragma mark - Private Function

/**
 *  将数据库结果集转换为Model
 *  @param resultSet
 *  @return
 */
-(UserContactModel *)convertResultSet2Model:(FMResultSet *)resultSet{

    UserContactModel *model=[[UserContactModel alloc]init];
    model.ucid=[resultSet stringForColumn:@"ucid"];
    model.ctid=[resultSet stringForColumn:@"ctid"];
    model.remark=[resultSet stringForColumn:@"remark"];
    model.addtime=[LZFormat String2Date:[resultSet stringForColumn:@"addtime"]];
    model.especially=(int)[LZFormat Safe2Int32:[resultSet stringForColumn:@"especially"]];
    model.isvalid=[LZFormat Safe2Int32:[resultSet stringForColumn:@"isvalid"]];

    return model;
}

@end
