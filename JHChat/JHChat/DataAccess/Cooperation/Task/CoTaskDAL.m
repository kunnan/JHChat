
//
//  CoTaskDAL.m
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 任务数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "CoTaskDAL.h"
#import "CoMemberDAL.h"
#import "CoManageDAL.h"
#import "CoTaskTransferDAL.h"
#import "TagDataModel.h"
#import "CoTaskRelatedModel.h"

@implementation CoTaskDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoTaskDAL *)shareInstance{
    static CoTaskDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[CoTaskDAL alloc] init];
    }
    return instance;
}

/**
 *  创建表
 */
-(void)createCoTaskTableIfNotExists
{
    NSString *tableName = @"co_task";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[cid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[tid] [varchar](50) NULL,"
                                         "[createdate] [date] NULL,"
                                         "[createuname] [varchar](300) NULL,"
                                         "[createuser] [varchar](50) NULL,"
                                         "[dep] [varchar](50) NULL,"
                                         "[deptname] [varchar](300) NULL,"
                                         "[des] [text] NULL,"
                                         "[enddate] [date] NULL,"
                                         "[ruid] [varchar](50) NULL,"
                                         "[englishname] [varchar](300) NULL,"
                                         "[pid] [varchar](50) NULL,"
                                         "[plandate] [date] NULL,"
                                         "[lockdate] [date] NULL,"
                                         "[lockuser] [varchar](50) NULL,"
                                         "[logo] [varchar](500) NULL,"
                                         "[name] [varchar](300) NULL,"
                                         "[oid] [varchar](50) NULL,"
                                         "[istask] [integer] NULL,"
                                         "[resourceid] [varchar](50) NULL,"
                                         "[isfavorites] [integer] NULL,"
                                         "[finishcount] [integer] NULL,"
                                         "[state] [integer] NULL,"
                                         "[memberslength] [integer] NULL,"
                                         "[count] [integer] NULL,"
                                         "[adminid] [varchar](50) NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateCoTaskTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
                 case 21:{
                [self AddColumnToTableIfNotExist:@"co_task" columnName:@"[rootname]" type:@"[varchar](300)"];
                [self AddColumnToTableIfNotExist:@"co_task" columnName:@"[pname]" type:@"[varchar](300)"];
                [self AddColumnToTableIfNotExist:@"co_task" columnName:@"[rootid]" type:@"[varchar](50)"];
               
                break;
                 }
			case 73:{
				[self AddColumnToTableIfNotExist:@"co_task" columnName:@"[tcode]" type:@"[varchar](50)"];
				[self AddColumnToTableIfNotExist:@"co_task" columnName:@"[needauditing]" type:@"[integer]"];

				break;
			}
                
        }
    }
}
#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)taskArray{
    
    [[self getDbQuene:@"co_task" FunctionName:@"addDataWithArray:(NSMutableArray *)taskArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql;
		
        for (int i = 0; i< taskArray.count;  i++) {
            CoTaskModel *taskModel = [taskArray objectAtIndex:i];
            
            NSString *cid = taskModel.cid;
            NSString *tid = taskModel.tid;
            NSDate *createdate=taskModel.createdate;
            NSString *createuname=taskModel.createuname;
            NSString *createuser=taskModel.createuser;
            NSString *dep=taskModel.dep;
            NSString *deptname=taskModel.deptname;
            NSString *des=taskModel.des;
            NSDate *enddate=taskModel.enddate;
            NSString *englishname=taskModel.englishname;
            NSString *ruid=taskModel.ruid;
            NSDate *plandate=taskModel.plandate;
            NSString *pid=taskModel.pid;
            NSDate *lockdate=taskModel.lockdate;
            NSString *lockuser=taskModel.lockuser;
            NSString *logo=taskModel.logo;
            NSString *name=taskModel.name;
            NSString *oid=taskModel.oid;
            NSString *resourceid=taskModel.resourceid;
            NSString *adminid=taskModel.adminid;
            
            NSNumber *istask=[NSNumber numberWithInteger:taskModel.istask];
            NSNumber *finishcount=[NSNumber numberWithInteger:taskModel.finishcount];
            NSNumber *state=[NSNumber numberWithInteger:taskModel.state];
            NSNumber *count=[NSNumber numberWithInteger:taskModel.count];
            NSNumber *isfavorites=[NSNumber numberWithInteger:taskModel.isfavorites];
            NSNumber *memberslength=[NSNumber numberWithInteger:taskModel.memberslength];
            
            NSString *rootid=taskModel.rootid;
            NSString *rootname=taskModel.rootname;
            NSString *pname=taskModel.pname;
			NSString *tcode = taskModel.tcode;
			NSNumber *needauditing = [NSNumber numberWithBool:taskModel.needauditing];
			
            
            sql = @"INSERT OR REPLACE INTO co_task(cid,tid,createdate,createuname,createuser,dep,deptname,des,enddate,englishname,ruid,plandate,pid,lockdate,lockuser,logo,name,oid,resourceid,istask,finishcount,state,count,isfavorites,memberslength,adminid,rootid,rootname,pname,tcode,needauditing)"
            "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            isOK = [db executeUpdate:sql,cid,tid,createdate,createuname,createuser,dep,deptname,des,enddate,englishname,ruid,plandate,pid,lockdate,lockuser,logo,name,oid,resourceid,istask,finishcount,state,count,isfavorites,memberslength,adminid,rootid,rootname,pname,tcode,needauditing];
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
        
    }];
}

/**
 *  添加单条数据
 */
-(void)addTaskModel:(CoTaskModel *)taskModel{
    
    [[self getDbQuene:@"co_task" FunctionName:@"addTaskModel:(CoTaskModel *)taskModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *cid = taskModel.cid;
        NSString *tid = taskModel.tid;
        NSDate *createdate=taskModel.createdate;
        NSString *createuname=taskModel.createuname;
        NSString *createuser=taskModel.createuser;
        NSString *dep=taskModel.dep;
        NSString *deptname=taskModel.deptname;
        NSString *des=taskModel.des;
        NSDate *enddate=taskModel.enddate;
        NSString *englishname=taskModel.englishname;
        NSString *ruid=taskModel.ruid;
        NSDate *plandate=taskModel.plandate;
        NSString *pid=taskModel.pid;
        NSDate *lockdate=taskModel.lockdate;
        NSString *lockuser=taskModel.lockuser;
        NSString *logo=taskModel.logo;
        NSString *name=taskModel.name;
        NSString *oid=taskModel.oid;
        NSString *resourceid=taskModel.resourceid;
        NSString *adminid=taskModel.adminid;
        NSNumber *istask=[NSNumber numberWithInteger:taskModel.istask];
        NSNumber *finishcount=[NSNumber numberWithInteger:taskModel.finishcount];
        NSNumber *state=[NSNumber numberWithInteger:taskModel.state];
        NSNumber *count=[NSNumber numberWithInteger:taskModel.count];
        NSNumber *isfavorites=[NSNumber numberWithInteger:taskModel.isfavorites];
        NSNumber *memberslength=[NSNumber numberWithInteger:taskModel.memberslength];
        
        NSString *rootid=taskModel.rootid;
        NSString *rootname=taskModel.rootname;
        NSString *pname=taskModel.pname;
		NSString *tcode = taskModel.tcode;
		
		NSNumber *needauditing = [NSNumber numberWithBool:taskModel.needauditing];
		
        NSString *sql = @"INSERT OR REPLACE INTO co_task(cid,tid,createdate,createuname,createuser,dep,deptname,des,enddate,englishname,ruid,plandate,pid,lockdate,lockuser,logo,name,oid,resourceid,istask,finishcount,state,count,isfavorites,memberslength,adminid,rootid,rootname,pname,tcode,needauditing)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,cid,tid,createdate,createuname,createuser,dep,deptname,des,enddate,englishname,ruid,plandate,pid,lockdate,lockuser,logo,name,oid,resourceid,istask,finishcount,state,count,isfavorites,memberslength,adminid,rootid,rootname,pname,tcode,needauditing];
        if (!isOK) {
            DDLogError(@"插入失败");
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];

}

#pragma mark - 删除数据

/**
 *  根据id删除任务
 *
 *  @param
 */
-(void)deleteOid:(NSString*)oid Taskid:(NSString *)tid{
    
    [[self getDbQuene:@"co_task" FunctionName:@"deleteOid:(NSString*)oid Taskid:(NSString *)tid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_task where tid=? AND oid=?";
        isOK = [db executeUpdate:sql,tid,oid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}
/**
 *  根据id删除任务
 *
 *  @param
 */
-(void)deleteTaskid:(NSString *)tid{
    
    
    [[self getDbQuene:@"co_task" FunctionName:@"deleteTaskid:(NSString *)tid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_task where tid=?";
        isOK = [db executeUpdate:sql,tid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}

-(void)deleteAllTaskDataOid:(NSString*)oid{
    
    [[self getDbQuene:@"co_task" FunctionName:@"deleteAllTaskDataOid:(NSString*)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_task where oid=?";
        isOK = [db executeUpdate:sql,oid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
}
/**
 *  删除我参与的任务
 *
 *  @param
 */
-(void)deleteMyJoinTaskDataOid:(NSString*)oid{
    
    [[self getDbQuene:@"co_task" FunctionName:@"deleteMyJoinTaskDataOid:(NSString*)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_task where oid=? AND state != 1 AND state !=3";
        isOK = [db executeUpdate:sql,oid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}

/**
 *  删除我负责的任务 ok
 *
 *  @param
 */
-(void)deleteMyChargeTaskDataOid:(NSString*)oid{
    
    [[self getDbQuene:@"co_task"FunctionName:@"deleteMyChargeTaskDataOid:(NSString*)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_task Where tid in (select cid from co_manage Where oid=? AND type='task')";
        isOK = [db executeUpdate:sql,oid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
    [[CoManageDAL shareInstance]deleteMangeOid:oid type:@"task"];
}

/**
 *  删除星标任务
 *
 *  @param
 */
-(void)deleteStarTaskDataOid:(NSString*)oid{
 
    [[self getDbQuene:@"co_task" FunctionName:@"deleteStarTaskDataOid:(NSString*)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_task where oid=? AND isfavorites=1";
        isOK = [db executeUpdate:sql,oid];
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
}

/**
 *  删除完成任务
 *
 *  @param
 */
-(void)deleteFinishTaskDataOid:(NSString*)oid{
    
    [[self getDbQuene:@"co_task" FunctionName:@"deleteFinishTaskDataOid:(NSString*)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_task where oid=? AND state=3";
        isOK = [db executeUpdate:sql,oid];
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
}
/**
 *  删除我托付的任务
 *
 *  @param
 */
-(void)deleteMyTransferTaskDataOid:(NSString*)oid{
    
    [[self getDbQuene:@"co_task" FunctionName:@"deleteMyTransferTaskDataOid:(NSString*)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_task Where tid in (select tid from co_task_transfer Where oid=?)";
        isOK = [db executeUpdate:sql,oid];
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
    
    [[CoTaskTransferDAL shareInstance]deleteTransferOid:oid];
    
}

/**
 *  删除废弃任务
 *
 *  @param
 */
-(void)deleteAbandonTaskDataOid:(NSString*)oid{
    
    [[self getDbQuene:@"co_task" FunctionName:@"deleteAbandonTaskDataOid:(NSString*)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_task where oid=? AND state=4";
        isOK = [db executeUpdate:sql,oid];
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
}


/**
 *  删除未发布的任务
 *
 *  @param
 */
-(void)deleteUnpublishTaskDataOid:(NSString*)oid{
    
    [[self getDbQuene:@"co_task" FunctionName:@"deleteUnpublishTaskDataOid:(NSString*)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_task where oid=? AND state=1";
        isOK = [db executeUpdate:sql,oid];
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];
}

/**
 *  删除子任务
 *
 *  @param
 */
-(void)deleteAllChildTaskTid:(NSString*)tid{
    
    [[self getDbQuene:@"co_task" FunctionName:@"deleteAllChildTaskTid:(NSString*)tid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from co_task where pid=?";
        isOK = [db executeUpdate:sql,tid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
    }];

}

#pragma mark - 修改数据



/**
 修改任务状态
 *  @param tid      任务ID
 *  @param state    任务状态
 */
-(void)updateTaskStateTid:(NSString *)tid withState:(NSInteger)state{
    
    NSNumber *stat=[NSNumber numberWithInteger:state];
    [[self getDbQuene:@"co_task" FunctionName:@"updateTaskStateTid:(NSString *)tid withState:(NSInteger)state"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_task set state=? Where tid=?";
        isOK = [db executeUpdate:sql,stat,tid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
        
    } ];

}

/**
 修改任务计划时间
 *  @param tid      任务ID
 *  @param plandate    任务状态
 */
-(void)updateTaskPlanDateTid:(NSString *)tid withDate:(NSDate*)plandate{
    
    [[self getDbQuene:@"co_task" FunctionName:@"updateTaskPlanDateTid:(NSString *)tid withDate:(NSDate*)plandate"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_task set plandate=? Where tid=?";
        isOK = [db executeUpdate:sql,plandate,tid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
        
    } ];
}

/**
 修改任务名称
 *  @param tid      任务ID
 *  @param name     任务名称
 */
-(void)updateTaskNameTid:(NSString *)tid withName:(NSString*)name{
    
    [[self getDbQuene:@"co_task" FunctionName:@"updateTaskNameTid:(NSString *)tid withName:(NSString*)name"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_task set name=? Where tid=?";
        isOK = [db executeUpdate:sql,name,tid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
        
    } ];

}

/**
 修改任务所在企业
 *  @param tid      任务ID
 *  @param oid      任务所在企业
 */
-(void)updateTaskCompanyTid:(NSString *)tid Oid:(NSString*)oid{
    
    [[self getDbQuene:@"co_task" FunctionName:@"updateTaskCompanyTid:(NSString *)tid Oid:(NSString*)oid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_task set oid=? Where tid=?";
        isOK = [db executeUpdate:sql,oid,tid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
        
    } ];
}

/**
 *  更改任务的父任务
 *
 *  @param tid 任务ID
 *  @param pid 父任务ID
 */
-(void)updataTaskParentTid:(NSString*)tid Pid:(NSString*)pid{
    
    [[self getDbQuene:@"co_task" FunctionName:@"updataTaskParentTid:(NSString*)tid Pid:(NSString*)pid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_task set pid=? Where tid=?";
        isOK = [db executeUpdate:sql,pid,tid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
        
    } ];

}

/**
 *  更改任务的描述
 *
 *  @param tid 任务ID
 *  @param des 任务描述
 */
-(void)updataTaskDescribeTid:(NSString*)tid Des:(NSString*)des{
    
    [[self getDbQuene:@"co_task" FunctionName:@"updataTaskDescribeTid:(NSString*)tid Des:(NSString*)des"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_task set des=? Where tid=?";
        isOK = [db executeUpdate:sql,des,tid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
        
    } ];
}

/**
 *  更改任务的收藏
 *
 *  @param tid 任务ID
 *  @param isfavorites 任务收藏状态
 */
-(void)updataTaskFavoriteTid:(NSString*)tid Isfavorites:(NSInteger)isfavorites{
	
	NSNumber *favorites = [NSNumber numberWithInteger:isfavorites];
	
	[[self getDbQuene:@"co_task" FunctionName:@"updataTaskFavoriteTid:(NSString*)tid Isfavorites:(NSInteger)isfavorites"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = NO;
		NSString *sql = @"update co_task set isfavorites=? Where tid=?";
		isOK = [db executeUpdate:sql,favorites,tid];
		
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"更新失败" Other:nil];

			DDLogError(@"更新失败 - updateMsgId");
		}
		
	} ];
}

/**
 *  更改任务的锁定
 *
 *  @param tid 任务ID
 *  @param des 任务描述
 */
-(void)updataTaskLock:(NSString*)tid LockUser:(NSString*)lockUser{
    
    [[self getDbQuene:@"co_task" FunctionName:@"updataTaskLock:(NSString*)tid LockUser:(NSString*)lockUser"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_task set lockuser=? Where tid=?";
        isOK = [db executeUpdate:sql,lockUser,tid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
        
    } ];
}


/**
 *  更改任务成员数量
 *
 *  @param tid 任务ID
 *  @param mlength 任务成员数量
 */
-(void)updataTaskMemberCount:(NSString*)tid MemberLength:(NSInteger)mlength{
    
    NSNumber *memberslength = [NSNumber numberWithInteger:mlength];
    
    [[self getDbQuene:@"co_task" FunctionName:@"updataTaskMemberCount:(NSString*)tid MemberLength:(NSInteger)mlength"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"update co_task set memberslength=? Where tid=?";
        isOK = [db executeUpdate:sql,memberslength,tid];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"更新失败" Other:nil];

            DDLogError(@"更新失败 - updateMsgId");
        }
        
    } ];
}


/**
 修改任务加入权限
 *  @param tid        任务ID
 *  @param isApply    权限
 */
-(void)updateTaskId:(NSString *)tid withTaskApplyroot:(NSNumber *)isApply{
	
	[[self getDbQuene:@"co_task" FunctionName:@"updateTaskId:(NSString *)tid withTaskApplyroot:(NSNumber *)isApply"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
		BOOL isOK = NO;
		NSString *sql = @"update co_task set needauditing=? Where cid=?";
		isOK = [db executeUpdate:sql,isApply,tid];
		
		if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"co_task" Sql:sql Error:@"更新失败" Other:nil];

			DDLogError(@"更新失败 - updateMsgId");
		}
	} ];
	
}
#pragma mark - 查询数据

-(CoTaskModel*)getDataTaskModelTid:(NSString*)tid{
    
   __block CoTaskModel *model=[[CoTaskModel alloc]init];
    
    [[self getDbQuene:@"co_task" FunctionName:@"getDataTaskModelTid:(NSString*)tid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select* From co_task Where tid=%@",tid];
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            model = [self getModelFromFM:resultSet];
            // 管理员头像
            NSString *sql1=[NSString stringWithFormat:@"Select face From co_member Where cid=%@ AND utype=1" ,model.tid];
            FMResultSet *faceSet=[db executeQuery:sql1];
            while ([faceSet next]) {
                NSString *face = [faceSet stringForColumn:@"face"];
                model.face=face;
                
            }
            [faceSet close];
        }
        [resultSet close];
    }];
    
    return model;

    
}
-(CoTaskModel*)getDataTaskModelCid:(NSString*)Cid{
    
    __block CoTaskModel *model=[[CoTaskModel alloc]init];
    
    [[self getDbQuene:@"co_task" FunctionName:@"getDataTaskModelCid:(NSString*)Cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select* From co_task Where Cid=%@",Cid];
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            model = [self getModelFromFM:resultSet];
            // 管理员头像
            NSString *sql1=[NSString stringWithFormat:@"Select face From co_member Where cid=%@ AND utype=1" ,model.tid];
            FMResultSet *faceSet=[db executeQuery:sql1];
            while ([faceSet next]) {
                NSString *face = [faceSet stringForColumn:@"face"];
                model.face=face;
                
            }
            [faceSet close];
        }
        [resultSet close];
    }];
    
    return model;
    
    
}

/**
 子任务
 *  @param uid      任务ID
 *  @param origin   起始位置
 *  @param count    数量 20
 
 */
-(NSMutableArray*)getChildTaskID:(NSString*)taskID{
    NSMutableArray *taskArr=[NSMutableArray array];
    
    
    [[self getDbQuene:@"co_task" FunctionName:@"getChildTaskID:(NSString*)taskID"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_task Where pid=%@ Order by createdate desc",taskID];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            CoTaskModel *taskModel = [self getModelFromFM:resultSet];
            
            // 管理员头像
            NSString *sql1=[NSString stringWithFormat:@"Select face From co_member Where cid=%@ AND utype=1" ,taskModel.tid];
            FMResultSet *faceSet=[db executeQuery:sql1];
            while ([faceSet next]) {
                NSString *face = [faceSet stringForColumn:@"face"];
                taskModel.face=face;
                
            }
            
            [taskArr addObject:taskModel];
            [faceSet close];
        }
        [resultSet close];
    }];
    
    
    return taskArr;
}


/**
 我负责的任务
 *  @param uid      用户ID
 *  @param oid      组织ID
 *  @param origin   起始位置
 *  @param count    数量 20
 
 */
-(NSMutableArray*)getMyChargeUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count{
    
    
    NSMutableArray *taskArr=[NSMutableArray array];
    
    
    [[self getDbQuene:@"co_task" FunctionName:@"getMyChargeUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_task Where tid in (select cid from co_member Where uid=%@ AND utype=1 )Order by createdate desc  limit  %ld,%ld",uid,origin,count];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            CoTaskModel *taskModel = [self getModelFromFM:resultSet];
            // 管理员头像
            NSString *sql1=[NSString stringWithFormat:@"Select face From co_member Where cid=%@ AND utype=1" ,taskModel.tid];
            FMResultSet *faceSet=[db executeQuery:sql1];
            while ([faceSet next]) {
                NSString *face = [faceSet stringForColumn:@"face"];
                taskModel.face=face;

            }

            [taskArr addObject:taskModel];
            [faceSet close];
        }
        [resultSet close];
    }];
    
    
    return taskArr;
}


/**
 我参与的任务
 *  @param uid      用户ID
 *  @param oid      组织ID
 *  @param origin   起始位置
 *  @param count    数量 20
 
 */
-(NSMutableArray*)getMyPartUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count{
    
    NSMutableArray *taskArr=[NSMutableArray array];
    
    
    [[self getDbQuene:@"co_task" FunctionName:@"getMyPartUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_task Where tid in (select cid from co_member Where uid=%@ AND (utype=1 or utype=2))Order by createdate desc  limit  %ld,%ld",uid,origin,count];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            CoTaskModel *taskModel = [self getModelFromFM:resultSet];
            
            // 管理员头像
            NSString *sql1=[NSString stringWithFormat:@"Select face From co_member Where cid=%@ AND utype=1" ,taskModel.tid];
            FMResultSet *faceSet=[db executeQuery:sql1];
            while ([faceSet next]) {
                NSString *face = [faceSet stringForColumn:@"face"];
                taskModel.face=face;
                
            }

            [taskArr addObject:taskModel];
            [faceSet close];
        }
        [resultSet close];
    }];
    
    
    return taskArr;

}


/**
 我观察的任务
 *  @param uid      用户ID
 *  @param oid      组织ID
 *  @param origin   起始位置
 *  @param count    数量 20
 
 */
-(NSMutableArray*)getMyObserveUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count{
    
    NSMutableArray *taskArr=[NSMutableArray array];
    
    
    [[self getDbQuene:@"co_task" FunctionName:@"getMyObserveUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_task Where tid in (select cid from co_member Where oid=%@ AND uid=%@ AND utype=3)Order by createdate desc  limit  %ld,%ld",oid,uid,origin,count];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            CoTaskModel *taskModel = [self getModelFromFM:resultSet];
            
            // 管理员头像
            NSString *sql1=[NSString stringWithFormat:@"Select face From co_member Where cid=%@ AND utype=1" ,taskModel.tid];
            FMResultSet *faceSet=[db executeQuery:sql1];
            while ([faceSet next]) {
                NSString *face = [faceSet stringForColumn:@"face"];
                taskModel.face=face;
                
            }

            [taskArr addObject:taskModel];
            [faceSet close];
        }
        [resultSet close];
    }];
    
    
    return taskArr;

}


/**
 未发布的任务
 *  @param uid      用户ID
 *  @param oid      组织ID
 *  @param origin   起始位置
 *  @param count    数量 20
 
 */
-(NSMutableArray*)getMyUnPublishUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count{
    
    NSMutableArray *taskArr=[NSMutableArray array];
    
    [[self getDbQuene:@"co_task" FunctionName:@"getMyUnPublishUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_task Where oid=%@ AND createuser=%@ AND state=1 Order by createdate desc  limit  %ld,%ld",oid,uid,origin,count];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            CoTaskModel *taskModel = [self getModelFromFM:resultSet];
            // 管理员头像
            NSString *sql1=[NSString stringWithFormat:@"Select face From co_member Where cid=%@ AND utype=1" ,taskModel.tid];
            FMResultSet *faceSet=[db executeQuery:sql1];
            while ([faceSet next]) {
                NSString *face = [faceSet stringForColumn:@"face"];
                taskModel.face=face;
                
            }

            [taskArr addObject:taskModel];
            [faceSet close];
        }
        [resultSet close];
    }];
    
    
    return taskArr;
}


/**
 标星的任务
 *  @param uid      用户ID
 *  @param oid      组织ID
 *  @param origin   起始位置
 *  @param count    数量 20
 
 */
-(NSMutableArray*)getMyStarUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count{
    
    NSMutableArray *taskArr=[NSMutableArray array];
    
    [[self getDbQuene:@"co_task" FunctionName:@"getMyStarUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
          NSString *sql=[NSString stringWithFormat:@"Select * From co_task Where oid=%@ AND createuser=%@ AND isfavorites=1 Order by createdate desc  limit  %ld,%ld",oid,uid,origin,count];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            CoTaskModel *taskModel = [self getModelFromFM:resultSet];
            // 管理员头像
            NSString *sql1=[NSString stringWithFormat:@"Select face From co_member Where cid=%@ AND utype=1" ,taskModel.tid];
            FMResultSet *faceSet=[db executeQuery:sql1];
            while ([faceSet next]) {
                NSString *face = [faceSet stringForColumn:@"face"];
                taskModel.face=face;
            }
            [taskArr addObject:taskModel];
            [faceSet close];
        }
        [resultSet close];
    }];
    
    
    return taskArr;
    

}

/**
 我托付任务
 *  @param uid      用户ID
 *  @param oid      组织ID
 *  @param origin   起始位置
 *  @param count    数量 20
 
 */
-(NSMutableArray*)getMyTransferUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count{
    NSMutableArray *taskArr=[NSMutableArray array];
    
    
    [[self getDbQuene:@"co_task" FunctionName:@"getMyTransferUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
         NSString *sql=[NSString stringWithFormat:@"Select * From co_task Where tid in (select tid from co_task_transfer Where oid=%@ AND uid=%@ )Order by createdate desc  limit  %ld,%ld",oid,uid,origin,count];
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            CoTaskModel *taskModel = [self getModelFromFM:resultSet];
            
            // 管理员头像
            NSString *sql1=[NSString stringWithFormat:@"Select face From co_member Where cid=%@ AND utype=1" ,taskModel.tid];
            FMResultSet *faceSet=[db executeQuery:sql1];
            while ([faceSet next]) {
                NSString *face = [faceSet stringForColumn:@"face"];
                taskModel.face=face;
                
            }

            [taskArr addObject:taskModel];
            [faceSet close];
        }
        [resultSet close];
    }];
    
    
    return taskArr;
}

/**
 完成的任务
 *  @param uid      用户ID
 *  @param oid      组织ID
 *  @param origin   起始位置
 *  @param count    数量 20
 
 */
-(NSMutableArray*)getFinshUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count{
    
    NSMutableArray *taskArr=[NSMutableArray array];

    [[self getDbQuene:@"co_task" FunctionName:@"getFinshUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_task Where oid=%@ AND state=3 Order by createdate desc  limit  %ld,%ld",oid,origin,count];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            CoTaskModel *taskModel = [self getModelFromFM:resultSet];
            
            // 管理员头像
            NSString *sql1=[NSString stringWithFormat:@"Select face From co_member Where cid=%@ AND utype=1" ,taskModel.tid];
            FMResultSet *faceSet=[db executeQuery:sql1];
            while ([faceSet next]) {
                NSString *face = [faceSet stringForColumn:@"face"];
                taskModel.face=face;
                
            }
            
            [taskArr addObject:taskModel];
            [faceSet close];
        }
        [resultSet close];
    }];
    
    
    return taskArr;

}

/**
 废弃的任务
 *  @param uid      用户ID
 *  @param oid      组织ID
 *  @param origin   起始位置
 *  @param count    数量 20
 
 */
-(NSMutableArray*)getAbandonUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count{
    
    NSMutableArray *taskArr=[NSMutableArray array];
    
    [[self getDbQuene:@"co_task" FunctionName:@"getAbandonUid:(NSString*)uid Oid:(NSString*)oid orign:(NSInteger)origin Count:(NSInteger)count"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select * From co_task Where oid=%@ AND state=4 Order by createdate desc  limit  %ld,%ld",oid,origin,count];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            CoTaskModel *taskModel = [self getModelFromFM:resultSet];
            
            // 管理员头像
            NSString *sql1=[NSString stringWithFormat:@"Select face From co_member Where cid=%@ AND utype=1" ,taskModel.tid];
            FMResultSet *faceSet=[db executeQuery:sql1];
            while ([faceSet next]) {
                NSString *face = [faceSet stringForColumn:@"face"];
                taskModel.face=face;
                
            }
            
            [taskArr addObject:taskModel];
            [faceSet close];
        }
        [resultSet close];
    }];
    
    
    return taskArr;
}
/**
 某任务下是否存在父任务
 
 @param cid 协作id
 
 @return return value description
 */
-(BOOL)isHaveParendTaskWithCid:(NSString*)cid{
    
    __block CoTaskModel *model=[[CoTaskModel alloc]init];
    [[self getDbQuene:@"co_task" FunctionName:@"isHaveParendTaskWithCid:(NSString*)cid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select* From co_task Where cid=%@",cid];
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            model = [self getModelFromFM:resultSet];
        }
        [resultSet close];
    }];
    if ([model.pid  isEqual: @"0"] || model.pid == nil) {
        return NO;
    }
    else {
        return YES;
    }
    
}

#pragma mark 内部
// 数据库转模型
-(CoTaskModel*)getModelFromFM:(FMResultSet*)resultSet{
    
    NSString *cid = [resultSet stringForColumn:@"cid"];
    NSString *tid = [resultSet stringForColumn:@"tid"];
    NSDate *createdate=[resultSet dateForColumn:@"createdate"];
    NSString *createuname=[resultSet stringForColumn:@"createuname"];
    NSString *createuser=[resultSet stringForColumn:@"createuser"];
    NSString *dep=[resultSet stringForColumn:@"dep"];
    NSString *deptname=[resultSet stringForColumn:@"deptname"];
    NSString *des=[resultSet stringForColumn:@"des"];
    NSDate *enddate=[resultSet dateForColumn:@"enddate"];
    NSString *englishname=[resultSet stringForColumn:@"englishname"];
    NSString *ruid=[resultSet stringForColumn:@"ruid"];
    NSDate *plandate=[resultSet dateForColumn:@"plandate"];
    NSString *pid=[resultSet stringForColumn:@"pid"];
    NSDate *lockdate=[resultSet dateForColumn:@"lockdate"];;
    NSString *lockuser=[resultSet stringForColumn:@"lockuser"];
    NSString *logo=[resultSet stringForColumn:@"logo"];
    NSString *name=[resultSet stringForColumn:@"name"];
    NSString *oid=[resultSet stringForColumn:@"oid"];
    NSString *resourceid=[resultSet stringForColumn:@"resourceid"];
    NSString *adminid=[resultSet stringForColumn:@"adminid"];
    NSInteger istask=[resultSet intForColumn:@"istask"];
    NSInteger finishcount=[resultSet intForColumn:@"finishcount"];
    NSInteger state=[resultSet intForColumn:@"state"];
    NSInteger count=[resultSet intForColumn:@"count"];
    NSInteger isfavorites=[resultSet intForColumn:@"isfavorites"];
    NSInteger memberslength=[resultSet intForColumn:@"memberslength"];
    
    NSString *rootid=[resultSet stringForColumn:@"rootid"];
    NSString *rootname=[resultSet stringForColumn:@"rootname"];
    NSString *pname=[resultSet stringForColumn:@"pname"];
	NSString *tcode = [resultSet stringForColumn:@"tcode"];
	
	BOOL needauditing = [resultSet boolForColumn:@"needauditing"];
    CoTaskModel *taskModel = [[CoTaskModel alloc] init];
	
    taskModel.cid = cid;
    taskModel.tid=tid;
    taskModel.createdate=createdate;
    taskModel.createuname=createuname;
    taskModel.createuser=createuser;
    taskModel.dep=dep;
    taskModel.deptname=deptname;
    taskModel.des = des;
    
    taskModel.enddate=enddate;
    taskModel.englishname=englishname;
    taskModel.ruid=ruid;
    taskModel.plandate=plandate;
    taskModel.pid=pid;
    taskModel.lockdate=lockdate;
    taskModel.lockuser=lockuser;
    taskModel.logo=logo;
    taskModel.name=name;
    taskModel.oid=oid;
    taskModel.resourceid=resourceid;
    taskModel.istask=istask;
    taskModel.finishcount=finishcount;
    taskModel.state=state;
    taskModel.count=count;
    taskModel.isfavorites=isfavorites;
    taskModel.memberslength=memberslength;
    taskModel.adminid=adminid;
    
    taskModel.rootname = rootname;
    taskModel.rootid = rootid;
    taskModel.pname = pname;
	taskModel.tcode = tcode;
	taskModel.needauditing = needauditing;
	
    return taskModel;
}

-(NSMutableDictionary*)getJeson:(NSString *)tid{
    
    
    __block CoTaskModel *model=[[CoTaskModel alloc]init];
    __block CoTaskModel *pModel=[[CoTaskModel alloc]init];

    __block CoMemberModel *adminsModel = [[CoMemberModel alloc]init];
    __block CoMemberModel *curModel = [[CoMemberModel alloc]init];

    __block CoTaskRelatedModel *relatedModel=[[CoTaskRelatedModel alloc]init];

    __block TagDataModel *tagModel=[[TagDataModel alloc]init];
    
    NSMutableArray *memberArr = [NSMutableArray arrayWithCapacity:5];
    [[self getDbQuene:@"co_task" FunctionName:@"getJeson:(NSString *)tid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"Select* From co_task Where tid=%@",tid];
        
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            model = [self getModelFromFM:resultSet];
            // 管理员头像
            NSString *sql1=[NSString stringWithFormat:@"Select face From co_member Where cid=%@ AND utype=1" ,model.tid];
            FMResultSet *faceSet=[db executeQuery:sql1];
            while ([faceSet next]) {
                NSString *face = [faceSet stringForColumn:@"face"];
                model.face=face;
                
            }
            [faceSet close];
        }
        [resultSet close];
        
        //管理员
        NSString *sql1=[NSString stringWithFormat:@"Select* From co_member Where cid=%@ AND utype=1",tid];
        FMResultSet *resultSet1=[db executeQuery:sql1];
        while ([resultSet1 next]) {
            NSString *mid = [resultSet1 stringForColumn:@"mid"];
            NSString *cid = [resultSet1 stringForColumn:@"cid"];
            NSString *cuid = [resultSet1 stringForColumn:@"cuid"];
            NSString *des = [resultSet1 stringForColumn:@"des"];
            NSString *deptname = [resultSet1 stringForColumn:@"deptname"];
            NSString *did = [resultSet1 stringForColumn:@"did"];
            NSString *face =[resultSet1 stringForColumn:@"face"];
            NSString *jiancheng = [resultSet1 stringForColumn:@"jiancheng"];
            NSString *oid = [resultSet1 stringForColumn:@"oid"];
            NSString *orgname = [resultSet1 stringForColumn:@"orgname"];
            NSString *quancheng = [resultSet1 stringForColumn:@"quancheng"];
            NSString *uname = [resultSet1 stringForColumn:@"uname"];
            NSString *uid = [resultSet1 stringForColumn:@"uid"];
            NSDate *addtime = [resultSet1 dateForColumn:@"addtime"];
            NSInteger type = [resultSet1 intForColumn:@"type"];
            NSInteger utype = [resultSet1 intForColumn:@"utype"];
            NSInteger isvalid =[resultSet1 intForColumn:@"isvalid"];
            
            adminsModel.mid = mid;
            adminsModel.cid = cid;
            adminsModel.cuid = cuid;
            adminsModel.des  = des;
            adminsModel.deptname = deptname;
            adminsModel.did = did;
            adminsModel.face = face;
            adminsModel.jiancheng = jiancheng;
            adminsModel.oid = oid;
            adminsModel.orgname = orgname;
            adminsModel.quancheng = quancheng;
            adminsModel.uname = uname;
            adminsModel.uid = uid;
            adminsModel.addtime = addtime;
            adminsModel.type=type;
            adminsModel.utype=utype;
            adminsModel.isvalid=isvalid;

            
        }
        [resultSet1 close];
        
        NSString *uid = [AppUtils GetCurrentUserID];
        //当前用户
        NSString *sql2=[NSString stringWithFormat:@"Select* From co_member Where cid=%@ AND uid = %@",tid,uid];
        FMResultSet *resultSet2=[db executeQuery:sql2];
        while ([resultSet2 next]) {
            NSString *mid = [resultSet2 stringForColumn:@"mid"];
            NSString *cid = [resultSet2 stringForColumn:@"cid"];
            NSString *cuid = [resultSet2 stringForColumn:@"cuid"];
            NSString *des = [resultSet2 stringForColumn:@"des"];
            NSString *deptname = [resultSet2 stringForColumn:@"deptname"];
            NSString *did = [resultSet2 stringForColumn:@"did"];
            NSString *face =[resultSet2 stringForColumn:@"face"];
            NSString *jiancheng = [resultSet2 stringForColumn:@"jiancheng"];
            NSString *oid = [resultSet2 stringForColumn:@"oid"];
            NSString *orgname = [resultSet2 stringForColumn:@"orgname"];
            NSString *quancheng = [resultSet2 stringForColumn:@"quancheng"];
            NSString *uname = [resultSet2 stringForColumn:@"uname"];
            NSString *uid = [resultSet2 stringForColumn:@"uid"];
            NSDate *addtime = [resultSet2 dateForColumn:@"addtime"];
            NSInteger type = [resultSet2 intForColumn:@"type"];
            NSInteger utype = [resultSet2 intForColumn:@"utype"];
            NSInteger isvalid =[resultSet2 intForColumn:@"isvalid"];
            
            curModel.mid = mid;
            curModel.cid = cid;
            curModel.cuid = cuid;
            curModel.des  = des;
            curModel.deptname = deptname;
            curModel.did = did;
            curModel.face = face;
            curModel.jiancheng = jiancheng;
            curModel.oid = oid;
            curModel.orgname = orgname;
            curModel.quancheng = quancheng;
            curModel.uname = uname;
            curModel.uid = uid;
            curModel.addtime = addtime;
            curModel.type=type;
            curModel.utype=utype;
            curModel.isvalid=isvalid;

        }
        [resultSet2 close];
        
        // 成员
        NSString *sql3=[NSString stringWithFormat:@"Select* From co_member Where cid=%@",tid];
        FMResultSet *resultSet3=[db executeQuery:sql3];
        while ([resultSet3 next]) {
            
            CoMemberModel *memberModel = [[CoMemberModel alloc] init];
            NSString *mid = [resultSet3 stringForColumn:@"mid"];
            NSString *cid = [resultSet3 stringForColumn:@"cid"];
            NSString *cuid = [resultSet3 stringForColumn:@"cuid"];
            NSString *des = [resultSet3 stringForColumn:@"des"];
            NSString *deptname = [resultSet3 stringForColumn:@"deptname"];
            NSString *did = [resultSet3 stringForColumn:@"did"];
            NSString *face =[resultSet3 stringForColumn:@"face"];
            NSString *jiancheng = [resultSet3 stringForColumn:@"jiancheng"];
            NSString *oid = [resultSet3 stringForColumn:@"oid"];
            NSString *orgname = [resultSet3 stringForColumn:@"orgname"];
            NSString *quancheng = [resultSet3 stringForColumn:@"quancheng"];
            NSString *uname = [resultSet3 stringForColumn:@"uname"];
            NSString *uid = [resultSet3 stringForColumn:@"uid"];
            NSDate *addtime = [resultSet3 dateForColumn:@"addtime"];
            NSInteger type = [resultSet3 intForColumn:@"type"];
            NSInteger utype = [resultSet3 intForColumn:@"utype"];
            NSInteger isvalid =[resultSet3 intForColumn:@"isvalid"];
            
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
            NSMutableDictionary *memDic = [memberModel convertModelToDictionary];
            [memDic setObject:[LZFormat Date2String:memberModel.addtime ] forKey:@"addtime"];

            [memberArr addObject:memDic];
            if(memberArr.count >=5){
                break;
            }
            
        }
        [resultSet3 close];
        
        //父任务
        NSString *sql4=[NSString stringWithFormat:@"Select* From co_task Where tid=%@",model.pid];
        FMResultSet *resultSet4=[db executeQuery:sql4];
        while ([resultSet4 next]) {
            
            pModel = [self getModelFromFM:resultSet4];
            // 管理员头像
            NSString *sql1=[NSString stringWithFormat:@"Select face From co_member Where cid=%@ AND utype=1" ,model.tid];
            FMResultSet *faceSet=[db executeQuery:sql1];
            while ([faceSet next]) {
                NSString *face = [faceSet stringForColumn:@"face"];
                pModel.face=face;
                
            }

        }
        [resultSet4 close];
        
        // 关联工作组
        NSString *sql5=[NSString stringWithFormat:@"Select * From co_task_related Where tid=%@ AND coopType=1",tid];
        FMResultSet *resultSet5=[db executeQuery:sql5];
        while ([resultSet5 next]) {
            NSString *keyId = [resultSet5 stringForColumn:@"keyId"];
            NSString *tid = [resultSet5 stringForColumn:@"tid"];
            NSString *relatedname=[resultSet5 stringForColumn:@"relatedname"];
            NSString *relatedid=[resultSet5 stringForColumn:@"relatedid"];
            NSInteger coopType=[resultSet5 intForColumn:@"coopType"];
            
            relatedModel.keyId = keyId;
            relatedModel.tid=tid;
            relatedModel.relatedname=relatedname;
            relatedModel.relatedid=relatedid;
            relatedModel.coopType=coopType;

        }
        [resultSet5 close];
        
        // 关联标签
        NSString *sql6=[NSString stringWithFormat:@"Select * From tag_data Where dataid=%@ ",tid];
        FMResultSet *resultSet6=[db executeQuery:sql6];
        while ([resultSet6 next]) {
            
            tagModel.tdid = [resultSet6 stringForColumn:@"tdid"];
            tagModel.taid = [resultSet6 stringForColumn:@"taid"];
            tagModel.name = [resultSet6 stringForColumn:@"name"];
            tagModel.ttid = [resultSet6 stringForColumn:@"ttid"];
            tagModel.dataid = [resultSet6 stringForColumn:@"dataid"];
            tagModel.oid = [resultSet6 stringForColumn:@"oid"];
            tagModel.uid = [resultSet6 stringForColumn:@"uid"];
            tagModel.dataextend1 = [resultSet6 stringForColumn:@"dataextend1"];
            tagModel.dataextend2 = [resultSet6 stringForColumn:@"dataextend2"];
            tagModel.dataextend3 = [resultSet6 stringForColumn:@"dataextend3"];
            tagModel.createdate = [resultSet6 dateForColumn:@"createdate"];

        }
        [resultSet6 close];
        
    }];
    
    NSMutableDictionary *tasksDic = [model convertModelToDictionary];
   // model.plandate = nil;
    [tasksDic setObject:[LZFormat Date2String:model.plandate ] forKey:@"plandate"];
    [tasksDic setObject:[LZFormat Date2String:model.createdate ] forKey:@"createdate"];
    [tasksDic setObject:[LZFormat Date2String:model.enddate ] forKey:@"enddate"];
    [tasksDic setObject:[LZFormat Date2String:model.lockdate ] forKey:@"lockdate"];

    
    
    
    NSMutableDictionary *adminsDic = [adminsModel convertModelToDictionary];
    [adminsDic setObject:[LZFormat Date2String:adminsModel.addtime ] forKey:@"addtime"];

    [tasksDic setObject:adminsDic forKey:@"admins"];
    
    NSMutableDictionary *currmemberDic = [curModel convertModelToDictionary];
    [currmemberDic setObject:[LZFormat Date2String:curModel.addtime ] forKey:@"addtime"];

    [tasksDic setObject:currmemberDic forKey:@"currmember"];
    
    [tasksDic setObject:memberArr forKey:@"members"];
    
    if (pModel.cid && [pModel.cid length]!=0) {
        
        NSMutableDictionary *parentTaskDic = [pModel convertModelToDictionary];
        [parentTaskDic setObject:[LZFormat Date2String:pModel.plandate ] forKey:@"plandate"];
        [parentTaskDic setObject:[LZFormat Date2String:model.createdate ] forKey:@"createdate"];
        [parentTaskDic setObject:[LZFormat Date2String:model.enddate ] forKey:@"enddate"];
        [parentTaskDic setObject:[LZFormat Date2String:model.lockdate ] forKey:@"lockdate"];
        [tasksDic setObject:parentTaskDic forKey:@"parenttask"];

    }else{
        //[tasksDic setObject:[NSDictionary class] forKey:@"parenttask"];

    }
    
    if (relatedModel.keyId && [relatedModel.keyId length]!=0) {
        NSDictionary *relatrdGroupDic = [relatedModel convertModelToDictionary];
        [tasksDic setObject:relatrdGroupDic forKey:@"relatedgroup"];
        
    }else{
      //  [tasksDic setObject:[NSDictionary class] forKey:@"relatedgroup"];

    }
    
    if (tagModel.tdid && [tagModel.tdid length]!=0) {
        NSMutableDictionary *relatedTagDic = [tagModel convertModelToDictionary];
        [relatedTagDic setObject:[LZFormat Date2String:tagModel.createdate ] forKey:@"createdate"];

        [tasksDic setObject:relatedTagDic forKey:@"relatedtag"];
    }else{
        //[tasksDic setObject:[NSDictionary class] forKey:@"relatedtag"];

    }
    
   
    return tasksDic;
}
@end
