//
//  CooperationProjectMainParse.m
//  LeadingCloud
//
//  Created by SY on 16/10/17.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CooperationProjectMainParse.h"
#import "CoProjectGroupModel.h"
#import "CoProjectsModel.h"

#import "CoProjectMainGroupDAL.h"
#import "CoProjectsMainDAL.h"
#import "CoProjectMainModsDAL.h"

#import "NSObject+JsonSerial.h"

#define UserID [AppUtils GetCurrentUserID] // 当前用户id
#define OrgID [AppUtils GetCurrentOrgID]  // 当前企业id
@interface CooperationProjectMainParse ()
{
    NSMutableDictionary *isDeleteDic;
}


@end

@implementation CooperationProjectMainParse
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CooperationProjectMainParse *)shareInstance {
    
    static CooperationProjectMainParse *instance = nil;
    if (instance == nil) {
        instance = [[CooperationProjectMainParse alloc] init];
    }
    return  instance;
}

/**
 *  解析数据
 *
 *  @param dataDic
 */
-(void)parse:(NSMutableDictionary *)dataDic {
    
     NSString *route = [dataDic objectForKey:WebApi_Route];
    /* 获取项目分组 */
    if ([route isEqualToString:WebApi_CloudCooperation_GetCustomGroup]) {
        [self parseGroupList:dataDic];
    }
    /* 获取项目下的分组 */
    else if ([route isEqualToString:WebApi_CloudCooperation_GetProjectsItem]) {
        [self parseGroupProjectsList:dataDic];
    }
    /* 添加项目分组 */
    else if ([route isEqualToString:WebApi_CloudCooperation_AddCustomGroup]) {
        [self parseAddCustomGroup:dataDic];
    }
    /* 设置分组名称 */
    else if ([route isEqualToString:WebApi_CloudCooperation_SetCustomGroupName]) {
        [self parseSetGroupName:dataDic];
    }
    /* 删除项目分组 */
    else if ([route isEqualToString:WebApi_CloudCooperation_DeleteCustomGroup]) {
        [self parseDeleteGroup:dataDic];
    }
    /* 项目排序 */
    else if ([route isEqualToString:WebApi_CloudCooperation_SetCustomGroupSort]) {
        [self parseGroupSort:dataDic];
    }
    /* 调整项目所属分组 */
    else if ([route isEqualToString:WebApi_CloudCooperation_SetProjectToNewGroup]) {
        [self parseSetNewGroup:dataDic];
    }
    /* 项目置顶和取消置顶操作 */
    else if ([route isEqualToString:WebApi_CloudCoopration_ProjectTopAction]) {
        [self parseTopAction:dataDic];
    }
    /* 查询我的项目信息 */
    else if ([route isEqualToString:WebApi_CloudCooperation_GetProjecstWithSearch]) {
        [self parseProjectSearch:dataDic];
    }
    /* 获取我在当前项目下能够使用的模块 */
    else if ([route isEqualToString:WebApi_CloudCooperation_GetMods] || [route isEqualToString:WebApi_Devrun_CloudCooperation_GetMods]) {
        [self parseGetMods:dataDic];
    }
    /* 获取当前项目可用的所有模块 */
    else if ([route isEqualToString:WebApi_CloudCooperation_GetAllMods] || [route isEqualToString:WebApi_Devrun_CloudCooperation_GetAllMods]) {
        [self parseGetAllMods:dataDic];
    }
    /* 重新设置当前项目能用的所有模块 备注：此接口会将之前当前项目下已有的数据清空，插入当前的数据 */
    else if ([route isEqualToString:WebApi_CloudCooperation_ResetProjectMods] || [route isEqualToString:WebApi_Devrun_CloudCooperation_ResetProjectMods]) {
        [self parseResetProjectMods:dataDic];
    }
    /* 获取指定项目id的项目数据 */
    else if ([route isEqualToString:WebApi_CloudCooperation_GetProjectMain] || [route isEqualToString:WebApi_Devrun_CloudCooperation_GetProjectMain]) {
        [self parseGetProjectMain:dataDic];
    }
    /* 获取所有项目<##> */
    else if ([route isEqualToString:WebApi_CloudCooperation_GetllpProjects]) {
        [self parseAllProject:dataDic];
    }
    
    
}

/**
 获取项目分组
 */
-(void)parseGroupList:(NSMutableDictionary*)dataDic {
    
    NSArray *dataContext = [dataDic lzNSArrayForKey:WebApi_DataContext];
    NSMutableDictionary *postData = [dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Post];
    NSDictionary *otherDate = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    
    NSString *ispull = [otherDate lzNSStringForKey:@"1"];
    // 加库的arr
    NSMutableArray *groupArray = [[NSMutableArray alloc] init];
  
    for (NSDictionary * groupDic in dataContext) {
        CoProjectGroupModel *pgModel = [[CoProjectGroupModel alloc] init];
        [pgModel serializationWithDictionary:groupDic];
        pgModel.uid = [postData lzNSStringForKey:@"uid"];
        pgModel.orgid = [postData lzNSStringForKey:@"orgid"];
        pgModel.state = [[postData lzNSNumberForKey:@"state"] integerValue];
        
        //【未分组项目】 这个分组的id是空的，在数据库中不存在，但是页面上有的 可不可以让uid加上orgid作为未分组项目的主键
        if ([NSString isNullOrEmpty:pgModel.pgid]) {
            pgModel.pgid = [NSString stringWithFormat:@"%@%@",pgModel.uid,pgModel.orgid];
        }
        [groupArray addObject:pgModel];
    }
    // 先删
    [[CoProjectMainGroupDAL shareInstance] deleteAllGroupWithUid:[postData lzNSStringForKey:@"uid"] orgid:[postData lzNSStringForKey:@"orgid"] state:[[postData lzNSNumberForKey:@"state"] integerValue]];
    
    // 存库
    [[CoProjectMainGroupDAL shareInstance] addProjectMainWithArray:groupArray];
    
    if ([ispull isEqualToString:@"isPull"]) {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationProjectMainParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_ProjectMainGroupListForPull, groupArray);
        });
    }
    else {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationProjectMainParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_ProjectMainGroupList, groupArray);
        });
    }
    
}

/**
 获取分组下的项目
 */
-(void)parseGroupProjectsList:(NSMutableDictionary*)dataDic {
    
    NSArray *dataContext = [dataDic lzNSArrayForKey:WebApi_DataContext];
    NSDictionary *otherData = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSDictionary *postDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    
    NSString *isPull = [otherData lzNSStringForKey:@"1"];
    
    NSString *lastkey = [postDic lzNSStringForKey:@"lastkey"];
    NSString *pgid = [self getPgidIfNil:[postDic lzNSStringForKey:@"pgid"]];
    
    NSMutableArray *projectsArray = [[NSMutableArray alloc] init];
    for (NSDictionary *projectDic in dataContext) {
        CoProjectsModel *projectModel = [[CoProjectsModel alloc] init];
        [projectModel serializationWithDictionary:projectDic];
       
        projectModel.pgid = [self getPgidIfNil:projectModel.pgid];
     
        [projectsArray addObject:projectModel];
    }
    /* 每个分组只删一次 */
    if ([NSString isNullOrEmpty:lastkey]) {
         [[CoProjectsMainDAL shareInstance] deleteProjectsWithPgid:pgid];
    }
   
    // 存库
    [[CoProjectsMainDAL shareInstance] addProjectsWithArray:projectsArray];
    
    NSMutableDictionary *Dic = [[NSMutableDictionary alloc] init];
    [Dic setObject:lastkey forKey:@"lastkey"];
    [Dic setObject:projectsArray forKey:@"array"];
   
    if ([isPull isEqualToString:@"isPull"]) {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationProjectMainParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_ProjectMainGetProjectsListForPull, Dic);
        });

    }
    else {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationProjectMainParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_ProjectMainGetProjectsList, Dic);
        });
    }
}
/* 获取所有项目<##> */
-(void)parseAllProject:(NSMutableDictionary*)dataDic {
    NSDictionary *dataContext = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSArray *modelList = [dataContext lzNSArrayForKey:@"apimodellist"];
    
    NSMutableArray *projectsArray = [[NSMutableArray alloc] init];
    for (NSDictionary *projectDic in modelList) {
        CoProjectsModel *projectModel = [[CoProjectsModel alloc] init];
        [projectModel serializationWithDictionary:projectDic];
        projectModel.pgid = [self getPgidIfNil:projectModel.pgid];
        [projectsArray addObject:projectModel];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationProjectMainParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_ProjectMainGetAllProject, projectsArray);
    });
}
/**
 添加项目
 */
-(void)parseAddCustomGroup:(NSMutableDictionary*)dataDic {
    NSDictionary *dataContext = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSDictionary *dataPost = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    
    CoProjectGroupModel *pgModel = [[CoProjectGroupModel alloc] init];
    [pgModel serializationWithDictionary:dataContext];
    pgModel.orgid = [dataPost lzNSStringForKey:@"orgid"];
    pgModel.uid = [dataPost lzNSStringForKey:@"uid"];
    // state状态？ 暂时先1
    pgModel.state = 1;
    [[CoProjectMainGroupDAL shareInstance] addProjectGroupWithModel:pgModel];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationProjectMainParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, pgModel);
    });

}

/**
 设置分组名称
 */
-(void)parseSetGroupName:(NSMutableDictionary*)dataDic {
    
    NSInteger isSuccess = [[dataDic lzNSNumberForKey:WebApi_DataContext] integerValue];
    NSDictionary *postDataDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    
    NSString *pgid = [postDataDic lzNSStringForKey:@"pgid"];
    NSString *name = [postDataDic lzNSStringForKey:@"name"];
    
    if (isSuccess) {
        [[CoProjectMainGroupDAL shareInstance] updateGroupNameWithNewName:name pgid:pgid];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationProjectMainParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, pgid);
    });
    
}

/**
 删除分组
 */
-(void)parseDeleteGroup:(NSMutableDictionary*)dataDic {
    
    NSInteger isSuccess = [[dataDic lzNSNumberForKey:WebApi_DataContext] integerValue];
    
    NSDictionary *dataGet=[dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
    NSString *pgid = [dataGet lzNSStringForKey:@"pgId"];
    
    if (isSuccess) {
        [[CoProjectMainGroupDAL shareInstance]deleteCustomGroupWithPgid:pgid];
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationProjectMainParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_ProjectMainGroupDelete, pgid);
    });
    
}

/**
 项目排序
 */
-(void)parseGroupSort:(NSMutableDictionary*)dataDic {
    NSInteger isSuccess = [[dataDic lzNSNumberForKey:WebApi_DataContext]integerValue];

    if (isSuccess) {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationProjectMainParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_ProjectMainGroupSortSuccess, nil);
        });
    }
    
    
}

/**
 调整项目所属分组
 */
-(void)parseSetNewGroup:(NSMutableDictionary*)dataDic {
    
    NSString *newPgid =[self getPgidIfNil:[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSDictionary *postDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    
    NSString *oldPgid =[self getPgidIfNil:[postDic lzNSStringForKey:@"oldpgid"]];
    
    
    /* 更新数据库 还要更新分组的prcount */
    [[CoProjectsMainDAL shareInstance] updateProjectGroupWithNewPgid:newPgid prid:[postDic lzNSStringForKey:@"prid"]];
    /* 刷新本地prcount */
    [self updatePrcountWithNewPgid:newPgid oldPgid:oldPgid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationProjectMainParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_ProjectMainSetProjectNewGroup, newPgid);
    });
    
}

/**
 项目置顶和取消置顶操作
 */
-(void)parseTopAction:(NSMutableDictionary*)dataDic {
    
    NSString *newGroupid = [dataDic lzNSStringForKey:WebApi_DataContext];
    
    NSDictionary *postdata  =[dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    NSDictionary *otherDataDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    
    NSInteger istop = [[postdata lzNSNumberForKey:@"isTop"] integerValue];
    NSString *prid = [postdata lzNSStringForKey:@"prid"];
    NSString *oldGroupid = [otherDataDic lzNSStringForKey:@"oldpgid"];
    
    if ([NSString isNullOrEmpty:newGroupid]) {
        newGroupid = [NSString stringWithFormat:@"%@%@",UserID,OrgID];
    }
    
    
    [self updatePrcountWithNewPgid:newGroupid oldPgid:oldGroupid];
    // 修改本地
    if (![NSString isNullOrEmpty:newGroupid]) {
        [[CoProjectsMainDAL shareInstance] updateProjectTopActionWithNewPgid:newGroupid istop:istop prid:prid];
    
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationProjectMainParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_ProjectMainSetProjectTopAction, newGroupid);
    });
  
}
/* 查询我的项目信息 */
-(void)parseProjectSearch:(NSMutableDictionary*)dataDic {
    
    NSArray *contextArr = [dataDic lzNSArrayForKey:WebApi_DataContext];
    
    NSMutableArray *groupArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *allProjectsDic = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < contextArr.count; i++) {
        NSDictionary *groupAndProDic = [contextArr objectAtIndex:i];
        
        NSDictionary *groupDic  =[groupAndProDic lzNSDictonaryForKey:@"group"];
        NSArray *projectsArr = [groupAndProDic lzNSArrayForKey:@"projects"];
        
        CoProjectGroupModel *pgModel = [[CoProjectGroupModel alloc] init];
        [pgModel serializationWithDictionary:groupDic];
        [groupArray addObject:pgModel];
        
        NSMutableArray *projectsArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in projectsArr) {
            CoProjectsModel *prModel = [[CoProjectsModel alloc] init];
            [prModel serializationWithDictionary:dic];
            [projectsArray addObject:prModel];
        }
        [allProjectsDic setObject:projectsArray forKey:[NSString stringWithFormat:@"%d",i]];
    }
    
    
    NSMutableDictionary *allSearchDic = [[NSMutableDictionary alloc] init];
    [allSearchDic setObject:groupArray forKey:@"group"];
    [allSearchDic setObject:allProjectsDic forKey:@"project"];
    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationProjectMainParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_ProjectMainGetProjectsWithSearch, allSearchDic);
    });

}

/**
 获取我在当前项目下能够使用的模块
 */
-(void)parseGetMods:(NSMutableDictionary*)dataDic {
    NSMutableArray *getModsAppInfoArr  = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableDictionary *datasendPost = [dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Post];
    NSMutableArray *modsArr = [NSMutableArray array];
    for(int i =0;i<getModsAppInfoArr.count;i++){
        
        NSDictionary *modsDic = [getModsAppInfoArr objectAtIndex:i];
        CoProjectModsModel *coproModsModel = [[CoProjectModsModel alloc]init];
        [coproModsModel serializationWithDictionary:modsDic];
        coproModsModel.prid = [datasendPost lzNSStringForKey:@"prId"];
        [modsArr addObject:coproModsModel];
    }
    [[CoProjectMainModsDAL shareInstance]deleteProjectMainModsWithPrid:[datasendPost lzNSStringForKey:@"prId"]];
    [[CoProjectMainModsDAL shareInstance]addProjectMainModsWithArray:modsArr];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationProjectMainParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_ProjectMainSetProjectGetMods, modsArr);
    });
}

/**
 获取当前项目可用的所有模块
 */
-(void)parseGetAllMods:(NSMutableDictionary*)dataDic {
    NSArray *getAllModsArr = [dataDic lzNSArrayForKey:WebApi_DataContext];
    NSMutableArray *selectedArr = [NSMutableArray array];
    NSMutableArray *unselectedArr = [NSMutableArray array];
    NSMutableDictionary *getAllModsDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *datasendGet = [dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Get];
    for(int i=0;i<getAllModsArr.count;i++){
        CoProjectModsModel *coProModModel = [[CoProjectModsModel alloc]init];
        NSDictionary *allModsDic = [getAllModsArr objectAtIndex:i];
        [coProModModel serializationWithDictionary:allModsDic];
        coProModModel.prid = [datasendGet lzNSStringForKey:@"prId"];
        if(coProModModel.isuseable  == YES){
            [selectedArr addObject:coProModModel];
        }else{
            [unselectedArr addObject:coProModModel];
        }
    }
    [getAllModsDic setObject:selectedArr forKey:@"selectedArr"];
    [getAllModsDic setObject:unselectedArr forKey:@"unselectedArr"];
    
    [[CoProjectMainModsDAL shareInstance]deleteProjectMainModsWithPrid:[datasendGet lzNSStringForKey:@"prId"]];
    [[CoProjectMainModsDAL shareInstance]addProjectMainModsWithArray:selectedArr];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationProjectMainParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_ProjectMainSetProjectGetAllMods, getAllModsDic);
    });
}

/**
 重新设置当前项目能用的所有模块 备注：此接口会将之前当前项目下已有的数据清空，插入当前的数据
 */
-(void)parseResetProjectMods:(NSMutableDictionary*)dataDic {
//    NSMutableArray *dataContext = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        self.appDelegate.lzGlobalVariable.isNeedRefreshCoProAppInfoVC = YES;
        __block CooperationProjectMainParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_ProjectMainSetResetProjectMods, nil);
    });
}

/**
 获取指定项目id的项目数据
 */
-(void)parseGetProjectMain:(NSMutableDictionary*)dataDic {
    NSDictionary *dataContext = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    CoProjectsModel *coProModel = [[CoProjectsModel alloc]init];
    [coProModel serializationWithDictionary:dataContext];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationProjectMainParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_ProjectMainSetGetProjectMain, coProModel);
    });
}







/**
 修改本地分组下项目字段的数量

 @param newpgid 新的分组id
 @param oldPgid 老的分组id
 */
-(void)updatePrcountWithNewPgid:(NSString *)newpgid oldPgid:(NSString *)oldPgid {
    
    /* 由prid得到老的pgid，老的pgid的prcount-1 知道为0 */
    CoProjectGroupModel *oldPgModel = [[CoProjectMainGroupDAL shareInstance] getGroupModelWithPgid:oldPgid];
    CoProjectGroupModel *newPgModel = [[CoProjectMainGroupDAL shareInstance] getGroupModelWithPgid:newpgid];
    
    /* 老的分组prcount - 1 */
    oldPgModel.prcount -= 1;
    if (oldPgModel.prcount >= 0) {
        [[CoProjectMainGroupDAL shareInstance]updateGroupPrcountWithPrcount:[NSString stringWithFormat:@"%ld",oldPgModel.prcount] pgid:oldPgid];
    }
    
    /* 新的分组prcount +1 */
    newPgModel.prcount += 1;
    [[CoProjectMainGroupDAL shareInstance] updateGroupPrcountWithPrcount:[NSString stringWithFormat:@"%ld",newPgModel.prcount] pgid:newpgid];
    
}
-(NSString*)getPgidIfNil:(NSString*)pgid {
    if ([NSString isNullOrEmpty:pgid]) {
       return   [NSString stringWithFormat:@"%@%@",UserID ,OrgID];
    }
    return pgid;
}



/**
 *  解析数据(服务器返回的ErrorCode非0)
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parseErrorDataContext:(NSMutableDictionary *)dataDic {
    
    
    
    
    
    
}
@end
