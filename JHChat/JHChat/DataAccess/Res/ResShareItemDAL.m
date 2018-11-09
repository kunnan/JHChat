//
//  ResShareItemDAL.m
//  LeadingCloud
//
//  Created by SY on 16/2/23.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  sy
 Date：   2016-02-23
 Version: 1.0
 Description: 【云盘】分享文件数据库
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ResShareItemDAL.h"
#import "ResShareItemModel.h"
@implementation ResShareItemDAL
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ResShareItemDAL *)shareInstance{
    static ResShareItemDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[ResShareItemDAL alloc] init];
    }
    return instance;
}
#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createResShareItemTableIfNotExists
{
    NSString *tableName = @"resshareitem";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[shiid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[shareid] [varchar](50) NULL,"
                                         "[rpid] [varchar](50) NULL,"
                                         "[itemid] [varchar](50) NULL,"
                                         "[itemname] [varchar](100) NULL,"
                                         "[itemexptype] [varchar](100) NULL,"
                                         "[itemtype] [integer] NULL,"
                                         "[itemsize] [varchar](50) NULL,"
                                         "[sharedate] [date] NULL,"
                                         "[itempartitontype] [integer] NULL,"
                                         "[isvalid] [integer] NULL,"
                                         "[showname] [varchar](100) NULL,"
                                         "[showsize] [varchar](50) NULL,"
                                         "[icon] [varchar](50) NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateResShareItemTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
//                case 21:
//                [self AddColumnToTableIfNotExist:@"resshareitem" columnName:@"isvalid" type:@"[integer]"];
//                [self AddColumnToTableIfNotExist:@"resshareitem" columnName:@"showname" type:@"[varchar](100)"];
//                [self AddColumnToTableIfNotExist:@"resshareitem" columnName:@"showsize" type:@"[varchar](50)"];
//                [self AddColumnToTableIfNotExist:@"resshareitem" columnName:@"icon" type:@"[varchar](50)"];
//                
//                break;
                
        }
    }
}
#pragma mark - 添加数据
-(void)addShareItemsWithArray:(NSMutableArray*)shareArray {
    
    [[self getDbQuene:@"resshareitem" FunctionName:@"addShareItemsWithArray:(NSMutableArray*)shareArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		
		NSString *sql = @"INSERT OR REPLACE INTO resshareitem(shiid,shareid,rpid,itemid,itemname,itemexptype,itemtype,itemsize,sharedate,itempartitontype,isvalid,showname,showsize,icon)" "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        for (int i  = 0; i < shareArray.count; i++) {
            ResShareItemModel *shareModel = [shareArray objectAtIndex:i];
            
            NSString *shareid = shareModel.shareid;
            NSString *name = shareModel.itemname;
            NSString *showname = shareModel.showname;
            NSString *rpid = shareModel.rpid;
            NSString *shiid = shareModel.shiid;
            NSString *itemid = shareModel.itemid;
            NSDate *sharedate = shareModel.sharedate;
            NSNumber *partitiontype = [NSNumber numberWithInteger:shareModel.itempartitiontype] ;
            NSString *exptype = shareModel.itemexptype;
            NSNumber *type = [NSNumber numberWithInteger: shareModel.itemtype];
            NSNumber *itemsize = [NSNumber numberWithLongLong:shareModel.itemsize];
            NSString *showsize = shareModel.showsize;
            NSNumber *isvalid = [NSNumber numberWithInteger:shareModel.isvalid];
            NSString *icon = shareModel.icon;
			
            
            isOK = [db executeUpdate:sql,shiid,shareid,rpid,itemid,name,exptype,type,itemsize,sharedate,partitiontype,isvalid,showname,showsize,icon];
            if (!isOK) {
                DDLogError(@"插入失败");
                break;
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"resshareitem" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
        
        
    }];

    
    
}
#pragma mark - 删除数据
-(void)deleteAllShareFile{
    
    [[self getDbQuene:@"resshareitem" FunctionName:@"deleteAllShareFile"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from resshareitem ";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"resshareitem" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
    
    
}

#pragma mark - 查询数据

/**
 *  获取资源列表
 *
 *  @param classid  文件夹ID
 *  @param start    起始条目
 *  @param count    需要获取的条目数量
 *  @param sortDic  排序规则
 *
 *  @return 资源记录数组
 */
-(NSMutableArray *)getShareItemModelsWithShiid:(NSString *)shiid startNum:(NSInteger)start queryCount:(NSInteger)count sort:(NSMutableDictionary *)sortDic
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    /* 排序信息 */
//    NSString *column = [sortDic objectForKey:@"column"];
//    NSString *sortrule = [sortDic objectForKey:@"sortrule"];
    
    [[self getDbQuene:@"resshareitem" FunctionName:@"getShareItemModelsWithShiid:(NSString *)shiid startNum:(NSInteger)start queryCount:(NSInteger)count sort:(NSMutableDictionary *)sortDic"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From resshareitem "
                       "Order by 'desc' limit %ld, %ld",start,count];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;
}


-(ResShareItemModel*)convertResultSetToModel:(FMResultSet*)result {
    
    NSString *shiid = [result stringForColumn:@"shiid"];
    NSString *shareid = [result stringForColumn:@"shareid"];
    NSInteger itempartitontype = [result intForColumn:@"itempartitontype"];
    NSString *itemname = [result stringForColumn:@"itemname"];
    NSString *rpid = [result stringForColumn:@"rpid"];
    NSString *itemid = [result stringForColumn:@"itemid"];
    NSDate *sharedate = [result dateForColumn:@"sharedate"];
    NSInteger itemtype = [result intForColumn:@"itemtype"];
    NSString *itemexptype = [result stringForColumn:@"itemexptype"];
    NSString *itemsize = [result stringForColumn:@"itemsize"];
    
    ResShareItemModel *resModel = [[ResShareItemModel alloc] init];
    resModel.shiid = shiid;
    resModel.shareid = shareid;
    resModel.itemname = itemname;
    resModel.rpid = rpid;
    resModel.itemid = itemid;
    resModel.itemtype = itemtype;
    resModel.itempartitiontype = itempartitontype;
    resModel.sharedate = sharedate;
    resModel.itemexptype = itemexptype;
    resModel.itemsize = (long long)itemsize;

    
    return resModel;
}
@end
