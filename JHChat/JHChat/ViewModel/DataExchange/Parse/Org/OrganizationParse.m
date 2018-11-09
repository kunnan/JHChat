//
//  OrganizationParse.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/23.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2015-12-24
 Version: 1.0
 Description: 解析组织机构
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "OrganizationParse.h"
#import "OrgDAL.h"
#import "OrgEnterPriseDAL.h"
#import "OrgEnterPriseModel.h"
#import "OrgAdminDAL.h"
#import "OrgAdminModel.h"
#import "OrgUserDAL.h"
#import "OrgModel.h"
#import "OrgUserApplyDAL.h"
#import "OrgUserIntervateDAL.h"
#import "SysApiVersionDAL.h"

@implementation OrganizationParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrganizationParse *)shareInstance{
    static OrganizationParse *instance = nil;
    if (instance == nil) {
        instance = [[OrganizationParse alloc] init];
    }
    return instance;
}

/**
 *  解析数据
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parse:(NSMutableDictionary *)dataDic
{
    NSString *route = [dataDic objectForKey:WebApi_Route];
    //根据路由进行数据解析分发
    if([route isEqualToString:WebApi_Organization_GetUserOrgByUisController]){
        [self parseGetUserOrgByUisController:dataDic];
    }
    //新的组织接受调用
    else if([route isEqualToString:WebApi_Organization_ApproveOrgIntervate]){
        [self parseApproveOrgIntervate:dataDic];
    }
    //新的组织拒绝调用
    else if([route isEqualToString:WebApi_Organization_RefuseOrgUserIntervate]){
        [self parseRefuseOrgUserIntervate:dataDic];
    }
    //获取用户在某个组织下的主要信息
    else if([route isEqualToString:WebApi_Organization_GetOrgsByUserByUidOeid]){
        [self parseGetOrgsByUserByUidOeid:dataDic];
    }
    //创建组织
    else if([route isEqualToString:WebApi_Organization_CreateEnterPrise]){
        [self parseCreateEnterPrise:dataDic];
    }
    //查找组织
    else if([route isEqualToString:WebApi_Organization_GetOrgByUserApply]){
        [self parseGetOrgByUserApply:dataDic];
    }
    //个人组织信息
    else if([route isEqualToString:WebApi_Organization_GetBasicByentersUser]){
        [self parseGetBasicByentersUser:dataDic];
    }
    //加入群组部门信息
    else if ([route isEqualToString:WebApi_Organization_Getorgbyuid]){
        
        [self parseGetorgbyuid:dataDic];
    }
    //根据组织ID查找组织
    else if ([route isEqualToString:WebApi_Organization_GetOrgInfoByCodeModel]){
        [self parseGetOrgInfoByCodeModel:dataDic];
    }
    /* 创建部门 */
    else if( [route isEqualToString:WebApi_Organization_CreateDept] ){
        [self parseCreateDept:dataDic];
    }
    /* 修改部门 */
    else if( [route isEqualToString:WebApi_Organization_UpdateDept] ){
        [self parseUpdateDept:dataDic];
    }
    /* 删除部门 */
    else if( [route isEqualToString:WebApi_Organization_DeleteDept] ){
        [self parseDeleteDept:dataDic];
    }
    /* 获取一个部门信息 */
    else if ([route isEqualToString:WebApi_Organization_GetDept]) {
        [self parseGetDept:dataDic];
    }
    /* 当前人可以管理的部门 */
    else if( [route isEqualToString:WebApi_Organization_GetOrgProrityByEUId] ){
        [self parseGetOrgProrityByEuid:dataDic];
    }
    /* 当前人所属的部门 */
    else if( [route isEqualToString:WebApi_Organization_GetOrgListByUidOeid] ){
        [self parseGetOrgListByUidOeid:dataDic];
    }
    /* 获取当前企业下的所有部门(不包含当前企业) */
    else if( [route isEqualToString:WebApi_Organization_GetChildOrgByssqy] ){
        [self parseGetChildOrgByssqy:dataDic];
    }
    /* 获取当前企业下的所有部门 */
    else if( [route isEqualToString:WebApi_Organization_GetOrgByssqy] ){
        [self parseGetOrgByssqy:dataDic];
    }
    /* 获取当前部门的子部门 */
    else if( [route isEqualToString:WebApi_Organization_GetOrgListByOPid] ){
        [self parseGetOrgListByOPid:dataDic];
    }
    /* 修改组织信息 */
    else if( [route isEqualToString:WebApi_Organization_UpdateEnterprise] ){
        [self parseUpdateEnterprise:dataDic];
    }
    /* 得到组织联系人 || 根据筛选条件返回某个企业权限下的用户列表 */
    else if ([route isEqualToString:WebApi_OrgUser_GetUserByFilter] || [route isEqualToString:WebApi_Organization_GetAuthUserByFilter]) {
        [self parseGetUserByFilter:dataDic];
    }
    /* 新的员工申请记录 */
    else if ([route isEqualToString:Contact_WebAPI_GetMsgUserApplyList]){
        [self parseGetMsgUserApplyList:dataDic];
    }
    /* 获取组织申请成员列表 */
    else if ([route isEqualToString:Contact_WebAPI_GetOrgUsrapplyList]){
        [self parseGetOrgUsrapplyList:dataDic];
    }
    /* 新的员工接受 */
    else if ([route isEqualToString:Contact_WebAPI_AcceptApplyUser]){
        [self parserAcceptApplyUser:dataDic];
    }
    /* 新的员工拒绝 */
    else if ([route isEqualToString:Contact_WebAPI_RefuseApplyUser]){
        [self parserRefuseApplyUser:dataDic];
    }
    /* 获取某个组织下某人的申请记录信息 */
    else if ([route isEqualToString:Contact_WebAPI_GetOrgUserApplyModelByKey]){
        [self parserGetOrgUserApplyModelByKey:dataDic];
    }
    /* 获取一个组织信息 */
    else if ([route isEqualToString:WebApi_Organization_GetOrgByOid]){
        [self parserGetOrgByOid:dataDic];
    }
    /* 用户删除组织的加入邀请 */
    else if ([route isEqualToString:WebApi_Organization_DeleteOrgUserIntervate]){
        [self parserDeleteOrgUserIntervate:dataDic];
    }
    /* 管理员删除用户申请加入某个组织 */
    else if ([route isEqualToString:Contact_WebAPI_DeleteApplyUser]){
        [self parserDeleteApplyUser:dataDic];
    }
    /* 退出组织 */
    else if ([route isEqualToString:WebApi_Organization_UserExitEnter]){
        [self parseUserExitEnter:dataDic];
    }
    /* 获取未激活用户在某个企业所属的部门 */
    else if ([route isEqualToString:WebApi_Organization_GetUserAddItionInfoByUid]){
        [self parseGetUserAddItionInfoByUid:dataDic];
    }
    /* 未激活用户调整部门后，矫正邀请信息 */
    else if ([route isEqualToString:WebApi_Organization_ReactOrgIntervateUser]){
        [self parseReactOrgIntervateUser:dataDic];
    }
    /* 根据组织id获取上级的所有组织数据 */
    else if ([route isEqualToString:WebApi_Organization_GetRecusiveParentOrgByOid]){
        [self parseGetRecusiveParentOrgByOid:dataDic];
    }
    /* 根据组织id集合返回的组织信息 */
    else if ([route isEqualToString:WebApi_Organization_GetOrgByOids]){
        [self parserGetOrgByOids:dataDic];
    }
    /* 企业的过期时间判断，true:未到期，false:到期 */
    else if ([route isEqualToString:WebApi_Organization_EnterLic_DeadLineAuthCheck]){
        [self parseEnterLicDeadLineAuthCheck:dataDic];
    }
    /* 判断企业下是否给某应用授权 */
    else if ([route isEqualToString:Contact_WebApi_OrgLicense_IsExistsAuth]) {
        [self parseOrgLicenseIsExistsAuth:dataDic];
    }

    
}

#pragma mark - 解析所属有效组织
/**
 *  解析所属有效组织
 */
-(void)parseGetUserOrgByUisController:(NSMutableDictionary *)dataDic{
    NSMutableArray *dataArray  = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    
    NSMutableArray *allOrgEnterPriseArr = [[NSMutableArray alloc] init];
    for(int i=0;i<dataArray.count;i++){
        NSDictionary *dataDic = [dataArray objectAtIndex:i];
        NSString *eid = [dataDic objectForKey:@"oid"];
        NSString *ecode = [dataDic objectForKey:@"ecode"];
        NSString *name = [dataDic objectForKey:@"name"];
        NSString *shortname = [dataDic objectForKey:@"shortname"];
        NSString *createdate = [dataDic lzNSStringForKey:@"createdate"];
        
        OrgEnterPriseModel *orgEnterPriseModel = [[OrgEnterPriseModel alloc] init];
        orgEnterPriseModel.eid = eid;
        orgEnterPriseModel.ecode = ecode;
        orgEnterPriseModel.name = name;
        orgEnterPriseModel.shortname = shortname;
        orgEnterPriseModel.logo=[NSString null2Empty:[dataDic objectForKey:@"logo"]];
        orgEnterPriseModel.isenteradmin=[LZFormat Safe2Int32:[dataDic objectForKey:@"isenteradmin"]];
        orgEnterPriseModel.createdate = [LZFormat String2Date:createdate];
        orgEnterPriseModel.username = [dataDic lzNSStringForKey:@"username"];
        if([NSString isNullOrEmpty:orgEnterPriseModel.username]){
            orgEnterPriseModel.username = [[LZUserDataManager readCurrentUserInfo] objectForKey:@"username"];
        }
        orgEnterPriseModel.isadmin = [LZFormat Safe2Int32:[dataDic lzNSNumberForKey:@"isadmin"]];
        
        [allOrgEnterPriseArr addObject:orgEnterPriseModel];
    }
    //在插入数据以前，先把以前当前组织下的所有部门清除掉
    [[OrgEnterPriseDAL shareInstance] deleteAllData];
    
    [[OrgEnterPriseDAL shareInstance] addDataWithOrgEnterpriseArray:allOrgEnterPriseArr];
    
    /* 更新SysApiVersion */
    [[SysApiVersionDAL shareInstance] updateServerVersionToClientVersionWithCode:LogoinWebApi_api_organization_getuserorgbyuidcontroller_S8];
    
    self.appDelegate.lzGlobalVariable.isNeedRefreshContactRootVC2 = YES;
    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetBelongOrgs, dataDic);
        EVENT_PUBLISH_WITHDATA(service, EventBus_SendFirstLaunchPercentage, nil);
    });
}

#pragma mark - 新的组织接受调用
/**
 *  接受组织邀请
 *  @param dataDict
 */
-(void)parseApproveOrgIntervate:(NSMutableDictionary *)dataDict{
    NSMutableDictionary *dataDic  = [dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableArray *arrData=[NSMutableArray array];
    OrgEnterPriseModel *orgEnterPriseModel = [[OrgEnterPriseModel alloc] init];
    orgEnterPriseModel.ecode=[dataDic objectForKey:@"ecode"];
    orgEnterPriseModel.isenteradmin=[LZFormat Safe2Int32:[dataDic objectForKey:@"isenteradmin"]];
    orgEnterPriseModel.logo=[NSString null2Empty:[dataDic objectForKey:@"logo"]];
    orgEnterPriseModel.name=[dataDic objectForKey:@"name"];
    orgEnterPriseModel.eid=[dataDic objectForKey:@"oid"];
    orgEnterPriseModel.shortname=[dataDic objectForKey:@"shortname"];
    orgEnterPriseModel.createdate = [LZFormat String2Date:[dataDic lzNSStringForKey:@"createdate"]];
    orgEnterPriseModel.isadmin = [LZFormat Safe2Int32:[dataDic lzNSNumberForKey:@"isadmin"]];
    [arrData addObject:orgEnterPriseModel];
    
    [[OrgEnterPriseDAL shareInstance] addDataWithOrgEnterpriseArray:arrData];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_ApproveOrgIntervate, arrData);
    });
}

#pragma mark - 新的组织拒绝调用
/**
 *  拒绝组织邀请
 *  @param dataDict
 */
-(void)parseRefuseOrgUserIntervate:(NSMutableDictionary *)dataDict{

    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_RefuseOrgUserIntervate, dataString);
    });
}

#pragma mark - 获取用户在某个组织下的主要信息
/**
 *  获取用户在某个组织下的主要信息
 *  @param dataDict
 */
-(void)parseGetOrgsByUserByUidOeid:(NSMutableDictionary *)dataDict{
    NSMutableDictionary *datadic  = [dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableArray *arrData=[NSMutableArray array];
    OrgEnterPriseModel *orgEnterPriseModel = [[OrgEnterPriseModel alloc] init];
    orgEnterPriseModel.ecode=[datadic objectForKey:@"ecode"];
    orgEnterPriseModel.isenteradmin=[LZFormat Safe2Int32:[datadic objectForKey:@"isenteradmin"]];
    orgEnterPriseModel.logo=[NSString null2Empty:[datadic objectForKey:@"logo"]];
    orgEnterPriseModel.name=[datadic objectForKey:@"name"];
    orgEnterPriseModel.eid=[datadic objectForKey:@"oid"];
    orgEnterPriseModel.shortname=[datadic objectForKey:@"shortname"];
    orgEnterPriseModel.userallcount=[LZFormat Safe2Int32:[datadic objectForKey:@"usercount"]];
    orgEnterPriseModel.isadmin = [LZFormat Safe2Int32:[datadic lzNSNumberForKey:@"isadmin"]];
    [arrData addObject:orgEnterPriseModel];
    [[OrgEnterPriseDAL shareInstance] addDataWithOrgEnterpriseArray:arrData];
    self.appDelegate.lzGlobalVariable.isNeedRefreshContactRootVC2=YES;

}

#pragma mark - 获取一个部门的信息
/**
 *  得到一个部门信息
 *
 *  @param dataDict
 */
-(void)parseGetDept:(NSMutableDictionary *)dataDict {
    NSMutableDictionary *dataDic  = [dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableArray *arrData=[NSMutableArray array];
    OrgModel *orgModel = [[OrgModel alloc] init];
    orgModel.code=[dataDic objectForKey:@"code"];
    orgModel.name=[dataDic objectForKey:@"name"];
    orgModel.shortname=[dataDic objectForKey:@"shortname"];
    orgModel.normalcount = [LZFormat Safe2Int32:[dataDic objectForKey:@"normalcount"]];
    orgModel.unactivecount = [LZFormat Safe2Int32:[dataDic objectForKey:@"unactivecount"]];
    orgModel.childnormalcount = [LZFormat Safe2Int32:[dataDic objectForKey:@"childnormalcount"]];
    orgModel.childunactivecount = [LZFormat Safe2Int32:[dataDic objectForKey:@"childunactivecount"]];
    [arrData addObject:orgModel];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetDept, arrData);
    });
}

#pragma mark - 创建组织
/**
 *  创建组织
 *  @param dataDict
 */
-(void)parseCreateEnterPrise:(NSMutableDictionary *)dataDict{
    NSDictionary *otherData  = [dataDict lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSString *otherOperate  = [otherData lzNSStringForKey:WebApi_DataSend_Other_Operate];

    /* 附带的其它信息处理 */
    if(![NSString isNullOrEmpty:otherOperate]){
        /* 注册、创建组织 */
        if( [otherOperate isEqualToString:@"registercreate"]) {
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                __block OrganizationParse * service = self;
                EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_Create_EnterPrise, dataDict);
            });
            return;
        }
    }

    
    NSMutableDictionary *datadic  = [dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
//    NSString *eid=[datadic objectForKey:@"eid"];

    NSMutableArray *arrData=[NSMutableArray array];
    OrgEnterPriseModel *orgEnterPriseModel = [[OrgEnterPriseModel alloc] init];
    orgEnterPriseModel.ecode=[datadic objectForKey:@"ecode"];
    orgEnterPriseModel.isenteradmin=[LZFormat Safe2Int32:[datadic objectForKey:@"isenteradmin"]];
    orgEnterPriseModel.logo=[NSString null2Empty:[datadic objectForKey:@"logo"]];
    orgEnterPriseModel.name=[datadic objectForKey:@"name"];
    orgEnterPriseModel.eid=[datadic objectForKey:@"eid"];
    orgEnterPriseModel.shortname=[datadic objectForKey:@"shortname"];
    orgEnterPriseModel.createdate = [LZFormat String2Date:[datadic lzNSStringForKey:@"createdate"]];
    orgEnterPriseModel.isenteradmin = 1;
    orgEnterPriseModel.isadmin = 1;
    [arrData addObject:orgEnterPriseModel];
    
    [[OrgEnterPriseDAL shareInstance] addDataWithOrgEnterpriseArray:arrData];
    
    self.appDelegate.lzGlobalVariable.isNeedRefreshContactRootVC2=YES;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[LZUserDataManager readCurrentUserInfo]];
    NSMutableDictionary *notificaton = [dic lzNSMutableDictionaryForKey:@"notificaton"];
    [notificaton setObject:[NSNumber numberWithUnsignedInt:2] forKey:@"identitytype"];
    [notificaton setObject:[datadic lzNSStringForKey:@"eid"] forKey:@"selectoid"];
    [dic setObject:notificaton forKey:@"notificaton"];
    [LZUserDataManager saveCurrentUserInfo:dic];
    
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    
    [postData setObject:[AppUtils GetCurrentUserID] forKey:@"uid"];
    [postData setObject:[datadic lzNSStringForKey:@"eid"] forKey:@"selectoid"];
    
    [[self appDelegate].lzservice sendToServerForPost:WebApi_CloudUser routePath:WebApi_CloudUser_Update_Selected_Org moduleServer:Modules_Default getData:nil postData:postData otherData:nil];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_Create_EnterPrise, dataDict);
    });
    
}
#pragma mark - 查找组织
/**
 *  创建组织
 *  @param dataDict
 */
-(void)parseGetOrgByUserApply:(NSMutableDictionary *)dataDict{
    
    NSMutableDictionary *dataDic=[dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_ExistOrgByCode, dataDic);
    });
}

#pragma mark - 组织个人信息
/**
 *  组织个人信息
 *  @param dataDict
 */
-(void)parseGetBasicByentersUser:(NSMutableDictionary *)dataDict{
    NSMutableArray *dataArray  = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableArray *allOrgEnterPriseArr = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *orgUserEnterpriseDic;
    NSMutableDictionary *orgAllDataDic;

    for(int i=0;i<dataArray.count;i++){
        orgUserEnterpriseDic=[[NSMutableDictionary alloc]init];
        NSMutableArray *orgallDataArr=[[NSMutableArray alloc]init];
        
        NSDictionary *dataDic = [dataArray objectAtIndex:i];
        NSString *eid = [dataDic objectForKey:@"eid"];
        NSString *shortname = [dataDic objectForKey:@"shortname"];
        NSString *username = [dataDic objectForKey:@"username"];
        NSString *mobile = [dataDic objectForKey:@"mobile"];
        
//        NSString *officecall = [dataDic objectForKey:@"officecall"];
        NSString *officecall=@"";
        //处理username为空时，让username等于mobile
        if([username isKindOfClass:[NSNull class]]){
            username = @"";
        }
        if([mobile isKindOfClass:[NSNull class]]){
            mobile = @"";
        }
        
        NSMutableArray *orgAllArray=[dataDic objectForKey:@"orgallbyuser"];
        for(int j=0;j<orgAllArray.count;j++){
            NSDictionary *orgDataDic=[orgAllArray objectAtIndex:j];
            orgAllDataDic=[[NSMutableDictionary alloc]init];
            NSString *oid=[orgDataDic objectForKey:@"oid"];
            NSString *orgShortname=[orgDataDic lzNSStringForKey:@"shortname"];
            [orgAllDataDic setObject:oid forKey:@"oid"];
            [orgAllDataDic setObject:orgShortname forKey:@"shortname"];
            [orgAllDataDic setObject:[orgDataDic lzNSStringForKey:@"oeid"] forKey:@"oeid"];
            [orgallDataArr addObject:orgAllDataDic];
        }
        if(orgAllArray.count==0){//容错处理， 当orgall没值时
            orgAllDataDic=[[NSMutableDictionary alloc]init];
            [orgAllDataDic setObject:eid forKey:@"oid"];
            [orgAllDataDic setObject:shortname forKey:@"shortname"];
            [orgAllDataDic setObject:eid forKey:@"oeid"];
            [orgallDataArr addObject:orgAllDataDic];
        }

        [orgUserEnterpriseDic setObject:orgallDataArr forKey:@"orgAlldepartment"];
        [orgUserEnterpriseDic setObject:eid forKey:@"eid"];
        [orgUserEnterpriseDic setObject:shortname forKey:@"shortname"];
        [orgUserEnterpriseDic setObject:username forKey:@"username"];
        [orgUserEnterpriseDic setObject:mobile forKey:@"mobile"];
        [orgUserEnterpriseDic setObject:officecall forKey:@"officecall"];

        
        [allOrgEnterPriseArr addObject:orgUserEnterpriseDic];
    }
    
    [LZUserDataManager savePersonalEnterpriseInfo:allOrgEnterPriseArr];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetBasic_Byenters_User, allOrgEnterPriseArr);
    });
}

/**
 //加入群组部门信息
 *  @param dataDict
 */
- (void)parseGetorgbyuid:(NSMutableDictionary*)dataDict{
    
    //部门
    NSMutableDictionary *companyDic=[NSMutableDictionary dictionary];
    
    NSMutableArray *dataArray  = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    //组织
    NSMutableArray *orgArr=[NSMutableArray array];

    
    for (NSDictionary *subDict in dataArray) {
        
        NSDictionary *enterprisemodel=[subDict objectForKey:@"enterprisemodel"];
        OrgModel *pModel=[[OrgModel alloc]init];
        [pModel serializationWithDictionary:enterprisemodel];
        [orgArr addObject:pModel];

        NSString *oid=[enterprisemodel objectForKey:@"oid"];
        
        NSArray *deptmodel=[subDict objectForKey:@"deptmodel"];
        NSMutableArray *deptArr=[NSMutableArray array];
        for (NSDictionary *depDict in deptmodel) {
            OrgModel *dModel=[[OrgModel alloc]init];
            [dModel serializationWithDictionary:depDict];
            [deptArr addObject:dModel];
        }
        
        [companyDic setObject:deptArr forKey:oid];
        
    }
    NSDictionary *comDict=[NSDictionary dictionaryWithObjectsAndKeys:companyDic,@"dept",orgArr,@"org", nil];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetOrgbyuid, comDict);
    });

}
#pragma mark - 根据组织ID查找组织
/**
 *  根据组织ID查找组织
 *  @param dataDict
 */
-(void)parseGetOrgInfoByCodeModel:(NSMutableDictionary *)dataDict{
    
    NSMutableDictionary *dic=[dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 发送给扫描视图 */
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Scan_SendWebApi_Success, dic);
    });
}

/**
 *  创建部门
 */
-(void)parseCreateDept:(NSMutableDictionary *)dataDict{
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_DeptModifySuccess, dataDict);
    });
}

/**
 *  修改部门
 */
-(void)parseUpdateDept:(NSMutableDictionary *)dataDict{
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_DeptModifySuccess, dataDict);
    });
}

/**
 *  删除部门
 */
-(void)parseDeleteDept:(NSMutableDictionary *)dataDict{
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_DeleteOrg, dataDict);
    });
}


/**
 *  获取当前人可以管理的部门
 */
-(void)parseGetOrgProrityByEuid:(NSMutableDictionary *)dataDict{
    
    NSDictionary *otherData  = [dataDict lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSString *otherOperate  = [otherData lzNSStringForKey:WebApi_DataSend_Other_Operate];
    
    /* 附带的其它信息处理 */
    if(![NSString isNullOrEmpty:otherOperate]){
        /*  */
        if( [otherOperate isEqualToString:@"OrgCancelAdmin"]) {
            NSArray *oidArr=[dataDict lzNSArrayForKey:WebApi_DataContext];
            NSDictionary *postData = [dataDict lzNSDictonaryForKey:WebApi_DataSend_Post];
            NSString *oeid = [postData lzNSStringForKey:@"oeid"];
            if(oidArr.count==0){
                [[OrgEnterPriseDAL shareInstance]updateEnterpriseWithOEId:oeid isadmin:0];
            }
            return;
        }
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetOrgProrityByEuid, dataDict);
    });
}

/**
 *  获取某人所属的部门
 */
-(void)parseGetOrgListByUidOeid:(NSMutableDictionary *)dataDict{
    
    NSMutableArray *orgArr = [[NSMutableArray alloc] init];
    
    /* 解析所属部门数据 */
    NSMutableArray *orgDatacontext = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    NSDictionary *postData = [dataDict lzNSDictonaryForKey:WebApi_DataSend_Post];
    NSString *dataother_type = [[dataDict lzNSDictonaryForKey:WebApi_DataSend_Other] lzNSStringForKey:@"type"];
    
    NSString *oeid = [postData lzNSStringForKey:@"oeid"];
    for (NSDictionary *orgDic in orgDatacontext) {
        OrgModel *orgModel=[[OrgModel alloc]init];
        [orgModel serializationWithDictionary:orgDic];
        
        if([dataother_type isEqualToString:@"GWselectdepartment"]){
            if(![oeid isEqualToString:orgModel.oid])[orgArr addObject:orgModel];
        }
        else{
            [orgArr addObject:orgModel];
        }
    }
    
    NSDictionary *returnData = @{@"orgs":orgArr,
                                 @"uid":[[dataDict objectForKey:WebApi_DataSend_Post] objectForKey:@"uid"],
                                 @"datasendother": [dataDict lzNSDictonaryForKey:WebApi_DataSend_Other]};
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetOrgListByUidOeid, returnData);
    });
}

/**
 *  修改组织信息
 */
-(void)parseUpdateEnterprise:(NSMutableDictionary *)dataDict {
    // gengxin
    NSNumber *dataContext = [dataDict lzNSNumberForKey:WebApi_DataContext];
    if(dataContext.integerValue == 1){
        NSDictionary *postData=[dataDict lzNSDictonaryForKey:WebApi_DataSend_Post];
        NSString *enterpriseId = [postData lzNSStringForKey:@"eid"];
        NSString *name = [postData lzNSStringForKey:@"name"];
        NSString *shortname = [postData lzNSStringForKey:@"shortname"];
        [[OrgEnterPriseDAL shareInstance] updateEnterpriseWithOEId:enterpriseId
                                                              name:name
                                                         shortName:shortname
                                                       description:nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block OrganizationParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_UpdateEnterprise, dataDict);
        });
    }
}

/**
 *  获取当前企业下的所有部门(不包含当前企业)
 */
-(void)parseGetChildOrgByssqy:(NSMutableDictionary *)dataDict{
    
    NSMutableArray *orgArr = [[NSMutableArray alloc] init];
    
    /* 解析部门数据 */
    NSMutableArray *orgDatacontext = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    for (NSDictionary *orgDic in orgDatacontext) {
        OrgModel *orgModel=[[OrgModel alloc]init];
        [orgModel serializationWithDictionary:orgDic];
        [orgArr addObject:orgModel];
    }
    
    NSDictionary *returnData = @{@"orgs":orgArr,
                                 @"eid":[dataDict objectForKey:WebApi_DataSend_Post]};
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetOrgListByOeid, returnData);
    });
}

/**
 *  获取当前企业下的所有部门
 */
-(void)parseGetOrgByssqy:(NSMutableDictionary *)dataDict{
    NSMutableArray *orgArr = [[NSMutableArray alloc] init];
    
    /* 解析部门数据 */
    NSMutableArray *orgDatacontext = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    for (NSDictionary *orgDic in orgDatacontext) {
        OrgModel *orgModel=[[OrgModel alloc]init];
        [orgModel serializationWithDictionary:orgDic];
        [orgArr addObject:orgModel];
    }
    
    NSDictionary *returnData = @{@"orgs":orgArr,
                                 @"eid":[dataDict objectForKey:WebApi_DataSend_Post]};
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetOrgByssqy, returnData);
    });
    
}


/**
 *  获取当前部门的子部门
 */
-(void)parseGetOrgListByOPid:(NSMutableDictionary *)dataDict{
    
    NSMutableArray *orgArr = [[NSMutableArray alloc] init];
    
    /* 解析子部门数据 */
    NSMutableArray *orgDatacontext = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    for (NSDictionary *orgDic in orgDatacontext) {
        OrgModel *orgModel=[[OrgModel alloc]init];
        [orgModel serializationWithDictionary:orgDic];
        [orgArr addObject:orgModel];
    }
    
    NSDictionary *returnData = @{@"orgs":orgArr,
                                 @"oid":[dataDict objectForKey:WebApi_DataSend_Post]};
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetOrgListByOpid, returnData);
    });
}

/**
 *  得到组织联系人
 */
-(void)parseGetUserByFilter:(NSMutableDictionary *) dataDict {
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetUserByFilter, dataDict);
    });
}

/**
 *  新的员工申请记录
 */
-(void)parseGetMsgUserApplyList:(NSMutableDictionary *) dataDict {
    NSMutableArray *dataArray=[dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    
    NSMutableArray<OrgUserApplyModel *> *ouaModels=[[NSMutableArray alloc]init];
    //          将网络数据，转换为数据库Model
    for (int i=0;i<dataArray.count;i++){
        NSDictionary *tmpData=(NSDictionary*)[dataArray objectAtIndex:i];
        OrgUserApplyModel *model=[[OrgUserApplyModel alloc]init];
        [model serializationWithDictionary:tmpData];
        [ouaModels addObject:model];
        
    }
    NSDictionary *param=[dataDict objectForKey:WebApi_DataSend_Post];
    NSString *lastkey=[param objectForKey:@"start"];
    if([lastkey isEqualToString:@"0"]){
        [[OrgUserApplyDAL shareInstance]deleteAllData];
    }
    [[OrgUserApplyDAL shareInstance ]addDataWithArray:ouaModels];
    NSMutableDictionary *favoritesDict=[NSMutableDictionary dictionary];
    [favoritesDict setObject:lastkey forKey:@"lastkey"];
    [favoritesDict setObject:ouaModels forKey:@"orguserapplyall"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetMsgUserApplyList, favoritesDict);
    });
    
}

/**
 *  获取组织申请成员列表
 */
-(void)parseGetOrgUsrapplyList:(NSMutableDictionary *) dataDict {
    NSMutableArray *dataArray=[dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableArray<OrgUserApplyModel *> *ouaModels=[[NSMutableArray alloc]init];
    //          将网络数据，转换为数据库Model
    for (int i=0;i<dataArray.count;i++){
        NSDictionary *tmpData=(NSDictionary*)[dataArray objectAtIndex:i];
        OrgUserApplyModel *model=[[OrgUserApplyModel alloc]init];
        [model serializationWithDictionary:tmpData];
        [ouaModels addObject:model];
        
    }
    NSDictionary *param=[dataDict objectForKey:WebApi_DataSend_Post];
    NSString *lastkey=[param objectForKey:@"start"];
    if([lastkey isEqualToString:@"0"]){
        [[OrgUserApplyDAL shareInstance]deleteAllDataByOid:[param objectForKey:@"oid"]];
    }
    [[OrgUserApplyDAL shareInstance ]addDataWithArray:ouaModels];
    NSMutableDictionary *favoritesDict=[NSMutableDictionary dictionary];
    [favoritesDict setObject:lastkey forKey:@"lastkey"];
    [favoritesDict setObject:ouaModels forKey:@"orguserapplyall"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetOrgUsrapplyList, favoritesDict);
    });
}

/**
 *  新的员工接受
 */
-(void)parserAcceptApplyUser:(NSMutableDictionary *) dataDict {
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_AcceptApplyUser, nil);
    });
}

/**
 *  新的员工拒绝
 */
-(void)parserRefuseApplyUser:(NSMutableDictionary *) dataDict {
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_RefuseApplyUser, dataString);
    });
}

/**
 *  获取某个组织下某人的申请记录信息
 */
-(void)parserGetOrgUserApplyModelByKey:(NSMutableDictionary *) dataDict {
    NSMutableDictionary *dataDic  = [dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableArray<OrgUserApplyModel *> *tmpModels=[[NSMutableArray alloc]init];
    
    OrgUserApplyModel *orgUserApplyModel=[[OrgUserApplyModel alloc]init];
    
    [orgUserApplyModel serializationWithDictionary:dataDic];
    
    [tmpModels addObject:orgUserApplyModel];
    
    [[OrgUserApplyDAL shareInstance]addDataWithArray:tmpModels];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetOrgUserApplyModelByKey, tmpModels);
    });
}

/**
 *  获取一个组织信息
 */
-(void)parserGetOrgByOid:(NSMutableDictionary *) dataDict {
    NSMutableDictionary *datadic  = [dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSDictionary *otherData = [dataDict lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSString *otherOperate = [otherData lzNSStringForKey:WebApi_DataSend_Other_Operate];
    
    NSMutableArray *distinctArr = [[NSMutableArray alloc] init];
    /* 若为修改员工名称，还需要刷新父页面 */
    if(![NSString isNullOrEmpty:[datadic lzNSStringForKey:@"opath"]]){
        [distinctArr addObjectsFromArray:[[datadic lzNSStringForKey:@"opath"] componentsSeparatedByString:@","]];
    }
    if([otherOperate isEqualToString:@"newdepartment"]){//新增部门
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 发送EvenBus，通知页面更新 */
            __block OrganizationParse * service2 = self;

                for(NSString *org in distinctArr){
                    if([[datadic lzNSStringForKey:@"oid"] isEqualToString:org]){
                        [distinctArr removeLastObject];
                    }else{
                        NSDictionary *data = @{@"oid":org,@"types":@{@"requestdep":@""}};
                        EVENT_PUBLISH_WITHDATA(service2, EventBus_Organization_RerfreshContactEnterpriseVC, data);
                    }
                }
        });
       
    }
    else if ([otherOperate isEqualToString:@"updatedepartment"]){ //修改部门信息
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block OrganizationParse * service2 = self;
            for(NSString *org in distinctArr){
                if([[datadic lzNSStringForKey:@"oid"] isEqualToString:org]){
                    /* 发送EventBus,通知子部门页面更新 */
                    NSDictionary *refreshTypes = @{@"currentorgmodel":
                                                       @{
                                                           @"name":[datadic lzNSStringForKey:@"name"],
                                                           @"shortname":[datadic lzNSStringForKey:@"shortname"],
                                                           @"showgroup":[datadic lzNSStringForKey:@"showgroup"]
                                                           }};
                    
                    NSDictionary *dataForCurrent=@{@"oid":org,
                                                   @"types":refreshTypes};
                    EVENT_PUBLISH_WITHDATA(service2, EventBus_Organization_RerfreshContactEnterpriseVC, dataForCurrent);
                }else{
                    
                    NSDictionary *data = @{@"oid":org,@"types":@{@"requestdep":@""}};
                    EVENT_PUBLISH_WITHDATA(service2, EventBus_Organization_RerfreshContactEnterpriseVC, data);
                }
            }
        });
    }
    else if( [otherOperate isEqualToString:@"contactselectjob"] ){ //选择岗位
        OrgEnterPriseModel *orgEnterPriseModel = [[OrgEnterPriseModel alloc] init];
        orgEnterPriseModel.ecode=[datadic objectForKey:@"code"];
        orgEnterPriseModel.name=[datadic objectForKey:@"name"];
        orgEnterPriseModel.eid=[datadic objectForKey:@"oid"];
        orgEnterPriseModel.shortname=[datadic objectForKey:@"shortname"];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block OrganizationParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_RerfreshContactForSelectJob, orgEnterPriseModel);
        });
    }
    else{
        NSMutableArray *arrData=[NSMutableArray array];
        OrgEnterPriseModel *orgEnterPriseModel = [[OrgEnterPriseModel alloc] init];
        orgEnterPriseModel.ecode=[datadic objectForKey:@"code"];
        orgEnterPriseModel.name=[datadic objectForKey:@"name"];
        orgEnterPriseModel.eid=[datadic objectForKey:@"oid"];
        orgEnterPriseModel.shortname=[datadic objectForKey:@"shortname"];
        [arrData addObject:orgEnterPriseModel];
        [[OrgEnterPriseDAL shareInstance] addDataWithOrgEnterpriseArray:arrData];
        self.appDelegate.lzGlobalVariable.isNeedRefreshContactRootVC2=YES;
    }
    
}

/**
 *  用户删除组织的加入邀请
 */
-(void)parserDeleteOrgUserIntervate:(NSMutableDictionary *) dataDict {
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    NSMutableDictionary *getDic=[dataDict lzNSMutableDictionaryForKey:WebApi_DataSend_Get];
    
    NSMutableDictionary *dataDic=[NSMutableDictionary dictionary];
    [dataDic setObject:dataString forKey:@"datacontext"];
    [dataDic setObject:[getDic lzNSStringForKey:@"ouiid"] forKey:@"ouiid"];
    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_DeleteOrgUserIntervate, dataDic);
    });
}

/**
 *  管理员删除用户申请加入某个组织
 */
-(void)parserDeleteApplyUser:(NSMutableDictionary *) dataDict {
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    NSMutableDictionary *getDic=[dataDict lzNSMutableDictionaryForKey:WebApi_DataSend_Get];
    
    NSMutableDictionary *dataDic=[NSMutableDictionary dictionary];
    [dataDic setObject:dataString forKey:@"datacontext"];
    [dataDic setObject:[getDic lzNSStringForKey:@"ouaid"] forKey:@"ouaid"];
    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_DeleteApplyUser, dataDic);
    });
    
}

/**
 *  退出组织
 */
-(void)parseUserExitEnter:(NSMutableDictionary *) dataDict {
    
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    NSMutableDictionary *postData=[dataDict lzNSMutableDictionaryForKey:WebApi_DataSend_Post];
    if([[AppUtils GetCurrentUserID]isEqualToString:[postData lzNSStringForKey:@"uid"]]){
        //删除本地存储的已退出的组织信息
        [[OrgEnterPriseDAL shareInstance]deleteOrgUserEntetpriseByEId:[postData lzNSStringForKey:@"oeid"]];
    }
    if([[AppUtils GetCurrentOrgID] isEqualToString:[postData lzNSStringForKey:@"oeid"]]){
        NSArray *orgEnterPrisesArr = [[OrgEnterPriseDAL shareInstance]getOrgEnterPrises];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[LZUserDataManager readCurrentUserInfo]];
        NSMutableDictionary *notificaton = [dic lzNSMutableDictionaryForKey:@"notificaton"];
        NSString *mainoeid = [notificaton lzNSStringForKey:@"mainoeid"];
        if(orgEnterPrisesArr.count==0){
            /* 个人身份 */
            [[self appDelegate].lzservice sendToServerForGet:WebApi_CloudUser routePath:WebApi_CloudUser_SwitchPersonidenType moduleServer:Modules_Default getData:nil otherData:nil];
            [notificaton setObject:[NSNumber numberWithUnsignedInt:1] forKey:@"identitytype"];
            [notificaton setObject:[AppUtils GetCurrentUserID] forKey:@"selectoid"];
        }
        else{
            /* 组织身份 */
            OrgEnterPriseModel *orgEnterPriseModel = [orgEnterPrisesArr firstObject];
            NSMutableDictionary *nowPostData = [NSMutableDictionary dictionary];
            
            [nowPostData setObject:[AppUtils GetCurrentUserID] forKey:@"uid"];
            [nowPostData setObject:orgEnterPriseModel.eid forKey:@"selectoid"];
            
            [[self appDelegate].lzservice sendToServerForPost:WebApi_CloudUser routePath:WebApi_CloudUser_Update_Selected_Org moduleServer:Modules_Default getData:nil postData:nowPostData otherData:nil];
            
            /* 当前ID是主企业身份 */
            if([mainoeid isEqualToString:[postData lzNSStringForKey:@"oeid"]]){
                NSMutableDictionary *getData = [NSMutableDictionary dictionary];
                getData[@"oeid"] = orgEnterPriseModel.eid;
                [self.appDelegate.lzservice sendToServerForGet:WebApi_CloudUser routePath:WebApi_CloudUser_SetMainOrg moduleServer:Modules_Default getData:getData otherData:nil];
                [notificaton setObject:orgEnterPriseModel.eid forKey:@"mainoeid"];
            }
            
            [notificaton setObject:[NSNumber numberWithUnsignedInt:2] forKey:@"identitytype"];
            [notificaton setObject:orgEnterPriseModel.eid forKey:@"selectoid"];
        }
        [dic setObject:notificaton forKey:@"notificaton"];
        [LZUserDataManager saveCurrentUserInfo:dic];
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.appDelegate.lzGlobalVariable.isNeedRefreshContactRootVC2=YES;
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_UserExitEnter, dataString);
    });
}

/**
 *  获取未激活用户在某个企业所属的部门
 */
-(void)parseGetUserAddItionInfoByUid:(NSMutableDictionary *) dataDict {
    NSMutableArray *orgArr = [[NSMutableArray alloc] init];
    
    /* 解析所属部门数据 */
    NSMutableDictionary *orgDatacontext = [dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableArray *orgallbyuser = [orgDatacontext lzNSMutableArrayForKey:@"orgallbyuser"];
    
    for (NSDictionary *orgDic in orgallbyuser) {
        OrgModel *orgModel=[[OrgModel alloc]init];
        [orgModel serializationWithDictionary:orgDic];
        [orgArr addObject:orgModel];
    }
    
    NSDictionary *returnData = @{@"orgs":orgArr,
                                 @"uid":[[dataDict objectForKey:WebApi_DataSend_Post] objectForKey:@"uid"],
                                 };
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetUserAddItionInfoByUid, returnData);
    });
    
}

/**
 *  未激活用户调整部门后，矫正邀请信息
 */
-(void)parseReactOrgIntervateUser:(NSMutableDictionary *) dataDict {
    NSNumber *dataContext = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataContext];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_ReactOrgIntervateUser, dataString);
    });
}

/**
 *  根据组织id获取上级的所有组织数据
 */
-(void)parseGetRecusiveParentOrgByOid:(NSMutableDictionary *) dataDict {
    NSMutableArray *orgArr = [[NSMutableArray alloc] init];
    
    /* 解析所属部门数据 */
    NSMutableArray *orgDatacontext = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    for (NSDictionary *orgDic in orgDatacontext) {
        OrgModel *orgModel=[[OrgModel alloc]init];
        [orgModel serializationWithDictionary:orgDic];
        [orgArr addObject:orgModel];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetRecusiveParentOrgByOid, orgArr);
    });
    
}


/**
 *  根据组织id集合返回的组织信息
 */
-(void)parserGetOrgByOids:(NSMutableDictionary *) dataDict {
    NSMutableArray *dataArr  = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableArray *orgEnterPriseArr = [NSMutableArray array];
    for(int i=0;i<dataArr.count;i++){
        NSDictionary *dataDic = [dataArr objectAtIndex:i];
        OrgEnterPriseModel *orgEnterPriseModel = [[OrgEnterPriseModel alloc] init];
        orgEnterPriseModel.ecode=[dataDic objectForKey:@"code"];
        orgEnterPriseModel.name=[dataDic objectForKey:@"name"];
        orgEnterPriseModel.eid=[dataDic objectForKey:@"oid"];
        orgEnterPriseModel.shortname=[dataDic objectForKey:@"shortname"];
        [orgEnterPriseArr addObject:orgEnterPriseModel];
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetOrgByOids, orgEnterPriseArr);
    });
}

/**
 *  企业的过期时间判断，true:未到期，false:到期
 */
-(void)parseEnterLicDeadLineAuthCheck:(NSMutableDictionary *) dataDict {
    NSNumber *dataContext = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataContext];
    
    NSDictionary *otherDic = [dataDict lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSString *type = [otherDic lzNSStringForKey:@"type"];
    NSDictionary *datadic = @{@"datastring" : dataString,@"type" : type};
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_EnterLicDeadLineAuthCheck, datadic);
    });
}

/**
 * 判断企业下是否给某应用授权
 */
-(void)parseOrgLicenseIsExistsAuth:(NSMutableDictionary *)dataDict {
    NSNumber *datacontext = [dataDict lzNSNumberForKey:WebApi_DataContext];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrganizationParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_OrgLicenseIsExistsAuth, datacontext);
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
