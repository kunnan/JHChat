//
//  CoGroupDAL.h
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

#import <Foundation/Foundation.h>
#import "LZFMDatabase.h"
#import "CoGroupModel.h"

@interface CoGroupDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoGroupDAL *)shareInstance;

/**
 *  创建表
 */
-(void)createCoGroupTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateCoGroupTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)groupArray StartIndex:(NSInteger)sIndex;

/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)groupArray;

/**
 *  添加单条数据
 */
-(void)addGroupModel:(CoGroupModel *)groupModel;
/**
 添加新建群组信息
 *  @param groupModel      群组数据
 */
-(void)addNewGroupModel:(CoGroupModel *)groupModel;

/**
 新建群组信息
 *  @param groupModel      群组数据
 */
-(void)updateModelGroupId:(NSString *)gid GroupModel:(CoGroupModel *)groupModel;


#pragma mark - 删除数据

/**
 *  根据id删除群组
 *
 *  @param
 */
-(void)deleteGroupid:(NSString *)gid;

/**
 *  根据id删除群组
 *
 *  @param oid 机构ID
 */
-(void)deleteAllGroupOid:(NSString *)oid;

/**
 *  根据id删除机构
 *
 *  @param oid 机构ID
 */
-(void)deleteOrgGroupOid:(NSString *)oid;
/**
 *  根据id删除关闭群组
 *
 *  @param oid 机构ID
 */
-(void)deleteAllMyCloseGroupOid:(NSString *)oid;

/**
 *  根据id删除创建群组
 *
 *  @param oid 机构ID
 */
-(void)deleteAllMyCreatGroupOid:(NSString *)oid;

/**
 *  根据id删除创建群组
 *
 *  @param oid 机构ID
 */
-(void)deleteUpAllMyCreatGroupOid:(NSString *)oid;
/**
 *  根据id删除管理群组
 *
 *  @param oid 机构ID
 */
-(void)deleteAllMyMangeGroupOid:(NSString *)oid;

/**
 *  根据id删除管理群组
 *
 *  @param oid 机构ID
 */
-(void)deleteUpAllMyMangeGroupOid:(NSString *)oid;

/**
 *  根据id删除加入的群组
 *
 *  @param oid 机构ID
 */
-(void)deleteAllMyJoinGroupOid:(NSString *)oid;

/**
 *  根据id删除加入的群组
 *
 *  @param oid 机构ID
 */
-(void)deleteuUpAllMyJoinGroupOid:(NSString *)oid;
#pragma mark - 修改数据

/**
    修改群组名称
 *  @param gid        群组ID
 *  @param gName      群组名称
 */
-(void)updateGroupId:(NSString *)gid withzGroupName:(NSString *)gName;

/**
    修改群组描述
 *  @param gid      群组ID
 *  @param gDes     群组描述
 */
-(void)updateGroupId:(NSString *)gid withzGroupDes:(NSString *)gDes;

/**
    修改群组状态
 *  @param gid      群组ID
 *  @param state    群组描述 1 开启 0关闭
 */
-(void)updateGroupId:(NSString *)gid withGroupState:(NSInteger)state;

/**
 修改群组管制
 *  @param gid      群组ID
 */
-(void)updateGroupId:(NSString *)gid withGroupFavorite:(BOOL)isfavorites;

/**
    修改群组logo
 *  @param gid        群组ID
 *  @param logo       群组logo
 */
-(void)updateGroupId:(NSString *)gid withzGrouplogo:(NSString *)logo;

/**
    修改群组加入权限
 *  @param gid        群组ID
 *  @param isApply    权限
 */
-(void)updateGroupId:(NSString *)gid withzGroupApplyroot:(NSNumber *)isApply;

/**
 *  更新工作组所在企业
 *
 *  @param gid 群组ID
 *  @param oid 企业ID
 */
-(void)updateGroupId:(NSString *)gid withzGroupCoid:(NSString *)oid;

/**
    修改群组描述基本信息
 *  @param gid      群组ID
 *  @param des     群组描述
 */
-(void)updateGroupDataId:(NSString *)gid withzGroupName:(NSString *)name Des:(NSString*)des Needauditing:(NSInteger)needauditing;

/**
 *  更新工作组成员数量
 *
 *  @param gid 群组ID
 *  @param memlength 成员总数
 */
-(void)updateGroupId:(NSString *)gid withzGroupMemLength:(NSInteger )memlength;
#pragma mark - 查询数据

/**
 *  我创建的群组列表
 *
 *  @param oid      组织ID
 *  @param startIndex  起始ID 没有传0
 *  @param count    数量
 *
 *  @return 群组
 */
-(NSMutableArray *)getMyGroupWithOid:(NSString *)oid StartIndex:(NSString*)startIndex Count:(NSInteger)count;

/**
 *  我创建的群组列表(搜索)
 *
 *  @param oid      企业ID
 *
 *  @return 群组
 */

-(NSMutableArray *)SearchMyGroupWithOid:(NSString *)oid Search:(NSString*)searchStr;

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

-(NSMutableArray *)getMyChargeGroupWithOid:(NSString *)oid StartIndex:(NSString*)startIndex Count:(NSInteger)count;

/**
 *  我管理的列表(搜索)
 *
 *  @param oid      企业ID
 
 *
 *  @return 群组
 */

-(NSMutableArray *)SearchMyChargeGroupWithOid:(NSString *)oid Search:(NSString*)searchStr;


/**
 *  我的加入的列表
 *
 *  @param oid      组织ID
 *  @param startIndex  起始ID 没有传0
 *  @param count    数量
 *
 *  @return 群组
 */
-(NSMutableArray *)getMyJoinGroupWithOid:(NSString *)oid StartIndex:(NSString*)startIndex Count:(NSInteger)count;


/**
 *  我加入的列表(搜索)
 *
 *  @param oid      企业ID
 
 *
 *  @return 群组
 */
-(NSMutableArray *)SearchMyJoinGroupWithOid:(NSString *)oid Search:(NSString*)searchStr;

/**
 *  关闭群组列表
 *
 *  @param oid      组织ID
 *  @param startIndex  起始ID 没有传0
 *  @param count    数量
 *  @return 群组
 */
-(NSMutableArray*)getGroupCloseDataOid:(NSString*)oid StartIndex:(NSString*)startIndex Count:(NSInteger)count;

/**
 *  关闭群组列表(搜索)
 *
 *  @param oid      企业ID
 *  @return 群组
 */
-(NSMutableArray*)SearchGroupCloseDataOid:(NSString*)oid Serach:(NSString*)searchStr;

/**
 *  获取群组全部列表
 *
 *  @param oid      组织ID
 *  @return 群组
 */
-(NSMutableArray*)getGroupAllDataOid:(NSString*)oid;

/**
 *  获取组织全部列表
 *
 *  @param oid      组织ID
 *  @return 群组
 */
-(NSMutableArray*)getOrganizationDataOid:(NSString*)oid;

/**
 * 搜索
 *
 *  @param oid      组织名称
 *  @return 群组
 */
-(NSMutableArray*)getSearchGroupAllDataOid:(NSString*)oid Name:(NSString*)name;

/**
 *  得到群组详情
 *
 *  @param gid      群组ID
 *  @return 群组
 */
-(CoGroupModel*)getDataGroupModelGid:(NSString*)gid;
@end
