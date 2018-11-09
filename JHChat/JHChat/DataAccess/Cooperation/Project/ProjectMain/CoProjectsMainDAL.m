//
//  CoProjectsMainDAL.m
//  LeadingCloud
//
//  Created by SY on 16/10/20.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CoProjectsMainDAL.h"
@implementation CoProjectsMainDAL

+(CoProjectsMainDAL *)shareInstance {
    static CoProjectsMainDAL *instance= nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[CoProjectsMainDAL alloc] init];
    }
    return instance;
}
#pragma mark - 表结构操作
-(void)creatProjectsMainTableIfNotExists {
    
    NSString *tableName = @"co_projectsmain";
    
    /* 判断是否创建了此表 */
    if (![super checkIsExistsTable:tableName]) {
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:@"Create Table If Not Exists %@("
                                         "[prid] [varchar](100) PRIMARY KEY NOT NULL,"
                                         "[prname] [varchar](100) NULL,"
                                         "[orgname] [varchar](100) NULL,"
                                         "[createdate] [date] NULL,"
                                         "[coverpic] [varchar](100) NULL,"
                                         "[pgid] [varchar](150) NULL,"
                                         "[istop] [integer] NULL);",
                                         tableName]];
    }
}
/**
 *  升级数据库
 */
-(void)updataCoProjectMainTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    
    for (int i = currentDbVersion; i<=systemDbVersion; i++) {
        switch (i) {
            case 16:
            {
                [self AddColumnToTableIfNotExist:@"co_projectsmain" columnName:@"[appcode]" type:@"[varchar](100)"];
                [self AddColumnToTableIfNotExist:@"co_projectsmain" columnName:@"[isadmin]" type:@"[integer]"];
                break;
            }
            case 47:
            {
                [self AddColumnToTableIfNotExist:@"co_projectsmain" columnName:@"[managername]" type:@"[text]"];
                [self AddColumnToTableIfNotExist:@"co_projectsmain" columnName:@"[managerid]" type:@"[varchar](100)"];
                break;
            }
            case 64:
            {
                [self AddColumnToTableIfNotExist:@"co_projectsmain" columnName:@"[showmode]" type:@"[integer]"];
                [self AddColumnToTableIfNotExist:@"co_projectsmain" columnName:@"[customopenjsondata]" type:@"[text]"];
                break;
            }
            case 70:
            {
                [self AddColumnToTableIfNotExist:@"co_projectsmain" columnName:@"[isimgroup]" type:@"[integer]"];
                break;
            }
        }
    }
}
#pragma mark - 添加数据

/**
 添加项目model

 @param array 项目数组
 */
-(void)addProjectsWithArray:(NSMutableArray*)array {
    [[self getDbQuene:@"co_projectsmain" FunctionName:@"addProjectsWithArray:(NSMutableArray*)array"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		
		NSString *sql = @"INSERT OR REPLACE INTO co_projectsmain(prid,prname,orgname,createdate,coverpic,pgid,istop,appcode,isadmin,managername,managerid,showmode,customopenjsondata,isimgroup) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        for (CoProjectsModel *prModel in array) {
            NSString *prid = prModel.prid;
            NSString *prname = prModel.prname;
            NSString *orgname = prModel.orgname;
            NSDate *createdate = prModel.createdate;
            NSString *coverpic = prModel.coverpic;
            NSString *pgid = prModel.pgid;
            NSNumber *istop = [NSNumber numberWithBool:prModel.istop];
            
            NSString *appcode = prModel.appcode;
            NSNumber *isadmin = [NSNumber numberWithBool:prModel.isadmin];
            
            NSString *managername = prModel.managername;
            NSString *managerid = prModel.managerid;
            
            NSNumber *showmode = [NSNumber numberWithInteger:prModel.showmode];
            NSString *customopenjsondata = prModel.customopenjsondata;
            NSNumber *isimgroup = [NSNumber numberWithInteger:prModel.isimgroup];
	
            isOK = [db executeUpdate:sql,prid,prname,orgname,createdate,coverpic,pgid,istop,appcode,isadmin,managername,managerid,showmode,customopenjsondata,isimgroup];
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_projectsmain" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return ;
        }
    }];
 }
#pragma mark - 删除数据

/**
 删除指定分组下的所有项目

 @param pgid 分组id
 */
-(void)deleteProjectsWithPgid:(NSString*)pgid {
    
	[[self getDbQuene:@"co_projectsmain" FunctionName:@"deleteProjectsWithPgid:(NSString*)pgid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_projectsmain where pgid=?";
        isOK = [db executeUpdate:sql,pgid];
        
        if (!isOK) {
            DDLogError(@"删除失败 - updateMsgId");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_projectsmain" Sql:sql Error:@"删除失败" Other:nil];

        }
    }];

    
}
#pragma mark - 修改数据

/**
 修改分组id

 @param pgid 分组id
 @param prid 项目主键
 */
-(void)updateProjectGroupWithNewPgid:(NSString*)pgid prid:(NSString*)prid {
    [[self getDbQuene:@"co_projectsmain" FunctionName:@"updateProjectGroupWithNewPgid:(NSString*)pgid prid:(NSString*)prid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *sql = @"Update co_projectsmain set pgid = ? Where prid = ?";
        isOK = [db executeUpdate:sql,pgid,prid];
        if (!isOK) {
            DDLogError(@"修改失败");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_projectsmain" Sql:sql Error:@"更新失败" Other:nil];

        }
    }];
    
    
}

/**
 项目置顶/取消置顶操作

 @param pgid  分组id
 @param istop 是否置顶
 @param prid  项目id
 */
-(void)updateProjectTopActionWithNewPgid:(NSString*)pgid istop:(NSInteger)istop prid:(NSString*)prid {
	[[self getDbQuene:@"co_projectsmain" FunctionName:@"updateProjectTopActionWithNewPgid:(NSString*)pgid istop:(NSInteger)istop prid:(NSString*)prid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        NSNumber *isTop = [NSNumber numberWithInteger:istop];
        
        NSString *sql = @"Update co_projectsmain set pgid = ? , istop = ? Where prid = ?";
        isOK = [db executeUpdate:sql,pgid,isTop,prid];
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_projectsmain" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"修改失败");
        }
    }];
    
    
}
#pragma mark - 查询数据

/**
 查询某分组下的项目

 @param pgid 分组id

 @return 项目model order by createdate desc
 */
-(NSMutableArray*)getProjectsWith:(NSString*)pgid laodCount:(NSInteger)count starCount:(NSInteger)starCount{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
      [[self getDbQuene:@"co_projectsmain" FunctionName:@"getProjectsWith:(NSString*)pgid laodCount:(NSInteger)count starCount:(NSInteger)starCount"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
          //Order by createdate asc
          NSString *sql = [NSString stringWithFormat:@"Select * From co_projectsmain Where pgid = '%@'  Order by createdate desc limit %ld,%ld ",pgid,starCount,count];
          
          FMResultSet *resultSet = [db executeQuery:sql];
          
          while ([resultSet next]) {
              
              [result addObject:[self convertResultSetToModel:resultSet]];
          }
          [resultSet close];
      }];
    return result;
}

/**
 查询某项目
 
 @param prid 项目id
 
 @return 项目model
 */
-(CoProjectsModel*)getProjectsWithByPrid:(NSString *)prid{
    __block CoProjectsModel *pModel ;
    
    [[self getDbQuene:@"co_projectsmain" FunctionName:@"getProjectsWithByPrid:(NSString *)prid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_projectsmain Where prid=%@ ",prid];
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            pModel=[self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    return pModel;
}

#pragma mark - Private Function
    
    /**
     *  将FMResultSet转为Model
     *
     *  @param resultSet FMResultSet
     *
     *  @return ImChatLogModel
     */
    
-(CoProjectsModel*)convertResultSetToModel:(FMResultSet *)resultSet {
    
    CoProjectsModel *prModel = [[CoProjectsModel alloc]init];
    prModel.prid = [resultSet stringForColumn:@"prid"];
    prModel.prname = [resultSet stringForColumn:@"prname"];
    prModel.orgname = [resultSet stringForColumn:@"orgname"];
    prModel.createdate = [resultSet dateForColumn:@"createdate"];
    prModel.coverpic = [resultSet stringForColumn:@"coverpic"];
    prModel.pgid = [resultSet stringForColumn:@"pgid"];
    prModel.istop = [resultSet intForColumn:@"istop"];
    
    prModel.appcode = [resultSet stringForColumn:@"appcode"];
    prModel.isadmin = [resultSet intForColumn:@"isadmin"];
    
    prModel.managername = [resultSet stringForColumn:@"managername"];
    prModel.managerid = [resultSet stringForColumn:@"managerid"];
    
    prModel.showmode = [resultSet intForColumn:@"showmode"];
    prModel.customopenjsondata = [resultSet stringForColumn:@"customopenjsondata"];
    
    prModel.isimgroup = [resultSet intForColumn:@"isimgroup"];
    
    return prModel;
}
@end
