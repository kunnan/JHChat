//
//  AliyunGalleryFileDAL.m
//  LeadingCloud
//
//  Created by SY on 2017/6/29.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "AliyunGalleryFileDAL.h"
#import "AliyunGalleryFileModel.h"
#import "AliyunOSS.h"
@implementation AliyunGalleryFileDAL
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(AliyunGalleryFileDAL *)shareInstance{
    static AliyunGalleryFileDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[AliyunGalleryFileDAL alloc] init];
    }
    return instance;
}
#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createAliFileTableIfNotExists
{
    NSString *tableName = @"aliyun_galleryfile";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[fileid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[icon] [varchar](50) NULL,"
                                         "[iconurl] [varchar](500) NULL,"
                                         "[iconurl32] [varchar](500) NULL,"
                                         "[iconurl64] [varchar](500) NULL,"
                                         "[iconurl128] [varchar](500) NULL,"
                                         "[iconurlnottoken] [varchar](500) NULL,"
                                         "[filename] [varchar](50) NULL,"
                                         "[fileext] [varchar](50) NULL,"
                                         "[filesize] [integer] NULL,"
                                         "[createdate] [date] NULL,"
                                         "[artworkwidth] [varchar](50) NULL,"
                                         "[artworkheight] [varchar](50) NULL,"
                                         "[descripte] [varchar](50) NULL,"
                                         "[filezipdescriptionid] [varchar](50) NULL);",
                                         tableName]];
        
    }
}
#pragma mark - 添加数据

-(void)addAliFileModel:(AliyunGalleryFileModel*)fileModel {
    [[self getDbQuene:@"aliyun_galleryfile" FunctionName:@"addAliFileModel:(AliyunGalleryFileModel*)fileModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *fileid = fileModel.fileid;
        NSString *icon = fileModel.icon;
        NSString *iconurl = fileModel.iconurl;
        NSString *iconurl32 = fileModel.iconurl32;
        NSString *iconurl64 = fileModel.iconurl64;
        NSString *iconurl128 = fileModel.iconurl128;
        NSString *iconurlnottoken = fileModel.iconurlnottoken;
        NSString *filename = fileModel.filename;
        NSString *fileext = fileModel.fileext;
        NSNumber *  filesize = [NSNumber numberWithLongLong:fileModel.filesize];
        NSDate *createdate = fileModel.createdate;
        NSString *artworkwidth = fileModel.artworkwidth;
        NSString *artworkheight = fileModel.artworkheight;
        NSString *descripte = fileModel.descripte;
        NSString *filezipdescriptionid = fileModel.filezipdescriptionid;
        
        NSString *sql = @"INSERT OR REPLACE INTO aliyun_galleryfile(fileid,icon,iconurl,iconurl32,iconurl64,iconurl128,iconurlnottoken,filename,fileext,filesize,createdate,artworkwidth,artworkheight,descripte,filezipdescriptionid)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        isOK = [db executeUpdate:sql,fileid,icon,iconurl,iconurl32,iconurl64,iconurl128,iconurlnottoken,filename,fileext,filesize,createdate,artworkwidth,artworkheight,descripte,filezipdescriptionid];
        if (!isOK) {
            DDLogError(@"插入失败");
        }
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"aliyun_galleryfile" Sql:sql Error:@"插入失败" Other:nil];

            *rollback = YES;
            return;
        }
    }];
    
    
}

@end
