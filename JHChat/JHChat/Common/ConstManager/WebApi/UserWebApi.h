//
//  UserWebApi.h
//  LeadingCloud
//
//  Created by wchMac on 16/6/2.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#ifndef UserWebApi_h
#define UserWebApi_h


#endif /* UserWebApi_h */


/*-----------------------联系人相关----------------------*/
static NSString * const WebApi_Colleaguelist = @"api/colleaguelist";
/* 获取我的好友 */
static NSString * const WebApi_Colleaguelist_GetColleagues = @"api/colleaguelist/getcolleagues/{tokenid}";
/* 获取我的好友标签列表 */
static NSString * const WebApi_Colleaguelist_GetContactGroup = @"api/colleaguelist/getcontactgroup/{tokenid}";
/* 获取我的好友和标签之间的关系 */
static NSString * const WebApi_Colleaguelist_GetContractListWithTag = @"api/colleaguelist/getcontractlistwithtag/{tokenid}";
/* 获取用户名片信息 */
static NSString * const WebApi_Colleaguelist_BusinessCardForMobile = @"api/colleaguelist/businesscardformobile/{uid}/{tokenid}";
/* 添加好友 */
static NSString * const WebApi_Colleaguelist_InviteFriend = @"api/colleaguelist/invitefriend/{tokenid}";
/* 解除好友关系 */
static NSString * const WebApi_Colleaguelist_RemoveFriend = @"api/colleaguelist/removefriend/{friendid}/{tokenid}";
/* 解除星标好友 */
static NSString * const WebApi_Colleaguelist_RemoveEspecially = @"api/contactgroup/removeespecially/{ctid}/{tokenid}";
/* 设为星标好友 */
static NSString * const WebApi_Colleaguelist_AddEspecially = @"api/contactgroup/addespecially/{ctid}/{tokenid}";
/* 好友设置详情 */
static NSString * const WebApi_Colleaguelist_Contact_UpdateUserDetail = @"api/colleaguelist/contact/updateuserdetail/{friendid}/{tokenid}";



/* 新增好友标签 */
static NSString * const WebApi_Colleaguelist_AddContactGroup = @"api/contactgroup/addnewtag/{tokenid}";
/* 移动端标签下选择人员 */
static NSString * const WebApi_Colleaguelist_BatTagAddUsersByMobile = @"api/contactgroup/battagaddusersbymobile/{tagid}/{tokenid}";
/* 移除标签分组 */
static NSString * const WebApi_Colleaguelist_Remove = @"api/contactgroup/remove/{ucgid}/{tokenid}";


/* 获取【常用联系人】信息 */
static NSString * const WebApi_Colleaguelist_OfenCooperation = @"api/colleaguelist/ofencooperation/{tokenid}";
/* 获取【新的好友】的记录 */
static NSString * const WebApi_Colleaguelist_GetUserInterList  = @"api/colleaguelist/getuserinterlist/{tokenid}";
/* 同意新的好友邀请添加 */
static NSString * const WebApi_Colleaguelist_AddFriend  = @"api/colleaguelist/addfriend/{frienid}/{tokenid}";
/* 拒绝新的好友邀请添加 */
static NSString * const WebApi_Colleaguelist_RefuseApply  = @"api/colleaguelist/refuseapply/{frienid}/{tokenid}";
/* 新的好友临时通知数据 */
static NSString * const WebApi_Colleaguelist_GetNewFriendsByuid  = @"api/colleaguelist/getnewfriendsbyuid/{frienduid}/{tokenid}";
/* 新的好友删除好友申请 */
static NSString * const WebApi_Colleaguelist_DeleteFriendApply  = @"api/user/colleaguelist/deletefriendapply/{uiid}/{tokenid}";


/* 获取某个用户在好友的位置，以及返回用户信息 */
static NSString * const WebApi_Colleaguelist_GetAppendUserContact  = @"api/colleaguelist/getappendusercontact/{friendid}/{tokenid}";
/* 删除经常协作人员 */
static NSString * const WebApi_Colleaguelist_RemoveOfterCooperation  = @"api/colleaguelist/removeofencooperation/{tokenid}";
/*获取【新的组织】信息*/
static NSString * const WebApi_Colleaguelist_GetOrgInterListByUid = @"api/colleaguelist/getorginterlistbyuid/{tokenid}";
/* 联系人中添加好友的WebApi(老版本) */
static NSString * const WebApi_Colleaguelist_AddNewFriend = @"api/colleaguelist/userapplyfriend/{tokenid}";
/* 邀请新的好友 */
static NSString * const WebApi_Colleaguelist_AddNewFriend_GraphCode = @"api/colleaguelist/userapplyfriend/graphcode/{tokenid}";

/* 通过登录名得到用户的ID */
static NSString * const WebApi_Colleaguelist_GetUidByLoginName = @"api/user/getuidbyloginname/{loginname}/{tokenid}";
/* 添加经常协作人员 */
static NSString * const WebApi_Colleaguelist_AddOfenCooperation = @"api/colleaguelist/addofencooperations/{tokenid}";
/* 通讯录管理中，根据筛选条件返回某个企业下的用户列表 */
static NSString * const WebApi_Colleaguelist_GetColorgUserByFilter = @"api/colleaguelist/getcolorguserbyfilter/{tokenid}";

/*------------------更多，我的资料-------------------*/
static NSString * const WebApi_CloudUser = @"api/user";
/* 得到用户信息 */
static NSString * const WebApi_CloudUser_LoadUser = @"api/user/loaduser/{tokenid}";
/* 得到我的资料 */
static NSString * const WebApi_CloudUser_List = @"api/user/getusercenter/{tokenid}";
/* 修改个人资料 */
static NSString * const WebApi_CloudUser_Update_User = @"api/user/UpdateUser/{tokenid}";
/* 修改头像 */
static NSString * const WebApi_CloudUser_Update_UserFace = @"api/user/updateuserheadshot/{tokenid}";
/* 组织切换 */
static NSString * const WebApi_CloudUser_Update_Selected_Org = @"api/user/updateselectedorg/{tokenid}";
/* 修改密码 */
static NSString * const WebApi_CloudUser_Update_UserPwdByUp = @"api/user/upadteuserpwdbyup/{tokenid}";
/* 换绑验证密码 */
static NSString * const WebApi_CloudUser_ValidPassword = @"api/user/validpassword/{tokenid}";
/* 判断是否需要对发送手机验证码进行图形校验 */
static NSString * const WebApi_CloudUser_IsNeedMobileValidGraph = @"api/user/isneedmobilevalidgraph/{tokenid}";
/* 发送手机验证码 */
static NSString * const WebApi_CloudUser_SendMobileValidCode = @"api/user/sendmobilevalidcode/{tokenid}";
/* 修改手机号码绑定 */
static NSString * const WebApi_CloudUser_UpdateBindUserPhone = @"api/user/updatebinduserphone/{tokenid}";
/* 判断是否需要对发送邮箱验证码进行图形校验 */
static NSString * const WebApi_CloudUser_IsNeedEmailValidGraph = @"api/user/isneedemailvalidgraph/{tokenid}";
/* 发送邮箱验证码 */
static NSString * const WebApi_CloudUser_SendEmailValidCode = @"api/user/sendemailvalidcode/{tokenid}";
/* 修改邮箱绑定 */
static NSString * const WebApi_CloudUser_UpdateBindUserEmail = @"api/user/updatebinduseremail/{tokenid}";
/* 取消邮箱绑定 */
static NSString * const WebApi_CloudUser_CancelBindEmail = @"api/user/cancelbindemail/{tokenid}";
/* 取消手机绑定 */
static NSString * const WebApi_CloudUser_CancelBindPhone = @"api/user/cancelbindphone/{tokenid}";
/* 切换个人身份 */
static NSString * const WebApi_CloudUser_SwitchPersonidenType = @"api/user/switchpersonidentype/{tokenid}";
/* 组织管理员重置成员密码 */
static NSString * const WebApi_CloudUser_UpadteUserPwdBySetting = @"api/user/upadteuserpwdbysetting/{tokenid}";
/* 用户设置主企业 */
static NSString * const WebApi_CloudUser_SetMainOrg = @"api/user/setmainorg/{oeid}/{tokenid}";
/* 第三方登录成功后保存用户信息 */
static NSString * const WebApi_CloudUser_PerfectLoginInfo = @"api/user/login/oauth/perfectlogininfo/{tokenid}";
/* 解绑微信账号 */
static NSString * const WebApi_CloudUser_CancelBindWeChat = @"api/user/cancelbindwechat/{tokenid}";
/* 解绑微博账号 */
static NSString * const WebApi_CloudUser_CancelBindWeBo = @"api/user/cancelbindwebo/{tokenid}";
/* 解绑腾讯QQ账号 */
static NSString * const WebApi_CloudUser_CancelBindQQ = @"api/user/cancelbindqq/{tokenid}";
/* 登录校验判断验证码 */
static NSString * const WebApi_CloudUser_IsMatchValidCode = @"api/user/ismatchvalidcode/{tokenid}";


