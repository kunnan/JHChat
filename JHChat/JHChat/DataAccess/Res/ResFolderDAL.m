//
//  ResFolderDAL.m
//  LeadingCloud
//
//  Created by wchMac on 16/1/13.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  dfl
 Date：   2016-01-13
 Version: 1.0
 Description: 资源文件夹处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ResFolderDAL.h"
#import "ResFolderModel.h"
#import "NSString+IsNullOrEmpty.h"
@implementation ResFolderDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ResFolderDAL *)shareInstance{
    static ResFolderDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[ResFolderDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createResFolderTableIfNotExists
{
    NSString *tableName = @"resfolder";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[classid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[url] [text] NULL,"
                                         "[name] [varchar](50) NULL,"
                                         "[createdate] [date] NULL,"
                                         "[createuser] [varchar](50) NULL,"
                                         "[createusername] [varchar](50) NULL,"
                                         "[updatedate] [date] NULL,"
                                         "[updateuser] [varchar](50) NULL,"
                                         "[updateusername] [varchar](50) NULL,"
                                         "[parentid] [varchar](50) NULL,"
                                         "[parentall] [text] NULL,"
                                         "[partitiontype] [integer] NULL,"
                                         "[iscacheallres] [integer] NULL,"
                                         "[rpid] [varchar](50) NULL,"
                                         "[description] [text] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateResFolderTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 75:
                
                [self AddColumnToTableIfNotExist:@"resfolder" columnName:@"[operateauthority]" type:@"[integer]"];
                [self AddColumnToTableIfNotExist:@"resfolder" columnName:@"[isshare]" type:@"[integer]"];
                break;
           
        }
    }
}
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)resFolderArray{
    
    [[self getDbQuene:@"resfolder" FunctionName:@"addDataWithArray:(NSMutableArray *)resFolderArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO resfolder(classid,url,name,createdate,createuser,createusername,updatedate,updateuser,updateusername,parentid,parentall,partitiontype,rpid,description,icon,pinyin,operateauthority,isshare)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
        for (int i = 0; i< resFolderArray.count;  i++) {
            ResFolderModel *resFolderModel = [resFolderArray objectAtIndex:i];
            
            NSString *classid = resFolderModel.classid;
            NSString *url = resFolderModel.url;
            NSString *name = resFolderModel.name;
            NSDate *createdate = resFolderModel.createdate;
            NSString *createuser = resFolderModel.createuser;
            NSString *createusername = resFolderModel.createusername;
            NSDate *updatedate = resFolderModel.updatedate;
            NSString *updateuser = resFolderModel.updateuser;
            NSString *updateusername = resFolderModel.updateusername;
            NSString *parentid = resFolderModel.parentid;
            NSString *parentall = resFolderModel.parentall;
            NSNumber *partitiontype = [NSNumber numberWithInteger:resFolderModel.partitiontype];
            NSString *description = resFolderModel.descript;
            NSString *rpid = resFolderModel.rpid;
            NSString *icon = resFolderModel.icon;
            NSString *pinyin = resFolderModel.pinyin;
            NSNumber *operateauthority = [NSNumber numberWithInteger:resFolderModel.operateauthority];
            NSNumber *isshare = [NSNumber numberWithInteger:resFolderModel.isshare];
            isOK = [db executeUpdate:sql,classid,url,name,createdate,createuser,createusername,updatedate,updateuser,updateusername,parentid,parentall,partitiontype,rpid,description,icon,pinyin,operateauthority,isshare];
            if (!isOK) {
                DDLogError(@"插入失败");
                break;
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"resfolder" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
}

/**
 *  根据文件夹Model添加数据
 */
-(void)addDataWithResFolderModel:(ResFolderModel *)resFolderModel{
    
    [[self getDbQuene:@"resfolder" FunctionName:@"addDataWithResFolderModel:(ResFolderModel *)resFolderModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;

        NSString *classid = resFolderModel.classid;
        NSString *url = resFolderModel.url;
        NSString *name = resFolderModel.name;
        NSDate *createdate = resFolderModel.createdate;
        NSString *createuser = resFolderModel.createuser;
        NSString *createusername = resFolderModel.createusername;
        NSDate *updatedate = resFolderModel.updatedate;
        NSString *updateuser = resFolderModel.updateuser;
        NSString *updateusername = resFolderModel.updateusername;
        NSString *parentid = resFolderModel.parentid;
        NSString *parentall = resFolderModel.parentall;
        NSNumber *partitiontype = [NSNumber numberWithInteger:resFolderModel.partitiontype];
        NSString *description = resFolderModel.descript;
        NSString *rpid = resFolderModel.rpid;
        NSString *icon = resFolderModel.icon;
        NSString *pinyin = resFolderModel.pinyin;
        NSNumber *operateauthority =[NSNumber numberWithInteger: resFolderModel.operateauthority];
        NSNumber *isshare = [NSNumber numberWithInteger:resFolderModel.isshare];
        NSString *sql = @"INSERT OR REPLACE INTO resfolder(classid,url,name,createdate,createuser,createusername,updatedate,updateuser,updateusername,parentid,parentall,partitiontype,rpid,description,icon,pinyin,operateauthority,isshare)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,classid,url,name,createdate,createuser,createusername,updatedate,updateuser,updateusername,parentid,parentall,partitiontype,rpid,description,icon,pinyin,operateauthority,isshare];
        if (!isOK) {
            DDLogError(@"插入失败");
        }

        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"resfolder" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
    
}

#pragma mark - 删除数据
/**
 *  删除单个文件夹
 *
 *  @param classid 文件夹ID
 */
- (void) deleteFolderWithClassid:(NSString *) classid {
    [[self getDbQuene:@"resfolder" FunctionName:@"deleteFolderWithClassid:(NSString *) classid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from resfolder Where classid = ? ";
        isOK = [db executeUpdate:sql, classid];
        if (!isOK) {
            DDLogVerbose(@"====删除失败=====");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"resfolder" Sql:sql Error:@"删除失败" Other:nil];

        }
         
    }];
    
}
/**
 *  删除所有文件夹，以保持与web端数据同步
 *
 *  @param rpid 资源池id 父
 */
-(void) deleteAllFolderWithRpid:(NSString *)rpid{
    [[self getDbQuene:@"resfolder" FunctionName:@"deleteAllFolderWithRpid:(NSString *)rpid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from resfolder Where rpid = ?";
        isOK = [db executeUpdate:sql, rpid];
        if (!isOK) {
            DDLogVerbose(@"====删除失败=====");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"resfolder" Sql:sql Error:@"删除失败" Other:nil];

        }
        
    }];
}
/**
 *  删除单个文件夹
 *
 *  @param classid 文件夹ID
 */
- (void) deleteFolderWithPraentId:(NSString *) parentid {
    [[self getDbQuene:@"resfolder" FunctionName:@"deleteFolderWithPraentId:(NSString *) parentid "] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from resfolder Where parentid = ? ";
        isOK = [db executeUpdate:sql, parentid];
        if (!isOK) {
            DDLogVerbose(@"====删除失败=====");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"resfolder" Sql:sql Error:@"删除失败" Other:nil];

        }
        
    }];
    
}
#pragma mark - 修改数据

/**
 *  更新文件夹下的资源数量
 *
 *  @param iscacheall 是否缓存完所有资源
 *  @param classid    文件夹ID
 */
-(void)updateIsCacheAllRes:(NSInteger)iscacheall withClassid:(NSString *)classid{
    
    [[self getDbQuene:@"resfolder" FunctionName:@"updateIsCacheAllRes:(NSInteger)iscacheall withClassid:(NSString *)classid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update resfolder set iscacheallres=? Where classid=?";
        isOK = [db executeUpdate:sql,[NSNumber numberWithInteger:iscacheall],classid];
        if (!isOK) {
            DDLogError(@"更新失败 - updateMsgId");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"resfolder" Sql:sql Error:@"更新失败" Other:nil];

        }
    }];
    
}

/**
 *   修改文件夹名
 *
 *  @param resfolderName 新名字
 *  @param classid       文件夹id
 */
- (void)updataFolderNam:(NSString*)resfolderName withClassid:(NSString *)classid {
    [[self getDbQuene:@"resfolder" FunctionName:@"updataFolderNam:(NSString*)resfolderName withClassid:(NSString *)classid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update resfolder set name = ?  Where classid = ? ";
        isOK = [db executeUpdate:sql,resfolderName, classid];
        if (!isOK) {
            DDLogVerbose(@"=====文件更新失败=====");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"resfolder" Sql:sql Error:@"更新失败" Other:nil];

        }
    }];
    
    
}
/**
 *   更新是够分享字段
 *
 *  @param resfolderName 新名字
 *  @param classid       文件夹id
 */
- (void)updataIsShare:(NSInteger)isshare withClassid:(NSString *)classid {
    [[self getDbQuene:@"resfolder" FunctionName:@"updataIsShare:(NSInteger)isshare withClassid:(NSString *)classid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSNumber *share = [NSNumber numberWithInteger:isshare];
        NSString *sql = @"update resfolder set isshare = ?  Where classid = ? ";
        isOK = [db executeUpdate:sql,share, classid];
        if (!isOK) {
            DDLogVerbose(@"=====文件更新失败=====");
            [[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"resfolder" Sql:sql Error:@"更新失败" Other:nil];
            
        }
    }];
    
}
/**
 *   更新icon字段
 *
 *  @param resfolderName 新名字
 *  @param classid       文件夹id
 */
- (void)updataIcon:(NSString*)icon withClassid:(NSString *)classid {
    [[self getDbQuene:@"resfolder" FunctionName:@"updataIcon:(NSString*)icon withClassid:(NSString *)classid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update resfolder set icon = ?  Where classid = ? ";
        isOK = [db executeUpdate:sql,icon, classid];
        if (!isOK) {
            DDLogVerbose(@"=====文件更新失败=====");
            [[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"resfolder" Sql:sql Error:@"更新失败" Other:nil];
            
        }
    }];
    
}
/**
 *  协作文件保存到云盘
 *
 *  @param parentid 新的父id
 *  @param rpid     新的资源池id
 *  @param classid  保存的文件夹
 */
- (void)updataFolderParentid:(NSString*)parentid andRpid:(NSString*)rpid withClassid:(NSString *)classid {
    [[self getDbQuene:@"resfolder" FunctionName:@"updataFolderParentid:(NSString*)parentid andRpid:(NSString*)rpid withClassid:(NSString *)classid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update resfolder set parentid = ? , rpid = ? Where classid = ? ";
        isOK = [db executeUpdate:sql,parentid,rpid, classid];
        if (!isOK) {
            DDLogVerbose(@"=====文件更新失败=====");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"resfolder" Sql:sql Error:@"更新失败" Other:nil];

        }
    }];
    
    
}

/**
 *  协作 - 任务 - 文件 修改文件夹名
 *
 *  @param resfolderName 新名字
 *  @param classid       文件夹id
 */
- (void)updataFolderName:(NSString*)resfolderName andDescription:(NSString*)description withClassid:(NSString *)classid {
    [[self getDbQuene:@"resfolder" FunctionName:@"updataFolderName:(NSString*)resfolderName andDescription:(NSString*)description withClassid:(NSString *)classid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update resfolder set name = ? Where classid = ? ";
        isOK = [db executeUpdate:sql,resfolderName, classid];
        if (!isOK) {
            DDLogVerbose(@"=====文件重命名更新失败=====");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"resfolder" Sql:sql Error:@"更新失败" Other:nil];

        }
    }];
    
    
}

/**
 *  修改文件夹路径(移动文件夹)
 *
 *  @param folder 文件夹model
 */
-(void)updataFolderPath:(ResFolderModel*)folder
{
    
    [[self getDbQuene:@"resfolder" FunctionName:@"updataFolderPath:(ResFolderModel*)folder"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update resfolder set parentall = ? , parentid = ? Where classid = ? ";
        isOK = [db executeUpdate:sql,folder.parentall,folder.parentid,folder.classid];
        if (!isOK) {
            DDLogVerbose(@"=====文件移动失败=====");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"resfolder" Sql:sql Error:@"更新失败" Other:nil];

        }
    }];

    
    
}
#pragma mark - 查询数据

/**
 *  获取根节点的classid
 *
 *  @return 根节点文件夹ID
 */
-(NSString *)getRootClassid{
    __block NSString *classid = @"";
    
    [[self getDbQuene:@"resfolder" FunctionName:@"getRootClassid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select classid From resfolder Where parentid='-'"];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            classid = [resultSet stringForColumn:@"classid"];
        }
        [resultSet close];
    }];
    
    return classid;
}

/**
 *  协作- 获取根文件夹
 *
 *  @param rpid 文件夹资源池id
 *
 *  @return 文件根id
 */
-(NSString *)getRootClassidWithParentAndRpid:(NSString*)rpid{
    __block NSString *classid = @"";
    
    [[self getDbQuene:@"resfolder" FunctionName:@"getRootClassidWithParentAndRpid:(NSString*)rpid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select classid From resfolder Where parentid='-' and rpid ='%@'",rpid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            classid = [resultSet stringForColumn:@"classid"];
        }
        [resultSet close];
    }];
    
    return classid;
}
// 获取parentall 用于连续跳转
-(NSString *)getParentallWithClassid:(NSString*)classid{
    __block NSString *parentall = @"";
    
    [[self getDbQuene:@"resfolder" FunctionName:@"getParentallWithClassid:(NSString*)classid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select parentall From resfolder Where classid ='%@'",classid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            parentall = [resultSet stringForColumn:@"parentall"];
        }
        [resultSet close];
    }];
    
    return parentall;
}

/**
 *  获取根文件夹Model
 *
 *  @return 根文件夹
 */
-(ResFolderModel *)getRootFolderModelWithRpid:(NSString*)rpid{
    __block ResFolderModel *resFolderModel = nil;
    
    [[self getDbQuene:@"resfolder" FunctionName:@"getRootFolderModelWithRpid:(NSString*)rpid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select classid,url,name,createdate,createuser,createusername,updatedate,updateuser,updateusername,parentid,parentall,partitiontype,rpid,description,icon,pinyin,operateauthority,isshare From resfolder Where parentid='-' and rpid = '%@'",rpid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            resFolderModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return resFolderModel;
}

/**
 获取指定根文件夹

 @param rpid     资源池id
 @param parentid 根文件夹id

 @return 根文件夹
 */
-(ResFolderModel *)getRootFolderModelWithRpid:(NSString*)rpid parentid:(NSString*)parentid{
    __block ResFolderModel *resFolderModel = nil;
    
   
    [[self getDbQuene:@"resfolder" FunctionName:@"getRootFolderModelWithRpid:(NSString*)rpid parentid:(NSString*)parentid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = nil;
        if ([NSString isNullOrEmpty:parentid]) {
        
             sql=[NSString stringWithFormat:@"Select classid,url,name,createdate,createuser,createusername,updatedate,updateuser,updateusername,parentid,parentall,partitiontype,rpid,description,icon,pinyin,operateauthority,isshare From resfolder Where parentid='-' and rpid = '%@'",rpid];
        }
        else {
            sql=[NSString stringWithFormat:@"Select classid,url,name,createdate,createuser,createusername,updatedate,updateuser,updateusername,parentid,parentall,partitiontype,rpid,description,icon,pinyin,operateauthority,isshare From resfolder Where classid='%@' and rpid = '%@'",parentid, rpid];
        }
       
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            resFolderModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return resFolderModel;
}
/**
 *  获取此文件夹下的资源是否缓存完
 *
 *  @param classid 文件夹ID
 *
 *  @return 资源数量
 */
-(BOOL)checkIsCacheAllWithClassid:(NSString *)classid{
    __block NSInteger resCount = 0;
    
    [[self getDbQuene:@"resfolder" FunctionName:@"checkIsCacheAllWithClassid:(NSString *)classid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select ifnull(iscacheallres,0) count From resfolder Where classid='%@'",classid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            resCount = [resultSet intForColumn:@"count"];
        }
        [resultSet close];
    }];
    
    return resCount>0 ? YES : NO;
}

/**
 *  协作-工作组-文件夹
 *
 *  @param parentid 文件夹ID
 *  @param sortDic  排序规则
 *
 *  @return 子文件夹
 */
-(NSMutableArray *)getChildModelsWithClassid:(NSString *)classid  sort:(NSMutableDictionary *)sortDic
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    /* 排序信息 */
    NSString *column = [sortDic objectForKey:@"column"];
    NSString *sortrule = [sortDic objectForKey:@"sortrule"];
    NSString *secondSort = [self secondParamertSortWithCurSort:column];
    
    
    [[self getDbQuene:@"resfolder" FunctionName:@"getChildModelsWithClassid:(NSString *)classid  sort:(NSMutableDictionary *)sortDic"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select classid,url,name,createdate,createuser,createusername,updatedate,updateuser,updateusername,parentid,parentall,partitiontype,rpid,description,icon,pinyin,operateauthority,isshare"
                       " From resfolder Where parentid='%@'"
                       " Order by %@ %@,%@ %@",classid,column,sortrule,secondSort,sortrule];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;
}
/**
 *  协作 - 文件
 *
 *  @param classid 文件夹id
 *  @param rpid    资源池id
 *  @param sortDic 排序
 *
 *  @return 数据
 */
-(NSMutableArray *)getChildModelsWithClassid:(NSString *)classid andRpid:(NSString*)rpid sort:(NSMutableDictionary *)sortDic
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    /* 排序信息 */
    NSString *column = [sortDic objectForKey:@"column"];
    NSString *sortrule = [sortDic objectForKey:@"sortrule"];
    NSString *secondSort = [self secondParamertSortWithCurSort:column];
    
    [[self getDbQuene:@"resfolder" FunctionName:@"getChildModelsWithClassid:(NSString *)classid andRpid:(NSString*)rpid sort:(NSMutableDictionary *)sortDic"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select classid,url,name,createdate,createuser,createusername,updatedate,updateuser,updateusername,parentid,parentall,partitiontype,rpid,description,icon,pinyin,operateauthority,isshare"
                       " From resfolder Where parentid='%@' and rpid= '%@'"
                       " Order by %@ %@,%@ %@",classid,rpid,column,sortrule,secondSort,sortrule];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;
}
// 通过classid找到该文件夹
-(ResFolderModel*)getFolderModelWithClassid:(NSString*)classid {
    __block ResFolderModel *resFolderModel = nil;
    [[self getDbQuene:@"resfolder" FunctionName:@"getFolderModelWithClassid:(NSString*)classid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select classid,url,name,createdate,createuser,createusername,updatedate,updateuser,updateusername,parentid,parentall,partitiontype,rpid,description,icon,pinyin,operateauthority,isshare From resfolder Where  classid = '%@'",classid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            resFolderModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return resFolderModel;
    
    
    
}
#pragma mark - Private Function

/**
 *  将FMResultSet转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return ImChatLogModel
 */
-(ResFolderModel *)convertResultSetToModel:(FMResultSet *)resultSet {
    
    NSString *classid = [resultSet stringForColumn:@"classid"];
    NSString *url = [resultSet stringForColumn:@"url"];
    NSString *rpid = [resultSet stringForColumn:@"rpid"];
    NSString *name = [resultSet stringForColumn:@"name"];
    NSDate *createdate = [resultSet dateForColumn:@"createdate"];
    NSString *createuser = [resultSet stringForColumn:@"createuser"];
    NSString *createusername = [resultSet stringForColumn:@"createusername"];
    NSDate *updatedate = [resultSet dateForColumn:@"updatedate"];
    NSString *updateuser = [resultSet stringForColumn:@"updateuser"];
    NSString *updateusername = [resultSet stringForColumn:@"updateusername"];
    NSString *parentid = [resultSet stringForColumn:@"parentid"];
    NSString *parentall = [resultSet stringForColumn:@"parentall"];
    NSInteger partitiontype = [resultSet intForColumn:@"partitiontype"];
    NSString *description = [resultSet stringForColumn:@"description"];
    NSString *icon = [resultSet stringForColumn:@"icon"];
    NSString *pinyin = [resultSet stringForColumn:@"pinyin"];
    NSInteger operateauthority = [resultSet intForColumn:@"operateauthority"];
    NSInteger isshare = [resultSet intForColumn:@"isshare"];
    
    ResFolderModel * resFolderModel = [[ResFolderModel alloc] init];
    resFolderModel.classid = classid;
    resFolderModel.url = url;
    resFolderModel.name = name;
    resFolderModel.createdate = createdate;
    resFolderModel.createuser = createuser;
    resFolderModel.createusername = createusername;
    resFolderModel.updatedate = updatedate;
    resFolderModel.updateuser = updateuser;
    resFolderModel.updateusername = updateusername;
    resFolderModel.parentid = parentid;
    resFolderModel.parentall = parentall;
    resFolderModel.partitiontype = partitiontype;
    resFolderModel.rpid = rpid;
    resFolderModel.descript = description;
    resFolderModel.icon = icon;
    resFolderModel.pinyin = pinyin;
    resFolderModel.operateauthority = operateauthority;
    resFolderModel.isshare = isshare;
    
    return resFolderModel;
    
    
}
#pragma mark - 第二字段排序
-(NSString *) secondParamertSortWithCurSort:(NSString *)sortStr {
    if ([sortStr isEqualToString:@"updatedate"]) {
        return @"pinyin";
    }
    else if ([sortStr isEqualToString:@"pinyin"]) {
        return @"updatedate";
    }
   
    return sortStr;
}

@end
