//
//  ResDAL.h
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 资源数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "LZFMDatabase.h"

@class ResModel;
@class PostFileModel;
@interface ResDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ResDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createResTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateResTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)resArray;
-(void)addPostFileModel:(PostFileModel*)resModel;

/**
 *  根据ResModel添加资源
 */
-(void)addDataWithModel:(ResModel *)resModel;

#pragma mark - 删除数据

/**
 *  根据Rid删除资源
 *
 *  @param rid rid
 */
-(void)deleteResWithRid:(NSString *)rid;
/**
 *  根据Rpid删除资源
 *
 *  @param rid rpid
 */
-(void)deleteAllResWithRpid:(NSString *)rpid withClassid:(NSString*)classid;
/**
 *  根据classid删除资源
 *
 *  @param rid rpid
 */
-(void)deleteAllResWithClassid:(NSString*)classid;
/**
 *  根据Rpid删除资源
 *
 *  @param rid rpid
 */
-(void)deleteAllResWithRpid:(NSString*)rpid;
#pragma mark - 修改数据

/**
 *  根据clienttempid修改资源信息
 */
-(void)UpdateResWithClientID:(ResModel *)resModel;

/**
 *  更新资源的上传状态
 */
-(void)updateResUploadStatus:(ResModel *)resModel status:(NSInteger)uploadStatus;
/**
 *  修改保存到云盘的文件资源
 *
 *  @param classid 保存过后新的classid
 *  @param rpid    保存过后新的rpid
 *  @param rid     要保存的文件rid
 */
-(void)updateSaveRescource:(NSString *)classid andRpid:(NSString*)rpid withRid:(NSString*)rid;

/**
 *  重命名文件
 */
- (void) updateResFileName:(NSString *) name withRid:(NSString *)rid;

/**
 *  更新资源的下载状态
 */
-(void)updateResDownloadStatus:(ResModel *)resModel status:(NSInteger)downloadStatus;
/**
 *  文件移动替换classID
 *
 *  @param  资源文件
 */
-(void)updateFileClassid:(ResModel*) fileModel;

-(void)updateFavoriteFileWithIsfavorite:(NSString*)isfavorite objectid:(NSString*)objectid;
/**
 *  根据rid修改资源信息
 */
-(void)UpdateUpgradeFileWithRid:(ResModel *)resModel;

#pragma mark - 查询数据

/**
 *  获取资源列表
 *
 *  @param classid  文件夹ID
 *  @param start    起始条目
 *  @param count    需要获取的条目数量
 *  @param sortDic  排序规则
 *
 *  @return 资源记录数组
 */
-(NSMutableArray *)getChildModelsWithClassid:(NSString *)classid startNum:(NSInteger)start queryCount:(NSInteger)count sort:(NSMutableDictionary *)sortDic;

/**
 *  获取未上传成功的文件
 *
 *  @param classid  文件夹ID
 *
 *  @return 资源记录数组
 */
-(NSMutableArray *)getNoUploadSuccessModels:(NSString *)classid;
/**
 *  协作-工作组-文件
 *
 *  @param classid 根文件夹id
 *  @param sortDic 排序
 *
 *  @return 文件数组
 */
-(NSMutableArray *)getChildModelsWithClassid:(NSString *)classid sort:(NSMutableDictionary *)sortDic;
/**
 *  获取特定资源
 *
 *  @param resid  资源ID
 *  @param clienttempid  客户端临时ID
 *
 *  @return 资源对象
 */
-(ResModel *)getResModelWithResid:(NSString *)resid orClientTempId:(NSString *)clienttempid;
/**
 *  获取特定资源
 *
 *  @param resid  资源ID
 *
 *  @return 资源对象
 */
-(ResModel *)getResModelWithResid:(NSString *)resid;
/**
 *  获取图片资源
 *
 *  @param rpid   资源次id
 *  @param rid    资源id
 *  @param extype 文件类型
 *
 *  @return 图片文件model
 */
- (ResModel *) getImageArrayWithRpid:(NSString *)rpid rid:(NSString *)rid extype:(NSString*)extype;

@end
