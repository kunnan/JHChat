//
//  CooperationTaskParse.m
//  LeadingCloud
//
//  Created by wang on 16/2/22.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CooperationTaskParse.h"
#import "CoTaskDAL.h"
#import "CoMemberDAL.h"
#import "CoTaskTransferDAL.h"
#import "CoTaskPhaseDAL.h"
#import "CoTaskRelatedDAL.h"
#import "TagDataDAL.h"
#import "CooperationTaskItem.h"
#import "CooAppModel.h"
#import "AppDAL.h"
#import "CoAppDAL.h"
#import "CooOfNewTaskDAL.h"
#import "CooOfNewModel.h"
#import "ImGroupDAL.h"
#import "CoManageDAL.h"
#import "CoRoleDAL.h"
#import "CooLayoutModel.h"

#import "CoLayoutDAL.h"

//文件
#import "ResFolderModel.h"
#import "ResModel.h"
#import "ResDAL.h"
#import "ResFolderDAL.h"
#import "CooperationCommonModel.h"
#import "CoAppDAL.h"
#import "CooperationCouldRelationItem.h"

@interface CooperationTaskParse ()
{
    NSString *folderRpid;
    NSString *parentid;
}
@end

@implementation CooperationTaskParse


+(CooperationTaskParse *)shareInstance{
    static CooperationTaskParse *instance = nil;
    if (instance == nil) {
        instance = [[CooperationTaskParse alloc] init];
    }
    return instance;
}

-(void)parse:(NSMutableDictionary *)dataDic{
    
    NSString *route = [dataDic objectForKey:WebApi_Route];
    
    //创建任务
    if ([route isEqualToString:WebApi_CloudCooperationTaskCreat]) {
       
        [self parseCreatTask:dataDic];
    }
    
    //任务列表
    else if ([route isEqualToString:WebApi_CloudCooperationTaskList] || [route isEqualToString:WebApi_CloudCooperationGetAttentionlist]){
       
        [self parseTaskList:dataDic];
    }
 
    // 任务详情
    else if ([route isEqualToString:WebApi_CloudCooperationTaskInfo]) {
        
        [self parseTaskDetial:dataDic];
    }
    //任务目标
    
    else if ([route isEqualToString:WebApi_CloudCooperationTaskGoal]){
        
        [self parseTaskGoal:dataDic];

    }
    //任务基本信息刷新
    else if ([route isEqualToString:WebApi_CloudCooperationTaskNewInfo]){
        [self parseTaskNewbaseInfo:dataDic];

    }
    //任务基本信息
    else if ([route isEqualToString:WebApi_CloudCooperationLoadtaskbasicinfo]){
        
        [self parseTaskbaseInfo:dataDic];
    }
    //子任务列表
    else if ([route isEqualToString:WebApi_CloudCooperationChildTaskList]){
        
        [self parseTaskChildList:dataDic];
    }
    //设置计划时间
    else if ([route isEqualToString:WebApi_CloudCooperationTaskPlanDate]){
        
        [self parseTaskSetPlanDate:dataDic];
       
    }
    //设置任务名称
    
    else if ([route isEqualToString:WebApi_CloudCooperationTaskName]){
        
        [self parseTaskSetName:dataDic];
    }

    
    // 任务描述
    else if ([route isEqualToString:WebApi_CloudCooperationTaskEditDescribe]){
        [self parseTaskSetDes:dataDic];
    }
       
    //可选择关联的母任务
    else if ([route isEqualToString:WebApi_CloudCooperationTaskLoadRelateTaskList]){
        
        [self parseLoadRelateTask:dataDic];
    }
    //设置管理母任务
    else if ([route isEqualToString:WebApi_CloudCooperationTaskModifyRelateTask]){
        
        [self setRelationParent:dataDic];
    }
    //创建任务节点
    else if ([route isEqualToString:WebApi_CloudCooperationTaskCreatPhase]){
        [self parseAddPhase:dataDic];
    }
    /*设置环节描述*/
    else if ([route isEqualToString:WebApi_CloudCooperationTaskSavePhaseDes]){
        
        [self parseSetPhaseDes:dataDic];
    }
    /*设置环节提示*/
    else if ([route isEqualToString:WebApi_CloudCooperationTaskSavePhaseTip]){
        [self parseSetPhaseTip:dataDic];
    }
    /*设置环节时限*/
    else if ([route isEqualToString:WebApi_CloudCooperationTaskSavePhaseDateLimit]){
        [self parseSetPhaseDateLimit:dataDic];
    }

    //激活任务节点
    else if ([route isEqualToString:WebApi_CloudCooperationTaskActivePhase]){
        [self parseActivePhase:dataDic];
    }
    //未开始任务节点
    else if ([route isEqualToString:WebApi_CloudCooperationTaskUnstartPhase]){
        [self parseUnstartPhase:dataDic];

    }
    //完成任务节点
    else if ([route isEqualToString:WebApi_CloudCooperationTaskFinishPhase]){
        [self parseFinishPhase:dataDic];
    }
    //删除任务节点
    else if ([route isEqualToString:WebApi_CloudCooperationTaskDeletePhase]){
        
        [self parseDelePhase:dataDic];
    }
    //修改任务节点负责人
    else if ([route isEqualToString:WebApi_CloudCooperationTaskSetAdmin]){
        [self parseAdminPhase:dataDic];
    }
    //添加任务关联工作组
    else if ([route isEqualToString:WebApi_CloudCooperationTaskAddRelatedGroup]){
        [self addRelatedGroup:dataDic];
    }
    //删除任务关联工作组
    else if ([route isEqualToString:WebApi_CloudCooperationTaskDeleteRelatedGroup]){
        [self deleRelatedGroup:dataDic];
    }
    //添加任务关联项目
    else if ([route isEqualToString:WebApi_CloudCooperationTaskAddRelatedProject]){
        [self addRelatedProject:dataDic];
    }
    //删除任务关联项目
    else if ([route isEqualToString:WebApi_CloudCooperationTaskDeleteRelatedProject]){
        [self deleRelatedProject:dataDic];
    }

    
    //托付任务
    else if ([route isEqualToString:WebApi_CloudCooperationTaskSetTaskAdmin]){
        [self setTaskAdmins:dataDic];
    }
	
	//设置任务管理员
	else if ([route isEqualToString:WebApi_CloudCooperationMemberSetAdmin]){
		
		[self setTaskMemberAdmins:dataDic];
	}
	//删除任务管理员
	else if ([route isEqualToString:WebApi_CloudCooperationMemberCannelAdmin]){
		[self cannelTaskMemberAdmins:dataDic];

	}
	
    //锁定任务
    else if ([route isEqualToString:WebApi_CloudCooperationTaskLocktask]){
        [self lockTask:dataDic];
    }
    //解锁任务
    else if ([route isEqualToString:WebApi_CloudCooperationTaskUnLocktask]){
        [self unlockTask:dataDic];
    }
    //删除任务
    else if ([route isEqualToString:WebApi_CloudCooperationTaskDeltask]){
        [self delTask:dataDic];
    }
    //发布任务
    else if ([route isEqualToString:WebApi_CloudCooperationTaskPublishtask]){
        [self publishTask:dataDic];
    }
    //暂停任务
    else if ([route isEqualToString:WebApi_CloudCooperationTaskPausetask]){
        [self pauseTask:dataDic];
    }
    //恢复任务
    else if ([route isEqualToString:WebApi_CloudCooperationTaskRecovertask]){
        [self recoverTask:dataDic];
    }
    //废弃任务
    else if ([route isEqualToString:WebApi_CloudCooperationTaskAbandontask]){
        [self abandonTask:dataDic];
    }
    //完成任务
    else if ([route isEqualToString:WebApi_CloudCooperationTaskCompletetask]){
        [self completeTask:dataDic];
    }
    //任务可关联工作组列表
    else if ([route isEqualToString:WebApi_CloudCooperationTaskRefGroupUnSelectedList]){
        
        [self refGroupUnSelectedList:dataDic];
        
    }
    //任务全部关联工作组列表
    else if ([route isEqualToString:WebApi_CloudCooperationTaskRefGroupAllList]){
        
        [self refGroupAllList:dataDic];
    }
    //任务全部关联项目列表
    else if ([route isEqualToString:WebApi_CloudCooperationTaskRefProjectAllList]){
        [self refProjectAllList:dataDic];

    }
    //任务可关联项目列表
    else if ([route isEqualToString:WebApi_CloudCooperationTaskRefProjectUnSelectedList]){
        [self refProjectUnSelectedList:dataDic];
        
    }

    // 获取协作协作已加载的iOS应用（个人）
    else if ([route isEqualToString:WebApi_CloudCooperationTool_GetOrgToolInfo]) {
        [self parseOrganizationTool:dataDic];
    }
    //获取协作协作已加载的iOS应用（个人）
    else if ([route isEqualToString:WebApi_CloudCooperationTool_GetPersonToolInfo]) {
        
        [self parseOrganizationTool:dataDic];
    }
    
    // 获取组织和个人购买支持协作的iOS应用
    else if ([route isEqualToString:WebApi_CloudCooperationTool_GetOrgAppList]) {
        [self parseOrganizationAppList:dataDic];
    }
    // 获取个人购买支持协作的iOS应用
    else if ([route isEqualToString:WebApi_CloudCooperstionTool_GetPersonAppList]) {
        [self parseOrganizationAppList:dataDic];
    }
    /* 添加协作区工具（组织和个人） */
    else if ([route isEqualToString:WebApi_CloudCooperationTool_AddCooTool]) {
        [self parseOrganizationAddTool:dataDic];
        
    }
    /* 添加协作区工具（个人）*/
    else if ([route isEqualToString:WebApi_CloudCooperationTool_AddPersonTool]) {
        [self parseOrganizationAddTool:dataDic];
        
    }
    // 移除协作区工具
    else if ( [route isEqualToString:WebApi_CloudCooperationTool_DeleteTool]) {
        
        [self parseDeleteTool:dataDic];
    }
    // 工具排序
    else if ([route isEqualToString:WebApi_CloudCooperationTool_ToolSort]) {
        [self parseToolSort:dataDic];
    }
    // 新的协作 协作区内所有邀请我的成员列表
    else if ([route isEqualToString:WebApi_CloudCooperationNew_hasinvited]) {
        [self parseHasInvited:dataDic];
    }
    // 新的协作 同意邀请
    else if ([route isEqualToString:WebApi_CloudCooperationNew_AgreeInvite]) {
        [self parseReciveInvite:dataDic];
    }
    // 新的协作拒绝邀请
    else if ([route isEqualToString:Webapi_CloudCooperationNew_DisagreeInvite]) {
        [self parseReciveInvite:dataDic];
    }
	//添加任务 搜索
	else if ([route isEqualToString:WebApi_CloudCooperationJoinTask]){
		/* 在主线程中发送通知 */
		dispatch_async(dispatch_get_main_queue(), ^{
			__block CooperationTaskParse * service = self;
			NSDictionary *data  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
			EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParse_Join, data);
		});
	}
	else if ([route isEqualToString:WebApi_CloudCooperationJoinTaskFormGid]){
		/* 在主线程中发送通知 */
		dispatch_async(dispatch_get_main_queue(), ^{
			__block CooperationTaskParse * service = self;
			NSDictionary *data  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
			EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParse_Join_Tid, data);
		});
	}
	else if ([route isEqualToString:WebApi_CloudCooperationTaskSetApplyroot]){
		//设置申请加入权限
		
		NSDictionary *getParam=[dataDic objectForKey:WebApi_DataSend_Get];
		NSString *tid=[getParam objectForKey:@"tid"];
		NSString *needing=[dataDic objectForKey:WebApi_DataSend_Post];
		
		[[CoTaskDAL shareInstance]updateTaskId:tid withTaskApplyroot:[NSNumber numberWithInt:[needing intValue]]];
		/* 在主线程中发送通知 */
		dispatch_async(dispatch_get_main_queue(), ^{
			__block CooperationTaskParse * service = self;
			EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParse_Set_ApplyRoot, tid);
		});
	}
}


/**
 *  消息发送成功后，服务器端返回的数据
 */

//创建任务
-(void)parseCreatTask:(NSMutableDictionary*)dataDic{
    // 任务id
    NSString *contextDict  = [dataDic lzNSStringForKey:WebApi_DataContext];
    NSDictionary *param =[dataDic objectForKey:WebApi_DataSend_Post];
    //存储任务基本信息
    CoTaskModel *listObject=[[CoTaskModel alloc]init];
	
    listObject.cid=contextDict;
    listObject.tid=contextDict;
    listObject.name=[param objectForKey:@"name"];
    listObject.oid =[param objectForKey:@"oid"];
    listObject.pid =[param objectForKey:@"pid"];
    listObject.logo=[[LZUserDataManager readCurrentUserInfo] objectForKey:@"face"];
    listObject.state=1;
    listObject.plandate= [LZFormat String2SystemDate:[NSString stringWithFormat:@"%@T00:00:00",[param objectForKey:@"plandate"]]];
    listObject.adminid =[[LZUserDataManager readCurrentUserInfo]objectForKey:@"uid"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationTaskParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParse_Creat, listObject);
    });
}

//任务列表
-(void)parseTaskList:(NSMutableDictionary*)dataDic{
    
    NSDictionary *postDict = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    
    NSMutableArray *taskListArr=[NSMutableArray array];
    NSMutableArray *taskIDArr=[NSMutableArray array];
    NSMutableArray *contextArr  = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    for (NSDictionary *dict in contextArr) {
        CoTaskModel *listObject=[[CoTaskModel alloc]init];
        [listObject serializationWithDictionary:dict];
        [taskListArr addObject:listObject];
        [taskIDArr addObject:listObject.tid];
       }
    

    [[CoTaskDAL shareInstance]addDataWithArray:taskListArr];
    
    NSString *orign=[postDict objectForKey:@"lastkey"];
    
    NSMutableDictionary *taskDict=[NSMutableDictionary dictionary];
    taskDict[@"data"]=taskListArr;
    taskDict[@"lastkey"]=orign;
    taskDict[@"search"]=[postDict lzNSStringForKey:@"fvalue"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        //任务列表
        __block CooperationTaskParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParse_List, taskDict);
    });

}

//子任务
-(void)parseTaskChildList:(NSDictionary*)dataDic{
    
    NSMutableArray *taskListArr=[NSMutableArray array];
    NSMutableArray *contextArr  = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    
    NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
    NSString *tid=[param objectForKey:@"ptid"];
    [[CoTaskDAL shareInstance]deleteAllChildTaskTid:tid];
    
    for (NSDictionary *dict in contextArr) {
        CoTaskModel *listObject=[[CoTaskModel alloc]init];
        [listObject serializationWithDictionary:dict];
        listObject.cid=listObject.tid;
        
        [taskListArr addObject:listObject];
    }
    [[CoTaskDAL shareInstance]addDataWithArray:taskListArr];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
         //任务列表
        __block CooperationTaskParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParse_Child_List, taskListArr);
    });
}
#pragma mark 任务详情
-(void)parseTaskDetial:(NSMutableDictionary*)dataDic{
    
    CooperationTaskItem *item=[[CooperationTaskItem alloc]init];
    
    NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
    NSString *tid=[param objectForKey:@"tid"];
    
    NSDictionary *contextDict  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    
    //任务基本信息
    CoTaskModel *tModel = [[CoTaskModel alloc]init];
    [tModel serializationWithDictionary:contextDict];
    //cid 没有返回值
    tModel.cid =tModel.tid;
	
	NSDictionary *admins=[contextDict objectForKey:@"admins"];
	CoMemberModel *aModel=[[CoMemberModel alloc]init];
	[aModel serializationWithDictionary:admins];
	aModel.cid=tid;
	
	tModel.logo = aModel.face;
	
    [[CoTaskDAL shareInstance]addTaskModel:tModel];
    
    item.taskID=tid;
    item.taskName=tModel.name;
    item.taskDesciption=tModel.des;
    item.rootid=tModel.rootid;
    item.rootname=tModel.rootname;
	item.tasknumber = tModel.tcode;
	item.logo = tModel.logo;
	item.isneeding = tModel.needauditing;

	
    if(tModel.pid && tModel.rootid && [tModel.pid isEqualToString:tModel.rootid]){
        
    }else{
        item.parentID=tModel.pid;
        item.parentName=tModel.pname;
    }
    item.isFavorites=tModel.isfavorites;
    item.state=tModel.state;
    //文件资源id
    item.taskFilerpid=tModel.resourceid;
    //计划时间
    if (tModel.plandate) {
        item.stopDate=[LZFormat Date2String:tModel.plandate format:@"yyyy-MM-dd"];
    }
    //任务锁定
    if (tModel.lockuser&&![tModel.lockuser isEqualToString:@"0"]) {
        item.isLock=YES;
    }
    item.lockUser=tModel.lockuser;

    item.igid=[[ImGroupDAL shareInstance]getImGroupWithIgidFromWorkGroup:tModel.tid];
    
    if (!item.igid) {
        
        [[CooperationCommonModel shareInstance]getIgModelRelated:item.taskID];
    }
    item.memberslength=tModel.memberslength;
    //删除所有成员
    [[CoMemberDAL shareInstance]deleteUnMyCooperationId:tid];
    
    //管理员

    [[CoMemberDAL shareInstance]addModel:aModel];
    item.chargeModel=aModel;
    

    //成员
    NSArray *members=[contextDict objectForKey:@"members"];
    NSMutableArray *memberArr=[NSMutableArray array];
    for (NSDictionary *mDict in members) {
        CoMemberModel *mModel=[[CoMemberModel alloc]init];
        [mModel serializationWithDictionary:mDict];
        
        mModel.cid=tid;
        [memberArr addObject:mModel];
    }
    [[CoMemberDAL shareInstance]addDataWithArray:memberArr];
    item.memberArray=memberArr;
    
    //当前自己
    NSDictionary *currmember=[contextDict objectForKey:@"currmember"];
    CoMemberModel *currmemberModel=[[CoMemberModel alloc]init];
    [currmemberModel serializationWithDictionary:currmember];
    currmemberModel.cid=tid;
    [[CoMemberDAL shareInstance]addModel:currmemberModel];
	
	if (currmemberModel.utype==1 || currmemberModel.utype==4) {
		
		item.isCharge=YES;

	}
	
	item.identity = currmemberModel.utype;
	
	if (!currmemberModel.mid) {
		item.identity = 3;
		
	}
	
    // 角色
    NSArray *currrolekey = [contextDict objectForKey:@"currrolekey"];
    item.curRolekeyArr = currrolekey;
    [[CoRoleDAL shareInstance]deleteCoRoleCid:item.taskID];
    [[CoRoleDAL shareInstance]addDataWithArray:currrolekey Cid:item.taskID];
    //节点
    NSMutableArray *phases=[contextDict objectForKey:@"phases"];
    [[CoTaskPhaseDAL shareInstance]deleteAllPhaseTaskId:tid];
    NSMutableArray *phaseArr=[NSMutableArray array];
    for (NSDictionary *pDict in phases) {
        CoTaskPhaseModel *pModel=[[CoTaskPhaseModel alloc]init];
        [pModel serializationWithDictionary:pDict];
        if (pModel.chief &&[pModel.chief length]>1) {
            
            NSDictionary *mDict=[pDict objectForKey:@"cheifmem"];
            
            CoMemberModel *mModel=[[CoMemberModel alloc]init];
            [mModel serializationWithDictionary:mDict];
            
            pModel.face=mModel.face;
            
          //  [[CoMemberDAL shareInstance]addModel:mModel];
            
        }
        [phaseArr addObject:pModel];
        
    }
    [[CoTaskPhaseDAL shareInstance]addDataWithArray:phaseArr];
    
    NSMutableArray *checkArr=[NSMutableArray array];
    for (CoTaskPhaseModel *pModel in phaseArr) {
        CooperationTaskCheckItem *cItem=[[CooperationTaskCheckItem alloc]init];
        cItem=[cItem getModelForm:pModel];
        [checkArr addObject:cItem];
        
    }
    item.checkArray=checkArr;
    //关联工作组
    
    NSArray *gArray=[contextDict objectForKey:@"relatedgroup"];
    NSMutableArray *groupArr=[NSMutableArray array];
    
    [[CoTaskRelatedDAL shareInstance]deleteAllTaskId:tid];
    for (NSDictionary *gDict in gArray) {
        
        CoTaskRelatedModel *rModel=[[CoTaskRelatedModel alloc]init];
        [rModel serializationWithDictionary:gDict];
        rModel.keyId=[LZUtils CreateGUID];
        rModel.tid=tid;
        rModel.coopType=1;
        [groupArr addObject:rModel];
    }
    [[CoTaskRelatedDAL shareInstance]addDataWithArray:groupArr];
    item.workGroupArray=groupArr;
    
    //关联项目 
    NSArray *pArray=[contextDict objectForKey:@"relatedproject"];
    NSMutableArray *projectArr=[NSMutableArray array];
    
    for (NSDictionary *pDict in pArray) {
        
        CoTaskRelatedModel *rModel=[[CoTaskRelatedModel alloc]init];
        [rModel serializationWithDictionary:pDict];
        rModel.keyId=[LZUtils CreateGUID];
        rModel.tid=tid;
        rModel.coopType=2;
        [projectArr addObject:rModel];
    }
    [[CoTaskRelatedDAL shareInstance]addDataWithArray:projectArr];
    item.projectArray=projectArr;

    
    //关联标签
    NSArray *tArray=[contextDict objectForKey:@"relatedtag"];
    NSMutableArray *tagsArr=[NSMutableArray array];
    [[TagDataDAL shareInstance]deleteCooperationCid:tid];
    for (NSDictionary *tDict in tArray) {
        TagDataModel *tModel=[[TagDataModel alloc]init];
        [tModel serializationWithDictionary:tDict];
        [tagsArr addObject:tModel];
    }
    [[TagDataDAL shareInstance] addDataWithTagDataArray:tagsArr];

    item.labelsArray = tagsArr;
	
	NSArray *cooperationtags=[contextDict objectForKey:@"cooperationTags"];
	NSMutableArray *tags=[NSMutableArray array];
	for (NSDictionary *tDict in cooperationtags) {
		TagDataModel *tModel=[[TagDataModel alloc]init];
		[tModel serializationWithDictionary:tDict];
		[tags addObject:tModel];
	}
	item.tagArray = tags;
	
    //webapp
    
    // 控制基本信息的显隐性
    NSMutableDictionary *layoutSetting = [contextDict objectForKey:@"layoutsetting"];
     NSMutableArray *appArray = [[NSMutableArray alloc] init];
    // 已添加的工具
    NSDictionary *appTool = [contextDict objectForKey:@"iosapp"];
    //    排序的refs
    NSArray *sortArr  = [appTool lzNSArrayForKey:@"refs"];
    for (int i = 0; i < sortArr.count; i++) {
        
        NSDictionary *appSortDic = [sortArr objectAtIndex:i];
        NSString *appid = [appSortDic lzNSStringForKey:@"appid"];
        NSString *purchase = [appSortDic lzNSStringForKey:@"purchase"];
        
        // 获取app
        NSDictionary *apps = [appTool lzNSDictonaryForKey:@"apps"];
        NSDictionary *appDic = [apps lzNSDictonaryForKey:appid];
        CooAppModel *appModel = [[CooAppModel alloc] init];
        appModel.purchase = [purchase integerValue];
        [appModel serializationWithDictionary:appDic];
        
        appModel.cid = tid;
        appModel.name =[appSortDic lzNSStringForKey:@"name"];
        // 排序用
        appModel.index = i;
        // 数据库主键
        appModel.cooAppid = [NSString stringWithFormat:@"%@%@",appModel.cid,appModel.appid];
//        NSMutableArray *appsArr = [[NSMutableArray alloc] init];
//        // 通过解析拿到的cid取出数据，如果没有取到的话就插入否则就不插入
//        appsArr = [[CoAppDAL shareInstance] getUserAllApp:tid];
//        for (int i = 0; i < [appsArr count]; i++) {
//            // 获取数据库中原来的数据 如果存在的话就 删除 然后在插入 保持数据同步
//            [[CoAppDAL shareInstance] deleteAppDataWithCid:tid];
//        }
        
        NSArray *appRolesArr = [ appSortDic lzNSArrayForKey:@"roles"];
   
        if (appRolesArr && [appRolesArr count]!=0 ) {
            
            for (NSString *roleID  in appRolesArr) {
                
                for (NSString *curRole in currrolekey) {
                    
                    if ([roleID isEqualToString:curRole]) {
                        appModel.isShowApp = 1;

                    }
                }
            }
            
        }else{
            
            appModel.isShowApp=1;
            
        }
        
        [appArray addObject:appModel];
   
      }
   
      // 插入到数据库
    [[CoAppDAL shareInstance] addCooDataWithAppArray:appArray];

    // 基本信息/动态的显隐
    CooLayoutModel *layoutModel = [[CooLayoutModel alloc] init];
    // json
    layoutModel.layout = layoutSetting;
    layoutModel.cid = tid;
    // 插入到数据库
    [[CoLayoutDAL shareInstance] addLayoutInfo:layoutModel];
    
    item.layoutModel = layoutModel;
    
    
    NSMutableArray *showArr = [NSMutableArray array];
    for (CooAppModel *appModel in appArray) {
        if (appModel.isShowApp==1) {
            [showArr addObject:appModel];
        }
    }
    item.toolArray = showArr;
    
    NSMutableDictionary *appAndLayoutDic = [[NSMutableDictionary alloc] init];
    [appAndLayoutDic setObject:showArr forKey:@"appArray"];
    [appAndLayoutDic setObject:layoutModel forKey:@"layoutModel"];

    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:item,@"data",contextDict,@"json",tid ,@"tid", nil];
        __block CooperationTaskParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParse_Detial, sendDic);
        __block CooperationTaskParse * service2 = self;
        //工具EventBus_Coo_TaskTool_ToolList
        EVENT_PUBLISH_WITHDATA(service2, EventBus_Coo_TaskTool_ToolList, appAndLayoutDic);
        //基本信息、动态的显隐
    //    EVENT_PUBLISH_WITHDATA(service2, EventBus_Coo_TaskParse_InfoIsHiden, layoutModel);
    });

}

- (void)parseTaskGoal:(NSDictionary *)dataDic{
    NSDictionary *contextDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSDictionary *getDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
    NSString *tid =[getDic lzNSStringForKey:@"tid"];
    NSString *des = [contextDic lzNSStringForKey:@"des"];
    
    NSArray *phases = [contextDic lzNSArrayForKey:@"phases"];
    [[CoTaskPhaseDAL shareInstance]deleteAllPhaseTaskId:tid];
    NSMutableArray *phaseArr=[NSMutableArray array];
    for (NSDictionary *pDict in phases) {
        CoTaskPhaseModel *pModel=[[CoTaskPhaseModel alloc]init];
        [pModel serializationWithDictionary:pDict];
        if (pModel.chief &&[pModel.chief length]>1) {
            
            NSDictionary *mDict=[pDict objectForKey:@"cheifmem"];
            CoMemberModel *mModel=[[CoMemberModel alloc]init];
            [mModel serializationWithDictionary:mDict];
            pModel.face=mModel.face;
        }
        [phaseArr addObject:pModel];
        
    }
    
    [[CoTaskPhaseDAL shareInstance]addDataWithArray:phaseArr];
    NSMutableArray *checkArr=[NSMutableArray array];
    for (CoTaskPhaseModel *pModel in phaseArr) {
        CooperationTaskCheckItem *cItem=[[CooperationTaskCheckItem alloc]init];
        cItem=[cItem getModelForm:pModel];
        [checkArr addObject:cItem];
        
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:des,@"des",tid,@"tid",checkArr,@"phaseArr", nil];
        __block CooperationTaskParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParse_Goal, sendDic);
    });

    
}
#pragma mark 设置任务时间
-(void)parseTaskSetPlanDate:(NSMutableDictionary*)dataDic{
    
    NSDictionary *getParam=[dataDic objectForKey:WebApi_DataSend_Get];
    NSString *tid=[getParam objectForKey:@"tid"];
    NSString *planDate=[NSString stringWithFormat:@"%@T00:00:00",[dataDic objectForKey:WebApi_DataSend_Post]];
    NSDate *planDate1 =[LZFormat String2Date:planDate];
    
    [[CoTaskDAL shareInstance]updateTaskPlanDateTid:tid withDate:planDate1];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:tid,@"cid",@"time",@"info",planDate,@"data", nil];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationTaskParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParse_SetInfo, dict);
    });
}

#pragma mark 设置任务名称
-(void)parseTaskSetName:(NSMutableDictionary*)dataDic{
    
    NSDictionary *getParam=[dataDic objectForKey:WebApi_DataSend_Get];
    NSString *tid=[getParam objectForKey:@"tid"];
    NSString *name=[dataDic objectForKey:WebApi_DataSend_Post];
    
    [[CoTaskDAL shareInstance]updateTaskNameTid:tid withName:name];
    
    NSDictionary *sendDict = [NSDictionary dictionaryWithObjectsAndKeys:tid,@"tid",name,@"name", nil];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationTaskParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParse_SetName, sendDict);
    });
}
#pragma mark 设置任务描述

-(void)parseTaskSetDes:(NSMutableDictionary*)dataDic{
    
    NSDictionary *getParam=[dataDic objectForKey:WebApi_DataSend_Get];
    NSString *tid=[getParam objectForKey:@"tid"];
    NSString *des=[dataDic objectForKey:WebApi_DataSend_Post];

    [[CoTaskDAL shareInstance]updataTaskDescribeTid:tid Des:des];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationTaskParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParse_SetInfo, nil);
    });
}
- (void)parseTaskNewbaseInfo:(NSDictionary*)dataDic{
    
    CooperationTaskItem *item=[[CooperationTaskItem alloc]init];
    
    NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
    NSString *tid=[param objectForKey:@"tid"];
    
    NSDictionary *contextDict  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    
    //任务基本信息
    CoTaskModel *tModel = [[CoTaskModel alloc]init];
    [tModel serializationWithDictionary:contextDict];
    //cid 没有返回值
    tModel.cid =tModel.tid;
    item.taskID=tid;
    item.taskName=tModel.name;
    item.taskDesciption=tModel.des;
    item.parentID=tModel.pid;
    item.isFavorites=tModel.isfavorites;
    item.state=tModel.state;
    //文件资源id
    item.taskFilerpid=tModel.resourceid;
    //计划时间
    if (tModel.plandate) {
        item.stopDate=[LZFormat Date2String:tModel.plandate format:@"yyyy-MM-dd"];
    }
    //任务锁定
    if (tModel.lockuser&&![tModel.lockuser isEqualToString:@"0"]) {
        item.isLock=YES;
    }
    item.lockUser=tModel.lockuser;
    
    item.igid=[[ImGroupDAL shareInstance]getImGroupWithIgidFromWorkGroup:tModel.tid];
    
    if (!item.igid) {
        
        [[CooperationCommonModel shareInstance]getIgModelRelated:item.taskID];
    }
    item.memberslength=tModel.memberslength;
    //管理员
    NSDictionary *admins=[contextDict objectForKey:@"admins"];
    CoMemberModel *aModel=[[CoMemberModel alloc]init];
    [aModel serializationWithDictionary:admins];
    aModel.cid=tid;
    item.chargeModel=aModel;
    
    NSString*uid=[[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
    if (uid &&[uid isEqualToString:aModel.uid]) {
        item.isCharge=YES;
    }
    //成员
    NSArray *members=[contextDict objectForKey:@"members"];
    NSMutableArray *memberArr=[NSMutableArray array];
    for (NSDictionary *mDict in members) {
        CoMemberModel *mModel=[[CoMemberModel alloc]init];
        [mModel serializationWithDictionary:mDict];
        
        mModel.cid=tid;
        [memberArr addObject:mModel];
    }
    item.memberArray=memberArr;
    
    //关联标签
    NSArray *tArray=[contextDict objectForKey:@"relatedtag"];
    NSMutableArray *tagsArr=[NSMutableArray array];
    [[TagDataDAL shareInstance]deleteCooperationCid:tid];
    for (NSDictionary *tDict in tArray) {
        TagDataModel *tModel=[[TagDataModel alloc]init];
        [tModel serializationWithDictionary:tDict];
        [tagsArr addObject:tModel];
    }
    [[TagDataDAL shareInstance] addDataWithTagDataArray:tagsArr];
    
    item.labelsArray = tagsArr;
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationTaskParse * service = self;
        NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:item,@"data",tid ,@"tid", nil];

        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParse_BaseNewInfo, sendDic);
    });

}

-(void)parseTaskbaseInfo:(NSMutableDictionary*)dataDic{
    
    //存储任务基本信息
    NSDictionary *taskinfo=[dataDic lzNSDictonaryForKey:WebApi_DataContext];
    CoTaskModel *listObject=[[CoTaskModel alloc]init];
    [listObject serializationWithDictionary:taskinfo];
    [[CoTaskDAL shareInstance]addTaskModel:listObject];
    listObject.face=[[LZUserDataManager readCurrentUserInfo] objectForKey:@"face"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationTaskParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParse_Info, listObject);
    });
}

// 获取已添加的工具
-(void)parseOrganizationTool:(NSMutableDictionary*)dataDic {
    
    NSMutableDictionary *contextDic = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableDictionary *dataGet = [dataDic objectForKey:WebApi_DataSend_Get];
    // 协作区类型
    NSString *type = [dataGet objectForKey:@"type"];
    NSString *cid = [dataGet objectForKey:@"cid"];
    NSMutableDictionary *appsDic = [contextDic objectForKey:@"apps"];
    NSMutableArray *appArray = [[NSMutableArray alloc] init];
    NSArray *refsArray = [contextDic objectForKey:@"refs"];
    for (int i = 0; i < [refsArray count]; i++) {
        NSDictionary *dic = [refsArray objectAtIndex:i];
        NSString *appid = [dic objectForKey:@"appid"];
        NSString *purchase = [dic objectForKey:@"purchase"];
        // 获取app
        NSDictionary *appDic = [appsDic objectForKey:appid];
        CooAppModel *appModel = [[CooAppModel alloc] init];
        [appModel serializationWithDictionary:appDic];
       
        
        appModel.purchase = [purchase integerValue];
        appModel.type = type;
        // 排序用
        appModel.index = i;
        
        // 数据库主键
        appModel.cooAppid = [LZUtils CreateGUID];
       
        appModel.cid = cid;
//        NSMutableArray *apps = [[NSMutableArray alloc] init];
//        // 通过解析拿到的cid取出数据，如果没有取到的话就插入否则就不插入
////        apps = [[CoAppDAL shareInstance] getUserAllApp:cid];
////        for (int i = 0; i < [apps count]; i++) {
////            // 获取数据库中原来的数据 如果存在的话就 删除 然后在插入
////            [[CoAppDAL shareInstance] deleteAppDataWithCid:cid];
////        }

        [appArray addObject:appModel];
    }
    [[CoAppDAL shareInstance] deleteAppDataWithCid:cid];

    // 插入到数据库
    [[CoAppDAL shareInstance] addCooDataWithAppArray:appArray];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationTaskParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskTool_ToolList, appArray);
    });
}

// 获取组织和个人购买支持协作的iOS应用 （不用添加到数据库了）
-(void)parseOrganizationAppList:(NSMutableDictionary* )dataDic {
    
    
    NSMutableDictionary *contextDic = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableDictionary *dataGet = [dataDic objectForKey:WebApi_DataSend_Get];
    NSMutableArray *allAppModelArray = [[NSMutableArray alloc] init];
    
    for (NSString *appkey in contextDic.allKeys) {
        CooAppModel *appModle = [[CooAppModel alloc] init];
        NSDictionary *appDic = [contextDic objectForKey:appkey];
        
        [appModle serializationWithDictionary:appDic];
        appModle.type = [dataGet objectForKey:@"type"];
        appModle.cid = [dataGet objectForKey:@"cid"];
        // 数据库主键
        appModle.cooAppid = [NSString stringWithFormat:@"%@%@",appModle.cid,appModle.appid];
        
        [allAppModelArray addObject:appModle];
    }
    
    // 插入到数据库
//    [[CoAppDAL shareInstance] addCooDataWithAppArray:allAppModelArray];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationTaskParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskTool_AppTool, allAppModelArray);
    });
    
}
// 组织添加应用工具
-(void)parseOrganizationAddTool:(NSMutableDictionary *)dataDic {
    NSMutableDictionary *contextDic = [dataDic objectForKey:WebApi_DataSend_Get];
     NSMutableArray *array = [[NSMutableArray alloc] init];
    CooAppModel *app = [[CooAppModel alloc] init];
    [app serializationWithDictionary:contextDic];
    // 数据库主键
    app.cooAppid = [LZUtils CreateGUID];
   
    [array addObject:app];
    [[CoAppDAL shareInstance] addCooDataWithAppArray:array];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationTaskParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_CooTool_AddAppTool, app);
    });
}

// 删除协作区工具
-(void)parseDeleteTool:(NSMutableDictionary *)dataDic {
    NSMutableDictionary *dataGet = [dataDic objectForKey:WebApi_DataSend_Get];
    NSMutableDictionary *appDic = [[NSMutableDictionary alloc] init];
    [appDic setObject:[dataGet objectForKey:@"cid"] forKey:@"cid"];
    [appDic setObject:[dataGet objectForKey:@"appid"] forKey:@"appid"];
    // 通过cid和appid把本地删除
    [[CoAppDAL shareInstance] deleteAppDataWithCid:[dataGet objectForKey:@"cid"] appid:[dataGet objectForKey:@"appid"]];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationTaskParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EvenTBus_Coo_CooTool_DeleteTool, appDic);
    });

}
// 工具排序
- (void)parseToolSort:(NSMutableDictionary*)dataDic {
    
    
    
}
// 新的协作 协作区内所有邀请我的成员列表
-(void)parseHasInvited:(NSMutableDictionary*)dataDic {
    
    NSMutableDictionary *newCooDic = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSArray *inviteListArr = [newCooDic objectForKey:@"invitelist"];
    NSMutableArray *newCooModelArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [inviteListArr count]; i++) {
        NSDictionary *newCooDic = [inviteListArr objectAtIndex:i];
        CooOfNewModel *newCooModel = [[CooOfNewModel alloc] init];
        [newCooModel serializationWithDictionary:newCooDic];
        newCooModel.state = 2;  //未处理状态
        [newCooModelArray addObject:newCooModel];
    }
    // 先删除本地数据 在从新插入最新的到数据库
    [[CooOfNewTaskDAL shareInstance] deleteCooOfNewDataWithState:@"2"];
    // 存本地
    [[CooOfNewTaskDAL shareInstance] addNewCooDataWithArray:newCooModelArray];
//     [[CooOfNewTaskDAL shareInstance] updataNewCooWithKeyId:newCooModle.keyid state:0];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationTaskParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_NewCooperation_newCooList, newCooModelArray);
    });
}
// 新的协作 同意邀请
-(void)parseReciveInvite:(NSMutableDictionary*)dataDic {
    
    NSNumber *data = [dataDic lzNSNumberForKey:WebApi_DataContext];
    
    NSInteger isSuccess = [data integerValue];
    
    NSMutableDictionary *agreeDic = [[NSMutableDictionary alloc] init];
    
  
    if (isSuccess) {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationTaskParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_NewCooperation_AgreeInvite, agreeDic);
        });
    }
}
- (void)parseLoadRelateTask:(NSMutableDictionary*)dataDic{
    
    NSMutableArray *contextArr  = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    
    NSMutableArray *relationArr=[NSMutableArray array];
    
    for (NSDictionary *dict in contextArr) {
        
        CooperationCouldRelationItem *rItem=[[CooperationCouldRelationItem alloc]init];
        
        [rItem serializationWithDictionary:dict];
        
        [relationArr addObject:rItem];
        
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationTaskParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Load_RelateTaskList, relationArr);
    });
}

 //设置管理母任务
-(void)setRelationParent:(NSMutableDictionary*)dataDic{
    
//    NSString *context=[NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *context = [NSString stringWithFormat:@"%@",dataNumber];
    
    if (context &&[context isEqualToString:@"1"]) {
        
        NSDictionary *getDict=[dataDic objectForKey:WebApi_DataSend_Get];
        
        //更改后的父任务ID
        NSString *pid=[getDict objectForKey:@"pid"];
        //当前任务id
        NSString *tid=[getDict objectForKey:@"tid"];
        NSString *pname=[getDict objectForKey:@"pname"];

        
        //更改数据库任务的父任务id
        [[CoTaskDAL shareInstance]updataTaskParentTid:tid Pid:pid];
        
        NSDictionary *data=[NSDictionary dictionaryWithObjectsAndKeys:pname,@"pname",pid,@"pid",tid,@"tid", nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationTaskParse *service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Modify_Relate_Task, data);
        });
    }
    
}


//创建节点
-(void)parseAddPhase:(NSMutableDictionary*)dataDic{
    
    NSString *phid = [dataDic lzNSStringForKey:WebApi_DataContext];
    
    NSDictionary *postDict = [dataDic objectForKey:WebApi_DataSend_Post];
    CoTaskPhaseModel *pModel=[[CoTaskPhaseModel alloc]init];

    [pModel serializationWithDictionary:postDict];
    
    pModel.datelimit = [LZFormat StringCooperationDate:[postDict objectForKey:@"datelimit"]];
    pModel.phid=phid;
    pModel.state=[[NSString stringWithFormat:@"%@",[postDict objectForKey:@"state"]]integerValue];
    [[CoTaskPhaseDAL shareInstance]addPhase:pModel];
    CooperationTaskCheckItem *checkItem=[[CooperationTaskCheckItem alloc]init];
    
    checkItem=[checkItem getModelForm:pModel];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationTaskParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParsePhase_Creat, checkItem);
    });

}
 /*设置环节描述*/
- (void)parseSetPhaseDes:(NSMutableDictionary*)dataDic{
    
    NSDictionary *getParam=[dataDic objectForKey:WebApi_DataSend_Get];
    NSString *tid=[getParam objectForKey:@"tid"];
    NSString *phid=[getParam objectForKey:@"phid"];

    NSString *des=[dataDic objectForKey:WebApi_DataSend_Post];
    
    [[CoTaskPhaseDAL shareInstance]upDataTaskPhaseDes:des TaskID:tid Phid:phid];
    
}

/*设置环节提示*/
- (void)parseSetPhaseTip:(NSMutableDictionary*)dataDic{
    
    NSDictionary *getParam=[dataDic objectForKey:WebApi_DataSend_Get];
    NSString *tid=[getParam objectForKey:@"tid"];
    NSString *phid=[getParam objectForKey:@"phid"];
    
    NSString *tip=[dataDic objectForKey:WebApi_DataSend_Post];
    
    [[CoTaskPhaseDAL shareInstance]upDataTaskPhaseTip:tip TaskID:tid Phid:phid];

}
/*设置环节时限*/
- (void)parseSetPhaseDateLimit:(NSMutableDictionary*)dataDic{
    
    NSDictionary *getParam=[dataDic objectForKey:WebApi_DataSend_Get];
    NSString *tid=[getParam objectForKey:@"tid"];
    NSString *phid=[getParam objectForKey:@"phid"];
    
    NSDate *datelimit=[dataDic objectForKey:WebApi_DataSend_Post];
    
    [[CoTaskPhaseDAL shareInstance]upDataTaskPhaseDatelimit:datelimit TaskID:tid Phid:phid];
    
}

//删除节点
-(void)parseDelePhase:(NSMutableDictionary*)dataDic{
    NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
    NSString *phid=[param objectForKey:@"phid"];
    [[CoTaskPhaseDAL shareInstance]deletePhaseId:phid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationTaskParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParsePhase_Edit, WebApi_CloudCooperationTaskDeletePhase);
    });
}
//激活检查点
-(void)parseActivePhase:(NSMutableDictionary *)dataDic{
    
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    //activecount=1 state2 处理中 state2=1activecount=1 已完成
    if ([contextDict isEqualToString:@"1"]) {
        NSInteger activecount=1;
        NSInteger state=2;
        NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
        NSString *phid=[param objectForKey:@"phid"];
        NSString *tid=[param objectForKey:@"tid"];
        [[CoTaskPhaseDAL shareInstance]upDataTaskPhaseState:state Activecount:activecount TaskID:tid Phid:phid];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationTaskParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParsePhase_Edit, WebApi_CloudCooperationTaskActivePhase);
        });
    }

}

//未开始检查点
-(void)parseUnstartPhase:(NSMutableDictionary *)dataDic{
    
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    //activecount=1 state2 处理中 state2=1activecount=1 已完成
    if ([contextDict isEqualToString:@"1"]) {
        NSInteger activecount=1;
        NSInteger state=0;
        NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
        NSString *phid=[param objectForKey:@"phid"];
        NSString *tid=[param objectForKey:@"tid"];
        [[CoTaskPhaseDAL shareInstance]upDataTaskPhaseState:state Activecount:activecount TaskID:tid Phid:phid];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationTaskParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParsePhase_Edit, WebApi_CloudCooperationTaskUnstartPhase);
        });
    }
    
}


//完成检查点
-(void)parseFinishPhase:(NSMutableDictionary *)dataDic{
    
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    //activecount=1 state2 处理中 state=1activecount=1 已完成
    if ([contextDict isEqualToString:@"1"]) {
        NSInteger activecount=1;
        NSInteger state=1;
        NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
        NSString *phid=[param objectForKey:@"phid"];
        NSString *tid=[param objectForKey:@"tid"];
        [[CoTaskPhaseDAL shareInstance]upDataTaskPhaseState:state Activecount:activecount TaskID:tid Phid:phid];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationTaskParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParsePhase_Edit, WebApi_CloudCooperationTaskFinishPhase);
        });
    }
    
}

//修改任务管理员
-(void)parseAdminPhase:(NSMutableDictionary *)dataDic{
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];

    if ([contextDict isEqualToString:@"1"]) {
        
        NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
        NSString *phid=[param objectForKey:@"phid"];
        NSString *tid=[param objectForKey:@"tid"];
        NSString *uid = [dataDic objectForKey:WebApi_DataSend_Post];
        
        [[CoTaskPhaseDAL shareInstance]upDataTaskPhaseChief:uid TaskID:tid Phid:phid];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationTaskParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParsePhase_Edit, nil);
        });
    }
}

//添加关联工作组
-(void)addRelatedGroup:(NSMutableDictionary*)dataDic{
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    if ([contextDict isEqualToString:@"1"]){
        
        NSDictionary *getDict = [dataDic objectForKey:WebApi_DataSend_Get];
        
        NSString *tid = [getDict objectForKey:@"tid"];
        
        NSString *gid = [getDict objectForKey:@"gid"];
        
        NSString *gname = [getDict objectForKey:@"gname"];

        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:tid,@"tid",gid,@"gid",gname,@"gname",WebApi_CloudCooperationTaskAddRelatedGroup,@"url", nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationTaskParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskRelateGroupPhase_Add, dict);
        });
    }
}

//删除关联工作组
-(void)deleRelatedGroup:(NSMutableDictionary*)dataDic{
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    if ([contextDict isEqualToString:@"1"]){
      
        NSDictionary *getDict = [dataDic objectForKey:WebApi_DataSend_Get];
        NSString *tid = [getDict objectForKey:@"tid"];
        NSString *gid = [getDict objectForKey:@"gid"];
       
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:tid,@"tid",gid,@"gid",WebApi_CloudCooperationTaskDeleteRelatedGroup,@"url", nil];

        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationTaskParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskRelateGroupPhase_Del, dict);
        });
    }
}
//添加关联项目
- (void)addRelatedProject:(NSMutableDictionary*)dataDic{
    
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    if ([contextDict isEqualToString:@"1"]){
        
        NSDictionary *getDict = [dataDic objectForKey:WebApi_DataSend_Get];
        
        NSString *tid = [getDict objectForKey:@"tid"];
        
        NSString *pid = [getDict objectForKey:@"prid"];
        
        NSString *pname = [getDict objectForKey:@"pname"];
        
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:tid,@"tid",pid,@"pid",pname,@"pname",WebApi_CloudCooperationTaskAddRelatedProject,@"url", nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationTaskParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskRelateProjectPhase_Add, dict);
        });
    }

}

//删除关联项目
- (void)deleRelatedProject:(NSMutableDictionary*)dataDic{
    
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    if ([contextDict isEqualToString:@"1"]){
        
        NSDictionary *getDict = [dataDic objectForKey:WebApi_DataSend_Get];
        NSString *tid = [getDict objectForKey:@"tid"];
        NSString *pid = [getDict objectForKey:@"prid"];
        
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:tid,@"tid",pid,@"pid",WebApi_CloudCooperationTaskDeleteRelatedProject,@"url", nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationTaskParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskRelateProjectPhase_Del, dict);
        });
    }

}

//托付任务
-(void)setTaskAdmins:(NSMutableDictionary*)dataDic{
    
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    if ([contextDict isEqualToString:@"1"]){
        NSDictionary *getDict = [dataDic objectForKey:WebApi_DataSend_Get];
        
        NSString *cid = [getDict objectForKey:@"tid"];
        NSString *uid = [getDict objectForKey:@"uid"];
        [[CoMemberDAL shareInstance]upDataMemberUtypeCooperationTaskId:cid Uid:uid Utype:CoSuperadministrator];

        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationTaskParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskSetAdmins, cid);
        });
    }

}

//设置任务管理员
- (void)setTaskMemberAdmins:(NSMutableDictionary*)dataDic{
	
	NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
	NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
	if ([contextDict isEqualToString:@"1"]){
		NSDictionary *getDict = [dataDic objectForKey:WebApi_DataSend_Get];
		
		NSString *cid = [getDict objectForKey:@"cid"];
		NSString *uid = [getDict objectForKey:@"uid"];
		[[CoMemberDAL shareInstance]upDataMemberUtypeCooperationId:cid Uid:uid Utype:CoAdministrator];
		
		/* 在主线程中发送通知 */
		dispatch_async(dispatch_get_main_queue(), ^{
			__block CooperationTaskParse * service = self;
			EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskSetMemberIdentity, cid);
		});
	}
}

//取消任务管理员
-(void)cannelTaskMemberAdmins:(NSMutableDictionary*)dataDic{
	
	NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
	NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
	if ([contextDict isEqualToString:@"1"]){
		NSDictionary *getDict = [dataDic objectForKey:WebApi_DataSend_Get];
		
		NSString *cid = [getDict objectForKey:@"cid"];
		NSString *uid = [getDict objectForKey:@"uid"];
		[[CoMemberDAL shareInstance]upDataMemberUtypeCooperationId:cid Uid:uid Utype:CoParticipant];
		
		/* 在主线程中发送通知 */
		dispatch_async(dispatch_get_main_queue(), ^{
			__block CooperationTaskParse * service = self;
			EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskSetMemberIdentity, cid);
		});
	}
}

//锁定任务
-(void)lockTask:(NSMutableDictionary*)dataDic{
	
    __block CooperationTaskParse * service = self;
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    if ([contextDict isEqualToString:@"1"]){
        NSDictionary *getDict = [dataDic objectForKey:WebApi_DataSend_Get];
        NSString *tid = [getDict objectForKey:@"tid"];
        NSString *uid= [[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];

        [[CoTaskDAL shareInstance]updataTaskLock:tid LockUser:uid];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:tid,@"tid",WebApi_CloudCooperationTaskLocktask,@"url", nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskSetStaut, dict);
        });
    }else{
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_WebApi_SendFail, (@{@"Code":@"0",@"Message":@"锁定任务失败"}));
        });
    }

}

//解锁任务
-(void)unlockTask:(NSMutableDictionary*)dataDic{
    
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    __block CooperationTaskParse * service = self;

    if ([contextDict isEqualToString:@"1"]){
        NSDictionary *getDict = [dataDic objectForKey:WebApi_DataSend_Get];
        NSString *tid = [getDict objectForKey:@"tid"];
        [[CoTaskDAL shareInstance]updataTaskLock:tid LockUser:nil];

        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:tid,@"tid",WebApi_CloudCooperationTaskUnLocktask,@"url", nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskSetStaut, dict);
        });
    }else{
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_WebApi_SendFail, (@{@"Code":@"0",@"Message":@"解除任务锁定失败"}));
        });
    }
    
}
//删除任务
-(void)delTask:(NSMutableDictionary*)dataDic{
    
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    __block CooperationTaskParse * service = self;
    if ([contextDict isEqualToString:@"1"]){
        
        NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
        NSString *tid=[param objectForKey:@"tid"];
        [[CoTaskDAL shareInstance]deleteTaskid:tid];
        
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:tid,@"tid",WebApi_CloudCooperationTaskDeltask,@"url", nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskSetDel, dict);
        });

    }else{
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_WebApi_SendFail, (@{@"Code":@"0",@"Message":@"删除任务失败"}));
        });
    }
    
}

//发布任务
-(void)publishTask:(NSMutableDictionary*)dataDic{
    
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    if ([contextDict isEqualToString:@"1"]){
        
        NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
        NSString *tid=[param objectForKey:@"tid"];
        [[CoTaskDAL shareInstance]updateTaskStateTid:tid withState:2];
        
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:tid,@"tid",WebApi_CloudCooperationTaskPublishtask,@"url", nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationTaskParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskSetStaut, dict);
        });
    }
    
}

//暂停任务
-(void)pauseTask:(NSMutableDictionary*)dataDic{
    
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    if ([contextDict isEqualToString:@"1"]){
        
        NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
        NSString *tid=[param objectForKey:@"tid"];
        [[CoTaskDAL shareInstance]updateTaskStateTid:tid withState:5];

        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:tid,@"tid",WebApi_CloudCooperationTaskPausetask,@"url", nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationTaskParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskSetStaut, dict);
        });
    }
    
}


//恢复任务
-(void)recoverTask:(NSMutableDictionary*)dataDic{
    
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    if ([contextDict isEqualToString:@"1"]){
        
        NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
        NSString *tid=[param objectForKey:@"tid"];
        [[CoTaskDAL shareInstance]updateTaskStateTid:tid withState:2];
        
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:tid,@"tid",WebApi_CloudCooperationTaskRecovertask,@"url", nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationTaskParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskSetStaut, dict);
        });
    }
    
}
//废弃任务
-(void)abandonTask:(NSMutableDictionary*)dataDic{
    
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    __block CooperationTaskParse * service = self;

    if ([contextDict isEqualToString:@"1"]){
        
        NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
        NSString *tid=[param objectForKey:@"tid"];
        [[CoTaskDAL shareInstance]updateTaskStateTid:tid withState:4];

        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:tid,@"tid",WebApi_CloudCooperationTaskAbandontask,@"url", nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskSetStaut, dict);
        });

    }else{
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_WebApi_SendFail, (@{@"Code":@"0",@"Message":@"任务废弃失败"}));
        });
    }
    
}
//完成任务
-(void)completeTask:(NSMutableDictionary*)dataDic{
    __block CooperationTaskParse * service = self;

//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    if ([contextDict isEqualToString:@"1"]){
        
        NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
        NSString *tid=[param objectForKey:@"tid"];
        [[CoTaskDAL shareInstance]updateTaskStateTid:tid withState:3];
        
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:tid,@"tid",WebApi_CloudCooperationTaskCompletetask,@"url", nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskSetStaut, dict);
        });

    }else{

        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_WebApi_SendFail, (@{@"Code":@"0",@"Message":@"任务完成失败"}));
        });
    }

}

//任务可关联的工作组列表
- (void)refGroupUnSelectedList:(NSMutableDictionary*)dataDic{
    
    NSMutableArray *contextArr  = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSDictionary *subDict in contextArr) {
        
        CoTaskRelatedModel *rModel = [[CoTaskRelatedModel alloc]init];
        rModel.tid=nil;
        rModel.relatedid=[subDict objectForKey:@"relatedid"];
        rModel.relatedname=[subDict objectForKey:@"relatedname"];
        [dataArr addObject:rModel];
    }
    NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
    NSString *tid=[param objectForKey:@"tid"];

    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:tid,@"tid",dataArr,@"data", nil];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationTaskParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Eef_Task_WorkGroup_List, dict);
    });
}

//任务可关联的项目列表
- (void)refProjectUnSelectedList:(NSMutableDictionary*)dataDic{
    
    NSMutableArray *contextArr  = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSDictionary *subDict in contextArr) {
        
        CoTaskRelatedModel *rModel = [[CoTaskRelatedModel alloc]init];
        rModel.tid=nil;
        rModel.relatedid=[subDict objectForKey:@"relatedid"];
        rModel.relatedname=[subDict objectForKey:@"relatedname"];
        [dataArr addObject:rModel];
    }
    NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
    NSString *tid=[param objectForKey:@"tid"];
    
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:tid,@"tid",dataArr,@"data", nil];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationTaskParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Eef_Task_Project_List, dict);
    });
}

//任务可关联的全部工作组列表
- (void)refGroupAllList:(NSMutableDictionary*)dataDic{
    
    NSMutableArray *contextArr  = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSDictionary *subDict in contextArr) {
        
        CoTaskRelatedModel *rModel = [[CoTaskRelatedModel alloc]init];
        rModel.tid=nil;
        rModel.relatedid=[subDict objectForKey:@"relatedid"];
        rModel.relatedname=[subDict objectForKey:@"relatedname"];
        [dataArr addObject:rModel];
    }
    
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:dataArr,@"data", nil];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationTaskParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Ref_Task_WorkGroup__ALL_List, dict);
    });
}

//任务可关联的全部项目列表
- (void)refProjectAllList:(NSMutableDictionary*)dataDic{
    
    NSMutableArray *contextArr  = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSDictionary *subDict in contextArr) {
        
        CoTaskRelatedModel *rModel = [[CoTaskRelatedModel alloc]init];
        rModel.tid=nil;
        rModel.relatedid=[subDict objectForKey:@"relatedid"];
        rModel.relatedname=[subDict objectForKey:@"relatedname"];
        [dataArr addObject:rModel];
    }
    
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:dataArr,@"data", nil];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationTaskParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Ref_Task_Project_ALL_List, dict);
    });
}




#pragma mark -
#pragma mark - 解析数据(服务器返回的ErrorCode非0)

/**
 *  解析数据(服务器返回的ErrorCode非0)
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parseErrorDataContext:(NSMutableDictionary *)dataDic{
    
}

@end
