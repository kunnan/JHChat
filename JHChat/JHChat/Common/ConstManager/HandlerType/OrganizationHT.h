//
//  OrganizationHT.h
//  LeadingCloud
//
//  Created by wchMac on 16/5/9.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#ifndef OrganizationHT_h
#define OrganizationHT_h


#endif /* OrganizationHT_h */

/* ===============================组织机构(origanization)=============================== */
static NSString * const Handler_Organization = @"organization";

/* 组织(org) */
static NSString * const Handler_Organization_Org = @"org";
static NSString * const Handler_Organization_Org_Createenter = @"organization.org.createenter"; //创建组织--临时通知(已处理)
static NSString * const Handler_Organization_Org_UCountChange = @"organization.org.ucountchange";  //组织用户数发生改变--临时通知(未处理)
static NSString * const Handler_Organization_Org_EnterUCountChange = @"organization.org.enterucountchange";  //企业用户数发生改变--临时通知(未处理)
static NSString * const Handler_Organization_Org_Disband = @"organization.org.disband";  //解散组织--临时通知(已处理)
static NSString * const Handler_Organization_Org_UpdateEnterprise = @"organization.org.updateenterprise";  //修改企业信息--临时通知(已处理)
static NSString * const Handler_Organization_Org_CreateDepart = @"organization.org.createdepart";  //组织下新增部门--临时通知(已处理)
static NSString * const Handler_Organization_Org_UpdateDepart = @"organization.org.updatedepart";  //组织下修改部门信息--临时通知(已处理)
static NSString * const Handler_Organization_Org_DeleteDepart = @"organization.org.deletedepart";  //组织下删除部门--临时通知(已处理)
static NSString * const Handler_Organization_Org_AdjustUser = @"organization.org.adjustuser";  //组织下人员调整部门--临时通知(已处理)
static NSString * const Handler_Organization_Org_UpdateEnterLogo = @"organization.org.updateenterlogo";  //修改组织logo通知--持久通知(已处理)
static NSString * const Handler_Organization_Org_MoveUp = @"organization.org.moveup";  //组织下部门上移--临时通知(已处理)
static NSString * const Handler_Organization_Org_MoveDown = @"organization.org.movedown";  //组织下部门下移--临时通知(已处理)
static NSString * const Handler_Organization_Org_Drag = @"organization.org.drag";  //组织下部门拖拽--临时通知(已处理)
static NSString * const Handler_Organization_Org_ReconstOrg = @"organization.org.reconstorg";  //组织下部门重组（mis48覆盖组织）--临时通知(已处理)
static NSString * const Handler_Organization_Org_BatadJustUser = @"organization.org.batadjustuser";  //组织下用户批量调整部门--临时通知(已处理)


/* 管理员(admin) */
static NSString * const Handler_Organization_Admin = @"admin";
static NSString * const Handler_Organization_Org_SetAdmin = @"organization.admin.setadmin";  //设为管理员--临时通知(已处理)
static NSString * const Handler_Organization_Org_BatchSetAdmin = @"organization.admin.batchsetadmin";  //批量设为管理员--临时通知(已处理)
static NSString * const Handler_Organization_Org_CancelAdmin = @"organization.admin.canceladmin";  //取消管理员--临时通知(已处理)

/* 组织用户(orguser) */
static NSString * const Handler_Organization_Orguser = @"orguser";
static NSString * const Handler_Organization_Orguser_RemoveUser = @"organization.orguser.removeuser";  //删除用户--临时通知(已处理)
static NSString * const Handler_Organization_Orguser_AgreeUserApply = @"organization.orguser.agreeuserapply";  //新的员工-管理员同意用户的申请--临时通知(已处理)
static NSString * const Handler_Organization_Orguser_RefuseApply = @"organization.orguser.refuseapply";  //新的员工-管理员拒绝用户的申请--临时通知(已处理)
static NSString * const Handler_Organization_Orguser_UpdateEnterUserName = @"organization.orguser.updateenterusername";  //修改人员在企业下的名称--临时通知(已处理)
static NSString * const Handler_Organization_Orguser_ApproveIntervate = @"organization.orguser.approveintervate";  //新的组织--用户同意组织的邀请--临时通知(已处理)
static NSString * const Handler_Organization_Orguser_UserJoinApply = @"organization.orguser.userjoinapply";  //新的员工--临时通知(已处理)、消息(已处理)
static NSString * const Handler_Organization_Orguser_Intervateuser = @"organization.orguser.intervateuser";  //新的组织--临时通知(已处理)、消息(已处理)
static NSString * const Handler_Organization_Orguser_RevokeInterUser = @"organization.orguser.revokeinteruser";  //新的组织--组织撤销邀请用户(已处理)
static NSString * const Handler_Organization_Orguser_RefuseInvite = @"organization.orguser.refuseinvite";  //新的组织--用户拒绝通知(已处理)
static NSString * const Handler_Organization_Orguser_BatImportResult = @"organization.orguser.batimportresult";  //组织批量导入员工通知(已处理)
static NSString * const Handler_Organization_Orguser_BatRemoveUser = @"organization.orguser.batremoveuser";  //组织下批量删除人员(已处理)
static NSString * const Handler_Organization_Orguser_BatImportIlegal = @"organization.orguser.batimportilegal";  //批量导入用户后，给导入的用户发送通知(已处理)
static NSString * const Handler_Organization_Orguser_UserExit = @"organization.orguser.userexit";  //用户自行退出组织--临时通知(已处理)
static NSString * const Handler_Organization_Orguser_SetenterUserSort = @"organization.orguser.setenterusersort";  //设置用户在企业下的排序值通知--临时通知(已处理)



