//
//  BaseWebApi.h
//  LeadingCloud
//
//  Created by wchMac on 16/6/2.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BaseWebApi_h
#define BaseWebApi_h


#endif /* BaseWebApi_h */


/* Web服务器 */
static NSString * const Modules_Default = @"default";
/* 消息服务器 */
static NSString * const Modules_Message = @"message";
/* 文件服务器 */
static NSString * const Modules_File = @"file";
/* 文件操作服务器 */
static NSString * const Modules_FileManager = @"filemanager";

/* H5，默认web服务器 */
static NSString * const Modules_H5_Default = @"h5server";

/* 项目web服务器 */
static NSString * const Modules_DevAppManageRun = @"devappmanagerun";


/* 消息回执服务 */
static NSString * const Modules_Message_Receipt = @"message_receipt";

/* WebApi所在Controller */
static NSString * const WebApi_Controller = @"controller";
/* WebApi的路由名称 */
static NSString * const WebApi_Route = @"route";
/* WebApi获取到的数据 */
static NSString * const WebApi_DataContext = @"datacontext";
/* WebApi返回的错误信息 */
static NSString * const WebApi_ErrorCode = @"errorcode";
/* WebApi发送时，Post的数据 */
static NSString * const WebApi_DataSend_Post = @"datasend_post";
/* WebApi发送时，Get的数据 */
static NSString * const WebApi_DataSend_Get = @"datasend_get";
/* WebApi发送时，Other存放的数据 */
static NSString * const WebApi_DataSend_Other = @"datasend_other";

/* 登录方式 */
static NSString * const Login_Mode_Password = @"";
static NSString * const Login_Mode_WeChat = @"wechat";
static NSString * const Login_Mode_QQ = @"qq";
static NSString * const Login_Mode_WeiBo = @"weibo";

static NSString * const Login_Step_First_ClickLoginBtn = @"loginbycode";
static NSString * const Login_Step_Second_BindPhone = @"bindwechat";
static NSString * const Login_Step_Third_Password = @"bindwechatwithpwd";
static NSString * const Login_Step_AutoLogin = @"refreshaccesstoken";


/* iOS客户端标识 */
static NSString * const WebApi_ClientType = @"1";

/*-------------------------datasend_other中的参数------------------------*/
static NSString * const WebApi_DataSend_Other_Operate = @"datasend_other_operate";
static NSString * const WebApi_DataSend_Other_Tag = @"datasend_other_tag";

/* webapi结果回调 */
static NSString * const WebApi_DataSend_Other_BackBlock = @"datasend_other_backblock";
typedef void (^WebApiSendBackBlock)(NSMutableDictionary *dataDic);
/* 显示错误提示 */
static NSString * const WebApi_DataSend_Other_ShowError = @"datasend_other_showerror";
static NSString * const WebApi_DataSend_Other_SE_NotShowAll = @"datasend_other_showerror_notshowall";
static NSString * const WebApi_DataSend_Other_SE_NotShowNetFail = @"datasend_other_showerror_notshownetfail";

/*-------------------------登录时请求的api------------------------*/
// api/apiserver/getbaseserver
static NSString * const LogoinWebApi_api_apiserver_getbaseserver_S1 = @"s1";
// api/msgtemplate/gettemplate
static NSString * const LogoinWebApi_api_msgtemplate_gettemplate_S2 = @"s2";
// api/filemanager/getremotelyservermodelall
static NSString * const LogoinWebApi_api_filemanager_getremotelyservermodelall_S3 = @"s3";
// api/colleaguelist/getcolleagues
static NSString * const LogoinWebApi_api_colleaguelist_getcolleagues_S4 = @"s4";
// api/colleaguelist/getcontactgroup
static NSString * const LogoinWebApi_api_colleaguelist_getcontactgroup_S5 = @"s5";
// api/colleaguelist/getcontractlistwithtag
static NSString * const LogoinWebApi_api_colleaguelist_getcontractlistwithtag_S6 = @"s6";
// api/colleaguelist/ofencooperation
static NSString * const LogoinWebApi_api_colleaguelist_ofencooperation_S7 = @"s7";
// api/organization/getuserorgbyuidcontroller
static NSString * const LogoinWebApi_api_organization_getuserorgbyuidcontroller_S8 = @"s8";
// api/imgroup/getgrouplistbypages
static NSString * const LogoinWebApi_api_imgroup_getgrouplistbypages_S9 = @"s9";
// api/fileserver/uploadfileexp
static NSString * const LogoinWebApi_api_fileserver_uploadfileexp_S10 = @"s10";
// api/cooperation/extendtype/getallconfig
static NSString * const LogoinWebApi_api_cooperation_extendtype_getallconfig_S11 = @"s11";
// api/user/getusercenter
static NSString * const LogoinWebApi_api_user_getusercenter_S13 = @"s13";
// api/template/gettemplatelist/1
static NSString * const LogoinWebApi_api_template_gettemplatelist_1_S14 = @"s14";
// api/postv/getposttypelist
static NSString * const LogoinWebApi_api_api_postv_getposttypelist_S15 = @"s15";


/*-------------------------登录相关------------------------*/
static NSString * const WebApi_ApiServer = @"api/apiserver";
/* 获取各个模块的服务器地址 */
static NSString * const WebApi_ApiServer_Init = @"api/apiserver/init";
/* 服务器可用性检查 */
static NSString * const WebApi_ApiServer_Available = @"api/apiserver/available";
/* 获取基础服务器配置 */
static NSString * const WebApi_ApiServer_GetBaseServer = @"api/apiserver/getbaseserver/{tokenid}";


/* 登录后发送客户端信息 */
static NSString * const WebApi_Connect_SaveLoginInfo = @"api/connection/savelogininfo/{tokenid}";
/* 取消Windows的登录 */
static NSString * const WebApi_Connect_KickOutPC = @"api/connection/kickoutpc/{tokenid}";

/* 注销操作 */
static NSString * const WebApi_Security = @"api/security/";
static NSString * const WebApi_Connection_Logout = @"api/connection/logout/{tokenid}";
static NSString * const WebApi_Security_Signout = @"api/security/signout/{tokenid}";
/* 检测更新版本 */
static NSString * const WebApi_ApiServer_Mobile_Version = @"api/apiserver/mobile/version/ios";

/* 移动端扫描后操作 */
static NSString * const WebApi_Security_CheckQrLogin = @"api/security/checkqrlogin/{qrid}/{tokenid}";
/* 手机端确认二维码登录 */
static NSString * const WebApi_Security_CheckSubmit = @"api/security/checksubmit/{qrid}/{tokenid}";
/* 手机端取消二维码登录 */
static NSString * const WebApi_Security_CheckCancel = @"api/security/checkcancel/{qrid}/{tokenid}";


/* 获取移动端短地址配置信息 */
static NSString * const WebApi_System = @"api/system/";
static NSString * const WebApi_System_GetMobiletrPath = @"api/system/getmobiletrpath/{tokenid}";

/* 获取webapi的数据版本 */
static NSString * const WebApi_System_ApiVersion = @"api/system/apiversion/getsysapiversion/{tokenid}";


/*------------------注册相关-------------------*/
/* 发送手机的验证码（废弃） */
static NSString * const WebApi_CloudUser_SaveValidCode = @"api/user/savevalidcode/{tokenid}";
/* 判断账号是否被注册 */
static NSString * const WebApi_CloudUser_ExistUserByLoginName = @"api/user/existuserbyloginname/{tokenid}";
/* 手机号注册提交 */
static NSString * const WebApi_CloudUser_RegisterByMobile = @"api/user/registerbymobile/{tokenid}";
/* 手机注册密码重置 */
static NSString * const WebApi_CloudUser_UpdateUserByPhoneNum = @"api/user/updateuserbyphonenum/{tokenid}";
/* 邮箱注册密码重置 */
static NSString * const WebApi_CloudUser_UpdateUserByEmail = @"api/user/updateuserbyemail/{tokenid}";



/*------------------应用相关-------------------*/
static NSString * const WebApi_CloudApp = @"api/App";
/* 获取个人iOS应用(已弃用) */
static NSString * const WebApi_CloudApp_IOSApp = @"api/App/iOSApp/{tokenid}";
/* 获取当前组织和个人iOS应用(已弃用) */
static NSString * const WebApi_CloudApp_Org_IOSApp = @"api/App/iOSApp/{orgid}/{tokenid}";

/* 获取当前用户企业下的配置 */
static NSString * const WebApi_CloudApp_GetPhoneUserOrgModel = @"api/App/GetPhoneUserOrgModel/{orgid}/{tokenid}";
/* 获取当前用户企业下更多 */
static NSString * const WebApi_CloudApp_GetPhoneMoreModel = @"api/App/GetPhoneMoreModel/{orgid}/{tokenid}";
/* 保存用户企业导航数据 */
static NSString * const WebApi_CloudApp_SaveUserOrgModel = @"api/App/SaveUserOrgModel/{tokenid}";
/* 根据appcode获取应用信息 */
static NSString * const WebApi_App_GetAppInfo = @"api/app/getappbyappcode/{appcode}/{tokenid}";

static NSString * const WebApi_App_baselinkconfig = @"api/system/baselinkconfig/getdeviceconfigbycode/{appcode}/{code}/{tokenid}";
/* 根据appid获取单个应用提醒数字 */
static NSString * const WebApi_App_GetAppNumber = @"api/app/getappnumber/{oid}/{appid}/{tokenid}";

static NSString * const WebApi_App_GetMagApp = @"api/app/getmagapp/{tokenid}";

/*------------------服务圈相关-------------------*/
static NSString * const WebApi_CloudsServiceCircles = @"api/servicecircles";
/*根据名称查询搜索服务圈(分页) POST*/
static NSString * const WebApi_CloudsServiceCircles_Search_Getlist = @"api/servicecircles/search/getlist2/{client}/{tokenid}";
/*根据组织ID获取当前用户被推荐的服务圈 get*/
static NSString * const WebApi_CloudsServiceCircles_Recommended_Getlist = @"api/servicecircles/recommended/getlist/{client}/{oid}/{length}/{tokenid}";

/*根据组织ID获取当前用户已加入的服务圈 GET*/
static NSString * const WebApi_CloudsServiceCircles_Getlist = @"api/servicecircles/getlist/{client}/{oid}/{tokenid}";

/// 通过uid获取首页服务圈信息
static NSString * const WebApi_CloudsServiceCircles_Getfirstpagebyuid = @"api/servicecircles/getfirstpagebyuid/{client}/{tokenid}";
/// 设置该服务圈是否为首页展示
static NSString * const WebApi_CloudsServiceCircles_Developer_Setisfirstpage = @"api/servicecircles/developer/member/setisfirstpage/{scid}/{isfirstpage}/{isjoin}/{tokenid}";


/*------------------吐槽、帮助-------------------*/
static NSString * const WebApi_HelpAndFeedBack = @"api/helpandfeedback";
/* 获取帮助信息 */
static NSString * const WebApi_HelpAndFeedBack_Help = @"api/helpandfeedback/help/{tokenid}";
/* 添加反馈 */
static NSString * const WebApi_HelpAndFeedBack_FeedBack = @"api/helpandfeedback/feedback/{tokenid}";


