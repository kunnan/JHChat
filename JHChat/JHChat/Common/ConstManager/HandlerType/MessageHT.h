//
//  MessageHT.h
//  LeadingCloud
//
//  Created by wchMac on 16/5/9.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#ifndef MessageHT_h
#define MessageHT_h


#endif /* MessageHT_h */

/* =================================即时消息(message)================================= */
static NSString * const Handler_Message = @"message";

/* 对话(lzchat) */
static NSString * const Handler_Message_LZChat = @"lzchat";
static NSString * const Handler_Message_LZChat_LZMsgNormal_Text  = @"message.lzchat.lzmsgnormal.text";  //文本--消息
static NSString * const Handler_Message_LZChat_Image_Download    = @"message.lzchat.image";    //图片消息--消息
static NSString * const Handler_Message_LZChat_File_Download     = @"message.lzchat.file.download";     //文件下载--消息
static NSString * const Handler_Message_LZChat_Card     = @"message.lzchat.card";     //名片--消息
static NSString * const Handler_Message_LZChat_Voice     = @"message.lzchat.voice";    //语音--消息
static NSString * const Handler_Message_LZChat_Geolocation     = @"message.lzchat.geolocation";     //地理位置--消息
static NSString * const Handler_Message_LZChat_Micro_Video = @"message.lzchat.microvideo";     //小视频--消息
static NSString * const Handler_Message_LZChat_VoiceCall = @"message.lzchat.call.voice";   // 语音通话
static NSString * const Handler_Message_LZChat_VideoCall = @"message.lzchat.call.video";    // 视频通话
static NSString * const Handler_Message_LZChat_UrlLink = @"message.lzchat.urllink";    // url视图
//static NSString * const Handler_Message_LZChat_ShareMsg = @"message.lzchat.sharemsg";  // 共享文件消息
static NSString * const Handler_Message_LZChat_Notice = @"message.lzchat.notice"; // 咨询类消息公告
static NSString * const Handler_Message_LZChat_Call_Main = @"message.lzchat.call.main"; // 语音聊天中的主消息体
static NSString * const Handler_Message_LZChat_Call_Unanswer = @"message.lzchat.call.unanswer";  // 用于自己同步的显示为未接听的消息
static NSString * const Handler_Message_LZChat_Call_Finish = @"message.lzchat.call.finish";  // 结束消息
static NSString * const Handler_Message_LZChat_Call_Notice = @"message.lzchat.call.notice";  // 发送通知的通知
static NSString * const Handler_Message_LZChat_Call_Receive = @"message.lzchat.call.receive";  // 视频通话接听的通知
static NSString * const Handler_Message_LZChat_Call_Speech = @"message.lzchat.call.speech"; // 是否禁止说话
static NSString * const Handler_Message_LZChat_LZTemplateMsg_BSform = @"message.lzchat.lztemplatemsg.";  // 业务会话表单
static NSString * const Handler_Message_LZChat_LZTemplateMsg_CooperationShareFile = @"message.lzchat.lztemplatemsg.appcoopertion";
static NSString * const Handler_Message_LZChat_ConsultNotice = @"message.lzchat.consultnotice"; // 业务会话咨询通知
static NSString * const Handler_Message_LZChat_ChatLog = @"message.lzchat.chatlog"; // 合并转发消息

static NSString * const Handler_Message_LZChat_SR = @"message.lzchat.systemremind.";
static NSString * const Handler_Message_LZChat_SR_CreateGroup = @"message.lzchat.systemremind.creategroup"; //群组创建--消息
static NSString * const Handler_Message_LZChat_SR_Group_AddUser = @"message.lzchat.systemremind.adduser";  //群组加人--消息
static NSString * const Handler_Message_LZChat_SR_RemoveUser = @"message.lzchat.systemremind.removeuser";  //群组删人--消息
static NSString * const Handler_Message_LZChat_SR_QuitGroup = @"message.lzchat.systemremind.quitgroup";  //用户退出群组--消息
static NSString * const Handler_Message_LZChat_SR_AssignAdmin = @"message.lzchat.systemremind.assignadmin";  //群主管理权转移--消息
static NSString * const Handler_Message_LZChat_SR_ModifyGroupName = @"message.lzchat.systemremind.modifyname";  //群组名称修改--消息
static NSString * const Handler_Message_LZChat_SR_JoinGroup = @"message.lzchat.systemremind.joingroup";  //扫描二维码--消息
static NSString * const Handler_Message_LZChat_SR_AddFriend = @"message.lzchat.systemremind.addfriend"; //好友通过请求的消息
static NSString * const Handler_Message_LZChat_SR_FilePost = @"message.lzchat.systemremind.filepost"; //

/* 状态消息(statusmsg) */
static NSString * const Handler_Message_StatusMsg = @"statusmsg";
static NSString * const Handler_Message_StatusMsg_PerNoti_IsRead = @"message.statusmsg.isreaded";   //其它设备已读状态消息--持久通知
static NSString * const Handler_Message_StatusMsg_PerNoti_ReadedList = @"message.statusmsg.readedlist";   //消息已读情况列表--持久通知
static NSString * const Handler_Message_StatusMsg_ReCallMsg = @"message.statusmsg.recallmsg";// 消息撤回通知（通知其他人）
static NSString * const Handler_Message_StatusMsg_DeleteMsg = @"message.statusmsg.deletemsg";// 消息删除通知（通知自己）
static NSString * const Handler_Message_StatusMsg_PCLoginIn = @"message.statusmsg.pcloginin"; // PC端登录，客户端收到的通知
static NSString * const Handler_Message_StatusMsg_PCLoginOut = @"message.statusmsg.pcloginout"; // PC端退出


/* 最近联系人(recent) */
static NSString * const Handler_Message_Recent = @"recent";
static NSString * const Handler_Message_Recent_Remove = @"message.recent.remove";  //最近联系人删除--临时通知
static NSString * const Handler_Message_Recent_SetStick = @"message.recent.setstick"; // 最近联系人置顶
static NSString * const Handler_Message_Recent_SetDisturb = @"message.recent.setdisturb"; // 最近联系人个人设置免打扰

/* 群组通知(group) */
static NSString * const Handler_Message_Group = @"group";
static NSString * const Handler_Message_Group_Create = @"message.group.creategroup";  //群组创建--临时通知
static NSString * const Handler_Message_Group_AddUser = @"message.group.adduser";  //群组加人--临时通知(已改持久通知)
static NSString * const Handler_Message_Group_RemoveUser = @"message.group.removeuser";  //群组删人--临时通知(已改持久通知)
static NSString * const Handler_Message_Group_QuitGroup = @"message.group.quitgroup";  //用户退出群组--临时通知(已改持久通知)
static NSString * const Handler_Message_Group_AssignAdmin = @"message.group.assignadmin";   //群主管理权转移--临时通知
static NSString * const Handler_Message_Group_ModifyName = @"message.group.modifyname";  //群组名称修改--临时通知(已改持久通知)
static NSString * const Handler_Message_Group_UpdateGroup  = @"message.group.updategroup"; //更新群组信息--临时通知
static NSString * const Handler_Message_Group_Open = @"message.group.open";  // 打开群组--临时通知
static NSString * const Handler_Message_Group_Close = @"message.group.close";  // 关闭群组--临时通知
static NSString * const Handler_Message_Group_UpdateDisturb = @"message.group.updatedisturb";  // 群免打扰修改--临时通知
static NSString * const Handler_Message_Group_UpdateIsShow = @"message.group.updateisshow";  // 群聊保存通讯录--临时通知
static NSString * const Handler_Message_Group_UpdateFace = @"message.group.updateface";  //更新群组头像--持久通知
static NSString * const Handler_Message_Group_DeleteGroup = @"message.group.deletegroup"; // 删除群组

/* 新的协作消息 */
static NSString * const Handler_Message_NewCoo_invitemsg = @"cooperation.invitemsg";

/* 更新审批状态 */
static NSString * const Handler_Message_BusinessMessage = @"businessmessage";
static NSString * const Handler_BusinessMessage_UpdateBusinessStatus = @"businessmessage.updatebusinessstatus";
