//
//  ImMsgAppDAL.m
//  LeadingCloud
//
//  Created by gjh on 2018/10/8.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import "ImMsgAppDAL.h"

#define instanceColumns @"logo,appcode,state,msgiosconfig,msgandroidconfig,valid,appcolour,synthetiselogo,msgwebconfig,name,appid"

@implementation ImMsgAppDAL
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImMsgAppDAL *)shareInstance{
    static ImMsgAppDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[ImMsgAppDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createImMsgAppTableIfNotExists{
    NSString *tableName = @"im_msg_app";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[appid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[logo] [varchar](50) NULL,"
                                         "[state] [varchar](50) NULL,"
                                         "[msgiosconfig] [varchar](50) NULL,"
                                         "[msgandroidconfig] [varchar](50) NULL,"
                                         "[valid] [varchar](50) NULL,"
                                         "[appcolour] [varchar](50) NULL,"
                                         "[synthetiselogo] [varchar](50) NULL,"
                                         "[msgwebconfig] [varchar](50) NULL,"
                                         "[name] [varchar](50) NULL,"
                                         "[appcode] [varchar](50) NULL);",
                                         tableName]];
    }
}

/**
 *  升级数据库
 */
-(void)updateImMsgAppTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                //            case 90:{
                //                [self AddColumnToTableIfNotExist:@"im_group" columnName:@"[groupresource]" type:@"[text]"];
                //                break;
                //            }
        }
    }
}

#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithImMsgAppArray:(NSMutableArray *)imMsgAppArray{
    
    [[self getDbQuene:@"im_msg_app" FunctionName:@"addDataWithImMsgAppArray:(NSMutableArray *)imMsgAppArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        for (int i = 0; i< imMsgAppArray.count;  i++) {
            ImMsgAppModel *imMsgAppModel = [imMsgAppArray objectAtIndex:i];
            NSString *logo = imMsgAppModel.logo;
            NSString *name = imMsgAppModel.name;
            NSString *appid = imMsgAppModel.appid;
            NSString *state = imMsgAppModel.state;
            NSString *msgiosconfig = imMsgAppModel.msgiosconfig;
            NSString *msgandroidconfig = imMsgAppModel.msgandroidconfig;
            NSString *valid = imMsgAppModel.valid;
            NSString *appcolour = imMsgAppModel.appcolour;
            NSString *synthetiselogo = imMsgAppModel.synthetiselogo;
            NSString *msgwebconfig = imMsgAppModel.msgwebconfig;
            NSString *appcode = imMsgAppModel.appcode;
            
            NSString *sql = @"INSERT OR REPLACE INTO im_msg_app(logo,name,appid,state,msgiosconfig,msgandroidconfig,valid,appcolour,synthetiselogo,msgwebconfig,appcode)"
            "VALUES (?,?,?,?,?,?,?,?,?,?,?)";
            isOK = [db executeUpdate:sql,logo,name,appid,state,msgiosconfig,msgandroidconfig,valid,appcolour,synthetiselogo,msgwebconfig,appcode];
            if (!isOK) {
                DDLogError(@"插入失败");
                [[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_msg_app" Sql:sql Error:@"插入失败" Other:nil];
                
                break;
            }
        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
    
}

/**
 *  单个数据
 */
-(void)addImMsgAppModel:(ImMsgAppModel *)imMsgAppModel{
    
    [[self getDbQuene:@"im_msg_app" FunctionName:@"addImMsgAppModel:(ImMsgAppModel *)imMsgAppModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *logo = imMsgAppModel.logo;
        NSString *name = imMsgAppModel.name;
        NSString *appid = imMsgAppModel.appid;
        NSString *state = imMsgAppModel.state;
        NSString *msgiosconfig = imMsgAppModel.msgiosconfig;
        NSString *msgandroidconfig = imMsgAppModel.msgandroidconfig;
        NSString *valid = imMsgAppModel.valid;
        NSString *appcolour = imMsgAppModel.appcolour;
        NSString *synthetiselogo = imMsgAppModel.synthetiselogo;
        NSString *msgwebconfig = imMsgAppModel.msgwebconfig;
        NSString *appcode = imMsgAppModel.appcode;
        
        NSString *sql = @"INSERT OR REPLACE INTO im_msg_app(logo,name,appid,state,msgiosconfig,msgandroidconfig,valid,appcolour,synthetiselogo,msgwebconfig,appcode)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,logo,name,appid,state,msgiosconfig,msgandroidconfig,valid,appcolour,synthetiselogo,msgwebconfig,appcode];
        if (!isOK) {
            [[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_msg_app" Sql:sql Error:@"插入失败" Other:nil];
            
            DDLogError(@"插入失败");
        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
    
}

#pragma make - 获取
/**
 *  ImMsgAppModel
 *
 *  @param
 *
 *  @return ImMsgAppModel
 */
-(NSMutableArray<ImMsgAppModel *> *)getimMsgAppModelArr
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"im_msg_app" FunctionName:@"getimMsgAppModelArr"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"select %@ from im_msg_app",instanceColumns];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            [result addObject:[self convertResultSetToModel:resultSet]];
        }
        [resultSet close];
    }];
    
    return result;
}
/**
 *  根据name获取ImMsgAppModel
 *
 *  @param Name
 *
 *  @return ImMsgAppModel
 */
- (ImMsgAppModel *)getImMsgAppModelWithName:(NSString *)Name
{
    __block ImMsgAppModel *imMsgAppModel = nil;
    
    [[self getDbQuene:@"im_msg_app" FunctionName:@"getImMsgAppModelWithName:(NSString *)Name"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select %@ from im_msg_app Where name='%@'",instanceColumns, Name];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            imMsgAppModel = [self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return imMsgAppModel;
}

#pragma mark - 删除
/* 删除对应的数据 */
- (void)deleteImMsgAppModel {
    [[self getDbQuene:@"im_msg_app" FunctionName:@"deleteImMsgAppModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from im_msg_app";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
            [[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"im_msg_app" Sql:sql Error:@"删除失败" Other:nil];
            
            DDLogError(@"删除失败 - deleteImMsgAppModel");
        }
    }];
}
#pragma mark 将查询结果集转换为Model对象

/**
 *  将查询结果集转换为Model对象
 *  @param resultSet
 *  @return
 */
-(ImMsgAppModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    ImMsgAppModel *model=[[ImMsgAppModel alloc]init];
    model.logo=[resultSet stringForColumn:@"logo"];
    model.appcode=[resultSet stringForColumn:@"appcode"];
    model.state=[resultSet stringForColumn:@"state"];
    model.name=[resultSet stringForColumn:@"name"];
    model.msgiosconfig=[resultSet stringForColumn:@"msgiosconfig"];
    model.msgandroidconfig=[resultSet stringForColumn:@"msgandroidconfig"];
    model.appcolour=[resultSet stringForColumn:@"appcolour"];
    model.valid=[resultSet stringForColumn:@"valid"];
    model.synthetiselogo=[resultSet stringForColumn:@"synthetiselogo"];
    model.msgwebconfig=[resultSet stringForColumn:@"msgwebconfig"];
    model.appid=[resultSet stringForColumn:@"appid"];
    
    return model;
}
@end
