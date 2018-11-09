//
//  ImGroupParse.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/26.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2015-12-26
 Version: 1.0
 Description: 解析群组数据
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ImGroupParse.h"
#import "ImGroupUserModel.h"
#import "ImGroupUserDAL.h"
#import "ImGroupModel.h"
#import "ImGroupDAL.h"
#import "ImRecentModel.h"
#import "AppDateUtil.h"
#import "ImRecentDAL.h"
#import "NSString+IsNullOrEmpty.h"
#import "SDWebImageManager.h"
#import "FilePathUtil.h"
#import "NSDictionary+DicSerial.h"
#import "NSArray+ArraySerial.h"
#import "CoExtendTypeModel.h"
#import "CoExtendTypeDAL.h"
#import "SysApiVersionDAL.h"
#import "ImGroupRobotInfoModel.h"
#import "ImGroupRobotInfoDAL.h"
#import "ImGroupRobotWeatherDAL.h"
#import "ImGroupRobotWeatherModel.h"

@implementation ImGroupParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImGroupParse *)shareInstance{
    static ImGroupParse *instance = nil;
    if (instance == nil) {
        instance = [[ImGroupParse alloc] init];
    }
    return instance;
}

#pragma mark - 解析webapi请求的数据

/**
 *  解析数据
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parse:(NSMutableDictionary *)dataDic{
    NSString *route = [dataDic objectForKey:WebApi_Route];
    
    /* 获取群组列表 */
    if([route isEqualToString:WebApi_ImGroup_GetGroupList]){
        [self parseGetGroupList:dataDic];
    }
    /* 获取群组列表-分页 */
    else if([route isEqualToString:WebApi_ImGroup_GetGroupListByPages]){
        [self parseGetGroupListPages:dataDic];
    }
    /* 分页获取群人员 */
    else if([route isEqualToString:WebApi_ImGroup_GetGroupUsersByPages]){
        [self parseGetGroupUsersByPages:dataDic];
    }
    /* 获取群组信息 */
    else if([route isEqualToString:WebApi_ImGroup_GetGroupInfoByPages]){
        [self parseGetGroupInfoByPages:dataDic];
    }
    //得到 igid 聊天
    else if([route isEqualToString:WebApi_ImGroup_Info_Relateid]){
        [self parseGetGroupInfoByReleateId:dataDic];
    }
    /* 添加完群组之后的回调 */
    else if([route isEqualToString:WebApi_ImGroup_AddGroup]){
        [self parseAddGroup:dataDic];
    }
    /* 消息免打扰 */
    else if( [route isEqualToString:WebApi_ImGroup_UpdateMsgRole] ){
        [self parseUpdateMsgRole:dataDic];
    }
    /* 群聊保存通讯录 */
    else if ([route isEqualToString:WebApi_ImGroup_IsSaveToAddress]) {
        [self parseUpdateSaveAddress:dataDic];
    }
    /* 添加群成员 */
    else if( [route isEqualToString:WebApi_ImGroup_AddMember] ){
        [self parseAddMember:dataDic];
    }
    /* 移除群成员 */
    else if( [route isEqualToString:WebApi_ImGroup_RemoveMember] ){
        [self parseRemoveMember:dataDic];
    }
    /* 删除并退出 */
    else if ( [route isEqualToString:WebApi_ImGroup_QuitGroup] ){
        [self parseQuitGroup:dataDic];
    }
    /* 删除并退出（业务会话） */
    else if ( [route isEqualToString:WebApi_BusinessSession_Recent_Quitgroup] ){
        [self parseQuitGroup:dataDic];
    }
    /* 修改群组名称 */
    else if ( [route isEqualToString:WebApi_ImGroup_ModifyGroupName] ){
        [self parseModifyGroupName:dataDic];
    }
    /* 修改群组名称（业务会话） */
    else if ( [route isEqualToString:WebApi_BusinessSession_Recent_Changename] ){
        [self parseModifyGroupNameForBusiness:dataDic];
    }
    /* 转让群管理员 */
    else if( [route isEqualToString:WebApi_ImGroup_AssignAdmin] ){
        [self parseAssignAdmin:dataDic];
    }
    /* 获取组群基本信息 */
    else if( [route isEqualToString:WebApi_ImGroup_GetGroupBaseInfo] ){
        [self parseGetGroupBaseInfo:dataDic];
    }
    /* 申请加入组群 */
    else if( [route isEqualToString:WebApi_ImGroup_ApplyJoinGroup] ){
        [self parseApplyJoinGroup:dataDic];
    }
    /* 查找群组用户 */
    else if ([route isEqualToString:WebApi_ImGroup_SearchGroupUser]) {
        [self parseSearchGroupUser:dataDic];
    }
    else if ([route isEqualToString:WebApi_CooperationExtendtype_GetAllConfig]) {
        [self parseGetAllConfigByDevice:dataDic];
    }
    else if ([route isEqualToString:WebApi_ImGroup_UpdateGroupIsLoadMsg]) {
        [self parseUpdateGroupIsLoadMsg:dataDic];
    }
    /* 显示绑定的群组的群主 */
    else if ([route isEqualToString:WebApi_ImGroup_GetCreateUserIdByGroupIdOrRelateId]){
        [self parseGetCreateUserIdByGroupIdOrRelateId:dataDic];
    }
    /* 设置绑定的群组的群主 */
    else if ([route isEqualToString:WebApi_ImGroup_SetImGroupByRelateId]){
        [self parseSetImGroupByRelateId:dataDic];
    }
    /* 根据消息群组ID获取该群组内机器人列表  */
    else if ([route isEqualToString:WebApi_ImGroup_GetGroupRobot]) {
        [self parseGetGroupRobot:dataDic];
    }
    /* 获取所有机器人信息 */
    else if ([route isEqualToString:WebApi_ImGroup_GetRobot]) {
        [self parseGetRobot:dataDic];
    }
    /* 获取单个机器人信息 */
    else if ([route isEqualToString:WebApi_ImGroup_GetRobotFoRid]) {
        [self parseGetRobotForRiid:dataDic];
    }
    /* 查机器人信息 */
    else if ([route isEqualToString:WebApi_WeatherRobot_GetWeatherRobotExample]) {
        [self parseGetWeatherRobotExample:dataDic];
    }
    /* 增机器人信息 */
    else if ([route isEqualToString:WebApi_WeatherRobot_AddWeatherRobotExample]) {
        [self parseAddWeatherRobotExample:dataDic];
    }
    /* 改机器人信息 */
    else if ([route isEqualToString:WebApi_WeatherRobot_UpdateWeatherRobotExample]) {
        [self parseUpdateWeatherRobotExample:dataDic];
    }
    /* 删机器人信息 */
    else if ([route isEqualToString:WebApi_WeatherRobot_DeleteWeatherRobotExample]) {
        [self parseDeleteWeatherRobotExample:dataDic];
    }
    /* 根据定时推送的天气预报的城市获取近三天的天气信息 */
    else if ([route isEqualToString:WebApi_WeatherRobot_GetDailyForecastWeathers]) {
        
    }
}

/**
 *  解析我的群组数据 (得到群组信息已经不使用这个了)
 */
-(void)parseGetGroupList:(NSMutableDictionary *)dataDic{
    NSMutableArray *dataArray  = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    
    NSMutableArray *allImGroupArr = [[NSMutableArray alloc] init];
    NSMutableArray *allImGroupUserArr = [[NSMutableArray alloc] init];
    for(int i=0;i<dataArray.count;i++){
        NSDictionary *dataDic = [dataArray objectAtIndex:i];
        ImGroupModel *imGroupModel = [[ImGroupModel alloc] init];
        [imGroupModel serializationWithDictionary:dataDic];

        /* 解析群组人员信息 */
        NSArray *groupusers = [dataDic lzNSArrayForKey:@"groupuser"];
        for(int j=0;j<groupusers.count;j++){
            NSDictionary *dataUserDic = [groupusers objectAtIndex:j];
            
            ImGroupUserModel *imGroupUserName= [[ImGroupUserModel alloc] init];
            [imGroupUserName serializationWithDictionary:dataUserDic];
            
            [allImGroupUserArr addObject:imGroupUserName];
        }
        
        [allImGroupArr addObject:imGroupModel];
    }
    
    /* 清空所有群组信息(除任务组外) */
    [[ImGroupDAL shareInstance] deleteAllShowGroup];
    
    [[ImGroupDAL shareInstance] addDataWithImGroupArray:allImGroupArr];
    [[ImGroupUserDAL shareInstance] addDataWithImGroupUserArray:allImGroupUserArr];
}

/**
 *  解析我的群组数据-分页
 */
-(void)parseGetGroupListPages:(NSMutableDictionary *)dataDic{
    NSMutableArray *dataArray  = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    
    NSMutableArray *allImGroupArr = [[NSMutableArray alloc] init];
    NSMutableArray *allImGroupUserArr = [[NSMutableArray alloc] init];
    for(int i=0;i<dataArray.count;i++){
        NSDictionary *dataDic = [dataArray objectAtIndex:i];
        ImGroupModel *imGroupModel = [[ImGroupModel alloc] init];
        [imGroupModel serializationWithDictionary:dataDic];
        imGroupModel.isshowinlist = 1;
        imGroupModel.isnottemp = 1;
        
        /* 解析群组人员信息 */
        NSArray *groupusers = [dataDic lzNSArrayForKey:@"groupuser"];
        for(int j=0;j<groupusers.count;j++){
            NSDictionary *dataUserDic = [groupusers objectAtIndex:j];
            
            ImGroupUserModel *imGroupUserName= [[ImGroupUserModel alloc] init];
            [imGroupUserName serializationWithDictionary:dataUserDic];
            
            [allImGroupUserArr addObject:imGroupUserName];
        }
        
        [allImGroupArr addObject:imGroupModel];
    }
    
    /* 清空所有群组信息(除任务组外) */
    [[ImGroupDAL shareInstance] deleteAllShowGroup];
    
    [[ImGroupDAL shareInstance] addDataWithImGroupArray:allImGroupArr];
    /* 将没有获取到的群聊状态改成临时的 */
    [[ImGroupDAL shareInstance] updateOtherGroupWithTempStatus];
    [[ImGroupUserDAL shareInstance] addDataWithImGroupUserArray:allImGroupUserArr];
    
    /* 登录时请求成功后，更新ImRecent表中人员信息 */
    NSMutableDictionary *otherData = [dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Other];
    NSString *showError = [otherData lzNSStringForKey:WebApi_DataSend_Other_ShowError];
    if([showError isEqualToString:WebApi_DataSend_Other_SE_NotShowAll]){
        [[ImRecentDAL shareInstance] updateAllLastMsgUsernam];
    }
    
    /* 更新SysApiVersion */
    [[SysApiVersionDAL shareInstance] updateServerVersionToClientVersionWithCode:LogoinWebApi_api_imgroup_getgrouplistbypages_S9];
    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ImGroupParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_GetGroupListByPages, dataDic);
        EVENT_PUBLISH_WITHDATA(service, EventBus_SendFirstLaunchPercentage, nil);
    });
}

/**
 *  分页获取群人员信息
 */
-(void)parseGetGroupUsersByPages:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *dataContextDic  = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableArray *dataArray = [dataContextDic objectForKey:@"searchresult"];
    
    NSMutableArray *allImGroupUserArr = [[NSMutableArray alloc] init];
    for(int j=0;j<dataArray.count;j++){
        NSDictionary *dataUserDic = [dataArray objectAtIndex:j];
        
        ImGroupUserModel *imGroupUserName= [[ImGroupUserModel alloc] init];
        [imGroupUserName serializationWithDictionary:dataUserDic];
        
        [allImGroupUserArr addObject:imGroupUserName];
    }

    [[ImGroupUserDAL shareInstance] addDataWithImGroupUserArray:allImGroupUserArr];
    
    NSDictionary *otherData  = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSString *otherOperate  = [otherData lzNSStringForKey:WebApi_DataSend_Other_Operate];

    /* 附带的其它信息处理 */
    if(![NSString isNullOrEmpty:otherOperate]){
        /* 聊天界面，获取群人员 */
        if( [otherOperate isEqualToString:@"nooperate"]) {
            return;
        }
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ImGroupParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_GetGroupUsersByPages, [dataContextDic objectForKey:@"groupid"]);
    });
}

/**
 *  解析单个群组数据
 */
-(void)parseGetGroupInfoByPages:(NSMutableDictionary *)dataDic{
    
    NSDictionary *groupInfoDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    
    NSDictionary *otherData  = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSString *otherOperate  = [otherData lzNSStringForKey:WebApi_DataSend_Other_Operate];

    NSString *igid = [groupInfoDic lzNSStringForKey:@"igid"];
    
    
    NSMutableArray *allImGroupUserArr = [[NSMutableArray alloc] init];
    
    ImGroupModel *imGroupModel = [[ImGroupModel alloc] init];
    [imGroupModel serializationWithDictionary:groupInfoDic];
    DDLogVerbose(@"------------------3333333%@",groupInfoDic);
    imGroupModel.groupresource = [[groupInfoDic lzNSDictonaryForKey:@"groupresource"] dicSerial];
    imGroupModel.imgrouprobots = [[groupInfoDic lzNSMutableArrayForKey:@"imgrouprobots"] arraySerial];
    /* 解析群组人员信息 */
    NSArray *groupusers = [groupInfoDic lzNSArrayForKey:@"groupuser"];
    for(int j=0;j<groupusers.count;j++){
        NSDictionary *dataUserDic = [groupusers objectAtIndex:j];

        ImGroupUserModel *imGroupUserName= [[ImGroupUserModel alloc] init];
        [imGroupUserName serializationWithDictionary:dataUserDic];
        
        [allImGroupUserArr addObject:imGroupUserName];
    }

    /* 成功获取到群信息的时候，状态都是正式的 */
    imGroupModel.isnottemp = 1;

    if(imGroupModel.imtype==Chat_ContactType_Main_ChatGroup){
        imGroupModel.isshowinlist = imGroupModel.isshow;
    } else {
        imGroupModel.isshowinlist = 0;
    }
    /* 删除此群组，避免人员出错 */
    [[ImGroupDAL shareInstance] deleteGroupWithIgid:imGroupModel.igid isDeleteImRecent:NO];
    
    [[ImGroupDAL shareInstance] addImGroupModel:imGroupModel];
    [[ImGroupUserDAL shareInstance] addDataWithImGroupUserArray:allImGroupUserArr];

    /* 获取群组信息，更新最近联系人使用 */
    if(![NSString isNullOrEmpty:otherOperate] && [otherOperate isEqualToString:@"update_imrecent"]){
        NSMutableDictionary *postDic  = (NSMutableDictionary *)[dataDic objectForKey:WebApi_DataSend_Post];
        NSString *contactid = [postDic objectForKey:@"groupid"];
        [[ImRecentDAL shareInstance] updateContactNameAndRelattypeAndFace:contactid];
        self.appDelegate.lzGlobalVariable.chatDialogID = contactid;
        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
    }
    
    /* 扫描二维码，加入群组 */
    if(![NSString isNullOrEmpty:otherOperate] && [otherOperate isEqualToString:@"getgroupinfoforscan"]){
        [[ImRecentDAL shareInstance] updateContactNameAndRelattypeAndFace:imGroupModel.igid];
        self.appDelegate.lzGlobalVariable.chatDialogID = imGroupModel.igid;
        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            __block ImGroupParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_ApplyJoinGroup, nil);
        });
        return;
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ImGroupParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_GetGroupInfo, igid);
    });
}

/**
 *  获取某个群组的信息(包含当前群组人数和当前人是否在群组中)
 */
-(void)parseGetGroupBaseInfo:(NSMutableDictionary *)dataDic {
    /* 扫描二维码，获取群组信息 */
    NSDictionary *groupInfoDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSString *igid = nil;
    if ([groupInfoDic count]>0) {
        /* 解析群组信息 */
        NSString *face = [groupInfoDic objectForKey:@"face"];
        NSString *isingroup = [groupInfoDic objectForKey:@"isingroup"];
        NSString *membercount = [groupInfoDic objectForKey:@"membercount"];
        NSString *name = [groupInfoDic objectForKey:@"name"];
        igid = [groupInfoDic objectForKey:@"igid"];
        [dic setObject:face forKey:@"face"];
        [dic setObject:isingroup forKey:@"isingroup"];
        [dic setObject:membercount forKey:@"membercount"];
        [dic setObject:name forKey:@"name"];
        [dic setObject:igid forKey:@"igid"];
    }    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ImGroupParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_Group_ScanJoin, dic);
    });
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ImGroupParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_GetGroupBaseInfo, igid);
    });
}

/**
 *  解析根据releatedid获取单个群组数据
 */
-(void)parseGetGroupInfoByReleateId:(NSMutableDictionary *)dataDic{
    NSDictionary *context=[dataDic lzNSDictonaryForKey:WebApi_DataContext];
    
    ImGroupModel *imGroupModel = [[ImGroupModel alloc] init];
    
    [imGroupModel serializationWithDictionary:context];
    imGroupModel.groupresource = [[context lzNSDictonaryForKey:@"groupresource"] dicSerial];
    imGroupModel.imgrouprobots = [[context lzNSMutableArrayForKey:@"imgrouprobots"] arraySerial];
    
    DDLogVerbose(@"------------------3333333000000000%@",context);
    NSMutableArray *allImGroupUserArr=[NSMutableArray array];
    
    /* 解析群组人员信息 */
    NSArray *groupusers = [context lzNSArrayForKey:@"groupuser"];
    for(int j=0;j<groupusers.count;j++){
        NSDictionary *dataUserDic = [groupusers objectAtIndex:j];
        
        ImGroupUserModel *imGroupUserName= [[ImGroupUserModel alloc] init];
        [imGroupUserName serializationWithDictionary:dataUserDic];
        
        [allImGroupUserArr addObject:imGroupUserName];
    }
    
    NSDictionary *otherdata = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    /* 获取失败时处理 */
    if([NSString isNullOrEmpty:imGroupModel.igid]){
        
        WebApiSendBackBlock backBlock = [otherdata objectForKey:@"opencooperationchatview"];
        if(backBlock){
            NSMutableDictionary *backData = [[NSMutableDictionary alloc] init];
            [backData setObject:@"" forKey:@"igid"];
            backBlock(backData);
        }
        
        return;
    }
//    if (imGroupModel.isnottemp == 0) {
    imGroupModel.isnottemp=1;
    if(imGroupModel.imtype==Chat_ContactType_Main_ChatGroup){
        imGroupModel.isshowinlist = imGroupModel.isshow;
    } else {
        imGroupModel.isshowinlist = 0;
    }
    /* 删除此群组，避免人员出错 */
    [[ImGroupDAL shareInstance] deleteGroupWithIgid:imGroupModel.igid isDeleteImRecent:NO];
    
    [[ImGroupDAL shareInstance] addImGroupModel:imGroupModel];
    [[ImGroupUserDAL shareInstance] addDataWithImGroupUserArray:allImGroupUserArr];
//    }
    
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:imGroupModel.relateid,@"cid",imGroupModel.igid,@"igid", nil];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ImGroupParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Get_igid, dict);
        
        NSDictionary *otherdata=[dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
        WebApiSendBackBlock backBlock = [otherdata objectForKey:@"opencooperationchatview"];
        if(backBlock){
            NSMutableDictionary *backData = [[NSMutableDictionary alloc] init];
            [backData setObject:imGroupModel.igid forKey:@"igid"];
            backBlock(backData);
        }
    });
}

/**
 *  解析添加群组
 */
-(void)parseAddGroup:(NSMutableDictionary *)dataDic{
    NSDictionary *groupInfoDic  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    
    NSMutableArray *allImGroupUserArr = [[NSMutableArray alloc] init];
    
    ImGroupModel *imGroupModel = [[ImGroupModel alloc] init];
    [imGroupModel serializationWithDictionary:groupInfoDic];
    
    /* 解析群组人员信息 */
    NSArray *groupusers = [groupInfoDic lzNSArrayForKey:@"groupuser"];
    for(int j=0;j<groupusers.count;j++){
        NSDictionary *dataUserDic = [groupusers objectAtIndex:j];
        
        ImGroupUserModel *imGroupUserName= [[ImGroupUserModel alloc] init];
        [imGroupUserName serializationWithDictionary:dataUserDic];
        
        [allImGroupUserArr addObject:imGroupUserName];
    }
    
    imGroupModel.isnottemp = 1;
    if(imGroupModel.imtype==Chat_ContactType_Main_ChatGroup){
        imGroupModel.isshowinlist = imGroupModel.isshow;
    } else {
        imGroupModel.isshowinlist = 0;
    }
    
    /* 删除此群组，避免人员出错 */
    [[ImGroupDAL shareInstance] deleteGroupWithIgid:imGroupModel.igid isDeleteImRecent:NO];
    if(imGroupModel.usercount==0){
        imGroupModel.usercount = allImGroupUserArr.count;
    }
    
    [[ImGroupDAL shareInstance] addImGroupModel:imGroupModel];
    [[ImGroupUserDAL shareInstance] addDataWithImGroupUserArray:allImGroupUserArr];
    
    /* 向最近联系人中添加 */
    ImRecentModel *imRecentModel = [[ImRecentModel alloc] init];
    imRecentModel.irid = [LZUtils CreateGUID];
    imRecentModel.contactid = imGroupModel.igid;
    imRecentModel.contacttype = Chat_ContactType_Main_ChatGroup;
    imRecentModel.contactname = imGroupModel.name;
    imRecentModel.face = imGroupModel.face;

    imRecentModel.lastdate = [AppDateUtil GetCurrentDate];
    imRecentModel.lastmsg = @""; //@"群组创建成功";
    imRecentModel.lastmsguser = @"";
    imRecentModel.lastmsgusername = @"";
    imRecentModel.badge = 0;
    imRecentModel.isexistsgroup = 1;
    
    [[ImRecentDAL shareInstance] addImRecentWithModel:imRecentModel isAddIfExists:NO];
    self.appDelegate.lzGlobalVariable.chatDialogID = imGroupModel.igid;
    self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
    
    /* 通知窗口 */
    __block ImGroupParse * service = self;

    NSMutableDictionary *backData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:imGroupModel.igid,@"igid",[[dataDic lzNSDictonaryForKey:WebApi_DataSend_Other] lzNSStringForKey:WebApi_DataSend_Other_Operate],@"other",nil];
    [backData setObject:imGroupModel.name forKey:@"name"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_ImGroup_Add, backData);
    });
}

/**
 *  解析开启免打扰
 */
-(void)parseUpdateMsgRole:(NSMutableDictionary *)dataDic{
    NSString *result  = [dataDic lzNSStringForKey:WebApi_DataContext];
    NSMutableDictionary *getData = [dataDic objectForKey:WebApi_DataSend_Get];
    
    __block ImGroupParse * service = self;
    if( [result isEqualToString:@"true"]){
        NSString *groupid = [getData objectForKey:@"groupid"];
        NSString *role = [getData objectForKey:@"role"];
        
        [[ImGroupDAL shareInstance] updateDisturbRole:groupid role:role.integerValue];
        self.appDelegate.lzGlobalVariable.chatDialogID = groupid;
        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_Disturb, nil);
        });
    }
    else {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_WebApi_SendFail, (@{@"Code":@"00",@"Message":@"消息免打扰修改失败"}));
        });
    }
}

/**
 保存通讯录

 @param dataDic
 */
- (void)parseUpdateSaveAddress:(NSMutableDictionary *)dataDic {
    NSString *result = [dataDic lzNSStringForKey:WebApi_DataContext];
    NSMutableDictionary *getData = [dataDic objectForKey:WebApi_DataSend_Get];
    __block ImGroupParse * service = self;
    if ([result isEqualToString:@"true"]) {
        NSString *groupid = [getData lzNSStringForKey:@"groupid"];
        NSString *show = [getData lzNSStringForKey:@"show"];
        
        [[ImGroupDAL shareInstance] updateIsSaveToAddress:groupid show:show.integerValue];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_SaveToAddress, nil);
        });
    } else {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_WebApi_SendFail, (@{@"Code":@"00",@"Message":@"保存通讯录修改失败"}));
        });
    }
}

/**
 *  添加群成员
 */
-(void)parseAddMember:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *resultDataContext  = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableDictionary *getData = [dataDic objectForKey:WebApi_DataSend_Get];
//    NSMutableDictionary *postData = [dataDic objectForKey:WebApi_DataSend_Post];
    
    /* 新加的人员 */
    NSMutableArray *allImGroupUserArr = [[NSMutableArray alloc] init];
    NSMutableArray *result = [resultDataContext lzNSMutableArrayForKey:@"addusers"];
    for(int i=0;i<result.count;i++){
        NSMutableDictionary *dic = [result objectAtIndex:i];
        
        ImGroupUserModel *imGroupUser= [[ImGroupUserModel alloc] init];
        [imGroupUser serializationWithDictionary:dic];
        
        [allImGroupUserArr addObject:imGroupUser];
    }
    
    NSString *groupid = [getData objectForKey:@"groupid"];
    NSString *groupName = [resultDataContext lzNSStringForKey:@"groupname"];

    /* 数据库中添加人员 */
    if([[ImGroupDAL shareInstance] checkIsLoadAllUser:groupid]){
        [[ImGroupUserDAL shareInstance] addDataWithImGroupUserArray:allImGroupUserArr];
    }
    else {
        DDLogVerbose(@"本地人员未加载完，不添加人员");
    }
    [[ImGroupDAL shareInstance] updateGroupUserForAddCount:allImGroupUserArr.count igid:groupid];
    
    /* 修改群名称 */
    if( ![NSString isNullOrEmpty:groupName] ){
        /* 更新群组名称 */
        [[ImGroupDAL shareInstance] updateGroupNameWithIgid:groupid groupName:groupName isRename:NO];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ImGroupParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_AddMember, groupid);
    });
    self.appDelegate.lzGlobalVariable.chatDialogID = groupid;
    self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;

}

/**
 *  移除群成员
 */
-(void)parseRemoveMember:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *result  = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    if([result allKeys].count > 0){
        NSMutableDictionary *getData  = [dataDic objectForKey:WebApi_DataSend_Get];
        NSMutableDictionary *postData  = [dataDic objectForKey:WebApi_DataSend_Post];
        NSString *igid = [getData objectForKey:@"groupid"];
        NSString *groupname = [result lzNSStringForKey:@"groupname"];
        NSMutableArray *deleteusers = [postData objectForKey:@"deleteusers"];
        
        for(int i=0;i<deleteusers.count;i++){
            NSString *uid = [deleteusers objectAtIndex:i];
            [[ImGroupUserDAL shareInstance] deleteGroupUserWithIgid:igid uid:uid];
            /* 减去群组中的人员数量 */
            ImGroupModel *imGroupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:igid];
            if( imGroupModel.usercount<=1){
                [[ImGroupDAL shareInstance] updateGroupUserCount:0 igid:igid];
            }
            else {
                [[ImGroupDAL shareInstance] updateGroupUserForReduceCount:1 igid:igid];
            }
        }
        
        /* 修改群名称 */
        if( ![NSString isNullOrEmpty:groupname] ){
            /* 更新群组名称 */
            [[ImGroupDAL shareInstance] updateGroupNameWithIgid:igid groupName:groupname isRename:NO];
        }
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block ImGroupParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_RemoveMember, igid);
        });
        self.appDelegate.lzGlobalVariable.chatDialogID = igid;
        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
    }
    else {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block ImGroupParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_WebApi_SendFail, (@{@"Code":@"00",@"Message":@"群成员删除失败"}));
        });
    }
}

/**
 *  退出群组
 */
-(void)parseQuitGroup:(NSMutableDictionary *)dataDic{
    NSString *result  = [dataDic lzNSStringForKey:WebApi_DataContext];
    NSInteger resultInteger  = [dataDic lzNSNumberForKey:WebApi_DataContext].integerValue;
    NSMutableDictionary *getData  = [dataDic objectForKey:WebApi_DataSend_Get];
    NSString *groupid = [getData objectForKey:@"groupid"];
    
    __block ImGroupParse * service = self;
    if([result isEqualToString:@"true"] || resultInteger==1){
        
        ImGroupModel *imGroupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:groupid];
        /* 删除内存缓存 */
        NSString *faceImgName = [NSString stringWithFormat:@"%@.jpg",imGroupModel.face];
        SDWebImageManager *sharedSmallManager = [SDWebImageManager sharedManager:[FilePathUtil getFaceIconImageSmallDicAbsolutePath]];
        [sharedSmallManager.imageCache removeImageForKey:faceImgName];
        
        
        [[ImGroupDAL shareInstance] deleteGroupWithIgid:groupid isDeleteImRecent:YES];
        self.appDelegate.lzGlobalVariable.chatDialogID = groupid;
        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_DeleteGroup, groupid);
        });
    }
    else {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_WebApi_SendFail, (@{@"Code":@"00",@"Message":@"退出群组失败"}));
        });
        self.appDelegate.lzGlobalVariable.chatDialogID = groupid;
        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
    }
}

/**
 *  修改群组名称
 */
-(void)parseModifyGroupName:(NSMutableDictionary *)dataDic{
    NSString *result  = [dataDic lzNSStringForKey:WebApi_DataContext];
    NSMutableDictionary *postDic  = [dataDic objectForKey:WebApi_DataSend_Post];
    
    __block ImGroupParse * service = self;
    if([result isEqualToString:@"true"]){
        /* 在消息中处理 */
        NSString *igid = [postDic objectForKey:@"igid"];
        NSString *name = [postDic objectForKey:@"name"];
        [[ImGroupDAL shareInstance] updateGroupNameWithIgid:igid groupName:name isRename:YES];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, igid);
        });
    }
}

/**
 *  修改群组名称（业务会话）
 */
-(void)parseModifyGroupNameForBusiness:(NSMutableDictionary *)dataDic{
    NSInteger resultInteger  = [dataDic lzNSNumberForKey:WebApi_DataContext].integerValue;
    NSString *postDate  = [dataDic lzNSStringForKey:WebApi_DataSend_Post];
    NSMutableDictionary *getDic  = [dataDic objectForKey:WebApi_DataSend_Get];
    
    __block ImGroupParse * service = self;
    if(resultInteger==1){
        /* 在消息中处理 */
        NSString *igid = [getDic objectForKey:@"targetid"];
        NSString *name = postDate;
        [[ImGroupDAL shareInstance] updateGroupNameWithIgid:igid groupName:name isRename:YES];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, igid);
        });
    }
}

/**
 *  转让群管理员
 *
 */
-(void)parseAssignAdmin:(NSMutableDictionary *)dataDic{
    NSString *result  = [dataDic lzNSStringForKey:WebApi_DataContext];
    NSMutableDictionary *postDic  = [dataDic objectForKey:WebApi_DataSend_Post];
    
    __block ImGroupParse * service = self;
    if([result isEqualToString:@"true"]){
        /* 在消息中处理 */
        NSString *igid = [postDic objectForKey:@"igid"];
        NSString *createuser = [postDic objectForKey:@"createuser"];
        [[ImGroupDAL shareInstance] updateGroupCreateUser:createuser groupid:igid];

        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_AssignAdmin, igid);
        });
        
        self.appDelegate.lzGlobalVariable.chatDialogID = igid;
        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
    }
}


/**
 *  申请加入群组
 *  @param dataDict
 */
-(void)parseApplyJoinGroup:(NSMutableDictionary *)dataDict{
    NSString *datacontext = [dataDict lzNSStringForKey:WebApi_DataContext];
    
    if([datacontext isEqualToString:@"true"]){
    
        NSString *groupid = [dataDict lzNSStringForKey:WebApi_DataSend_Post];
    
        /* 更新ImRecent表 */
        [[ImRecentDAL shareInstance] updateIsExistsGroupWithIgid:groupid isexistsgroup:1];
        
//        NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
//        [getData setObject:groupid forKey:@"groupid"];
//        [self.appDelegate.lzservice sendToServerForGet:WebApi_ImGroup routePath:WebApi_ImGroup_GetGroupInfo moduleServer:Modules_Message getData:getData otherData:@{WebApi_DataSend_Other_Operate:@"getgroupinfoforscan"}];
        
        NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
        [postData setObject:groupid forKey:@"groupid"];
        [postData setObject:[NSNumber numberWithInteger:200] forKey:@"pagesize"];
        [self.appDelegate.lzservice sendToServerForPost:WebApi_ImGroup routePath:WebApi_ImGroup_GetGroupInfoByPages moduleServer:Modules_Message getData:nil postData:postData otherData:@{WebApi_DataSend_Other_Operate:@"getgroupinfoforscan"}];
    } else {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block ImGroupParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_WebApi_SendFail, (@{@"Code":@"00",@"Message":@"加入群组失败"}));
        });
    }
//    /* 在主线程中发送通知 */
//    dispatch_async(dispatch_get_main_queue(), ^{
//        __block ImGroupParse * service = self;
//        EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_ApplyJoinGroup, datacontext);
//    });    
}

/**
 搜索群组中的用户

 @param dataDict 
 */
-(void)parseSearchGroupUser:(NSMutableDictionary *)dataDict {
    NSArray *dataArr = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i=0; i<dataArr.count; i++) {
        NSDictionary *dic = [dataArr objectAtIndex:i];
        ImGroupUserModel *groupmodel = [[ImGroupUserModel alloc] init];
        groupmodel.username = [dic objectForKey:@"username"];
        groupmodel.quancheng = [[dic objectForKey:@"quancheng"] lowercaseString];
        groupmodel.jiancheng = [[dic objectForKey:@"jiancheng"] lowercaseString];
        groupmodel.face = [dic objectForKey:@"face"];
        groupmodel.uid = [dic objectForKey:@"uid"];
        groupmodel.igid = [dic objectForKey:@"igid"];
        groupmodel.iguid = [dic objectForKey:@"iguid"];
        [arr addObject:groupmodel];
    }    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ImGroupParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_WebApi_SearchGroupUser, arr);
    });
}

- (void)parseGetAllConfigByDevice:(NSMutableDictionary *)dataDict {
    NSDictionary *dict = [dataDict lzNSDictonaryForKey:WebApi_DataContext];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSDictionary *dataDic in [dict allValues]) {
        CoExtendTypeModel *model = [[CoExtendTypeModel alloc] init];
        model.cetid = [dataDic lzNSStringForKey:@"cetid"];
        model.code = [dataDic lzNSStringForKey:@"code"];
        model.name = [dataDic lzNSStringForKey:@"name"];
        model.aliasname = [dataDic lzNSStringForKey:@"aliasname"];
        model.config = [dataDic lzNSStringForKey:@"config"];
        model.des = [dataDic lzNSStringForKey:@"description"];
        model.appcode = [dataDic lzNSStringForKey:@"appcode"];
        [dataArr addObject:model];
    }
    [[CoExtendTypeDAL shareInstance] deleteAllData];
    [[CoExtendTypeDAL shareInstance] addDataWithArray:dataArr];
    
    /* 更新SysApiVersion */
    [[SysApiVersionDAL shareInstance] updateServerVersionToClientVersionWithCode:LogoinWebApi_api_cooperation_extendtype_getallconfig_S11];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ImGroupParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_SendFirstLaunchPercentage, nil);
    });
}

- (void)parseUpdateGroupIsLoadMsg:(NSMutableDictionary *)dataDict {
    NSMutableDictionary *getData = [dataDict objectForKey:WebApi_DataSend_Get];
    NSNumber *returnData  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *returnStr = [returnData stringValue];
    if ([returnStr isEqualToString:@"1"]) {
        NSString *groupid = [getData lzNSStringForKey:@"groupid"];
        NSString *isloadmsg = [getData lzNSStringForKey:@"isloadmsg"];
        /* 聊天会话置顶成功 */
        __block ImGroupParse * service = self;
        
        /* 判断该聊天是否在最近联系人列表，不在的话就先添加到列表 */
        //    BOOL isExist = [[ImRecentDAL shareInstance] checkIsShowRecentWithContactid:recentid];
        //    if (!isExist) {
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"SendMessageAndDeleteMsg" object:nil userInfo:@{@"dialogid":recentid}];
        //    }
        
        [[ImGroupDAL shareInstance] updateIsLoadMsg:groupid state:[isloadmsg isEqualToString:@"true"] ? @"1" :@"0"];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_UpdateGroupIsLoadMsg, nil);
        });
    }
    
}

/**
 显示绑定的群组的群主
 @param dataDict
 */
- (void)parseGetCreateUserIdByGroupIdOrRelateId:(NSMutableDictionary *)dataDict {
    NSString *dataContext = [dataDict lzNSStringForKey:WebApi_DataContext];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ImGroupParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_GetCreateUserIdByGroupIdOrRelateId, dataContext);
    });
}

/**
 设置绑定的群组的群主
 @param dataDict
 */
- (void)parseSetImGroupByRelateId:(NSMutableDictionary *)dataDict {
//    NSNumber *dataContext = [dataDict lzNSNumberForKey:WebApi_DataContext];
//    NSString *dataString = [NSString stringWithFormat:@"%@",dataContext];
    NSDictionary *getData = [dataDict lzNSDictonaryForKey:WebApi_DataSend_Get];
    NSString *uid = [getData lzNSStringForKey:@"createuserid"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ImGroupParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_GetCreateUserIdByGroupIdOrRelateId, uid);
        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_SetImGroupByRelateId, uid);
    });
}

/* 根据消息群组ID获取该群组内机器人列表 */
- (void)parseGetGroupRobot:(NSMutableDictionary *)dataDict {
    NSMutableArray *dataContext = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    NSDictionary *getDic = [dataDict lzNSDictonaryForKey:WebApi_DataSend_Get];
    [[ImGroupDAL shareInstance] updateGroupGroupRobot:[dataContext arraySerial] groupid:[getDic lzNSStringForKey:@"igid"]];

    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ImGroupParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_GetGroupRobot, dataContext);
    });
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshGroupRobot" object:nil];
}
/* 所有机器人列表 */
- (void)parseGetRobot:(NSMutableDictionary *)dataDict {
    NSMutableArray *dataContext = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    
    /* 获取之前先删除 */
    [[ImGroupRobotInfoDAL shareInstance] deleteImGroupRobotInfoModel];
    for (NSDictionary *tmpDic in dataContext) {
        ImGroupRobotInfoModel *groupRobotInfoModel = [[ImGroupRobotInfoModel alloc] init];
        groupRobotInfoModel.name = [tmpDic lzNSStringForKey:@"name"];
        groupRobotInfoModel.icon = [tmpDic lzNSStringForKey:@"icon"];
        groupRobotInfoModel.riid = [tmpDic lzNSStringForKey:@"riid"];
        groupRobotInfoModel.intro = [tmpDic lzNSStringForKey:@"intro"];
        groupRobotInfoModel.appid = [tmpDic lzNSStringForKey:@"appid"];
        groupRobotInfoModel.appcode = [tmpDic lzNSStringForKey:@"appcode"];
        groupRobotInfoModel.iscustomsettint = [[tmpDic lzNSNumberForKey:@"iscustomsettint"] integerValue];
        groupRobotInfoModel.preview = [tmpDic lzNSStringForKey:@"preview"];
        groupRobotInfoModel.messageapi = [tmpDic lzNSStringForKey:@"messageapi"];
        groupRobotInfoModel.templatecode = [tmpDic lzNSStringForKey:@"templatecode"];
        [[ImGroupRobotInfoDAL shareInstance] addImGroupRobotInfoModel:groupRobotInfoModel];
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ImGroupParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_GetRobot, nil);
    });
}

/* 单个机器人 */
- (void)parseGetRobotForRiid:(NSMutableDictionary *)dataDict {
    NSDictionary *dataContext = [[dataDict lzNSArrayForKey:WebApi_DataContext] firstObject];
    NSString *_riid = [[dataDict lzNSDictonaryForKey:WebApi_DataSend_Get] lzNSStringForKey:@"riid"];
    
    ImGroupRobotInfoModel *groupRobotInfoModel = [[ImGroupRobotInfoModel alloc] init];
    if (!dataContext) {
        groupRobotInfoModel = [[ImGroupRobotInfoDAL shareInstance] getimGroupRobotInfoModelByRiid:_riid];
    } else {
        groupRobotInfoModel.name = [dataContext lzNSStringForKey:@"name"];
        groupRobotInfoModel.icon = [dataContext lzNSStringForKey:@"icon"];
        groupRobotInfoModel.riid = [dataContext lzNSStringForKey:@"riid"];
        groupRobotInfoModel.intro = [dataContext lzNSStringForKey:@"intro"];
        groupRobotInfoModel.appid = [dataContext lzNSStringForKey:@"appid"];
        groupRobotInfoModel.appcode = [dataContext lzNSStringForKey:@"appcode"];
        groupRobotInfoModel.iscustomsettint = [[dataContext lzNSNumberForKey:@"iscustomsettint"] integerValue];
        groupRobotInfoModel.preview = [dataContext lzNSStringForKey:@"preview"];
        groupRobotInfoModel.messageapi = [dataContext lzNSStringForKey:@"messageapi"];
        groupRobotInfoModel.templatecode = [dataContext lzNSStringForKey:@"templatecode"];
        [[ImGroupRobotInfoDAL shareInstance] addImGroupRobotInfoModel:groupRobotInfoModel];
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ImGroupParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_GetRobotForRiid, groupRobotInfoModel);
    });
}
/* 查天气信息 */
- (void)parseGetWeatherRobotExample:(NSMutableDictionary *)dataDict {
    NSMutableDictionary *dataContext = [dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
    ImGroupRobotWeatherModel *robotWeatherModel = [[ImGroupRobotWeatherModel alloc] init];
    robotWeatherModel.rwid = [dataContext lzNSStringForKey:@"rwid"];
    robotWeatherModel.name = [dataContext lzNSStringForKey:@"name"];
    robotWeatherModel.icon = [dataContext lzNSStringForKey:@"icon"];
    robotWeatherModel.isopentime = [[dataContext lzNSNumberForKey:@"isopentime"] integerValue];
    robotWeatherModel.pushtime = [LZFormat String2Date:[dataContext lzNSStringForKey:@"pushtime"]];   // 默认是当前时间
    robotWeatherModel.province = [dataContext lzNSStringForKey:@"province"];   // 默认北京
    robotWeatherModel.city = [dataContext lzNSStringForKey:@"city"];
    robotWeatherModel.ispushmessage = [[dataContext lzNSNumberForKey:@"ispushmessage"] integerValue];
    robotWeatherModel.addtime = [LZFormat String2Date:[dataContext lzNSStringForKey:@"addtime"]];
    robotWeatherModel.igid = [dataContext lzNSStringForKey:@"igid"];
    robotWeatherModel.igrid = [dataContext lzNSStringForKey:@"igrid"];  // 更新时候传
    robotWeatherModel.riid = [dataContext lzNSStringForKey:@"riid"];
    
//    [[ImGroupRobotWeatherDAL shareInstance] addImGroupRobotWeatherModel:robotWeatherModel];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ImGroupParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_GetWeatherRobotExample, robotWeatherModel);
    });
}

/* 添加天气机器人信息 */
- (void)parseAddWeatherRobotExample:(NSMutableDictionary *)dataDict {
    NSDictionary *errorCode = [dataDict lzNSDictonaryForKey:WebApi_ErrorCode];
    NSMutableDictionary *dataContext = [dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
    if ([[errorCode lzNSStringForKey:@"Code"] isEqualToString:@"0"]) {
        ImGroupRobotWeatherModel *robotWeatherModel = [[ImGroupRobotWeatherModel alloc] init];
        robotWeatherModel.rwid = [dataContext lzNSStringForKey:@"rwid"];
        robotWeatherModel.name = [dataContext lzNSStringForKey:@"name"];
        robotWeatherModel.icon = [dataContext lzNSStringForKey:@"icon"];
        robotWeatherModel.isopentime = [[dataContext lzNSNumberForKey:@"isopentime"] integerValue];
        robotWeatherModel.pushtime = [LZFormat String2Date:[dataContext lzNSStringForKey:@"pushtime"]];   // 默认是当前时间
        robotWeatherModel.province = [dataContext lzNSStringForKey:@"province"];   // 默认北京
        robotWeatherModel.city = [dataContext lzNSStringForKey:@"city"];
        robotWeatherModel.ispushmessage = [[dataContext lzNSNumberForKey:@"ispushmessage"] integerValue];
        robotWeatherModel.addtime = [LZFormat String2Date:[dataContext lzNSStringForKey:@"addtime"]];
        robotWeatherModel.igid = [dataContext lzNSStringForKey:@"igid"];
        robotWeatherModel.igrid = [dataContext lzNSStringForKey:@"igrid"];  // 更新时候传
        robotWeatherModel.riid = [dataContext lzNSStringForKey:@"riid"];
        
        [[ImGroupRobotWeatherDAL shareInstance] addImGroupRobotWeatherModel:robotWeatherModel];
    } else {
        DDLogVerbose(@"添加机器人失败");
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ImGroupParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_AddWeatherRobotExample, nil);
    });
}


/*  修改天气机器人实例 */
- (void)parseUpdateWeatherRobotExample:(NSMutableDictionary *)dataDict {
    NSInteger dataContext = [[dataDict lzNSNumberForKey:WebApi_DataContext] integerValue];
    NSMutableDictionary *postDic = [dataDict lzNSMutableDictionaryForKey:WebApi_DataSend_Post];
    if (dataContext == 1) {
        DDLogVerbose(@"修改机器人成功");
        ImGroupRobotWeatherModel *robotWeatherModel = [[ImGroupRobotWeatherModel alloc] init];
        robotWeatherModel.rwid = [postDic lzNSStringForKey:@"rwid"];
        robotWeatherModel.name = [postDic lzNSStringForKey:@"name"];
        robotWeatherModel.icon = [postDic lzNSStringForKey:@"icon"];
        robotWeatherModel.isopentime = [[postDic lzNSNumberForKey:@"isopentime"] integerValue];
        robotWeatherModel.pushtime = [postDic objectForKey:@"pushtime"];   // 默认是当前时间
        robotWeatherModel.province = [postDic lzNSStringForKey:@"province"];   // 默认北京
        robotWeatherModel.city = [postDic lzNSStringForKey:@"city"];
        robotWeatherModel.ispushmessage = [[postDic lzNSNumberForKey:@"ispushmessage"] integerValue];
        robotWeatherModel.igid = [postDic lzNSStringForKey:@"igid"];
        robotWeatherModel.igrid = [postDic lzNSStringForKey:@"igrid"];  // 更新时候传
        robotWeatherModel.riid = [postDic lzNSStringForKey:@"riid"];
        
        [[ImGroupRobotWeatherDAL shareInstance] addImGroupRobotWeatherModel:robotWeatherModel];
    } else {
        DDLogVerbose(@"修改机器人失败");
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ImGroupParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_UpdateWeatherRobotExample, nil);
    });
}
/* 删除天气机器人实例 */
- (void)parseDeleteWeatherRobotExample:(NSMutableDictionary *)dataDict {
    NSInteger dataContext = [[dataDict lzNSNumberForKey:WebApi_DataContext] integerValue];
    NSMutableDictionary *getDic = [dataDict lzNSMutableDictionaryForKey:WebApi_DataSend_Get];
    if (dataContext == 1) {
        [[ImGroupRobotWeatherDAL shareInstance] deleteImGroupRobotWeatherModelWithRwId:[getDic lzNSStringForKey:@"rwid"]];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block ImGroupParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_ChatGroup_DeleteWeatherRobotExample, nil);
        });
    } else {
        DDLogVerbose(@"删除机器人失败");
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
//    NSString *route = [dataDic objectForKey:WebApi_Route];
//    NSString *errorCode = [[dataDic objectForKey:WebApi_ErrorCode] objectForKey:@"Code"];
    
    /* 移除群成员 */
//    if( [route isEqualToString:WebApi_ImGroup_RemoveMember] ){
//        if([errorCode isEqualToString:@"81017"]){
//            [self parseRemoveMember:dataDic];
//        }
//    }

}


@end
