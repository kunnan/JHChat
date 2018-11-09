/************************************************************
 Author:  lz-fzj
 Date：   2016-02-29
 Version: 1.0
 Description: 【联系人】-【好友标签】数据库访问类
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import "UserContactGroupDAL.h"
#import "AppDateUtil.h"

#pragma mark - 【联系人】-【好友标签】数据库访问类
/**
 *  【联系人】-【好友标签】数据库访问类
 */
@implementation UserContactGroupDAL
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(UserContactGroupDAL *)shareInstance
{
    static UserContactGroupDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[UserContactGroupDAL alloc] init];
    }
    return instance;
}
#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createUserTableIfNotExists
{
    NSString *tmpTableName=@"user_contact_group";
    if(![super checkIsExistsTable:tmpTableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"CREATE TABLE IF NOT EXISTS %@("
                                         "[ucgid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[uid] [varchar](50) NULL,"
                                         "[tagvalue] [varchar](50) NULL,"
                                         "[addtime] [date] NULL"
                                         ");"
                                         ,tmpTableName]];
    }
}
/**
 *  升级数据库
 */
-(void)updateUserContactGroupTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}
#pragma mark - 添加数据
/**
 *  批量添加数据
 *  @param userArray 
 */
-(void)addDataWithUserContactGroupArray:(NSMutableArray *)userArray{
    [[self getDbQuene:@"user_contact_group" FunctionName:@"addDataWithUserContactGroupArray:(NSMutableArray *)userArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK=YES;
        for (int i=0;i<userArray.count;i++){
            UserContactGroupModel *model=(UserContactGroupModel *)[userArray objectAtIndex:i];
            
            NSString *sqlString=@"INSERT OR REPLACE INTO  user_contact_group(ucgid,uid,tagvalue,addtime)"
                                "VALUES(?,?,?,?)";
            isOK=[db executeUpdate:sqlString,model.ucgId,model.uId,model.tagValue,[AppDateUtil GetCurrentDate]];
            if(isOK==false){
                DDLogError(@"插入【user_contact_group】数据失败");
            }
            
            if (!isOK) {
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user_contact_group" Sql:sqlString Error:@"插入失败" Other:nil];

                *rollback = YES;
                return;
            }
        }
    }];
}

/**
 *  添加单条
 *
 */
-(void)addUserContactGroupModel:(UserContactGroupModel *)model
{
    
    [[self getDbQuene:@"user_contact_group" FunctionName:@"addUserContactGroupModel:(UserContactGroupModel *)model"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *sqlString=@"INSERT OR REPLACE INTO  user_contact_group(ucgid,uid,tagvalue,addtime)"
        "VALUES(?,?,?,?)";
        isOK=[db executeUpdate:sqlString,model.ucgId,model.uId,model.tagValue,[AppDateUtil GetCurrentDate]];
        if (!isOK) {
            DDLogError(@"插入失败");
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user_contact_group" Sql:sqlString Error:@"插入失败" Other:nil];

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
    NSString *sqlString=@"DELETE FROM user_contact_group";
    [[self getDbQuene:@"user_contact_group" FunctionName:@"deleteAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = NO;
        isOK = [db executeUpdate:sqlString];
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user_contact_group" Sql:sqlString Error:@"删除失败" Other:nil];

		}
    }];
}

/**
 *  根据TagId删除好友标签
 *  @param ucgId 标签id（主键）
 */
-(void)deleteByUCGId:(NSString * )ucgId{
    [[self getDbQuene:@"user_contact_group" FunctionName:@"deleteByUCGId:(NSString * )ucgId"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
       NSString *sqlString=@"DELETE FROM user_contact_group WHERE ucgid=? ";
		BOOL isOK = NO;
        isOK =[db executeUpdate:sqlString,ucgId];
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user_contact_group" Sql:sqlString Error:@"删除失败" Other:nil];
			
		}
    }];
}


#pragma mark - 修改数据


#pragma mark - 查询数据

/**
 *  获取所有标签
 */
-(NSMutableArray *)getUserContactGroups{
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"user_contact_group" FunctionName:@"getUserContactGroups"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *sqlString=@" select  ucg.ucgid ,ucg.tagvalue,"
        "                                        sum(case length(ifnull(dataextend2,'')) when 0 then 0 else 1 end) dataextend2"
        "                                        from user_contact_group ucg"
        "                                        left join  (  select td.dataextend1,td.dataextend2 from  tag_data  td"
        "                                                    inner join user_contact uc on uc.ucid=td.dataextend2"
        "                                                    inner join user u on uc.ctid=u.uid"
        "                                                    where td.ttid='contactgroup')     td    on ucg.ucgid=td.dataextend1"
        "                                        group by ucg.ucgid"
        "                                        order by ucg.addtime";
        
        FMResultSet *resultSet=[db executeQuery:sqlString];
        
        while ([resultSet next]) {
            UserContactGroupModel *groupModel = [[UserContactGroupModel alloc] init];
            groupModel.ucgId = [resultSet stringForColumn:@"ucgid"];
            groupModel.tagValue = [resultSet stringForColumn:@"tagvalue"];
            groupModel.usercount = [resultSet intForColumn:@"dataextend2"];
            
            [resultArray addObject:groupModel];
        }
        [resultSet close];
    }];
    return resultArray;
}


/**
 *  根据标签id获取标签数据
 *  @param tagid
 *  @return
 */
-(UserContactGroupModel *)getUserContactGroupByTagId:(NSString *)ucgid{
    __block UserContactGroupModel *model=nil;
    [[self getDbQuene:@"user_contact_group"FunctionName:@"getUserContactGroupByTagId:(NSString *)ucgid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlString=@"SELECT * FROM user_contact_group WHERE ucgid=?";
        FMResultSet *resultSet=[db executeQuery:sqlString,ucgid];
        if([resultSet next]){
            model = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    return model;

}

/**
 *  根据标签id查询标签成员相关信息
 *
 *  @param ucgid tagid
 *
 *  @return arr
 */
-(NSMutableArray *)getUserContactGroupWithUserInfoByTagId:(NSString *)ucgid{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    //                         去数据库查询
    [[[UserContactGroupDAL shareInstance] getDbQuene:@"user_contact_group" FunctionName:@"getUserContactGroupWithUserInfoByTagId:(NSString *)ucgid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlString=@"select td.tdid, uc.ucid,u.username,u.uid,u.face"
        "                                       from tag_data td"
        "                                       inner join user_contact uc on td.dataextend2=uc.ucid"
        "                                       inner join user   u on u.uid=uc.ctid"
        "                                       where td.dataextend1=?";
        FMResultSet *resultSet=[db executeQuery:sqlString,ucgid];
        while ([resultSet next]) {
            NSMutableDictionary *tmpDic=[NSMutableDictionary dictionary];
            [tmpDic setObject:[resultSet stringForColumn:@"tdid"] forKey:@"pid"];
            [tmpDic setObject:[resultSet stringForColumn:@"username"] forKey:@"username"];
            [tmpDic setObject:[resultSet stringForColumn:@"face"] forKey:@"face"];
            [tmpDic setObject:[resultSet stringForColumn:@"uid"] forKey:@"uid"];
            [tmpDic setObject:[resultSet stringForColumn:@"ucid"] forKey:@"ucid"];
            [tmpDic setObject:@"0" forKey:@"tagValue"];
            [resultArray addObject:tmpDic];
        }
        [resultSet close];
    }];
    
    return resultArray;
}

/**
 *  将UserContactGroupModel转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return OrgUserIntervateModel
 */
-(UserContactGroupModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    
    UserContactGroupModel *model=[[UserContactGroupModel alloc]init];
    
    model.ucgId=[resultSet stringForColumn:@"ucgid"];
    model.uId=[resultSet stringForColumn:@"uId"];
    model.tagValue=[resultSet stringForColumn:@"tagvalue"];
    model.addTime=[resultSet dateForColumn:@"addtime"];
    return model;
}

///**
// *  将数据结果对象转换为Model对象
// *  @param resultSet
// *  @return
// */
//-(NSArray<UserContactGroupModel *> *)convertResultSet2Model:(FMResultSet *)resultSet{
//    NSMutableArray<UserContactGroupModel *> *tmpModels=[[NSMutableArray alloc]init];
//    while ([resultSet next]) {
//        UserContactGroupModel *model=[[UserContactGroupModel alloc]init];
//        model.ucgId=[resultSet stringForColumn:@"ucgid"];
//        model.uId=[resultSet stringForColumn:@"uId"];
//        model.tagValue=[resultSet stringForColumn:@"tagvalue"];
//        model.addTime=[LZFormat String2Date:[resultSet stringForColumn:@"addtime"]];
//        [tmpModels addObject:model];
//    }
//    return  [tmpModels copy];
//}
@end
