//
//  CoProjectStageTaskDAL.m
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 阶段任务关系数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "CoProjectStageTaskDAL.h"

@implementation CoProjectStageTaskDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoProjectStageTaskDAL *)shareInstance{
    static CoProjectStageTaskDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[CoProjectStageTaskDAL alloc] init];
    }
    return instance;
}

/**
 *  创建表
 */
-(void)createCoProjectStageTaskTableIfNotExists
{
    NSString *tableName = @"co_project_stage_task";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[prstid] [integer] PRIMARY KEY NOT NULL,"
                                         "[prid] [integer] NULL,"
                                         "[prsid] [integer] NULL,"
                                         "[tid] [integer] NULL,"
                                         "[ordernum] [integer] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateCoProjectStageTaskTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
                
        }
    }
}
@end
