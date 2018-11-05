//
//  EventBusConst.h
//  LeadingCloud
//
//  Created by wchMac on 16/2/17.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#ifndef EventBusConst_h
#define EventBusConst_h


#endif /* EventBusConst_h */

/*----------------------- 登录web服务器 ----------------------- */
static NSString * const EventBus_LoginWebSuccess = @"loginweb_success";
static NSString * const EventBus_LoginWebSuccessForTempNotification = @"loginweb_success_tempnotification";

/*----------------------- 通讯处理类 ----------------------- */
static NSString * const EventBus_ConnectHandle = @"connecthandle";

/*----------------------- 集成第三方登录 ----------------------- */
static NSString * const EventBus_ConnectThirdApp = @"connectthirdapp";
static NSString * const EventBus_LoginThirdApp_NoReg = @"loginthirdapp_noreg";
static NSString * const EventBus_LoginThirdApp_Error = @"loginthirdapp_error";

/*----------------------- 网络状态发生改变 ----------------------- */
static NSString * const EventBus_NetWorkStateChange = @"NetworkStateChange";

/* 连接消息服务器状态 */
/* 登录Web成功 */
static NSString * const LZConnection_Login_Success = @"login_success";
/* 登录Web失败 */
static NSString * const LZConnection_Login_Failure = @"login_failure";

/* 登录状态 */
static NSString * const LZConnection_Login_NetWorkStatus = @"login_networkstatus";
static NSString * const LZConnection_Login_NetWorkStatus_ConnectFail = @"connectfail";
static NSString * const LZConnection_Login_NetWorkStatus_PrepareConect = @"prepareconnect";
static NSString * const LZConnection_Login_NetWorkStatus_Connecting = @"connecting";
static NSString * const LZConnection_Login_NetWorkStatus_NamePwdRight = @"naempwdright";
static NSString * const LZConnection_Login_NetWorkStatus_DbCreateError = @"dbcreateerror";
static NSString * const LZConnection_Login_NetWorkStatus_Connected = @"connected";
static NSString * const LZConnection_Login_NetWorkStatus_RecvFinish = @"recvfinish";

/* 获取TokenID */
static NSString * const EventBus_LZConnection_GetToken = @"gettoken";
static NSString * const LZConnection_GetToken_Success = @"gettoken_success";
static NSString * const LZConnection_GetToken_Failure = @"gettoken_failure";

/* 获取服务器 */
static NSString * const EventBus_LZConnection_GetModuleServer = @"getmoduleserver";
static NSString * const LZConnection_GetModuleServer_Success = @"getmoduleserver_success";
static NSString * const LZConnection_GetModuleServer_Failure = @"getmoduleserver_failure";

/* 连接IM成功 */
static NSString * const LZConnection_Connection_Success = @"connection_success";
/* 连接IM失败 */
static NSString * const LZConnection_Connection_failure = @"connection_failure";

/* 发送成功 */
static NSString * const LZConnection_Send_Success = @"send_success";
/* 发送失败 */
static NSString * const LZConnection_Send_failure = @"send_failure";
/* 自动登录 */
static NSString * const EventBus_AutoLogIn = @"auto_login";
/* passport异常 */
static NSString * const EventBus_PassPort_Error = @"passport_error";

/*----------------------- 通用 ----------------------- */

/* 通用单文本编辑控制器 */
static NSString * const EventBus_LZOneFieldValueEdit_Success = @"lzonefieldvalueedit_success";
/* 文件保存控制器 */
static NSString * const EventBus_MoveFileController_Success = @"savefile_success";
static NSString * const EventBus_SaveFileByBatch_Success = @"savefilebybatch_success";
static NSString * const EventBus_ReplaceFile_Success = @"ReplaceFile_Succes";
/* 文件详情信息获取成功 */
static NSString * const EventBus_FileDetails_Success = @"Details_Success";
/* 限制上传的文件类型 */
static NSString * const EventBus_FileUploadExp_LimitUploadExp = @"fileupload_explimit";
/* 文件保存控制器 */
static NSString * const EventBus_MoveFileController_FolderSuccess = @"saveormovefolder_success";
/* 文件移动成功 */
static NSString * const EventBus_MoveFoleCpnroller_FileSuccess = @"saveormovefile_success";
/* 扫描完成，发送webapi请求之后 */
static NSString * const EventBus_Scan_SendWebApi_Success = @"scan_sengwebapi_success";
/* 扫描完成，关闭扫描页面 */
static NSString * const EventBus_Scan_CloseScanVC = @"scan_closescan_vc";
/* 联系人页签加入组织完成，关闭加入组织页面 */
//static NSString * const EventBus_Contact_CloseJoinOrgVC = @"contact_closejoinorg_vc";

/* 被踢下线 */
static NSString * const EventBus_Login_Quit = @"Login_Quit";

/* 收到消息 */
static NSString * const EventBus_GetMsgForWebView = @"GetMsg_ForWebView";
/* WebView间发送消息 */
static NSString * const EventBus_JSNoticeWebView = @"WebView_JsNotice";
/* 发送数据到webveiw */
static NSString * const EventBus_SendDataToWebView = @"WebView_senddatatowebview";


/* 首次登陆百分比数字 */
static NSString * const EventBus_SendFirstLaunchPercentage = @"Login_SendFirstLaunchPercentage";


/*----------------------- 消息 ----------------------- */

/* webapi，发送成功 */
static NSString * const EventBus_WebApi_SendSuccess = @"webapi_sendsuccess";
/* WebApi，发送失败 */
static NSString * const EventBus_WebApi_SendFail = @"webapi_sendfail";

/* 聊天界面，收到新的消息 */
static NSString * const EventBus_Chat_RecvNewMsg = @"chat_recvnewmsg";
/* 聊天界面，收到系统消息 */
static NSString * const EventBus_Chat_RecvSystemMsg = @"chat_recvsystemmsg";
/* 聊天界面，更新消息发送状态 */
static NSString * const EventBus_Chat_UpdateSendStatus = @"chat_updatechatsendstatus";
/* 聊天界面，撤回消息 */
static NSString * const EventBus_Chat_RecallMsg = @"chat_recallmsg";
/* 聊天界面，删除消息 */
static NSString * const EventBus_Chat_DeleteMsg = @"chat_deleteMsg";
/* 聊天界面，更新语音下载状态 */
static NSString * const EventBus_Chat_UpdateVoiceDownloadStatus = @"chat_updatevoicedownloadstatus";
/* 聊天界面，收到已读通知 */
static NSString * const EventBus_Chat_RecvReadList = @"chat_readlist";
/* 聊天界面，更新消息审批状态 */
static NSString * const EventBus_Chat_UpdateMsgStatus = @"chat_updatechatmsgstatus";
/* 消息页签，收到新消息后刷新 */
static NSString * const EventBus_Chat_RefreshMessageRootVC = @"chat_refreshmessagerootvc";
/* 消息页签，刷新headerView */
static NSString * const EventBus_Chat_RefreshMessageRootHeaderView = @"chat_refreshmessagerootheaderView";
/* 消息页签，立刻刷新消息页签 */
static NSString * const EventBus_Chat_RefreshMessageRootVC_Now = @"chat_refreshmessagerootvc_now";
/* 二级消息列表刷新 */
static NSString * const EventBus_Chat_RefreshSecondMsgVC = @"chat_refreshsecondmsgvc";
/* 聊天界面，收到消息下载完成通知 */
static NSString * const EventBus_Chat_DownloadChatlog = @"chat_download_chatloglist";
/* 清空聊天记录 */
static NSString * const EventBus_Chat_ClearChatlog = @"chat_clear_chatlog";
/* 获取消息的读取状态 */
static NSString * const EventBus_Chat_GetMessageReadStatus = @"chat_getmessagereadstatus";
/* 在消息列表中定位 */
static NSString * const EventBus_Chat_LocalInChat = @"chat_localinchat";
/* 修改是否通知手机端的属性 */
static NSString * const EventBus_Chat_UpdatePushState = @"chat_updatepushstate";
/* PC端退出登录 */
static NSString * const EventBus_Chat_KickOutPC = @"chat_kickoutpc";

/* 添加群组 */
static NSString * const EventBus_Chat_ImGroup_Add = @"chat_imgroup_add";
/* 扫描二维码加入群组 */
static NSString * const EventBus_Chat_Group_ScanJoin = @"chat_group_scanjoin";
/* 申请加入群组 */
static NSString * const EventBus_Chat_ApplyJoinGroup = @"chat_applyjoingroup";
/* 获取群组信息 */
static NSString * const EventBus_Chat_GetGroupInfo = @"chat_getgroupinfo";
/* 获取某个群组的信息(包含当前群组人数和当前人是否在群组中) */
static NSString * const EventBus_Chat_GetGroupBaseInfo = @"chat_getgroupbaseinfo";
/* 查找群组中的用户 */
static NSString * const EventBus_WebApi_SearchGroupUser = @"webapi_search_groupuser";
/* 聊天会话置顶 */
static NSString * const EventBus_WebApi_SetRecentStick = @"webapi_setrecentstick";
/* 设置个人免打扰 */
static NSString * const EventBus_WebApi_SetRecentOneDisturb = @"webapi_setrecentdisturb";

/*----------------------业务会话-------------------------*/
/* 获取会话记录列表 */
static NSString * const EventBus_BusinessSession_Recent = @"businesssession_recent";
/* 获取业务会话工具列表 */
static NSString * const EventBus_BusinessSession_Tool_Usable = @"businesssession_tool_usable";
/* 获取实例下的会话列表 */
static NSString * const EventBus_BusinessSession_Recent_Acquirelist = @"businesssession_recent_acquirelist";
/* 创建业务会话 */
static NSString * const EventBus_BusinessSession_Recent_Create = @"businesssession_recent_create";
/* 根据bsiid获取会话示例数据 */
static NSString * const EventBus_BusinessSession_Ins_Acquire = @"businesssession_ins_acquire";
/* 业务扩展类型数据 */
static NSString * const EventBus_BusinessSession_GetExtendTypeByCode = @"businesssession_getextendtypebycode";
/* 表单列表数据 */
static NSString * const EventBus_BusinessSession_GetBsFormList = @"businesssession_getbsformlist";
/* 附件列表数据 */
static NSString * const EventBus_BusinessSession_AttachSetAcquireList = @"businesssession_attachsetacquirelist";
/* 获取附件列表中详细数据 */
static NSString * const EventBus_BusinessSession_AttachAcquireAll = @"businesssession_attachacquireall";
/* 获取附件相关信息 */
static NSString * const EventBus_BusinessSession_AttachSetAcquire = @"businesssession_attachsetacquire";
/* 附件上传完以后写入附件信息 */
static NSString * const EventBus_BusinessSession_AttachSetAdd = @"businesssession_attachsetadd";
/* 附件删除 */
static NSString * const EventBus_BusinessSession_Delete = @"businesssession_delete";
/* 会话状态权限判断 */
static NSString * const EventBus_BusinessSession_ProcessingAuthority = @"businesssession_processingauthority";
/* 根据检索条件获取会话记录列表 */
static NSString * const EventBus_BusinessSession_Search = @"businesssession_search";


/* 新的好友 */
static NSString * const EventBus_Colleaguelist_GetUserInterList = @"colleaguelist_getuserinterlist";
/* 新的好友同意添加 */
static NSString * const EventBus_Colleaguelist_AddFriend = @"colleaguelist_addfriend";
/* 新的好友拒绝添加 */
static NSString * const EventBus_Colleaguelist_RefuseApply = @"colleaguelist_refuseapply";
/* 新的好友临时通知数据处理 */
static NSString * const EventBus_Colleaguelist_NewFriend_Notice = @"colleaguelist_newfriend_notice";
/* 新的好友临时通知得到数据 */
static NSString * const EventBus_Colleaguelist_NewFriend_Data = @"colleaguelist_newfriend_data";
/* 新的好友临时通知同意 */
static NSString * const EventBus_Colleaguelist_AgreeFriend = @"colleaguelist_agreefriend";
/* 新的好友临时通知拒绝 */
static NSString * const EventBus_Colleaguelist_RefuseFriend = @"colleaguelist_refusefriend";
/* 新的好友临时通知删除 */
static NSString * const EventBus_Colleaguelist_DeleteInvite = @"colleaguelist_deleteinvite";
/* 新的好友添加标签分组 */
static NSString * const EventBus_Colleaguelist_AddContactGroup = @"colleaguelist_addcontactgroup";
/* 刷新经常协作人员 */
static NSString * const EventBus_Colleaguelist_ReloadOfenCooperation = @"colleaguelist_reloadfencooperaion";
/* 我的好友列表数据发生变化 */
static NSString * const EventBus_Colleaguelist_RefreshContactFriendList = @"colleaguelist_refreshcontactfriendlist";
/* 添加星标好友通知 */
static NSString * const EventBus_Colleaguelist_SetEspecial = @"colleaguelist_setespecial";
/* 移除星标好友通知 */
static NSString * const EventBus_Colleaguelist_RemoveEspecial = @"colleaguelist_removeespecial";
/* 好友信息界面数据发送变化 */
static NSString * const EventBus_Colleaguelist_RefreshContactFriendInfoVC = @"colleaguelist_refreshcontactfriendinfovc";
/* 移动端标签下选择人员 */
static NSString * const EventBus_Colleaguelist_BatTagAddUsersByMobile = @"colleaguelist_battagaddusersbymobile";
/* 用户详细信息 */
static NSString * const EventBus_Colleaguelist_BusinessCardForMobile = @"colleaguelist_businesscardformobile";
/* 添加好友 */
static NSString * const EventBus_Colleaguelist_InviteFriend = @"colleaguelist_invitefriend";
/* 解除好友关系 */
static NSString * const EventBus_Colleaguelist_RemoveFriend = @"colleaguelist_removefriend";
/* 解除星标好友 */
static NSString * const EventBus_Colleaguelist_RemoveEspecially = @"colleaguelist_removeespecially";
/* 设为星标好友 */
static NSString * const EventBus_Colleaguelist_AddEspecially = @"colleaguelist_addespecially";
/* 新的好友删除好友申请 */
static NSString * const EventBus_Colleaguelist_DeleteFriendApply = @"colleaguelist_deletefriendapply";
/* 标签分组删除 */
static NSString * const EventBus_Colleaguelist_RemoveLabelInfo = @"colleaguelist_removelabelinfo";
/* 通讯录管理中，根据筛选条件返回某个企业下的用户列表 */
static NSString * const EventBus_Colleaguelist_GetColorgUserByFilter = @"colleaguelist_getcolorguserbyfilter";
/* 设置详情 */
static NSString * const EventBus_Colleaguelist_UpdateUserDetail = @"colleaguelist_updateuserdetail";




/* 新的员工所有成员列表 */
static NSString * const EventBus_Organization_GetMsgUserApplyList = @"organization_getmsguserapplylist";
/* 获取组织申请成员列表 */
static NSString * const EventBus_Organization_GetOrgUsrapplyList = @"organization_getorgusrapplylist";
/* 新的员工同意 */
static NSString * const EventBus_Organization_AcceptApplyUser = @"organization_acceptapplyuser";
/* 新的员工拒绝 */
static NSString * const EventBus_Organization_RefuseApplyUser = @"organization_refuseapplyuser";
/* 新的员工临时通知数据 */
static NSString * const EventBus_Organization_GetOrgUserJoinApply = @"organization_getorguserjoinapply";
/* 获取某个组织下某人的申请记录信息 */
static NSString * const EventBus_Organization_GetOrgUserApplyModelByKey = @"organization_getorguserapplymodelbykey";
/* 新的员工-管理员同意用户申请 */
static NSString * const EventBus_Organization_OrgAgreeUserApply = @"organization_orgagreeuserapply";
/* 新的员工-管理员拒绝用户申请 */
static NSString * const EventBus_Organization_OrgUserRefuseApply = @"organization_orguserrefuseapply";



/* 新的组织 */
static NSString * const EventBus_Colleaguelist_NewOrgs = @"colleaguelist_neworgs";
/* 好友信息 */
static NSString * const EventBus_Colleaguelist_GetContactList = @"colleaguelist_getcontactlist";

/* 创建组织 */
static NSString * const EventBus_Organization_Create_EnterPrise = @"organization_create_enterPrise";
/* 查找组织 */
static NSString * const EventBus_Organization_ExistOrgByCode = @"organization_existOrgByCode";
/* 申请加入组织 */
static NSString * const EventBus_Organization_ApplyJoinOrg = @"organization_applyJoinOrg";
/* 组织切换 */
static NSString * const EventBus_Organization_Update_Selected_Org = @"organization_update_selected_org";
/* 个人组织信息 */
static NSString * const EventBus_Organization_GetBasic_Byenters_User = @"organization_getbasic_byenters_user";
/* 新的组织接受调用 */
static NSString * const EventBus_Organization_ApproveOrgIntervate = @"organization_ApproveOrgIntervate";
/* 得到一个组织部门的信息 */
static NSString * const EventBus_Organization_GetDept = @"Organization_GetDept";
/* 新的组织拒绝调用 */
static NSString * const EventBus_Organization_RefuseOrgUserIntervate = @"organization_RefuseOrgUserIntervate";
/* 新的组织临时通知数据处理 */
static NSString * const EventBus_Organization_GetOrgUserInterInfoByUidOeid = @"organization_GetOrgUserInterInfoByUidOeid";
/* 新的组织临时通知数据得到 */
static NSString * const EventBus_Organization_GetOrgUserInterInfoByUidOeidData = @"organization_GetOrgUserInterInfoByUidOeidData";
//* 加入群组 得到部门信息
static NSString * const EventBus_Organization_GetOrgbyuid = @"organization_getorgbyuid";
/* 解散组织临时通知数据得到（移除部门下成员也走这个通知） */
static NSString * const EventBus_Organization_GetOrgUserDisBandOrgByOeid = @"organization_GetOrgUserDisBandOrgByOeid";
/* 修改组织信息 */
static NSString * const EventBus_Organization_UpdateEnterprise = @"organization_UpdateEnterprise";
/* 新的组织-用户同意组织的邀请 */
static NSString * const EventBus_Organization_OrgUserApproveIntervate = @"organization_orguserapproveintervate";
/* 新的组织-组织撤销邀请用户 */
static NSString * const EventBus_Organization_RevokeInterUser = @"organization_revokeinteruser";
/* 新的组织-用户拒绝组织的邀请 */
static NSString * const EventBus_Organization_RefuseInvite = @"organization_refuseinvite";



/* 获取所有的组织结构 */
static NSString * const EventBus_Organization_GetBelongOrgs = @"organization_GetBelongOrgs";
/* 组织通讯录数据发送变化 */
static NSString * const EventBus_Organization_RefreshContactRoot = @"organization_refreshcontactroot";
/* 修改用户在企业下的名称 */
static NSString * const EventBus_Organization_OrgUserUpdateEnterUsername = @"organization_orguserupdateenterusername";
/* 移除部门下的人员 */
static NSString * const EventBus_Organization_OrgUserRemoveUser = @"organization_orguserremoveuser";

/* 通知，被设置为企业管理员 */
static NSString * const EventBus_Organization_Admin_SetEnterpriseAdmin = @"organization_admin_setenterpriseadmin";
/* 通知，被取消企业管理员 */
static NSString * const EventBus_Organization_Admin_CancleEnterpriseAdmin = @"organization_admin_cancleaEnterprisedmin";
/* 通知，被设置为部门管理员 */
static NSString * const EventBus_Organization_Admin_SetOrgAdmin = @"organization_admin_setorgadmin";
/* 通知，被取消部门管理员 */
static NSString * const EventBus_Organization_Admin_CancleOrgAdmin = @"organization_admin_cancleaorgedmin";

/*----------------------组织机构，岗位-------------------------*/
/* 获取岗位列表 */
static NSString * const EventBus_Organization_GetOrgPostList = @"orgpost_getorgpostlist";
/* 获取企业下基准岗位（职务）列表 */
static NSString * const EventBus_Organization_GetOrgBaseList = @"orgpost_getorgbaselist";

/*----------------------群设置-------------------------*/
/* 消息免打扰设置 */
static NSString * const EventBus_ChatGroup_Disturb = @"chatgroup_disturb";
/* 保存到通讯录 */
static NSString * const EventBus_ChatGroup_SaveToAddress = @"chatgroup_savetoaddress";
/* 添加群成员 */
static NSString * const EventBus_ChatGroup_AddMember = @"chatgroup_addmember";
/* 获取群信息 */
static NSString * const EventBus_ChatGroup_GetGroupListByPages = @"chatgroup_getgrouplistbypages";
/* 分页获取群成员 */
static NSString * const EventBus_ChatGroup_GetGroupUsersByPages = @"chatgroup_getgroupusersbypages";
/* 移除群成员 */
static NSString * const EventBus_ChatGroup_RemoveMember = @"chatgroup_removemember";
/* 退出群组,被移除 */
static NSString * const EventBus_ChatGroup_DeleteGroup = @"chatgroup_deltegroup";
/* 转让群主 */
static NSString * const EventBus_ChatGroup_AssignAdmin = @"chatgroup_assignadmin";
/* 修改群名称 */
static NSString * const EventBus_ChatGroup_ModifyGroupName = @"chatgroup_modifygroupname";
/* 开启、关闭群组 */
static NSString * const EventBus_ChatGroup_OperOrCloseGroup = @"chatgroup_openorclosegroup";
/* 新成员加入查看聊天记录 */
static NSString * const EventBus_ChatGroup_UpdateGroupIsLoadMsg = @"chatgroup_updategroupisloadmsg";
/* 显示绑定的群组的群主 */
static NSString * const EventBus_ChatGroup_GetCreateUserIdByGroupIdOrRelateId = @"chatgroup_getcreateuseridbygroupidorrelateid";
/* 根据消息群组ID获取该群组内机器人列表 */
static NSString * const EventBus_ChatGroup_GetGroupRobot = @"chatgroup_getgrouprobot";
/* 所有机器人列表 */
static NSString * const EventBus_ChatGroup_GetRobot = @"chatgroup_getrobot";
/* 单个机器人 */
static NSString * const EventBus_ChatGroup_GetRobotForRiid = @"chatgroup_getrobotforriid";
/* 设置绑定的群组的群主 */
static NSString * const EventBus_ChatGroup_SetImGroupByRelateId = @"chatgroup_setimgroupbyrelateid";
/* 添加天气机器人 */
static NSString * const EventBus_ChatGroup_AddWeatherRobotExample = @"chatgroup_addweatherrobotexample";
/* 删除天气机器人 */
static NSString * const EventBus_ChatGroup_DeleteWeatherRobotExample = @"chatgroup_deleteweatherrobotexample";
/* 获得天气机器人 */
static NSString * const EventBus_ChatGroup_GetWeatherRobotExample = @"chatgroup_getweatherrobotexample";
/* 修改天气机器人 */
static NSString * const EventBus_ChatGroup_UpdateWeatherRobotExample = @"chatgroup_updateweatherrobotexample";

/*-----------------------     应用    ----------------------- */

static NSString * const EventBus_App_IOSApp = @"app_iosapp";
static NSString * const EventBus_App_Org_IOSApp = @"app_org_iosapp";
static NSString * const EventBus_App_Org_GetPhoneUserOrgModel = @"app_org_getphoneuserorgmodel";
static NSString * const EventBus_App_Org_GetPhoneUserOrgModel_SelectApp = @"app_org_getphoneuserorgmodel_selectapp";
static NSString * const EventBus_App_Org_GetPhoneMoreModel = @"app_org_getphonemoremodel";
static NSString * const EventBus_App_Org_SaveUserOrgModel = @"app_org_saveuserorgmodel";
static NSString * const EventBus_App_Org_GetAppNumber = @"app_org_getappnumber";
static NSString * const EventBus_App_GetMagApp = @"app_getmagapp";


static NSString * const EventBus_App_Jurisdiction_Disabled = @"app_jurisdiction_disabled";
static NSString * const EventBus_App_Jurisdiction_Enable = @"app_jurisdiction_enable";
static NSString * const EventBus_App_Jurisdiction_Available = @"app_jurisdiction_available";
static NSString * const EventBus_App_Jurisdiction_Unavailable = @"app_jurisdiction_unavailable";
static NSString * const EventBus_App_Remind = @"app_remind";
static NSString * const EventBus_App_OprnVPNApp = @"app_openvpnapp";

/* 刷新应用页签数据 */
static NSString * const EventBus_App_RefreshAppRootVC = @"app_RefreshAppRootVC";

/*-----------------------     服务圈    ----------------------- */
/* 我加入的服务圈 */
static NSString * const EventBus_ServiceCircles_Join_Getlist = @"ServiceCircles_Join_Getlist";
/* 推荐的服务圈 */
static NSString * const EventBus_ServiceCircles_Recommended_Getlist = @"ServiceCircles_Recommended_Getlist";
/* 搜索的服务圈 */
static NSString * const EventBus_ServiceCircles_Search_Getlist = @"ServiceCircles_Search_Getlist";

/* 设置首页服务圈 */
static NSString * const EventBus_ServiceCircles_Setisfirstpage = @"ServiceCircles_Setisfirstpage";
/* 得到首页服务圈 */
static NSString * const EventBus_ServiceCircles_Firstpage = @"ServiceCircles_Firstpage";

/*----------------------- 云盘 ----------------------- */
static NSString * const EventBus_App_Res_NetDiskIndex = @"app_res_netdiskindex";
static NSString * const EventBus_App_Res_NetDiskIndex_AddResource = @"app_res_netdiskindex_addresource";
static NSString * const EventBus_App_Res_NetDiskIndex_getFolderData = @"app_res_netdiskindex_getfolderdata";

static NSString * const EventBus_App_Res_AddResourceFromNetDisk = @"app_res_addresourcefromnetdisk";

static NSString * const EventBus_App_Res_NetDiskIndex_EditFolder = @"app_folder_netdiskindex_editfolder";
static NSString * const EventBus_App_Res_NetDiskIndex_DelFolder = @"app_folder_netdisk_delfolder";
static NSString * const EventBus_App_Res_NetDiskIndex_DelFile = @"app_file_netdisk_delfile";
static NSString * const EventBus_App_Res_NetDiskIndex_ReNameResource = @"app_file_netdisk_renameresource";
static NSString * const EventBus_App_Res_NetDiskIndex_GetFolderList = @"app_folder_netdisk_GetFolderList";
static NSString * const EventBus_App_Res_NetDiskIndex_DelMoreResoure = @"app_editecontroller_delmoreresource";
static NSString * const EventBus_App_Res_NetDiskIndex_FolderMove = @"app_folder_movefolder";
static NSString * const EventBus_App_Res_NetDiskIndex_MoveController = @"app_folder_movecontroller";
static NSString * const EventBus_App_Res_NetDiskIndex_FileMove = @"app_file_movefile";
static NSString * const EventBus_App_Res_NetDiskIndex_FileVersion = @"app_file_version";
static NSString * const EventBus_App_Res_NetDiskIndex_UpgradeFile = @"app_file_upgradefile";
static NSString * const EventBus_App_Res_NetDiskIndex_ReplaceFile = @"app_file_replacefile";
static NSString * const EventBus_App_Res_MixDownload = @"app_file_mixdownload";
static NSString * const EventBus_App_Res_FileBagContext = @"app_file_filebag";

static NSString * const EventBus_App_Res_NetDiskIndex_GetFolderRpid = @"app_netdiskfolder_getrpid";
static NSString * const EventBus_App_ResFolder_PullDownFolder = @"app_netdiskfolder_pulldownfolder";

static NSString * const EventBus_App_Recycle_NetDiskIndex_RecycleList = @"app_recycle_recyclelist";
static NSString * const EventBus_App_Recycle_NetDiskIndex_Del = @"app_recycle_del";
static NSString * const EventBus_App_Recycle_NetDiskIndex_DelAllRecycleData = @"app_recycle_delallrecycledata";
static NSString * const EventBus_App_Recycle_NetDiskIndex_Reduction = @"app_recycle_reduction";

static NSString * const EventBus_App_Res_NetDiskIndex_NetFileSelectController = @"app_netfileselectcontroller";
// 收藏
static NSString * const EventBus_App_Collection_NetDiskIndex_AddCollection = @"app_collection_addcollection";
static NSString * const EventBus_App_Collection_NetDisk_CollectionList = @"app_collection_collectionList";
static NSString * const EventBus_App_Collection_NetDisk_CancelCollection = @"app_collection_cancelcollection";

// 分享
static NSString * const EventBus_App_NetDiskIndex_ResShare = @"app_resshare";
static NSString * const EventBus_App_NetDiskShare_Share = @"app_NetDisk_Share";
static NSString * const EventBus_App_NetDiskShare_CancelShare = @"app_netdisk_cancelshare";
static NSString * const EventBus_App_NetDiskShare_ShareModelInfo = @"app_netdisk_sharemodelinfo";
static NSString * const EventBus_App_NetDiskShare_InputPassword = @"app_netdisk_InputPassword";
static NSString * const EventBus_App_NetDiskShare_ShareNotExist = @"app_shareFile_notexist";
static NSString * const EventBus_App_NetDiskShare_Notice_CancelShare = @"app_netdisk_not_cancleshare";
static NSString * const EventBus_App_NetDiskShare_Notice_AddShare = @"app_netdisk_not_addshare";
static NSString * const EventBus_App_NetDiskShare_GetShareItemInfo = @"app_netdisk_getshareiteminfo";
static NSString * const EventBus_App_NetDiskShare_SaveShareItemToNet = @"app_netdisk_SaveShareItemToNet";
static NSString * const EventBus_App_NetDiskShare_GetShareModelInfo = @"app_netdisk_GetShareModelInfo";

// 回收站
static NSString * const EventBus_App_NetDiskRecycle_Notice_Delete = @"netdiskrecycle_notice_delete";
static NSString * const EventBus_App_NetDiskRecycle_Notice_ClearAll = @"netdiskrecycle_notice_clearall";


// 组织云盘
static NSString * const EventBus_App_NetDiskOrganization_OrganizationModel = @"NetDiskOrganization_OrganizationModel";
static NSString * const EventBus_App_NetDiskApp_Size = @"App_NetDiskApp_Size";
static NSString * const EventBus_App_NetDiskOrganization_OrganizationNormalList = @"NetDiskOrganization_OrganizationNormalList";
static NSString * const EventBus_App_NetDiskOrganization_OrganizationNormalList_SearchResult = @"NetDiskOrganization_OrganizationNormalList_rearchresulrt";
static NSString * const EventBus_App_NetDiskOrganization_GetAllFolderWithRpid = @"NetDiskOrganization_getallfolder";
/*----------------------- 协作 -----------------------*/
static NSString * const EventBus_Coo_WorkGroupParse = @"Coo_WorkGroupParse";
static NSString * const EventBus_Coo_WorkGroupParse_List = @"Coo_WorkGroupParse_list";
static NSString * const EventBus_Coo_WorkGroupParse_OrgList = @"Coo_WorkGroupParse_Orglist";
static NSString * const EventBus_Coo_WorkGroupParse_Create = @"Coo_WorkGroupParse_Create";
static NSString * const EventBus_Coo_WorkGroupParse_Detial = @"Coo_WorkGroupParse_Detial";
static NSString * const EventBus_Coo_WorkGroupParse_Detial_JsonData = @"EventBus_Coo_WorkGroupParse_Detial_JsonData";
static NSString * const EventBus_Coo_WorkGroupParse_Modify = @"Coo_WorkGroupParse_Modify";
static NSString * const EventBus_Coo_WorkGroupParse_BaseInfo = @"Coo_WorkGroupParse_baseinfo";
static NSString * const EventBus_Coo_WorkGroupParse_PostgroupList = @"Coo_WorkGroupParse_postgroupList";

static NSString * const EventBus_Coo_WorkGroupParse_Set = @"Coo_WorkGroupParse_Set";
static NSString * const EventBus_Coo_WorkGroupParse_Logo = @"Coo_WorkGroupParse_Logo";
static NSString * const EventBus_Coo_WorkGroupParse_Join = @"Coo_WorkGroupParse_Join";
static NSString * const EventBus_Coo_WorkGroupParse_Join_gid = @"Coo_WorkGroupParse_Join_gid";
static NSString * const EventBus_Coo_WorkGroupParse_ApplyJoing = @"Coo_WorkGroupParse_ApplyJoing";
static NSString * const EventBus_Coo_WorkGroupParse_Set_ApplyRoot = @"Coo_WorkGroupParse_Set_ApplyRoot";
static NSString * const EventBus_Coo_WorkGroupParse_Set_Logo_Image = @"Coo_WorkGroupParse_Set_Logo_Image";

/*----------------------- 协作,项目 -----------------------*/
// 项目分组列表
static NSString * const EventBus_Coo_ProjectMainGroupList = @"coo_projectmain_projectmaingroup_list";
static NSString * const EventBus_Coo_ProjectMainGroupListForPull = @"coo_projectmain_projectmaingroup_listforpull";
static NSString * const EventBus_Coo_ProjectMainGroupDelete = @"coo_projectmain_projectmaingroup_delete";
static NSString * const EventBus_Coo_ProjectMainGroupSortSuccess = @"coo_projectmain_projectmaingroup_sortsuccess";
static NSString * const EventBus_Coo_ProjectMainGetProjectsList = @"coo_projectmain_projectmaingroup_getprojectslist";
static NSString * const EventBus_Coo_ProjectMainGetProjectsListForPull = @"coo_projectmain_projectmaingroup_getprojectslistforpull";
static NSString * const EventBus_Coo_ProjectMainSetProjectNewGroup = @"coo_projectmain_projectmaingroup_setprojectgroup";
static NSString * const EventBus_Coo_ProjectMainSetProjectTopAction = @"coo_projectmain_projectmaingroup_setprojecttopaction";
static NSString * const EventBus_Coo_ProjectMainGetProjectsWithSearch = @"coo_projectmain_getprojectwithsearch";
static NSString * const EventBus_Coo_ProjectMainSetGetProjectMain = @"coo_projectmain_projectmainsetgetprojectmain";
static NSString * const EventBus_Coo_ProjectMainGetAllProject = @"coo_projectmain_projectmaingetallproject";


//项目下应用模块
static NSString * const EventBus_Coo_ProjectMainSetProjectGetMods = @"coo_projectmain_projectmaingroup_setprojectgetmods";
static NSString * const EventBus_Coo_ProjectMainSetProjectGetAllMods = @"coo_projectmain_projectmaingroup_setprojectgetallmods";
static NSString * const EventBus_Coo_ProjectMainSetResetProjectMods = @"coo_projectmain_projectmaingroup_setresetprojectmods";



//工作组-文件
static NSString * const EventBus_Coo_WorkGroupFile_GetResource = @"coo_workfile_getresource";
// 工作组-下级文件
static NSString * const EventBus_Coo_WorkGroupNextFile_GetNextRes = @"coo_WorkGroup_getnextRes";
// 工作组-新增文件夹
static NSString * const EventBus_Coo_WorkGroupFolder_AddFolder = @"coo_workGroup_addFolder";
// 工作组-修改文件夹名称
static NSString * const EventBus_Coo_WorkGroup_EditFolderName = @"coo_workGroup_editfoldername";
// 工作组-修改文件名称
static NSString * const EventBus_Coo_WorkGroup_EditFileName = @"coo_workGroup_editfilename";
// 工作组 - 删除文件夹
static NSString * const EventBus_Coo_WorkGroup_DelFolder = @"coo_workGroup_delfolder";
// 工作组 - 删除文件
static NSString * const EventBus_Coo_WorkGroup_DelFile = @"coo_workGroup_delfile";
// 工作组- 文件夹得移动
static NSString * const EventBus_Coo_WorkGroup_MoveFolder = @"coo_workgroup_movefolder";
// 工作组 - 文件的移动
static NSString * const EventBus_Coo_WorkGroup_MoveFile = @"coo_workgroup_movefile";
// 工作组 - 获取资源信息
static NSString * const EventBus_Coo_WorkGroup_GetResourceInfo = @"coo_workgroup_getresourceinfo";
// 获取文件夹信息
static NSString * const EventBus_Coo_WorkGroup_GetFolderInfo = @"coo_workgroup_getfolderinfo";
// 文件上传
static NSString * const EventBus_Coo_WorkGroup_UploadResource = @"coowoukgroup_uploadresource";
// 保存文件夹到云盘
static NSString * const EventBus_Coo_WorkGroup_SaveFolderToNet = @"cooworkgroup_savefolderTonetdisk";
// 保存文件到云盘
static NSString * const EventBus_Coo_WorkGroup_SaveFileToNet = @"cooworkgroup_savefiletonetdisk";
static NSString * const EventBus_Coo_GroupFile_NetAddResource = @"coo_GroupFile_netaddresouce";
// 导入云盘文件
static NSString * const EventBus_Coo_WorkGroup_ImportNetDiskResource = @"coowoukgroup_ImportNetDiskResource";

static NSString * const EventBus_Coo_TaskParse_Creat = @"Coo_TaskParse_Creat";
static NSString * const EventBus_Coo_TaskParse_List = @"Coo_TaskParse_List";
static NSString * const EventBus_Coo_TaskParse_Child_List = @"Coo_TaskParse_Child_List";

static NSString * const EventBus_Coo_Eef_Task_WorkGroup_List = @"Coo_Eef_Task_WorkGroup_List";
static NSString * const EventBus_Coo_Ref_Task_WorkGroup__ALL_List = @"Coo_Ref_Task_WorkGroup__ALL_List";
static NSString * const EventBus_Coo_Ref_Task_Project_ALL_List = @"Coo_Ref_Task_WorkGroup__ALL_List";
static NSString * const EventBus_Coo_Eef_Task_Project_List = @"Coo_Eef_Task_Project_List";

static NSString * const EventBus_Coo_TaskParse_Join = @"Coo_TaskParse_Join";
static NSString * const EventBus_Coo_TaskParse_Join_Tid = @"Coo_TaskParse_Join_Tid";

static NSString * const EventBus_Coo_TaskParse_Detial = @"Coo_TaskParse_Detial";
static NSString * const EventBus_Coo_TaskParse_BaseNewInfo = @"coo_BaseNew_info";
static NSString * const EventBus_Coo_TaskParse_Goal = @"coo_Goal";

//任务基本信息 （父任务名称使用）
static NSString * const EventBus_Coo_TaskParse_Info = @"coo_taskparse_info";
static NSString * const EventBus_Coo_TaskParse_SetInfo = @"coo_taskparse_set_info";
static NSString * const EventBus_Coo_TaskParse_SetName = @"coo_taskparse_set_Name";

static NSString * const EventBus_Coo_TaskParse_Set_ApplyRoot = @"Coo_TaskParse_Set_ApplyRoot";

// 控制显隐
/* 任务 */
static NSString * const EventBus_Coo_TaskPase_DetialTool = @"coo_taskparse_apptool";
static NSString * const EventBus_Coo_TaskParse_InfoIsHiden = @"coo_taskparse_infohiden";
/* 工作组 */
static NSString * const EventBus_Coo_GroupPase_DetialTool = @"coo_groupparse_apptool";

static NSString * const EventBus_Coo_TaskParsePhase_Creat = @"Coo_TaskParsePhase_Creat";
static NSString * const EventBus_Coo_TaskParsePhase_Edit = @"Coo_TaskParsePhase_Edit";
static NSString * const EventBus_Coo_TaskRelateGroupPhase_Add = @"Coo_TaskRelateGroupPhase_Add";
static NSString * const EventBus_Coo_TaskRelateGroupPhase_Del = @"Coo_TaskRelateGroupPhase_Del";

static NSString * const EventBus_Coo_TaskRelateProjectPhase_Add = @"Coo_TaskRelateProjectPhase_Add";
static NSString * const EventBus_Coo_TaskRelateProjectPhase_Del = @"Coo_TaskRelateProjectPhase_Del";
//任务管理员
static NSString * const EventBus_Coo_TaskSetAdmins = @"Coo_TaskSetAdmins";

static NSString * const EventBus_Load_RelateTaskList = @"Load_RelateTaskList";

//任务成员身份
static NSString * const EventBus_Coo_TaskSetMemberIdentity= @"Coo_TaskSetMemberIdentity";


//设置关联母任务
static NSString * const EventBus_Coo_Modify_Relate_Task = @"Coo_Modify_Relate_Task";

//项目

//新建项目
static NSString * const EventBus_Coo_Add_Project = @"Coo_Add_Project";
//项目列表
static NSString * const EventBus_Coo_List_Project = @"Coo_List_Project";
//项目详情
static NSString * const EventBus_Coo_Base_Info_Project = @"Coo_Base_Info_Project";
//项目基本信息修改
static NSString * const EventBus_Coo_Edit_Info_Project = @"Coo_Edit_Info_Project";
//项目全部任务修改
static NSString * const EventBus_Coo_All_Task_Project = @"Coo_All_Task_Project";


//事务
//事务列表
static NSString * const EventBus_Coo_Transaction_List = @"Coo_Transaction_List";
//岗位列表
static NSString * const EventBus_Coo_Transaction_PostInfo_List = @"Coo_Transaction_PostInfo_List";

//新的处理列表
static NSString * const EventBus_Coo_Transaction_NewTodo_List = @"Coo_Transaction_NewTodo_List";

//筛选列表
static NSString * const EventBus_Coo_Transaction_Filter_List = @"Coo_Transaction_Filter_List";
//事务状态数量
static NSString * const EventBus_Coo_Transaction_Status_Count = @"Coo_Transaction_Status_Count";
//事务状态数量
static NSString * const EventBus_Coo_Transaction_New_Tolo_Count = @"Coo_Transaction_New_Tolo_Count";

//事务状态改变  del
static NSString * const EventBus_Coo_Transaction_Status_Change = @"Coo_Transaction_Status_Change";

//事务当前状态当前条件数量
static NSString * const EventBus_Coo_Transaction_Contion_Count = @"Coo_Transaction_Contion_Count";

//事务当前状态当前条件数量
static NSString * const EventBus_Coo_Transaction_Model_Type = @"Coo_Transaction_Model_Type";

//协作成员
static NSString * const EventBus_Coo_SetAdmins = @"Coo_SetAdmins";
static NSString * const EventBus_Coo_SetChange = @"Coo_SetChange";

static NSString * const EventBus_Coo_RemoveMember = @"Coo_RemoveMember";
static NSString * const EventBus_Member_AfreshAdd = @"Coo_Member_AfreshAdd";
static NSString * const EventBus_Member_RevokeAdd = @"Coo_Member_RevokeAdd";
static NSString * const EventBus_Coo_Member_Add = @"Coo_Member_Add";
static NSString * const EventBus_Coo_Member_List = @"Coo_Member_List";
static NSString * const EventBus_Coo_Member_Search_List = @"Coo_Member_Search_List";

static NSString * const EventBus_Coo_Member_Valid_List = @"Coo_Member_valid_List";
static NSString * const EventBus_Coo_Member_Quit = @"Coo_Member_Quit";

static NSString * const EventBus_Coo_Set_MemberOrg = @"Coo_Set_MemberOrg";

static NSString * const EventBus_Coo_Member_Exist = @"Coo_Member_Exist";
static NSString * const EventBus_Coo_Member_ObservreList = @"Coo_Member_ObservreList";
static NSString * const EventBus_Coo_Member_DelObservre = @"Coo_Member_DelObservre";
static NSString * const EventBus_Coo_Member_AddObservre = @"Coo_Member_AddObservre";
static NSString * const EventBus_Coo_Member_Subscribe = @"Coo_Member_Subscribe";
static NSString * const EventBus_Coo_Member_ResSubscribe = @"Coo_Member_ResSubscribe";


//得到igid 聊天id
static NSString * const EventBus_Coo_Get_igid = @"Coo_Get_igid";

static NSString * const EventBus_Coo_TaskSetStaut = @"Coo_TaskSetStaut";
static NSString * const EventBus_Coo_TaskSetDel = @"Coo_TaskDel";

static NSString * const EventBus_Coo_TaskTool_ToolList = @"coo_tasktool_toollist";
static NSString * const EventBus_Coo_TaskTool_AppTool = @"coo_tasktool_apptool";

static NSString * const EventBus_Coo_CooTool_AddAppTool = @"coo_cootool_addtool";
static NSString * const EvenTBus_Coo_CooTool_DeleteTool = @"coo_CooTool_deletetool";
static NSString * const EventBud_Coo_CooTool_ToolSort = @"coo_cootool_toolsort";
static NSString * const EventBus_Coo_CooTool_GetDidAddTool = @"coo_cootool_getdidadd";
// 新的协作
static NSString * const EventBus_Coo_NewCooperation_newCooList = @"coo_newcoo_list";
static NSString * const EventBus_Coo_NewCooperation_NewCooLogList = @"coo_newcoo_loglist";
static NSString * const EventBus_Coo_NewCooperation_AgreeInvite = @"coo_newcoo_agreeintive";
static NSString * const EventBus_Coo_NewCooperation_DeleteInvite = @"coo_newCoo_delteteinvite";
static NSString * const EventBus_Coo_NewCooperation_GetTransactionModel = @"coo_newCoo_GettransantionModel";
static NSString * const EventBus_Coo_NewCooperation_GetNewCooInfo = @"coo_newCoo_getnewCooInfo";
// 新的成员
static NSString * const EventBus_Coo_NewMember_GetAllApplyer = @"coo_newmember_getallmember";
static NSString * const Eventbus_Coo_NewMember_GetApplyLogList = @"coo_newmembwe_getapplylog";
static NSString * const EventBus_Coo_NewMember_Agree = @"coo_newmember_agree";
static NSString * const EventBud_Coo_NewMember_NotAgree = @"coo_newmember_notagree";
static NSString * const Eventbus_Coo_NewMember_DeleteLog = @"coo_newmemeber_deletelog";
static NSString * const EventBud_Coo_NewMember_GetNewApplyInfo = @"coo_newmember_getnewapplyinfo";

// 普通成员审批
static NSString * const EventBus_Coo_NewCooperationApproval_GetApprovalInfo = @"coo_newCooapproval_getapprovalInfo";
static NSString * const EventBus_Coo_NewCooperationApproval_AgreeApproval = @"coo_newCooapproval_agreeapproval";
static NSString * const EventBus_Coo_NewCooperationApproval_IgnoreApproval = @"coo_newCooapproval_IgnoreApprova";
//任务-文件
static NSString * const EventBus_Coo_TaskParse_FileList = @"Coo_TaskParse_FileList";
static NSString * const EventBus_Coo_TaskParse_NextFileList = @"coo_taskparse_nextfilelist";
static NSString * const EventBus_Coo_TaskFile_AddFolder = @"coo_task_addfolder";
static NSString * const EventBus_Coo_TaskFile_AddOneFile = @"coo_task_addfile";
static NSString * const EventBus_Coo_TaskFile_RenameFolder = @"coo_task_renamefolder";
static NSString * const EventBus_Coo_TaskFile_RenamrFile = @"coo_task_renamefile";
static NSString * const EventBus_Coo_TaskFile_DelFolder = @"coo_task_delfolder";
static NSString * const EventBus_Coo_TaskFile_DelFile = @"coo_task_delfile";
static NSString * const EventBus_Coo_TaskFole_MoveFolder = @"coo_task_movefolder";
static NSString * const EventBus_Coo_TaskFole_MoveFile = @"coo_task_movefile";
static NSString * const EventBus_Coo_TaskFile_GetResInfo = @"coo_task_getresinfo";
static NSString * const EventBus_Coo_TaskFile_NetAddResource = @"coo_task_netaddresouce";
static NSString * const EventBus_Coo_TaskFile_GetParentTaskList = @"coo_taskfile_GetParentTaskList";
static NSString * const EventBus_Folder_GetFolders = @"coo_folder_getfolderes";
static NSString * const EventBus_Coo_TaskFile_IsissueAllToChildTask = @"coo_taskfile_IsissueAllToChildTask";

static NSString * const EventBus_Coo_TaskFile_UpgradeResource = @"coo_task_upgradefile";
static NSString * const EventBus_Coo_TaskFile_CopyFolder = @"coo_task_copyFolder";
static NSString * const EventBus_Coo_TaskFile_CopyResource = @"coo_Task_ copyrescource";

/*----------------------- 动态 -----------------------*/
static NSString * const EventBus_PostParse_List = @"PostParse_List";
static NSString * const EventBus_PostParse_Prompt = @"PostParse_Prompt";
static NSString * const EventBus_PostParse_Prompt_Del = @"PostParse_Prompt_Del";
static NSString * const EventBus_PostParse_Prompt_Add = @"PostParse_Prompt_Add";
static NSString * const EventBus_PostParse_MemberList = @"PostParse_MemberList";
static NSString * const EventBus_PostParse_UpPics = @"PostParse_UpPics";
static NSString * const EventBus_PostParse_UpPics_Cannel = @"PostParse_UpPics_Cannel";
static NSString * const EventBus_PostParse_Up_Failure = @"PostParse_Up_Failure";
static NSString * const EventBus_PostParse_User_List = @"PostParse_User_List";
//判断最新一条动态
static NSString * const EventBus_PostParse_NewList_page = @"PostParse_NewList_Page";

static NSString * const EventBus_PostParse_Add = @"PostParse_Add";
static NSString * const EventBus_PostParse_FileAdd = @"PostParse_FileAdd";
static NSString * const EventBus_PostParse_AddRoot = @"PostParse_AddRoot";

static NSString * const EventBus_PostParse_AddReply = @"PostParse_AddReply";
static NSString * const EventBus_PostParse_DelReply = @"PostParse_DelReply";
static NSString * const EventBus_PostParse_AddReplys = @"PostParse_AddReplys";
static NSString * const EventBus_PostParse_AddZan = @"PostParse_AddZan";
static NSString * const EventBus_PostParse_CannelZan = @"PostParse_CannelZan";
static NSString * const EventBus_PostParse_Notification = @"PostParse_Notification";
static NSString * const EventBus_PostParse_Message_Notification = @"PostParse_Message_Notification";

static NSString * const EventBus_PostParse_History_Notification = @"PostParse_History_Notification";
static NSString * const EventBus_PostParse_Detial = @"PostParse_History_Detial";

//动态跟页面刷新通知
static NSString * const EventBus_PostRoot_Refresh_Not = @"PostParse_PostRoot_Refresh_Not";
//动态详情页面刷新通知
static NSString * const EventBus_PostDetial_Refresh_Not = @"PostParse_PostDetial_Refresh_Not";

/*----------------------- 页面通知 -----------------------*/
 static NSString * const EventBus_Coo_Company_Change = @"Coo_Company_Change";
//收起键盘
 static NSString * const EventBus_Coo_Hide_KeyBoard = @"Coo_Hide_KeyBoard";
//岗位切换
static NSString * const EventBus_Coo_PostInfo_Change = @"Coo_PostInfo_Change";
//筛选点击
static NSString * const EventBus_Coo_Filter_Change = @"Coo_Filter_Change";


//删除动态通知
 static NSString * const EventBus_Not_Coo_Post_del = @"Not_Coo_Post_del";
//添加动态通知
 static NSString * const EventBus_Not_Coo_Post_add = @"Not_Coo_Post_add";
//添加动态通知
static NSString * const EventBus_Not_Coo_Post_read = @"Not_Coo_Post_read";
//添加动态通知
static NSString * const EventBus_Not_Coo_Post_addRoot = @"Not_Coo_Post_addRoot";
//添加工作组通知
static NSString * const EventBus_Not_Coo_Group_add = @"Not_Coo_Group_add";
//退出工作组通知
static NSString * const EventBus_Not_Coo_Group_quit = @"Not_Coo_Group_quit";
//常用语改变通知
static NSString * const EventBus_Not_Coo_Prompt_Change = @"Not_Coo_Prompt_Change";

//工作组修改当前人参与身份
static NSString * const EventBus_Not_Coo_Group_Identity = @"Not_Coo_Group_Identity";

//任务修改当前人参与身份
static NSString * const EventBus_Not_Coo_Task_Identity = @"Not_Coo_Task_Identity";

//创建任务
static NSString * const EventBus_Not_Coo_Task_Add = @"Not_Coo_Task_Identity_Add";

//工作组名称修改
static NSString * const EventBus_Not_Coo_WorkGroup_SetName = @"Not_Coo_WorkGroup_SetName";
//工作组Logo修改
static NSString * const EventBus_Not_Coo_WorkGroup_SetLogo = @"Not_Coo_WorkGroup_SetLogo";
//工作组设置状态
static NSString * const EventBus_Not_Coo_WorkGroup_SetState = @"Not_Coo_WorkGroup_SetState";

//工作组设置状态
static NSString * const EventBus_Not_Coo_WorkGroup_SetQuit = @"Not_Coo_WorkGroup_SetQuit";
//工作组设置权限
static NSString * const EventBus_Not_Coo_WorkGroup_SetMemberState = @"Not_Coo_WorkGroup_SetMemberState";

//工作组名称修改
static NSString * const EventBus_Not_Coo_WorkGroup_Invite_Agree = @"Not_Coo_WorkGroup_Invite_Agree";

// 新的协作邀请通知
static NSString * const EventBus_Not_Coo_NewCooperation_NewHandle = @"not_newCooperation_newhandle";
//动态新的消息
static NSString * const EventBus_Not_Coo_Post_New_Notification = @"Not_Coo_Post_New_Notification";

//     工具添加
static NSString * const EventBus_Not_Coo_ToolApp_Insert = @"not_coo_toolapp_insertapp";
//     移除工具
static NSString * const EventBus_Not_Coo_ToolApp_Delete = @"not_coo_toolapp_delete";

//成员数量变化
static NSString * const EventBus_Not_Coo_Member_Number_Notification = @"Not_Coo_Member_Number_Notification";

static NSString * const EventBus_CloudCoo_Base_Get = @"CloudCoo_Base_Get";
//任务名称修改
static NSString * const EventBus_Not_Coo_Task_SetName  = @"Not_Coo_Task_SetName";
static NSString * const EventBus_Not_Coo_Task_SetState = @"Not_Coo_Task_SetState";
static NSString * const EventBus_Not_Coo_Task_SetLock = @"Not_Coo_Task_SetLock";
static NSString * const EventBus_Not_Coo_Task_SetParent = @"Not_Coo_Task_SetParent";
static NSString * const EventBus_Not_Coo_Task_SetPhaseAdmin = @"Not_Coo_Task_SetPhaseAdmin";
static NSString * const EventBus_Not_Coo_Task_SetPhaseState = @"Not_Coo_Task_SetPhaseState";
static NSString * const EventBus_Not_Coo_Post_Collection = @"Not_Coo_Post_Collection";
static NSString * const EventBus_Not_Coo_Task_Collection = @"Not_Coo_Task_Collection";

/*-----------------------我的事务----------------------*/
//添加
static NSString * const EventBus_Not_TranSaction_Add = @"Not_TranSaction_Add";
//通知
static NSString * const EventBus_Not_TranSaction_Change = @"Not_TranSaction_Change";
//更新
static NSString * const EventBus_Not_TranSaction_Update = @"Not_TranSaction_Update";
//删除
static NSString * const EventBus_Not_TranSaction_Delete = @"Not_TranSaction_Delete";


/*-----------------------协作 文件----------------------*/
static NSString * const EventBus_Coo_Document_DelRes = @"Coo_Doc_DelRes";
static NSString * const EventBus_Coo_Document_DelFolder = @"Coo_Doc_DelFolder";
static NSString * const EventBus_Coo_Document_Notice_Resource = @"Coo_Doc_resource";
static NSString * const EventBus_Coo_Document_Notice_Folder = @"Coo_Doc_Folder";
/*----------------------- 标签 -----------------------*/
static NSString * const EventBus_Tags_TagParse_Creat = @"Tags_TagParse_Creat";
static NSString * const EventBus_Tags_TagParse_Cannel = @"Tags_TagParse_Cannel";
static NSString * const EventBus_Tags_TagList = @"Tags_TagParse_TagList";
static NSString * const EventBus_Tags_TagParse_Add = @"Tags_TagParse_Add";
static NSString * const EventBus_Tags_TagParse_Delete = @"Tags_TagParse_Delete";
/*----------------------- 收藏 -----------------------*/
//动态
static NSString * const EventBus_FavoritesParse_Add = @"FavoritesParse_Add";
static NSString * const EventBus_FavoritesParse_Cannel = @"FavoritesParse_Cannel";
//任务
static NSString * const EventBus_FavoritesParse_Add_Task = @"FavoritesParse_Add_Task";
static NSString * const EventBus_FavoritesParse_Add_Group = @"FavoritesParse_Add_Group";

static NSString * const EventBus_FavoritesParse_Cannel_Task = @"FavoritesParse_Cannel_Task";
static NSString * const EventBus_FavoritesParse_Cannel_Group = @"FavoritesParse_Cannel_Group";

//更多  收藏
static NSString * const EventBus_FavoritesParse_Section = @"FavoritesParse_Section";
static NSString * const EventBus_FavoritesParse_Section_Type = @"FavoritesParse_Section_Type";
static NSString * const EventBus_FavoritesParse_Search = @"FavoritesParse_Search";
static NSString * const EventBus_FavoritesParse_Search_Type = @"FavoritesParse_Search_Type";
static NSString * const EventBus_FavoritesParse_Search_Next = @"FavoritesParse_Search_Next";
static NSString * const EventBus_FavoritesParse_GetType = @"FavoritesParse_Get_Type";
static NSString * const EventBus_FavoritesParse_CannelAll = @"FavoritesParse_CannelAll";

//------------------收藏  关注 -v2------------
static NSString * const EventBus_FavoritesParse_V2GetFavorites = @"FavoritesParse_V2GetFavorites";
static NSString * const EventBus_FavoritesParse_V2Remove = @"FavoritesParse_V2Remove";


//刷新收藏界面
static NSString * const EventBus_FavoritesParse_RefreshMoreCollectionVC = @"FavoritesParse_RefreshMoreCollectionVC";

 // 添加收藏 通知
static NSString * const EventBus_Favorites_Notice_AddFavorite = @"favorite_notice_add";
// 收藏信息
static NSString * const EventBus_App_Collection_NetDisk_CollectionInfo = @"app_collection_info";
// 收藏移除 - 单个
static NSString * const EventBus_Favorites_Notice_RemoveSingle = @"favorites_notice_removesingle";
// 收藏移除 - 多个
static NSString * const EventBus_Favorites_Notice_RemoveMultiple = @"favorites_notice_removemultiple";
// 收藏移除 - 一类
static NSString * const EventBus_Favorites_Notice_RemoveType = @"favorites_notice_removetype";
// 收藏移除 - 全部
static NSString * const EventBus_Favorites_Notice_RemoveAll = @"favorites_notice_removeall";


/*----------------------- 更多 我的资料 -----------------------*/
static NSString * const EventBus_More_User_LoadUser = @"More_User_LoadUser";
static NSString * const EventBus_More_User_LoadUser_ReloadChatView = @"More_User_LoadUser_ReloadChatView";
static NSString * const EventBus_More_User_List = @"More_User_List";
static NSString * const EventBus_More_User_Update_UserFace = @"More_User_Update_UserFace";
static NSString * const EventBus_More_User_Update_UserPwdByUp = @"More_User_Update_UserPwdByUp";
static NSString * const EventBus_More_User_LoadUserForChatGroupRecvList = @"More_User_LoadUser_ChatGroupRecvList";
static NSString * const EventBus_User_ValidPassword = @"User_ValidPassword";
static NSString * const EventBus_User_SendMobileValidCode = @"User_SendMobileValidCode";
static NSString * const EventBus_User_UpdateBindUserPhone = @"User_UpdateBindUserPhone";
static NSString * const EventBus_User_SendEmailValidCode = @"User_SendEmailValidCode";
static NSString * const EventBus_User_UpdateBindUserEmail = @"User_UpdateBindUserEmail";
static NSString * const EventBus_User_CancelBindeMail = @"User_CancelBindeMail";
static NSString * const EventBus_User_CancelBindPhone = @"User_CancelBindPhone";
static NSString * const EventBus_User_SwitchPersonidenType = @"User_SwitchPersonidenType";
static NSString * const EventBus_User_UpadteUserPwdBySetting = @"User_UpadteUserPwdBySetting";
static NSString * const EventBus_User_SetMainOrg = @"User_SetMainOrg";
static NSString * const EventBus_User_CancelBindIndentity = @"User_CancelBindIndentity";

static NSString * const EventBus_User_IsNeedValidGraph = @"User_IsNeedValidGraph";
static NSString * const EventBus_User_IsMatchValidCode = @"User_IsMatchValidCode";



/* 头像更改通知处理 */
static NSString * const EventBus_User_Account_ChangeFace = @"User_Account_ChangeFace";

/* 用户账户相关通知处理 */
static NSString * const EventBus_UserAccount_Setting = @"User_Account_Setting";


/* 切换身份通知 */
static NSString * const EventBus_User_SwitchIdentiType = @"User_SwitchIdentiType";
/* 设为主企业通知 */
static NSString * const EventBus_User_SetMainOeid = @"User_SetMainOeid";



/*----------------------- 手机注册 -----------------------*/
static NSString * const EventBus_Register_ByMobile_ExistUserByLoginName = @"Register_Exist_User_ByLoginName";
static NSString * const EventBus_Register_ByMobile_SaveValidCode = @"Register_Save_Valid_Code";
static NSString * const EventBus_Register_ByMobile = @"Register_ByMobile";
static NSString * const EventBus_Register_ByMobile_UpdateUserByPhoneNum = @"Register_Update_User_ByPhoneNum";
static NSString * const EventBus_Register_ByMobile_UpdateUserByEmail = @"Register_Update_User_ByEmail";

/*---------------------- 云盘 文件 ----------------------*/
static NSString * const EventBus_CloudDisk_Notice_DeleteDoc = @"clouddisk_not_deletedoc";
static NSString * const EventBus_CloudDisk_Notice_updateName = @"clouddisk_not_updatename";
static NSString * const EventBus_CloudDisk_Notice_Move = @"clouddisk_not_move";
static NSString * const EventBus_CloudDisk_Notice_Add = @"clouddisk_not_add";
static NSString * const EventBus_App_NetDiskIndex_GetResourceInfo = @"clouddisk_getresourceinfo";
static NSString * const EventBus_App_NetDiskIndex_GetFolderInfo = @"clouddisk_getfolderinfo";
static NSString * const EventBus_App_NetDiskIndex_Notice_AddRes = @"clouddisk_addres";
static NSString * const EventBus_App_NetDiskIndex_Notice_AddFolder = @"clouddisk_addFolder";
static NSString * const EventBus_CloudDisk_MoreDelete = @"clouddisk_moredelete";


/*------------------------ 联系人 -----------------------*/
static NSString * const EventBus_Contact_AddNewFriend = @"contact_add_friend";
static NSString * const EventBus_Contact_GetUidByLoginName = @"contact_getuidbyloginname";
static NSString * const EventBus_Organization_DeptModifySuccess = @"organization_deptmodifysuccess";
static NSString * const EventBus_Organization_DeleteOrg = @"organization_deleteorg";
static NSString * const EventBus_Organization_GetOrgProrityByEuid = @"organization_GetOrgProrityByEuid";
static NSString * const EventBus_Organization_GetOrgListByOeid = @"organization_GetOrgListByOeid";
static NSString * const EventBus_Organization_GetOrgByssqy = @"organization_GetOrgByssqy";
static NSString * const EventBus_Organization_GetOrgListByOpid = @"organization_GetOrgListByOpid";
static NSString * const EventBus_Organization_GetUserByFilter = @"organization_GetUserByFilter";
static NSString * const EventBus_Organization_GetUserByOIdPages = @"organization_GetUserByOIdPages";
static NSString * const EventBus_Organization_GetOrgListByUidOeid = @"organization_GetOrgListByUidOeid";
static NSString * const EventBus_Organization_GetUserAddItionInfoByUid = @"organization_GetUserAddItionInfoByUid";
static NSString * const EventBus_Organization_AdjustUserOrg = @"organization_AdjustUserOrg";
static NSString * const EventBus_Organization_InvitateUserOrModifyUser = @"organization_InvitateUserOrModifyUser";
static NSString * const EventBus_Organization_DeleteOrgUser = @"organization_DeleteOrgUser";
static NSString * const EventBus_Organization_DeleteUserFromEnter = @"organization_DeleteUserFromEnter";
static NSString * const EventBus_Organization_SetBatchAdmin = @"organization_SetBatchAdmin";
static NSString * const EventBus_Organization_CancleAdmin = @"organization_CancleAdmin";
static NSString * const EventBus_Organization_GetAdminUsersByOid = @"organization_GetAdminUsersByOid";
static NSString * const EventBus_Organization_ReactOrgIntervateUser = @"organization_ReactOrgIntervateUser";
static NSString * const EventBus_Organization_GetRecusiveParentOrgByOid = @"organization_GetRecusiveParentOrgByOid";
static NSString * const EventBus_Organization_OpenShowUserMobile = @"organization_OpenShowUserMobile";
static NSString * const EventBus_Organization_CloseShowUserMobile = @"organization_CloseShowUserMobile";


static NSString * const EventBus_Organization_RefreshSelectOrgsChanged = @"organization_SelectOrgsChanged";
static NSString * const EventBus_Organization_RerfreshContactEnterpriseVC = @"organization_RerfreshContactEnterpriseVC";
static NSString * const EventBus_Organization_RerfreshContactForSelectJob = @"organization_RerfreshContactSelectJob";
static NSString * const EventBus_Organization_DeleteDepart = @"organization_deletedepart";
static NSString * const EventBus_Organization_AdjustUser = @"organization_adjustuser";
static NSString * const EventBus_Organization_BatImportResult = @"organization_batimportresult";
static NSString * const EventBus_Organization_BatRemoveUser = @"organization_batremoveuser";
static NSString * const EventBus_Organization_MoveUp = @"organization_moveup";
static NSString * const EventBus_Organization_MoveDown = @"organization_movedown";
static NSString * const EventBus_Organization_Drag = @"organization_drag";
static NSString * const EventBus_Organization_ReconstOrg = @"organization_reconstorg";
static NSString * const EventBus_Organization_UserExit = @"organization_userexit";
static NSString * const EventBus_Organization_BatadJustUser = @"organization_batadjustuser";
static NSString * const EventBus_Organization_UserExitEnter = @"organization_userexitenter";
static NSString * const EventBus_Organization_GetOrgByOids = @"organization_getorgbyoids";
static NSString * const EventBus_Organization_SetenterUserSort = @"organization_setenterusersort";
static NSString * const EventBus_Organization_EnterLicDeadLineAuthCheck = @"organization_enterlicdeadlineauthcheck";





static NSString * const EventBus_OrgLicenseIsExistsAuth = @"orglicense_isexistsauth";

/* 删除好友邀请 */
static NSString * const EventBus_Organization_DeleteOrgUserIntervate = @"organization_deleteorguserintervate";
/* 管理员删除用户申请加入某个组织 */
static NSString * const EventBus_Organization_DeleteApplyUser = @"organization_deleteapplyuser";




/* 联系人好友标签删除通知 */
static NSString * const EventBus_UserTag_RemoveTag = @"usertag_removetag";
/* 联系人好友标签界面列表发生变化 */
static NSString * const EventBus_UserTag_RefreshContactFriendLabelListVC = @"usertag_refreshcontactfriendlabellist";

/*------------------------ 吐槽与帮助 -----------------------*/
/* 帮助 */
static NSString * const EventBus_HelpAndFeedBack_Help = @"helpandfeedback_help";
/* 吐槽 */
static NSString * const EventBus_HelpAndFeedBack_FeedBack = @"helpandfeedback_feedback";


/*------------------------ 通用文件 -----------------------*/
static NSString * const EventBus_commonFile_AddResource = @"commonFile_addResource";
static NSString * const EventBus_CommonFile_GetFolderAndRes = @"commonFile_getfolderandres";

/*------------------------ 账号安全 -----------------------*/
/* 移动端扫描后操作 */
static NSString * const EventBus_Security_CheckQrLogin = @"Security_CheckQrLogin";
/* 手机端确认二维码登录 */
static NSString * const EventBus_Security_CheckSubmit = @"Security_CheckSubmit";
/* 手机端取消二维码登录 */
static NSString * const EventBus_Security_CheckCancel = @"Security_CheckCancel";

/*------------------------ 基础协作文件 -----------------------*/

/* 我的权限 */
static NSString * const EventBus_CooperationBaseFile_Authority_MyAuthority = @"cooperationbasefile_Authority_MyAuthority";
/* 文件权限状态 */
static NSString * const EventBus_CooperationBaseFile_Authority_FileAuthority = @"cooperationbasefile_Authority_FileAuthority";
/*  */
static NSString * const EventBus_CooperationBaseFile_Authority_MyAuthorityModel = @"cooperationbasefile_Authority_myauthoritymodel";
/*  */
static NSString * const EventBus_CooperationBaseFile_Authority_GetMyFolderModel = @"cooperationbasefile_Authority_GetMyFolderModel";
/*  */
static NSString * const EventBus_CooperationBaseFile_Authority_AuthorityForFolder = @"cooperationbasefile_Authority_AuthorityForFolder";
/* 设置人员权限<##> */
static NSString * const EventBus_CooperationBaseFile_Authority_SettingsAuthorityForFolder = @"cooperationbasefile_Authority_SettingsAuthorityForFolder";
/* 权限设置 */
static NSString * const EventBus_CooperationBaseFile_Authority_SettingsAuthority = @"cooperationbasefile_Authority_SettingsAuthority";
/* 新增文件 */
static NSString * const EventBus_CooperationBaseFile_AddNewFile = @"cooperationbasefile_AddNewFile";
/* 获取文件夹 */
static NSString * const EventBus_CooperationBaseFile_GetFolder = @"cooperationbasefile_getfolder";
/* 打开文件夹 */
static NSString * const EventBus_CooperationBaseFile_GetResource = @"cooperationbasefile_getresource";
/* 删除文件夹 */
static NSString * const EventBus_CooperationBaseFile_DelFolder = @"cooperationbasefile_delfolder";

/* 删除文件 */
static NSString * const EventBus_CooperationBaseFile_DelFile= @"cooperationbasefile_delfile";

/* 批量删除 */
static NSString * const EventBus_CooperationBaseFile_MixDeleteData = @"cooperationbasefile_mixdeletaData";
static NSString * const EventBus_CooperationBaseFile_UploadFileSuccess = @"cooperationbasefile_uploadsuccess";

/* 导入云盘文件 */
static NSString * const EventBus_CooperationBaseFile_ImportNetDiskResource= @"cooperationbasefile_importnetdiskresource";
/* 获取我的共享文件夹 */
static NSString * const EventBus_CooperationBaseFile_ShareFolder_GetShareFolderModel= @"cooperationbasefile_ShareFolder_GetShareFolderModele";
static NSString * const EventBus_CooperationBaseFile_ShareFolder_GetShareList= @"cooperationbasefile_ShareFolder_GGetShareList";
/* 获取引用的共享文件夹 */
static NSString * const EventBus_CooperationBaseFile_ShareFolder_GetQouteShareFolderOrg= @"cooperationbasefile_ShareFolder_GetQouteShareFolderOrg";
/* 设置共享文档 */
static NSString * const EventBus_CooperationBaseFile_ShareFolder_SettingUpdataFolder= @"cooperationbasefile_ShareFolder_SettingUpdataFolder";
/* 取消共享文档 */
static NSString * const EventBus_CooperationBaseFile_ShareFolder_CancleShareFolder= @"cooperationbasefile_ShareFolder_CancleShareFolder";
/* 删除分享项 */
static NSString * const EventBus_CooperationBaseFile_ShareFolder_DeleteShareItem= @"cooperationbasefile_ShareFolder_DeleteShareItem";
/* 添加分享项 */
static NSString * const EventBus_CooperationBaseFile_ShareFolder_AddShareItem= @"cooperationbasefile_ShareFolder_AddShareItem";
/* 添加共享文档(引用) */
static NSString * const EventBus_CooperationBaseFile_QuoteShareFolder_AddQuoteFodlerShare= @"cooperationbasefile_QuoteShareFolder_AddQuoteFodlerShare";
/* 删除共享(引用) */
static NSString * const EventBus_CooperationBaseFile_QuoteShareFolder_DeleteQuoteShareFolder= @"cooperationbasefile_QuoteShareFolder_DeleteQuoteShareFolder";
static NSString * const EventBus_CooperationBaseFile_QuoteShareFolder_GetNORpidShare= @"cooperationbasefile_QuoteShareFolder_GetNORpidShare";
/* 添加共享文件夹 自己的 */
static NSString * const EventBus_CooperationBaseFile_ShareFolder_AddFolderForShare= @"cooperationbasefile_ShareFolder_AddFolderForShare";
/* 获取引用的文件夹 */
static NSString * const EventBus_CooperationBaseFile_QuoteShareFolder_GetQuoteFolder = @"cooperationbasefile_QuoteShareFolder_GetQuoteFolder";
/* 查看引用的文件 */
static NSString * const EventBus_CooperationBaseFile_QuoteShareFolder_GetShareItemList = @"cooperationbasefile_QuoteShareFolder_GetShareItemList";
/* 输入共享码时请求api成功 */
static NSString * const EventBus_CooperationBaseFile_QuoteShareFolder_GetSharedType = @"cooperationbasefile_QuoteShareFolder_GetSharedType";
static NSString * const EventBus_Resource_Folder_GetFolderOne = @"resourece_folder_getfolderone";

/*------------------------ 移动端短地址配置 -----------------------*/

/* 移动端短地址配置 */
static NSString * const EventBus_System_GetMobiletrPath= @"System_GetMobiletrPath";

/* 消息页签搜索 */
static NSString * const EventBus_ImFilterUser_SearchAll = @"imfilteruser_searchall";





