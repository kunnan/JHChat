//
//  UserContactOfenCooperationDAL.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/3.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2015-12-02
 Version: 1.0
 Description: 常用联系人数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "UserContactOfenCooperationDAL.h"
#import "NSString+IsNullOrEmpty.h"

@implementation UserContactOfenCooperationDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(UserContactOfenCooperationDAL *)shareInstance
{
    static UserContactOfenCooperationDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[UserContactOfenCooperationDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createUserContactOfenCooperationTableIfNotExists
{
    NSString *tableName = @"user_contact_ofencooperation";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[ucoid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[lastdate] [date] NULL,"
                                         "[reveiverid] [varchar](50) NULL,"
                                         "[receivername] [date] NULL,"
                                         "[isvalid] [integer] NULL,"
                                         "[showindex] [integer] NULL,"
                                         "[receiverid] [varchar](50) NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateUserContactOfenCooperationTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
//        switch (i) {
//            case 5:
//                [self AddColumnToTableIfNotExist:@"user_contact_ofencooperation" columnName:@"showindex" type:@"[integer]"];
//                break;
//            case 19:
//                [self AddColumnToTableIfNotExist:@"user_contact_ofencooperation" columnName:@"receiverid" type:@"[varchar](50)"];
//                break;
//        }
    }
}
#pragma mark - 添加数据
/**
 *  批量添加数据
 *  @param userArray
 */
-(void)addDataWithUserContactOftenCooperationArray:(NSMutableArray<UserContactOfenCooperationModel *> *)userArray{
    [[self getDbQuene:@"user_contact_ofencooperation"FunctionName:@"addDataWithUserContactOftenCooperationArray:(NSMutableArray<UserContactOfenCooperationModel *> *)userArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK=YES;
        
        NSString *sqlString=@"INSERT OR REPLACE INTO  user_contact_ofencooperation(ucoid,lastdate,receiverid,receivername,isvalid,showindex)"
        "VALUES(?,?,?,?,?,?)";
        for (int i=0;i<userArray.count;i++){
            UserContactOfenCooperationModel *model=(UserContactOfenCooperationModel *)[userArray objectAtIndex:i];
            isOK=[db executeUpdate:sqlString,model.ucoid,nil,model.receiverid,model.receivername,[NSNumber numberWithInt:1],[NSNumber numberWithInteger:model.showindex]];
            if(isOK==false){
                DDLogError(@"插入【user_contact_group】数据失败");
            }
            if (!isOK) {
				
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user_contact_ofencooperation" Sql:sqlString Error:@"插入失败" Other:nil];
					
                *rollback = YES;
                return;
            }
        }
    }];
}


#pragma mark - 删除数据
/**
 *  清空数据
 */
-(void)deleteAllData{
    [[self getDbQuene:@"user_contact_ofencooperation"FunctionName:@"deleteAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = NO;
        isOK = [db executeUpdate:@"DELETE FROM user_contact_ofencooperation"];
		
		if (!isOK) {
			
		[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user_contact_ofencooperation" Sql:@"DELETE FROM user_contact_ofencooperation" Error:@"删除失败" Other:nil];
		}
    }];
}
/**
 *  根据uId删除记录
 *  @param uId
 */
-(void)deleteByuId:(NSString *)uId{
    [[self getDbQuene:@"user_contact_ofencooperation" FunctionName:@"deleteByuId:(NSString *)uId"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
       NSString *sqlString=@"DELETE FROM user_contact_ofencooperation WHERE receiverid=? ";
		BOOL isOK = NO;
        isOK = [ db executeUpdate:sqlString,uId];
		
		if (!isOK) {
			
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user_contact_ofencooperation" Sql:sqlString Error:@"删除失败" Other:nil];
		}
    }];
}



#pragma mark - 修改数据



#pragma mark - 查询数据

/**
 *  获取常用联系人列表数据
 *
 *  @return 数据
 */
-(NSMutableArray *)getContectOftenCooperationList{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"user_contact_ofencooperation" FunctionName:@"getContectOftenCooperationList"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select ucoid,uid,username,face from user_contact_ofencooperation left join user on uid=receiverid Where uid<>'%@'  order by ifnull(user_contact_ofencooperation.showindex,0) asc",[AppUtils GetCurrentUserID]];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            UserModel *userModel = [[UserModel alloc] init];
            userModel.uid = [resultSet stringForColumn:@"uid"];
            userModel.username = [resultSet stringForColumn:@"username"];
            userModel.face = [resultSet stringForColumn:@"face"];
            
            UserContactOfenCooperationModel *model = [[UserContactOfenCooperationModel alloc] init];
            model.userModel = userModel;
            model.ucoid = [resultSet stringForColumn:@"ucoid"];
            
            [result addObject:model];
        }
        [resultSet close];
    }];
    return result;
}
/**
 *  搜索常用联系人
 *  @param searchText
 *  @return
 */
-(NSMutableArray *)searchOfenCooperationContact:(NSString *)searchText {
    NSMutableArray<ContactRootSearchModel2 *> *retArray=[NSMutableArray array];
    NSString *sqlString=@" select * From User Where uid in ( select distinct u.uid from user_contact_ofencooperation uc"
    "                                              left join user u on  u.uid=uc.receiverid "
    "                                              where upper(u.username) like '%%%@%%' or upper(u.quancheng) like '%%%@%%' or upper(u.jiancheng) like '%%%@%%' or upper(u.mobile) like '%%%@%%' or upper(u.email) like '%%%@%%'  ) order by quancheng";
    searchText=[searchText uppercaseString];
    sqlString=[NSString stringWithFormat:sqlString,searchText,searchText,searchText,searchText,searchText];
    [[self getDbQuene:@"user_contact_ofencooperation" FunctionName:@"searchOfenCooperationContact:(NSString *)searchText" ] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *resultSet=[db executeQuery:sqlString];

        while ([resultSet next]) {
            NSString *username = [resultSet stringForColumn:@"username"];
            NSString *quancheng = [resultSet stringForColumn:@"quancheng"];
            NSString *jiancheng = [resultSet stringForColumn:@"jiancheng"];
            NSString *mobile = [resultSet stringForColumn:@"mobile"];
            NSString *email = [resultSet stringForColumn:@"email"];
            
            ContactRootSearchModel2 *cellMocel = [[ContactRootSearchModel2 alloc] init];
            cellMocel.uid = [resultSet stringForColumn:@"uid"];
            cellMocel.username = username;
            cellMocel.face = [resultSet stringForColumn:@"face"];
            
            if( (![NSString isNullOrEmpty:username] && [[username uppercaseString] rangeOfString:searchText].location!=NSNotFound)
               || (![NSString isNullOrEmpty:quancheng] && [[quancheng uppercaseString] rangeOfString:searchText].location!=NSNotFound)
               || (![NSString isNullOrEmpty:jiancheng] && [[jiancheng uppercaseString] rangeOfString:searchText].location!=NSNotFound) ){
                cellMocel.des = @"";
            }
            else if( ![NSString isNullOrEmpty:mobile] && [[mobile uppercaseString] rangeOfString:searchText].location!=NSNotFound ){
                cellMocel.des = [NSString stringWithFormat:@"手机号:%@",mobile];
            }
            else if( ![NSString isNullOrEmpty:email] && [[email uppercaseString] rangeOfString:searchText].location!=NSNotFound ){
                cellMocel.des = [NSString stringWithFormat:@"邮箱:%@",email];
            }
            
            [retArray addObject:cellMocel];
        }
        [resultSet close];
    }];
    return [retArray copy];
}

@end
