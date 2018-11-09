//
//  PostFileDAL.m
//  LeadingCloud
//
//  Created by wang on 16/3/19.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "PostFileDAL.h"

@implementation PostFileDAL


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PostFileDAL *)shareInstance{
    static PostFileDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[PostFileDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createPostFileTableIfNotExists
{
    NSString *tableName = @"post_file";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[rid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[classid] [varchar](50) NULL,"
                                         "[expid] [varchar](50) NULL,"
                                         "[exptype] [varchar](50) NULL,"
                                         "[icon] [varchar](50) NULL,"
                                         "[iconurl] [varchar](300) NULL,"
                                         "[name] [varchar](200) NULL,"
                                         "[description] [varchar](300) NULL,"
                                         "[expandinfo] [varchar](300) NULL,"
                                         "[iscurrentversion] [integer] NULL,"
                                         "[rpid] [varchar](50) NULL,"
                                         "[showname] [varchar](200) NULL,"
                                         "[showsize] [varchar](50) NULL,"
                                         "[showversion] [varchar](50) NULL,"
                                         "[updatedate] [date] NULL,"
                                         "[updateusername] [varchar](200) NULL,"
                                         "[version] [varchar](50) NULL,"
                                         "[versionid] [varchar](50) NULL,"
                                         "[rtype] [integer] NULL,"
                                         "[size] [integer] NULL,"
                                         "[sortindex] [integer] NULL,"
                                         "[postid] [varchar](50) NULL,"
                                         "[subcount] [integer] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updatePostFileTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}
#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)pArray{
    
    
    [[self getDbQuene:@"post_file" FunctionName:@"addDataWithArray:(NSMutableArray *)pArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
		NSString *sql = @"INSERT OR REPLACE INTO post_file(rid,rpid,classid,expid,exptype,icon,iconurl,name,description,expandinfo,iscurrentversion,showname,showsize,showversion,updatedate,updateusername,version,versionid,rtype,size,sortindex,subcount,postid)"
		"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
        for (int i = 0; i< pArray.count;  i++) {
            PostFileModel *pModel = [pArray objectAtIndex:i];
            
            NSString *rid = pModel.rid;
            NSString *rpid = pModel.rpid;
            NSString *classid = pModel.classid;
            NSString *expid = pModel.expid;
            NSString *exptype=pModel.exptype;
            NSString *icon = pModel.icon;
            NSString *iconurl=pModel.iconurl;
            NSString *name=pModel.name;
            NSString *descripti=pModel.descripti;
            NSString *expandinfo=pModel.expandinfo;
            NSNumber *iscurrentversion=[NSNumber numberWithBool:pModel.iscurrentversion];
            NSString *showname=pModel.showname;
            NSString *showsize=pModel.showsize;
            NSString *showversion=pModel.showversion;
            NSDate *updatedate=pModel.updatedate;
            NSString *updateusername=pModel.updateusername;
            NSString *version=pModel.version;
            NSString *versionid=pModel.versionid;
            NSNumber *rtype=[NSNumber numberWithInteger:pModel.rtype];
            NSNumber *size=[NSNumber numberWithInteger:pModel.size];
            NSNumber *sortindex=[NSNumber numberWithInteger:pModel.sortindex];
            NSNumber *subcount=[NSNumber numberWithInteger:pModel.subcount];
            NSString *postID=pModel.postID;

            isOK = [db executeUpdate:sql,rid,rpid,classid,expid,exptype,icon,iconurl,name,descripti,expandinfo,iscurrentversion,showname,showsize,showversion,updatedate,updateusername,version,versionid,rtype,size,sortindex,subcount,postID];
            
            if (!isOK) {
                DDLogError(@"插入失败");
            }
        }
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"post_file" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
        
    }];
    
}

@end
