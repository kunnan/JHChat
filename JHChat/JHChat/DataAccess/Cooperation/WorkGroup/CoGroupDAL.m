//
//  CoGroupDAL.m
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 群组数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "CoGroupDAL.h"
#import "CoManageDAL.h"

@implementation CoGroupDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoGroupDAL *)shareInstance{
    static CoGroupDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[CoGroupDAL alloc] init];
    }
    return instance;
}

/**
 *  创建表
 */
-(void)createCoGroupTableIfNotExists
{
    NSString *tableName = @"co_group";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[cid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[oid] [varchar](50) NULL,"
                                         "[createdate] [date] NULL,"
                                         "[createuname] [varchar](300) NULL,"
                                         "[createuser] [varchar](50) NULL,"
                                         "[des] [text] NULL,"
                                         "[gcode] [varchar](300) NULL,"
                                         "[logo] [text] NULL,"
                                         "[gid] [varchar](50) NULL,"
                                         "[ruid] [text] NULL,"
                                         "[name] [varchar](500) NULL,"
                                         "[needauditing] [integer] NULL,"
                                         "[resourceid] [integer] NULL,"
                                         "[lockdate] [date] NULL,"
                                         "[lockuser] [varchar](300) NULL,"
                                         "[isgroup] [integer] NULL,"
                                         "[memberslength] [integer] NULL,"
                                         "[currentusertype] [integer] NULL,"
                                         "[superadminid] [varchar](50) NULL,"
                                         "[bind_oid] [varchar](50) NULL,"
                                         "[coid] [varchar](50) NULL,"
                                         "[state] [integer] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateCoGroupTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 36:{
                
                //我加入的索引
                [self AddColumnToTableIfNotExist:@"co_group" columnName:@"[joinindex]" type:@"[float]"];
                [self AddColumnToTableIfNotExist:@"co_group" columnName:@"[creatindex]" type:@"[float]"];
                [self AddColumnToTableIfNotExist:@"co_group" columnName:@"[maginindex]" type:@"[float]"];
                [self AddColumnToTableIfNotExist:@"co_group" columnName:@"[closeindex]" type:@"[float]"];

                break;
            }
			case 61:{
				[self AddColumnToTableIfNotExist:@"co_group" columnName:@"[isfavorites]" type:@"[bool]"];
				break;
				
			}
        }
    }
}
-(void)addDataWithArray:(NSMutableArray *)groupArray StartIndex:(NSInteger)sIndex {
    
    [[self getDbQuene:@"co_group" FunctionName:@"addDataWithArray:(NSMutableArray *)groupArray StartIndex:(NSInteger)sIndex"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        BOOL isOK = YES;
		NSString *sql;
		
        for (int i = 0; i< groupArray.count;  i++) {
            CoGroupModel *groupModel = [groupArray objectAtIndex:i];
            
            NSString *cid = groupModel.cid;
            NSString *oid = groupModel.oid;
            NSString *createuname = groupModel.createuname;
            NSString *createuser = groupModel.createuser;
            NSString *des = groupModel.des;
            NSString *gcode = groupModel.gcode;
            NSString *logo = groupModel.logo;
            NSString *gid = groupModel.gid;
            NSString *ruid = groupModel.ruid;
            NSString *name = groupModel.name;
            NSString *lockuser = groupModel.lockuser;
            NSDate *createdate = groupModel.createtime;
            NSDate *lockdate = groupModel.lockdate;
            NSString *resourceid=groupModel.resourceid;
            
            NSString *bind_oid=groupModel.bind_oid;
            NSString *coid=groupModel.coid;
            NSString *superadminid = groupModel.superadminid;
            NSNumber *currentusertype = [NSNumber numberWithInteger:groupModel.currentusertype];
            NSNumber *memberslength = [NSNumber numberWithInteger:groupModel.memberslength];
            
            NSNumber *isgroup = [NSNumber numberWithInteger:groupModel.isgroup];
            NSNumber *state = [NSNumber numberWithInteger:groupModel.state];
            
//            NSInteger sunject = 0; //我加入的
            NSString *indexName =@""; //我加入的
            NSNumber * index = [NSNumber numberWithFloat:0.0];
			
			NSNumber *isfavorites = [NSNumber numberWithBool:groupModel.isfavorites];
			

            //数字
            NSNumber * joinindex = [NSNumber numberWithFloat:0.0];
            if (!(groupModel.joinindex==0.0)) {
                joinindex = [NSNumber numberWithFloat:sIndex+i+1.000];
                index = joinindex;
//                sunject = 0;
                indexName =@"joinindex"; //我加入的

            }
            //数字
            NSNumber * creatindex = [NSNumber numberWithFloat:0.0];
            if (!(groupModel.creatindex==0.0)) {
                creatindex = [NSNumber numberWithFloat:sIndex+i+1.000];
//                sunject = 1;
                indexName =@"creatindex"; //我加入的
                index = creatindex;

            }
            //数字
            NSNumber * maginindex = [NSNumber numberWithFloat:0.0];
            if (!(groupModel.maginindex==0.0)) {
                maginindex = [NSNumber numberWithFloat:sIndex+i+1.000];
//                sunject = 2;
                indexName =@"maginindex"; //我加入的
                index = maginindex;

            }
            //数字
            NSNumber * closeindex = [NSNumber numberWithFloat:0.0];
            if (!(groupModel.closeindex==0.0)) {
                closeindex = [NSNumber numberWithFloat:sIndex+i+1.000];
//                sunject = 3;
                indexName =@"closeindex"; //我加入的
                index = closeindex;

            }

            
            BOOL isExist = false;
            
            //判读是否存在😯
            NSString *sql1=[NSString stringWithFormat:@"Select gid From co_group Where cid=%@",cid];
            FMResultSet *resultSet1=[db executeQuery:sql1];
            while ([resultSet1 next]) {
                isExist=YES;
            };
            
            if(isExist){
                
                sql = [NSString stringWithFormat:@"update co_group set isfavorites=?,oid=?,createuname=?,createuser=?,des=?,gcode=?,logo=?,gid=?,ruid=?,name=?,lockuser=?,createdate=?,lockdate=?,isgroup=?,state=?,resourceid=?,superadminid=?,currentusertype=?,memberslength=?,bind_oid=?,coid=?,%@=? Where cid=?",indexName];
                isOK = [db executeUpdate:sql,isfavorites,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid,index,cid];
                
                if (!isOK) {
                    DDLogError(@"更新失败 - updateMsgId");
                }
                
                
            }else{
            
                sql = @"INSERT OR REPLACE INTO co_group(cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid,joinindex,creatindex,maginindex,closeindex,isfavorites)"
                "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                isOK = [db executeUpdate:sql,cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid,joinindex,creatindex,maginindex,closeindex,isfavorites];
                
                if (!isOK) {
                    DDLogError(@"插入失败");
                }
            }
            if (!isOK) {
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"插入失败" Other:nil];

                *rollback = YES;
                return;
            }
            }
            
    }];
  
}

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)groupArray{
	
	[[self getDbQuene:@"co_group" FunctionName:@"addDataWithArray:(NSMutableArray *)groupArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = YES;
		NSString *sql;
		for (CoGroupModel *groupModel in groupArray) {
			
			NSString *cid = groupModel.cid;
			NSString *oid = groupModel.oid;
			NSString *createuname = groupModel.createuname;
			NSString *createuser = groupModel.createuser;
			NSString *des = groupModel.des;
			NSString *gcode = groupModel.gcode;
			NSString *logo = groupModel.logo;
			NSString *gid = groupModel.gid;
			NSString *ruid = groupModel.ruid;
			NSString *name = groupModel.name;
			NSString *lockuser = groupModel.lockuser;
			NSDate *createdate = groupModel.createtime;
			NSDate *lockdate = groupModel.lockdate;
			NSString *resourceid=groupModel.resourceid;
			NSNumber *isgroup = [NSNumber numberWithInteger:groupModel.isgroup];
			NSNumber *state = [NSNumber numberWithInteger:groupModel.state];
			NSNumber *needauditing=[NSNumber numberWithInteger:groupModel.needauditing];
			
			NSString *coid=groupModel.coid;
			NSString *bind_oid=groupModel.bind_oid;
			NSString *superadminid = groupModel.superadminid;
			NSNumber *currentusertype = [NSNumber numberWithInteger:groupModel.currentusertype];
			NSNumber *memberslength = [NSNumber numberWithInteger:groupModel.memberslength];
			NSNumber *isfavorites = [NSNumber numberWithBool:groupModel.isfavorites];
		
			sql = @"INSERT OR REPLACE INTO co_group(cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid,isfavorites)"
				"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			
			isOK = [db executeUpdate:sql,cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid,isfavorites];
			
			if (!isOK) {
					DDLogError(@"插入失败");
				}
		}
		
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"插入失败" Other:nil];

			*rollback = YES;
			return;
		}
		
	}];
	
	
}
-(void)addGroupModel:(CoGroupModel *)groupModel{
	
    [[self getDbQuene:@"co_group" FunctionName:@"addGroupModel:(CoGroupModel *)groupModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		
        NSString *cid = groupModel.cid;
        NSString *oid = groupModel.oid;
        NSString *createuname = groupModel.createuname;
        NSString *createuser = groupModel.createuser;
        NSString *des = groupModel.des;
        NSString *gcode = groupModel.gcode;
        NSString *logo = groupModel.logo;
        NSString *gid = groupModel.gid;
        NSString *ruid = groupModel.ruid;
        NSString *name = groupModel.name;
        NSString *lockuser = groupModel.lockuser;
        NSDate *createdate = groupModel.createtime;
        NSDate *lockdate = groupModel.lockdate;
        NSString *resourceid=groupModel.resourceid;
        NSNumber *isgroup = [NSNumber numberWithInteger:groupModel.isgroup];
        NSNumber *state = [NSNumber numberWithInteger:groupModel.state];
        NSNumber *needauditing=[NSNumber numberWithInteger:groupModel.needauditing];
        
        NSString *coid=groupModel.coid;
        NSString *bind_oid=groupModel.bind_oid;
        NSString *superadminid = groupModel.superadminid;
        NSNumber *currentusertype = [NSNumber numberWithInteger:groupModel.currentusertype];
        NSNumber *memberslength = [NSNumber numberWithInteger:groupModel.memberslength];
		
		NSNumber *isfavorites = [NSNumber numberWithBool:groupModel.isfavorites];
		
        BOOL isExist = false;
        
        //判读是否存在😯
        NSString *sql1=[NSString stringWithFormat:@"Select gid From co_group Where cid=%@",cid];
        FMResultSet *resultSet1=[db executeQuery:sql1];
        while ([resultSet1 next]) {
            isExist=YES;
        };
        
        if(isExist){
            
            NSString *sql = [NSString stringWithFormat:@"update co_group set isfavorites=?,oid=?,createuname=?,createuser=?,des=?,gcode=?,logo=?,gid=?,ruid=?,name=?,lockuser=?,createdate=?,lockdate=?,isgroup=?,state=?,resourceid=?,superadminid=?,currentusertype=?,memberslength=?,bind_oid=?,coid=? Where cid=?"];
            isOK = [db executeUpdate:sql,isfavorites,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid,cid];
            
            if (!isOK) {
                DDLogError(@"更新失败 - updateMsgId");
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"插入失败" Other:nil];

            }

        }else{
        
            NSString *sql = @"INSERT OR REPLACE INTO co_group(cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid,isfavorites)"
            "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            isOK = [db executeUpdate:sql,cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid,isfavorites];
            if (!isOK) {
                DDLogError(@"插入失败");
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"插入失败" Other:nil];

            }
        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }

        
    }];
}

/**
 新建群组信息
 *  @param groupModel      群组数据
 */
-(void)updateModelGroupId:(NSString *)gid GroupModel:(CoGroupModel *)groupModel{
    
    NSString *cid = groupModel.cid;
    NSString *oid = groupModel.oid;
    NSString *createuname = groupModel.createuname;
    NSString *createuser = groupModel.createuser;
    NSString *des = groupModel.des;
    NSString *gcode = groupModel.gcode;
    NSString *logo = groupModel.logo;
    NSString *ruid = groupModel.ruid;
    NSString *name = groupModel.name;
    NSString *lockuser = groupModel.lockuser;
    NSDate *createdate = groupModel.createtime;
    NSDate *lockdate = groupModel.lockdate;
    NSString *resourceid=groupModel.resourceid;
    NSNumber *isgroup = [NSNumber numberWithInteger:groupModel.isgroup];
    NSNumber *state = [NSNumber numberWithInteger:groupModel.state];
    NSNumber *needauditing=[NSNumber numberWithInteger:groupModel.needauditing];
    
    NSString *coid=groupModel.coid;
    NSString *bind_oid=groupModel.bind_oid;
    NSString *superadminid = groupModel.superadminid;
    NSNumber *currentusertype = [NSNumber numberWithInteger:groupModel.currentusertype];
    NSNumber *memberslength = [NSNumber numberWithInteger:groupModel.memberslength];
	NSNumber *isfavorites = [NSNumber numberWithBool:groupModel.isfavorites];
	
    
    [[self getDbQuene:@"co_group" FunctionName:@"updateModelGroupId:(NSString *)gid GroupModel:(CoGroupModel *)groupModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_group set isfavorites=?,oid=?,createuname=?,createuser=?,des=?,gcode=?,logo=?,gid=?,ruid=?,name=?,lockuser=?,createdate=?,lockdate=?,isgroup=?,state=?,needauditing=?,resourceid=?,superadminid=?,currentusertype=?,memberslength=?,bind_oid=?,coid=? Where cid=?";
        isOK = [db executeUpdate:sql,isfavorites,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid,cid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    } ];
}



/**
    新建群组信息
 *  @param groupModel      群组数据
 */
-(void)addNewGroupModel:(CoGroupModel *)groupModel{
    
    [[self getDbQuene:@"co_group" FunctionName:@"addNewGroupModel:(CoGroupModel *)groupModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *cid = groupModel.cid;
        NSString *oid = groupModel.oid;
        NSString *createuname = groupModel.createuname;
        NSString *createuser = groupModel.createuser;
        NSString *des = groupModel.des;
        NSString *gcode = groupModel.gcode;
        NSString *logo = groupModel.logo;
        NSString *gid = groupModel.gid;
        NSString *ruid = groupModel.ruid;
        NSString *name = groupModel.name;
        NSString *lockuser = groupModel.lockuser;
        NSDate *createdate = groupModel.createtime;
        NSDate *lockdate = groupModel.lockdate;
        NSString *resourceid=groupModel.resourceid;
        NSNumber *isgroup = [NSNumber numberWithInteger:groupModel.isgroup];
        NSNumber *state = [NSNumber numberWithInteger:groupModel.state];
        NSNumber *needauditing=[NSNumber numberWithInteger:groupModel.needauditing];
        
        NSString *coid=groupModel.coid;
        NSString *bind_oid=groupModel.bind_oid;
        NSString *superadminid = groupModel.superadminid;
        NSNumber *currentusertype = [NSNumber numberWithInteger:groupModel.currentusertype];
        NSNumber *memberslength = [NSNumber numberWithInteger:groupModel.memberslength];
		
		NSNumber *isfavorites = [NSNumber numberWithBool:groupModel.isfavorites];
        
        CGFloat curIndex = 1.0;
        
        NSString *sql1=[NSString stringWithFormat:@"Select joinindex From co_group Where coid=%@  AND state=1  limit 0,1",oid];
        
        FMResultSet *resultSet1=[db executeQuery:sql1];
        while ([resultSet1 next]) {
            curIndex  = [resultSet1 doubleForColumn:@"joinindex"];
            if (curIndex>1.0) {
                curIndex =1.0;
            }
        }
        curIndex -=0.001;
        
        
        NSNumber *joinindex = [NSNumber numberWithFloat:curIndex];
        NSNumber *creatindex = [NSNumber numberWithInteger:curIndex];
        NSNumber *maginindex = [NSNumber numberWithInteger:curIndex];

        NSString *sql = @"INSERT OR REPLACE INTO co_group(cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid,joinindex,creatindex,maginindex,isfavorites)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid,joinindex,creatindex,maginindex,isfavorites];
        if (!isOK) {
            DDLogError(@"插入失败");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"更新失败" Other:nil];

        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
}


-(void)deleteGroupid:(NSString *)gid{
    [[self getDbQuene:@"co_group" FunctionName:@"deleteGroupid:(NSString *)gid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_group where gid=?";
        isOK = [db executeUpdate:sql,gid];
        
        if (!isOK) {
            DDLogError(@"更新失败 - updateMsgId");
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"删除失败" Other:nil];

        }
        NSString *sql2=@"delete from co_member where cid=?";
        [db executeUpdate:sql2,gid];
    }];
}

/**
 *  根据id删除群组
 *
 *  @param oid 机构ID
 */
-(void)deleteAllGroupOid:(NSString *)oid{
    
    [[self getDbQuene:@"co_group" FunctionName:@"deleteAllGroupOid:(NSString *)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_group where coid=?";
        isOK = [db executeUpdate:sql,oid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
}

/**
 *  根据id删除机构
 *
 *  @param oid 机构ID
 */
-(void)deleteOrgGroupOid:(NSString *)oid{
	[[self getDbQuene:@"co_group" FunctionName:@"deleteOrgGroupOid:(NSString *)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = NO;
		NSString *sql = @"delete from co_group where coid=? AND bind_oid is not null ";
		isOK = [db executeUpdate:sql,oid];
		
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"删除失败" Other:nil];

			DDLogError(@"更新失败 - updateMsgId");
		}
	}];

}

/**
 *  根据id删除关闭群组
 *
 *  @param oid 机构ID
 */
-(void)deleteAllMyCloseGroupOid:(NSString *)oid{
    
    [[self getDbQuene:@"co_group" FunctionName:@"deleteAllMyCloseGroupOid:(NSString *)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_group where coid=? AND state=0";
        isOK = [db executeUpdate:sql,oid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}

/**
 *  根据id删除创建群组
 *
 *  @param oid 机构ID
 */
-(void)deleteAllMyCreatGroupOid:(NSString *)oid{
    NSString *curuid=[[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
    [[self getDbQuene:@"co_group" FunctionName:@"deleteAllMyCreatGroupOid:(NSString *)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_group where coid=? AND superadminid=?";
        isOK = [db executeUpdate:sql,oid,curuid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
}

/**
 *  根据id删除创建群组
 *
 *  @param oid 机构ID
 */
-(void)deleteUpAllMyCreatGroupOid:(NSString *)oid{
    
    NSString *curuid=[[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
    [[self getDbQuene:@"co_group" FunctionName:@"deleteUpAllMyCreatGroupOid:(NSString *)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_group set state=-1 where coid=? AND superadminid=?";
        isOK = [db executeUpdate:sql,oid,curuid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}
/**
 *  根据id删除管理群组
 *
 *  @param oid 机构ID
 */
-(void)deleteAllMyMangeGroupOid:(NSString *)oid{
    
    [[self getDbQuene:@"co_group" FunctionName:@"deleteAllMyMangeGroupOid:(NSString *)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_group Where gid in (select cid from co_manage Where oid=? AND type='group')";
        isOK = [db executeUpdate:sql,oid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
    [[CoManageDAL shareInstance]deleteMangeOid:oid type:@"group"];
    
}
/**
 *  根据id删除管理群组
 *
 *  @param oid 机构ID
 */
-(void)deleteUpAllMyMangeGroupOid:(NSString *)oid{
    
    [[self getDbQuene:@"co_group" FunctionName:@"deleteUpAllMyMangeGroupOid:(NSString *)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_group set state=-1 Where gid in (select cid from co_manage Where oid=? AND type='group')";
        isOK = [db executeUpdate:sql,oid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}

/**
 *  根据id删除加入的群组
 *
 *  @param oid 机构ID
 */
-(void)deleteAllMyJoinGroupOid:(NSString *)oid{
    
    [[self getDbQuene:@"co_group" FunctionName:@"deleteAllMyJoinGroupOid:(NSString *)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_group Where coid=? AND state=1";
        isOK = [db executeUpdate:sql,oid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
    
}
/**
 *  根据id删除加入的群组
 *
 *  @param oid 机构ID
 */
-(void)deleteuUpAllMyJoinGroupOid:(NSString *)oid{
    
    [[self getDbQuene:@"co_group" FunctionName:@"deleteuUpAllMyJoinGroupOid:(NSString *)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_group set state=-1 Where coid=? AND state=1";
        isOK = [db executeUpdate:sql,oid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}

-(void)updateGroupId:(NSString *)gid withzGroupName:(NSString *)gName{
    
    [[self getDbQuene:@"co_group" FunctionName:@"updateGroupId:(NSString *)gid withzGroupName:(NSString *)gName"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_group set name=? Where cid=?";
        isOK = [db executeUpdate:sql,gName,gid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
}

-(void)updateGroupId:(NSString *)gid withzGroupDes:(NSString *)gDes{
    [[self getDbQuene:@"co_group" FunctionName:@"updateGroupId:(NSString *)gid withzGroupDes:(NSString *)gDes"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_group set des=? Where cid=?";
        isOK = [db executeUpdate:sql,gDes,gid];
        
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
}
/**
 修改群组状态
 *  @param gid      群组ID
 *  @param state    群组描述 1 开启 0关闭
 */
-(void)updateGroupId:(NSString *)gid withGroupState:(NSInteger)state{
    
    NSNumber *state1=[NSNumber numberWithInteger:state];
    [[self getDbQuene:@"co_group" FunctionName:@"updateGroupId:(NSString *)gid withGroupState:(NSInteger)state"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_group set state=? Where cid=?";
        isOK = [db executeUpdate:sql,state1,gid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    } ];
}

/**
 修改群组管制
 *  @param gid      群组ID
 */
-(void)updateGroupId:(NSString *)gid withGroupFavorite:(BOOL)isfavorites{
	
	NSNumber *state1=[NSNumber numberWithBool:isfavorites];
	[[self getDbQuene:@"co_group" FunctionName:@"updateGroupId:(NSString *)gid withGroupFavorite:(BOOL)isfavorites"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = NO;
		NSString *sql = @"update co_group set isfavorites=? Where cid=?";
		isOK = [db executeUpdate:sql,state1,gid];
		
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"更新失败" Other:nil];

			DDLogError(@"更新失败 - updateMsgId");
		}
	} ];
}

/**
 修改群组logo
 *  @param gid        群组ID
 *  @param logo       群组logo
 */
-(void)updateGroupId:(NSString *)gid withzGrouplogo:(NSString *)logo{
    [[self getDbQuene:@"co_group" FunctionName:@"updateGroupId:(NSString *)gid withzGrouplogo:(NSString *)logo"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_group set logo=? Where cid=?";
        isOK = [db executeUpdate:sql,logo,gid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    } ];
}

/**
 修改群组加入权限
 *  @param gid        群组ID
 *  @param isApply    权限
 */
-(void)updateGroupId:(NSString *)gid withzGroupApplyroot:(NSNumber *)isApply{
   
    [[self getDbQuene:@"co_group" FunctionName:@"updateGroupId:(NSString *)gid withzGroupApplyroot:(NSNumber *)isApply"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_group set needauditing=? Where cid=?";
        isOK = [db executeUpdate:sql,isApply,gid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    } ];

}

/**
 *  更新工作组所在企业
 *
 *  @param gid 群组ID
 *  @param oid 企业ID
 */
-(void)updateGroupId:(NSString *)gid withzGroupCoid:(NSString *)oid{
    
    [[self getDbQuene:@"co_group" FunctionName:@"updateGroupId:(NSString *)gid withzGroupCoid:(NSString *)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_group set coid=? Where cid=?";
        isOK = [db executeUpdate:sql,oid,gid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    } ];
}

-(void)updateGroupDataId:(NSString *)gid withzGroupName:(NSString *)name Des:(NSString*)des Needauditing:(NSInteger)needauditing{
    NSNumber *needaudit=[NSNumber numberWithInteger:needauditing];
    [[self getDbQuene:@"co_group" FunctionName:@"updateGroupDataId:(NSString *)gid withzGroupName:(NSString *)name Des:(NSString*)des Needauditing:(NSInteger)needauditing"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_group set name=?,des=?,needauditing=? Where cid=?";
        isOK = [db executeUpdate:sql,name,des,needaudit,gid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    } ];
}
/**
 *  更新工作组成员数量
 *
 *  @param gid 群组ID
 *  @param memlength 成员总数
 */
-(void)updateGroupId:(NSString *)gid withzGroupMemLength:(NSInteger )memlength{
    
    NSNumber *memberslength=[NSNumber numberWithInteger:memlength];
    
    [[self getDbQuene:@"co_group" FunctionName:@"updateGroupId:(NSString *)gid withzGroupMemLength:(NSInteger )memlength"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_group set memberslength=? Where cid=?";
        isOK = [db executeUpdate:sql,memberslength,gid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_group" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    } ];

}
#pragma mark 查询
/**
 *  我创建的群组列表
 *
 *  @param oid      组织ID
 *  @param startIndex  起始ID 没有传0
 *  @param count    数量
 *
 *  @return 群组
 */
-(NSMutableArray *)getMyGroupWithOid:(NSString *)oid StartIndex:(NSString*)startIndex Count:(NSInteger)count{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSString *curuid=[[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
    [[self getDbQuene:@"co_group" FunctionName:@"getMyGroupWithOid:(NSString *)oid StartIndex:(NSString*)startIndex Count:(NSInteger)count"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql;
        if([startIndex isEqualToString:@"1"]){
            sql=[NSString stringWithFormat:@"Select cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid From co_group Where coid=%@ AND superadminid=%@ AND state=1 AND bind_oid is null ORDER BY name asc limit 0,%ld",oid,curuid,count];
            
        }else{
            sql=[NSString stringWithFormat:@"Select cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid From co_group Where coid=%@ AND superadminid=%@ AND bind_oid is null and creatindex > (select  creatindex From co_group where gid =%@) ORDER BY name asc limit 0,%ld",oid,curuid,startIndex,count];
        }
        
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            CoGroupModel *groupModel=[self getModelFromFM:resultSet];
            [result addObject:groupModel];
        }
        [resultSet close];
    }];
    return result;
}


/**
 *  我创建的群组列表(搜索)
 *
 *  @param oid      企业ID
 
 *
 *  @return 群组
 */

-(NSMutableArray *)SearchMyGroupWithOid:(NSString *)oid Search:(NSString*)searchStr{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSString *curuid=[[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
    [[self getDbQuene:@"co_group" FunctionName:@"SearchMyGroupWithOid:(NSString *)oid Search:(NSString*)searchStr"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid From co_group Where coid=%@ AND bind_oid is null AND superadminid=%@ AND state=1 AND name like '%%%@%%' ",oid,curuid,searchStr];
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            CoGroupModel *groupModel=[self getModelFromFM:resultSet];
            [result addObject:groupModel];
        }
        [resultSet close];
    }];
    return result;
}

/**
 *  我的管理的列表 ok
 *
 *  @param oid      组织ID
 *  此处需要处理
 *  @param startIndex  起始ID 没有传0
 *  @param count    数量
 *
 *  @return 群组
 */

-(NSMutableArray *)getMyChargeGroupWithOid:(NSString *)oid StartIndex:(NSString*)startIndex Count:(NSInteger)count{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"co_group" FunctionName:@"getMyChargeGroupWithOid:(NSString *)oid StartIndex:(NSString*)startIndex Count:(NSInteger)count"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *sql;
        if([startIndex isEqualToString:@"1"]){
            
            sql=[NSString stringWithFormat:@"Select cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid From co_group Where gid in (select cid from co_manage Where oid=%@ AND type='group') AND bind_oid is null ORDER BY name asc limit 0,%ld",oid,count];
        }else{
            
            sql=[NSString stringWithFormat:@"Select cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid From From co_group Where gid in (select cid from co_manage Where oid=%@ AND type='group') AND bind_oid is null and maginindex > (select  maginindex From co_group where gid =%@) ORDER BY name asc limit 0,%ld",oid,startIndex,count];
        }
        
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            CoGroupModel *groupModel=[self getModelFromFM:resultSet];
            [result addObject:groupModel];
        }
        [resultSet close];
    }];
    return result;
}


/**
 *  我管理的列表(搜索)
 *
 *  @param oid      企业ID
 
 *
 *  @return 群组
 */
-(NSMutableArray *)SearchMyChargeGroupWithOid:(NSString *)oid Search:(NSString*)searchStr{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    //NSString *curuid=[[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
    [[self getDbQuene:@"co_group" FunctionName:@"SearchMyChargeGroupWithOid:(NSString *)oid Search:(NSString*)searchStr"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid From co_group Where gid in (select cid from co_manage Where oid=%@ AND type='group') AND state=1 AND bind_oid is null AND name like '%%%@%%' ",oid,searchStr];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            CoGroupModel *groupModel=[self getModelFromFM:resultSet];
            [result addObject:groupModel];
        }
        [resultSet close];
    }];
    return result;
}
/**
 *  我的加入的列表
 *
 *  @param oid      组织ID
 *  @param startIndex  起始ID 没有传0
 *  @param count    数量
 *
 *  @return 群组
 */
-(NSMutableArray *)getMyJoinGroupWithOid:(NSString *)oid StartIndex:(NSString*)startIndex Count:(NSInteger)count{
    
    //select top 20 from co_group where id < xxxxxx
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"co_group" FunctionName:@"getMyJoinGroupWithOid:(NSString *)oid StartIndex:(NSString*)startIndex Count:(NSInteger)count"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql;
        
        if ([startIndex isEqualToString:@"1"]) {
            sql=[NSString stringWithFormat:@"Select cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid From co_group Where coid=%@ AND bind_oid is null AND state=1 ORDER BY name asc limit 0,%ld",oid,count];
            
        }else{
            
            sql=[NSString stringWithFormat:@"Select cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid From co_group Where coid=%@ AND bind_oid is null AND state=1 and joinindex > (select  joinindex From co_group where gid =%@) ORDER BY name asc limit 0,%ld",oid,startIndex,count];

        }
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            CoGroupModel *groupModel=[self getModelFromFM:resultSet];
            [result addObject:groupModel];
        }
        [resultSet close];
    }];
    return result;
}

/**
 *  我加入的列表(搜索)
 *
 *  @param oid      企业ID
 
 *
 *  @return 群组
 */
-(NSMutableArray *)SearchMyJoinGroupWithOid:(NSString *)oid Search:(NSString*)searchStr{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"co_group" FunctionName:@"SearchMyJoinGroupWithOid:(NSString *)oid Search:(NSString*)searchStr"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid From co_group Where coid=%@  AND state=1 AND bind_oid is null AND name like '%%%@%%' ",oid,searchStr];
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            CoGroupModel *groupModel=[self getModelFromFM:resultSet];
            [result addObject:groupModel];
        }
        [resultSet close];
    }];
    return result;
}

-(NSMutableArray*)getGroupAllDataOid:(NSString*)oid{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"co_group" FunctionName:@"getGroupAllDataOid:(NSString*)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid"" From co_group Where coid=%@ ",oid];

        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            CoGroupModel *groupModel=[self getModelFromFM:resultSet];
            [result addObject:groupModel];
        }
        [resultSet close];
    }];
    return result;
}

/**
 *  获取组织全部列表
 *
 *  @param oid      组织ID
 *  @return 群组
 */
-(NSMutableArray*)getOrganizationDataOid:(NSString*)oid{
	NSMutableArray *result = [[NSMutableArray alloc] init];
	[[self getDbQuene:@"co_group" FunctionName:@"getOrganizationDataOid:(NSString*)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		NSString *sql=[NSString stringWithFormat:@"Select cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid"" From co_group Where coid=%@ AND bind_oid is not null",oid];
		
		FMResultSet *resultSet=[db executeQuery:sql];
		while ([resultSet next]) {
			CoGroupModel *groupModel=[self getModelFromFM:resultSet];
			[result addObject:groupModel];
		}
        [resultSet close];
	}];
	return result;
}

/**
 *  关闭群组列表
 *
 *  @param oid      组织ID
 *  @param startIndex  起始ID 没有传0
 *  @param count    数量
 *  @return 群组
 */
-(NSMutableArray*)getGroupCloseDataOid:(NSString*)oid StartIndex:(NSString*)startIndex Count:(NSInteger)count{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"co_group" FunctionName:@"getGroupCloseDataOid:(NSString*)oid StartIndex:(NSString*)startIndex Count:(NSInteger)count"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql;
        if ([startIndex isEqualToString:@"1"]) {
           sql=[NSString stringWithFormat:@"Select cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid"" From co_group Where coid=%@ AND state=0 AND bind_oid is null ORDER BY name asc limit 0,%ld",oid,count];

        }else{
            sql=[NSString stringWithFormat:@"Select cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid From co_group  Where coid=%@ AND state=0 AND bind_oid is null and closeindex > (select  closeindex From co_group where gid =%@) ORDER BY name asc limit 0,%ld",oid,startIndex,count];

        }
        
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            CoGroupModel *groupModel=[self getModelFromFM:resultSet];
            [result addObject:groupModel];
        }
        [resultSet close];
    }];
    return result;
}

/**
 *  关闭群组列表(搜索)
 *
 *  @param oid      企业ID
 *  @return 群组
 */
-(NSMutableArray*)SearchGroupCloseDataOid:(NSString*)oid Serach:(NSString*)searchStr{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"co_group" FunctionName:@"SearchGroupCloseDataOid:(NSString*)oid Serach:(NSString*)searchStr"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid"" From co_group Where coid=%@ AND state=0 AND bind_oid is null AND name like '%%%@%%' ",oid,searchStr];

        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            CoGroupModel *groupModel=[self getModelFromFM:resultSet];
            [result addObject:groupModel];
        }
        [resultSet close];
    }];
    return result;
}


-(NSMutableArray*)getSearchGroupAllDataOid:(NSString*)oid Name:(NSString*)name{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSString *str=[NSString stringWithFormat:@"%%%@%%",name];
    [[self getDbQuene:@"co_group" FunctionName:@"getSearchGroupAllDataOid:(NSString*)oid Name:(NSString*)name"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid"" From co_group Where name like '%@' AND coid=%@ AND bind_oid is null",str,oid];
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            CoGroupModel *groupModel=[self getModelFromFM:resultSet];
            [result addObject:groupModel];
        }
        [resultSet close];
    }];
    
    return result;
}

-(CoGroupModel*)getDataGroupModelGid:(NSString*)gid{
    
   __block CoGroupModel *groupModel ;
    
    [[self getDbQuene:@"co_group" FunctionName:@"getDataGroupModelGid:(NSString*)gid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select cid,oid,createuname,createuser,des,gcode,logo,gid,ruid,name,lockuser,createdate,lockdate,isgroup,state,needauditing,resourceid,superadminid,currentusertype,memberslength,bind_oid,coid,isfavorites"" From co_group Where gid=%@ ",gid];
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            groupModel=[self getModelFromFM:resultSet];
        }
        [resultSet close];
    }];
    return groupModel;
}

#pragma mark 内部转模型
-(CoGroupModel*)getModelFromFM:(FMResultSet*)resultSet{
    
    NSString *oid = [resultSet stringForColumn:@"oid"];
    NSString *cid = [resultSet stringForColumn:@"cid"];
    NSString *createuname = [resultSet stringForColumn:@"createuname"];
    NSString *createuser = [resultSet stringForColumn:@"createuser"];
    NSString *des = [resultSet stringForColumn:@"des"];
    NSString *gcode = [resultSet stringForColumn:@"gcode"];
    NSString *logo = [resultSet stringForColumn:@"logo"];
    NSString *gid =[resultSet stringForColumn:@"gid"];
    NSString *ruid = [resultSet stringForColumn:@"ruid"];
    NSString *name = [resultSet stringForColumn:@"name"];
    NSString *lockuser = [resultSet stringForColumn:@"lockuser"];
    NSString *resourceid=[resultSet stringForColumn:@"resourceid"];
    NSString *coid=[resultSet stringForColumn:@"coid"];
    NSString *bind_oid=[resultSet stringForColumn:@"bind_oid"];
    NSString *superadminid = [resultSet stringForColumn:@"superadminid"];
    
    NSDate *createdate = [resultSet dateForColumn:@"createdate"];
    NSDate *lockdate = [resultSet dateForColumn:@"lockdate"];
    
    NSInteger isgroup = [resultSet intForColumn:@"isgroup"];
    NSInteger state = [resultSet intForColumn:@"state"];
    NSInteger needauditing=[resultSet intForColumn:@"needauditing"];
    NSInteger currentusertype = [resultSet intForColumn:@"currentusertype"];;
    NSInteger memberslength = [resultSet intForColumn:@"memberslength"];;
	
	BOOL isfavorites = [resultSet boolForColumn:@"isfavorites"];
	
	
    CoGroupModel *groupModel = [[CoGroupModel alloc] init];
    groupModel.cid = cid;
    groupModel.createuname = createuname;
    groupModel.createuser = createuser;
    groupModel.des  = des;
    groupModel.gcode = gcode;
    groupModel.logo = logo;
    groupModel.gid = gid;
    groupModel.ruid = ruid;
    groupModel.name = name;
    groupModel.lockuser = lockuser;
    groupModel.createtime = createdate;
    groupModel.lockdate = lockdate;
    groupModel.isgroup = isgroup;
    groupModel.state = state;
    groupModel.needauditing=needauditing;
    groupModel.resourceid=resourceid;
    groupModel.oid=oid;
    groupModel.superadminid=superadminid;
    groupModel.currentusertype=currentusertype;
    groupModel.memberslength=memberslength;
    groupModel.bind_oid=bind_oid;
    groupModel.coid=coid;
	groupModel.isfavorites = isfavorites;
    return groupModel;
}
@end
