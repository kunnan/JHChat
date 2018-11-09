//
//  PostTemplateDAL.m
//  LeadingCloud
//
//  Created by wang on 16/7/28.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "PostTemplateDAL.h"

@implementation PostTemplateDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostTemplateDAL *)shareInstance{
    static PostTemplateDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[PostTemplateDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createPostTemplateTableIfNotExists
{
    NSString *tableName = @"post_template";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-07-28日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[tmcode] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[tvid] [varchar](50) NULL,"
                                         "[version] [varchar](50) NULL,"
                                         "[template] [data] NULL);",
                                         tableName]];
    }
}

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)pArray{
    
    [[self getDbQuene:@"post_template" FunctionName:@"addDataWithArray:(NSMutableArray *)pArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO post_template(tmcode,tvid,version,template)"
		"VALUES (?,?,?,?)";
		
        for (int i = 0; i< pArray.count;  i++) {
            PostTemplateModel *pModel = [pArray objectAtIndex:i];
            
            NSString *tmcode = pModel.tmcode;
            NSString *tvid = pModel.tvid;
            NSString *version = pModel.version;
            if (![pModel.templateDic isKindOfClass:[NSDictionary class]]) {
                pModel.templateDic = [[NSDictionary alloc]init];
            }
            NSData *templateDic=[NSJSONSerialization dataWithJSONObject:pModel.templateDic options:NSJSONWritingPrettyPrinted error:nil];;
            
		
            isOK = [db executeUpdate:sql,tmcode,tvid,version,templateDic];
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post_template" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
        
    }];
    

}


#pragma mark - 删除数据
/**
 *  删除单条数据
 */
-(void)deleAllPostTemplate{
    [[self getDbQuene:@"post_template" FunctionName:@"deleAllPostTemplate"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from post_template";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post_template" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}

/**
 *  得到动态模板
 *
 *  @param ecode 更加动态code
 *
 *  @return
 */
- (NSDictionary*)getTemplateFromEcodle:(NSString*)ecode{
    
    __block NSDictionary *tempDic;
    [[self getDbQuene:@"post_template" FunctionName:@"getTemplateFromEcodle:(NSString*)ecode"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
      //  SELECT * FROM "post_template" WHERE tmcode =  'Cooperationpost';
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM post_template WHERE tmcode=?"];
        FMResultSet *resultSet=[db executeQuery:sql,ecode];
        while ([resultSet next]) {
            
            NSData *tempData = [resultSet dataForColumn:@"template"];
            
            tempDic =[NSJSONSerialization JSONObjectWithData:tempData options:NSJSONReadingMutableContainers error:nil];
        }
        [resultSet close];
    }];
    
    return tempDic;
}

@end

