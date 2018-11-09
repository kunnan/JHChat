//
//  CoMemberDAL.h
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

#import <Foundation/Foundation.h>
#import "LZFMDatabase.h"
#import "CoMemberModel.h"

@interface CoMemberDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CoMemberDAL *)shareInstance;

/**
 *  创建表
 */
-(void)createCoMemberTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateCoMemberTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;
#pragma mark - 添加数据
/**
 *  批量添加数据
 */
-(void)addDataWithArray:(NSMutableArray *)memberArray;
/**
 *  批量添加数据(去重)
 */
-(void)addfilterDataWithArray:(NSMutableArray *)memberArray;

/**
 *  添加单条数据
 */
-(void)addModel:(CoMemberModel *)memberModel;

/**
 *  批量添加添加成员数据
 */
-(void)addOriginCooperationID:(NSString*)cid DataWithArray:(NSMutableArray *)memberArray;
#pragma mark - 删除数据

/**
 *  根据id删除
 *
 *  @param
 */
-(void)deleteMemberId:(NSString *)mid;

/**
 *  删除协作所有成员
 *
 *  @param
 */
-(void)deleteCooperationId:(NSString *)cid;

/**
 *  删除协作所有成员(去除自己)
 *
 *  @param
 */
-(void)deleteUnMyCooperationId:(NSString *)cid;
/**
 *  删除协作成员
 *  cid 协作ID
 *  uid 成员ID
 *  @param
 */
-(void)deleteMemberCooperationId:(NSString *)cid Uid:(NSString*)uid;

#pragma mark - 修改数据


/**
 *  更新成员状态
 *
 *  @param cid      协作ID
 *  @param uid      用户ID
 *  @param isvalid  是否通过
 *  @return CoMemberModel 模型数组
 */
-(void)upDataMemberValidCooperationId:(NSString*)cid Uid:(NSString*)uid Isvalid:(BOOL)isvalid;

/**
 *  更新成员身份
 *
 *  @param cid      协作ID
 *  @param uid      用户ID
 *  @param utype    身份 1 管理员 2 成员 3 观察者
 *  @return CoMemberModel 模型数组
 */
-(void)upDataMemberUtypeCooperationId:(NSString*)cid Uid:(NSString*)uid Utype:(NSInteger)utype;

/**
 *  更新成员身份 (任务 之前管理员信息设置为0)
 *
 *  @param cid      协作ID
 *  @param uid      用户ID
 *  @param utype    身份 1 管理员
 */
-(void)upDataMemberUtypeCooperationTaskId:(NSString*)cid Uid:(NSString*)uid Utype:(NSInteger)utype;

/**
 *  更新企业用户当前身份
 *
 *  @param cid 协作ID
 *  @param uid 用户ID
 *  @param oid 组织ID
 *  @param did 部门ID
 */
-(void)UpDataMemberCompanyCooperationId:(NSString*)cid Uid:(NSString*)uid Oid:(NSString*)oid OrgName:(NSString*)orgname Did:(NSString*)did DepName:(NSString*)depname;
#pragma mark - 查询数据

/**
 *  群组成员
 *
 *  @param oid      组织ID
 *  @param gid      协作ID
 *
 *  @return CoMemberModel 模型数组
 */

-(NSMutableArray *)getGroupMemberWithOid:(NSString *)oid GroupID:(NSString*)gid;

/**
 *  协作成员
 *
 *  @param cid      协作ID
 *
 *  @return CoMemberModel 模型数组
 */
-(NSMutableArray *)getCooMemberWithCID:(NSString*)cid;


/**
 *  协作管理员数组
 *
 *  @param cid      协作ID
 *
 *  @return CoMemberModel 模型数组
 */
-(NSMutableArray *)getCooAdminsWithCID:(NSString*)cid;

/**
 *  协作普通管理员id数组
 *
 *  @param cid      协作ID
 *
 *  @return CoMemberModel 模型数组
 */
-(NSMutableArray *)getCooAdminsUidWithCID:(NSString*)cid;

/**
 *  协作激活管理员数组
 *
 *  @param cid      协作ID
 *
 *  @return CoMemberModel 模型数组
 */
-(NSMutableArray *)getCooActiveAdminsWithCID:(NSString*)cid;
/**
 *  协作普通成员数组
 *
 *  @param cid      协作ID
 *
 *  @return CoMemberModel 模型数组
 */
-(NSMutableArray *)getCooCommonsWithCID:(NSString*)cid;

/**
 *  协作通过普通成员数组
 *
 *  @param cid      协作ID
 *
 *  @return CoMemberModel 模型数组
 */
-(NSMutableArray *)getCooValidCommonsWithCID:(NSString*)cid;
/**
 *  协作激活普通成员数组
 *
 *  @param cid      协作ID
 *
 *  @return CoMemberModel 模型数组
 */
-(NSMutableArray *)getCooActiveCommonsWithCID:(NSString*)cid;

/**
 *  搜索协作成员
 *
 *  @param cid    协作ID
 *  @param search 搜索名称
 *
 *  @return CoMemberModel 模型数组
 */
-(NSMutableArray *)getSearchCooMemberCid:(NSString*)cid Search:(NSString*)search;

/**
 *  得到管理员
 *
 *  @param cid      协作ID
 *
 *  @return CoMemberModel 模型数组
 */
-(CoMemberModel *)getCooChargeWithCID:(NSString*)cid;

/**
 *  得到个人信息
 *
 *  @param mid  成员mid
 
 *  @return CoMemberModel 模型数组
 */
-(CoMemberModel *)getMemberData:(NSString*)mid;

/**
 *  得到个人信息
 *
 *  @param uid      成员id
 *
 *  @return CoMemberModel 模型数组
 */
-(CoMemberModel *)getMemberDataUid:(NSString*)uid Cid:(NSString*)cid;

/**
 *  得到协作个人信息
 *
 *  @param mid  成员mid
 *  @param cid  协作id
 *  @return CoMemberModel 模型数组
 */
-(CoMemberModel *)getCooperation:(NSString*)cid MemberData:(NSString*)mid;

/**
 *  是否存在父任务中
 *
 *  @param uid  成员用户ID
 *  @param pid  父任务ID

 *  @return CoMemberModel 模型数组
 */
-(BOOL)isExistParantTask:(NSString*)pid Uid:(NSString*)uid;

/**
 *  是否存成员
 *
 *  @return CoMemberModel 模型数组
 */
-(BOOL)isExistCooperation:(NSString*)cid Uid:(NSString*)uid;

#pragma mark 得到成员列表

-(NSMutableDictionary*)getCooHandleMembersWithCID:(NSString *)cid;

#pragma mark 得到任务成员列表

-(NSMutableDictionary*)getCooHandleTaskMembersWithCID:(NSString *)cid;

/**
 *  得到协作已通过成员
 *
 *  @param cid 协作ID
 *
 *  @return 处理后的成员（A,B）
 */
-(NSMutableDictionary*)getCooExistMembersWithCID:(NSString *)cid;

//得到除去管理员的数据
-(NSMutableDictionary*)getCooHandleMembersRemoveAdmWithCID:(NSString *)cid AdminID:(NSString *)aid;
@end
