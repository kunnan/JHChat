//
//  ResShareDAL.m
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

#import "ResShareDAL.h"
#import "ResShareModel.h"
@implementation ResShareDAL


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ResShareDAL *)shareInstance{
    static ResShareDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[ResShareDAL alloc] init];
    }
    return instance;
}


#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createResShareFolderTableIfNotExists
{
    NSString *tableName = @"resshare";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[shareid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[rpid] [varchar](50) NULL,"
                                         "[name] [varchar](50) NULL,"
                                         "[exptype] [varchar](100) NULL,"
                                         "[sharedate] [date] NULL,"
                                         "[shareuser] [varchar](50) NULL,"
                                         "[shareusername] [varchar](50) NULL,"
                                         "[matuitydatedate] [date] NULL,"
                                         "[partitiontype] [integer] NULL,"
                                         "[type] [integer] NULL,"
                                         "[link] [varchar](100) NULL,"
                                         "[showtype] [varchar](100) NULL,"
                                         "[paw] [varchar](50) NULL,"
                                         "[imageurl] [varchar](100) NULL,"
                                         "[issrc] [integer] NULL,"
                                         "[copylink] [varchar](250) NULL,"
                                         "[qrcode] [varchar](100) NULL,"
                                         "[showlink] [varchar](150) NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateResShareFolderTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
//            case 3:{
//                [self AddColumnToTableIfNotExist:@"resshare" columnName:@"imageurl" type:@"[varchar](100)"];
//                [self AddColumnToTableIfNotExist:@"resshare" columnName:@"issrc" type:@"[integer]"];
//                break;
//            }
//            case 22: {
//                [self AddColumnToTableIfNotExist:@"resshare" columnName:@"copylink" type:@"[varchar](250)"];
//                [self AddColumnToTableIfNotExist:@"resshare" columnName:@"qrcode" type:@"[varchar](100)"];
//                [self AddColumnToTableIfNotExist:@"resshare" columnName:@"showlink" type:@"[varchar](150)"];
//                 break;
//            }
        }
    }
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
-(NSMutableArray *)getShareModelsWithClass:(NSString *)classid startNum:(NSInteger)start queryCount:(NSInteger)count sort:(NSMutableDictionary *)sortDic
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
        [[self getDbQuene:@"resshare" FunctionName:@"getShareModelsWithClass:(NSString *)classid startNum:(NSInteger)start queryCount:(NSInteger)count sort:(NSMutableDictionary *)sortDic"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql=[NSString stringWithFormat:@"Select * From resshare "
                           "Order by sharedate desc limit %ld, %ld",start,count];
            FMResultSet *resultSet=[db executeQuery:sql];
            while ([resultSet next]) {
                
                [result addObject:[self converResultSetToModel:resultSet]];
            }
            [resultSet close];
        }];
    
    return result;
}

/**
 *  获取资源列表
 *
 *  @return 资源记录数组
 */
-(NSMutableArray *)getShareModels{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"resshare" FunctionName:@"getShareModels"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From resshare Order by sharedate desc"];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            
            [result addObject:[self converResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;
}

-(ResShareModel*)getDidShareModelWithShareid:(NSString*)shareid {
    __block ResShareModel *resModel = nil;
    
    [[self getDbQuene:@"resshare" FunctionName:@"getDidShareModelWithShareid:(NSString*)shareid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select *"
                       " From resshare Where shareid='%@' ",shareid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            
            resModel = [self converResultSetToModel:resultSet];
            
        }
        [resultSet close];
    }];
    
    return resModel;

    
}
/**
 *  将FMResultSet转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return FavoritesModel
 */

-(ResShareModel*)converResultSetToModel:(FMResultSet*)resultSet{
    
   
    NSString *shareid = [resultSet stringForColumn:@"shareid"];
    NSString *name = [resultSet stringForColumn:@"name"];
    NSString *rpid = [resultSet stringForColumn:@"rpid"];
    NSDate *sharedate = [resultSet dateForColumn:@"sharedate"];
    NSDate *matuitydatedate = [resultSet dateForColumn:@"matuitydatedate"];
    NSInteger partitiontype = [resultSet intForColumn:@"partitiontype"];
    NSString *exptype = [resultSet stringForColumn:@"exptype"];
    NSInteger type = [resultSet intForColumn:@"type"];
    NSString *shareuser = [resultSet stringForColumn:@"shareuser"];
    NSString *shareusername = [resultSet stringForColumn:@"shareusername"];
    NSString *paw = [resultSet stringForColumn:@"paw"];
    NSString *shareLink = [resultSet stringForColumn:@"link"];
    NSString *showtype = [resultSet stringForColumn:@"showtype"];
    NSString *imageurl = [resultSet stringForColumn:@"imageurl"];
    NSInteger issrc = [resultSet intForColumn:@"issrc"];
    NSString *copylink = [resultSet stringForColumn:@"copylink"];
    NSString *qrcode = [resultSet stringForColumn:@"qrcode"];
    NSString *showlink = [resultSet stringForColumn:@"showlink"];
    
    ResShareModel *resModel = [[ResShareModel alloc] init];
    resModel.shareid = shareid;
    resModel.name = name;
    resModel.rpid = rpid;
    resModel.matuitydate = matuitydatedate;
    resModel.partitiontype = partitiontype;
    resModel.sharedate = sharedate;
    resModel.exptype = exptype;
    resModel.type = type;
    resModel.shareuser = shareuser;
    resModel.shareusername = shareusername;
    resModel.sharelink = shareLink;
    resModel.paw = paw;
    resModel.showtype = showtype;
    resModel.imageurl = imageurl;
    resModel.issrc = issrc;
    resModel.copylink = copylink;
    resModel.qrcode = qrcode;
    resModel.showlink = showlink;

    return resModel;
    
}
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addShareDataWithArray:(NSMutableArray*)shareArray {
    
    
    [[self getDbQuene:@"resshare" FunctionName:@"addShareDataWithArray:(NSMutableArray*)shareArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		
		NSString *sql = @"INSERT OR REPLACE INTO resshare(shareid,rpid,name,exptype,sharedate,shareuser,shareusername,matuitydatedate,partitiontype,type,link,showtype,paw,imageurl,issrc,copylink,qrcode,showlink)" "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
        for (int i  = 0; i < shareArray.count; i++) {
            ResShareModel *shareModel = [shareArray objectAtIndex:i];
           
            NSString *shareid = shareModel.shareid;
            NSString *name = shareModel.name;
            NSString *rpid = shareModel.rpid;
            NSDate *sharedate = shareModel.sharedate;
            NSDate *matuitydatedate = shareModel.matuitydate;
            NSNumber *partitiontype = [NSNumber numberWithInteger:shareModel.partitiontype] ;
            NSString *exptype = shareModel.exptype;
            NSNumber *type = [NSNumber numberWithInteger: shareModel.type];
            NSString *shareuser = shareModel.shareuser;
            NSString *shareusername = shareModel.shareusername;
            NSString *shareLink = shareModel.sharelink;
            NSString *paw =shareModel.paw;
            NSString *showtype = shareModel.showtype;
            NSString *imageurl = shareModel.imageurl;
            NSNumber *issrc = [NSNumber numberWithInteger:shareModel.issrc];
            NSString *copylink = shareModel.copylink;
            NSString *qrcode = shareModel.qrcode;
            NSString *showlink = shareModel.showlink;
			
            
            isOK = [db executeUpdate:sql,shareid,rpid,name,exptype,sharedate,shareuser,shareusername,matuitydatedate,partitiontype,type,shareLink,showtype,paw,imageurl,issrc,copylink,qrcode,showlink];
            if (!isOK) {
                DDLogError(@"插入失败");
                break;
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"resshare" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    

    }];
}
/**
 *  添加分享文件model
 *
 *  @param shareModel 分享的model
 */
-(void)addShareDataWithModel:(ResShareModel*)shareModel {
    
    [[self getDbQuene:@"resshare" FunctionName:@"addShareDataWithModel:(ResShareModel*)shareModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        
        NSString *shareid = shareModel.shareid;
        NSString *name = shareModel.name;
        NSString *rpid = shareModel.rpid;
        NSDate *sharedate = shareModel.sharedate;
        NSDate *matuitydatedate = shareModel.matuitydate;
        NSNumber *partitiontype = [NSNumber numberWithInteger:shareModel.partitiontype] ;
        NSString *exptype = shareModel.exptype;
        NSNumber *type = [NSNumber numberWithInteger: shareModel.type];
        NSString *shareuser = shareModel.shareuser;
        NSString *shareusername = shareModel.shareusername;
        NSString *shareLink = shareModel.sharelink;
        NSString *paw =shareModel.paw;
        NSString *shoetype = shareModel.showtype;
        NSString *imageurl = shareModel.imageurl;
        NSNumber *issrc = [NSNumber numberWithInteger:shareModel.issrc];
        
        NSString *copylink = shareModel.copylink;
        NSString *qrcode = shareModel.qrcode;
        NSString *showlink = shareModel.showlink;

            NSString *sql = @"INSERT OR REPLACE INTO resshare(shareid,rpid,name,exptype,sharedate,shareuser,shareusername,matuitydatedate,partitiontype,type,link,showtype,paw,imageurl,issrc,copylink,qrcode,showlink)" "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            
            isOK = [db executeUpdate:sql,shareid,rpid,name,exptype,sharedate,shareuser,shareusername,matuitydatedate,partitiontype,type,shareLink,shoetype,paw,imageurl,issrc,copylink,qrcode,showlink];
            if (!isOK) {
                DDLogError(@"插入失败");
                
            }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"resshare" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
        
        
    }];
}
#pragma mark - 删除数据
/**
 *  取消分享
 *
 *  @param shareid 分享文件的主键id
 */
-(void)deleteCancelShareFile:(NSString*)shareid
{
    
    [[self getDbQuene:@"resshare" FunctionName:@"deleteCancelShareFile:(NSString*)shareid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from resshare where shareid=?";
        isOK = [db executeUpdate:sql,shareid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"resshare" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
    
}
-(void)deleteAllShareFile{
    
    [[self getDbQuene:@"resshare" FunctionName:@"deleteAllShareFile"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from resshare ";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"resshare" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];

    
}
@end
