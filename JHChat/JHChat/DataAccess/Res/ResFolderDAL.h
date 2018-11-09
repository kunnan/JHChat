//
//  ResFolderDAL.h
//  LeadingCloud
//
//  Created by wchMac on 16/1/13.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  dfl
 Date：   2016-01-13
 Version: 1.0
 Description: 资源文件夹处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZFMDatabase.h"

@class ResFolderModel;
@interface ResFolderDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ResFolderDAL *)shareInstance;

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createResFolderTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateResFolderTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)resFolderArray;

/**
 *  根据文件夹Model添加数据
 */
-(void)addDataWithResFolderModel:(ResFolderModel *)resFolderModel;

#pragma mark - 删除数据
/**
 *  删除单个文件夹
 *
 *  @param classid 文件夹ID
 */
- (void) deleteFolderWithClassid:(NSString *) classid;
/**
 *  删除所有文件夹，以保持与web端数据同步
 *
 *  @param rpid 资源池id 父
 */
-(void) deleteAllFolderWithRpid:(NSString *)rpid;
/**
 *  删除单个文件夹
 *
 *  @param classid 文件夹ID
 */
- (void) deleteFolderWithPraentId:(NSString *) parentid;

#pragma mark - 修改数据

/**
 *  更新文件夹下的资源数量
 *
 *  @param iscacheall 是否缓存完所有资源
 *  @param classid    文件夹ID
 */
-(void)updateIsCacheAllRes:(NSInteger)iscacheall withClassid:(NSString *)classid;

/**
 *  重命名文件夹
 *
 *  @param resfolderName 重命名的文件夹名称
 *  @param classid       文件夹ID
 */
- (void)updataFolderNam:(NSString*)resfolderName withClassid:(NSString *)classid;
/**
 *   更新是够分享字段
 *
 *  @param resfolderName 新名字
 *  @param classid       文件夹id
 */
- (void)updataIsShare:(NSInteger)isshare withClassid:(NSString *)classid;
/**
 *   更新icon字段
 *
 *  @param resfolderName 新名字
 *  @param classid       文件夹id
 */
- (void)updataIcon:(NSString*)icon withClassid:(NSString *)classid;
/**
 *  协作文件保存到云盘
 *
 *  @param parentid 新的父id
 *  @param rpid     新的资源池id
 *  @param classid  保存的文件夹
 */
- (void)updataFolderParentid:(NSString*)parentid andRpid:(NSString*)rpid withClassid:(NSString *)classid;
/**
 *  修改文件夹路径
 *
 *  @param folder 文件夹model
 */
-(void)updataFolderPath:(ResFolderModel*)folder;

/**
 *  协作 - 任务 - 文件 修改文件夹名
 *
 *  @param resfolderName 新名字
 *  @param classid       文件夹id
 */
- (void)updataFolderName:(NSString*)resfolderName andDescription:(NSString*)description withClassid:(NSString *)classid;
#pragma mark - 查询数据

/**
 *  获取根节点的classid
 *
 *  @return 根节点文件夹ID
 */
-(NSString *)getRootClassid;

/**
 *  获取根文件夹Model
 *
 *  @return 根文件夹
 */
-(ResFolderModel *)getRootFolderModelWithRpid:(NSString*)rpid;
/**
 获取指定根文件夹
 
 @param rpid     资源池id
 @param parentid 根文件夹id
 
 @return 根文件夹
 */
-(ResFolderModel *)getRootFolderModelWithRpid:(NSString*)rpid parentid:(NSString*)parentid;

/**
 *  判断此文件夹下的资源是否缓存完
 *
 *  @param classid 文件夹ID
 *
 *  @return 资源数量
 */
-(BOOL)checkIsCacheAllWithClassid:(NSString *)classid;

/**
 *  获取指定文件夹ID的子文件夹
 *
 *  @param parentid 文件夹ID
 *  @param sortDic  排序规则
 *
 *  @return 子文件夹
 */
-(NSMutableArray *)getChildModelsWithClassid:(NSString *)classid sort:(NSMutableDictionary *)sortDic;
/**
 *  协作 - 文件
 *
 *  @param classid 文件夹id
 *  @param rpid    资源池id
 *  @param sortDic 排序
 *
 *  @return 数据
 */
-(NSMutableArray *)getChildModelsWithClassid:(NSString *)classid andRpid:(NSString*)rpid sort:(NSMutableDictionary *)sortDic;
/**
 *  协作- 获取根文件夹
 *
 *  @param rpid 文件夹资源池id
 *
 *  @return 文件根id
 */
-(NSString *)getRootClassidWithParentAndRpid:(NSString*)rpid;
// 获取parentall 用于连续跳转
-(NSString *)getParentallWithClassid:(NSString*)classid;
// 通过classid找到该文件夹
-(ResFolderModel*)getFolderModelWithClassid:(NSString*)classid;
@end
