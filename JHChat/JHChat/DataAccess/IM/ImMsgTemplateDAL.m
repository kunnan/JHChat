//
//  ImMsgTemplateDAL.m
//  LeadingCloud
//
//  Created by wchMac on 16/8/16.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  dfl
 Date：   2016-08-10
 Version: 1.0
 Description: 消息模板集合处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ImMsgTemplateDAL.h"
#import "AppDelegate.h"

#define instanceColumns @"mtid,templates,code,clickrefresh,type,templatedetailist,name,icon"

@implementation ImMsgTemplateDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImMsgTemplateDAL *)shareInstance{
    static ImMsgTemplateDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[ImMsgTemplateDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createImMsgTemplateTableIfNotExists{
    NSString *tableName = @"im_msgtemplate";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[mtid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[templates] [text] NULL,"
                                         "[code] [varchar](200) NULL,"
                                         "[clickrefresh] [integer] NULL,"
                                         "[type] [integer] NULL,"
                                         "[templatedetailist] [text] NULL,"
                                         "[name] [varchar](100) NULL,"
                                         "[icon] [text] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateImMsgTemplateTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {

    }
}

#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithImMsgTemplateArray:(NSMutableArray *)imMsgTemplate{
    
    [[self getDbQuene:@"im_msgtemplate" FunctionName:@"addDataWithImMsgTemplateArray:(NSMutableArray *)imMsgTemplate"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        for (int i = 0; i< imMsgTemplate.count;  i++) {
            ImMsgTemplateModel *model = [imMsgTemplate objectAtIndex:i];
            
            NSString *mtid = model.mtid;
            NSString *templates = model.templates;
            NSString *code = model.code;
            NSNumber *clickrefresh=[NSNumber numberWithInteger:model.clickrefresh];
            NSNumber *type=[NSNumber numberWithInteger:model.type];
            NSString *templatedetailist=model.templatedetailist;
            NSString *name = model.name;
            NSString *icon=model.icon;
            
            NSString *sql = @"INSERT OR REPLACE INTO im_msgtemplate(mtid,templates,code,clickrefresh,type,templatedetailist,name,icon)"
            "VALUES (?,?,?,?,?,?,?,?)";
            isOK = [db executeUpdate:sql,mtid,templates,code,clickrefresh,type,templatedetailist,name,icon];
            
            if (!isOK) {
                DDLogError(@"更新失败");
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_msgtemplate" Sql:sql Error:@"插入失败" Other:nil];

                break;
            }
        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.lzGlobalVariable.msgTemplateDic = nil;
}


#pragma mark - 删除数据
/**
 *  清空所有数据
 */
-(void)deleteAllData{
    [[self getDbQuene:@"im_msgtemplate" FunctionName:@"deleteAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"DELETE FROM im_msgtemplate"];
    }];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.lzGlobalVariable.msgTemplateDic = nil;
}


#pragma mark - 修改数据



#pragma mark - 查询数据

/**
 *  根据code获取对应的模板信息
 */
-(ImMsgTemplateModel *)getImMsgTemplateModelWithCode:(NSString *)code
{
    __block ImMsgTemplateModel *templateModel = nil;
    [[self getDbQuene:@"im_msgtemplate" FunctionName:@"getImMsgTemplateModelWithCode:(NSString *)code"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql= [NSString stringWithFormat:@"select %@ from im_msgtemplate Where code='%@'",instanceColumns,code];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            templateModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return templateModel;
}

/**
 *  获取所有的模板信息
 */
-(NSArray<ImMsgTemplateModel *> *)getAllImMsgTemplateModel {
    
    NSMutableArray<ImMsgTemplateModel *> *modelDataArr = [NSMutableArray array];
    [[self getDbQuene:@"im_msgtemplate" FunctionName:@"getAllImMsgTemplateModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql= [NSString stringWithFormat:@"select %@ from im_msgtemplate",instanceColumns];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            ImMsgTemplateModel *templateModel = [self convertResultSetToModel:resultSet];
            [modelDataArr addObject:templateModel];
        }
        [resultSet close];
    }];
    
    return modelDataArr;
}

#pragma mark - Private Function

/**
 *  将UserInfoModel转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return ImTemplateDetailModel
 */
-(ImMsgTemplateModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    
    ImMsgTemplateModel *imMsgTemplateModel=[[ImMsgTemplateModel alloc]init];
    
    imMsgTemplateModel.mtid=[resultSet stringForColumn:@"mtid"];
    imMsgTemplateModel.templates=[resultSet stringForColumn:@"templates"];
    imMsgTemplateModel.code=[resultSet stringForColumn:@"code"];
    imMsgTemplateModel.clickrefresh=[resultSet intForColumn:@"clickrefresh"];
    imMsgTemplateModel.type=[resultSet intForColumn:@"type"];
    imMsgTemplateModel.templatedetailist=[resultSet stringForColumn:@"templatedetailist"];;
    imMsgTemplateModel.name=[resultSet stringForColumn:@"name"];
    imMsgTemplateModel.icon=[resultSet stringForColumn:@"icon"];
    
    return imMsgTemplateModel;
}

@end
