//
//  OrganizationWebApi.h
//  LeadingCloud
//
//  Created by wchMac on 16/5/24.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#ifndef OrganizationWebApi_h
#define OrganizationWebApi_h

#endif /* OrganizationWebApi_h */


/*-----------------------组织机构相关----------------------*/



static NSString * const WebApi_Organization = @"api/organization";
/* 获取用户的所属有效组织 */
static NSString * const WebApi_Organization_GetUserOrgByUisController = @"api/organization/getuserorgbyuidcontroller/{tokenid}";
/* 获取某个企业下的所有部门（不包括当前企业） */
static NSString * const WebApi_Organization_GetChildOrgByssqy = @"api/organization/getchildorgbyssqy/{tokenid}";
/* 获取某个企业下的所有部门 */
static NSString * const WebApi_Organization_GetOrgByssqy = @"api/organization/getorgbyssqy/{tokenid}";
/* 获取子级部门（不递归）*/
static NSString * const WebApi_Organization_GetOrgListByOPid = @"api/organization/getorglistbyopid/{tokenid}";
/* 新的组织接受调用 */
static NSString * const WebApi_Organization_ApproveOrgIntervate = @"api/organization/approveorgintervate/{tokenid}";
/* 新的组织拒绝调用 */
static NSString * const WebApi_Organization_RefuseOrgUserIntervate = @"api/organization/refuseorguserintervate/{ouiid}/{tokenid}";
/* 获取【新的组织】临时通知数据 */
static NSString * const WebApi_Organization_GetOrgUserInterInfoByUidOeid = @"api/organization/getorguserinterinfobyuidoeid/{tokenid}";
/* 用户删除组织的加入邀请 */
static NSString * const WebApi_Organization_DeleteOrgUserIntervate = @"api/organization/deleteorguserintervate/{ouiid}/{tokenid}";

/* 创建组织 */
static NSString * const WebApi_Organization_CreateEnterPrise = @"api/organization/createenterprise/{tokenid}";
/* 查找组织 (已废弃)*/
static NSString * const WebApi_Organization_ExistOrgByCode = @"api/organization/existorgbycode/{tokenid}";
/* 查找组织 */
static NSString * const WebApi_Organization_GetOrgByUserApply = @"api/organization/getorgbyuserapply/{tokenid}";
/* 个人组织信息 */
static NSString * const WebApi_Organization_GetBasicByentersUser = @"api/organization/getbasicbyentersuser/{tokenid}";
/* 加入群组部门信息 */
static NSString * const WebApi_Organization_Getorgbyuid = @"api/organization/getorgbyuid/{tokenid}";
/* 根据oid查找组织 */
static NSString * const WebApi_Organization_GetOrgInfoByCodeModel = @"api/organization/getorginfobycodemodel/{tokenid}";
/* 获取用户在某个组织下的主要信息 */
static NSString * const WebApi_Organization_GetOrgsByUserByUidOeid = @"api/organization/getorgsbyuserbyuidoeid/{tokenid}";
/* 创建部门 */
static NSString * const WebApi_Organization_CreateDept = @"api/organization/createdept/{tokenid}";
/* 修改部门 */
static NSString * const WebApi_Organization_UpdateDept = @"api/organization/updatedept/{tokenid}";
/* 获取指定组织下我能管理部门 */
static NSString * const WebApi_Organization_GetOrgProrityByEUId = @"api/organization/getorgproritybyeuid/{tokenid}";
/* 获取我在某个企业所属的部门 */
static NSString * const WebApi_Organization_GetOrgListByUidOeid = @"api/organization/getorglistbyuidoeid/{tokenid}";
/* 获取未激活用户在某个企业所属的部门 */
static NSString * const WebApi_Organization_GetUserAddItionInfoByUid = @"api/organization/getuseradditioninfobyuid/{tokenid}";
/* 删除部门 */
static NSString * const WebApi_Organization_DeleteDept = @"api/organization/deletedept/{tokenid}";
/* 获取部门信息 */
static NSString * const WebApi_Organization_GetDept = @"api/organization/getdept/{tokenid}";
/* 更新组织信息 */
static NSString * const WebApi_Organization_UpdateEnterprise = @"api/organization/updateenterprise/{tokenid}";
/* 获取一个组织信息 */
static NSString * const WebApi_Organization_GetOrgByOid = @"api/organization/getorgbyoid/{oid}/{tokenid}";
/* 退出组织 */
static NSString * const WebApi_Organization_UserExitEnter = @"api/organization/userexitenter/{tokenid}";
/* 未激活用户调整部门后，矫正邀请信息 */
static NSString * const WebApi_Organization_ReactOrgIntervateUser = @"api/organization/reactorgintervateuser/{tokenid}";
/* 根据组织id获取上级的所有组织数据 */
static NSString * const WebApi_Organization_GetRecusiveParentOrgByOid = @"api/organization/getrecusiveparentorgbyoid/{tokenid}";
/* 根据组织id集合返回的组织信息 */
static NSString * const WebApi_Organization_GetOrgByOids = @"api/organization/getorgbyoids/{tokenid}";



/* 搜索员工 */
static NSString * const WebApi_OrgUser_GetUserByFilter = @"api/user/getuserbyfilter/{tokenid}";
/* 根据筛选条件返回某个企业权限下的用户列表 */
static NSString * const WebApi_Organization_GetAuthUserByFilter = @"api/organization/getauthuserbyfilter/{tokenid}";

/*-----------------------企业相关----------------------*/
/* 企业的过期时间判断，true:未到期，false:到期 */
static NSString * const WebApi_Organization_EnterLic_DeadLineAuthCheck = @"api/organization/enterlic/deadlineauthcheck/{oeid}/{tokenid}";



static NSString * const WebApi_OrgUser = @"api/orguser";
/* 申请加入组织(已弃用) */
static NSString * const WebApi_OrgUser_ApplyJoinOrg = @"api/organization/applyjoinorg/{tokenid}";
/* 人员申请加入某个组织结构 */
static NSString * const WebApi_OrgUser_UserApplyJoinOrg = @"api/organization/userapplyjoinorg/{tokenid}";
/* 分页获取当前部门下的成员（查看、人员选择模式） */
static NSString * const WebApi_OrgUser_GetColleagueUserByOIdPages = @"api/colleaguelist/getcolleagueuserbyoidpages/{tokenid}";
/* 分页获取当前部门下的成员（管理模式） */
static NSString * const WebApi_OrgUser_GetUserByOIdPages  = @"api/organization/getuserbyoidpages/{tokenid}";
/* 修改员工所属部门 */
static NSString * const WebApi_OrgUser_AdjustUserOrg  = @"api/organization/adjustuserorg/{tokenid}";
/* 修改员工所属部门(新) */
static NSString * const WebApi_OrgUser_AdjustUserOrg_V2  = @"api/organization/adjustuserorg/v2/{tokenid}";

/* 添加员工（旧版本） */
static NSString * const WebApi_OrgUser_IntervateUserByUsingMobile = @"api/organization/orgintervateuserbymobile/{tokenid}";
/* 添加员工 */
static NSString * const WebApi_OrgUser_IntervateUserByUsingMobile_GraphCode = @"api/organization/orgintervateuserbymobile/graphcode/{tokenid}";
/* 编辑员工姓名 */
static NSString * const WebApi_OrgUser_UpdateEnterUserName = @"api/organization/updateenterusername/{tokenid}";
/* 删除部门下组织人员 */
static NSString * const WebApi_OrgUser_DeleteOrgUser = @"api/organization/deleteorguser/{tokenid}";
/* 企业中删除组织人员 */
static NSString * const WebApi_OrgUser_DeleteUserFromEnter = @"api/organization/deleteuserfromenter/{tokenid}";
/* 设置管理员 */
static NSString * const WebApi_OrgUser_GetUserBySetBatchAdmin = @"api/organization/getuserbysetbatchadmin/{tokenid}";
/* 取消管理员 */
static NSString * const WebApi_OrgUser_CancleAdmin = @"api/organization/canceladmin/{tokenid}";
/* 获取当前部门的管理员数据 */
static NSString * const WebApi_OrgUser_GetAdminiUserByOidPages = @"api/organization/getadminuserbyoidpages/{tokenid}";
/* 公开用户在企业下的手机号码 */
static NSString * const WebApi_OrgUser_OpenShowUserMobile = @"api/organization/openshowusermobile/{oeid}/{uid}/{tokenid}";
/* 屏蔽用户在企业下的手机号码公开 */
static NSString * const WebApi_OrgUser_CloseShowUserMobile = @"api/organization/closeshowusermobile/{oeid}/{uid}/{tokenid}";
/* 通过用户id集合邀请员工 */
static NSString * const WebApi_OrgUser_Mobile_InviteuserByUids = @"api/organization/mobile/inviteuserbyuids/{tokenid}";


#define no user








///* 获取用户在所有企业下的信息 */
//static NSString * const Contact_WebAPI_GetBasicByEntersUser = @"api/organization/getbasicbyentersuser/{tokenid}";

/*【新的员工】的申请记录 */
static NSString * const Contact_WebAPI_GetMsgUserApplyList = @"api/organization/getmsguserapplylist/{tokenid}";

/* 获取组织的申请列表 */
static NSString * const Contact_WebAPI_GetOrgUsrapplyList = @"api/organization/getorgusrapplylist/{tokenid}";
/* 同意员工加入组织 */
static NSString * const Contact_WebAPI_AcceptApplyUser = @"api/organization/acceptapplyuser/{tokenid}";
/* 拒绝员工加入组织 */
static NSString * const Contact_WebAPI_RefuseApplyUser = @"api/organization/refuseapplyuser/{tokenid}";
/* 获取某个组织下某人的申请记录信息 */
static NSString * const Contact_WebAPI_GetOrgUserApplyModelByKey = @"api/organization/getorguserapplymodelbykey/{tokenid}";
/* 管理员删除用户申请加入某个组织 */
static NSString * const Contact_WebAPI_DeleteApplyUser = @"api/organization/deleteapplyuser/{ouaid}/{tokenid}";
/* 获取当前部门的管理员数据 */
static NSString * const Contact_WebAPI_GetAdminUserByOId = @"api/organization/getadminuserbyoidpages/{tokenid}";






static NSString * const Contact_WebApi_OrgLicense_IsExistsAuth = @"api/orglicense/isexistsauth/{orgid}/{appid}/{tokenid}";

/*-----------------------组织机构,岗位相关----------------------*/

static NSString * const WebApi_OrgPost = @"api/OrgPost";
/* 获取岗位列表 */
static NSString * const Contact_WebAPI_GetOrgPostList = @"api/OrgPost/GetOrgPostList/{oid}/{tokenid}";
/* 获取企业下基准岗位（职务）列表 */
static NSString * const Contact_WebAPI_GetOrgBaseList = @"api/OrgPost/GetOrgBaseList/{orgid}/{tokenid}";


