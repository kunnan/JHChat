//
//  CoMemberDAL.m
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 成员数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "CoMemberDAL.h"
#import "UserDAL.h"
#import "AppDateUtil.h"

@implementation CoMemberDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoMemberDAL *)shareInstance{
    static CoMemberDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[CoMemberDAL alloc] init];
    }
    return instance;
}

/**
 *  创建表
 */
-(void)createCoMemberTableIfNotExists
{
    NSString *tableName = @"co_member";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[mid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[addtime] [date] NULL,"
                                         "[cid] [varchar](50) NULL,"
                                         "[cuid] [varchar](50) NULL,"
                                         "[deptname] [varchar](300) NULL,"
                                         "[des] [text] NULL,"
                                         "[did] [text] NULL,"
                                         "[face] [text] NULL,"
                                         "[jiancheng] [text] NULL,"
                                         "[oid] [varchar](50) NULL,"
                                         "[orgname] [varchar](300) NULL,"
                                         "[quancheng] [text] NULL,"
                                         "[uname] [varchar](300) NULL,"
                                         "[uid] [varchar](50) NULL,"
                                         "[type] [integer] NULL,"
                                         "[isvalid] [integer] NULL,"
                                         "[utype] [integer] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateCoMemberTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}

-(void)addDataWithArray:(NSMutableArray *)memberArray{
    
	[[self getDbQuene:@"co_member" FunctionName:@"addDataWithArray:(NSMutableArray *)memberArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO co_member(mid,cid,cuid,deptname,des,did,face,jiancheng,oid,orgname,quancheng,addtime,uname,type,utype,uid,isvalid)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        for (int i = 0; i< memberArray.count;  i++) {
            CoMemberModel *memberModel = [memberArray objectAtIndex:i];
            
            NSString *mid = memberModel.mid;
            NSString *cid = memberModel.cid;
            NSString *cuid = memberModel.cuid;
            NSString *deptname = memberModel.deptname;
            NSString *des = memberModel.des;
            NSString *did = memberModel.did;
            NSString *face = memberModel.face;
            NSString *jiancheng = memberModel.jiancheng;
            NSString *oid = memberModel.oid;
            NSString *orgname = memberModel.orgname;
            NSString *quancheng = memberModel.quancheng;
            NSDate *addtime = memberModel.addtime;
            NSString *uname=memberModel.uname;
            NSNumber *type = [NSNumber numberWithInteger:memberModel.type];
            NSNumber *utype = [NSNumber numberWithInteger:memberModel.utype];
            NSString *uid = memberModel.uid;
            NSNumber *isvalid=[NSNumber numberWithInteger:memberModel.isvalid];

            isOK = [db executeUpdate:sql,mid,cid,cuid,deptname,des,did,face,jiancheng,oid,orgname,quancheng,addtime,uname,type,utype,uid,isvalid];

            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_member" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
        
    }];
    
}
/**
 *  批量添加数据(去重)
 */
-(void)addfilterDataWithArray:(NSMutableArray *)memberArray{
    
    
	[[self getDbQuene:@"co_member" FunctionName:@"addfilterDataWithArray:(NSMutableArray *)memberArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO co_member(mid,cid,cuid,deptname,des,did,face,jiancheng,oid,orgname,quancheng,addtime,uname,type,utype,uid,isvalid)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        for (int i = 0; i< memberArray.count;  i++) {
            CoMemberModel *memberModel = [memberArray objectAtIndex:i];
            
            BOOL isExist =false;

            NSString *sql1=[NSString stringWithFormat:@"Select mid From co_member Where cid=%@ AND uid=%@ ",memberModel.cid,memberModel.uid];
                FMResultSet *resultSet=[db executeQuery:sql1];
                
                while ([resultSet next]) {
                    
                    isExist=true;
                }
    
            if (isExist) {
               continue ;
            }
            
            NSString *mid = memberModel.mid;
            NSString *cid = memberModel.cid;
            NSString *cuid = memberModel.cuid;
            NSString *deptname = memberModel.deptname;
            NSString *des = memberModel.des;
            NSString *did = memberModel.did;
            NSString *face = memberModel.face;
            NSString *jiancheng = memberModel.jiancheng;
            NSString *oid = memberModel.oid;
            NSString *orgname = memberModel.orgname;
            NSString *quancheng = memberModel.quancheng;
            NSDate *addtime = memberModel.addtime;
            NSString *uname=memberModel.uname;
            NSNumber *type = [NSNumber numberWithInteger:memberModel.type];
            NSNumber *utype = [NSNumber numberWithInteger:memberModel.utype];
            NSString *uid = memberModel.uid;
            NSNumber *isvalid=[NSNumber numberWithInteger:memberModel.isvalid];

            isOK = [db executeUpdate:sql,mid,cid,cuid,deptname,des,did,face,jiancheng,oid,orgname,quancheng,addtime,uname,type,utype,uid,isvalid];
            
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_member" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
        
    }];
    
}
-(void)addModel:(CoMemberModel *)memberModel{
    
	[[self getDbQuene:@"co_member" FunctionName:@"addModel:(CoMemberModel *)memberModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *mid = memberModel.mid;
        NSString *cid = memberModel.cid;
        NSString *cuid = memberModel.cuid;
        NSString *deptname = memberModel.deptname;
        NSString *des = memberModel.des;
        NSString *did = memberModel.did;
        NSString *face = memberModel.face;
        NSString *jiancheng = memberModel.jiancheng;
        NSString *oid = memberModel.oid;
        NSString *orgname = memberModel.orgname;
        NSString *quancheng = memberModel.quancheng;
        NSDate *addtime = memberModel.addtime;
        NSString *uname=memberModel.uname;
        NSNumber *type = [NSNumber numberWithInteger:memberModel.type];
        NSNumber *utype = [NSNumber numberWithInteger:memberModel.utype];
        NSString *uid = memberModel.uid;
        NSNumber *isvalid=[NSNumber numberWithInteger:memberModel.isvalid];
        
        NSString *sql = @"INSERT OR REPLACE INTO co_member(mid,cid,cuid,deptname,des,did,face,jiancheng,oid,orgname,quancheng,addtime,uname,type,utype,uid,isvalid)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,mid,cid,cuid,deptname,des,did,face,jiancheng,oid,orgname,quancheng,addtime,uname,type,utype,uid,isvalid];
        if (!isOK) {
            DDLogError(@"插入失败");
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_member" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
    

}

/**
 *  批量添加添加成员数据  废弃
 */
-(void)addOriginCooperationID:(NSString*)cid DataWithArray:(NSMutableArray *)memberArray{
    
    NSMutableArray *mArr=[NSMutableArray array];
    for (NSDictionary *dict in memberArray) {
        
        NSString *uid=[dict objectForKey:@"invitedid"];
        UserModel *uModel=[[UserDAL shareInstance]getUserDataWithUid:uid];
        
        CoMemberModel *cModel=[[CoMemberModel alloc]init];
        cModel.mid = [LZUtils CreateGUID];
        cModel.cid=cid;
        cModel.uid=uid;
        cModel.cuid = uid;
        cModel.deptname =nil;
        cModel.des = nil;
        cModel.did = nil;
        cModel.face = uModel.face;
        cModel.jiancheng = uModel.jiancheng;
        cModel.oid = nil;
        cModel.orgname =nil;
        cModel.quancheng = uModel.quancheng;
        cModel.addtime = [AppDateUtil GetCurrentDate];
        cModel.uname=uModel.username;
        cModel.type = 2;
        cModel.utype = CoParticipant;
        cModel.isvalid=0;
        [mArr addObject:cModel];
        
    }
    
    [self addDataWithArray:mArr];
}

#pragma mark  更新数据

/**
 *  更新成员状态
 *
 *  @param cid      协作ID
 *  @param uid      用户ID
 *  @param isvalid  是否通过
 *  @return CoMemberModel 模型数组
 */
-(void)upDataMemberValidCooperationId:(NSString*)cid Uid:(NSString*)uid Isvalid:(BOOL)isvalid{
    
    NSNumber *Isvalid=[NSNumber numberWithBool:isvalid];
    
	[[self getDbQuene:@"co_member" FunctionName:@"upDataMemberValidCooperationId:(NSString*)cid Uid:(NSString*)uid Isvalid:(BOOL)isvalid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_member set isvalid=?Where cid=? AND uid=?";
        isOK = [db executeUpdate:sql,Isvalid,cid,uid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_member" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
        
    } ];

}
/**
 *  更新成员身份
 *
 *  @param cid      协作ID
 *  @param uid      用户ID
 *  @param utype    身份 1 管理员
 *  @return CoMemberModel 模型数组
 */
-(void)upDataMemberUtypeCooperationId:(NSString*)cid Uid:(NSString*)uid Utype:(NSInteger)utype{
    
    NSNumber *Utype=[NSNumber numberWithInteger:utype];
    
	[[self getDbQuene:@"co_member" FunctionName:@"upDataMemberUtypeCooperationId:(NSString*)cid Uid:(NSString*)uid Utype:(NSInteger)utype"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_member set utype=?Where cid=? AND uid=?";
        isOK = [db executeUpdate:sql,Utype,cid,uid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_member" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
        
    } ];
}

/**
 *  更新成员身份 (任务 之前管理员信息设置为0)
 *
 *  @param cid      协作ID
 *  @param uid      用户ID
 *  @param utype    身份 1 管理员
  
 */
-(void)upDataMemberUtypeCooperationTaskId:(NSString*)cid Uid:(NSString*)uid Utype:(NSInteger)utype{
    
    [[self getDbQuene:@"co_member" FunctionName:@""] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_member set utype=? Where cid=? AND utype=4";
        isOK = [db executeUpdate:sql,[NSNumber numberWithInteger:CoParticipant],cid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_member" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
        
    } ];

    
    NSNumber *Utype=[NSNumber numberWithInteger:utype];
    [[self getDbQuene:@"co_member" FunctionName:@"upDataMemberUtypeCooperationTaskId:(NSString*)cid Uid:(NSString*)uid Utype:(NSInteger)utype"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_member set utype=?Where cid=? AND uid=?";
        isOK = [db executeUpdate:sql,Utype,cid,uid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_member" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
        
    } ];

}

/**
 *  更新企业用户当前身份
 *
 *  @param cid 协作ID
 *  @param uid 用户ID
 *  @param oid 组织ID
 *  @param did 部门ID
 */
-(void)UpDataMemberCompanyCooperationId:(NSString*)cid Uid:(NSString*)uid Oid:(NSString*)oid OrgName:(NSString*)orgname Did:(NSString*)did DepName:(NSString*)depname{
    
    [[self getDbQuene:@"co_member" FunctionName:@"UpDataMemberCompanyCooperationId:(NSString*)cid Uid:(NSString*)uid Oid:(NSString*)oid OrgName:(NSString*)orgname Did:(NSString*)did DepName:(NSString*)depname"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_member set oid=?,orgname=?, did=?, deptname=? Where cid=? AND uid=?";
        isOK = [db executeUpdate:sql,oid,orgname,did,depname,cid,uid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_member" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
        
    } ];

    
}
#pragma mark 删除
-(void)deleteMemberId:(NSString *)mid{
    
    [[self getDbQuene:@"co_member" FunctionName:@"deleteMemberId:(NSString *)mid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_member where mid=?";
        isOK = [db executeUpdate:sql,mid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_member" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}

/**
 *  删除协作所有成员
 *
 *  @param
 */
-(void)deleteCooperationId:(NSString *)cid{
    [[self getDbQuene:@"co_member" FunctionName:@"deleteCooperationId:(NSString *)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_member where cid=?";
        isOK = [db executeUpdate:sql,cid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_member" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}

/**
 *  删除协作所有成员(去除自己)
 *
 *  @param
 */
-(void)deleteUnMyCooperationId:(NSString *)cid {
    NSString *uid = [[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"uid"];
    [[self getDbQuene:@"co_member" FunctionName:@"deleteUnMyCooperationId:(NSString *)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_member where cid=? AND uid != ?";
        isOK = [db executeUpdate:sql,cid,uid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_member" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
    
}

/**
 *  删除协作成员
 *  cid 协作ID
 *  uid 成员ID
 *  @param
 */
-(void)deleteMemberCooperationId:(NSString *)cid Uid:(NSString*)uid{
    
	[[self getDbQuene:@"co_member" FunctionName:@"deleteMemberCooperationId:(NSString *)cid Uid:(NSString*)uid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_member where cid=? AND uid=?";
        isOK = [db executeUpdate:sql,cid,uid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_member" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}

-(NSMutableArray *)getGroupMemberWithOid:(NSString *)oid GroupID:(NSString*)gid{
    
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"co_member" FunctionName:@"getGroupMemberWithOid:(NSString *)oid GroupID:(NSString*)gid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select* From co_member Where oid=%@ AND cid=%@ AND utype!=3",oid,gid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            CoMemberModel *memberModel = nil;
            
            memberModel=[self getModelFromFM:resultSet];

            [result addObject:memberModel];

        }
        [resultSet close];
    }];
    
    return result;

}
/**
 *  协作成员(没处理过的)
 *
 *  @param cid      协作ID
 *
 *  @return CoMemberModel 模型数组
 */
-(NSMutableArray *)getCooMemberWithCID:(NSString*)cid{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"co_member" FunctionName:@"getCooMemberWithCID:(NSString*)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select* From co_member Where cid=%@ AND utype=4 order by addtime asc",cid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            CoMemberModel *memberModel = nil;
            memberModel=[self getModelFromFM:resultSet];
            [result addObject:memberModel];
        }
        [resultSet close];
        
        NSString *sql2=[NSString stringWithFormat:@"Select* From co_member Where cid=%@ AND utype=1 order by addtime asc",cid];
        FMResultSet *resultSet2=[db executeQuery:sql2];
        while ([resultSet2 next]) {
            CoMemberModel *memberModel = nil;
            memberModel=[self getModelFromFM:resultSet2];
            [result addObject:memberModel];
        }
        [resultSet2 close];
        
//        NSString *sql4=[NSString stringWithFormat:@"Select* From co_member Where cid=%@ AND utype=3 order by addtime asc",cid];
//        FMResultSet *resultSet4=[db executeQuery:sql4];
//        while ([resultSet4 next]) {
//            CoMemberModel *memberModel = [[CoMemberModel alloc] init];
//            memberModel=[self getModelFromFM:resultSet4];
//            [result addObject:memberModel];
//        }

        NSString *sql3=[NSString stringWithFormat:@"Select* From co_member Where cid=%@ AND utype=2 order by isvalid desc,addtime asc",cid];
        
        FMResultSet *resultSet3=[db executeQuery:sql3];
        while ([resultSet3 next]) {
            CoMemberModel *memberModel = nil;
            memberModel=[self getModelFromFM:resultSet3];
            [result addObject:memberModel];
        }
        [resultSet3 close];

    }];
    
    return result;
}

/**
 *  协作管理员数组
 *
 *  @param cid      协作ID
 *
 *  @return CoMemberModel 模型数组
 */
-(NSMutableArray *)getCooAdminsWithCID:(NSString*)cid{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"co_member" FunctionName:@"getCooAdminsWithCID:(NSString*)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select* From co_member Where cid=%@ AND utype=4 order by addtime asc",cid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            CoMemberModel *memberModel = nil;
            memberModel=[self getModelFromFM:resultSet];
            [result addObject:memberModel];
        }
        [resultSet close];
        
        NSString *sql2=[NSString stringWithFormat:@"Select* From co_member Where cid=%@ AND utype=1 order by addtime asc",cid];
        FMResultSet *resultSet2=[db executeQuery:sql2];
        while ([resultSet2 next]) {
            CoMemberModel *memberModel = nil;
            memberModel=[self getModelFromFM:resultSet2];
            [result addObject:memberModel];
        }
        [resultSet2 close];
    }];
    
    return result;
}


/**
 *  协作激活管理员数组
 *
 *  @param cid      协作ID
 *
 *  @return CoMemberModel 模型数组
 */
-(NSMutableArray *)getCooActiveAdminsWithCID:(NSString*)cid{
	
	NSMutableArray *result = [[NSMutableArray alloc] init];
	[[self getDbQuene:@"co_member" FunctionName:@"getCooActiveAdminsWithCID:(NSString*)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		NSString *sql=[NSString stringWithFormat:@"Select* From co_member Where cid=%@ AND utype=4 order by addtime asc",cid];
		FMResultSet *resultSet=[db executeQuery:sql];
		while ([resultSet next]) {
			CoMemberModel *memberModel = nil;
			memberModel=[self getModelFromFM:resultSet];
			[result addObject:memberModel];
		}
        [resultSet close];
        
		NSString *sql2=[NSString stringWithFormat:@"Select* From co_member Where cid=%@ AND utype=1 AND isvalid==1 order by addtime asc",cid];
		FMResultSet *resultSet2=[db executeQuery:sql2];
		while ([resultSet2 next]) {
			CoMemberModel *memberModel = nil;
			memberModel=[self getModelFromFM:resultSet2];
			[result addObject:memberModel];
		}
        [resultSet2 close];
	}];
	
	return result;
}

/**
 *  协作普通管理员id数组
 *
 *  @param cid      协作ID
 *
 *  @return CoMemberModel 模型数组
 */
-(NSMutableArray *)getCooAdminsUidWithCID:(NSString*)cid{
	
	NSMutableArray *result = [[NSMutableArray alloc] init];
	[[self getDbQuene:@"co_member" FunctionName:@"getCooAdminsUidWithCID:(NSString*)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
	
		NSString *sql2=[NSString stringWithFormat:@"Select* From co_member Where cid=%@ AND utype=1 order by addtime asc",cid];
		FMResultSet *resultSet2=[db executeQuery:sql2];
		while ([resultSet2 next]) {
			CoMemberModel *memberModel = nil;
			memberModel=[self getModelFromFM:resultSet2];
			[result addObject:memberModel.uid];
		}
        [resultSet2 close];
	}];
	
	return result;
}


/**
 *  协作普通成员数组
 *
 *  @param cid      协作ID
 *
 *  @return CoMemberModel 模型数组
 */
-(NSMutableArray *)getCooCommonsWithCID:(NSString*)cid{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"co_member" FunctionName:@"getCooCommonsWithCID:(NSString*)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
//        NSString *sql4=[NSString stringWithFormat:@"Select* From co_member Where cid=%@ AND utype=3 order by addtime asc",cid];
//        FMResultSet *resultSet4=[db executeQuery:sql4];
//        while ([resultSet4 next]) {
//            CoMemberModel *memberModel = [[CoMemberModel alloc] init];
//            memberModel=[self getModelFromFM:resultSet4];
//            [result addObject:memberModel];
//        }
        
        NSString *sql3=[NSString stringWithFormat:@"Select* From co_member Where cid=%@ AND utype=2 order by isvalid desc,addtime asc",cid];
        
        FMResultSet *resultSet3=[db executeQuery:sql3];
        while ([resultSet3 next]) {
            CoMemberModel *memberModel = nil;
            memberModel=[self getModelFromFM:resultSet3];
            [result addObject:memberModel];
        }
        [resultSet3 close];
        
    }];
    
    return result;
}

/**
 *  协作通过普通成员数组
 *
 *  @param cid      协作ID
 *
 *  @return CoMemberModel 模型数组
 */
-(NSMutableArray *)getCooValidCommonsWithCID:(NSString*)cid{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"co_member" FunctionName:@"getCooValidCommonsWithCID:(NSString*)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        
        NSString *sql3=[NSString stringWithFormat:@"Select* From co_member Where cid=%@ AND utype=2 AND isvalid>0 order by addtime asc",cid];
        
        FMResultSet *resultSet3=[db executeQuery:sql3];
        while ([resultSet3 next]) {
            CoMemberModel *memberModel = nil;
            memberModel=[self getModelFromFM:resultSet3];
            [result addObject:memberModel];
        }
        [resultSet3 close];
        
    }];
    
    return result;

}

/**
 *  协作激活普通成员数组
 *
 *  @param cid      协作ID
 *
 *  @return CoMemberModel 模型数组
 */
-(NSMutableArray *)getCooActiveCommonsWithCID:(NSString*)cid{
	
	NSMutableArray *result = [[NSMutableArray alloc] init];
	[[self getDbQuene:@"co_member" FunctionName:@"getCooActiveCommonsWithCID:(NSString*)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		
		
		NSString *sql3=[NSString stringWithFormat:@"Select* From co_member Where cid=%@ AND utype=2 AND isvalid==1 order by addtime asc",cid];
		
		FMResultSet *resultSet3=[db executeQuery:sql3];
		while ([resultSet3 next]) {
			CoMemberModel *memberModel = nil;
			memberModel=[self getModelFromFM:resultSet3];
			[result addObject:memberModel];
		}
        [resultSet3 close];
		
	}];
	
	return result;
	
}

/**
 *  搜索协作成员
 *
 *  @param cid    协作ID
 *  @param search 搜索名称
 *
 *  @return CoMemberModel 模型数组
 */
-(NSMutableArray *)getSearchCooMemberCid:(NSString*)cid Search:(NSString*)search{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[self getDbQuene:@"co_member" FunctionName:@"getSearchCooMemberCid:(NSString*)cid Search:(NSString*)search"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select* From co_member Where cid=%@ AND utype=4 AND uname like '%%%@%%' order by addtime asc",cid,search];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            CoMemberModel *memberModel = nil;
            memberModel=[self getModelFromFM:resultSet];
            [result addObject:memberModel];
        }
        [resultSet close];
        
        NSString *sql2=[NSString stringWithFormat:@"Select* From co_member Where cid=%@ AND utype=1 AND uname like '%%%@%%' order by addtime asc",cid,search];
        FMResultSet *resultSet2=[db executeQuery:sql2];
        while ([resultSet2 next]) {
            CoMemberModel *memberModel = nil;
            memberModel=[self getModelFromFM:resultSet2];
            [result addObject:memberModel];
        }
        [resultSet2 close];
        
//        NSString *sql4=[NSString stringWithFormat:@"Select* From co_member Where cid=%@ AND utype=3 AND uname like '%%%@%%' order by addtime asc",cid,search];
//        FMResultSet *resultSet4=[db executeQuery:sql4];
//        while ([resultSet4 next]) {
//            CoMemberModel *memberModel = [[CoMemberModel alloc] init];
//            memberModel=[self getModelFromFM:resultSet4];
//            [result addObject:memberModel];
//        }
        
        NSString *sql3=[NSString stringWithFormat:@"Select* From co_member Where cid=%@ AND utype=2 AND uname like '%%%@%%' order by isvalid desc,addtime asc",cid,search];
        
        FMResultSet *resultSet3=[db executeQuery:sql3];
        while ([resultSet3 next]) {
            CoMemberModel *memberModel = nil;
            memberModel=[self getModelFromFM:resultSet3];
            [result addObject:memberModel];
        }
        [resultSet3 close];
        
    }];
    
    return result;
}
/**
 *  得到管理员
 *
 *  @param cid      协作ID
 *
 *  @return CoMemberModel 模型数组
 */

-(CoMemberModel *)getCooChargeWithCID:(NSString*)cid{
   
    __block CoMemberModel *memberModel ;
    
    [[self getDbQuene:@"co_member" FunctionName:@"getCooChargeWithCID:(NSString*)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select* From co_member Where cid=%@ AND utype=4",cid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
           memberModel=[self getModelFromFM:resultSet];
            
        }
        [resultSet close];
    }];

    return memberModel;
    
}

/**
 *  得到个人信息
 *
 *  @param mid      成员mid
 *
 *  @return CoMemberModel 模型数组
 */
-(CoMemberModel *)getMemberData:(NSString*)mid{

    __block CoMemberModel *memberModel ;
    [[self getDbQuene:@"co_member" FunctionName:@"getMemberData:(NSString*)mid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select* From co_member Where mid=%@ ",mid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            memberModel=[self getModelFromFM:resultSet];
        }
        [resultSet close];
    }];
    
    return memberModel;

}

/**
 *  得到个人信息
 *
 *  @param uid      成员id
 *
 *  @return CoMemberModel 模型数组
 */
-(CoMemberModel *)getMemberDataUid:(NSString*)uid Cid:(NSString*)cid{
    
    __block CoMemberModel *memberModel ;
    [[self getDbQuene:@"co_member" FunctionName:@"getMemberDataUid:(NSString*)uid Cid:(NSString*)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select* From co_member Where uid=%@ AND cid=%@",uid,cid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            memberModel=[self getModelFromFM:resultSet];
        }
        [resultSet close];
    }];
    
    return memberModel;
    
}
/**
 *  得到协作个人信息
 *
 *  @param id  成员id
 *  @param cid  协作id
 *  @return CoMemberModel 模型数组
 */
-(CoMemberModel *)getCooperation:(NSString*)cid MemberData:(NSString*)mid{
    __block CoMemberModel *memberModel ;
    [[self getDbQuene:@"co_member" FunctionName:@"getCooperation:(NSString*)cid MemberData:(NSString*)mid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select* From co_member Where uid=%@ AND cid=%@",mid,cid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            memberModel=[self getModelFromFM:resultSet];
        }
        [resultSet close];
    }];
    
    return memberModel;

}


/**
 *  得到个人信息
 *
 *  @param uid  成员用户ID
 *  @param pid  父任务ID
 
 *  @return CoMemberModel 模型数组
 */
-(BOOL)isExistParantTask:(NSString*)pid Uid:(NSString*)uid{
    
    __block BOOL isExist = NO;
    if (pid && [pid length]!=0) {
        
        [[self getDbQuene:@"co_member" FunctionName:@"isExistParantTask:(NSString*)pid Uid:(NSString*)uid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql=[NSString stringWithFormat:@"Select mid From co_member Where cid=%@ AND uid=%@ AND utype!=2",pid,uid];
            FMResultSet *resultSet=[db executeQuery:sql];
            while ([resultSet next]) {
    
                isExist=YES;
                
            }
            [resultSet close];
        }];

        
    }
    
    return isExist;
}

/**
 *  是否存成员
 *
 *  @return CoMemberModel 模型数组
 */
-(BOOL)isExistCooperation:(NSString*)cid Uid:(NSString*)uid{
    
    __block BOOL isExist = NO;
    
    if (cid && [cid length]!=0) {
        
		[[self getDbQuene:@"co_member" FunctionName:@"isExistCooperation:(NSString*)cid Uid:(NSString*)uid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql=[NSString stringWithFormat:@"Select mid From co_member Where cid=%@ AND uid=%@ AND utype!=3",cid,uid];
            FMResultSet *resultSet=[db executeQuery:sql];
            while ([resultSet next]) {
                
                isExist=YES;
                
            }
            [resultSet close];
        }];
        
        
    }
    
    return isExist;
    
}
#pragma mark 得到成员列表

-(NSMutableDictionary*)getCooHandleMembersWithCID:(NSString *)cid{
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    NSMutableArray *indexArr=[NSMutableArray array];
    
    //非管理员 首字母
    [[self getDbQuene:@"co_member" FunctionName:@"getCooHandleMembersWithCID:(NSString *)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select DISTINCT SUBSTR(ifnull (quancheng,'#'),1,1)a  From co_member Where cid=%@ AND utype!=1 AND utype!=4 AND utype!=3 order by a desc ",cid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            NSString *a = [[resultSet stringForColumn:@"a"] uppercaseString];
            a = [AppUtils getRightFirstChar:a];
            
            NSMutableArray *array=[NSMutableArray array];
            [result setObject:array forKey:a];
            if ([a isEqualToString:@"#"]) {
				if(indexArr.count>0){
					NSString *lastIndex = [indexArr lastObject];
					if ([lastIndex isEqualToString:@"#"]) {
						
					}else{
						[indexArr addObject:a];

					}
				}
				else{
					[indexArr addObject:a];
				}
            }else{
                [indexArr insertObject:a atIndex:0];
            }
        
            //[indexArr addObject:a];
        }
        [resultSet close];
    }];
    [result setObject:[NSMutableArray array] forKey:LZGDCommonLocailzableString(@"message_admin")];
    NSLog(@"%@",indexArr);
    
    [[self getDbQuene:@"co_member" FunctionName:@"getCooHandleMembersWithCID:(NSString *)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select SUBSTR(ifnull (quancheng,'#'),1,1)a,*  From co_member  Where cid=%@ order by quancheng asc ",cid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            NSString *a = [[resultSet stringForColumn:@"a"] uppercaseString];
            a = [AppUtils getRightFirstChar:a];
            
            CoMemberModel *memberModel = nil;
            memberModel=[self getModelFromFM:resultSet];
            if(memberModel.utype==CoAdministrator||memberModel.utype==CoSuperadministrator){
                NSMutableArray *arr=[result objectForKey:LZGDCommonLocailzableString(@"message_admin")];
                [arr addObject:memberModel];
                [result setObject:arr forKey:LZGDCommonLocailzableString(@"message_admin")];

            }else{
                NSMutableArray *arr=[result objectForKey:a];
                [arr addObject:memberModel];
                [result setObject:arr forKey:a];

            }
            
            
        }
        [resultSet close];
    }];
    [result setObject:indexArr forKey:@"index"];
    return result;
}


#pragma mark 得到任务成员列表

-(NSMutableDictionary*)getCooHandleTaskMembersWithCID:(NSString *)cid{
	
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	NSMutableArray *indexArr=[NSMutableArray array];
	
	//非管理员 首字母
	[[self getDbQuene:@"co_member" FunctionName:@"getCooHandleTaskMembersWithCID:(NSString *)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		NSString *sql=[NSString stringWithFormat:@"Select DISTINCT SUBSTR(ifnull (quancheng,'#'),1,1)a  From co_member Where cid=%@ AND utype!=1 AND utype!=4 AND utype!=3 order by a desc ",cid];
		FMResultSet *resultSet=[db executeQuery:sql];
		while ([resultSet next]) {
			NSString *a = [[resultSet stringForColumn:@"a"] uppercaseString];
			a = [AppUtils getRightFirstChar:a];
			
			NSMutableArray *array=[NSMutableArray array];
			[result setObject:array forKey:a];
			if ([a isEqualToString:@"#"]) {
				if(indexArr.count>0){
					NSString *lastIndex = [indexArr lastObject];
					if ([lastIndex isEqualToString:@"#"]) {
						
					}else{
						[indexArr addObject:a];
						
					}
				}
				else{
					[indexArr addObject:a];
				}
			}else{
				[indexArr insertObject:a atIndex:0];
			}
			
			//[indexArr addObject:a];
		}
        [resultSet close];
    }];
	[result setObject:[NSMutableArray array] forKey:@"任务负责人"];
	NSLog(@"%@",indexArr);
	
	[[self getDbQuene:@"co_member" FunctionName:@"getCooHandleTaskMembersWithCID:(NSString *)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		NSString *sql=[NSString stringWithFormat:@"Select SUBSTR(ifnull (quancheng,'#'),1,1)a,*  From co_member  Where cid=%@ order by quancheng asc ",cid];
		FMResultSet *resultSet=[db executeQuery:sql];
		while ([resultSet next]) {
			NSString *a = [[resultSet stringForColumn:@"a"] uppercaseString];
			a = [AppUtils getRightFirstChar:a];
			
			CoMemberModel *memberModel = nil;
			memberModel=[self getModelFromFM:resultSet];
			if(memberModel.utype==CoAdministrator){
				NSMutableArray *arr=[result objectForKey:LZGDCommonLocailzableString(@"message_admin")];
				if(!arr){
					arr = [NSMutableArray array];
					[indexArr insertObject:LZGDCommonLocailzableString(@"message_admin") atIndex:0];
				}
				[arr addObject:memberModel];
				[result setObject:arr forKey:LZGDCommonLocailzableString(@"message_admin")];
				
			}else if (memberModel.utype==CoSuperadministrator){
				NSMutableArray *arr=[result objectForKey:@"任务负责人"];
				[arr addObject:memberModel];
				[result setObject:arr forKey:@"任务负责人"];

			}
			else{
				NSMutableArray *arr=[result objectForKey:a];
				[arr addObject:memberModel];
				[result setObject:arr forKey:a];
				
			}
			
			
		}
        [resultSet close];
    }];
	[result setObject:indexArr forKey:@"index"];
	return result;
}

/**
 *  得到协作已通过成员
 *
 *  @param cid 协作ID
 *
 *  @return 处理后的成员（A,B）
 */
-(NSMutableDictionary*)getCooExistMembersWithCID:(NSString *)cid{
	
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    NSMutableArray *indexArr=[NSMutableArray array];
	
    //非管理员 首字母
    [[self getDbQuene:@"co_member" FunctionName:@"getCooExistMembersWithCID:(NSString *)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select DISTINCT SUBSTR(ifnull (quancheng,'#'),1,1)a  From co_member Where cid=%@ AND utype!=1 AND utype!=4 AND utype!=3 AND isvalid=1 order by a desc ",cid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            NSString *a = [[resultSet stringForColumn:@"a"] uppercaseString];
            a = [AppUtils getRightFirstChar:a];
            
            NSMutableArray *array=[NSMutableArray array];
            [result setObject:array forKey:a];
            if ([a isEqualToString:@"#"]) {
				if(indexArr.count>0){
					NSString *lastIndex = [indexArr lastObject];
					if ([lastIndex isEqualToString:@"#"]) {
						
					}else{
						[indexArr addObject:a];
						
					}
				}
				else{
					[indexArr addObject:a];
				}
            }else{
                [indexArr insertObject:a atIndex:0];
            }
            
            //[indexArr addObject:a];
        }
        [resultSet close];
    }];
    [result setObject:[NSMutableArray array] forKey:LZGDCommonLocailzableString(@"message_admin")];
    NSLog(@"%@",indexArr);
    
    [[self getDbQuene:@"co_member" FunctionName:@"getCooExistMembersWithCID:(NSString *)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select SUBSTR(ifnull (quancheng,'#'),1,1)a,*  From co_member  Where cid=%@ AND isvalid=1 order by quancheng asc ",cid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            NSString *a = [[resultSet stringForColumn:@"a"] uppercaseString];
            a = [AppUtils getRightFirstChar:a];
            
            CoMemberModel *memberModel = nil;
            memberModel=[self getModelFromFM:resultSet];
            if(memberModel.utype==CoAdministrator||memberModel.utype==CoSuperadministrator){
                NSMutableArray *arr=[result objectForKey:LZGDCommonLocailzableString(@"message_admin")];
                [arr addObject:memberModel];
                [result setObject:arr forKey:LZGDCommonLocailzableString(@"message_admin")];
                
            }else{
                NSMutableArray *arr=[result objectForKey:a];
                [arr addObject:memberModel];
                [result setObject:arr forKey:a];
                
            }
            
            
        }
        [resultSet close];
    }];
    [result setObject:indexArr forKey:@"index"];
    return result;
}

//得到除去管理员的数据 (没使用)
-(NSMutableDictionary*)getCooHandleMembersRemoveAdmWithCID:(NSString *)cid AdminID:(NSString *)aid{
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    [[self getDbQuene:@"co_member" FunctionName:@"getCooHandleMembersRemoveAdmWithCID:(NSString *)cid AdminID:(NSString *)aid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select DISTINCT SUBSTR(ifnull (quancheng,'#'),1,1)a  From co_member Where cid=%@ AND uid=%@ order by a asc ",cid,aid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            NSString *a = [[resultSet stringForColumn:@"a"] uppercaseString];
            a = [AppUtils getRightFirstChar:a];
            
            NSMutableArray *array=[NSMutableArray array];
            [result setObject:array forKey:a];
            
        }
        [resultSet close];
    }];
    
    [[self getDbQuene:@"co_member" FunctionName:@"getCooHandleMembersRemoveAdmWithCID:(NSString *)cid AdminID:(NSString *)aid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select SUBSTR(ifnull (quancheng,'#'),1,1)a,*  From co_member  Where cid=%@ AND uid=%@ order by a asc ",cid,aid];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {            
            NSString *a = [[resultSet stringForColumn:@"a"] uppercaseString];
            a = [AppUtils getRightFirstChar:a];
            
            CoMemberModel *memberModel = nil; //[[CoMemberModel alloc] init];
            memberModel=[self getModelFromFM:resultSet];
            NSMutableArray *arr=[result objectForKey:a];
            [arr addObject:memberModel];
            [result setObject:arr forKey:a];
            
            
        }
        [resultSet close];
    }];
    
    return result;
}

#pragma mark 内部
// 数据库转模型
-(CoMemberModel*)getModelFromFM:(FMResultSet*)resultSet{
    
    NSString *mid = [resultSet stringForColumn:@"mid"];
    NSString *cid = [resultSet stringForColumn:@"cid"];
    NSString *cuid = [resultSet stringForColumn:@"cuid"];
    NSString *des = [resultSet stringForColumn:@"des"];
    NSString *deptname = [resultSet stringForColumn:@"deptname"];
    NSString *did = [resultSet stringForColumn:@"did"];
    NSString *face =[resultSet stringForColumn:@"face"];
    NSString *jiancheng = [resultSet stringForColumn:@"jiancheng"];
    NSString *oid = [resultSet stringForColumn:@"oid"];
    NSString *orgname = [resultSet stringForColumn:@"orgname"];
    NSString *quancheng = [resultSet stringForColumn:@"quancheng"];
    NSString *uname = [resultSet stringForColumn:@"uname"];
    NSString *uid = [resultSet stringForColumn:@"uid"];
    NSDate *addtime = [resultSet dateForColumn:@"addtime"];
    NSInteger type = [resultSet intForColumn:@"type"];
    NSInteger utype = [resultSet intForColumn:@"utype"];
    NSInteger isvalid =[resultSet intForColumn:@"isvalid"];
    
    CoMemberModel *memberModel = [[CoMemberModel alloc] init];
    memberModel.mid = mid;
    memberModel.cid = cid;
    memberModel.cuid = cuid;
    memberModel.des  = des;
    memberModel.deptname = deptname;
    memberModel.did = did;
    memberModel.face = face;
    memberModel.jiancheng = jiancheng;
    memberModel.oid = oid;
    memberModel.orgname = orgname;
    memberModel.quancheng = quancheng;
    memberModel.uname = uname;
    memberModel.uid = uid;
    memberModel.addtime = addtime;
    memberModel.type=type;
    memberModel.utype=utype;
    memberModel.isvalid=isvalid;
    return memberModel;
}

@end
