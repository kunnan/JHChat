//
//  CooperationHT.h
//  LeadingCloud
//
//  Created by wchMac on 16/5/9.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#ifndef CooperationHT_h
#define CooperationHT_h


#endif /* CooperationHT_h */

/* ===============================协作(cooperation)=============================== */
static NSString * const Handler_Cooperation = @"cooperation";

/* 动态(post) */
static NSString * const Handler_Cooperation_Postmain = @"postmain";
static NSString * const Handler_Cooperation_Postmain_Insert  = @"cooperation.postmain.insert";  //添加动态--临时通知(处理)
static NSString * const Handler_Cooperation_Postmain_Delete  = @"cooperation.postmain.delete";  //删除动态--临时通知(处理)

// 回复
static NSString * const Handler_Cooperation_Post_Reply = @"post_reply";
static NSString * const Handler_Cooperation_Post_Reply_Insert = @"cooperation.post_reply.insert";  //动态评论--临时通知
static NSString * const Handler_Cooperation_Post_Reply_Delete = @"cooperation.post_reply.delete";  //动态删除评论--临时通知

//点赞
static NSString * const Handler_Cooperation_Post_Praise = @"post_praise";
static NSString * const Handler_Cooperation_Post_Praise_Insert = @"cooperation.post_praise.insert";  //动态评论--临时通知
static NSString * const Handler_Cooperation_Post_Praise_Delete = @"cooperation.post_praise.delete";  //动态删除评论--临时通知

//标签
static NSString * const Handler_Cooperation_Post_Tag = @"post_tag";
static NSString * const Handler_Cooperation_Post_Tag_Insert = @"cooperation.post_tag.insert";  //动态评论--临时通知
static NSString * const Handler_Cooperation_Post_Tag_Delete = @"cooperation.post_tag.delete";  //动态删除评论--临时通知

/* 常用语(postcue) */
static NSString * const Handler_Cooperation_Postcue = @"postcue";
static NSString * const Handler_Cooperation_Postcue_Insert  = @"cooperation.postcue.insert";  //添加常用语--临时通知(处理)
static NSString * const Handler_Cooperation_Postcue_Delete  = @"cooperation.postcue.delete";  //删除常用语--临时通知(处理)
static NSString * const Handler_Cooperation_Postcue_Update  = @"cooperation.postcue.update";  //更新常用语--临时通知(处理)

/* 我的提醒(post_remind) */
static NSString * const Handler_Cooperation_PostRemind = @"post_remind";
static NSString * const Handler_Cooperation_PostRemind_Insert  = @"cooperation.postremind.insert";  //添加--临时通知(未处理)
static NSString * const Handler_Cooperation_PostRemind_Count = @"cooperation.post_remind.count"; //协作动态--消息（已处理）




/* 资源评论(post_Resources) */
static NSString * const Handler_Cooperation_PostResources = @"post_resources";
static NSString * const Handler_Cooperation_PostResources_Insert  = @"cooperation.post_resources.insert";  //添加--临时通知(未处理)
static NSString * const Handler_Cooperation_PostResources_Delete  = @"cooperation.post_resources.delete";  //删除--临时通知(未处理)

/* 任务(task) */
static NSString * const Handler_Cooperation_Task = @"task";
static NSString * const Handler_Cooperation_Task_CreateTask  = @"cooperation.task.createtask";  //创建任务--临时通知(未处理)
static NSString * const Handler_Cooperation_Task_TaskBasicInfo  = @"cooperation.task.taskbasicinfo";  //修改任务信息--临时通知(未处理)
static NSString * const Handler_Cooperation_Task_SetMember  = @"cooperation.task.setmember";  //设置任务责任人--临时通知(未处理)
static NSString * const Handler_Cooperation_Task_DelMember  = @"cooperation.task.delmember";  //删除任务成员--临时通知(未处理)
static NSString * const Handler_Cooperation_Task_LockTask  = @"cooperation.task.locktask";  //锁定、解锁任务--临时通知(未处理)
static NSString * const Handler_Cooperation_Task_DelTask  = @"cooperation.task.deltask";  //删除任务--临时通知(未处理)
static NSString * const Handler_Cooperation_Task_TaskStateChange  = @"cooperation.task.taskstatechange";  //任务状态改变--临时通知(未处理)
static NSString * const Handler_Cooperation_Task_Phase  = @"cooperation.task.phase";  //任务环节创建/保存--临时通知(未处理)
static NSString * const Handler_Cooperation_Task_Phase_SetMember  = @"cooperation.task.phase.setmember";  //任务环节责任人设置--临时通知(未处理)
static NSString * const Handler_Cooperation_Task_ModifyMember  = @"cooperation.task.modifymember";  //修改成员--临时通知(未处理)

static NSString * const Handler_Cooperation_Task_SetState      = @"cooperation.task.setstate";          //设置任务状态--(处理)
static NSString * const Handler_Cooperation_Task_SetParent     = @"cooperation.task.setparent";         //设置任务父任务--临时通知(处理)
static NSString * const Handler_Cooperation_Task_SetName       = @"cooperation.task.setname";          //修改任务名称--临时通知(处理)
static NSString * const Handler_Cooperation_Task_SetLock       = @"cooperation.task.setlock";           //设置任务锁--临时通知(处理)
static NSString * const Handler_Cooperation_Task_SetPhaseadmin = @"cooperation.task.setphaseadmin";     //设置节点管理员--临时通知(未处理)
static NSString * const Handler_Cooperation_Task_SetPhaseState = @"cooperation.task.setphasestate";     //设置节点状态--临时通知(未处理)

/* 项目(project) */
static NSString * const Handler_Cooperation_Project = @"project";

/* 工作组(workgroup) */
static NSString * const Handler_Cooperation_Group = @"workgroup";
static NSString * const Handler_Cooperation_Group_ApplyJoinGroup  = @"cooperation.group.setapplyroot";  //申请加入工作组 权限--临时通知(未处理)
static NSString * const Handler_Cooperation_Group_SetState  = @"cooperation.group.setstate";  //工作组状态--临时通知(处理)
static NSString * const Handler_Cooperation_Group_SetName  = @"cooperation.group.setname";  //修改工作组名称--临时通知(处理)
static NSString * const Handler_Cooperation_Group_SetMemberState  = @"cooperation.group.setmemberstate";  //工作组成员权限--临时通知(处理)
static NSString * const Handler_Cooperation_Group_SetLogo  = @"cooperation.group.setlogo";  //工作组设置logo--临时通知(处理)

static NSString * const Handler_Cooperation_Member_Add  = @"cooperation.member.add";  //成员添加--临时通知(未处理)
static NSString * const Handler_Cooperation_Member_Del  = @"cooperation.member.del";  //成员删除--临时通知(未处理)


static NSString * const Handler_Cooperation_Invitemsg = @"cooperation.invitemsg";  //新的协作--消息(已处理)

static NSString * const Handler_Cooperation_Invite_Add  = @"cooperation.invite.add";  //协作添加成员邀请--临时通知(未处理)
static NSString * const Handler_Cooperation_Invite_Revert  = @"cooperation.invite.revert";  //协作撤销成员邀请--临时通知(未处理)
static NSString * const Handler_Cooperation_ReceiveInvite = @"cooperation.receiveinvite";  //收到邀请--临时通知(未处理)

/* internal static class Cooperation */
static NSString * const Handler_Cooperation_Add = @"cooperation.add";
static NSString * const Handler_Cooperation_Del = @"cooperation.del";
static NSString * const Handler_Cooperation_newhandle = @"cooperation.newhandle"; // 新的协作-- 邀请通知-新(处理)
static NSString * const Handler_Cooperation_Send = @"cooperation.invite.send";
static NSString * const Handler_Cooperation_Agree = @"cooperation.invite.agree";   // 同意(处理）
static NSString * const Handler_Cooperation_Disagree = @"cooperation.invite.disagree"; // 不同意(处理)
static NSString * const Handler_Cooperation_Revoke = @"cooperation.invite.revoke"; // 撤销邀请(未处理)

/* 应用(app) */
static NSString * const Handler_Cooperation_App = @"app";
static NSString * const Handler_Cooperation_App_Insert = @"cooperation.app.insert"; //增加应用--临时通知(未处理)
static NSString * const Handler_Cooperation_App_Phase = @"cooperation.app.phase"; //更新应用--临时通知(未处理)
static NSString * const Handler_Cooperation_App_Delete = @"cooperation.app.delete"; //删除应用--临时通知(未处理)
static NSString * const Handler_Cooperation_App_Ref_Insert = @"cooperation.app.ref.insert"; //增加工具--临时通知(未处理)
static NSString * const Handler_Cooperation_App_Ref_Phase = @"cooperation.app.ref.phase"; //增加工具--临时通知(未处理)
static NSString * const Handler_Cooperation_App_Ref_Delete = @"cooperation.app.ref.delete"; //增加工具--临时通知(未处理)

/* 协作文件(document) */
static NSString * const Handler_Cooperation_Document = @"document";
static NSString * const Handler_Cooperation_Document_Resource_Insert = @"cooperation.document.resource.insert"; //资源新增--临时通知(处理)
static NSString * const Handler_Cooperation_Document_Resource_Delete = @"cooperation.document.resource.delete"; //资源删除--临时通知(处理)
static NSString * const Handler_Cooperation_Document_Resource_Update = @"cooperation.document.resource.update"; //资源修改--临时通知(处理)
static NSString * const Handler_Cooperation_Document_Folder_Insert = @"cooperation.document.folder.insert"; //文件夹新增--临时通知(处理)
static NSString * const Handler_Cooperation_Document_Folder_Delete = @"cooperation.document.folder.delete"; //文件夹删除--临时通知(处理)
static NSString * const Handler_Cooperation_Document_Folder_Update = @"cooperation.document.folder.update"; //文件夹修改--临时通知(处理)
static NSString * const Handler_Cooperation_Document_Resource_Move = @"cooperation.document.resource.move"; //资源移动--临时通知(处理)
static NSString * const Handler_Cooperation_Document_Folder_Move = @"cooperation.document.folder.move"; //文件夹移动--临时通知(处理)

/* 日志(log) */
static NSString * const Handler_Cooperation_Log = @"log";
static NSString * const Handler_Cooperation_Log_Add = @"cooperation.log.add"; //新增日志--临时通知(未处理)

/* 好友(friend) */
static NSString * const Handler_Cooperation_Friend = @"friend";
static NSString * const Handler_Cooperation_Friend_Invite = @"cooperation.friend.invite"; //邀请--临时通知(未处理)
static NSString * const Handler_Cooperation_Friend_Accept = @"cooperation.friend.accept"; //接受邀请--临时通知(未处理)
static NSString * const Handler_Cooperation_Friend_Refuse = @"cooperation.friend.refuse"; //拒绝邀请--临时通知(未处理)


