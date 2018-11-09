//
//  ServerCirclesDAL.m
//  LeadingCloud
//
//  Created by wang on 17/3/29.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "ServerCirclesDAL.h"

@implementation ServerCirclesDAL




/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ServerCirclesDAL *)shareInstance{
    
    static ServerCirclesDAL *instance = nil;
    
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[ServerCirclesDAL alloc] init];
    }
    return instance;

}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createServerCirclesTableIfNotExists{
    
    NSString *tableName = @"servercircles";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2017-03-29日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[scid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[name] [varchar](500) NULL,"
                                         "[des] [text] NULL,"
                                         "[oid] [varchar](50) NULL,"
                                         "[resourcepoolid] [varchar](50) NULL,"
                                         "[status] [integer] NULL,"
                                         "[orgname] [varchar](300) NULL,"
                                         "[membercount] [integer] NULL,"
                                         "[config] [data] NULL,"
                                         "[sctid] [varchar](50) NULL,"
                                         "[logo] [varchar](50) NULL,"
                                         "[face] [varchar](50) NULL,"
                                         "[isjoin] [integer] NULL);",
                                         tableName]];
    }

}
/**
 *  升级数据库
 */
-(void)updateServerCirclesTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
  
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 52:{
                [self AddColumnToTableIfNotExist:@"servercircles" columnName:@"[extid]" type:@"[varchar](50)"];
                break;
            }
			case 67:{
				[self AddColumnToTableIfNotExist:@"servercircles" columnName:@"[appcodelist]" type:@"[data]"];
				[self AddColumnToTableIfNotExist:@"servercircles" columnName:@"[appcode]" type:@"[varchar](50)"];

				break;
			}
			case 69:{
				
				[self AddColumnToTableIfNotExist:@"servercircles" columnName:@"[logofile]" type:@"[varchar](50)"];
				
				break;
			}
			case 77:{
				
				[self AddColumnToTableIfNotExist:@"servercircles" columnName:@"[isfirstpage]" type:@"[integer]"];
				[self AddColumnToTableIfNotExist:@"servercircles" columnName:@"[firstlogo]" type:@"[varchar](50)"];

				break;
			}
				
        }
    }

	
}

#pragma mark - 添加数据

-(void)addDataWithAppArray:(NSMutableArray *)appArray{
    
    [[self getDbQuene:@"servercircles" FunctionName:@"addDataWithAppArray:(NSMutableArray *)appArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO servercircles(scid,name,des,oid,resourcepoolid,orgname,sctid,logo,face,status,membercount,isjoin,config,extid,appcode,appcodelist,logofile,isfirstpage,firstlogo)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
        for (int i = 0; i< appArray.count;  i++) {
            ServiceCirclesListItem *sclItem=[appArray objectAtIndex:i];
            
            NSString *scid=sclItem.scid;
            NSString *name=sclItem.name;
            NSString *des=sclItem.des;
            NSString *oid=sclItem.oid;
            NSString *resourcepoolid=sclItem.resourcepoolid;
            
            NSString *orgname=sclItem.orgname;
            NSString *sctid=sclItem.sctid;
            NSString *logo=sclItem.logo;
            NSString *face=sclItem.face;
            NSNumber *status=[NSNumber numberWithInteger:sclItem.status];
            
            NSNumber *membercount=[NSNumber numberWithInteger:sclItem.membercount];
            NSNumber *isjoin=[NSNumber numberWithBool:sclItem.isjoin];
            NSData *config =[NSData data];
            
            NSString *extid = sclItem.extid;
			NSString *logofile = sclItem.logofile;
			NSNumber *isfirstpage=[NSNumber numberWithBool:sclItem.isfirstpage];
			NSString *firstlogo = sclItem.firstlogo;


            if (sclItem.config) {
                config =[NSJSONSerialization dataWithJSONObject:sclItem.config options:NSJSONWritingPrettyPrinted error:nil];

            }
			NSString *appcode = sclItem.appcode;
			
			NSData *appcodelist = [NSData data];
			if (sclItem.appcodelist) {
    
				appcodelist =[NSJSONSerialization dataWithJSONObject:sclItem.appcodelist options:NSJSONWritingPrettyPrinted error:nil];

			}
			
            isOK = [db executeUpdate:sql,scid,name,des,oid,resourcepoolid,orgname,sctid,logo,face,status,membercount,isjoin,config,extid,appcode,appcodelist,logofile,isfirstpage,firstlogo];
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"servercircles" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];

}


/**
 *  搜索加入的服务圈
 */
- (NSMutableArray*)searchJoinSearverCircles:(NSString*)oid Search:(NSString*)search{
    
    NSMutableArray *result = [NSMutableArray array];
    
    
    [[self getDbQuene:@"servercircles" FunctionName:@"searchJoinSearverCircles:(NSString*)oid Search:(NSString*)search"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From servercircles Where isjoin=1 AND (name like '%%%@%%')",search];
            
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            ServiceCirclesListItem *sclItem = [self getModelFromFM:resultSet];
            
            [result addObject:sclItem];
        }
        [resultSet close];
    }];

    return result;
}
/**
 * 所有的服务圈
 */
- (NSMutableArray*)searchAllSearverCircles:(NSString*)oid Search:(NSString*)search{
	
	NSMutableArray *result = [NSMutableArray array];
	
	
	[[self getDbQuene:@"servercircles" FunctionName:@"searchAllSearverCircles:(NSString*)oid Search:(NSString*)search"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		NSString *sql=[NSString stringWithFormat:@"Select * From servercircles Where name like '%%%@%%'",search];
		
		FMResultSet *resultSet=[db executeQuery:sql];
		while ([resultSet next]) {
			
			ServiceCirclesListItem *sclItem = [self getModelFromFM:resultSet];
			
			[result addObject:sclItem];
		}
        [resultSet close];
	}];
	
	return result;
}

/**
 *  加入的服务圈
 */
- (NSMutableArray*)getJoinAllSearverCircles:(NSString*)oid{
	
    NSMutableArray *result = [NSMutableArray array];
    
    
    [[self getDbQuene:@"servercircles" FunctionName:@"getJoinAllSearverCircles:(NSString*)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From servercircles Where isjoin=1"];
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            ServiceCirclesListItem *sclItem = [self getModelFromFM:resultSet];
            
            [result addObject:sclItem];
        }
        [resultSet close];
    }];
    
    return result;
}

/**
 *  加入的服务圈
 */
- (NSMutableArray*)getRecommendAllSearverCircles:(NSString*)oid{
    
    NSMutableArray *result = [NSMutableArray array];
    
    
    [[self getDbQuene:@"servercircles"FunctionName:@"getRecommendAllSearverCircles:(NSString*)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From servercircles Where isjoin!=1"];
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            ServiceCirclesListItem *sclItem = [self getModelFromFM:resultSet];
            
            [result addObject:sclItem];
        }
        [resultSet close];
    }];
    
    return result;

}



#pragma mark 内部
// 数据库转模型
-(ServiceCirclesListItem*)getModelFromFM:(FMResultSet*)resultSet{
    
    NSString *scid = [resultSet stringForColumn:@"scid"];
    NSString *name = [resultSet stringForColumn:@"name"];
    NSString *des = [resultSet stringForColumn:@"des"];
    NSString *oid = [resultSet stringForColumn:@"oid"];
    NSString *resourcepoolid = [resultSet stringForColumn:@"resourcepoolid"];
    NSString *orgname = [resultSet stringForColumn:@"orgname"];
    NSString *sctid =[resultSet stringForColumn:@"sctid"];
    NSString *logo = [resultSet stringForColumn:@"logo"];
    NSString *face = [resultSet stringForColumn:@"face"];
    NSString *extid = [resultSet stringForColumn:@"extid"];
    NSData *config = [resultSet dataForColumn:@"config"];
    NSInteger status = [resultSet intForColumn:@"status"];
    NSInteger membercount = [resultSet intForColumn:@"membercount"];
    BOOL isjoin =[resultSet boolForColumn:@"isjoin"];
    
    NSString *appcode = [resultSet stringForColumn:@"appcode"];
	NSData *appcodelist = [resultSet dataForColumn:@"appcodelist"];
	
	NSString *logofile = [resultSet stringForColumn:@"logofile"];
	BOOL isfirstpage =[resultSet boolForColumn:@"isfirstpage"];
	NSString *firstlogo = [resultSet stringForColumn:@"firstlogo"];

	
    ServiceCirclesListItem *sclItem = [[ServiceCirclesListItem alloc] init];
    sclItem.scid = scid;
    sclItem.name = name;
    sclItem.des = des;
    sclItem.oid = oid;
    sclItem.resourcepoolid = resourcepoolid;
    sclItem.orgname = orgname;
    sclItem.sctid = sctid;
    sclItem.logo = logo;
    sclItem.face = face;
    sclItem.status = status;
    sclItem.membercount = membercount;
    sclItem.isjoin = isjoin;
    sclItem.extid = extid;
	sclItem.appcode = appcode;
	sclItem.logofile = logofile;
	sclItem.isfirstpage = isfirstpage;
	sclItem.firstlogo = firstlogo;
    if (!config) {
        config = [NSData data];
    }
    sclItem.config=[NSJSONSerialization JSONObjectWithData:config options:NSJSONReadingMutableContainers error:nil];
	
	if (!appcodelist) {
		appcodelist = [NSData data];
	}
	sclItem.appcodelist=[NSJSONSerialization JSONObjectWithData:appcodelist options:NSJSONReadingMutableContainers error:nil];

    return sclItem;
}


/**
 *  服务圈是否加入
 */
- (BOOL)isJoinSearverCircles:(NSString*)scid{
    
    __block BOOL isjoin = false;
  
    [[self getDbQuene:@"servercircles" FunctionName:@"isJoinSearverCircles:(NSString*)scid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select scid From servercircles Where scid=%@ AND isjoin=1",scid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
                
            isjoin=YES;
                
        }
        [resultSet close];
    }];
    
    
    return isjoin;
    
}

/**
 *  删除加入的服务圈
 */
- (void)deleJoinServerCircles:(NSString*)oid{
    
    [[self getDbQuene:@"servercircles" FunctionName:@"deleJoinServerCircles:(NSString*)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from servercircles Where isjoin=1";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"servercircles" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}

/**
 *  删除推荐的服务圈
 */
- (void)deleRecommendServerCircles:(NSString*)oid{
    
    [[self getDbQuene:@"servercircles"FunctionName:@"deleRecommendServerCircles:(NSString*)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from servercircles Where isjoin!=1";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"servercircles" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
    
}
@end
