//
//  BusinessSessionRecentDAL.m
//  LeadingCloud
//
//  Created by gjh on 17/4/5.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "BusinessSessionRecentDAL.h"
#import "ImRecentDAL.h"


@implementation BusinessSessionRecentDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(BusinessSessionRecentDAL *)shareInstance
{
    static BusinessSessionRecentDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[BusinessSessionRecentDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createBusinessSessionRecentTableIfNotExists
{
    NSString *tableName = @"businesssession_recents";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[bsguid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[bsiid] [varchar](50) NULL,"
                                         "[bid] [varchar](50) NULL,"
                                         "[bsid] [varchar](50) NULL,"
                                         "[title] [text] NULL,"
                                         "[stype] [integer] NULL,"
                                         "[bstype] [integer] NULL,"
                                         "[bname] [text] NULL,"
                                         "[targetid] [varchar](50) NULL,"
                                         "[ismain] [integer] NULL,"
                                         "[creator] [varchar](100) NULL,"
                                         "[memberCount] [integer] NULL,"
                                         "[instancename] [varchar](100) NULL,"
                                         "[targetorgname] [varchar](100) NULL,"
                                         "[face] [varchar](50) NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateBusinessSessionRecentTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 76:
                [self AddColumnToTableIfNotExist:@"businesssession_recents" columnName:@"[creteusername]" type:@"[varchar](100)"];
                [self AddColumnToTableIfNotExist:@"businesssession_recents" columnName:@"[useabled]" type:@"[integer]"];
                [self AddColumnToTableIfNotExist:@"businesssession_recents" columnName:@"[instance]" type:@"[data]"];
                break;
        }
    }
}

/*
 删除表
 */
-(void)dropTableBusinessSessionRecentAndBusinessSessionRecent1{
    [[self getDbQuene:@"businesssession_recent" FunctionName:@"dropTableBusinessSessionRecentAndBusinessSessionRecent1"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        BOOL isOK = NO;
        NSString *sql = nil;
        /* 判断是否已经创建了此表 */
        if([super checkIsExistsTable:@"businesssession_recent"]){
            sql = @"drop table businesssession_recent";
            [db executeUpdate:sql];
        }
        /* 判断是否已经创建了此表 */
        if([super checkIsExistsTable:@"businesssession_recent1"]){
            sql = @"drop table businesssession_recent1";
            [db executeUpdate:sql];
        }
    }];
    
}
-(void)dropTableBusiness_Session_Recent{
    [[self getDbQuene:@"businesssession_recent" FunctionName:@"dropTableBusiness_Session_Recent"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        /* 判断是否已经创建了此表 */
        if([super checkIsExistsTable:@"business_session_recent"]){
            NSString *sql = @"drop table business_session_recent";
            isOK = [db executeUpdate:sql];
        }
        if (!isOK) {
            DDLogError(@"删除business_session_recent");
        }
    }];
    
}

#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithBusinessSessionRecentArray:(NSMutableArray *)RecentArray{
    [[self getDbQuene:@"businesssession_recent" FunctionName:@"addDataWithBusinessSessionRecentArray:(NSMutableArray *)RecentArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        for (int i = 0; i< RecentArray.count;  i++) {
            BusinessSessionRecentModel *recentModel = [RecentArray objectAtIndex:i];
            
            NSString *bsguid = [LZUtils CreateGUID];
            NSString *bsiid = recentModel.bsiid;
            NSString *title = recentModel.title;
            NSNumber *stype = [NSNumber numberWithInteger:recentModel.stype];
            NSNumber *bstype = [NSNumber numberWithInteger:recentModel.bstype];
            NSString *bname = recentModel.bname;
            NSString *targetid = recentModel.targetid;
            NSNumber *ismain = [NSNumber numberWithInteger:recentModel.ismain];
            NSString *face = recentModel.face;
            NSString *bid = recentModel.bid;
            NSString *bsid = recentModel.bsid;
            NSNumber *memberCount = [NSNumber numberWithInteger:recentModel.memberCount];
            NSString *creator = recentModel.creator;
            NSString *instancename = recentModel.instancename;
            NSString *targetorgname = recentModel.targetorgname;
            NSString *creteusername = recentModel.creteusername;
            NSNumber *useabled = [NSNumber numberWithInteger:recentModel.useabled];
            NSData *instance=[NSJSONSerialization dataWithJSONObject:recentModel.instance options:NSJSONWritingPrettyPrinted error:nil];
            NSString *sql = @"INSERT OR REPLACE INTO businesssession_recents(bsguid,bsiid,title,stype,bstype,bname,targetid,ismain,face,bid,bsid,memberCount,creator,instancename,targetorgname,creteusername,useabled,instance)"
            "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            isOK = [db executeUpdate:sql,bsguid,bsiid,title,stype,bstype,bname,targetid,ismain,face,bid,bsid,memberCount,creator,instancename,targetorgname,creteusername,useabled,instance];
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
}

/**
 *  单条添加
 *
 */
-(void)addDataWithBusinessSessionRecentModel:(BusinessSessionRecentModel*)recentModel{
    
    [[self getDbQuene:@"businesssession_recent" FunctionName:@"addDataWithBusinessSessionRecentModel:(BusinessSessionRecentModel*)recentModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *bsguid = [LZUtils CreateGUID];
        NSString *bsiid = recentModel.bsiid;
        NSString *title = recentModel.title;
        NSNumber *stype = [NSNumber numberWithInteger:recentModel.stype];
        NSNumber *bstype = [NSNumber numberWithInteger:recentModel.bstype];
        NSString *bname = recentModel.bname;
        NSString *targetid = recentModel.targetid;
        NSNumber *ismain = [NSNumber numberWithInteger:recentModel.ismain];
        NSString *face = recentModel.face;
        NSString *bid = recentModel.bid;
        NSString *bsid = recentModel.bsid;
        NSNumber *memberCount = [NSNumber numberWithInteger:recentModel.memberCount];
        NSString *creator = recentModel.creator;
        NSString *instancename = recentModel.instancename;
        NSString *targetorgname = recentModel.targetorgname;
        NSString *creteusername = recentModel.creteusername;
        NSNumber *useabled = [NSNumber numberWithInteger:recentModel.useabled];
        NSData *instance=[NSJSONSerialization dataWithJSONObject:recentModel.instance options:NSJSONWritingPrettyPrinted error:nil];
        NSString *sql = @"INSERT OR REPLACE INTO businesssession_recents(bsguid,bsiid,title,stype,bstype,bname,targetid,ismain,face,bid,bsid,memberCount,creator,instancename,targetorgname,creteusername,useabled,instance)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,bsguid,bsiid,title,stype,bstype,bname,targetid,ismain,face,bid,bsid,memberCount,creator,instancename,targetorgname,creteusername,useabled,instance];
        if (!isOK) {
            DDLogError(@"插入失败");
        }
        
        if (!isOK) {
            *rollback = YES;
            return;
        }
    }];
    
}

#pragma mark - 删除数据

/**
 *  清空所有数据
 */
-(void)deleteAllData{
    [[self getDbQuene:@"businesssession_recent" FunctionName:@"deleteAllData"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"DELETE FROM businesssession_recents"];
    }];
}

#pragma mark - 修改数据


#pragma mark - 查询数据

/**
 *  根据专业类型查询数据
 *
 *  bstype 专业类型
 *  contactid 消息ID
 *  @return 消息列表数组
 */
-(NSMutableArray *)getBusinessSessionRecentWithBstype:(NSInteger )bstype contactid:(NSString *)contactid{
    
    NSMutableArray *targetidArr = [[ImRecentDAL shareInstance]getImRecentContactidWithContactid:contactid];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"businesssession_recent" FunctionName:@"getBusinessSessionRecentWithBstype:(NSInteger )bstype contactid:(NSString *)contactid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for(NSString *targetid in targetidArr){
            NSString *sql = [NSString stringWithFormat:@"select * from businesssession_recents where targetid=%@ and bstype=%ld",targetid,bstype];
//            NSString *sql = [NSString stringWithFormat:@"select * from businesssession_recents where targetid in (SELECT contactid FROM im_recent WHERE contactid like '%@.%%' and parsetype=1 order by lastdate desc) and bstype=%ld",contactid,bstype];
            FMResultSet *resultSet=[db executeQuery:sql];
            while ([resultSet next]) {
                BusinessSessionRecentModel *recentModel = [self convertResultSetToModel:resultSet];
                [result addObject:recentModel];
            }
            [resultSet close];
        }
        
    }];
    return result;
}


/**
 *  获取消息列表选择数据
 *
 *  @return 消息列表数组
 */
-(NSMutableArray *)getBusinessSessionRecentList
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"businesssession_recent" FunctionName:@"getBusinessSessionRecentList"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select * from businesssession_recents Order by lasttime desc"];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            
            BusinessSessionRecentModel *rmModel = [self convertResultSetToModel:resultSet];
//            rmModel.isdisturb = 0;
            
            /* 获取群的总人数 */
//            if(rmModel.contacttype == Chat_ContactType_Main_ChatGroup || rmModel.contacttype == Chat_ContactType_Main_CoGroup){
//                //                NSString *sql= [NSString stringWithFormat:@"select count(0) count from im_group_user Where igid='%@' ",rmModel.contactid];
//                NSString *sql= [NSString stringWithFormat:@"select usercount count from im_group Where igid='%@' ",rmModel.contactid];
//                FMResultSet *groupSet=[db executeQuery:sql];
//                if ([groupSet next]) {
//                    NSInteger count = [groupSet intForColumn:@"count"];
//                    rmModel.usercount = count;
//                }
//            }
            
            [result addObject:rmModel];
        }
        [resultSet close];
    }];
    
    return result;
}

/**
 *  根据targetid获取数据
 *
 *  @return model
 */
-(BusinessSessionRecentModel *)getBusinessSessionRecentWithTargetId:(NSString *)targetid{
    __block BusinessSessionRecentModel *recentModel = nil;
    
    [[self getDbQuene:@"businesssession_recent" FunctionName:@"getBusinessSessionRecentWithTargetId:(NSString *)targetid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql=[NSString stringWithFormat:@"select * from businesssession_recents where targetid=%@",targetid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if ([resultSet next]) {
            recentModel =[self convertResultSetToModel:resultSet];
        }
        [resultSet close];
    }];
    
    return recentModel;
        
}


/**
 *  将FMResultSet转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return ImGroupUserModel
 */
-(BusinessSessionRecentModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    
    NSString *bsguid = [resultSet stringForColumn:@"bsguid"];
    NSString *bsiid = [resultSet stringForColumn:@"bsiid"];
    NSString *title = [resultSet stringForColumn:@"title"];
    NSInteger stype = [resultSet intForColumn:@"stype"];
    NSInteger bstype = [resultSet intForColumn:@"bstype"];
    NSString *bname = [resultSet stringForColumn:@"bname"];
    NSString *targetid = [resultSet stringForColumn:@"targetid"];
    BOOL ismain = [resultSet intForColumn:@"ismain"];
    NSString *face = [resultSet stringForColumn:@"face"];
    NSString *bid = [resultSet stringForColumn:@"bid"];
    NSString *bsid  = [resultSet stringForColumn:@"bsid"];
    NSInteger memberCount = [resultSet intForColumn:@"memberCount"];
    NSString *creator = [resultSet stringForColumn:@"creator"];
    NSString *instancename = [resultSet stringForColumn:@"instancename"];
    NSString *targetorgname = [resultSet stringForColumn:@"targetorgname"];
    NSString *creteusername = [resultSet stringForColumn:@"creteusername"];
    BOOL useabled = [resultSet intForColumn:@"useabled"];
    NSDictionary *instance = [NSJSONSerialization JSONObjectWithData:[resultSet dataForColumn:@"instance"] options:NSJSONReadingMutableContainers error:nil];
    
    BusinessSessionRecentModel *model = [[BusinessSessionRecentModel alloc] init];
    model.bsguid = bsguid;
    model.bsiid = bsiid;
    model.title = title;
    model.stype = stype;
    model.bstype = bstype;
    model.bname = bname;
    model.targetid = targetid;
    model.ismain = ismain;
    model.face = face;
    model.bid = bid;
    model.bsid = bsid;
    model.memberCount = memberCount;
    model.creator = creator;
    model.instancename = instancename;
    model.targetorgname = targetorgname;
    model.creteusername = creteusername;
    model.useabled = useabled;
    model.instance = instance;
    
    return model;
}
@end
