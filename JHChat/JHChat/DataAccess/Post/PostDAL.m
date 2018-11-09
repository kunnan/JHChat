//
//  PostDAL.m
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 动态信息数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import "PostDAL.h"
#import "TagDataModel.h"
#import "PostFileModel.h"
#import "PostZanModel.h"
@implementation PostDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostDAL *)shareInstance{
    static PostDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[PostDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createPostTableIfNotExists
{
    NSString *tableName = @"post";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[pid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[contentobjid] [varchar](50) NULL,"
                                         "[oid] [varchar](50) NULL,"
                                         "[releaseuser] [varchar](50) NULL,"
                                         "[releaseusername] [varchar](50) NULL,"
                                         "[releaseuserface] [varchar](50) NULL,"
                                         "[content] [varchar](500) NULL,"
                                         "[rangetag] [varchar](50) NULL,"
                                         "[rangetype] [varchar](50) NULL,"
                                         "[rangename] [varchar](200) NULL,"
                                         "[msgtype] [integer] NULL,"
                                         "[directrelateduser] [varchar](50) NULL,"
                                         "[directrelateduserface] [varchar](50) NULL,"
                                         "[directrelatedusername] [varchar](200) NULL,"
                                         "[rangeurl] [varchar](100) NULL,"
                                         "[rangevalue] [varchar](100) NULL,"
                                         "[relatedpid] [varchar](50) NULL,"
                                         "[posttemplatedatadic] [data] NULL,"
                                         "[postfavorite] [data] NULL,"
                                         "[posttemplateid] [varchar](50) NULL,"
                                         "[postfilesid] [varchar](50) NULL,"
                                         "[postfilesidcomment] [varchar](200) NULL,"
                                         "[postfilestype] [varchar](50) NULL,"
                                         "[postresourcetype] [integer] NULL,"
                                         "[postdelperminssions] [integer] NULL,"
                                         "[latitude] [varchar](50) NULL,"
                                         "[longitude] [varchar](50) NULL,"
                                         "[reference] [varchar](50) NULL,"
                                         "[releasedate] [date] NULL,"
                                         "[address] [varchar](50) NULL,"
                                         "[postversion] [integer] NULL,"
                                         "[appcode] [varchar](50) NULL,"
                                         "[relevanceappcode] [varchar](50) NULL,"
                                         "[relevanceid] [varchar](50) NULL,"
                                         "[posttemplateversion] [varchar](50) NULL,"
                                         "[posttemplatetype] [integer] NULL,"
                                         "[posttypecode] [varchar](50) NULL,"
                                         "[appcodedataid] [varchar](50) NULL,"
                                         "[favoritetitle] [varchar](300) NULL,"
                                         "[isfiles] [integer] NULL,"
                                         "[posttemplatetypes] [varchar](50) NULL,"
                                         "[orgid] [varchar](50) NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updatePostTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
//            case 7:{
//                [self AddColumnToTableIfNotExist:@"post" columnName:@"address" type:@"[varchar](50)"];
//                break;
//            }
//                
//            case 12:{
//                
//                [self AddColumnToTableIfNotExist:@"post" columnName:@"postversion" type:@"[integer]"];
//                break;
//            }
//              
//            case 24:{
//                
//                [self AddColumnToTableIfNotExist:@"post" columnName:@"appcode" type:@"[varchar](50)"];
//                [self AddColumnToTableIfNotExist:@"post" columnName:@"relevanceappcode" type:@"[varchar](50)"];
//                [self AddColumnToTableIfNotExist:@"post" columnName:@"relevanceid" type:@"[varchar](50)"];
//                [self AddColumnToTableIfNotExist:@"post" columnName:@"posttemplateversion" type:@"[varchar](50)"];
//                [self AddColumnToTableIfNotExist:@"post" columnName:@"posttemplatetype" type:@"[integer]"];
//                [self AddColumnToTableIfNotExist:@"post" columnName:@"posttypecode" type:@"[varchar](50)"];
//                [self AddColumnToTableIfNotExist:@"post" columnName:@"appcodedataid" type:@"[varchar](50)"];
//                [self AddColumnToTableIfNotExist:@"post" columnName:@"favoritetitle" type:@"[varchar](300)"];
//                [self AddColumnToTableIfNotExist:@"post" columnName:@"isfiles" type:@"[integer]"];
//                [self AddColumnToTableIfNotExist:@"post" columnName:@"posttemplatetypes" type:@"[varchar](50)"];
//
//
//                break;
//            }
//                
//            case 28:{
//                [self AddColumnToTableIfNotExist:@"post" columnName:@"orgid" type:@"[varchar](50)"];
//            }
            case 28:{
                
                  [self AddColumnToTableIfNotExist:@"post" columnName:@"[expanddata]" type:@"[text]"];
                  [self AddColumnToTableIfNotExist:@"post" columnName:@"[expanddatadic]" type:@"[data]"];
                
                  break;
                }

        }
    }
}
#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)pArray{
    
    [[self getDbQuene:@"post" FunctionName:@"addDataWithArray:(NSMutableArray *)pArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO post(pid,contentobjid,releaseusername,releaseuserface,content,rangetag,rangetype,rangename,msgtype,directrelateduser,directrelateduserface,directrelatedusername,rangevalue,relatedpid,releasedate,releaseuser,rangeurl,oid,posttemplateid,posttemplatedatadic,postfavorite,postfilesid,postfilesidcomment,postfilestype,postresourcetype,postdelperminssions,latitude,longitude,reference,address,postversion,appcode,relevanceappcode,relevanceid,posttemplateversion,posttypecode,appcodedataid,favoritetitle,isfiles,posttemplatetype,posttemplatetypes,orgid,expanddata,expanddatadic)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
        for (int i = 0; i< pArray.count;  i++) {
            PostModel *pModel = [pArray objectAtIndex:i];

            NSString *pid = pModel.pid;
            NSString *contentobjid = pModel.contentobjid;
            NSString *releaseuser=pModel.releaseuser;
            NSString *releaseusername = pModel.releaseusername;
            NSString *releaseuserface = pModel.releaseuserface;
            NSString *content=pModel.content;
            NSString *rangetag=pModel.rangetag;
            NSString *rangetype=pModel.rangetype;
            NSString *rangename=pModel.rangename;
            NSString *oid=pModel.oid;
            NSNumber *msgtype=[NSNumber numberWithInteger:pModel.msgtype];
            NSString *directrelateduser=pModel.directrelateduser;
            NSString *directrelateduserface=pModel.directrelateduserface;
            NSString *directrelatedusername=pModel.directrelatedusername;
            NSString *rangeurl=pModel.rangeurl;
            NSString *rangevalue=pModel.rangevalue;
            NSString *relatedpid=pModel.relatedpid;
            NSDate *releasedate = pModel.releasedate;
            NSString *posttemplateid=pModel.posttemplateid;
            NSData *posttemplatedatadic=[NSJSONSerialization dataWithJSONObject:pModel.posttemplatedatadic options:NSJSONWritingPrettyPrinted error:nil];
            NSData *postfavorite=[NSJSONSerialization dataWithJSONObject:pModel.postfavorite options:NSJSONWritingPrettyPrinted error:nil];
           
            NSString *postfilesid=pModel.postfilesid;
            NSString *postfilesidcomment=pModel.postfilesidcomment;
            NSString *postfilestype=pModel.postfilestype;
            NSNumber *postresourcetype=[NSNumber numberWithInteger:pModel.postresourcetype];
            NSNumber *postdelperminssions=[NSNumber numberWithInteger:pModel.postdelperminssions];
            
            NSString *latitude=pModel.latitude;
            NSString *longitude=pModel.longitude;
            NSString *reference=pModel.reference;
            NSString *address=pModel.address;
            
            NSNumber *version = [NSNumber numberWithInteger:pModel.postversion];
            
            NSString *appcode=pModel.appcode;
            NSString *relevanceappcode=pModel.relevanceappcode;
            NSString *relevanceid=pModel.relevanceid;
            NSString *posttemplateversion=pModel.posttemplateversion;
            NSString *posttypecode=pModel.posttypecode;
            
            NSString *appcodedataid=pModel.appcodedataid;
            NSString *favoritetitle=pModel.favoritetitle;
            NSNumber *isfiles = [NSNumber numberWithInteger:pModel.isfiles];
            NSNumber *posttemplatetype = [NSNumber numberWithInteger:pModel.posttemplatetype];
            
            NSString *posttemplatetypes = pModel.posttemplatetypes;
            
            NSString *orgid = [[[LZUserDataManager readCurrentUserInfo] objectForKey:@"notificaton"] objectForKey:@"selectoid"];
            
            NSString *expanddata=pModel.expanddata;
            NSData *expanddatadic=[NSJSONSerialization dataWithJSONObject:pModel.expanddatadic options:NSJSONWritingPrettyPrinted error:nil];


            isOK = [db executeUpdate:sql,pid,contentobjid,releaseusername,releaseuserface,content,rangetag,rangetype,rangename,msgtype,directrelateduser,directrelateduserface,directrelatedusername,rangevalue,relatedpid,releasedate,releaseuser,rangeurl,oid,posttemplateid,posttemplatedatadic,postfavorite,postfilesid,postfilesidcomment,postfilestype,postresourcetype,postdelperminssions,latitude,longitude,reference,address,version,appcode,relevanceappcode,relevanceid,posttemplateversion,posttypecode,appcodedataid,favoritetitle,isfiles,posttemplatetype,posttemplatetypes,orgid,expanddata,expanddatadic];
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post" Sql:sql Error:@"插入失败" Other:nil];
		
            *rollback = YES;
            return;
        }
        
    }];

}

/**
 *  添加单条数据
 */
-(void)addPostModel:(PostModel *)pModel{
    
    [[self getDbQuene:@"post" FunctionName:@"addPostModel:(PostModel *)pModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
            BOOL isOK = YES;
        
            NSString *pid = pModel.pid;
            NSString *contentobjid = pModel.contentobjid;
            NSString *releaseuser=pModel.releaseuser;
            NSString *releaseusername = pModel.releaseusername;
            NSString *releaseuserface = pModel.releaseuserface;
            NSString *content=pModel.content;
            NSString *rangetag=pModel.rangetag;
            NSString *rangetype=pModel.rangetype;
            NSString *rangename=pModel.rangename;
            NSNumber *msgtype=[NSNumber numberWithInteger:pModel.msgtype];
            NSString *directrelateduser=pModel.directrelateduser;
            NSString *directrelateduserface=pModel.directrelateduserface;
            NSString *directrelatedusername=pModel.directrelatedusername;
            NSString *rangeurl=pModel.rangeurl;
            NSString *rangevalue=pModel.rangevalue;
            NSString *relatedpid=pModel.relatedpid;
            NSDate *releasedate = pModel.releasedate;
            NSString *oid=pModel.oid;
            NSString *posttemplateid=pModel.posttemplateid;
            NSData *posttemplatedatadic=[NSJSONSerialization dataWithJSONObject:pModel.posttemplatedatadic options:NSJSONWritingPrettyPrinted error:nil];
            NSData *postfavorite=[NSJSONSerialization dataWithJSONObject:pModel.postfavorite options:NSJSONWritingPrettyPrinted error:nil];
            NSString *postfilesid=pModel.postfilesid;
            NSString *postfilesidcomment=pModel.postfilesidcomment;
            NSString *postfilestype=pModel.postfilestype;
            NSNumber *postresourcetype=[NSNumber numberWithInteger:pModel.postresourcetype];
            NSNumber *postdelperminssions=[NSNumber numberWithInteger:pModel.postdelperminssions];
        
            NSString *latitude=pModel.latitude;
            NSString *longitude=pModel.longitude;
            NSString *reference=pModel.reference;
            NSString *address=pModel.address;
        
            NSNumber *version = [NSNumber numberWithInteger:pModel.postversion];
        
            NSString *appcode=pModel.appcode;
            NSString *relevanceappcode=pModel.relevanceappcode;
            NSString *relevanceid=pModel.relevanceid;
            NSString *posttemplateversion=pModel.posttemplateversion;
            NSString *posttypecode=pModel.posttypecode;
        
            NSString *appcodedataid=pModel.appcodedataid;
            NSString *favoritetitle=pModel.favoritetitle;
            NSNumber *isfiles = [NSNumber numberWithInteger:pModel.isfiles];
            NSNumber *posttemplatetype = [NSNumber numberWithInteger:pModel.posttemplatetype];
            NSString *posttemplatetypes = pModel.posttemplatetypes;
            NSString *orgid = [[[LZUserDataManager readCurrentUserInfo] objectForKey:@"notificaton"] objectForKey:@"selectoid"];
        
            NSString *expanddata=pModel.expanddata;
            NSData *expanddatadic=[NSJSONSerialization dataWithJSONObject:pModel.expanddatadic options:NSJSONWritingPrettyPrinted error:nil];

        
            NSString *sql = @"INSERT OR REPLACE INTO post(pid,contentobjid,releaseusername,releaseuserface,content,rangetag,rangetype,rangename,msgtype,directrelateduser,directrelateduserface,directrelatedusername,rangevalue,relatedpid,releasedate,releaseuser,rangeurl,oid,posttemplateid,posttemplatedatadic,postfavorite,postfilesid,postfilesidcomment,postfilestype,postresourcetype,postdelperminssions,latitude,longitude,reference,address,postversion,appcode,relevanceappcode,relevanceid,posttemplateversion,posttypecode,appcodedataid,favoritetitle,isfiles,posttemplatetype,posttemplatetypes,orgid,expanddata,expanddatadic)"
            "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            isOK = [db executeUpdate:sql,pid,contentobjid,releaseusername,releaseuserface,content,rangetag,rangetype,rangename,msgtype,directrelateduser,directrelateduserface,directrelatedusername,rangevalue,relatedpid,releasedate,releaseuser,rangeurl,oid,posttemplateid,posttemplatedatadic,postfavorite,postfilesid,postfilesidcomment,postfilestype,postresourcetype,postdelperminssions,latitude,longitude,reference,address,version,appcode,relevanceappcode,relevanceid,posttemplateversion,posttypecode,appcodedataid,favoritetitle,isfiles,posttemplatetype,posttemplatetypes,orgid,expanddata,expanddatadic];
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
     
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
        
    }];

}

#pragma mark - 删除数据


/**
 *  删除单条数据
 */
-(void)delePostID:(NSString *)pid{
    
    [[self getDbQuene:@"post" FunctionName:@"delePostID:(NSString *)pid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from post where pid=? OR relatedpid=?";
        isOK = [db executeUpdate:sql,pid,pid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
    //删除动态标签
	[[self getDbQuene:@"post" FunctionName:@"delePostID:(NSString *)pid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from tag_data where dataid=?";
        isOK = [db executeUpdate:sql,pid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"tag_data" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
}

/**
 *  删除动态回复数据
 */
-(void)delePostReplyID:(NSString *)pid{
    
	[[self getDbQuene:@"post" FunctionName:@"delePostReplyID:(NSString *)pid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from post where pid=? OR relatedpid=?";
        isOK = [db executeUpdate:sql,pid,pid];
        
        if (!isOK) {
            DDLogError(@"更新失败 - updateMsgId");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post" Sql:sql Error:@"删除失败" Other:nil];

        }
    }];
    //删除动态标签
    [[self getDbQuene:@"post" FunctionName:@"delePostReplyID:(NSString *)pid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from tag_data where dataid=?";
        isOK = [db executeUpdate:sql,pid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"tag_data" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
}
/**
 *  删除动态单条回复数据
 */
-(void)delePostReplyID:(NSString *)pid Rekatedpid:(NSString*)relatedpid{
    
	[[self getDbQuene:@"post" FunctionName:@"delePostReplyID:(NSString *)pid Rekatedpid:(NSString*)relatedpid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from post where pid=? OR relatedpid=?";
        isOK = [db executeUpdate:sql,pid,relatedpid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}
/**
 *  删除组织时间段的协作
 */

-(void)delePostOid:(NSString*)oid ListStarTime:(NSDate*)starTime EndTime:(NSDate*)endTime{
    
    
    [[self getDbQuene:@"post" FunctionName:@"delePostOid:(NSString*)oid ListStarTime:(NSDate*)starTime EndTime:(NSDate*)endTime"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from post  where (pid in ( SELECT pid  FROM post WHERE releasedate<=? AND releasedate>=? AND msgtype=0) and msgtype=1 AND oid=?) OR (releasedate<=? AND releasedate>=? AND msgtype=0 AND oid=?)";
        isOK = [db executeUpdate:sql,starTime,endTime,oid,starTime,endTime,oid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
   
    
}

/**
 *  删除组织时间段的协作
 */

-(void)delePostOid:(NSString*)oid{
    [[self getDbQuene:@"post" FunctionName:@"delePostOid:(NSString*)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from post  where (pid in ( SELECT pid  FROM post WHERE  msgtype=0) and msgtype=1 AND orgid=?) OR (msgtype=0 AND orgid=?)";
        isOK = [db executeUpdate:sql,oid,oid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}

-(void)delePostAppID:(NSString *)appid{

	[[self getDbQuene:@"post" FunctionName:@"delePostAppID:(NSString *)appid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = NO;
		NSString *sql = @"delete from post  where (pid in ( SELECT pid  FROM post WHERE  msgtype=0) and msgtype=1 AND appcodedataid=?) OR (msgtype=0 AND appcodedataid=?)";
		isOK = [db executeUpdate:sql,appid,appid];
		
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post" Sql:sql Error:@"删除失败" Other:nil];

			DDLogError(@"更新失败 - updateMsgId");
		}
	}];
}
#pragma mark - 修改数据



#pragma mark - 查询数据
//得到第一条动态的id
- (NSString*)getMyPostFirstOid:(NSString*)oid{
	__block NSString *pid;
	[[self getDbQuene:@"post" FunctionName:@"getMyPostOid:(NSString*)oid StarIndex:(NSInteger)starIndex Count:(NSInteger)count IsShowFileName:(BOOL)isShowFileName"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		NSString *sql=[NSString stringWithFormat:@"SELECT * FROM post WHERE orgid=%@ AND msgtype = '0' ORDER BY releasedate desc limit 0,1",oid];
		FMResultSet *resultSet=[db executeQuery:sql];
		
		while ([resultSet next]) {
			
			pid = [resultSet stringForColumn:@"pid"];

		}
		[resultSet close];
		 
		 }];
	return pid;
}

/**
    得到我的动态列表
 *  @param oid      组织ID
 
 */
-(NSMutableArray*)getMyPostOid:(NSString*)oid StarIndex:(NSInteger)starIndex Count:(NSInteger)count IsShowFileName:(BOOL)isShowFileName{
    
 //   SELECT * FROM post WHERE msgtype =  '0' ORDER BY releasedate desc
   // 75099686750130176
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
	[[self getDbQuene:@"post" FunctionName:@"getMyPostOid:(NSString*)oid StarIndex:(NSInteger)starIndex Count:(NSInteger)count IsShowFileName:(BOOL)isShowFileName"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM post WHERE orgid=%@ AND msgtype = '0' ORDER BY releasedate desc limit %ld,%ld",oid,starIndex,count];
        FMResultSet *resultSet=[db executeQuery:sql];

        while ([resultSet next]) {
            
            PostModel *pModel=[self getModelFromFM:resultSet];
            pModel.isShowFileName=isShowFileName;

            [result addObject:pModel];
        }
        [resultSet close];
        
        //所有回复数据
        NSString *sql1=[NSString stringWithFormat:@" SELECT * FROM post WHERE  relatedpid in( SELECT pid  FROM post WHERE orgid=%@ AND msgtype =  '0'  ORDER BY releasedate desc limit %ld,%ld)  ORDER BY releasedate ",oid,starIndex,count];
        FMResultSet *replaySet=[db executeQuery:sql1];
        
        while ([replaySet next]) {
            
            PostModel *pModel=[self getModelFromFM:replaySet];
            
            for (PostModel *sModel in result) {
                if (pModel.relatedpid && [pModel.relatedpid isEqualToString:sModel.pid]) {
                    [sModel.replypostlist addObject:pModel];
                    break;
                }
            }
            
        }
        [replaySet close];
        
        
        //所有标签
        NSString *sql2=[NSString stringWithFormat:@" SELECT * FROM tag_data WHERE  dataid in( SELECT pid  FROM post WHERE orgid=%@ AND msgtype =  '0'  ORDER BY releasedate desc limit %ld,%ld)  ORDER BY createdate desc",oid,starIndex,count];

        FMResultSet *dataTagSet=[db executeQuery:sql2];
        
        while ([dataTagSet next]) {
            
            NSString *name=[dataTagSet stringForColumn:@"name"];
            NSString *tdid=[dataTagSet stringForColumn:@"tdid"];
            NSString *uid=[dataTagSet stringForColumn:@"uid"];
            NSString *dataid=[dataTagSet stringForColumn:@"dataid"];
            
            TagDataModel *tModel=[[TagDataModel alloc]init];
            tModel.name=name;
            tModel.tdid=tdid;
            tModel.uid=uid;
            tModel.dataid=dataid;
            for (PostModel *sModel in result) {
                if (dataid &&[dataid isEqualToString:sModel.pid]) {
                    [sModel.tagdata addObject:tModel];
                    break;
                }
            }
            
        }
        [dataTagSet close];
        
        //所有文件
         NSString *sql3=[NSString stringWithFormat:@" SELECT * FROM post_file WHERE  postid in( SELECT pid  FROM post WHERE orgid=%@ AND msgtype =  '0'  ORDER BY releasedate desc limit %ld,%ld)  ORDER BY updatedate desc",oid,starIndex,count];
        
        FMResultSet *fileSet=[db executeQuery:sql3];
      //   SELECT * FROM post_file WHERE  rpid in( SELECT pid  FROM post WHERE oid=25395315007846432 AND msgtype =  '0'  ORDER BY releasedate desc limit 0,10)  ORDER BY updatedate desc
        while ([fileSet next]) {
            
            NSString *rid=[fileSet stringForColumn:@"rid"];
            NSString *rpid=[fileSet stringForColumn:@"rpid"];
            NSString *classid=[fileSet stringForColumn:@"classid"];
            NSString *expid=[fileSet stringForColumn:@"expid"];
            NSString *exptype=[fileSet stringForColumn:@"exptype"];
            NSString *icon=[fileSet stringForColumn:@"icon"];
            NSString *iconurl=[fileSet stringForColumn:@"iconurl"];
            NSString *descripti=[fileSet stringForColumn:@"description"];
            NSString *expandinfo=[fileSet stringForColumn:@"expandinfo"];
            NSInteger iscurrentversion=[fileSet intForColumn:@"iscurrentversion"];
            NSString *showname=[fileSet stringForColumn:@"showname"];
            NSString *showsize=[fileSet stringForColumn:@"showsize"];
            NSString *showversion=[fileSet stringForColumn:@"showversion"];
            NSDate *updatedate=[fileSet dateForColumn:@"updatedate"];
            NSString *updateusername=[fileSet stringForColumn:@"updateusername"];
            NSString *version=[fileSet stringForColumn:@"version"];
            NSString *versionid=[fileSet stringForColumn:@"versionid"];
            NSInteger rtype=[fileSet intForColumn:@"rtype"];
            NSInteger size=[fileSet intForColumn:@"size"];
            NSInteger sortindex=[fileSet intForColumn:@"sortindex"];
            NSInteger subcount=[fileSet intForColumn:@"subcount"];
            NSString *postID=[fileSet stringForColumn:@"postid"];
            NSString *name=[fileSet stringForColumn:@"name"];
            
            PostFileModel *fModel=[[PostFileModel alloc]init];
            fModel.rid=rid;
            fModel.rpid=rpid;
            fModel.classid=classid;
            fModel.expid=expid;
            fModel.exptype=exptype;
            fModel.icon=icon;
            fModel.iconurl=iconurl;
            fModel.descripti=descripti;
            fModel.expandinfo=expandinfo;
            fModel.iscurrentversion=iscurrentversion;
            fModel.showname=showname;
            fModel.showsize=showsize;
            fModel.showversion=showversion;
            fModel.updatedate=updatedate;
            fModel.updateusername=updateusername;
            fModel.version=version;
            fModel.versionid=versionid;
            fModel.rtype=rtype;
            fModel.size=size;
            fModel.sortindex=sortindex;
            fModel.subcount=subcount;
            fModel.postID=postID;
            fModel.name=name;
            for (PostModel *sModel in result) {
                if (postID &&[postID isEqualToString:sModel.pid]) {
                    [sModel.rosourlist addObject:fModel];
                    break;
                }
            }
            
        }
        [fileSet close];
        
        // 点赞
        NSString *sql4=[NSString stringWithFormat:@" SELECT * FROM post_praise WHERE  pid in( SELECT pid  FROM post WHERE orgid=%@ AND msgtype =  '0'  ORDER BY releasedate desc limit %ld,%ld)",oid,starIndex,count];
        FMResultSet *zanSet=[db executeQuery:sql4];
        
        while ([zanSet next]) {
            
            NSString *pid=[zanSet stringForColumn:@"pid"];
            NSString *ppid=[zanSet stringForColumn:@"ppid"];
            NSString *uid=[zanSet stringForColumn:@"uid"];
            NSString *username=[zanSet stringForColumn:@"username"];
            NSDate *praisedate=[zanSet dateForColumn:@"praisedate"];
            
            PostZanModel *zModel=[[PostZanModel alloc]init];
            zModel.pid=pid;
            zModel.ppid=ppid;
            zModel.uid=uid;
            zModel.username=username;
            zModel.praisedate=praisedate;
            for (PostModel *sModel in result) {
                if (pid &&[pid isEqualToString:sModel.pid]) {
                    [sModel.prainseusername addObject:zModel];
                    break;
                }
            }
        }
        [zanSet close];
    }];
    
    return result;

}
#pragma mark 内部
// 数据库转模型
-(PostModel*)getModelFromFM:(FMResultSet*)resultSet{
    
    PostModel *pModel=[[PostModel alloc]init];
    
    NSString *pid = [resultSet stringForColumn:@"pid"];
    NSString *contentobjid = [resultSet stringForColumn:@"contentobjid"];
    NSString *releaseuser = [resultSet stringForColumn:@"releaseuser"];
    NSString *releaseusername = [resultSet stringForColumn:@"releaseusername"];
    NSString *releaseuserface = [resultSet stringForColumn:@"releaseuserface"];
    NSString *content = [resultSet stringForColumn:@"content"];
    NSString *rangetag =[resultSet stringForColumn:@"rangetag"];
    NSString *rangetype = [resultSet stringForColumn:@"rangetype"];
    NSString *rangename = [resultSet stringForColumn:@"rangename"];
    NSInteger msgtype = [resultSet intForColumn:@"msgtype"];
    NSString *directrelateduser = [resultSet stringForColumn:@"directrelateduser"];
    NSString *directrelateduserface = [resultSet stringForColumn:@"directrelateduserface"];
    NSString *directrelatedusername = [resultSet stringForColumn:@"directrelatedusername"];
    NSString *rangeurl = [resultSet stringForColumn:@"rangeurl"];
    NSString *rangevalue = [resultSet stringForColumn:@"rangevalue"];
    NSString *relatedpid = [resultSet stringForColumn:@"relatedpid"];
    NSDate *releasedate =[resultSet dateForColumn:@"releasedate"];
    NSString *posttemplateid=[resultSet stringForColumn:@"posttemplateid"];
    NSData *posttemplatedatadic=[resultSet dataForColumn:@"posttemplatedatadic"];
    NSData *postfavorite=[resultSet dataForColumn:@"postfavorite"];
    
    NSString *postfilesid=[resultSet stringForColumn:@"postfilesid"];
    NSString *postfilesidcomment=[resultSet stringForColumn:@"postfilesidcomment"];
    NSString *postfilestype=[resultSet stringForColumn:@"postfilestype"];
    NSInteger postresourcetype=[resultSet intForColumn:@"postresourcetype"];
    NSInteger postdelperminssions=[resultSet intForColumn:@"postdelperminssions"];
    
    NSString *latitude=[resultSet stringForColumn:@"latitude"];
    
    NSString *longitude=[resultSet stringForColumn:@"longitude"];
    
    NSString *reference=[resultSet stringForColumn:@"reference"];
    NSString *address=[resultSet stringForColumn:@"address"];
    
    NSInteger postversion=[resultSet intForColumn:@"postversion"];
    
    NSString *appcode=[resultSet stringForColumn:@"appcode"];
    NSString *relevanceappcode=[resultSet stringForColumn:@"relevanceappcode"];
    NSString *relevanceid=[resultSet stringForColumn:@"relevanceid"];
    NSString *posttemplateversion=[resultSet stringForColumn:@"posttemplateversion"];
    NSInteger posttemplatetype=[resultSet intForColumn:@"posttemplatetype"];
    NSString *posttemplatetypes=[resultSet stringForColumn:@"posttemplatetypes"];
    
    NSString *posttypecode=[resultSet stringForColumn:@"posttypecode"];
    NSString *appcodedataid=[resultSet stringForColumn:@"appcodedataid"];
    NSString *favoritetitle=[resultSet stringForColumn:@"favoritetitle"];
    BOOL isfiles =[resultSet intForColumn:@"isfiles"];

    NSString *expanddata=[resultSet stringForColumn:@"expanddata"];
    NSData *expanddatadic=[resultSet dataForColumn:@"expanddatadic"];
    
    if(!expanddatadic){
        expanddatadic = [NSData data];
    }
    if(!postfavorite){
        postfavorite=[NSData data];
    }
    pModel.pid=pid;
    pModel.contentobjid=contentobjid;
    pModel.releaseuser=releaseuser;
    pModel.releaseusername=releaseusername;
    pModel.releaseuserface=releaseuserface;
    pModel.content=content;
    pModel.rangetag=rangetag;
    pModel.rangetype=rangetype;
    pModel.rangename=rangename;
    pModel.msgtype=msgtype;
    pModel.directrelateduser=directrelateduser;
    pModel.directrelateduserface=directrelateduserface;
    pModel.directrelatedusername=directrelatedusername;
    pModel.rangeurl=rangeurl;
    pModel.rangevalue=rangevalue;
    pModel.relatedpid=relatedpid;
    pModel.releasedate=releasedate;
    pModel.posttemplateid=posttemplateid;
    pModel.posttemplatedatadic=[NSJSONSerialization JSONObjectWithData:posttemplatedatadic options:NSJSONReadingMutableContainers error:nil];
    pModel.postfavorite=[NSJSONSerialization JSONObjectWithData:postfavorite options:NSJSONReadingMutableContainers error:nil];
    
    pModel.postfilesid=postfilesid;
    pModel.postfilesidcomment=postfilesidcomment;
    pModel.postfilestype=postfilestype;
    pModel.postresourcetype=postresourcetype;
    pModel.postdelperminssions=postdelperminssions;
    
    pModel.latitude=latitude;
    pModel.longitude=longitude;
    pModel.reference=reference;
    pModel.address=address;
    pModel.postversion=postversion;
    
    
    pModel.appcode=appcode;
    pModel.relevanceappcode=relevanceappcode;
    pModel.relevanceid=relevanceid;
    pModel.posttemplateversion=posttemplateversion;
    pModel.posttemplatetype=posttemplatetype;
    pModel.posttemplatetypes=posttemplatetypes;
    pModel.posttypecode=posttypecode;
    pModel.appcodedataid=appcodedataid;
    pModel.favoritetitle=favoritetitle;
    pModel.isfiles=isfiles;
    
    pModel.expanddata = expanddata;
    pModel.expanddatadic=[NSJSONSerialization JSONObjectWithData:expanddatadic options:NSJSONReadingMutableContainers error:nil];

    
    return pModel;
}

@end
