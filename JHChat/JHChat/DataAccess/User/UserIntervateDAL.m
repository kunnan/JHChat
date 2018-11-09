/************************************************************
 Author:  lz-fzj
 Date：   2016-03-01
 Version: 1.0
 Description: 【联系人】-【新的好友】数据库操作类
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "UserIntervateDAL.h"

#pragma mark - 【联系人】-【新的好友】数据库操作类
/**
 *  【联系人】-【新的好友】数据库操作类
 */
@implementation UserIntervateDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(UserIntervateDAL *)shareInstance
{
    static UserIntervateDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[UserIntervateDAL alloc] init];
    }
    return instance;
}
/**
 *  创建表
 */
-(void)createUserContactTableIfNotExists{
    NSString *tableName=@"user_intervate";
    if([super checkIsExistsTable:tableName]) return;
    /*****************************************************************************
     自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
     使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
     *****************************************************************************/
    [[self getDbQuene:@"user_intervate" FunctionName:@"createUserContactTableIfNotExists"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:[NSString stringWithFormat:
                           @"CREATE TABLE IF NOT EXISTS %@("
                           "[uiid] [varchar] (50) PRIMARY KEY NOT NULL,"
                           "[objid] [varchar](50) NULL,"
                           "[email] [varchar](50) NULL,"
                           "[mobile] [varchar](50) NULL,"
                           "[intervatedate] [date] NULL,"
                           "[type] [integer] NULL,"
                           "[uid] [varchar](50) NULL,"
                           "[username] [varchar](50) NULL,"
                           "[actiondate] [date] NULL,"
                           "[result] [integer] NULL,"
                           "[logtype] [integer] NULL,"
                           "[face] [text] NULL);"
                           ,tableName]];
    }];
    
}
/**
 *  升级数据库
 */
-(void)updateUserIntervateTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
//            case 5:{
//                [self AddColumnToTableIfNotExist:@"user_intervate" columnName:@"face" type:@"[text]"];
//                break;
//            }
        }
    }
}
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)userArray{
    [[self getDbQuene:@"user_intervate" FunctionName:@"addDataWithArray:(NSMutableArray *)userArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK=YES;
        
        NSString *sqlString=@"INSERT OR REPLACE INTO user_intervate(uiid,objid,email,mobile,intervatedate,type,uid,username,actiondate,result,logtype,face)"
        "VALUES(?,?,?,?,?,?,?,?,?,?,?,?)";
        for (int i=0;i<userArray.count;i++){
            UserIntervateModel *model=(UserIntervateModel *)[userArray objectAtIndex:i];
            
            NSString *uiid=model.uiid;
            NSString *objid=model.objid;
            NSString *email=model.email;
            NSString *mobile=model.mobile;
            NSDate   *intervatedate=model.intervatedate;
            NSNumber *type=[NSNumber numberWithInteger:model.type];
            
            NSString *uid=model.uid;
            NSString *username=model.username;
            NSDate   *actiondate=model.actiondate;
            NSNumber *result=[NSNumber numberWithInteger:model.result];
            NSNumber *logtype=[NSNumber numberWithInteger:model.logtype];
            NSString *face=model.face;
 
            isOK = [db executeUpdate:sqlString,uiid,objid,email,mobile,intervatedate,type,uid,username,actiondate,result,logtype,face];
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user_intervate" Sql:sqlString Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
}

/**
 *  插入单条数据
 *
 *  @param model UserIntervateModel
 */
-(void)addUserIntervateModel:(UserIntervateModel *)model{
    
    [[self getDbQuene:@"user_intervate" FunctionName:@"addUserIntervateModel:(UserIntervateModel *)model"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *uiid=model.uiid;
        NSString *objid=model.objid;
        NSString *email=model.email;
        NSString *mobile=model.mobile;
        NSDate   *intervatedate=model.intervatedate;
        NSNumber *type=[NSNumber numberWithInteger:model.type];
        
        NSString *uid=model.uid;
        NSString *username=model.username;
        NSDate   *actiondate=model.actiondate;
        NSNumber *result=[NSNumber numberWithInteger:model.result];
        NSNumber *logtype=[NSNumber numberWithInteger:model.logtype];
        NSString *face=model.face;
        
        NSString *sqlString=@"INSERT OR REPLACE INTO user_intervate(uiid,objid,email,mobile,intervatedate,type,uid,username,actiondate,result,logtype,face)"
        "VALUES(?,?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sqlString,uiid,objid,email,mobile,intervatedate,type,uid,username,actiondate,result,logtype,face];
        if (!isOK) {
            DDLogError(@"插入失败");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user_intervate" Sql:sqlString Error:@"插入失败" Other:nil];

        }
        if (!isOK) {
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
    [[self getDbQuene:@"user_intervate" FunctionName:@"deleteAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = NO;
        isOK = [db executeUpdate:@"DELETE FROM user_intervate"];
		
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user_intervate" Sql:@"DELETE FROM user_intervate" Error:@"删除失败" Other:nil];
			
		}
    }];
}


/**
 *  根据uiid删除信息
 *  @param uiid
 */
-(void)deleteUserIntervateByUiId:(NSString *)uiid{
    [[self getDbQuene:@"user_intervate" FunctionName:@"deleteUserIntervateByUiId:(NSString *)uiid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlString=@"DELETE FROM user_intervate WHERE uiid=?";
		BOOL isOK = NO;
		isOK = [db executeUpdate:sqlString,uiid];
		
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user_intervate" Sql:sqlString Error:@"更新失败" Other:nil];

		}
    }];
    
}

#pragma mark - 修改数据

/**
 *  更新邀请的【result】字段值
 *  @param resultValue 新的值
 *  @param uiid         主键id
 */
-(void)updateIntervateResultValue:(NSInteger)resultValue uiid:(NSString *)uiid{
    [[self getDbQuene:@"user_intervate" FunctionName:@"updateIntervateResultValue:(NSInteger)resultValue uiid:(NSString *)uiid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
       NSString *sqlString=@"UPDATE  user_intervate SET result=? WHERE uiid=?";
		
		BOOL isOK = NO;
        isOK = [db executeUpdate:sqlString,[NSNumber numberWithInteger:resultValue],uiid];
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user_intervate" Sql:sqlString Error:@"更新失败" Other:nil];
			
		}
    }];
}


#pragma mark - 查询数据
/**
 *  查询所有数据
 *  @return 
 */
-(NSArray<UserIntervateModel *> *)getAllData{
    __block NSArray<UserIntervateModel *> *retArray=nil;
    __block typeof(self) weakSelf=self;
    [[self getDbQuene:@"user_intervate" FunctionName:@"getAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *resultSet= [db executeQuery:@"SELECT * FROM user_intervate"];
        retArray=[weakSelf convertResultSet2Model:resultSet];
        [resultSet close];
    }];
    return retArray;
}

/**
 *  获取新的好友数据
 *
 */
-(NSMutableArray *)getUserIntervateDataWithStartNum:(NSInteger)startNum End:(NSInteger)end{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"user_intervate" FunctionName:@"getUserIntervateDataWithStartNum:(NSInteger)startNum End:(NSInteger)end"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From user_intervate Order by intervatedate desc limit %ld,%ld",(long)startNum,(long)end];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            UserIntervateModel *userIntervateModel=[self convertResultSetToModel:resultSet];
            [result addObject:userIntervateModel];
        }
        [resultSet close];
    }];
    
    return result;
}

/**
 *  根据用户id获取好友信息
 *  @param friendid 被邀请人用户id
 *  @return
 */
-(UserIntervateModel *)getUserIntervateByFriendId:(NSString *)friendid{
    __block UserIntervateModel *model=nil;
    [[self getDbQuene:@"user_intervate" FunctionName:@"getUserIntervateByFriendId:(NSString *)friendid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlString=@"SELECT * FROM user_intervate WHERE uid=?";
        FMResultSet *resultSet=[db executeQuery:sqlString,friendid];
        if([resultSet next]){
            model = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    return model;
    
}

/**
 *  将数据库结果集转为Model对象
 *  @param resultSet
 *  @return
 */
-(NSArray<UserIntervateModel *> *)convertResultSet2Model:(FMResultSet *)resultSet{
    NSMutableArray<UserIntervateModel *> *modelArray=[[NSMutableArray alloc]init];
    while ([resultSet next]) {
        UserIntervateModel *model =[[UserIntervateModel alloc]init];
        //转换
        model.uiid=[resultSet stringForColumn:@"uiid"];
        model.objid=[resultSet stringForColumn:@"objid"];
        model.email=[resultSet stringForColumn:@"email"];
        model.mobile=[resultSet stringForColumn:@"mobile"];
        model.intervatedate=[LZFormat String2Date:[resultSet stringForColumn:@"intervatedate"]];
        model.type=(int)[LZFormat Safe2Int32:[resultSet stringForColumn:@"type"]];
        model.uid=[resultSet stringForColumn:@"uid"];
        model.username=[resultSet stringForColumn:@"username"];
        model.actiondate=[LZFormat String2Date:[resultSet stringForColumn:@"actiondate"]];
        model.result=(int)[LZFormat Safe2Int32:[resultSet stringForColumn:@"result"]];
        model.logtype=(int)[LZFormat Safe2Int32:[resultSet stringForColumn:@"logtype"]];
        model.face=[resultSet stringForColumn:@"face"];
        //      加入集合
        [modelArray addObject:model];
    }
    return  [modelArray copy];
}

/**
 *  将OrgUserIntervateModel转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return OrgUserIntervateModel
 */
-(UserIntervateModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    
    UserIntervateModel *model =[[UserIntervateModel alloc]init];
    //转换
    model.uiid=[resultSet stringForColumn:@"uiid"];
    model.objid=[resultSet stringForColumn:@"objid"];
    model.email=[resultSet stringForColumn:@"email"];
    model.mobile=[resultSet stringForColumn:@"mobile"];
    model.intervatedate=[resultSet dateForColumn:@"intervatedate"];
    model.type=[resultSet intForColumn:@"type"];
    model.uid=[resultSet stringForColumn:@"uid"];
    model.username=[resultSet stringForColumn:@"username"];
    model.actiondate=[resultSet dateForColumn:@"actiondate"];
    model.result=[resultSet intForColumn:@"result"];
    model.logtype=[resultSet intForColumn:@"logtype"];
    model.face=[resultSet stringForColumn:@"face"];
    return model;
}

@end
