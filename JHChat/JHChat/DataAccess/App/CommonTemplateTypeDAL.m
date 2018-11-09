//
//  CommonTemplateTypeDAL.m
//  LeadingCloud
//
//  Created by wang on 2017/7/31.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "CommonTemplateTypeDAL.h"

@implementation CommonTemplateTypeDAL


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CommonTemplateTypeDAL *)shareInstance{
	
	static CommonTemplateTypeDAL *instance = nil;
	
	if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
		instance = [[CommonTemplateTypeDAL alloc] init];
	}
	return instance;

}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createCommonTemplateTypeTableIfNotExists{
	
	NSString *tableName = @"common_template_type";
	
	/* 判断是否已经创建了此表 */
	if(![super checkIsExistsTable:tableName]){
		/*****************************************************************************
		 自2017-07-31日起，此sql语句不允许再进行修改,若需要修改表结构，
		 使用 updateCommonTemplateTypeTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
		 *****************************************************************************/
		[[self getDbBase] executeUpdate:[NSString stringWithFormat:
										 @"Create Table If Not Exists %@("
										 "[blcid] [varchar](50) PRIMARY KEY NOT NULL,"
										 "[appcode] [varchar](50) NULL,"
										 "[aliasname] [varchar](500) NULL,"
										 "[code] [varchar](50) NULL,"
										 "[config] [text] NULL,"
										 "[name] [varchar](100) NULL);",
										 tableName]];
	}

}
/**
 *  升级数据库
 */
-(void)updateCommonTemplateTypeTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
	
}
#pragma mark - 添加数据


/**
 *  插入单条数据
 *
 *  @param model AppModel
 */
-(void)addCommonTemplateTypeModel:(CommonTemplateTypeModel *)model{
	
	[[self getDbQuene:@"common_template_type" FunctionName:@"addCommonTemplateTypeModel:(CommonTemplateTypeModel *)model"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = YES;
		
			NSString *blcid = model.blcid;
			NSString *appcode = model.appcode;
			NSString *aliasname = model.aliasname;
			NSString *code = model.code;
			NSString *name = model.name;
			NSString *config = model.config;
		
			
			NSString *sql = @"INSERT OR REPLACE INTO common_template_type(blcid,appcode,aliasname,code,name,config)"
			"VALUES (?,?,?,?,?,?)";
			isOK = [db executeUpdate:sql,blcid,appcode,aliasname,code,name,config];
			
			if (!isOK) {
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"common_template_type" Sql:sql Error:@"插入失败" Other:nil];
				DDLogError(@"插入失败");
			}
		
	}];

}

#pragma mark - 删除数据

/**
 *  清空所有数据
 */
-(void)deleteAllData{
	[[self getDbQuene:@"common_template_type" FunctionName:@"deleteAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
	
		BOOL isOK = NO;
		
		isOK = [db executeUpdate:@"DELETE FROM common_template_type"];;
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"common_template_type" Sql:@"DELETE FROM common_template_type" Error:@"删除失败" Other:nil];
			
			DDLogError(@"删除失败 - updateMsgId");
		}
	}];

}

/**
 *  得到模型
 *
 *
 *  @return
 */
- (CommonTemplateTypeModel*)getCommonTemplateTypeModelCode:(NSString*)code AppCode:(NSString*)appcode{
	
	__block CommonTemplateTypeModel *tempModel;
	[[self getDbQuene:@"common_template_type" FunctionName:@"getCommonTemplateTypeModelCode:(NSString*)code AppCode:(NSString*)appcode"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		//  SELECT * FROM "post_template" WHERE tmcode =  'Cooperationpost';
		NSString *sql=[NSString stringWithFormat:@"SELECT * FROM common_template_type WHERE LOWER(code)=? AND LOWER(appcode)=?"];
		FMResultSet *resultSet=[db executeQuery:sql,[code lowercaseString],[appcode lowercaseString]];
		while ([resultSet next]) {
			

			NSString *blcid = [resultSet stringForColumn:@"blcid"];
			NSString *appcode = [resultSet stringForColumn:@"appcode"];
			NSString *aliasname = [resultSet stringForColumn:@"aliasname"];
			NSString *code = [resultSet stringForColumn:@"code"];
			NSString *config = [resultSet stringForColumn:@"config"];
			NSString *name = [resultSet stringForColumn:@"name"];

			tempModel = [[CommonTemplateTypeModel alloc]init];
			tempModel.blcid = blcid;
			tempModel.appcode = appcode;
			tempModel.aliasname = aliasname;
			tempModel.code = code;
			tempModel.config = config;
			tempModel.name = name;
		}
        [resultSet close];
	}];
	
	return tempModel;

	
}

@end
