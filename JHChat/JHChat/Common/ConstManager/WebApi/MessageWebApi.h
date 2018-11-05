//
//  MessageWebApi.h
//  LeadingCloud
//
//  Created by wchMac on 16/6/2.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#ifndef MessageWebApi_h
#define MessageWebApi_h


#endif /* MessageWebApi_h */


/*---------------------消息发送，接收相关--------------------*/
static NSString * const WebApi_Message = @"api/message";
/* 接收消息 */
static NSString * const WebApi_Message_Get = @"api/message/get";
/* 发送消息 */
static NSString * const WebApi_Message_Send = @"api/message/send";
/* 发送消息回执 */
static NSString * const WebApi_Message_Report = @"api/message/report/{type}/{badge}/{tokenid}";
/* 消息撤回 */
static NSString * const WebApi_Message_RecallMsg = @"api/message/recallmsg/{synckey}/{tokenid}";
/* 消息删除 */
static NSString * const WebApi_Message_DeleteMsg = @"api/message/deletemsg/{container}/{tokenid}";
/* 保存语音通话的时长 */
static NSString * const WebApi_Message_SaveVideoMsg = @"api/message/savevideomsg/{tokenid}";
/* 修改是否通知手机端的属性 */
static NSString * const WebApi_Message_UpdatePushState = @"api/message/updatepushstate/{notice}/{tokenid}";

/*---------------------消息模板--------------------*/
static NSString * const WebApi_MsgTemplate = @"api/msgtemplate";
/* 获取消息模板的集合 */
static NSString * const WebApi_MsgTemplate_GetTemplate = @"api/msgtemplate/gettemplate/{tokenid}";

/*-----------------------最近联系人相关----------------------*/
static NSString * const WebApi_Recent = @"api/recent";
/*获取最近联系人*/
static NSString * const WebApi_Recent_GetRecentData = @"api/recent/getrecentdata/{tokenid}";
/*删除最近联系人*/
static NSString * const WebApi_Recent_DeleteRecent = @"api/recent/deleterecent/{recentid}/{tokenid}";
/* 联系人置顶 */
static NSString * const WebApi_Recent_SetRecentStick = @"api/recent/setrecentstick/{recentid}/{state}/{tokenid}";
/* 个人聊天免打扰 */
static NSString * const WebApi_Recent_SetRecentDisturb = @"api/recent/setrecentdisturb/{recentid}/{state}/{tokenid}";

/*-----------------------聊天记录相关----------------------*/
static NSString * const WebApi_ChatLog = @"api/chatlog";
/* 下载聊天记录 */
static NSString * const WebApi_ChatLog_GetChatLogList = @"api/chatlog/getchatloglist/{tokenid}";
/* 获取消息的读取状态 */
static NSString * const WebApi_ChatLog_GetMessageReadStatus = @"api/chatlog/getmessagereadstatus/{msgid}/{tokenid}";

/*-----------------------群组相关----------------------*/
static NSString * const WebApi_ImGroup = @"api/imgroup";
/* 获取所属群组数据 */
static NSString * const WebApi_ImGroup_GetGroupList = @"api/imgroup/getgrouplist/{tokenid}";
/* 获取所属群组数据-分页 */
static NSString * const WebApi_ImGroup_GetGroupListByPages = @"api/imgroup/getgrouplistbypages/{tokenid}";
/* 分页取得群组下人员 */
static NSString * const WebApi_ImGroup_GetGroupUsersByPages = @"api/imgroup/getgroupusersbypages/{tokenid}";
/* 获取单个群组信息 */
static NSString * const WebApi_ImGroup_GetGroupInfoByPages = @"api/imgroup/getgroupinfobypages/{tokenid}";
/* 获取某个群组的信息(包含当前群组人数和当前人是否在群组中) */
static NSString * const WebApi_ImGroup_GetGroupBaseInfo = @"api/imgroup/getgroupbaseinfo/{groupid}/{tokenid}";
/* 根据releateid获取单个群组信息,接口调整:获取群组时,将群组内的机器人也放进去 */
static NSString * const WebApi_ImGroup_Info_Relateid = @"api/imgroup/getgroupinfobyrelateid/{relateId}/{tokenid}";
/* 添加群组 */
static NSString * const WebApi_ImGroup_AddGroup = @"api/imgroup/addgroup/{tokenid}";
/* 删除群组 */
static NSString * const WebApi_ImGroup_DeleteGroup = @"api/imgroup/deletegroup/{groupid}/{tokenid}";
/* 修改群组 */
static NSString * const WebApi_ImGroup_ModifyGrouyp = @"api/imgroup/modifygroup/{tokenid}";
/* 添加群成员 */
static NSString * const WebApi_ImGroup_AddMember = @"api/imgroup/addmember/{groupid}/{tokenid}";
/* 移除群成员 */
static NSString * const WebApi_ImGroup_RemoveMember = @"api/imgroup/removemember/{groupid}/{tokenid}";
/* 修改群消息免打扰 */
static NSString * const WebApi_ImGroup_UpdateMsgRole = @"api/imgroup/updatemsgrole/{groupid}/{role}/{tokenid}";
/* 修改是否保存通讯录 */
static NSString * const WebApi_ImGroup_IsSaveToAddress = @"api/imgroup/updategroupshow/{groupid}/{show}/{tokenid}";
/* 退出群组 */
static NSString * const WebApi_ImGroup_QuitGroup = @"api/imgroup/quitgroup/{groupid}/{tokenid}";
/* 修改群组名称 */
static NSString * const WebApi_ImGroup_ModifyGroupName = @"api/imgroup/modifygroupname/{tokenid}";
/* 群主管理权转让 */
static NSString * const WebApi_ImGroup_AssignAdmin = @"api/imgroup/assignadmin/{tokenid}";
/* 申请加入群组 */
static NSString * const WebApi_ImGroup_ApplyJoinGroup = @"api/imgroup/joingroup/{tokenid}";
/* 查找群组用户 */
static NSString * const WebApi_ImGroup_SearchGroupUser = @"api/imgroup/searchgroupuser/{tokenid}";
/* 新成员查看历史记录 */
static NSString * const WebApi_ImGroup_UpdateGroupIsLoadMsg = @"api/imgroup/updategroupisloadmsg/{groupid}/{isloadmsg}/{tokenid}";
/* 显示绑定的群组的群主 */
static NSString * const WebApi_ImGroup_GetCreateUserIdByGroupIdOrRelateId = @"api/imgroup/getcreateuseridbygroupidorrelateid/{imtype}/{id}/{tokenid}";
/* 设置绑定的群组的群主 */
static NSString * const WebApi_ImGroup_SetImGroupByRelateId = @"api/imgroup/setimgroupbyrelateid/{relateid}/{createuserid}/{tokenid}";
/* 根据消息群组ID获取该群组内机器人列表 */
static NSString * const WebApi_ImGroup_GetGroupRobot = @"api/imgroup/getgrouprobot/{igid}/{tokenid}";
/* 获取所有机器人信息 */
static NSString * const WebApi_ImGroup_GetRobot = @"api/robot/getrobot/{tokenid}";
/* 获取单个机器人信息 */
static NSString * const WebApi_ImGroup_GetRobotFoRid = @"api/robot/getrobotforid/{riid}/{tokenid}";

/*-----------------------天气机器人相关----------------------*/
/* 获取所选天气机器人的详情 */
static NSString * const WebApi_WeatherRobot_GetWeatherRobotExample = @"api/weatherrobot/getweatherrobotexample/{rwid}/{tokenid}";
/* 添加天气机器人实例 */
static NSString * const WebApi_WeatherRobot_AddWeatherRobotExample = @"api/weatherrobot/addweatherrobotexample/{tokenid}";
/* 修改一个天气机器人的信息 */
static NSString * const WebApi_WeatherRobot_UpdateWeatherRobotExample = @"api/weatherrobot/updateweatherrobotexample/{tokenid}";
/* 删除一个天气机器人 */
static NSString * const WebApi_WeatherRobot_DeleteWeatherRobotExample = @"api/weatherrobot/deleteweatherrobotexample/{rwid}/{tokenid}";
/* 根据定时推送的天气预报的城市获取近三天的天气信息 */
static NSString * const WebApi_WeatherRobot_GetDailyForecastWeathers = @"api/weatherrobot/getdailyforecastweathers/{city}";


static NSString * const WebApi_CooperationExtendtype_GetAllConfig = @"api/cooperation/extendtype/getallconfig/{tokenid}";

/*-----------------------业务会话相关----------------------*/
static NSString * const WebApi_BusinessSession = @"api/businesssession";
/* 获取当前人会话记录中的业务信息 */
static NSString * const WebApi_BusinessSession_GetBussinessInfo = @"api/businesssession/instalkrecent/getbusinessinfo/{tokenid}";
/* 根据检索条件获取会话记录列表(废弃) */
static NSString * const WebApi_BusinessSession_QueryModelList = @"api/businesssession/instalkrecent/querymodellist/{tokenid}";
/* 获取会话记录列表 */
static NSString * const WebApi_BusinessSession_Recent = @"api/businesssession/recent/acquirelist/{tokenid}";
/* 根据检索条件获取会话记录列表 */
static NSString * const WebApi_BusinessSession_Search = @"api/businesssession/search/acquirelist/{tokenid}";
/* 获取业务会话工具列表 */
static NSString * const WebApi_BusinessSession_Tool_Usable = @"api/businesssession/tool/usable/{tokenid}";
/* 获取实例下的会话列表 */
static NSString * const WebApi_BusinessSession_Recent_Acquirelist = @"api/businesssession/recent/acquirelist/{bsiid}/{tokenid}";
/* 新建业务会话 */
static NSString * const WebApi_BusinessSession_Recent_Create = @"api/businesssession/recent/create/{tokenid}";
/* 根据群组ID打开会话 */
static NSString * const WebApi_BusinessSession_Recent_Acquire = @"api/businesssession/recent/acquire/{targetid}/{tokenid}";
/* 根据bsiid打开会话 */
static NSString * const WebApi_BusinessSession_Recent_Acquire_main = @"api/businesssession/recent/acquire/main/{bsiid}/{tokenid}";
/* 新建业务会话实例 */
static NSString * const WebApi_BusinessSession_Ins_Create = @"api/businesssession/ins/create/{tokenid}";
/* 打开业务会话实例 */
static NSString * const WebApi_BusinessSession_Ins_Init = @"api/businesssession/ins/init/{tokenid}";
/* 根据bsiid获取会话示例数据 */
static NSString * const WebApi_BusinessSession_Ins_Acquire = @"api/businesssession/ins/acquire/{bsiid}/{tokenid}";
/* 退出业务会话群组 */
static NSString * const WebApi_BusinessSession_Recent_Quitgroup = @"api/businesssession/recent/quitgroup/{tokenid}";
/* 变更业务群组名称 */
static NSString * const WebApi_BusinessSession_Recent_Changename = @"api/businesssession/recent/changename/{targetid}/{tokenid}";

/* 业务扩展类型数据 */
static NSString * const WebApi_BusinessSession_GetExtendTypeByCode = @"api/bussinesssession/getextendtypebycode/{appcode}/{code}/{tokenid}";
/* 获取表单列表数据 */
static NSString * const WebApi_BusinessSessionForm_GetBsFormList = @"api/businesssessionform/getbsformlist/{bsid}/{oeid}/{tokenid}";
/* 获取附件列表数据 */
static NSString * const WebApi_BusinessSession_Attach_AcquireTypeInfo = @"api/businesssession/attach/acquiretypeinfo/{bsid}/{bsiid}/{tokenid}";
/* 获取附件列表中详细数据 */
static NSString * const WebApi_BusinessSession_Attach_AcquireAll = @"api/businesssession/attach/acquireall/{bsiid}/{bsasid}/{tokenid}";
/* 获取附件相关信息 */
static NSString * const WebApi_BusinessSession_AttachSet_Acquire = @"api/businesssession/attachset/acquire/{bsasid}/{tokenid}";
/* 附件上传完以后写入附件信息 */
static NSString * const WebApi_BusinessSession_AttachSet_Add = @"api/businesssession/attach/add/{tokenid}";
/* 附件删除 */
static NSString * const WebApi_BusinessSession_Delete = @"api/businesssession/delete/{bsaid}/{tokenid}";
/* 会话状态权限判断 */
static NSString * const WebApi_BusinessSession_Ins_ProcessingAuthority = @"api/businesssession/ins/processingauthority/{bsiid}/{uid}/{tokenid}";



/*-----------------------提醒列表相关----------------------*/
static NSString * const WebApi_Remind = @"api/remind";
static NSString * const WebApi_Remind_GetRemindList = @"api/remind/getremindlist/{tokenid}?oeid={oeid}";

/*-----------------------发送通知API----------------------*/
static NSString * const WebApi_Notification = @"api/notification";
static NSString * const WebApi_Notification_Send = @"api/notification/send/{tokenid}";

/* 消息里搜索人员群组 */
static NSString * const WebApi_ImFilterUser_SearchAll = @"api/imfilteruser/searchall/{tokenid}";


