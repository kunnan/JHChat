//
//  PostPromptDAL.m
//  LeadingCloud
//
//  Created by wang on 16/3/9.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "PostPromptDAL.h"

@implementation PostPromptDAL


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostPromptDAL *)shareInstance{
    static PostPromptDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[PostPromptDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createPostPromptTableIfNotExists
{
    NSString *tableName = @"post_prompt";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[pcid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[cueorgid] [varchar](50) NULL,"
                                         "[cueuid] [varchar](50) NULL,"
                                         "[cuename] [varchar](300) NULL,"
                                         "[cuehtml] [varchar](300) NULL,"
                                         "[creatdate] [date] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updatePostPromptTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}
#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)pArray{
    
    
	[[self getDbQuene:@"post_prompt" FunctionName:@"addDataWithArray:(NSMutableArray *)pArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO post_prompt(pcid,cueorgid,cuename,cuehtml,creatdate,cueuid)"
		"VALUES (?,?,?,?,?,?)";
		
        for (int i = 0; i< pArray.count;  i++) {
            PostPromptModel *pModel = [pArray objectAtIndex:i];
            
            NSString *pcid = pModel.pcid;
            NSString *cueorgid = pModel.cueorgid;
            NSString *cuename = pModel.cuename;
            NSString *cuehtml = pModel.cuehtml;
            NSString *cueuid=pModel.cueuid;
            NSDate *creatdate = pModel.createdate;
			
            isOK = [db executeUpdate:sql,pcid,cueorgid,cuename,cuehtml,creatdate,cueuid];
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post_prompt" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
        
    }];

}

/**
 *  添加单条数据
 */
-(void)addPromptModel:(PostPromptModel *)pModel{
	[[self getDbQuene:@"post_prompt" FunctionName:@"addPromptModel:(PostPromptModel *)pModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
            NSString *pcid = pModel.pcid;
            NSString *cueorgid = pModel.cueorgid;
            NSString *cuename = pModel.cuename;
            NSString *cuehtml = pModel.cuehtml;
            NSDate *creatdate = pModel.createdate;
            NSString *cueuid=pModel.cueuid;
            NSString *sql = @"INSERT OR REPLACE INTO post_prompt(pcid,cueorgid,cuename,cuehtml,creatdate,cueuid)"
            "VALUES (?,?,?,?,?,?)";
            isOK = [db executeUpdate:sql,pcid,cueorgid,cuename,cuehtml,creatdate,cueuid];
            
        if (!isOK) {
                DDLogError(@"插入失败");
            }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post_prompt" Sql:sql Error:@"插入失败" Other:nil];
            *rollback = YES;
            return;
        }
        
    }];

}
#pragma mark - 删除数据

/**
 *  根据id删除常用语
 *
 *  @param
 */
-(void)deletePromptid:(NSString *)pcid{
    
	[[self getDbQuene:@"post_prompt" FunctionName:@"deletePromptid:(NSString *)pcid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from post_prompt where pcid=?";
        isOK = [db executeUpdate:sql,pcid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post_prompt" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
    

}
/**
 *  根据id删除常用语
 *
 *  @param
 */

-(void)deletePrompt{
    
	[[self getDbQuene:@"post_prompt" FunctionName:@"deletePrompt"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from post_prompt";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post_prompt" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
    
    
}

/**
    得到常用语
 *  @param oid      组织ID
 
 */
-(NSMutableArray*)getMyPrompt{

    NSMutableArray *result = [[NSMutableArray alloc] init];
    
	[[self getDbQuene:@"post_prompt" FunctionName:@"getMyPrompt"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select pcid,cueorgid,cuename,cuehtml,creatdate,cueuid From post_prompt"];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            
            NSString *pcid = [resultSet stringForColumn:@"pcid"];
            NSString *cueorgid = [resultSet stringForColumn:@"cueorgid"];
            NSString *cuename = [resultSet stringForColumn:@"cuename"];
            NSString *cuehtml = [resultSet stringForColumn:@"cuehtml"];
            NSDate *creatdate = [resultSet dateForColumn:@"creatdate"];
            NSString *cueuid  =[resultSet stringForColumn:@"cueuid"];
            PostPromptModel *pModel = [[PostPromptModel alloc] init];
            pModel.pcid = pcid;
            pModel.cueorgid = cueorgid;
            pModel.cuename = cuename;
            pModel.cuehtml  = cuehtml;
            pModel.createdate = creatdate;
            pModel.cueuid=cueuid;
            [result addObject:pModel];
        }
        [resultSet close];
    }];
    
    return result;
    
}
#pragma mark - 更新数据
/**
 *  更新常用语名称
 *
 *  @param name 名字
 *  @param pcid 常用语id
 */
- (void)updataPromptName:(NSString*)name Pcid:(NSString*)pcid{
    
	[[self getDbQuene:@"post_prompt" FunctionName:@"updataPromptName:(NSString*)name Pcid:(NSString*)pcid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update post_prompt set name=? Where pcid=?";
        isOK = [db executeUpdate:sql,name,pcid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post_prompt" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
        
    } ];

}

@end
