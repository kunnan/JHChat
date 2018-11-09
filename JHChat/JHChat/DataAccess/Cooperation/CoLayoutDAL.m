//
//  CoLayoutDAL.m
//  LeadingCloud
//
//  Created by SY on 16/5/6.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CoLayoutDAL.h"
#import "CooLayoutModel.h"
#import "NSObject+JsonSerial.h"
#import "NSString+SerialToDic.h"
@implementation CoLayoutDAL
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoLayoutDAL *)shareInstance{
    static CoLayoutDAL *instance = nil;
    
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[CoLayoutDAL alloc] init];
    }
    return instance;
}
/**
 *  创建表
 */
-(void)createCoLayoutTableIfNotExists
{
    NSString *tableName = @"co_layout";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[cid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[layout] [text] NULL);",
                                         tableName]];
        
    }
}

/**
 *  升级数据库
 */
-(void)updateCoLayoutTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}

#pragma mark - 添加数据
-(void)addLayoutInfo:(CooLayoutModel*)layouModel {
    [[self getDbQuene:@"co_layout" FunctionName:@"addLayoutInfo:(CooLayoutModel*)layouModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *cid = layouModel.cid;
        NSString *layoutJson = [NSString string];
        layoutJson = [layoutJson dictionaryToJson:layouModel.layout];
        
        NSString *sql = @"INSERT OR REPLACE INTO co_layout(cid,layout)"
        "VALUES (?,?)";
        isOK = [db executeUpdate:sql,cid,layoutJson];
        if (!isOK) {
            DDLogError(@"插入失败");
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_layout" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
        
    }];
    
}
#pragma mark - 查询数据
-(CooLayoutModel*)selectLayoutInfo:(NSString*)cid {
    __block CooLayoutModel *cooLayoutModel=nil;
    [[self getDbQuene:@"co_layout" FunctionName:@"-(CooLayoutModel*)selectLayoutInfo:(NSString*)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select layout From co_layout where cid = %@ ",cid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            
            NSString *layout = [resultSet stringForColumn:@"layout"];
            
            cooLayoutModel = [[CooLayoutModel alloc] init];
            cooLayoutModel.cid = cid;
            // json转字典
           NSMutableDictionary *layoutDic = [[NSMutableDictionary alloc] initWithDictionary:[layout seriaToDic]];
            cooLayoutModel.layout = layoutDic;
            
        }
        [resultSet close];
    }];
    
    return cooLayoutModel;
}



@end
