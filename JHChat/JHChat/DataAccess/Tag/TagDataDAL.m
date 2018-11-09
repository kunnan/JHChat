//
//  TagDataDAL.m
//  LeadingCloud
//
//  Created by wang on 16/2/18.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "TagDataDAL.h"

@implementation TagDataDAL


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(TagDataDAL *)shareInstance{
    static TagDataDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[TagDataDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createTagDataTableIfNotExists
{
    NSString *tableName = @"tag_data";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[tdid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[taid] [varchar](50) NULL,"
                                         "[name] [varchar](50) NULL,"
                                         "[ttid] [varchar](50) NULL,"
                                         "[dataid] [varchar](50) NULL,"
                                         "[oid] [varchar](50) NULL,"
                                         "[uid] [varchar](50) NULL,"
                                         "[dataextend1] [varchar](50) NULL,"
                                         "[dataextend2] [varchar](50) NULL,"
                                         "[dataextend3] [varchar](50) NULL,"
                                         "[createdate] [date] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateTagDataTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}
#pragma mark - 添加数据

-(void)addDataWithTagDataArray:(NSMutableArray *)tagsArray;
{
    
    [[self getDbQuene:@"tag_data" FunctionName:@"addDataWithTagDataArray:(NSMutableArray *)tagsArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		
		NSString *sql = @"INSERT OR REPLACE INTO tag_data(tdid,taid,name,ttid,dataid,oid,uid,dataextend1,dataextend2,dataextend3,createdate)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?)";
		
        for (int i = 0; i< tagsArray.count;  i++) {
            TagDataModel *tagModel = [tagsArray objectAtIndex:i];
            
            NSString *tdid = tagModel.tdid;
            NSString *taid = tagModel.taid;
            NSString *name = tagModel.name;
            NSString *ttid = tagModel.ttid;
            NSString *dataid = tagModel.dataid;
            NSString *oid = tagModel.oid;
            NSString *uid = tagModel.uid;
            NSString *dataextend1 = tagModel.dataextend1;
            NSString *dataextend2 = tagModel.dataextend2;
            NSString *dataextend3 = tagModel.dataextend3;
            NSDate *createdate = tagModel.createdate;

            isOK = [db executeUpdate:sql,tdid,taid,name,ttid,dataid,oid,uid,dataextend1,dataextend2,dataextend3,createdate];
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"tag_data" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
        
    }];
    
}
-(void)addTagDataModel:(TagDataModel *)tagModel
{
    
    [[self getDbQuene:@"tag_data" FunctionName:@"addTagDataModel:(TagDataModel *)tagModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *tdid = tagModel.tdid;
        NSString *taid = tagModel.taid;
        NSString *name = tagModel.name;
        NSString *ttid = tagModel.ttid;
        NSString *dataid = tagModel.dataid;
        NSString *oid = tagModel.oid;
        NSString *uid = tagModel.uid;
        NSString *dataextend1 = tagModel.dataextend1;
        NSString *dataextend2 = tagModel.dataextend2;
        NSString *dataextend3 = tagModel.dataextend3;
        NSDate *createdate = tagModel.createdate;
        
        NSString *sql = @"INSERT OR REPLACE INTO tag_data(tdid,taid,name,ttid,dataid,oid,uid,dataextend1,dataextend2,dataextend3,createdate)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,tdid,taid,name,ttid,dataid,oid,uid,dataextend1,dataextend2,dataextend3,createdate];
        if (!isOK) {
			
            DDLogError(@"插入失败");
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"tag_data" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
    
}



#pragma mark - 删除数据

-(void)deleteTagid:(NSString *)tid{
    [[self getDbQuene:@"tag_data" FunctionName:@"deleteTagid:(NSString *)tid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from tag_data where tdid=?";
        isOK = [db executeUpdate:sql,tid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"tag_data" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
}
/**
 *  根据协作cid删除群组
 *
 *  @param
 */
-(void)deleteCooperationCid:(NSString *)cid{
    
    [[self getDbQuene:@"tag_data" FunctionName:@"deleteCooperationCid:(NSString *)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from tag_data where dataid=?";
        isOK = [db executeUpdate:sql,cid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"tag_data" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}
/**
 *  根据标签类型id删除数据
 *  @param ttId
 */
-(void)deleteByTagTypeId:(NSString *)ttId{
    [[self getDbQuene:@"tag_data" FunctionName:@"deleteByTagTypeId:(NSString *)ttId"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = NO;
        isOK = [db executeUpdate:@"DELETE FROM tag_data WHERE ttid=?",ttId];
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"tag_data" Sql:@"DELETE FROM tag_data WHERE ttid=?" Error:@"删除失败" Other:nil];

		}
    }];
}

/**
 *  删除表中字段【dataextend1】值为“dataExtend1Value”的所有数据
 *  @param dataExtend1Value 值
 */
-(void)deleteByDataExtend1Value:(NSString *)dataExtend1Value{
    [[self getDbQuene:@"tag_data" FunctionName:@"deleteByDataExtend1Value:(NSString *)dataExtend1Value"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
       BOOL isOK = NO;
       NSString *sqlString=@"DELETE FROM tag_data WHERE dataextend1=?";
        isOK = [db executeUpdate:sqlString,dataExtend1Value];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"tag_data" Sql:sqlString Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
}

/**
 *  删除表中字段【dataextend2】值为“dataExtend2Value”的数据
 *  @param dataExtend2Value 值
 */
-(void)deleteByDataExtend2Value:(NSString *)dataExtend2Value DataExterend1Value:(NSString *)dataExterend1Value{
    [[self getDbQuene:@"tag_data" FunctionName:@"deleteByDataExtend2Value:(NSString *)dataExtend2Value DataExterend1Value:(NSString *)dataExterend1Value"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = NO;
        NSString *sqlString=@"DELETE FROM tag_data WHERE dataextend2=? AND dataextend1=?";
        isOK = [db executeUpdate:sqlString,dataExtend2Value,dataExterend1Value];
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"tag_data" Sql:sqlString Error:@"删除失败" Other:nil];
			
			DDLogError(@"更新失败 - updateMsgId");
		}
    }];
}

#pragma mark - 修改数据



#pragma mark - 查询数据
-(NSMutableArray *)getCooDataWithCid:(NSString *)cid{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"tag_data" FunctionName:@"getCooDataWithCid:(NSString *)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From tag_data Where dataid=%@ ",cid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            TagDataModel *tagModel = [self convertResultSetToModel:resultSet];
            [result addObject:tagModel];
        }
        [resultSet close];
    }];
    
    return result;
}

/**
 *  根据标签id获取标签数据
 *  @param tagid
 *  @return
 */
//-(TagDataModel *)geTagDataByTagId:(NSString *)dataExtend1Value{
//    __block TagDataModel *model=nil;
//    [[self getDbQuene] inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        NSString *sqlString=@"SELECT * FROM tag_data WHERE dataextend1=?";
//        FMResultSet *resultSet=[db executeQuery:sqlString,dataExtend1Value];
//        if([resultSet next]){
//            model = [self convertResultSetToModel:resultSet];
//        }
//    }];
//    return model;
//    
//}
-(NSMutableArray *)getTagDataByTagId:(NSString *)dataExtend1Value{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"tag_data" FunctionName:@"getTagDataByTagId:(NSString *)dataExtend1Value"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlString=@"SELECT * FROM tag_data WHERE dataextend1=?";
        FMResultSet *resultSet=[db executeQuery:sqlString,dataExtend1Value];
        while ([resultSet next]) {
            TagDataModel *model = [self convertResultSetToModel:resultSet];
            [result addObject:model];
        }
        [resultSet close];
    }];
    
    return result;
}


#pragma mark - Private Function

/**
 *  将TagDataModel转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return OrgUserIntervateModel
 */
-(TagDataModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    
    TagDataModel *tagModel=[[TagDataModel alloc]init];
    
    tagModel.tdid = [resultSet stringForColumn:@"tdid"];
    tagModel.taid = [resultSet stringForColumn:@"taid"];
    tagModel.name = [resultSet stringForColumn:@"name"];
    tagModel.ttid = [resultSet stringForColumn:@"ttid"];
    tagModel.dataid = [resultSet stringForColumn:@"dataid"];
    tagModel.oid = [resultSet stringForColumn:@"oid"];
    tagModel.uid = [resultSet stringForColumn:@"uid"];
    tagModel.dataextend1 = [resultSet stringForColumn:@"dataextend1"];
    tagModel.dataextend2 = [resultSet stringForColumn:@"dataextend2"];
    tagModel.dataextend3 = [resultSet stringForColumn:@"dataextend3"];
    tagModel.createdate = [resultSet dateForColumn:@"createdate"];
    return tagModel;
}

@end
