//
//  UserDAL.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/2.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-12-02
 Version: 1.0
 Description: 用户数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "UserDAL.h"
#import "NSString+IsNullOrEmpty.h"

@implementation UserDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(UserDAL *)shareInstance
{
    static UserDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[UserDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createUserTableIfNotExists
{
    NSString *tableName = @"user";
    
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
                                                                     "[loginname] [varchar](50) NULL,"
                                                                     "[mobile] [varchar](50) NULL,"
                                                                     "[email] [varchar](50) NULL,"
                                                                     "[address] [varchar](50) NULL,"
                                                                     "[province] [varchar](20) NULL,"
                                                                     "[city] [varchar](20) NULL,"
                                                                     "[county] [varchar](20) NULL,"
                                                                     "[regtype] [integer] NULL,"
                                                                     "[gender] [integer] NULL,"
                                                                     "[birthday] [date] NULL,"
                                                                     "[wechat] [varchar](50) NULL,"
                                                                     "[weibo] [varchar](50) NULL,"
                                                                     "[qq] [varchar](50) NULL,"
                                                                     "[face] [varchar](200) NULL,"
                                                                     "[isbingphone] [integer] NULL,"
                                                                     "[isbindemail] [integer] NULL,"
                                                                     "[addtime] [date] NULL,"
                                                                     "[quancheng] [varchar](200) NULL,"
                                                                     "[jiancheng] [varchar](50) NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateUserTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 62:{
                [self AddColumnToTableIfNotExist:@"user" columnName:@"[officecall]" type:@"[varchar](50)"];
                break;
            }
        }
    }
}
#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithUserArray:(NSMutableArray *)userArray{
    [[self getDbQuene:@"user"FunctionName:@"addDataWithUserArray:(NSMutableArray *)userArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO user(uid,mobile,email,address,regtype,wechat,weibo,qq,isbingphone,isbindemail,addtime,quancheng,jiancheng,face,username,loginname,gender,birthday,province,city,county,officecall)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
        for (int i = 0; i< userArray.count;  i++) {
            UserModel *userModel=[userArray objectAtIndex:i];
            NSString *uid=userModel.uid;
            if([NSString isNullOrEmpty:uid]){
                DDLogVerbose(@"插入用户数据时，主键id为空");
                continue;
            }
            NSString *mobile=userModel.mobile;
            NSString *email=userModel.email;
            NSString *address=userModel.address;
            NSNumber *regtype=[NSNumber numberWithInteger:userModel.regtype];
            NSString *wechat=userModel.wechat;
            NSString *weibo=userModel.weibo;
            NSString *qq=userModel.qq;
            NSNumber *isbingphone=[NSNumber numberWithInteger:userModel.isbindphone];
            NSNumber *isbindemail=[NSNumber numberWithInteger:userModel.isbindemail];
            NSDate   *addtime=userModel.addtime;
            NSString *quancheng=userModel.quancheng;
            NSString *jiancheng=userModel.jiancheng;
            NSString *face=userModel.face;
            NSString *username=userModel.username;
            NSString *loginname=userModel.loginname;
            NSNumber *gender=[NSNumber numberWithInteger:userModel.gender];
            NSDate   *birthday=userModel.birthday;
            NSString *province=userModel.province;
            NSString *city=userModel.city;
            NSString *county=userModel.county;
            NSString *officecall =userModel.officecall;
			
            isOK = [db executeUpdate:sql,uid,mobile,email,address,regtype,wechat,weibo,qq,isbingphone,isbindemail,addtime,quancheng,jiancheng,face,username,loginname,gender,birthday,province,city,county,officecall];
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
}

/**
 *  插入单条数据
 *
 *  @param model UserModel
 */
-(void)addUserModel:(UserModel *)userModel{
    
    [[self getDbQuene:@"user" FunctionName:@"addUserModel:(UserModel *)userModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *uid=userModel.uid;
        NSString *mobile=userModel.mobile;
        NSString *email=userModel.email;
        NSString *address=userModel.address;
        NSNumber *regtype=[NSNumber numberWithInteger:userModel.regtype];
        NSString *wechat=userModel.wechat;
        NSString *weibo=userModel.weibo;
        NSString *qq=userModel.qq;
        NSNumber *isbingphone=[NSNumber numberWithInteger:userModel.isbindphone];
        NSNumber *isbindemail=[NSNumber numberWithInteger:userModel.isbindemail];
        NSDate   *addtime=userModel.addtime;
        NSString *quancheng=userModel.quancheng;
        NSString *jiancheng=userModel.jiancheng;
        NSString *face=userModel.face;
        NSString *username=userModel.username;
        NSString *loginname=userModel.loginname;
        NSNumber *gender=[NSNumber numberWithInteger:userModel.gender];
        NSDate   *birthday=userModel.birthday;
        NSString *province=userModel.province;
        NSString *city=userModel.city;
        NSString *county=userModel.county;
        NSString *officecall=userModel.officecall;
        
        NSString *sql = @"INSERT OR REPLACE INTO user(uid,mobile,email,address,regtype,wechat,weibo,qq,isbingphone,isbindemail,addtime,quancheng,jiancheng,face,username,loginname,gender,birthday,province,city,county,officecall)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,uid,mobile,email,address,regtype,wechat,weibo,qq,isbingphone,isbindemail,addtime,quancheng,jiancheng,face,username,loginname,gender,birthday,province,city,county,officecall];
        if (!isOK) {
            DDLogError(@"插入失败");
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
}


#pragma mark - 删除数据



#pragma mark - 修改数据
-(void)updateUserWithUid:(UserModel *)userModel{
    [[self getDbQuene:@"user" FunctionName:@"updateUserWithUid:(UserModel *)userModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        NSString *uid=userModel.uid;
        NSString *face=userModel.face;
        NSString *username=userModel.username;
        NSString *loginname=userModel.loginname;
        NSString *mobile=userModel.mobile;
        NSNumber *regtype=[NSNumber numberWithInteger:userModel.regtype];
        NSNumber *isbingphone=[NSNumber numberWithInteger:userModel.isbindphone];
        NSNumber *isbindemail=[NSNumber numberWithInteger:userModel.isbindemail];
        NSDate   *addtime=userModel.addtime;
        NSString *quancheng=userModel.quancheng;
        NSString *jiancheng=userModel.jiancheng;
        NSNumber *gender=[NSNumber numberWithInteger:userModel.gender];
        NSDate   *birthday=userModel.birthday;
        NSString *province=userModel.province;
        NSString *city=userModel.city;
        NSString *county=userModel.county;
        NSString *sql = @"Update user set rid=?,partitiontype=?,face=?,username=?,loginname=?,mobile=?,regtype=?,isbingphone=?,isbindemail=?,addtime=?,quancheng=?,jiancheng=?,gender=?,birthday=?,province=?,city=?,county=? Where uid=?";
        isOK = [db executeUpdate:sql,face,username,loginname,mobile,regtype,isbingphone,isbindemail,addtime,quancheng,jiancheng,gender,birthday,province,city,county,uid];
        if (!isOK) {
            DDLogError(@"修改失败");
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user" Sql:sql Error:@"更新失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
}

/**
 *  修改昵称
 */
-(void)updateUserWithUid:(UserModel *)userModel userName:(NSString *)username{
    [[self getDbQuene:@"user" FunctionName:@"updateUserWithUid:(UserModel *)userModel userName:(NSString *)username"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        NSString *sql = @"Update user set username=? Where uid=?";
        isOK = [db executeUpdate:sql,username,userModel.uid];
    if (!isOK) {
        DDLogError(@"修改失败");
		[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user" Sql:sql Error:@"更新失败" Other:nil];

    }
    if (!isOK) {
        *rollback = YES;
        return;
    }
    }];
}

/**
 *  修改性别
 */
-(void)updateUserWithUid:(UserModel *)userModel userSex:(NSInteger)gender{
    [[self getDbQuene:@"user" FunctionName:@"updateUserWithUid:(UserModel *)userModel userSex:(NSInteger)gender"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        NSNumber *g=[NSNumber numberWithInteger:gender];
        NSString *sql = @"Update user set gender=? Where uid=?";
        isOK = [db executeUpdate:sql,g,userModel.uid];
        if (!isOK) {
            DDLogError(@"修改失败");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user" Sql:sql Error:@"更新失败" Other:nil];

        }
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
}

/**
 *  修改地区
 */
-(void)updateUserWithUid:(UserModel *)userModel province:(NSString *)province city:(NSString *)city county:(NSString *)county{
    [[self getDbQuene:@"user" FunctionName:@"updateUserWithUid:(UserModel *)userModel province:(NSString *)province city:(NSString *)city county:(NSString *)county"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        NSString *sql = @"Update user set province=?,city=?,county=? Where uid=?";
        isOK = [db executeUpdate:sql,province,city,county,userModel.uid];
        if (!isOK) {
            DDLogError(@"修改失败");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user" Sql:sql Error:@"更新失败" Other:nil];

        }
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
}

/**
 *  修改生日
 */
-(void)updateUserWithUid:(UserModel *)userModel userBirthday:(NSDate *)birthday{
    [[self getDbQuene:@"user" FunctionName:@"updateUserWithUid:(UserModel *)userModel userBirthday:(NSDate *)birthday"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        NSString *sql = @"Update user set birthday=? Where uid=?";
        isOK = [db executeUpdate:sql,birthday,userModel.uid];
        if (!isOK) {
            DDLogError(@"修改失败");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user" Sql:sql Error:@"更新失败" Other:nil];

        }
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
}

/**
 *  修改头像
 */
-(void)updateUserWithUid:(UserModel *)userModel userFace:(NSString *)face{
    [[self getDbQuene:@"user" FunctionName:@"updateUserWithUid:(UserModel *)userModel userFace:(NSString *)face"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        NSString *sql = @"Update user set face=? Where uid=?";
        isOK = [db executeUpdate:sql,face,userModel.uid];
        if (!isOK) {
            DDLogError(@"修改失败");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user" Sql:sql Error:@"更新失败" Other:nil];

        }
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
}

/**
 *  修改办公电话
 */
-(void)updateUserWithUid:(UserModel *)userModel officecall:(NSString *)officecall{
    [[self getDbQuene:@"user" FunctionName:@"updateUserWithUid:(UserModel *)userModel officecall:(NSString *)officecall"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        NSString *sql = @"Update user set officecall=? Where uid=?";
        isOK = [db executeUpdate:sql,officecall,userModel.uid];
        if (!isOK) {
            DDLogError(@"修改失败");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user" Sql:sql Error:@"更新失败" Other:nil];

        }
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
}

/**
 *  修改详细地址
 */
-(void)updateUserWithUid:(UserModel *)userModel address:(NSString *)address{
    [[self getDbQuene:@"user" FunctionName:@"updateUserWithUid:(UserModel *)userModel address:(NSString *)address"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        NSString *sql = @"Update user set address=? Where uid=?";
        isOK = [db executeUpdate:sql,address,userModel.uid];
        if (!isOK) {
            DDLogError(@"修改失败");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user" Sql:sql Error:@"更新失败" Other:nil];

        }
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
}


/**
 *  更改所有表中的用户信息
 */
-(void)updateAllTableUserInfo:(UserModel *)userModel{
    [[self getDbQuene:@"user" FunctionName:@"updateAllTableUserInfo:(UserModel *)userModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *plistPath =  [[NSBundle mainBundle] pathForResource:@"UserDALInfo" ofType:@"plist"];
        NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        
        for (NSString *tableName in [mutableDic allKeys]) {
            NSString *newTableName = [tableName stringByReplacingOccurrencesOfString:@"_1" withString:@""];
            
            NSDictionary *obj = [mutableDic lzNSDictonaryForKey:tableName];
            
            NSString *uid = [obj lzNSStringForKey:@"UID"];
            NSString *username = [obj lzNSStringForKey:@"USERNAME"];
            NSString *quancheng = [obj lzNSStringForKey:@"QC"];
            NSString *jiancheng = [obj lzNSStringForKey:@"JC"];
            if([NSString isNullOrEmpty:uid] || [NSString isNullOrEmpty:username]){
                continue;
            }
            
            /* 拼接需要更新的字段 */
            NSString *setColumn = [NSString stringWithFormat:@"%@='%@'",username,userModel.username];
            if(![NSString isNullOrEmpty:quancheng]){
                setColumn = [setColumn stringByAppendingString:[NSString stringWithFormat:@",%@='%@'",quancheng,userModel.quancheng]];
            }
            if(![NSString isNullOrEmpty:jiancheng]){
                setColumn = [setColumn stringByAppendingString:[NSString stringWithFormat:@",%@='%@'",jiancheng,userModel.jiancheng]];
            }
            
            NSString *sql = [NSString stringWithFormat:@"Update %@ set %@ Where %@='%@'",newTableName,setColumn,uid,userModel.uid];
            
            BOOL isOK = YES;
            isOK = [db executeUpdate:sql];
            if (!isOK) {
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"user" Sql:sql Error:@"更新失败" Other:nil];

                DDLogError(@"更改所有表中的用户信息----%@",sql);
            }
        }
        
        DDLogError(@"更改所有表中的用户完成--001");
    }];
    DDLogError(@"更改所有表中的用户完成--002");
}

#pragma mark - 查询数据

-(UserModel *)getUserDataWithUid:(NSString *)uid{
    __block UserModel *userModel=nil;
    [[self getDbQuene:@"user" FunctionName:@"getUserDataWithUid:(NSString *)uid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From user Where uid=%@ ",uid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            userModel = [self convertResultSet2Model:resultSet];
        }
        [resultSet close];
    }];
    return userModel;
    
}
/**
 *  得到所有联系人的手机号
 *
 *  @return 用户模型
 */
-(NSMutableArray<UserModel *> *)getUserMobileOfAll {
    NSMutableArray<UserModel *> *userModelArr = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"user" FunctionName:@"getUserMobileOfAll"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"SELECT mobile  FROM user_contact ,user WHERE user_contact.ctid=user.uid AND ifnull (mobile,'')"];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            UserModel *userModel = [[UserModel alloc] init];
            userModel.mobile = [resultSet stringForColumn:@"mobile"];
            [userModelArr addObject:userModel];
        }
        [resultSet close];
    }];
    return userModelArr;
}

/**
 *  用户用户姓名和头像ID
 *
 *  @param uid 用户ID
 *
 *  @return 用户信息
 */
-(UserModel *)getUserModelForNameAndFace:(NSString *)uid{
    if([NSString isNullOrEmpty:uid])uid=@"";
    __block UserModel *userModel=nil;
    [[self getDbQuene:@"user" FunctionName:@"getUserModelForNameAndFace:(NSString *)uid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=@"Select face,username From user Where uid='$userid$'"\
                        " union all "\
                        "Select face,username From im_group_user Where uid='$userid$'"\
                        " union all "\
                        "Select face,contactname as username From im_recent Where contactid='$userid$'"\
                        " union all "\
                        "Select '' as face,receivername as username From user_contact_ofencooperation Where receiverid='$userid$'"\
                        " union all "\
                        "Select face,username From user_info Where uid='$userid$'"\
                        " union all "\
                        "Select face,username From user_intervate Where uid='$userid$'"\
                        " union all "\
                        "Select face,uname From co_member Where uid='$userid$'"\
                        " union all "\
                        "Select '' as face,invitename as username From co_newcooperation Where inviteid='$userid$'"\
                        " union all "\
                        "Select applyface as face,applyname as username From co_newmember Where applyid='$userid$'"\
                        " union all "\
                        "Select face,username From org_user_apply Where uid='$userid$'"\
                        " union all "\
                        "Select releaseuserface as face,releaseusername as username From post Where releaseuser='$userid$'";
        sql = [sql stringByReplacingOccurrencesOfString:@"$userid$" withString:uid];
        FMResultSet *resultSet=[db executeQuery:sql];
        
        if ([resultSet next]) {
            NSString *face=[resultSet stringForColumn:@"face"];
            NSString *username=[resultSet stringForColumn:@"username"];
            
            userModel = [[UserModel alloc]init];
            userModel.uid = uid;
            userModel.face=face;
            userModel.username=username;
        }
        [resultSet close];
    }];
    
    return userModel;
}

/**
 *  搜索【我的好友】
 *  @param searchText 过滤条件
 *  @return 搜索结果
 */
-(NSMutableArray *)searchFriendList:(NSString *)searchText {
    NSMutableArray *retCells=[NSMutableArray array];
        NSString *sqlString=@" select * From User Where uid in ( select distinct u.uid from user_contact uc"
        "                                      inner join user u on uc.ctid=u.uid"
        "                                      where upper(u.username) like '%%%@%%' or upper(u.quancheng) like '%%%@%%' or upper(u.jiancheng) like '%%%@%%' or upper(u.mobile) like '%%%@%%' or upper(u.email) like '%%%@%%'  ) order by quancheng";
        searchText=[searchText uppercaseString];
        sqlString=[NSString stringWithFormat:sqlString,searchText,searchText,searchText,searchText,searchText];

        [[self getDbQuene:@"user" FunctionName:@"searchFriendList:(NSString *)searchText" ] inTransaction:^(FMDatabase *db, BOOL *rollback) {

            FMResultSet *resultSet=[db executeQuery:sqlString];
            while ([resultSet next]) {
                NSString *username = [resultSet stringForColumn:@"username"];
                NSString *quancheng = [resultSet stringForColumn:@"quancheng"];
                NSString *jiancheng = [resultSet stringForColumn:@"jiancheng"];
                NSString *mobile = [resultSet stringForColumn:@"mobile"];
                NSString *email = [resultSet stringForColumn:@"email"];
                
                ContactRootSearchModel2 *cellModel = [[ContactRootSearchModel2 alloc] init];
                cellModel.uid = [resultSet stringForColumn:@"uid"];;
                cellModel.username = [resultSet stringForColumn:@"username"];
                
                if( (![NSString isNullOrEmpty:username] && [[username uppercaseString] rangeOfString:searchText].location!=NSNotFound)
                   || (![NSString isNullOrEmpty:quancheng] && [[quancheng uppercaseString] rangeOfString:searchText].location!=NSNotFound)
                   || (![NSString isNullOrEmpty:jiancheng] && [[jiancheng uppercaseString] rangeOfString:searchText].location!=NSNotFound) ){
                    cellModel.des = @"";
                }
                else if( ![NSString isNullOrEmpty:mobile] && [[mobile uppercaseString] rangeOfString:searchText].location!=NSNotFound ){
                    cellModel.des = [NSString stringWithFormat:@"手机号:%@",mobile];
                }
                else if( ![NSString isNullOrEmpty:email] && [[email uppercaseString] rangeOfString:searchText].location!=NSNotFound ){
                    cellModel.des = [NSString stringWithFormat:@"邮箱:%@",email];
                }
                
                cellModel.face = [resultSet stringForColumn:@"face"];
                [retCells addObject:cellModel];
            }
            [resultSet close];
        }];
    
    return [retCells copy];
}

/**
 *  搜索【我的好友】
 *  @param searchText 过滤条件
 *  @return 搜索结果
 */
-(NSMutableArray *)searchFriendListForContactFriend:(NSString *)searchText {
    NSMutableArray *retCells=[NSMutableArray array];
    NSString *sqlString=@" select * From User Where uid in ( select distinct u.uid from user_contact uc"
    "                                      inner join user u on uc.ctid=u.uid"
    "                                      where upper(u.username) like '%%%@%%' or upper(u.quancheng) like '%%%@%%' or upper(u.jiancheng) like '%%%@%%' or upper(u.mobile) like '%%%@%%' or upper(u.email) like '%%%@%%'  ) order by quancheng";
    searchText=[searchText uppercaseString];
    sqlString=[NSString stringWithFormat:sqlString,searchText,searchText,searchText,searchText,searchText];
    
    [[self getDbQuene:@"user" FunctionName:@"searchFriendListForContactFriend:(NSString *)searchText" ] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *resultSet=[db executeQuery:sqlString];
        while ([resultSet next]) {
            UserModel *userModel = [self convertResultSet2Model:resultSet];
            [retCells addObject:userModel];
        }
        [resultSet close];
    }];
    
    return [retCells copy];
}

#pragma mark - Private Function

/**
 *  将数据库结果集转换为Model
 *  @param resultSet
 *  @return
 */
-(UserModel *)convertResultSet2Model:(FMResultSet *)resultSet{
    
    
    NSString *uid=[resultSet stringForColumn:@"uid"];
    NSString *mobile=[resultSet stringForColumn:@"mobile"];
    NSString *email=[resultSet stringForColumn:@"email"];
    NSString *address=[resultSet stringForColumn:@"address"];
    NSInteger gender=[resultSet intForColumn:@"gender"];
    NSInteger regtype=[resultSet intForColumn:@"regtype"];
    NSString *wechat=[resultSet stringForColumn:@"wechat"];
    NSString *weibo=[resultSet stringForColumn:@"weibo"];
    NSString *qq=[resultSet stringForColumn:@"qq"];
    NSInteger isbingphone=[resultSet intForColumn:@"isbingphone"];
    NSInteger isbindemail=[resultSet intForColumn:@"isbindemail"];
    NSDate   *addtime=[resultSet dateForColumn:@"addtime"];
    NSString *quancheng=[resultSet stringForColumn:@"quancheng"];
    NSString *jiancheng=[resultSet stringForColumn:@"jiancheng"];
    NSString *face=[resultSet stringForColumn:@"face"];
    NSString *username=[resultSet stringForColumn:@"username"];
    NSString *loginname=[resultSet stringForColumn:@"loginname"];
    NSDate   *birthday=[resultSet dateForColumn:@"birthday"];
    NSString *province=[resultSet stringForColumn:@"province"];
    NSString *city=[resultSet stringForColumn:@"city"];
    NSString *county=[resultSet stringForColumn:@"county"];
    NSString *officecall=[resultSet stringForColumn:@"officecall"];
    
    UserModel *userModel = [[UserModel alloc]init];
    userModel.face=face;
    userModel.username=username;
    userModel.loginname=loginname;
    userModel.mobile=mobile;
    userModel.gender=gender;
    userModel.birthday=birthday;
    userModel.province=province;
    userModel.city=city;
    userModel.county=county;
    userModel.uid=uid;
    userModel.email = email;
    userModel.address =address;
    userModel.regtype = regtype;
    userModel.wechat = wechat;
    userModel.weibo = weibo;
    userModel.qq = qq;
    userModel.isbindphone =isbingphone;
    userModel.isbindemail = isbindemail;
    userModel.addtime = addtime;
    userModel.quancheng =quancheng;
    userModel.jiancheng = jiancheng;
    userModel.officecall = officecall;
    
    return userModel;
}

@end
