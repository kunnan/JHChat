//
//  CoProjectMainModsDAL.m
//  LeadingCloud
//
//  Created by dfl on 16/10/28.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CoProjectMainModsDAL.h"

@implementation CoProjectMainModsDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoProjectMainModsDAL *)shareInstance {
    static CoProjectMainModsDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[CoProjectMainModsDAL alloc] init];
    }
    return instance;
}
#pragma mark - 表结构操作
-(void)creatProjectMainModsTableIfNotExists {
    
    NSString *tableName = @"co_projectmain_mods";
    
    /* 判断是否创建了此表 */
    if (![super checkIsExistsTable:tableName]) {
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:@"Create Table If Not Exists %@("
                                         "[cpmid] [varchar](150) PRIMARY KEY NOT NULL,"
                                         "[modid] [varchar](100) NULL,"
                                         "[name] [varchar](100) NULL,"
                                         "[appid] [varchar](200) NULL,"
                                         "[appname] [varchar](500) NULL,"
                                         "[codeguid] [varchar](200) NULL,"
                                         "[businessguid] [varchar](200) NULL,"
                                         "[modcolour] [varchar](150) NULL,"
                                         "[modlogo] [varchar](100) NULL,"
                                         "[weburl] [text] NULL,"
                                         "[html5] [text] NULL,"
                                         "[sort] [integer] NULL,"
                                         "[isuseable] [integer] NULL);",
                                         tableName]];
    }
}

/**
 *  升级数据库
 */
-(void)updataCoProjectMainModsTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    
    for (int i = currentDbVersion; i<=systemDbVersion; i++) {
        switch (i) {
            case 13:{

                [self AddColumnToTableIfNotExist:@"co_projectmain_mods" columnName:@"[prid]" type:@"[varchar](100)"];
                break;
            }
            case 17:{
                [self AddColumnToTableIfNotExist:@"co_projectmain_mods" columnName:@"[appcode]" type:@"[text]"];
                break;
            }
            case 46:{
                [self AddColumnToTableIfNotExist:@"co_projectmain_mods" columnName:@"[protogenesis]" type:@"[integer]"];
                [self AddColumnToTableIfNotExist:@"co_projectmain_mods" columnName:@"[activity]" type:@"[text]"];
                [self AddColumnToTableIfNotExist:@"co_projectmain_mods" columnName:@"[controller]" type:@"[text]"];
                break;
            }
            case 70:{
                [self AddColumnToTableIfNotExist:@"co_projectmain_mods" columnName:@"[isshowtopright]" type:@"[integer]"];
                break;
            }
        }
    }
}

#pragma mark - 添加数据

/**
 批量添加项目模块
 
 @param array array
 */
-(void)addProjectMainModsWithArray:(NSMutableArray*)array {
	[[self getDbQuene:@"co_projectmain_mods" FunctionName:@"addProjectMainModsWithArray:(NSMutableArray*)array"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO co_projectmain_mods(cpmid,modid,name,appid,appname,codeguid,businessguid,modcolour,modlogo,weburl,html5,sort,isuseable,prid,appcode,protogenesis,activity,controller,isshowtopright)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
        for (CoProjectModsModel *cpmModel in array) {
            NSString *cpmid = cpmModel.cpmid;
            NSString *modid = cpmModel.modid;
            NSString *name = cpmModel.name;
            NSString *appid = cpmModel.appid;
            NSString *appname = cpmModel.appname;
            NSString *codeguid = cpmModel.codeguid;
            NSString *businessguid = cpmModel.businessguid;
            NSString *modcolour = cpmModel.modcolour;
            NSString *modlogo = cpmModel.modlogo;
            NSString *weburl = cpmModel.weburl;
            NSString *html5 = cpmModel.html5;
            NSNumber *sort = [NSNumber numberWithInteger:cpmModel.sort];
            NSNumber *isuseable = [NSNumber numberWithInteger:cpmModel.isuseable];
            NSString *prid = cpmModel.prid;
            NSString *appcode = cpmModel.appcode;
            NSNumber *protogenesis = [NSNumber numberWithInteger:cpmModel.protogenesis];
            NSString *activity = cpmModel.activity;
            NSString *controller = cpmModel.controller;
            NSNumber *isshowtopright = [NSNumber numberWithInteger:cpmModel.isshowtopright];
			
            isOK = [db executeUpdate:sql,cpmid,modid,name,appid,appname,codeguid,businessguid,modcolour,modlogo,weburl,html5,sort,isuseable,prid,appcode,protogenesis,activity,controller,isshowtopright];
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_projectmain_mods" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return ;
        }
    }];
}

#pragma mark - 删除数据

/**
 *  清空所有数据
 */
-(void)deleteAllData{
    [[self getDbQuene:@"co_projectmain_mods" FunctionName:@"deleteAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"DELETE FROM co_projectmain_mods"];
    }];
}

/**
 *  根据项目id删除指定项目下的模块
 */
-(void)deleteProjectMainModsWithPrid:(NSString*)prid {
    
    [[self getDbQuene:@"co_projectmain_mods" FunctionName:@"deleteProjectMainModsWithPrid:(NSString*)prid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_projectmain_mods where prid=?";
        isOK = [db executeUpdate:sql,prid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_projectmain_mods" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
    
    
}

#pragma mark - 修改数据


#pragma mark - 查询数据

/**
 查询当前项目下模块

 @param prid   当前项目id
 
 @return 模块数组
 */
-(NSMutableArray*)getProjectMainModsWithPrid:(NSString*)prid {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"co_projectmain_mods" FunctionName:@"getProjectMainModsWithPrid:(NSString*)prid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *sql = [NSString stringWithFormat:@"Select * From co_projectmain_mods Where prid = '%@' Order by sort asc",prid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    return result;
    
}

#pragma mark - Private Function

/**
 *  将FMResultSet转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return ImChatLogModel
 */
-(CoProjectModsModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    
    
    
    NSString *cpmid = [resultSet stringForColumn:@"cpmid"];
    NSString *modid = [resultSet stringForColumn:@"modid"];
    NSString *name = [resultSet stringForColumn:@"name"];
    NSString *appid = [resultSet stringForColumn:@"appid"];
    NSString *appname = [resultSet stringForColumn:@"appname"];
    NSString *codeguid = [resultSet stringForColumn:@"codeguid"];
    NSString *businessguid = [resultSet stringForColumn:@"businessguid"];
    NSString *modcolour = [resultSet stringForColumn:@"modcolour"];
    NSString *modlogo = [resultSet stringForColumn:@"modlogo"];
    NSString *weburl = [resultSet stringForColumn:@"weburl"];
    NSString *html5 = [resultSet stringForColumn:@"html5"];
    NSInteger sort = [resultSet intForColumn:@"sort"];
    NSInteger isuseable = [resultSet intForColumn:@"isuseable"];
    NSString *prid = [resultSet stringForColumn:@"prid"];
    NSString *appcode = [resultSet stringForColumn:@"appcode"];
    NSInteger protogenesis = [resultSet intForColumn:@"protogenesis"];
    NSString *activity = [resultSet stringForColumn:@"activity"];
    NSString *controller = [resultSet stringForColumn:@"controller"];
    NSInteger isshowtopright = [resultSet intForColumn:@"isshowtopright"];
    
    CoProjectModsModel *coproModsModel = [[CoProjectModsModel alloc]init];
    coproModsModel.cpmid = cpmid;
    coproModsModel.modid = modid;
    coproModsModel.html5 = html5;
    coproModsModel.name = name;
    coproModsModel.appid = appid;
    coproModsModel.appname = appname;
    coproModsModel.codeguid = codeguid;
    coproModsModel.businessguid = businessguid;
    coproModsModel.modcolour = modcolour;
    coproModsModel.modlogo = modlogo;
    coproModsModel.weburl = weburl;
    coproModsModel.html5 = html5;
    coproModsModel.sort = sort;
    coproModsModel.isuseable = isuseable;
    coproModsModel.prid = prid;
    coproModsModel.appcode = appcode;
    coproModsModel.protogenesis = protogenesis;
    coproModsModel.activity = activity;
    coproModsModel.controller = controller;
    coproModsModel.isshowtopright = isshowtopright;
    
    return coproModsModel;
}

@end
