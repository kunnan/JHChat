//
//  PostCooperationTypeDAL.m
//  LeadingCloud
//
//  Created by wang on 16/8/2.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "PostCooperationTypeDAL.h"
@implementation PostCooperationTypeDAL


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostCooperationTypeDAL *)shareInstance{
    static PostCooperationTypeDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[PostCooperationTypeDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createPostCooperationTypeTableIfNotExists{
    
    NSString *tableName = @"post_coopeation_type";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-07-28日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[posttypeid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[posttypename] [varchar](50) NULL,"
                                         "[posttypecode] [varchar](50) NULL,"
                                         "[mobilelogo] [varchar](50) NULL,"
                                         "[logo] [varchar](50) NULL,"
                                         "[describe] [varchar](300) NULL,"
                                         "[appid] [varchar](50) NULL);",
                                         tableName]];
    }
}
//code_appcode
/**
 *  升级数据库
 */
-(void)updatePostCooperationTypeTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
            case 4:{
                [self AddColumnToTableIfNotExist:@"post_coopeation_type" columnName:@"[antwebapi]" type:@"[varchar](100)"];
                [self AddColumnToTableIfNotExist:@"post_coopeation_type" columnName:@"[trunjs]" type:@"[varchar](100)"];
                [self AddColumnToTableIfNotExist:@"post_coopeation_type" columnName:@"[trunmethod]" type:@"[varchar](100)"];
                [self AddColumnToTableIfNotExist:@"post_coopeation_type" columnName:@"[iostrun]" type:@"[text]"];


                break;
            }
            case 31:{
                [self AddColumnToTableIfNotExist:@"post_coopeation_type" columnName:@"[appcolor]" type:@"[varchar](50)"];
                [self AddColumnToTableIfNotExist:@"post_coopeation_type" columnName:@"[applogo]" type:@"[varchar](50)"];
                break;

            }
                
            case 50: {
                [self AddColumnToTableIfNotExist:@"post_coopeation_type" columnName:@"[appcode]" type:@"[varchar](50)"];

                break;

            }
		
			case 64: {
				[self AddColumnToTableIfNotExist:@"post_coopeation_type" columnName:@"[baselinkcode]" type:@"[varchar](50)"];

				break;
			}
        }
    }
}


/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)pArray{
    
    [self deleAllPostCoopeationType];
    
	[[self getDbQuene:@"post_coopeation_type" FunctionName:@"addDataWithArray:(NSMutableArray *)pArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO post_coopeation_type(posttypeid,posttypename,posttypecode,mobilelogo,logo,describe,appid,antwebapi,trunjs,trunmethod,iostrun,applogo,appcolor,appcode,baselinkcode)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
        for (int i = 0; i< pArray.count;  i++) {
            PostCooperationTypeModel *pModel = [pArray objectAtIndex:i];
            
            NSString *posttypeid = pModel.posttypeid;
            NSString *posttypename = pModel.posttypename;
            NSString *posttypecode = pModel.posttypecode;
            NSString *mobilelogo = pModel.mobilelogo;
            NSString *logo = pModel.logo;
            NSString *describe = pModel.describe;
            NSString *appid = pModel.appid;
            NSString *applogo = pModel.applogo;
            NSString *appcolor = pModel.appcolor;

            NSString *antwebapi = pModel.antwebapi;
            NSString *trunjs = pModel.trunjs;
            NSString *trunmethod = pModel.trunmethod;
            
            NSString *iostrun=pModel.iostrun;
            NSString *appcode=pModel.appcode;
			NSString *baselinkcode = pModel.baselinkcode;
			
            isOK = [db executeUpdate:sql,posttypeid,posttypename,posttypecode,mobilelogo,logo,describe,appid,antwebapi,trunjs,trunmethod,iostrun,applogo,appcolor,appcode,baselinkcode];
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post_coopeation_type" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
        
    }];

    
}


#pragma mark - 删除数据

-(void)deleAllPostCoopeationType{
    [[self getDbQuene:@"post_coopeation_type" FunctionName:@"deleAllPostCoopeationType"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from post_coopeation_type";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
            DDLogError(@"更新失败 - updateMsgId");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post_coopeation_type" Sql:sql Error:@"删除失败" Other:nil];

        }
    }];
    
}

/**
 *  得到手机展示图片
 *
 *  @param type 动态code
 *
 *  @return
 */
- (NSString*)getCooperationTypeImage:(NSString*)posttypecode AppCode:(NSString*)appcode{
    
    __block NSString *tempStr;
    [[self getDbQuene:@"post_coopeation_type" FunctionName:@"getCooperationTypeImage:(NSString*)posttypecode AppCode:(NSString*)appcode"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //  SELECT * FROM "post_template" WHERE tmcode =  'Cooperationpost';
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM post_coopeation_type WHERE LOWER(posttypecode)=? AND LOWER(appcode)=?"];
        FMResultSet *resultSet=[db executeQuery:sql,[posttypecode lowercaseString],[appcode lowercaseString]];
        while ([resultSet next]) {
            
            tempStr = [resultSet stringForColumn:@"applogo"];
            
        }
        [resultSet close];
    }];
    
    return tempStr;

}

/**
 *  得到手机展示颜色
 *
 *  @param type  动态code
 *
 *  @return
 */
- (NSString*)getCooperationTypeColor:(NSString*)posttypecode AppCode:(NSString*)appcode{
    
    __block NSString *tempStr;
    [[self getDbQuene:@"post_coopeation_type" FunctionName:@"getCooperationTypeColor:(NSString*)posttypecode AppCode:(NSString*)appcode"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //  SELECT * FROM "post_template" WHERE tmcode =  'Cooperationpost';
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM post_coopeation_type WHERE LOWER(posttypecode)=? AND LOWER(appcode)=?"];
        FMResultSet *resultSet=[db executeQuery:sql,[posttypecode lowercaseString],[appcode lowercaseString]];
        while ([resultSet next]) {
            
            tempStr = [resultSet stringForColumn:@"appcolor"];
            
        }
        [resultSet close];
    }];
    
    return tempStr;

}
/**
 *  根据动态code 得到模型
 *
 *  @param type 动态code
 *
 *  @return
 */
- (PostCooperationTypeModel*)getCooperationType:(NSString*)posttypecode AppCode:(NSString*)appcode{

    __block PostCooperationTypeModel *tempModel;
    [[self getDbQuene:@"post_coopeation_type" FunctionName:@"getCooperationType:(NSString*)posttypecode AppCode:(NSString*)appcode"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //  SELECT * FROM "post_template" WHERE tmcode =  'Cooperationpost';
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM post_coopeation_type WHERE LOWER(posttypecode)=? AND LOWER(appcode)=?"];
        FMResultSet *resultSet=[db executeQuery:sql,[posttypecode lowercaseString],[appcode lowercaseString]];
        while ([resultSet next]) {
            
            NSString *posttypeid = [resultSet stringForColumn:@"posttypeid"];
            NSString *posttypename = [resultSet stringForColumn:@"posttypename"];
            //NSString *posttypecode = [resultSet stringForColumn:@"posttypecode"];
            NSString *mobilelogo = [resultSet stringForColumn:@"mobilelogo"];
            NSString *logo = [resultSet stringForColumn:@"logo"];
            NSString *describe = [resultSet stringForColumn:@"describe"];
            NSString *appid = [resultSet stringForColumn:@"appid"];
            NSString *antwebapi = [resultSet stringForColumn:@"antwebapi"];
            NSString *trunjs = [resultSet stringForColumn:@"trunjs"];
            NSString *trunmethod = [resultSet stringForColumn:@"trunmethod"];
            NSString *iostrun = [resultSet stringForColumn:@"iostrun"];
            NSString *applogo = [resultSet stringForColumn:@"applogo"];
            NSString *appcolor = [resultSet stringForColumn:@"appcolor"];
			NSString *baselinkcode = [resultSet stringForColumn:@"baselinkcode"];
           // NSString *appcode = [resultSet stringForColumn:@"appcode"];

            tempModel = [[PostCooperationTypeModel alloc]init];
            tempModel.posttypeid = posttypeid;
            tempModel.posttypename = posttypename;
            tempModel.posttypecode = posttypecode;
            tempModel.mobilelogo = mobilelogo;
            tempModel.logo = logo;
            tempModel.describe = describe;
            tempModel.appid = appid;
            tempModel.antwebapi = antwebapi;
            tempModel.trunjs = trunjs;
            tempModel.trunmethod = trunmethod;
            tempModel.iostrun = iostrun;
            tempModel.applogo = applogo;
            tempModel.appcolor = appcolor;
            tempModel.appcode = appcode;
			tempModel.baselinkcode= baselinkcode;
			

        }
        [resultSet close];
    }];
    
    return tempModel;

}
@end
