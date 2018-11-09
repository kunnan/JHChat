//
//  UserInfoDAL.m
//  LeadingCloud
//
//  Created by dfl on 16/6/30.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "UserInfoDAL.h"

@implementation UserInfoDAL
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(UserInfoDAL *)shareInstance{
    static UserInfoDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[UserInfoDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createUserInfoTableIfNotExists
{
    NSString *tableName = @"user_info";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[uid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[username] [varchar](50) NULL,"
                                         "[face] [varchar](50) NULL,"
                                         "[cotainfojson] [data] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateUserInfoTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}

#pragma mark - 添加数据

/**
 *  插入单条数据
 *
 *  @param model UserInfoModel
 */
-(void)addUserInfoModel:(UserInfoModel *)model{
    [[self getDbQuene:@"user_info" FunctionName:@"addUserInfoModel:(UserInfoModel *)model"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *uid = model.uid;
        NSString *username = model.username;
        NSString *face=model.face;
        NSData *cotainfojson=[NSJSONSerialization dataWithJSONObject:model.cotainfojson options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *sql = @"INSERT OR REPLACE INTO user_info(uid,username,face,cotainfojson)"
        "VALUES (?,?,?,?)";
        isOK = [db executeUpdate:sql,uid,username,face,cotainfojson];
        if (!isOK) {
            DDLogError(@"插入失败");
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user_info" Sql:sql Error:@"插入失败" Other:nil];

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
    [[self getDbQuene:@"user_info" FunctionName:@"deleteAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = NO;
        isOK = [db executeUpdate:@"DELETE FROM user_info"];
		if (!isOK) {
			
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user_info" Sql:@"DELETE FROM user_info" Error:@"删除失败" Other:nil];

		}
    }];
}

#pragma mark - 修改数据




#pragma mark - 查询数据

-(UserInfoModel *)getUserDataWithUid:(NSString *)uid{
    __block UserInfoModel *userInfoModel=nil;
    [[self getDbQuene:@"user_info" FunctionName:@"getUserDataWithUid:(NSString *)uid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From user_info Where uid=%@ ",uid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            userInfoModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return userInfoModel;
    
}

#pragma mark - Private Function

/**
 *  将UserInfoModel转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return UserInfoModel
 */
-(UserInfoModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    
    NSData *cotainfojson=[resultSet dataForColumn:@"cotainfojson"];
    
    UserInfoModel *userInfoModel=[[UserInfoModel alloc]init];
    
    userInfoModel.uid=[resultSet stringForColumn:@"uid"];
    userInfoModel.username=[resultSet stringForColumn:@"username"];
    userInfoModel.face=[resultSet stringForColumn:@"face"];
    userInfoModel.cotainfojson=[NSJSONSerialization JSONObjectWithData:cotainfojson options:NSJSONReadingMutableContainers error:nil];
   
    return userInfoModel;
}

@end
