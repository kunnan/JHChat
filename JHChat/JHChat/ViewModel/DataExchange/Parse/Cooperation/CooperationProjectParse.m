//
//  CooperationProjectParse.m
//  LeadingCloud
//
//  Created by wang on 16/5/23.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CooperationProjectParse.h"
#import "CoProjectDAL.h"
#import "coMemberDAL.h"
#import "TagDataDAL.h"
#import "CooperationProjectItem.h"
#import "CoTaskDAL.h"
#import "ResFolderModel.h"
#import "ResModel.h"
#import "ResDAL.h"
#import "ResFolderDAL.h"

@interface CooperationProjectParse ()
{
    NSString *folderRpid;
    NSString *parentid;
}
@end

@implementation CooperationProjectParse

+(CooperationProjectParse *)shareInstance{
   
    static CooperationProjectParse *instance = nil;
    if (instance == nil) {
        instance = [[CooperationProjectParse alloc] init];
    }
    return instance;
    
}

-(void)parse:(NSMutableDictionary *)dataDic{
    
    NSString *route = [dataDic objectForKey:WebApi_Route];
    
    
    //创建项目
    if ([route isEqualToString:WebApi_CloudCooperationProjectAdd]){
        [self addProjectParse:dataDic];
    }
    //项目列表
    else if ([route isEqualToString:WebApi_CloudCooperationProjectList]){
        [self projectListParse:dataDic];
    }
    //项目基本信息
    else if ([route isEqualToString:WebApi_CloudCooperationProjectBaseInfo]){
        [self projectBaseInfoParse:dataDic];
    }
    //项目编辑姓名
    else if ([route isEqualToString:WebApi_CloudCooperationProjectEditName]){
        [self projectEditName:dataDic];
    }
    //项目编辑描述
    else if ([route isEqualToString:WebApi_CloudCooperationProjectEditDes]){
        [self projectEditDes:dataDic];
    }
    //项目修改开始时间
    else if ([route isEqualToString:WebApi_CloudCooperationProjectEditStartTime]){
        [self projectEditStartTime:dataDic];
    }
    //项目修改结束时间
    else if ([route isEqualToString:WebApi_CloudCooperationProjectEditEndTime]){
        [self projectEditEndTime:dataDic];
    }
    //遗弃项目
    else if ([route isEqualToString:WebApi_CloudCooperationProjectAbandon]){
        [self projectAbandon:dataDic];
    }
    //删除项目
    else if ([route isEqualToString:WebApi_CloudCooperationProjectdel]){
        [self projectDel:dataDic];
    }
    //完成项目
    else if ([route isEqualToString:WebApi_CloudCooperationProjectFinsh]){
        [self projectFinsh:dataDic];
    }
    //进行项目
    else if ([route isEqualToString:WebApi_CloudCooperationProjectRuning]){
        [self projectRuning:dataDic];
    }
    //任务列表已经关连
    else if ([route isEqualToString:WebApi_CloudCooperationProjectAllTaskList]){
        
        [self projectAllTaskListParse:dataDic];
    }
    
    
    
    
    
    // 文件
    else if ([route isEqualToString:WebApi_CloudCooperationProject_GetResource]) {
        [self parseResourceList:dataDic];
    }
    // 下级文件列表
    else if ([route isEqualToString:WebApi_CloudCooperationProject_GetNextResource]){
        [self parseNextResourceList:dataDic];
    }
    
    // 新增文件夹
    else if ([route isEqualToString:WebApi_CloudCooperationProject_AddFolder]) {
        [self parseAddFolder:dataDic];
    }
    // 删除文件夹
    else if ([route isEqualToString:WebApi_CloudCooperationProject_DelFolderContext]) {
        [self parseDeleteFolder:dataDic];
    }
    // 删除文件
    else if ([route isEqualToString:WebApi_CloudCooperationProject_DelResource]) {
        [self parseDeleteFile:dataDic];
    }
    // 批量删除
    else if ([route isEqualToString:WebApi_CloudCooperationProject_MixRemoveData]) {
        [self parseMixRemoveData:dataDic];
    }
    // 重命名文件夹
    else if ([route isEqualToString:WebApi_CloudCoooperationProject_EditFolderName]) {
        
        [self parseEditFolderName:dataDic];
    }
    // 重命名文件
    else if ([route isEqualToString:WebApi_CloudCooperationProject_EditResourceName]) {
        [self parseResourceName:dataDic];
    }
    // 文件/文件夹的移动
    else if ([route isEqualToString:WebApi_CloudCooperatonProject_Mobilefile]) {
        [self parseMove:dataDic];
    }
    
   
}

#pragma mark 创建项目
//数据未处理
- (void)addProjectParse:(NSMutableDictionary*)dataDic{
    
    //项目id
    NSString *cid=[dataDic lzNSStringForKey:WebApi_DataContext];
    
    NSMutableDictionary *postDict = [dataDic objectForKey:WebApi_DataSend_Post];
    
    CoProjectModel *prModel = [[CoProjectModel alloc]init];
    
    prModel.cid = cid;
    prModel.prid = cid;
    prModel.oid = [postDict objectForKey:@"oid"];
    prModel.name = [postDict objectForKey:@"name"];
    prModel.des = [postDict objectForKey:@"desc"];
    prModel.planbegindate = [LZFormat StringCooperationDate:[postDict objectForKey:@"planbegindate"]];
    prModel.planenddate = [LZFormat StringCooperationDate:[postDict objectForKey:@"planenddate"]];

    [[CoProjectDAL shareInstance]addProjectModel:prModel];
    
    NSDictionary *nDict =[NSDictionary dictionary];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationProjectParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Add_Project, nDict);
    });
}

#pragma mark 项目列表
- (void)projectListParse:(NSMutableDictionary*)dataDic{
    
    NSDictionary *getDict = [dataDic objectForKey:WebApi_DataSend_Get];
    NSString *oid = [getDict objectForKey:@"oid"];
    NSString *search = [getDict objectForKey:@"search"];
    NSInteger condition= [[getDict objectForKey:@"condition"]integerValue];
    //项目
    NSArray  *proArr=[dataDic lzNSArrayForKey:WebApi_DataContext];
    
    //全部项目
    NSMutableArray *allArr =[NSMutableArray array];
    for (NSDictionary *subDict in proArr) {
        CoProjectModel *pModel = [[CoProjectModel alloc]init];
        [pModel serializationWithDictionary:subDict];
        pModel.oid=oid;
        [allArr addObject:pModel];
    }
    [[CoProjectDAL shareInstance]addDataWithArray:allArr];
    
    NSMutableArray *lastArr =[[CoProjectDAL shareInstance]getDataArrayOid:oid Search:search Condition:condition];
    NSDictionary *sendDict =[NSDictionary dictionaryWithObjectsAndKeys:lastArr,@"data",oid,@"oid", nil];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationProjectParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_List_Project, sendDict);
    });
}

#pragma mark 项目详情
- (void)projectBaseInfoParse:(NSMutableDictionary*)dataDic{
    
    NSDictionary *getDict = [dataDic objectForKey:WebApi_DataSend_Get];
    NSString *pid = [getDict objectForKey:@"prid"];
    
    NSDictionary *contextDic=[dataDic lzNSDictonaryForKey:WebApi_DataContext];
    CoProjectModel *cpModel = [[CoProjectModel alloc]init];
    [cpModel serializationWithDictionary:contextDic];

    [[CoProjectDAL shareInstance]addProjectModel:cpModel];
    //当前用户
    NSDictionary *currmember = [contextDic objectForKey:@"currmember"];
    CoMemberModel *cModel = [[CoMemberModel alloc]init];
    [cModel serializationWithDictionary:currmember];
    cModel.cid = pid;
    [[CoMemberDAL shareInstance]addModel:cModel];
    
    //关联标签
    NSArray *relatedtag = [contextDic objectForKey:@"relatedtag"];
    NSMutableArray *tagsArr=[NSMutableArray array];
    [[TagDataDAL shareInstance]deleteCooperationCid:pid];
    for (NSDictionary *tDict in relatedtag) {
        TagDataModel *tModel=[[TagDataModel alloc]init];
        [tModel serializationWithDictionary:tDict];
        [tagsArr addObject:tModel];
    }
    [[TagDataDAL shareInstance] addDataWithTagDataArray:tagsArr];

    //成员
    NSArray *members =[contextDic objectForKey:@"members"];
    NSMutableArray *memberArr=[NSMutableArray array];
    for (NSDictionary *mDict in members) {
        CoMemberModel *mModel=[[CoMemberModel alloc]init];
        [mModel serializationWithDictionary:mDict];
        
        mModel.cid=pid;
        [memberArr addObject:mModel];
    }
    [[CoMemberDAL shareInstance]addDataWithArray:memberArr];
    
    //应用
//    NSDictionary *iosapp = [contextDic objectForKey:@"iosapp"];
    
    CooperationProjectItem *pItem =[[CooperationProjectItem alloc]init];
    pItem.projectID = cpModel.prid;
    pItem.projectName = cpModel.name;
    pItem.projectDesciption = cpModel.des;
    pItem.isStar = cpModel.isfavorites;
    pItem.resourceID = cpModel.resourceid;
    pItem.state = cpModel.state;
    //计划时间
    if (cpModel.planbegindate) {
        pItem.starTime=[LZFormat Date2String:cpModel.planbegindate format:@"yyyy-MM-dd"];
    }
    //计划完成
    if (cpModel.planenddate) {
        pItem.endTime=[LZFormat Date2String:cpModel.planenddate format:@"yyyy-MM-dd"];
    }
    
    pItem.labelsArray = tagsArr;
    pItem.memberArray = memberArr;
    
    [[CoProjectDAL shareInstance]addProjectModel:cpModel];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationProjectParse * service = self;
        NSDictionary *sendDict = [NSDictionary dictionaryWithObjectsAndKeys:pid,@"pid",pItem,@"data", nil];
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Base_Info_Project, sendDict);
    });
}

#pragma mark 项目编辑名称

- (void)projectEditName:(NSMutableDictionary*)dataDic{
    
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    NSString *name = [dataDic objectForKey:WebApi_DataSend_Post];
    if ([contextDict isEqualToString:@"1"]){
        
        NSDictionary *getDict = [dataDic objectForKey:WebApi_DataSend_Get];
        
        NSString *pid = [getDict objectForKey:@"prid"];
        [[CoProjectDAL shareInstance]upDataProjectName:name Pid:pid];
        
        NSDictionary *nDict=[NSDictionary dictionaryWithObjectsAndKeys:pid,@"pid",WebApi_CloudCooperationProjectEditName,@"url", nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationProjectParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Edit_Info_Project, nDict);
        });
    }
}

#pragma mark 项目编辑描述
- (void)projectEditDes:(NSMutableDictionary*)dataDic{
    
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    NSString *des = [dataDic objectForKey:WebApi_DataSend_Post];
    if ([contextDict isEqualToString:@"1"]){
        
        NSDictionary *getDict = [dataDic objectForKey:WebApi_DataSend_Get];
        
        NSString *pid = [getDict objectForKey:@"prid"];
        [[CoProjectDAL shareInstance]upDataProjectDes:des Pid:pid];
        
        NSDictionary *nDict=[NSDictionary dictionaryWithObjectsAndKeys:pid,@"pid",WebApi_CloudCooperationProjectEditDes,@"url", nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationProjectParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Edit_Info_Project, nDict);
        });
    }

}

#pragma mark 项目修改开始时间
- (void)projectEditStartTime:(NSMutableDictionary*)dataDic{
    
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    NSString *startTime = [dataDic objectForKey:WebApi_DataSend_Post];
    if ([contextDict isEqualToString:@"1"]){
        
        NSDictionary *getDict = [dataDic objectForKey:WebApi_DataSend_Get];
        
        NSString *pid = [getDict objectForKey:@"prid"];
        [[CoProjectDAL shareInstance]upDataProjectStartTime:startTime Pid:pid];
        
        NSDictionary *nDict=[NSDictionary dictionaryWithObjectsAndKeys:pid,@"pid",WebApi_CloudCooperationProjectEditStartTime,@"url", nil];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationProjectParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Edit_Info_Project, nDict);
        });
    }

}

#pragma mark 项目修改结束时间
- (void)projectEditEndTime:(NSMutableDictionary*)dataDic{
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    NSString *endTime = [dataDic objectForKey:WebApi_DataSend_Post];
    if ([contextDict isEqualToString:@"1"]){
        
        NSDictionary *getDict = [dataDic objectForKey:WebApi_DataSend_Get];
        
        NSString *pid = [getDict objectForKey:@"prid"];
        [[CoProjectDAL shareInstance]upDataProjectEndTime:endTime Pid:pid];
        
        NSDictionary *nDict=[NSDictionary dictionaryWithObjectsAndKeys:pid,@"pid",WebApi_CloudCooperationProjectEditEndTime,@"url", nil];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationProjectParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Edit_Info_Project, nDict);
        });
    }
    

}

#pragma mark 遗弃项目
- (void)projectAbandon:(NSMutableDictionary*)dataDic{
    
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];

    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    
    if ([contextDict isEqualToString:@"1"]){
        
        NSDictionary *getDict = [dataDic objectForKey:WebApi_DataSend_Get];
        
        NSString *pid = [getDict objectForKey:@"prid"];
        
        NSDictionary *nDict=[NSDictionary dictionaryWithObjectsAndKeys:pid,@"pid",WebApi_CloudCooperationProjectAbandon,@"url", nil];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationProjectParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Edit_Info_Project, nDict);
        });
    }

}

#pragma mark 删除项目
- (void)projectDel:(NSMutableDictionary*)dataDic{
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    
    if ([contextDict isEqualToString:@"1"]){
        
        NSDictionary *getDict = [dataDic objectForKey:WebApi_DataSend_Get];
        
        NSString *pid = [getDict objectForKey:@"prid"];
        
        NSDictionary *nDict=[NSDictionary dictionaryWithObjectsAndKeys:pid,@"pid",WebApi_CloudCooperationProjectdel,@"url", nil];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationProjectParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Edit_Info_Project, nDict);
        });
    }

}

#pragma mark 完成项目
- (void)projectFinsh:(NSMutableDictionary*)dataDic{
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    if ([contextDict isEqualToString:@"1"]){
        
        NSDictionary *getDict = [dataDic objectForKey:WebApi_DataSend_Get];
        
        NSString *pid = [getDict objectForKey:@"prid"];
        
        NSDictionary *nDict=[NSDictionary dictionaryWithObjectsAndKeys:pid,@"pid",WebApi_CloudCooperationProjectFinsh,@"url", nil];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationProjectParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Edit_Info_Project, nDict);
        });
    }

}

#pragma mark 进行项目
- (void)projectRuning:(NSMutableDictionary*)dataDic{
//    NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
    
    if ([contextDict isEqualToString:@"1"]){
        
        NSDictionary *getDict = [dataDic objectForKey:WebApi_DataSend_Get];
        
        NSString *pid = [getDict objectForKey:@"prid"];
        
        NSDictionary *nDict=[NSDictionary dictionaryWithObjectsAndKeys:pid,@"pid",WebApi_CloudCooperationProjectRuning,@"url", nil];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationProjectParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Edit_Info_Project, nDict);
        });
    }

}

#pragma mark 项目全部任务列表  
- (void)projectAllTaskListParse:(NSMutableDictionary*)dataDic{
    
    NSMutableArray *taskListArr=[NSMutableArray array];
    NSMutableArray *adminsArr=[NSMutableArray array];
    NSMutableArray *contextArr  = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    for (NSDictionary *dict in contextArr) {
        CoTaskModel *listObject=[[CoTaskModel alloc]init];
        [listObject serializationWithDictionary:dict];
        listObject.cid =listObject.tid;
        
        NSDictionary *admins=[dict objectForKey:@"admins"];
        CoMemberModel *mModel=[[CoMemberModel alloc]init];
        [mModel serializationWithDictionary:admins];
        listObject.face=mModel.face;
        [taskListArr addObject:listObject];
        [adminsArr addObject:mModel];
    }
    
    [[CoTaskDAL shareInstance]addDataWithArray:taskListArr];
    [[CoMemberDAL shareInstance]addDataWithArray:adminsArr];
    NSDictionary *getDict=[dataDic objectForKey:WebApi_DataSend_Get];
    NSString *pid = [getDict objectForKey:@"prid"];
    
    NSDictionary *nDict=[NSDictionary dictionaryWithObjectsAndKeys:pid,@"pid",taskListArr,@"data", nil];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationProjectParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_All_Task_Project, nDict);
    });
}


// 获取一级文件列表
-(void)parseResourceList:(NSMutableDictionary*)dataDic {
    NSMutableArray *folderAllArray = [[NSMutableArray alloc] init];
    NSMutableArray *fileAllArray = [[NSMutableArray alloc] init];
    NSDictionary *contextDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    // 一级文件夹
    NSArray *folderArray = [contextDic objectForKey:@"children"];
    // 一级文件目录
    NSArray *fileArray = [contextDic objectForKey:@"resourcemodels"];
    // 父文件夹
    ResFolderModel *rootFolder = [[ResFolderModel alloc] init];
    [rootFolder serializationWithDictionary:contextDic];
    NSString *classid = [contextDic objectForKey:@"id"];
    NSString *description = [contextDic objectForKey:@"description"];
    rootFolder.classid = classid;
    rootFolder.descript = description;
    
    // 把根文件夹加到数组
    [folderAllArray addObject:rootFolder];
    // 文件夹
    for (int i = 0; i < [folderArray count]; i++) {
        ResFolderModel *folder = [[ResFolderModel alloc] init];
        NSDictionary *folderDic = folderArray[i];
        [folder serializationWithDictionary:folderDic];
        
        NSString *classid = [folderDic objectForKey:@"id"];
        NSString *description = [folderDic objectForKey:@"description"];
        folder.classid = classid;
        folder.descript = description;
        folderRpid = folder.rpid;
        parentid = folder.parentid;
        [folderAllArray addObject:folder];
    }
    // 文件
    ResModel *file = nil;
    for (int i = 0; i < fileArray.count; i++) {
        file = [[ResModel alloc] init];
        NSDictionary *fileDic = fileArray[i];
        [file serializationWithDictionary:fileDic];
        file.descript = [fileDic objectForKey:@"description"];
        
        [fileAllArray addObject:file];
    }
    // 得到一级文件夹包括根文件目录
    [[ResFolderDAL shareInstance] addDataWithArray:folderAllArray];
    // 得到一级文件目录
    [[ResDAL shareInstance] addDataWithArray:fileAllArray];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:folderAllArray forKey:@"folder"];
    [dic setObject:fileAllArray forKey:@"file"];
    [dic setObject:[NSNumber numberWithInteger:fileAllArray.count] forKey:@"fileNum"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationProjectParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParse_FileList, rootFolder);
    });
}
// 下级文件解析
-(void)parseNextResourceList:(NSMutableDictionary*)dataDic {
    
    NSMutableArray *folderAllArray = [[NSMutableArray alloc] init];
    NSMutableArray *fileAllArray = [[NSMutableArray alloc] init];
    NSDictionary *contextDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    // 一级文件夹
    NSArray *folderArray = [contextDic objectForKey:@"children"];
    // 一级文件目录
    NSArray *fileArray = [contextDic objectForKey:@"resourcemodels"];
    // 父文件夹
    ResFolderModel *rootFolder = [[ResFolderModel alloc] init];
    [rootFolder serializationWithDictionary:contextDic];
    NSString *classid = [contextDic objectForKey:@"id"];
    NSString *description = [contextDic objectForKey:@"description"];
    rootFolder.classid = classid;
    rootFolder.descript = description;
    
    // 把根文件夹加到数组
    [folderAllArray addObject:rootFolder];
    // 文件夹
    for (int i = 0; i < [folderArray count]; i++) {
        ResFolderModel *folder = [[ResFolderModel alloc] init];
        NSDictionary *folderDic = folderArray[i];
        [folder serializationWithDictionary:folderDic];
        
        NSString *classid = [folderDic objectForKey:@"id"];
        NSString *description = [folderDic objectForKey:@"description"];
        folder.classid = classid;
        folder.descript = description;
        folderRpid = folder.rpid;
        parentid = folder.parentid;
        [folderAllArray addObject:folder];
    }
    // 文件
    for (int i = 0; i < fileArray.count; i++) {
        ResModel *file = [[ResModel alloc] init];
        NSDictionary *fileDic = fileArray[i];
        [file serializationWithDictionary:fileDic];
        file.descript = [fileDic objectForKey:@"description"];
        
        [fileAllArray addObject:file];
    }
    // 得到一级文件夹包括根文件目录
    [[ResFolderDAL shareInstance] addDataWithArray:folderAllArray];
    // 得到一级文件目录
    [[ResDAL shareInstance] addDataWithArray:fileAllArray];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationProjectParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskParse_FileList, rootFolder);
    });
    
}
-(void)parseAddFolder:(NSMutableDictionary*)dataDic {
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSDictionary *dataGet = [dataDic objectForKey:WebApi_DataSend_Get];
    // 加资源池id
    NSString *rpid = [dataGet objectForKey:@"rpid"];
    ResFolderModel *folder = [[ResFolderModel alloc] init];
    [folder serializationWithDictionary:contextDic];
    folder.rpid = rpid;
    NSString *classid = [contextDic objectForKey:@"id"];
    NSString *description = [contextDic objectForKey:@"description"];
    folder.classid = classid;
    folder.descript = description;
    
    [[ResFolderDAL shareInstance] addDataWithResFolderModel:folder];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block CooperationProjectParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, folder);
    });
 }
// 删除文件夹
-(void)parseDeleteFolder:(NSMutableDictionary*)dataDic {
    
    NSNumber *dataContext = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSDictionary *postData = [dataDic objectForKey:WebApi_DataSend_Post];
    
    NSInteger isSuccess = [dataContext integerValue];
    NSString *classid = [postData objectForKey:@"id"];
    if (isSuccess) {
        [[ResFolderDAL shareInstance] deleteFolderWithClassid:classid];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationProjectParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskFile_DelFolder, classid);
    });
}
// 删除文件
-(void)parseDeleteFile:(NSMutableDictionary*)dataDic {
    NSNumber *dataContext = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSInteger isSuccess = [dataContext integerValue];
    
    NSString *fileid = [dataDic objectForKey:WebApi_DataSend_Post];
    
    if (isSuccess) {
        [[ResDAL shareInstance] deleteResWithRid:fileid];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationProjectParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskFile_DelFile, fileid);
    });
}
// 批量删除
-(void)parseMixRemoveData:(NSMutableDictionary*)dataDic {
    
    NSNumber *contextData = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSInteger isSuccess = [contextData integerValue];
    NSDictionary *dataPost = [dataDic objectForKey:WebApi_DataSend_Post];
    
    if (isSuccess) {
        if ([[dataPost objectForKey:@"folderids"] isEqualToString:@""]) {
            // 文件删除
            [[ResDAL shareInstance] deleteResWithRid:[dataPost objectForKey:@"resourceids"]];
        }
        if ([[dataPost objectForKey:@"resourceids"] isEqualToString:@""]) {
            [[ResFolderDAL shareInstance] deleteFolderWithClassid:[dataPost objectForKey:@"folderids"]];
        }
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationProjectParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskFile_DelFile, nil);
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskFile_DelFolder, nil);
    });
}
// 文件夹重命名
-(void)parseEditFolderName:(NSMutableDictionary*)dataDic {
    
    NSMutableDictionary *contextDic  = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    
    ResFolderModel *resFolderModel = [[ResFolderModel alloc] init];
    [resFolderModel serializationWithDictionary:contextDic];
    NSString *classid = [contextDic objectForKey:@"id"];
    NSString *description = [contextDic objectForKey:@"description"];
    resFolderModel.classid = classid;
    resFolderModel.descript = description;
    
    // 更新数据库
    [[ResFolderDAL shareInstance] updataFolderName:resFolderModel.name andDescription:resFolderModel.descript withClassid:resFolderModel.classid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationProjectParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskFile_RenameFolder, resFolderModel);
    });
}
// 文件重命名
-(void)parseResourceName:(NSMutableDictionary*)dataDic {
    
    NSMutableDictionary *contextDic  = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    
    ResModel *resfileModel = [[ResModel alloc] init];
    [resfileModel serializationWithDictionary:contextDic];
    resfileModel.descript = [contextDic objectForKey:@"description"];
    /* 更新数据库 */
    [[ResDAL shareInstance] updateResFileName:resfileModel.name withRid:resfileModel.rid];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationProjectParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskFile_RenamrFile, resfileModel);
    });
  }

// 文件、文件夹移动
-(void)parseMove:(NSMutableDictionary*)dataDic {
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSDictionary *dataPost = [dataDic objectForKey:WebApi_DataSend_Post];
    
    
    if ([[dataPost objectForKey:@"resourceids"] isEqualToString:@""]) {
        NSMutableArray *allRwsFolderArr = [[NSMutableArray alloc] init];
        NSMutableArray *folderModels = [contextDic objectForKey:@"foldermodels"];
        [self analyseMoveSource:folderModels withArray:allRwsFolderArr];
        // 更新移动过的文件夹
        [[ResFolderDAL shareInstance] addDataWithArray:allRwsFolderArr];
        
    }
    if ([[dataPost objectForKey:@"folderids"] isEqualToString:@""]) {
        ResModel *fileModel = [[ResModel alloc] init];
        NSMutableArray *resourceModels = [contextDic objectForKey:@"resourcemodels"];
        for (int i = 0; i < resourceModels.count; i ++) {
            
            NSDictionary *fileDic = [resourceModels objectAtIndex:i];
            
            [fileModel serializationWithDictionary:fileDic];
            fileModel.descript = [fileDic objectForKey:@"description"];
            
            /* 通过文件的rid 修改数据库里面的classID */
            [[ResDAL shareInstance] updateFileClassid:fileModel];
        }
        
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationProjectParse *service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_MoveFileController_Success, nil);
    });    
}
-(void)analyseMoveSource:(NSMutableArray *)contextArray withArray:(NSMutableArray *)allRwsFolderArr{
    
    for (int i = 0; i < contextArray.count; i++) {
        NSDictionary *folderDic = [contextArray objectAtIndex:i];
        ResFolderModel *folder = [[ResFolderModel alloc] init];
        
        [folder serializationWithDictionary:folderDic];
        NSString *classid = [folderDic objectForKey:@"id"];
        NSString *description = [folderDic objectForKey:@"description"];
        folder.classid = classid;
        folder.descript = description;
        
        [allRwsFolderArr addObject:folder];
        
        NSMutableArray *childArray = [folderDic objectForKey:@"children"];
        if (childArray != nil && [childArray count] > 0 ) {
            [self analyseMoveSource:childArray withArray:allRwsFolderArr];
        }
    }
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
