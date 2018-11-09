//
//  CoProjectDAL.m
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 项目数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "CoProjectDAL.h"

@implementation CoProjectDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoProjectDAL *)shareInstance{
    static CoProjectDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[CoProjectDAL alloc] init];
    }
    return instance;
}

/**
 *  创建表
 */
-(void)createCoProjectTableIfNotExists
{
    NSString *tableName = @"co_project";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[prid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[state] [integer] NULL,"
                                         "[planbegindate] [date] NULL,"
                                         "[planenddate] [date] NULL,"
                                         "[coverpic] [varchar](200) NULL,"
                                         "[cid] [varchar](50) NULL,"
                                         "[name] [varchar](50) NULL,"
                                         "[isfavorites] [integer] NULL,"
                                         "[oid] [varchar](50) NULL,"
                                         "[des] [text] NULL,"
                                         "[resourceid] [varchar](50) NULL,"
                                         "[memberslength] [integer] NULL,"
                                         "[createdate] [date] NULL,"
                                         "[adminid] [varchar](50) NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateCoProjectTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
             
//            case 5:{
//                [self dropColumnToTableIfNotExist:@"co_project"columnName:@"prid"];
//                [self dropColumnToTableIfNotExist:@"co_project"columnName:@"prjcode"];
//                [self dropColumnToTableIfNotExist:@"co_project"columnName:@"dept"];
//                [self dropColumnToTableIfNotExist:@"co_project"columnName:@"prjbaseinfo"];
//                [self dropColumnToTableIfNotExist:@"co_project"columnName:@"prjprogress"];
//                [self dropColumnToTableIfNotExist:@"co_project"columnName:@"deptname"];
//                [self dropColumnToTableIfNotExist:@"co_project"columnName:@"enddate"];
//                [self dropColumnToTableIfNotExist:@"co_project"columnName:@"manageruserid"];
//                [self AddColumnToTableIfNotExist:@"co_project" columnName:@"prid" type:@"[varchar](50) PRIMARY KEY NOT"];
//                [self AddColumnToTableIfNotExist:@"co_project" columnName:@"cid" type:@"[varchar](50)"];
//                [self AddColumnToTableIfNotExist:@"co_project" columnName:@"name" type:@"[varchar](50)"];
//                [self AddColumnToTableIfNotExist:@"co_project" columnName:@"isfavorites" type:@"[integer]"];
//                [self AddColumnToTableIfNotExist:@"co_project" columnName:@"oid" type:@"[varchar](50)"];
//                [self AddColumnToTableIfNotExist:@"co_project" columnName:@"des" type:@"[text]"];
//                [self AddColumnToTableIfNotExist:@"co_project" columnName:@"resourceid" type:@"[varchar](50)"];
//                [self AddColumnToTableIfNotExist:@"co_project" columnName:@"memberslength" type:@"[integer]"];
//                [self AddColumnToTableIfNotExist:@"co_project" columnName:@"createdate" type:@"[date]"];
//                [self AddColumnToTableIfNotExist:@"co_project" columnName:@"adminid" type:@"[varchar](50)"];

//                break;
//            }
        }
    }
}

#pragma mark 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)projectArray{
    
	[[self getDbQuene:@"co_project" FunctionName:@"addDataWithArray:(NSMutableArray *)projectArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
    BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO co_project(cid,prid,createdate,name,oid,des,coverpic,resourceid,planbegindate,planenddate,adminid,isfavorites,memberslength,state)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
    for (CoProjectModel *pModel in projectArray) {

        NSString *cid = pModel.cid;
        NSString *prid = pModel.prid;
        NSDate *createdate=pModel.createdate;
        NSString *name=pModel.name;
        NSString *oid=pModel.oid;
        NSString *des=pModel.des;
        NSString *coverpic=pModel.coverpic;
        NSString *resourceid=pModel.resourceid;
        NSDate *planbegindate=pModel.planbegindate;
        NSDate *planenddate=pModel.planenddate;
        NSString *adminid =pModel.adminid;

        
        NSNumber *isfavorites=[NSNumber numberWithInteger:pModel.isfavorites];
        NSNumber *memberslength=[NSNumber numberWithInteger:pModel.memberslength];
        NSNumber *state=[NSNumber numberWithInteger:pModel.state];
		
        isOK = [db executeUpdate:sql,cid,prid,createdate,name,oid,des,coverpic,resourceid,planbegindate,planenddate,adminid,isfavorites,memberslength,state];
        
        if (!isOK) {
            DDLogError(@"插入失败");
        }
    }
    if (!isOK) {
        *rollback = YES;
		[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_project" Sql:sql Error:@"插入失败" Other:nil];

        return;
    }
    
    }];
    
}

/**
 *  添加单条数据
 */
-(void)addProjectModel:(CoProjectModel *)pModel{
    
    [[self getDbQuene:@"co_project" FunctionName:@"addProjectModel:(CoProjectModel *)pModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
            NSString *cid = pModel.cid;
            NSString *prid = pModel.prid;
            NSDate *createdate=pModel.createdate;
            NSString *name=pModel.name;
            NSString *oid=pModel.oid;
            NSString *des=pModel.des;
            NSString *coverpic=pModel.coverpic;
            NSString *resourceid=pModel.resourceid;
            NSDate *planbegindate=pModel.planbegindate;
            NSDate *planenddate=pModel.planenddate;
            NSString *adminid =pModel.adminid;
            
            
            NSNumber *isfavorites=[NSNumber numberWithInteger:pModel.isfavorites];
            NSNumber *memberslength=[NSNumber numberWithInteger:pModel.memberslength];
            NSNumber *state=[NSNumber numberWithInteger:pModel.state];
            
            NSString *sql = @"INSERT OR REPLACE INTO co_project(cid,prid,createdate,name,oid,des,coverpic,resourceid,planbegindate,planenddate,adminid,isfavorites,memberslength,state)"
            "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            isOK = [db executeUpdate:sql,cid,prid,createdate,name,oid,des,coverpic,resourceid,planbegindate,planenddate,adminid,isfavorites,memberslength,state];
            
            if (!isOK) {
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_project" Sql:sql Error:@"插入失败" Other:nil];

                DDLogError(@"插入失败");
            }
        
    }];
}


#pragma mark 查询
/**
 *  查询本独
 *
 *  @param oid       企业ID
 *  @param searchStr 搜索
 *  @param condition 条件
 *
 *  @return
 */
- (NSMutableArray*)getDataArrayOid:(NSString*)oid Search:(NSString*)searchStr Condition:(NSInteger)condition{
    
    NSMutableArray *result = [NSMutableArray array];
    
    [[self getDbQuene:@"co_project" FunctionName:@"getDataArrayOid:(NSString*)oid Search:(NSString*)searchStr Condition:(NSInteger)condition"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql;
        
        if (searchStr && [searchStr length]!=0) {
            sql=[NSString stringWithFormat:@"Select cid,prid,createdate,name,oid,des,coverpic,resourceid,planbegindate,planenddate,adminid,isfavorites,memberslength,state"" From co_project Where oid=%@ AND state=%@ AND name like '%%%@%%' Order by createdate desc",oid,[NSNumber numberWithInteger:condition],searchStr];
        }else{
            sql=[NSString stringWithFormat:@"Select cid,prid,createdate,name,oid,des,coverpic,resourceid,planbegindate,planenddate,adminid,isfavorites,memberslength,state ""From co_project Where oid=%@ AND state=%@  Order by createdate desc",oid,[NSNumber numberWithInteger:condition]];
        }
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            CoProjectModel *pModel=[self getModelFromFM:resultSet];
            [result addObject:pModel];
        }
        [resultSet close];
    }];

    return result;
    
}

/** 
 *  得到项目详情
 *
 *  @param pid 项目ID
 *
 *  @return
 */
- (CoProjectModel*)getProjectModelPid:(NSString*)pid{
    
    __block CoProjectModel *pModel ;
    
    [[self getDbQuene:@"co_project" FunctionName:@"(CoProjectModel*)getProjectModelPid:(NSString*)pid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select cid,prid,createdate,name,oid,des,coverpic,resourceid,planbegindate,planenddate,adminid,isfavorites,memberslength,state"" From co_project Where prid=%@ ",pid];
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            pModel=[self getModelFromFM:resultSet];
        }
        [resultSet close];
    }];
    return pModel;

}

#pragma mark 删除

/**
 *  删除单条项目
 *
 *  @param pid 项目ID
 */
- (void)delsingleProjectPid:(NSString*)pid{
    
    [[self getDbQuene:@"co_project" FunctionName:@"delsingleProjectPid:(NSString*)pid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_project where prid=?";
        isOK = [db executeUpdate:sql,pid];
        
        if (!isOK) {
            DDLogError(@"更新失败 - updateMsgId");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_project" Sql:sql Error:@"删除失败" Other:nil];

        }
        NSString *sql2=@"delete from co_member where cid=?";
        [db executeUpdate:sql2,pid];
    }];

}

/**
 *  删除当前企业下所有项目
 *
 *  @param oid 企业ID
 */
- (void)delAllProjectionOid:(NSString*)oid{
    [[self getDbQuene:@"co_project" FunctionName:@"delAllProjectionOid:(NSString*)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_project where oid=?";
        isOK = [db executeUpdate:sql,oid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_project" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
}

#pragma mark 更新数据
/**
 *  更新项目名称
 *
 *  @param name 名称
 *  @param pid  项目ID
 */
- (void)upDataProjectName:(NSString*)name Pid:(NSString*)pid{
    
    [[self getDbQuene:@"co_project" FunctionName:@"upDataProjectName:(NSString*)name Pid:(NSString*)pid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_project set name=? Where prid=?";
        isOK = [db executeUpdate:sql,name,pid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_project" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}
/**
 *  修改项目描述
 *
 *  @param des 项目描述
 *  @param pid 项目ID
 */
- (void)upDataProjectDes:(NSString*)des Pid:(NSString*)pid{
    
    [[self getDbQuene:@"co_project" FunctionName:@"upDataProjectDes:(NSString*)des Pid:(NSString*)pid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_project set des=? Where prid=?";
        isOK = [db executeUpdate:sql,des,pid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_project" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}

/**
 *  修改项目开始时间
 *
 *  @param startTime 开始时间
 *  @param pid       项目ID
 */
- (void)upDataProjectStartTime:(NSString*)startTime Pid:(NSString*)pid{
    
    [[self getDbQuene:@"co_project" FunctionName:@"upDataProjectStartTime:(NSString*)startTime Pid:(NSString*)pid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_project set planbegindate=? Where prid=?";
        isOK = [db executeUpdate:sql,[LZFormat StringCooperationDate:startTime],pid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_project" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}

/**
 *  修改项目结束时间
 *
 *  @param endTime   结束时间
 *  @param pid       项目ID
 */
- (void)upDataProjectEndTime:(NSString*)endTime Pid:(NSString*)pid{
    [[self getDbQuene:@"co_project" FunctionName:@"upDataProjectEndTime:(NSString*)endTime Pid:(NSString*)pid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_project set planenddate=? Where prid=?";
        isOK = [db executeUpdate:sql,[LZFormat StringCooperationDate:endTime],pid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_project" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}

/**
 *  修改项目当前转态
 *
 *  @param state 项目状态
 *  @param pid   项目ID
 */
- (void)upDataProjectState:(NSInteger)state Pid:(NSString*)pid{
    
    [[self getDbQuene:@"co_project" FunctionName:@"upDataProjectState:(NSInteger)state Pid:(NSString*)pid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_project set state=? Where prid=?";
        isOK = [db executeUpdate:sql,[NSNumber numberWithInteger:state],pid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_project" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}

/**
 *  修改项目企业ID
 *
 *  @param state 项目状态
 *  @param pid   项目ID
 */
- (void)upDataProjectOid:(NSString*)oid Pid:(NSString*)pid{
    
    [[self getDbQuene:@"co_project" FunctionName:@"upDataProjectOid:(NSString*)oid Pid:(NSString*)pid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_project set oid=? Where prid=?";
        isOK = [db executeUpdate:sql,oid,pid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_project" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
    

}

#pragma mark 内部
// 数据库转模型
-(CoProjectModel*)getModelFromFM:(FMResultSet*)resultSet{
    
    NSString *cid = [resultSet stringForColumn:@"cid"];
    NSString *prid = [resultSet stringForColumn:@"prid"];
    NSDate *createdate=[resultSet dateForColumn:@"createdate"];
    NSString *name=[resultSet stringForColumn:@"name"];
    NSString *coverpic=[resultSet stringForColumn:@"coverpic"];
    NSString *adminid=[resultSet stringForColumn:@"adminid"];
    NSString *des=[resultSet stringForColumn:@"des"];
    NSString *resourceid=[resultSet stringForColumn:@"resourceid"];
    NSString *oid=[resultSet stringForColumn:@"oid"];
    NSDate *planbegindate=[resultSet dateForColumn:@"planbegindate"];
    NSDate *planenddate=[resultSet dateForColumn:@"planenddate"];
    NSInteger state=[resultSet intForColumn:@"state"];
    NSInteger isfavorites=[resultSet intForColumn:@"isfavorites"];
    NSInteger memberslength=[resultSet intForColumn:@"memberslength"];
    
    CoProjectModel *pModel = [[CoProjectModel alloc] init];
    pModel.cid = cid;
    pModel.prid=prid;
    pModel.createdate=createdate;
    pModel.name=name;
    pModel.state=state;
    pModel.coverpic=coverpic;
    pModel.adminid=adminid;
    pModel.des=des;
    pModel.isfavorites=isfavorites;
    pModel.planbegindate=planbegindate;
    pModel.planenddate=planenddate;
    pModel.resourceid=resourceid;
    pModel.memberslength=memberslength;
    pModel.oid=oid;

    return pModel;
}
@end
