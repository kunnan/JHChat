//
//  CooperationWebApi.h
//  LeadingCloud
//
//  Created by wchMac on 16/6/2.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#ifndef CooperationWebApi_h
#define CooperationWebApi_h


#endif /* CooperationWebApi_h */


/*------------------动态-------------------*/
static NSString * const WebApi_CloudPost = @"api/Post";
/* 删除动态 */
static NSString * const WebApi_CloudPostDelPost = @"api/PostV/DelPost/{romvepid}/{pid}/{tokenid}";

/* 添加动态 */
static NSString * const WebApi_CloudPostAddPost = @"api/cooperation/post/AddPost/{tokenid}";

/* 添加动态 */
static NSString * const WebApi_CloudPostAddbasepostPost = @"api/cooperation/post/addbasepost/{tokenid}";

/* 回复动态 */
static NSString * const WebApi_CloudPostReplyPost = @"api/PostV/ReplyPostModel/{pid}/{tokenid}";
/* 动态列表 */
static NSString * const WebApi_CloudPostList = @"api/PostV/GetPostList/{tokenid}";
/* 个人动态列表 */
static NSString * const WebApi_CloudUserPostList = @"api/postv/getuserpostlist/{tokenid}";

/* 动态主列表 */
static NSString * const WebApi_CloudFollowNextPostList = @"api/postv/GetFollowNextPostList/{tokenid}";

/* 动态点赞 GET */
static NSString * const WebApi_CloudPostPraisePost = @"api/PhonePostV/phonePraisePost/{pid}/{tokenid}";
/* 动态取消点赞 GET*/
static NSString * const WebApi_CloudPostPraiseCannelPost = @"api/PhonePostV/DelphonePraisePost/{pid}/{ppid}/{tokenid}";


/* 获取常用语 */
static NSString * const WebApi_CloudPostGetPostCueList = @"api/PostV/GetPostCueList/{orgid}/{tokenid}";
/* 添加常用语 */
static NSString * const WebApi_CloudPostGetPostCueAdd = @"api/PostV/SavePostCue/{tokenid}";
/* 查询常用语 */
static NSString * const WebApi_CloudPostGetPostCueDetial = @"api/PostV/GetPostCue/{pcid}/{tokenid}";
/* 删除常用语 */
static NSString * const WebApi_CloudPostGetPostCueDel = @"api/PostV/DelPostCue/{pcid}/{tokenid}";


/* 根据pid获取动态 GET */
static NSString * const WebApi_CloudPostGetPostShowModel = @"api/PostV/GetPhonePostShowModel/{pid}/{tokenid}";
/* 动态消息提醒 GET */
static NSString * const WebApi_CloudPostRemindList = @"api/PostV/GetUserPostReMind/{tokenid}";
/* 动态消息提醒 GET */
static NSString * const WebApi_CloudPostunreadRemindList = @"api/postv/getunreadpostremind/{tokenid}";
/* 动态消息提醒 POST */
static NSString * const WebApi_CloudPostMoreRemindList = @"api/PostV/GetHistoryDateRemind/{tokenid}";
/* @成员列表 */
static NSString * const WebApi_CloudPostGetmembermodellist = @"api/PostV/GetAntMemberModelList/{tokenid}";
/* 模板 */
static NSString * const WebApi_CloudPostTempleList = @"api/template/gettemplatelist/1/{tokenid}";

/*动态类型*/
static NSString * const WebApi_CloudGetPosttypeList = @"api/PostV/GetPosttypeList/{tokenid}";

//动态标签通知
static NSString * const WebApi_CloudGetIncreaseTag = @"api/PostV/IncreaseTag/{pid}/{tagid}/{tokenid}";
static NSString * const WebApi_CloudGetRemoveTag = @"api/PostV/RemoveTag/{pid}/{tagid}/{tokenid}";


/*------------------协作，通用-------------------*/
static NSString * const WebApi_CloudCooperation = @"api/cooperation";
/* 协作成员分页 */
static NSString * const WebApi_CloudCooperationGetPageMemberList = @"api/cooperation/v2/member/getlist4p/{cid}/{lastuid}/{length}/{tokenid}";
/* 搜索协作成员分页 Post */
static NSString * const WebApi_CloudCooperationGetSearchMemberList = @"api/cooperation/v2/member/getlist4name4p/{cid}/{lastuid}/{length}/{tokenid}";
/* 协作通过的全部成员 */
static NSString * const WebApi_CloudCooperationGetValidMemberList = @"api/cooperation/v2/member/getvalidlist/{cid}/{tokenid}";


/*删除成员 GET*/
static NSString * const WebApi_CloudCoo_Member_del = @"api/cooperation/v2/member/remove/{type}/{cid}/{uid}/{tokenid}";
/*重新邀请 Get*/
static NSString * const WebApi_CloudCoo_Member_AfreshAdd = @"api/cooperation/v2/invite/resend/{type}/{cid}/{uid}/{tokenid}";
/*撤销邀请 GET*/
static NSString * const WebApi_CloudCoo_Member_RevokeAdd = @"api/cooperation/v2/invite/revoke/{type}/{cid}/{uid}/{tokenid}";
/*添加邀请 POST*/
static NSString * const WebApi_CloudCoo_Member_Add = @"api/cooperation/v2/invite/send/{type}/{cid}/{sendnow}/{tokenid}";
/*退出协作 GET*/
static NSString * const WebApi_CloudCoo_Member_quit = @"api/cooperation/v2/member/quit/{type}/{cid}/{tokenid}";


/*修改当前人参与身份*/
static NSString * const WebApi_CloudCoo_SetMemberOrg = @"api/cooperation/v2/member/setorg/{type}/{cid}/{oid}/{did}/{tokenid}";

/*判断用户是否存在协作中*/
static NSString * const WebApi_CloudCoo_IsExitMember = @"api/cooperation/v2/member/exists/{cid}/{uid}/{tokenid}";

/*判断用户是否存在协作中*/
static NSString * const WebApi_CloudCoo_ObserverList = @"api/cooperation/v2/observer/getlist/{cid}/{tokenid}";

/*判断用户是否存在协作中*/
static NSString * const WebApi_CloudCoo_DelCo_Observer = @"api/cooperation/v2/observer/del/{cooid}/{tokenid}";

/*判断用户是否存在协作中*/
static NSString * const WebApi_CloudCoo_AddCo_Observer = @"api/cooperation/v2/observer/add/{tokenid}";

/*判断用户是否订阅*/
static NSString * const WebApi_CloudCoo_Base_Get_Subscribe = @"api/cooperation/base/member/get/{cid}/{uid}/{tokenid}";

/*设置用户订阅*/
static NSString * const WebApi_CloudCoo_Base_Set_Subscribe = @"api/cooperation/base/member/addorremoveSubscription/{tokenid}";

static NSString * const WebApi_Cooperation_Base_Get = @"api/cooperation/base/get/{cid}/{tokenid}";

/*------------------协作，工作组-------------------*/
static NSString * const WebApi_CloudCooperationWorkGroup = @"api/cooperation/group";

/* 获取我加入工作组列表 */
static NSString * const WebApi_CloudCooperationWorkGroupPostList = @"api/cooperation/v2/group/getlist/{oid}/{lastkey}/{length}/{tokenid}";

/* 获取我加入的组织类工作圈集合 */
static NSString * const WebApi_CloudCooperationWorkGroupGetOrglist = @"api/workgroup/getorglist/{oid}/{tokenid}";

/* 获取我加入工作组列表 */
static NSString * const WebApi_CloudCooperationWorkGroupMyJoinList = @"api/workgroup/getgenerallist/{tokenid}";
/* 获取我创建工作组列表 */
static NSString * const WebApi_CloudCooperationWorkGroupMyCreatList = @"api/workgroup/getgenerallist4created/{tokenid}";
/* 获取我管理工作组列表 */
static NSString * const WebApi_CloudCooperationWorkGroupMyMangerList = @"api/workgroup/getgenerallist4managed/{tokenid}";


/* 获取关闭工作组列表 */
static NSString * const WebApi_CloudCooperationWorkGroupCloseList = @"api/workgroup/getgenerallist4closed/{tokenid}";
/* 创建工作组手机端 */
static NSString * const WebApi_CloudCooperationCreatWorkGroupForMobile = @"api/cooperation/v2/group/add/{tokenid}";
/* 获取工作组详情 */
static NSString * const WebApi_CloudCooperationWorkGroupDetial = @"api/cooperation/v2/group/get4ios/{gid}/{tokenid}";

static NSString * const WebApi_CloudCooperationWorkGroupBaseInfo = @"api/cooperation/v2/group/getbasicinfo/{gid}/{tokenid}";

/* 修改工作组名字 */
static NSString * const WebApi_CloudCooperationWorkGroupSetName = @"api/cooperation/v2/group/setname/{gid}/{tokenid}";
/* 修改工作组描述 */
static NSString * const WebApi_CloudCooperationWorkGroupSetDes = @"api/cooperation/v2/group/setdes/{gid}/{tokenid}";
/* 设置申请加入权限 */
static NSString * const WebApi_CloudCooperationWorkGroupSetApplyroot = @"api/cooperation/v2/group/setapplyroot/{gid}/{tokenid}";

/* 解散工作组 */
static NSString * const WebApi_CloudCooperationWorkGroupDismiss = @"api/cooperation/v2/group/del/{groupId}/{tokenid}";
/* 关闭工作组 */
static NSString * const WebApi_CloudCooperationWorkGroupTurnOff = @"api/cooperation/v2/group/off/{groupId}/{tokenid}";
/* 开启工作组 */
static NSString * const WebApi_CloudCooperationWorkGroupTurnOn = @"api/cooperation/v2/group/on/{groupId}/{tokenid}";
/* 搜索工作组 */
static NSString * const WebApi_CloudCooperationJoinWorkGroup = @"api/cooperation/v2/group/getbycode4apply/{tokenid}";
/* 根据gid搜索工作组 */
static NSString * const WebApi_CloudCooperationJoinWorkGroupFormGid = @"api/cooperation/v2/group/getbygid4apply/{gid}/{tokenid}";
/* 加入工作组 */
static NSString * const WebApi_CloudCooperationApplyJoingWorkGroup = @"api/cooperation/v2/apply/sendapply/{type}/{cid}/{tokenid}";
/*设置群组管理员*/
static NSString * const WebApi_CloudCooperationGroupMemberSetAdmin = @"api/cooperation/v2/group/setadmin/{gid}/{uid}/{tokenid}";
static NSString * const WebApi_CloudCooperationGroupMemberSetCharge = @"api/cooperation/v2/group/setcharge/{gid}/{uid}/{tokenid}";

/*取消群组管理员*/
static NSString * const WebApi_CloudCooperationGroupMemberRemoveAdmin = @"api/cooperation/v2/group/canceladmin/{gid}/{uid}/{tokenid}";

/*上传工作组logo POST*/
static NSString * const WebApi_CloudCooperationUpGroupLogo = @"api/cooperation/v2/group/setlogo/{gid}/{tokenid}";
static NSString * const WebApi_CloudCooperationUpGroupimg = @"api/filemanager/img/shear/{fileid}/0/0/{width}/{height}/{tokenid}";
static NSString * const WebApi_CloudCooperationUpGroupimgLogo = @"api/filemanager/img/shear/{fileid}/0/0/{width}/{height}/{logo}/{tokenid}";


/*------------------协作，任务-------------------*/
static NSString * const WebApi_CloudCooperationTask = @"api/cooperation/task";
/* 创建任务 */
static NSString * const WebApi_CloudCooperationTaskCreat = @"api/cooperation/v2/task/addtaskbycreater/{uid}/{tokenid}";
/* 修改任务描述 */
static NSString * const WebApi_CloudCooperationTaskEditDescribe = @"api/cooperation/v2/task/setdes/{tid}/{tokenid}";
/* 修改任务计划时间 */
static NSString * const WebApi_CloudCooperationTaskPlanDate = @"api/cooperation/v2/task/setplandate/{tid}/{tokenid}";
/* 修改任务名称 */
static NSString * const WebApi_CloudCooperationTaskName = @"api/cooperation/v2/task/setname/{tid}/{tokenid}";
///* 任务列表 */
//static NSString * const WebApi_CloudCooperationTaskList = @"api/cooperation/v2/task/getlistbyname/{type}/{oid}/{lastkey}/{length}/{tokenid}";
/* 任务列表 */
static NSString * const WebApi_CloudCooperationTaskList = @"api/cooperation/v3/task/getlistbyname/{tokenid}";
/* 获取关注的任务  废弃啦 get*/
static NSString * const WebApi_CloudCooperationGetAttentionlist = @"api/cooperation/v2/task/getlist/{type}/{oid}/{lastkey}/{length}/{tokenid}";
/* 搜索任务 */
static NSString * const WebApi_CloudCooperationJoinTask = @"api/cooperation/v2/task/getbycode4apply/{tokenid}";

static NSString * const WebApi_CloudCooperationJoinTaskFormGid = @"api/cooperation/v2/task/getbytid4apply/{tid}/{tokenid}";
/*获取任务基本信息*/
static NSString * const WebApi_CloudCooperationTaskInfo = @"api/cooperation/v2/task/get4ios/{tid}/{tokenid}";


static NSString * const WebApi_CloudCooperationTaskNewInfo = @"api/cooperation/v2/task/getbasicinfo/{tid}/{tokenid}";
static NSString * const WebApi_CloudCooperationTaskGoal = @"api/cooperation/v2/task/gettarget/{tid}/{tokenid}";

/* 子任务列表 */
static NSString * const WebApi_CloudCooperationChildTaskList = @"api/cooperation/v2/task/getchildlist/{ptid}/{tokenid}";
/*创建任务节点*/
static NSString * const WebApi_CloudCooperationTaskCreatPhase = @"api/cooperation/v2/task/phase/add/{tokenid}";
/*设置环节描述*/
static NSString * const WebApi_CloudCooperationTaskSavePhaseDes = @"api/cooperation/v2/task/phase/setdes/{tid}/{phid}/{tokenid}";
/*设置环节提示*/
static NSString * const WebApi_CloudCooperationTaskSavePhaseTip = @"api/cooperation/v2/task/phase/settip/{tid}/{phid}/{tokenid}";
/*设置环节时限*/
static NSString * const WebApi_CloudCooperationTaskSavePhaseDateLimit = @"api/cooperation/v2/task/phase/setdatelimit/{tid}/{phid}/{tokenid}";
/*激活任务节点*/
static NSString * const WebApi_CloudCooperationTaskActivePhase = @"api/cooperation/v2/task/phase/running/{tid}/{phid}/{tokenid}";
/*完成任务节点*/
static NSString * const WebApi_CloudCooperationTaskFinishPhase = @"api/cooperation/v2/task/phase/finish/{tid}/{phid}/{tokenid}";
/*未开始任务节点*/
static NSString * const WebApi_CloudCooperationTaskUnstartPhase = @"api/cooperation/v2/task/phase/unstart/{tid}/{phid}/{tokenid}";
/*删除任务节点*/
static NSString * const WebApi_CloudCooperationTaskDeletePhase = @"api/cooperation/v2/task/phase/del/{tid}/{phid}/{tokenid}";
/*修改任务节点负责人*/
static NSString * const WebApi_CloudCooperationTaskSetAdmin = @"api/cooperation/v2/task/phase/setadmin/{tid}/{phid}/{tokenid}";
/*设置托付任务*/
static NSString * const WebApi_CloudCooperationTaskSetTaskAdmin = @"api/cooperation/v2/task/setadmin/{tid}/{uid}/{tokenid}";
/*设置任务管理员*/
static NSString * const WebApi_CloudCooperationMemberSetAdmin = @"api/cooperation/v2/member/admin/set/{cid}/{uid}/{tokenid}";
/*删除任务管理员*/
static NSString * const WebApi_CloudCooperationMemberCannelAdmin = @"api/cooperation/v2/member/admin/cancel/{cid}/{uid}/{tokenid}";
/*发布任务*/
static NSString * const WebApi_CloudCooperationTaskPublishtask = @"api/cooperation/v2/task/publish/{tid}/{tokenid}";
/*暂停任务*/
static NSString * const WebApi_CloudCooperationTaskPausetask = @"api/cooperation/v2/task/pause/{tid}/{tokenid}";
/*恢复任务*/
static NSString * const WebApi_CloudCooperationTaskRecovertask = @"api/cooperation/v2/task/recover/{tid}/{tokenid}";
/*废弃任务*/
static NSString * const WebApi_CloudCooperationTaskAbandontask = @"api/cooperation/v2/task/abandon/{tid}/{tokenid}";
/*完成任务*/
static NSString * const WebApi_CloudCooperationTaskCompletetask = @"api/cooperation/v2/task/complete/{tid}/{tokenid}";
/*锁定任务*/
static NSString * const WebApi_CloudCooperationTaskLocktask = @"api/cooperation/v2/task/lock/{tid}/{tokenid}";
/*解锁任务*/
static NSString * const WebApi_CloudCooperationTaskUnLocktask = @"api/cooperation/v2/task/unlock/{tid}/{tokenid}";
/*删除任务*/
static NSString * const WebApi_CloudCooperationTaskDeltask = @"api/cooperation/v2/task/del/{tid}/{tokenid}";
/*设置可关联母任务 */
static NSString * const WebApi_CloudCooperationTaskModifyRelateTask = @"api/cooperation/v2/task/setparent/{tid}/{pid}/{tokenid}";
/* 设置申请加入权限 */
static NSString * const WebApi_CloudCooperationTaskSetApplyroot = @"api/cooperation/v2/task/setapplyroot/{tid}/{tokenid}";

/*获取可关联母任务列表get*/
static NSString * const WebApi_CloudCooperationTaskLoadRelateTaskList = @"api/cooperation/v2/task/getlist4reltask/{tid}/{oid}/{tokenid}";
/* 获取任务基本信息*/
static NSString * const WebApi_CloudCooperationLoadtaskbasicinfo = @"api/cooperation/v2/task/get/{tid}/{tokenid}";
/* 获取任务关联工作组已选择列表*/
static NSString * const WebApi_CloudCooperationTaskRefGroupSelectedList = @"api/cooperation/v2/task/ref/group/getselectedlist/{tid}/{oid}/{tokenid}";
/* 获取任务关联工作组未选择列表*/
static NSString * const WebApi_CloudCooperationTaskRefGroupUnSelectedList = @"api/cooperation/v2/task/ref/group/getunselectlist/{tid}/{oid}/{tokenid}";
/* 获取任务关联工作组全部列表*/
static NSString * const WebApi_CloudCooperationTaskRefGroupAllList = @"api/cooperation/v2/task/ref/group/getlist/{tid}/{oid}/{tokenid}";
/*删除关联工作组*/
static NSString * const WebApi_CloudCooperationTaskDeleteRelatedGroup = @"api/cooperation/v2/task/ref/group/del/{tid}/{gid}/{tokenid}";
/*添加关联工作组*/
static NSString * const WebApi_CloudCooperationTaskAddRelatedGroup = @"api/cooperation/v2/task/ref/group/add/{tid}/{gid}/{tokenid}";
/* 获取任务关联项目未选择列表*/
static NSString * const WebApi_CloudCooperationTaskRefProjectUnSelectedList = @"api/cooperation/v2/task/ref/project/getunselectlist/{tid}/{oid}/{tokenid}";
/* 获取任务关联工作组全部列表*/
static NSString * const WebApi_CloudCooperationTaskRefProjectAllList = @"api/cooperation/v2/task/ref/project/getlist/{tid}/{oid}/{tokenid}";
/*删除关联项目*/
static NSString * const WebApi_CloudCooperationTaskDeleteRelatedProject = @"api/cooperation/v2/task/ref/project/del/{tid}/{prid}/{tokenid}";
/*添加关联项目*/
static NSString * const WebApi_CloudCooperationTaskAddRelatedProject = @"api/cooperation/v2/task/ref/project/add/{tid}/{prid}/{tokenid}";



/*------------------协作，待处理-------------------*/

static NSString * const WebApi_CloudCooperationPending = @"api/transaction";
/*获取用户在指定企业下的岗位信息*/
static NSString * const WebApi_CloudCooperationPendingPostinfoList = @"api/Transaction/GetPostInfo/{eid}/{tokenid}";//GET api/Transaction/GetPostInfo

static NSString * const WebApi_CloudCooperationPendingNewList = @"api/todolist/gettodolist/{orgid}/{tokenid}";//GET 

static NSString * const WebApi_CloudCooperationPendingNewCount = @"api/todolist/getuntransactcount/{orgid}/{tokenid}";//GET

/*根据组合查询条件获取事务项信息*/
static NSString * const WebApi_CloudCooperationPendingList = @"api/Transaction/Item/InquireTransactionItemModelAndCount/{tokenid}";//POST
/*根据组合查询条件获取事务项查询条件*/
static NSString * const WebApi_CloudCooperationPendingTypeList = @"api/Transaction/InquireTransactionTypeAndB/{tokenid}";//POST
/*查询任务类型集合*/
static NSString * const WebApi_CloudCooperationPendingModelType = @"api/Transaction/Type/GetModelList/{tokenid}";//GET

/*查询任务类型*/
static NSString * const WebApi_CloudCooperationPendingGetModelByType = @"api/Transaction/Type/GetModel/{ttid}/{tokenid}";//GET

/*查询任务项中的各个状态数量*/
static NSString * const WebApi_CloudCooperationPendingStatusCount = @"api/Transaction/Item/InquireTransactionStatusCount/{tokenid}";//POST
/*查询任务模型*/
static NSString * const WebApi_CloudCooperationPendingModelItem = @"api/Transaction/Item/GetMyTransactionModel/{ttid}/{businessid}/{tokenid}";//GET


/*----------------------- 协作,项目（最新）2016.10.17---------------------------------------*/
static NSString *const WebApi_CloudCooperation_Project = @"api/projectmain";
static NSString *const WebApi_CloudCooperation_Devrun_Project = @"api/devrun/projectmain";
/* 获取我的项目分组 */
static NSString * const WebApi_CloudCooperation_GetCustomGroup = @"api/projectmain/getcustomgroups/{tokenid}";
/* 获取我的所有项目 */
static NSString * const WebApi_CloudCooperation_GetllpProjects = @"api/projectmain/getallprojects/{tokenid}";
/* 添加项目分组 */
static NSString * const WebApi_CloudCooperation_AddCustomGroup = @"api/projectmain/addcustomgroup/{tokenid}";
/* 设置项目分组的顺序 */
static NSString * const WebApi_CloudCooperation_SetCustomGroupSort = @"api/projectmain/setcustomgroupsort/{pgId}/{newSort}/{tokenid}";
/* 删除分组 */
static NSString * const WebApi_CloudCooperation_DeleteCustomGroup = @"api/projectmain/deletecustomgroup/{pgId}/{tokenid}";
/* 设置分组名称 */
static NSString * const WebApi_CloudCooperation_SetCustomGroupName = @"api/projectmain/setcustomgroupname/{tokenid}";
/* 获取指定项目实例分组下的项目 */
static NSString * const WebApi_CloudCooperation_GetProjectsItem = @"api/projectmain/getprojects/{tokenid}";
/* 项目置顶和取消置顶操作 */
static NSString * const WebApi_CloudCoopration_ProjectTopAction = @"api/projectmain/projecttopaction/{tokenid}";
/* 获取项目置顶状态值 */
static NSString * const WebApi_CloudCooperation_GetProjectTopValue = @"api/projectmain/getprojecttopvalue/{prId}/{uid}/{orgId}/{tokenid}";
/* 调整项目的所属分组 */
static NSString * const WebApi_CloudCooperation_SetProjectToNewGroup = @"api/projectmain/setproject2newgroup/{tokenid}";
/* 添加项目参与人 */
static NSString * const WebApi_CloudCooperation_AddMember = @"api/projectmain/addmember/{tokenid}";
/* 提交的查询数据 */
static NSString * const WebApi_CloudCooperation_GetProjecstWithSearch = @"api/projectmain/getprojectswithsearch/{tokenid}";
/* 获取指定项目id的项目数据（旧模式） */
static NSString * const WebApi_CloudCooperation_GetProjectMain = @"api/projectmain/getprojectmain/{prId}/{tokenid}";
/* 获取指定项目id的项目数据（新模式）*/
static NSString * const WebApi_Devrun_CloudCooperation_GetProjectMain = @"api/devrun/projectmain/getprojectmain/{prId}/{tokenid}";

/* 获取我在当前项目下能够使用的模块（旧模式） */
static NSString * const WebApi_CloudCooperation_GetMods = @"api/projectmain/getmods/{tokenid}";
/* 获取我在当前项目下能够使用的模块（新模式） */
static NSString * const WebApi_Devrun_CloudCooperation_GetMods = @"api/devrun/projectmain/getmods/{tokenid}";

/* 获取当前项目可用的所有模块（旧模式） */
static NSString * const WebApi_CloudCooperation_GetAllMods = @"api/projectmain/getallmods/{prId}/{tokenid}";
/* 获取当前项目可用的所有模块（新模式） */
static NSString * const WebApi_Devrun_CloudCooperation_GetAllMods = @"api/devrun/projectmain/getallmods/{prId}/{tokenid}";
/* 重新设置当前项目能用的所有模块 备注：此接口会将之前当前项目下已有的数据清空，插入当前的数据（旧模式） */
static NSString * const WebApi_CloudCooperation_ResetProjectMods = @"api/projectmain/resetprojectmods/{prId}/{tokenid}";
/* 重新设置当前项目能用的所有模块 备注：此接口会将之前当前项目下已有的数据清空，插入当前的数据（新模式） */
static NSString * const WebApi_Devrun_CloudCooperation_ResetProjectMods = @"api/devrun/projectmain/resetprojectmods/{prId}/{tokenid}";






/*------------------协作，项目-------------------*/
static NSString * const WebApi_CloudCooperationProject = @"api/cooperation/project";

/*新建项目 POST*/
static NSString * const WebApi_CloudCooperationProjectAdd = @"api/cooperation/v2/project/add/{tokenid}";
/*项目列表 GET*/
static NSString * const WebApi_CloudCooperationProjectList = @"api/cooperation/v2/project/getlist/{oid}/{tokenid}";
/*项目基本信息 GET*/
static NSString * const WebApi_CloudCooperationProjectBaseInfo = @"api/cooperation/v2/project/get4ios/{prid}/{tokenid}";
/*项目修改名称 Post*/
static NSString * const WebApi_CloudCooperationProjectEditName = @"api/cooperation/v2/project/setname/{prid}/{tokenid}";
/*项目修改描述 Post*/
static NSString * const WebApi_CloudCooperationProjectEditDes = @"api/cooperation/v2/project/setdes/{prid}/{tokenid}";
/*项目修改开始时间 Post*/
static NSString * const WebApi_CloudCooperationProjectEditStartTime = @"api/cooperation/v2/project/setplanbegindate/{prid}/{tokenid}";
/*项目修改结束时间 Post*/
static NSString * const WebApi_CloudCooperationProjectEditEndTime = @"api/cooperation/v2/project/setplanenddate/{prid}/{tokenid}";
/*遗弃项目 get*/
static NSString * const WebApi_CloudCooperationProjectAbandon = @"api/cooperation/v2/project/abandon/{prid}/{tokenid}";
/*删除项目 get*/
static NSString * const WebApi_CloudCooperationProjectdel = @"api/cooperation/v2/project/del/{oid}/{prid}/{tokenid}";
/*完成项目 get*/
static NSString * const WebApi_CloudCooperationProjectFinsh = @"api/cooperation/v2/project/finish/{prid}/{tokenid}";
/*进行项目 get*/
static NSString * const WebApi_CloudCooperationProjectRuning = @"api/cooperation/v2/project/running/{prid}/{tokenid}";
/*项目任务列表 get*/
static NSString * const WebApi_CloudCooperationProjectAllTaskList = @"api/cooperation/v2/project/task/getlist/{prid}/{tokenid}";





/*----------------------------------- 新的协作 --------------------------------------------*/
/* 协作区内所有邀请我的成员列表  api/cooperation/v2/invite/getlis api/cooperation/v2/other/gethandlelist/{tokenid}*/
static NSString * const WebApi_CloudCooperationNew_hasinvited = @"api/cooperation/v2/invite/getlist/{tokenid}";
/* 接收邀请操作(不同意) */
static NSString * const Webapi_CloudCooperationNew_DisagreeInvite = @"api/cooperation/v2/invite/disagree/{type}/{cid}/{tokenid}";
/* 同意邀请 */
static NSString * const WebApi_CloudCooperationNew_AgreeInvite = @"api/cooperation/v2/invite/agree/{type}/{cid}/{oid}/{did}/{tokenid}";
/* 删除邀请 */
static NSString * const WebApi_CloudCooperationNew_DeleteInvite = @"api/cooperation/v2/invite/del/{cid}/{tokenid}";
/* 删除邀请日志 */
static NSString * const WebApi_CloudCooperationNew_DeleteLogInvite = @"api/cooperation/v2/invite/log/del/{cid}/{keyid}/{tokenid}";
/*获取新的协作日志信息集合*/
static NSString * const WebApi_CloudCooperationNew_GetLogList = @"api/cooperation/v2/invite/log/getlist/{length}/{lastlogid}/{tokenid}";

/* 查询任务类型model */
static NSString * const WebApi_CloudCooperationNew_GetModel = @"api/Transaction/Type/GetModel/{ttid}/{tokenid}";
/* 获取新的协作邀请信息 */
static NSString *const WebApi_CloudCooperationNew_GetNewCooInviteInfo = @"api/cooperation/v2/invite/get/{keyid}/{tokenid}";

/*------------------------------------ 新的成员 --------------------------------------------*/
static NSString * const WebApi_CloudCooperationNew = @"api/cooperation/v2";
/*获取新的协作邀请数据集合 GET*/
static NSString * const WebApiCloudCooperationNewMember_GetList  = @"api/cooperation/v2/apply/getlist/{tokenid}";
/*申请通过 GET*/
static NSString * const WebApiCloudCooperationNewMember_Pass = @"api/cooperation/v2/apply/pass/{cid}/{uid}/{tokenid}";
/*申请不通过 GET 变成了删除 */
static NSString * const WebApiCloudCooperationNewMember_NotPass = @"api/cooperation/v2/apply/notpass/{cid}/{uid}/{tokenid}";
/* 删除申请日志 */
static NSString * const WebApiCloudCooperationNewMember_DeleteLoagApply = @"api/cooperation/v2/apply/log/del/{cid}/{cmalid}/{tokenid}";
/*获取新的成员日志信息集合*/
static NSString * const WebApiCloudCooperationNewMember_GetLoglist = @"api/cooperation/v2/apply/log/getlist/{length}/{lastlogid}/{tokenid}";
/* 获取申请数据 */
static NSString * const WebApiCloudCooperationNewMenber_GetNewApplyInfo = @"api/cooperation/v2/apply/get/{keyid}/{tokenid}";

/* 获取普通成员发起的邀请信息 */
static NSString * const WebApiCloudCooperationApproval_GetApprovalInfo = @"api/cooperation/v2/invite/approval/get/{keyid}/{tokenid}";
/* 同意普通成员发起的邀请信息 */
static NSString * const WebApiCloudCooperationApproval_AgreeApproval = @"api/cooperation/v2/invite/approval/agree/{keyid}/{tokenid}";
/* 忽略普通成员发起的邀请信息 */
static NSString * const WebApiCloudCooperationApproval_IgnoreApproval  =@"api/cooperation/v2/invite/approval/ignore/{keyid}/{tokenid}";
/*------------------标签-------------------*/
static NSString * const WebApi_CloudTag = @"api/tag";
static NSString * const WebApi_CloudTagCreat = @"api/tag/paste/{tokenid}";
static NSString * const webApi_CloudTagCanel = @"api/tag/cancel/{tid}/{tokenid}";
static NSString * const webApi_CloudTagList = @"api/cooperation/tag/list/{uid}/{oid}/{type}/{tokenid}";
static NSString * const webApi_CloudTagAdd = @"api/cooperation/tag/adds/{cid}/{tokenid}";
static NSString * const webApi_CloudTagDelete = @"api/cooperation/tag/deletetags/{tokenid}";



/*----------------------------------- 协作应用 -----------------------*/
static NSString * const WebApi_CloudCooperationToolApp = @"api/Cooperation/App";
/* 获取协作已加载的应用（组织和个人） */
static NSString * const WebApi_CloudCooperationTool_GetOrgToolInfo = @"api/Cooperation/App/Ref/iOS/{type}/{orgid}/{uid}/{cid}/{tokenid}";
/* 获取个人应用 */
static NSString * const WebApi_CloudCooperationTool_GetPersonToolInfo = @"api/Cooperation/App/Ref/iOS/{type}/{uid}/{cid}/{tokenid}";

/* 获取组织和个人购买支持协作的iOS应用 */
static NSString * const WebApi_CloudCooperationTool_GetOrgAppList = @"api/Cooperation/App/iOS/{type}/{orgid}/{uid}/{tokenid}";
/*  获取个人购买支持协作的iOS应用 */
static NSString * const WebApi_CloudCooperstionTool_GetPersonAppList = @"api/Cooperation/App/iOS/{type}/{uid}/{tokenid}";

/* 添加协作区工具（组织和个人） */
//static NSString * const WebApi_CloudCooperationTool_AddCooTool = @"api/Cooperation/App/Ref/{orgid}/{uid}/{cid}/{appid}/{before}/{tokenid}";
/* 添加协作区工具（个人）*/
//static NSString * const WebApi_CloudCooperationTool_AddPersonTool = @"api/Cooperation/App/Ref/{uid}/{cid}/{appid}/{before}/{tokenid}";
/* 批量添加工具 (组织)*/
static NSString * const WebApi_CloudCooperationTool_AddCooTool = @"api/Cooperation/App/Ref/{orgid}/{uid}/{cid}/{before}/{tokenid}";
/* 批量添加工具 (个人)*/
static NSString * const WebApi_CloudCooperationTool_AddPersonTool = @"api/Cooperation/App/Ref/{uid}/{cid}/{before}/{tokenid}";
/* 删除已添加的工具 */
static NSString * const WebApi_CloudCooperationTool_DeleteTool = @"api/Cooperation/App/Ref/{cid}/{appid}/{tokenid}";
/* 设置工具顺序 */
static NSString * const WebApi_CloudCooperationTool_ToolSort = @"api/Cooperation/App/Ref/{cid}/{appid}/{before}/{tokenid}";
/* 获取协作区已经应用关系列表 */
static NSString * const WebApi_CloudCooperationTool_loadcooperationexportapp = @"api/Cooperation/App/loadcooperationexportapp/{cid}/{tokenid}";


/*********************************** 协作 文件 *************************************************/

static NSString * const WebApi_CloudCooperationDocument = @"api/Resource/Cooperation";

/*------------------------------------ 工作组 文件 —---------------------------------*/
/* 工作组文件一级列表 */
static NSString * const WebApi_CloudCooperationWorkGroup_GetResource = @"api/Resource/CooperationGroupApp/GetResource/{rpid}/{tokenid}";
/* 工作组文件下级文件列表 */
static NSString * const WebApi_CloudCooperationWorkGroup_GetNextPageRes = @"api/Resource/CooperationGroupApp/GetResource/{rpid}/{classid}/{tokenid}";
/* 工作组- 文件-新增文件夹 */
static NSString * const WebApi_CloudCooperationWorkGroup_AddFolder = @"api/Resource/CooperationGroupApp/AddFolder/{rpid}/{cooperationid}/{tokenid}";
/* 工作组 - 文件夹 - 删除 */
static NSString * const WebApi_CloudCooperationWorkGroup_DelFolderContext = @"api/Resource/CooperationGroupApp/DelFolderContext/{rpid}/{cooperationid}/{tokenid}";
/* 工作组 - 文件 - 删除 */
static NSString * const WebApi_CloudCooperationWorkGroup_DelResource  = @"api/Resource/CooperationGroupApp/DelResource/{rpid}/{cooperationid}/{tokenid}";
/* 混合删除 （批量删除）*/
static NSString * const WebApi_CloudCooperationWorkGroup_MixRemoveData = @"api/Resource/CooperationGroupApp/MixRemoveData/{rpid}/{cooperationid}/{tokenid}";
/* 工作组 - 文件夹 - 重命名 */
static NSString * const WebApi_CloudCooperationWorkGroup_EditFolderName = @"api/Resource/CooperationGroupApp/EditFolderName/{rpid}/{cooperationid}/{tokenid}";
/* 工作组 - 文件 - 重命名 */
static NSString * const WebApi_CloudCooperetionWorkGroup_EditResourceName = @"api/Resource/CooperationGroupApp/EditResourceName/{rpid}/{cooperationid}/{tokenid}";
/* 工作组 - 文件夹 - 移动 */
static NSString * const WebApi_CloudCooperationWorkGroup_Mobilefolder = @"api/Resource/CooperationGroupApp/Mobilefile/{rpid}/{cooperationid}/{folderid}/{tokenid}";
/* 工作组 - 文件 - 移动(作废) */
static NSString * const WebApi_CloudCooperationWorkGroup_Mobilefile = @"api/Resource/CooperationGroupApp/Mobilefile/{rpid}/{cooperationid}/{rid}/{folderid}/{tokenid}";
/* 工作组 - 文件夹 - 保存到云盘 */
static NSString * const WebApi_CloudCooperationWorkGroup_CopyFolderToNetDisk = @"api/Resource/CooperationGroupApp/CopyMobilefile/{folderid}/{tokenid}";
/* 工作组 - 文件 - 保存到云盘 （已废弃）*/
static NSString * const WebApi_CloudCooperationWorkGroup_CopyResourceToNetDisk = @"api/Resource/CooperationGroupApp/CopyResource/{resourceid}/{targetrpid}/{targetpartitiontype}/{targetfolderid}/{tokenid}";
/* 工作组 - 文件 - 文件上传 api/Resource/CooperationGroupApp/AddResourceForLogic/{rpid}/{cooperationid}/{tokenid}*/
static NSString * const WebApi_CloudCooperationWorkGroup_AddResourceForLogic = @"api/Resource/CooperationGroupApp/AddResourceForLogic/{rpid}/{cooperationid}/{tokenid}";
/* 工作组 - 文件- 批量发动态 */
static NSString * const WebApi_CloudCooperationWorkGroup_AddMoreResourceForLogic = @"api/Resource/CooperationGroupApp/AddResource/{rpid}/{cooperationid}/{tokenid}";
/* 文件上传成功后 获取资源信息 */
static NSString * const WebApi_CloudCooperationWorkGroup_GalleryResourceModelMainInfo = @"api/Resource/CooperationGroupApp/GalleryResourceModelMainInfo/{tokenid}";
/* 获取文件夹信息 post cid rpid partitiontype  folderid */
static NSString * const WebApi_CloudCooperationWorkGroup_GetFolderInfo = @"api/BaseCooperation/getresourceinfo/authority/{tokenid}";
/* 文件升级 */
static NSString * const WebApi_CloudCooperationWorkGroup_UpgradeResource = @"api/Resource/CooperationGroupApp/UpgradeResource/{rpid}/{cooperationid}/{tokenid}";
/* 覆盖资源 */
static NSString * const WebApi_CloudCooperationWorkGroup_ReplaceResource = @"api/Resource/CooperationGroupApp/ReplaceResource/{rpid}/{cooperationid}/{tokenid}";
/* 导入云盘文件*/
static NSString * const WebApi_CloudCooperationWorkGroup_ImportNetDiskResource = @"api/resource/cooperationgroupapp/importsource/{rpid}/{partitiontype}/{folderid}/{tokenid}";

/*----------------------------------- 协作，任务（文件） -----------------------*/
/* 根文件目录 */
static NSString * const WebApi_CloudCooperationTask_GetFile = @"api/Resource/CooperationApp/GetResource/{rpid}/{tokenid}";
/* 下级文件目录 */
static NSString * const WebApi_CloudCooperationTask_GetNextResource = @"api/Resource/CooperationApp/GetResource/{rpid}/{classid}/{tokenid}";
/* 新建文件夹  任务id 资源池id */
static NSString * const WebApi_CloudCooperationTask_AddFolder = @"api/Resource/CooperationApp/AddFolder/{rpid}/{cooperationid}/{tokenid}";
/* 资源上传 */
static NSString * const WebApi_CloudCooperationTask_UploadOneResource = @"api/Resource/CooperationApp/AddResourceForLogic/{rpid}/{cooperationid}/{tokenid}";

/* 文件夹重命名 */
static NSString * const WebApi_CloudCooperationTask_UpdateFolderName = @"api/Resource/CooperationApp/EditFolderName/{rpid}/{cooperationid}/{tokenid}";
/* 文件重命名 */
static NSString * const WebApi_CloudCooperationTask_ResourcesRename = @"api/Resource/CooperationApp/EditResourceName/{rpid}/{cooperationid}/{tokenid}";
/* 删除文件夹 */
static NSString * const WebApi_CloudCooperationTask_DelFolder = @"api/Resource/CooperationApp/DelFolderContext/{rpid}/{cooperationid}/{tokenid}";
/* 删除文件 */
static NSString * const WebApi_CloudCooperationTask_DelResources = @"api/Resource/CooperationApp/DelResource/{rpid}/{cooperationid}/{tokenid}";
/* 批量删除 */
static NSString * const WebApi_CloudCooperationTask_MixRemoveData = @"api/Resource/CooperationApp/MixRemoveData/{rpid}/{cooperationid}/{tokenid}";
/* 文件夹移动 (已作废) */
static NSString * const WebApi_CloudCooperationTask_MoveFolder = @"api/Resource/CooperationApp/Mobilefolder/{rpid}/{cooperationid}/{folderid}/{parentfolderid}/{tokenid}";
/* 文件移动 */
static NSString * const WebApi_CloudCooperationTask_MoveFile = @"api/Resource/CooperationApp/Mobilefile/{rpid}/{cooperationid}/{folderid}/{tokenid}";
/* 文件批量移动 */
static NSString * const WebApi_CloudCooperationTask_MoveMoreFiles = @"api/Resource/CooperationApp/Mobilefile/{rpid}/{cooperationid}/{folderid}/{tokenid}";
/* 获取资源信息 */
static NSString * const WebApi_CloudCooperationtask_GetResourceInfo = @"api/Resource/CooperationApp/GetResourceInfo/{tokenid}";
/* 上传新版本 */
static NSString * const WebApi_CloudCooperationTask_UpgradeResource  = @"api/Resource/CooperationApp/UpgradeResource/{rpid}/{cooperationid}/{tokenid}";
/* 版本覆盖 成功之后调用 */
static NSString * const WebApi_CloudCooperationTask_ReplaceResourcePhone = @"api/Resource/CooperationApp/ReplaceResource/{rpid}/{cooperationid}/{tokenid}";
/* 保存文件到云盘 （文件文件夹通用）*/
static NSString * const WebApi_CloudCooperationTask_CopyFolder = @"api/Resource/CooperationApp/CopyMobilefile/{folderid}/{tokenid}";
/* 保存文件到云盘 (已废弃)*/
static NSString * const WebApi_CloudCooperationTask_CopyResource = @"api/Resource/CooperationApp/CopyResource/{resourceid}/{targetrpid}/{targetpartitiontype}/{targetfolderid}/{tokenid}";

/* 获取上报文件的父任务 */
static NSString * const WebApi_CloudCooperationTask_GetlistByTids = @"api/cooperation/v2/task/getlistbytids/{tokenid}";
/* 获取某个资源池文件夹 */
static NSString * const WebApi_CloudCooperationTask_GetFolders = @"api/Resource/CooperationApp/GetFolder/{rpid}/{tokenid}";
/* 导入云盘文件 */
static NSString * const WebApi_CloudCooperationTask_ImportNetResource = @"api/resource/cooperationapp/importsource/{rpid}/{partitiontype}/{folderid}/{tokenid}";
/* 下发全部文件 */
static NSString * const WebApi_CloudCooperationTask_IssuedResourceToAll = @"api/resource/cooperationapp/issuedresourcetoall/{tid}/{id}/{isfolder}/{tokenid}";
/* 发动态 */
static NSString * const WebApi_CloudCooperationTask_ResourceToPost = @"api/resource/cooperationapp/resourcetopost/{tokenid}";

/*----------------------------------- 项目文件 -----------------------*/
static NSString * const WebApi_CloudCooperationProjectDocument = @"api/Resource/CooperationProjectApp";
/* 获取资源区内容 */
static NSString * const WebApi_CloudCooperationProject_GetResource = @"api/Resource/CooperationProjectApp/GetResource/{rpid}/{tokenid}";
/* 获取文件夹下的资源 */
static NSString * const WebApi_CloudCooperationProject_GetNextResource = @"api/Resource/CooperationProjectApp/GetResource/{rpid}/{classid}/{tokenid}";
/* 添加文件夹 */
static NSString * const WebApi_CloudCooperationProject_AddFolder = @"api/Resource/CooperationProjectApp/AddFolder/{rpid}/{cooperationid}/{tokenid}";
/* 单个删除 文件 */
static NSString * const WebApi_CloudCooperationProject_DelResource = @"api/Resource/CooperationProjectApp/DelResource/{rpid}/{cooperationid}/{tokenid}";
/* 单个删除 文件夹 */
static NSString * const WebApi_CloudCooperationProject_DelFolderContext = @"api/Resource/CooperationProjectApp/DelFolderContext/{rpid}/{cooperationid}/{tokenid}";
/* 批量删除 */
static NSString * const WebApi_CloudCooperationProject_MixRemoveData = @"api/Resource/CooperationProjectApp/MixRemoveData/{rpid}/{cooperationid}/{tokenid}";
/* 文件夹重命名 */
static NSString * const WebApi_CloudCoooperationProject_EditFolderName = @"api/Resource/CooperationProjectApp/EditFolderName/{rpid}/{cooperationid}/{tokenid}";
/* 文件重命名 */
static NSString * const WebApi_CloudCooperationProject_EditResourceName = @"api/Resource/CooperationProjectApp/EditResourceName/{rpid}/{cooperationid}/{tokenid}";
/* 文件上传成功后调用 */
static NSString * const WebApi_CloudCooperationProject_AddResourceForLogic = @"api/Resource/CooperationProjectApp/AddResourceForLogic/{rpid}/{cooperationid}/{tokenid}";
/* 批量移动资源 */
static NSString * const WebApi_CloudCooperatonProject_Mobilefile = @"api/Resource/CooperationProjectApp/Mobilefile/{rpid}/{cooperationid}/{folderid}/{tokenid}";
/* 文件覆盖 */
static NSString * const WebApi_CloudCooperationProject_ReplaceResourcePhone = @"api/Resource/CooperationProjectApp/ReplaceResourcePhone/{rpid}/{cooperationid}/{tokenid}";
/* 文件升级 */
static NSString * const WebApi_CloudCooperationProject_UpgradeResourcePhone = @"api/Resource/CooperationProjectApp/UpgradeResourcePhone/{rpid}/{cooperationid}/{tokenid}";
/* 批量保存至网盘 */
static NSString * const WebApi_CloudCooperationProject_CopyMobilefile = @"api/Resource/CooperationProjectApp/CopyMobilefile/{folderid}/{tokenid}";

/*
 获取文件信息 post cid resourceid
 */
static NSString * const WebApi_CooperationBaseFile_GalleryResourceMainInfo = @"api/basecooperationfile/galleryresourcemodelmaininfo/authority/{tokenid}";
