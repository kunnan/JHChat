//
//  ColleaguelistParse.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2015-12-24
 Version: 1.0
 Description: 解析我的好友
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ColleaguelistParse.h"
#import "LZUtils.h"
#import "UserContactDAL.h"
#import "UserDAL.h"
#import "UserContactGroupDAL.h"
#import "UserContactOfenCooperationDAL.h"
#import "UserIntervateDAL.h"
#import "TagDataDAL.h"
#import "OrgUserIntervateDAL.h"
#import "AppDateUtil.h"
#import "UserInfoDAL.h"
#import "SysApiVersionDAL.h"

//          常量：好友标签id
#define UserTagValue_TypeId @"contactgroup"

@implementation ColleaguelistParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ColleaguelistParse *)shareInstance{
    static ColleaguelistParse *instance = nil;
    if (instance == nil) {
        instance = [[ColleaguelistParse alloc] init];
    }
    return instance;
}

/**
 *  解析数据
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parse:(NSMutableDictionary *)dataDic{
    NSString *route = [dataDic lzNSStringForKey:WebApi_Route];
    if([route isEqualToString:WebApi_Colleaguelist_GetColleagues])  [self parseGetColleagues:dataDic];    //  我的好友
    else if([route isEqualToString:WebApi_Colleaguelist_GetContactGroup]) [self parseContactGroup:dataDic];//我的好友标签
    else if([route isEqualToString:WebApi_Colleaguelist_OfenCooperation]) [self parseOfenCooperation:dataDic];//我的最近联系人
    else if([route isEqualToString:WebApi_Colleaguelist_GetUserInterList]) [self parseGetUserInterList:dataDic];//【新的好友】
    else if([route isEqualToString:WebApi_Colleaguelist_GetContractListWithTag]) [self parseGetContractListWithTag:dataDic];//我的好友和标签之间的关系
    else if([route isEqualToString:WebApi_Colleaguelist_GetOrgInterListByUid]) [self parseNewOrgs:dataDic];//【新的组织】
    else if ([route isEqualToString:WebApi_Colleaguelist_AddNewFriend] || [route isEqualToString:WebApi_Colleaguelist_AddNewFriend_GraphCode]) [self parseAddNewFirends:dataDic];//【邀请新好友】
    else if ([route isEqualToString:WebApi_Colleaguelist_GetUidByLoginName]) [self parseGetUidByLoginName:dataDic];
    //          设置备注名称
    else if([route hasPrefix:@"api/colleaguelist/addremark/"]) {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 完成备注名字输入后 通知界面 */
            __block ColleaguelistParse *service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, nil);
        });
    }
    //          添加好友标签
    else if([route isEqualToString:WebApi_Colleaguelist_AddContactGroup]){
        NSDictionary *postDate = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];

        /* 添加标签分组 */
        UserContactGroupModel *groupModel = [[UserContactGroupModel alloc] init];
        groupModel.ucgId = [dataDic lzNSStringForKey:WebApi_DataContext];
        groupModel.tagValue = [postDate lzNSStringForKey:@"tagvalue"];
        groupModel.addTime = [LZFormat String2Date:[postDate lzNSStringForKey:@"addtime"]];
        
        [[UserContactGroupDAL shareInstance] addDataWithUserContactGroupArray:[[NSMutableArray alloc] initWithObjects:groupModel, nil]];
        
        /* 添加标签人员 */        
        NSMutableArray *tmpModels=[[NSMutableArray alloc]init];
        for (NSString *ucid in [postDate lzNSArrayForKey:@"ucidlist"]){
            TagDataModel *tmpModel=[[TagDataModel alloc]init];
            tmpModel.tdid=[LZUtils CreateGUID];
            tmpModel.taid=nil;
            tmpModel.name=nil;
            tmpModel.ttid=UserTagValue_TypeId;
            tmpModel.dataid=nil;
            tmpModel.oid=nil;
            tmpModel.uid=nil;//按照正常逻辑，这里应当将用户Id存到这里来，但是服务器返回的是 ctid，所有先不存
            tmpModel.dataextend1=groupModel.ucgId;//将标签id存到这里
            tmpModel.dataextend2=ucid;//将ctid存到这里
            [tmpModels addObject:tmpModel];
        }        
        [[TagDataDAL shareInstance] addDataWithTagDataArray:tmpModels];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block ColleaguelistParse *service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_AddContactGroup, dataDic);
        });
    }
    //新的组织临时通知得到数据
    else if([route isEqualToString:WebApi_Organization_GetOrgUserInterInfoByUidOeid]){
        [self parseGetOrgUserInterInfoByUidOeid:dataDic];
    }
    //新的好友同意添加
    else if ([route isEqualToString:WebApi_Colleaguelist_AddFriend]){
        [self parseAddFriend:dataDic];
    }
    //新的好友拒绝添加
    else if ([route isEqualToString:WebApi_Colleaguelist_RefuseApply]){
        [self parseRefuseApply:dataDic];
    }
    //新的好友临时通知数据
    else if ([route isEqualToString:WebApi_Colleaguelist_GetNewFriendsByuid]){
        [self parseGetNewFriendsByuid:dataDic];
    }
    //新的好友临时通知同意
    else if ([route isEqualToString:WebApi_Colleaguelist_GetAppendUserContact]){
        [self parseGetAppendUserContact:dataDic];
    }
    /* 删除经常协作人员 */
    else if( [route isEqualToString:WebApi_Colleaguelist_RemoveOfterCooperation]){
        [self parseRemoveOfterCooperation:dataDic];
    }
    /* 移动端标签下选择人员 */
    else if( [route isEqualToString:WebApi_Colleaguelist_BatTagAddUsersByMobile]){
        [self parseBatTagAddUsersByMobile:dataDic];
    }
    /* 获取用户名片信息 */
    else if( [route isEqualToString:WebApi_Colleaguelist_BusinessCardForMobile]){
        [self parseBusinessCardForMobile:dataDic];
    }
    /* 添加好友 */
    else if ( [route isEqualToString:WebApi_Colleaguelist_InviteFriend]){
        [self parseInviteFriend:dataDic];
    }
    /* 解除好友关系 */
    else if ( [route isEqualToString:WebApi_Colleaguelist_RemoveFriend]){
        [self parseRemoveFriend:dataDic];
    }
    /* 解除星标好友 */
    else if ( [route isEqualToString:WebApi_Colleaguelist_RemoveEspecially]){
        [self parseRemoveEspecially:dataDic];
    }
    /* 设为星标好友 */
    else if ( [route isEqualToString:WebApi_Colleaguelist_AddEspecially]){
        [self parseAddEspecially:dataDic];
    }
    /* 新的好友删除好友申请 */
    else if ( [route isEqualToString:WebApi_Colleaguelist_DeleteFriendApply]){
        [self parseDeleteFriendApply:dataDic];
    }
    /* 移除标签分组 */
    else if ( [route isEqualToString:WebApi_Colleaguelist_Remove]){
        [self parseRemove:dataDic];
    }
    /* 通讯录管理中，根据筛选条件返回某个企业下的用户列表 */
    else if ( [route isEqualToString:WebApi_Colleaguelist_GetColorgUserByFilter]){
        [self parseGetColorgUserByFilter:dataDic];
    }
    /* 设置详情 */
    else if ( [route isEqualToString:WebApi_Colleaguelist_Contact_UpdateUserDetail]){
        [self paresUpdateUserDetail:dataDic];
    }
    
    
    
    
    
}

/**
 *  解析我的好友数据
 */
-(void)parseGetColleagues:(NSMutableDictionary *)dataDic{
    NSMutableArray *dataArray  = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    
    NSMutableArray<UserContactModel *> *allUserContractArr = [[NSMutableArray alloc] init];
    NSMutableArray<UserModel *> *allUserModelArr=[[NSMutableArray alloc]init];
    for(int i=0;i<dataArray.count;i++){
        NSDictionary *dataDic = [dataArray objectAtIndex:i];
        NSString *ucid = [dataDic objectForKey:@"ucid"];
        NSString *uid = [dataDic objectForKey:@"uid"];
        //          组装联系人记录
        UserContactModel *userContactModel = [[UserContactModel alloc] init];
        userContactModel.ucid = ucid;
        userContactModel.ctid = uid;
        userContactModel.especially=(int)[LZFormat Safe2Int32:[dataDic objectForKey:@"especially"]];
        [allUserContractArr addObject:userContactModel];
        //          组装联系人对应的user详细信息
        UserModel *userModel=[[UserDAL shareInstance] getUserDataWithUid:[dataDic objectForKey:@"uid"]];
        if(userModel == nil){
            userModel=[[UserModel alloc]init];
        }
        userModel.uid=[dataDic objectForKey:@"uid"];
        userModel.username=[dataDic objectForKey:@"username"];
        userModel.mobile=[dataDic objectForKey:@"mobile"];
        userModel.email=[dataDic objectForKey:@"email"];
        userModel.qq=[dataDic objectForKey:@"qq"];
        userModel.face=[dataDic objectForKey:@"face"];
        userModel.quancheng=[dataDic objectForKey:@"quancheng"];
        userModel.jiancheng=[dataDic objectForKey:@"jiancheng"];
        [allUserModelArr addObject:userModel];
    }
    //在插入数据以前，先清除掉所有数据
    [[UserContactDAL shareInstance] deleteAllData];
    
    //      加入数据库
    [[UserContactDAL shareInstance] addDataWithArray:allUserContractArr];
    [[UserDAL shareInstance] addDataWithUserArray:allUserModelArr];
    
    /* 更新SysApiVersion */
    [[SysApiVersionDAL shareInstance] updateServerVersionToClientVersionWithCode:LogoinWebApi_api_colleaguelist_getcolleagues_S4];

    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Contact_MyFriendInfo_DataChanged" object:nil];
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_SendFirstLaunchPercentage, nil);
    });
}

#pragma mark - 解析我的好友标签信息
/**
 *  解析我的好友标签信息
 *  @param dataDict
 */
-(void)parseContactGroup:(NSMutableDictionary *)dataDict{
    NSMutableArray *dataArray  = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableArray<UserContactGroupModel *> *tmpModels=[[NSMutableArray alloc]init];
    //          将网络数据，转换为数据库Model
    for (int i=0;i<dataArray.count;i++){
        NSDictionary *tmpData=(NSDictionary *)[dataArray objectAtIndex:i];
        UserContactGroupModel *model=[[UserContactGroupModel alloc]init];
        model.ucgId=[tmpData objectForKey:@"id"];
        model.tagValue=[tmpData objectForKey:@"name"];
        //              加入数组
        [tmpModels addObject:model];
    }
    //          插入前，先删除
    [[UserContactGroupDAL shareInstance] deleteAllData];
    [[UserContactGroupDAL shareInstance] addDataWithUserContactGroupArray:tmpModels];
    
    /* 更新SysApiVersion */
    [[SysApiVersionDAL shareInstance] updateServerVersionToClientVersionWithCode:LogoinWebApi_api_colleaguelist_getcontactgroup_S5];

    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_SendFirstLaunchPercentage, nil);
    });
}

#pragma mark - 解析【常用联系人】数据
/**
 *   解析【常用联系人】数据
 *  @param dataDict
 */
-(void)parseOfenCooperation:(NSMutableDictionary *) dataDict{
    //这里面冗余了用户的信息，需要同步到数据库中
    NSMutableArray *dataArray  = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableArray<UserContactOfenCooperationModel *> *tmpModels=[[NSMutableArray alloc]init];
    NSMutableArray<UserModel *> *tmpUserModels=[[NSMutableArray alloc]init];
    for (int i=0;i<dataArray.count;i++){
        NSDictionary *tmpData=(NSDictionary *)[dataArray objectAtIndex:i];
        UserContactOfenCooperationModel *model=[[UserContactOfenCooperationModel alloc]init];
        model.ucoid=[LZUtils CreateGUID];
        model.receiverid=[tmpData objectForKey:@"uid"];
        model.receivername=[tmpData objectForKey:@"username"];
        model.showindex = i;
        [tmpModels addObject: model];
        
        //      获取用户的信息
        UserModel *userModel =[[UserModel alloc]init];
        userModel.uid=[tmpData objectForKey:@"uid"];
        userModel.email=[tmpData objectForKey:@"email"];
        userModel.face=[tmpData objectForKey:@"face"];
        userModel.mobile=[tmpData objectForKey:@"mobile"];
        userModel.qq=[tmpData objectForKey:@"qq"];
        userModel.quancheng=[tmpData objectForKey:@"quancheng"];
        userModel.username=[tmpData objectForKey:@"username"];
        
        [tmpUserModels addObject:userModel];
    }
    
    //插入前，先清空数据
    [[UserContactOfenCooperationDAL shareInstance] deleteAllData];
    [[UserContactOfenCooperationDAL shareInstance] addDataWithUserContactOftenCooperationArray:tmpModels];
    //          插入用户数据
    [[UserDAL shareInstance] addDataWithUserArray:tmpUserModels];
    
    /* 更新SysApiVersion */
    [[SysApiVersionDAL shareInstance] updateServerVersionToClientVersionWithCode:LogoinWebApi_api_colleaguelist_ofencooperation_S7];
    
    
    /* 刷新联系人跟视图 */
    NSDictionary *otherDic = [dataDict lzNSDictonaryForKey:WebApi_DataSend_Other];
    if([[otherDic lzNSStringForKey:WebApi_DataSend_Other_Operate] isEqualToString:@"refreshcontactrootviewcontroller"]){
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_ReloadOfenCooperation, nil);
        EVENT_PUBLISH_WITHDATA(service, EventBus_SendFirstLaunchPercentage, nil);
    }

}

#pragma mark - 解析【新的好友】数据
/**
 *  解析【新的好友】数据
 *  @param dataDict
 */
-(void)parseGetUserInterList:(NSMutableDictionary *)dataDict{
    NSMutableArray *dataArray  = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableArray<UserIntervateModel *> *tmpModels=[[NSMutableArray alloc]init];
    //          将网络数据，转换为数据库Model
    for (int i=0;i<dataArray.count;i++){
        NSDictionary *tmpData=(NSDictionary *)[dataArray objectAtIndex:i];
        UserIntervateModel *model=[[UserIntervateModel alloc]init];
        [model serializationWithDictionary:tmpData];
        //              加入数组
        [tmpModels addObject:model];
    }
    NSDictionary *param=[dataDict objectForKey:WebApi_DataSend_Post];
    NSString *lastkey=[param objectForKey:@"start"];
    if([lastkey isEqualToString:@"0"]){
        //          插入前，先删除
        [[UserIntervateDAL shareInstance] deleteAllData];
    }
    [[UserIntervateDAL shareInstance ]addDataWithArray:tmpModels];
    NSMutableDictionary *favoritesDict=[NSMutableDictionary dictionary];
    [favoritesDict setObject:lastkey forKey:@"lastkey"];
    [favoritesDict setObject:tmpModels forKey:@"userinterlist"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_GetUserInterList, favoritesDict);
    });
}

#pragma mark - 我的好友和标签之间的关系
/**
 *  我的好友和标签之间的关系
 *  @param dataDict
 */
-(void)parseGetContractListWithTag:(NSMutableDictionary *)dataDict{
    NSArray *responseData  = [dataDict lzNSArrayForKey:WebApi_DataContext];
    NSMutableArray<TagDataModel *> *tmpModels=[[NSMutableArray alloc]init];
    //          解析返回的数据
    for(int i=0;i<responseData.count;i++){
        NSDictionary *tmpDic=[responseData objectAtIndex:i];
        NSString *tagid=[tmpDic lzNSStringForKey:@"tagid"];
        NSArray *ucidlist=[tmpDic lzNSArrayForKey:@"ucidlist"];
        for(int j=0;j<ucidlist.count;j++){
            TagDataModel *tmpModel=[[TagDataModel alloc]init];
            tmpModel.tdid=[LZUtils CreateGUID];
            tmpModel.taid=nil;
            tmpModel.name=nil;
            tmpModel.ttid=UserTagValue_TypeId;
            tmpModel.dataid=nil;
            tmpModel.oid=nil;
            tmpModel.uid=nil;//按照正常逻辑，这里应当将用户Id存到这里来，但是服务器返回的是 ctid，所有先不存
            tmpModel.dataextend1=tagid;//将标签id存到这里
            tmpModel.dataextend2=[ucidlist objectAtIndex:j];//将ctid存到这里
            [tmpModels addObject:tmpModel];
        }
        
    }
//        插入前，先删除
    [[TagDataDAL shareInstance]deleteByTagTypeId:UserTagValue_TypeId];
    [[TagDataDAL shareInstance ]addDataWithTagDataArray:tmpModels];
    
    /* 更新SysApiVersion */
    [[SysApiVersionDAL shareInstance] updateServerVersionToClientVersionWithCode:LogoinWebApi_api_colleaguelist_getcontractlistwithtag_S6];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_GetContactList, dataDict);
        EVENT_PUBLISH_WITHDATA(service, EventBus_SendFirstLaunchPercentage, nil);
    });
}

#pragma mark - 解析【新的组织】数据
/**
 *  解析【新的组织】数据
 *  @param dataDict
 */
-(void)parseNewOrgs:(NSMutableDictionary *)dataDict{
    NSMutableArray *dataArray  = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableArray<OrgUserIntervateModel *> *tmpModels=[[NSMutableArray alloc]init];
    //          将网络数据，转换为数据库Model
    for (int i=0;i<dataArray.count;i++){
        NSDictionary *tmpData=(NSDictionary*)[dataArray objectAtIndex:i];
        OrgUserIntervateModel *model=[[OrgUserIntervateModel alloc]init];
        [model serializationWithDictionary:tmpData];
        [tmpModels addObject:model];
        
    }
    NSDictionary *param=[dataDict objectForKey:WebApi_DataSend_Post];
    NSString *lastkey=[param objectForKey:@"start"];
    if([lastkey isEqualToString:@"0"]){
       [[OrgUserIntervateDAL shareInstance]deleteAllData];
    }
    [[OrgUserIntervateDAL shareInstance ]addDataWithArray:tmpModels];
    NSMutableDictionary *favoritesDict=[NSMutableDictionary dictionary];
    [favoritesDict setObject:lastkey forKey:@"lastkey"];
    [favoritesDict setObject:tmpModels forKey:@"orgIntrtvateAll"];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 通知界面 */
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_NewOrgs, favoritesDict);
    });
}

#pragma mark - 新的组织临时通知数据调用
/**
 *  接受组织邀请
 *  @param dataDict
 */
-(void)parseGetOrgUserInterInfoByUidOeid:(NSMutableDictionary *)dataDict{
    NSMutableDictionary *dataDic = [dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableArray<OrgUserIntervateModel *> *tmpModels=[[NSMutableArray alloc]init];
    
    OrgUserIntervateModel *model=[[OrgUserIntervateModel alloc]init];
    [model serializationWithDictionary:dataDic];
    
    [tmpModels addObject:model];
    
    [[OrgUserIntervateDAL shareInstance ]addDataWithArray:tmpModels];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetOrgUserInterInfoByUidOeidData, tmpModels);
    });
}
/**
 *  通过手机或邮箱进行搜所添加好友
 *
 *  @param dataDict
 */
-(void)parseAddNewFirends:(NSMutableDictionary *)dataDict{
    
    NSMutableArray *dataArray  = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableArray<UserIntervateModel *> *tmpModels=[[NSMutableArray alloc]init];
    // 将网络数据，转换为数据库Model
    if (dataArray.count != 0) {
        NSDictionary *tmpData=(NSDictionary *)[dataArray objectAtIndex:0];
        UserIntervateModel *model=[[UserIntervateModel alloc]init];
        
        model.email = [tmpData objectForKey:@"email"];
        model.mobile = [tmpData objectForKey:@"mobile"];
        model.result = (int)[LZFormat Safe2Int32:[tmpData objectForKey:@"result"]];
        
        DDLogVerbose(@"API返回数组不为空，添加好友不成功");
        [tmpModels addObject:model];
        
    } else {
        DDLogVerbose(@"API返回数组为空，添加好友成功");
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Contact_AddNewFriend, tmpModels);
    });

}

/**
 *  通过登录名得到用户ID
 *
 *  @param dataDict
 */
-(void)parseGetUidByLoginName:(NSMutableDictionary *)dataDict{
    
    NSString *datacontext = [dataDict lzNSStringForKey:WebApi_DataContext];

    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Contact_GetUidByLoginName, datacontext);
    });
}
/**
 *  新的好友同意添加
 *
 *  @param dataDict
 */
-(void)parseAddFriend:(NSMutableDictionary *)dataDict{
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataS = [NSString stringWithFormat:@"%@",dataNumber];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_AddFriend, dataS);
    });
}

/**
 *  新的好友同意添加
 *
 *  @param dataDict
 */
-(void)parseRefuseApply:(NSMutableDictionary *)dataDict{
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataS = [NSString stringWithFormat:@"%@",dataNumber];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_RefuseApply, dataS);
    });
}

/**
 *  新的好友临时通知数据
 *
 *  @param dataDict
 */
-(void)parseGetNewFriendsByuid:(NSMutableDictionary *)dataDict{
    NSMutableDictionary *dataDic  = [dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableArray<UserIntervateModel *> *tmpModels=[[NSMutableArray alloc]init];
    
    UserIntervateModel *userIvModel=[[UserIntervateModel alloc]init];
    
    [userIvModel serializationWithDictionary:dataDic];
    
    [tmpModels addObject:userIvModel];
    
    [[UserIntervateDAL shareInstance]addDataWithArray:tmpModels];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_NewFriend_Data, tmpModels);
    });
}

/**
 *  新的好友临时通知同意
 *
 *  @param dataDict
 */
-(void)parseGetAppendUserContact:(NSMutableDictionary *)dataDict{
    NSMutableDictionary *dataDic  = [dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableDictionary *userscanmodel= [dataDic lzNSMutableDictionaryForKey:@"userscanmodel"];
    NSMutableArray *userContactArr=[NSMutableArray array];
    //用户关系表
    UserContactModel *userCtModel=[[UserContactModel alloc]init];
    userCtModel.ucid=[userscanmodel objectForKey:@"ucid"];
    userCtModel.ctid=[userscanmodel objectForKey:@"uid"];
    userCtModel.remark=[userscanmodel objectForKey:@"remark"];
    userCtModel.especially=[LZFormat Safe2Int32:[userscanmodel objectForKey:@"especially"]];
    [userContactArr addObject:userCtModel];
    
    //用户表
    UserModel *userModel=[[UserModel alloc]init];
    userModel.uid=[userscanmodel objectForKey:@"uid"];
    userModel.username=[userscanmodel objectForKey:@"username"];
    userModel.mobile=[userscanmodel objectForKey:@"mobile"];
    userModel.email=[userscanmodel objectForKey:@"email"];
    userModel.face=[userscanmodel objectForKey:@"face"];
    userModel.quancheng=[userscanmodel objectForKey:@"quancheng"];
    userModel.jiancheng=[userscanmodel objectForKey:@"jiancheng"];
    
    [[UserContactDAL shareInstance]addDataWithArray:userContactArr];
    [[UserDAL shareInstance]addUserModel:userModel];
    /* 刷新我的好友页面 */
    self.appDelegate.lzGlobalVariable.isNeedRefreshContactFriendListVC2 = YES;
    
}

/**
 *  删除经常协作人员
 */
-(void)parseRemoveOfterCooperation:(NSMutableDictionary *)dataDict{
    NSNumber *dataContext = [dataDict lzNSNumberForKey:WebApi_DataContext];
    if(dataContext.integerValue==1){
        NSString *uid = [dataDict lzNSStringForKey:WebApi_DataSend_Post];
        
        [[UserContactOfenCooperationDAL shareInstance] deleteByuId:uid];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block ColleaguelistParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_ReloadOfenCooperation, nil);
        });
    }
}

/**
 *  移动端标签下选择人员
 */
-(void)parseBatTagAddUsersByMobile:(NSMutableDictionary *)dataDict{
    NSString *dataContext=[dataDict lzNSStringForKey:WebApi_DataContext];
    NSDictionary *dataPost=[dataDict lzNSDictonaryForKey:WebApi_DataSend_Post];
    NSString *tagid=[dataPost lzNSStringForKey:@"tagid"];

    /* 添加标签分组 */
    UserContactGroupModel *userCGModel=[[UserContactGroupModel alloc]init];
    userCGModel.ucgId=dataContext;
    userCGModel.tagValue=[dataPost lzNSStringForKey:@"tagname"];
    [[UserContactGroupDAL shareInstance]addUserContactGroupModel:userCGModel];
    [[UserContactGroupDAL shareInstance]deleteByUCGId:tagid];
    
    /* 添加标签人员 */
    NSMutableArray *tmpModels=[[NSMutableArray alloc]init];
    for (NSString *ucid in [dataPost lzNSArrayForKey:@"allfriendids"]){
        TagDataModel *tmpModel=[[TagDataModel alloc]init];
        tmpModel.tdid=[LZUtils CreateGUID];
        tmpModel.taid=nil;
        tmpModel.name=nil;
        tmpModel.ttid=UserTagValue_TypeId;
        tmpModel.dataid=nil;
        tmpModel.oid=nil;
        tmpModel.uid=nil;//按照正常逻辑，这里应当将用户Id存到这里来，但是服务器返回的是 ctid，所有先不存
        tmpModel.dataextend1=dataContext;//将标签id存到这里
        tmpModel.dataextend2=ucid;//将ctid存到这里
        [tmpModels addObject:tmpModel];
    }
    [[TagDataDAL shareInstance]deleteByDataExtend1Value:tagid];
    
    [[TagDataDAL shareInstance] addDataWithTagDataArray:tmpModels];
    
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_BatTagAddUsersByMobile, dataPost);
    });
}

/**
 *  获取用户名片信息
 */
-(void)parseBusinessCardForMobile:(NSMutableDictionary *)dataDict{
    NSDictionary *cotainfojson=[dataDict lzNSDictonaryForKey:WebApi_DataContext];

    NSString *cotainuid=[cotainfojson lzNSStringForKey:@"uid"];
    NSDictionary *dataGet=[dataDict lzNSDictonaryForKey:WebApi_DataSend_Get];
    NSString *uid=[dataGet lzNSStringForKey:@"uid"];
    NSString *username=[cotainfojson lzNSStringForKey:@"username"];
    NSString *face=[cotainfojson lzNSStringForKey:@"face"];
    UserInfoModel *userInfoModel=[[UserInfoModel alloc]init];
    userInfoModel.uid=uid;
    userInfoModel.username=username;
    userInfoModel.face=face;
    userInfoModel.cotainfojson=cotainfojson;
    [[UserInfoDAL shareInstance]addUserInfoModel:userInfoModel];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_BusinessCardForMobile, cotainuid);
    });
}

/**
 *  添加好友
 */
-(void)parseInviteFriend:(NSMutableDictionary *)dataDict{
    NSString *tmpResult=[dataDict lzNSStringForKey:WebApi_DataContext];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_InviteFriend, tmpResult);
    });
}

/**
 *  解除好友关系
 */
-(void)parseRemoveFriend:(NSMutableDictionary *)dataDict{
    NSNumber *dataContext=[dataDict lzNSNumberForKey:WebApi_DataContext];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_RemoveFriend, dataContext);
    });
}

/**
 *  解除星标好友
 */
-(void)parseRemoveEspecially:(NSMutableDictionary *)dataDict{
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_RemoveEspecially, nil);
    });
}

/**
 *  设为星标好友
 */
-(void)parseAddEspecially:(NSMutableDictionary *)dataDict{
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_AddEspecially, nil);
    });
}

/**
 *  新的好友删除好友申请
 */
-(void)parseDeleteFriendApply:(NSMutableDictionary *)dataDict{
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    NSMutableDictionary *getDic=[dataDict lzNSMutableDictionaryForKey:WebApi_DataSend_Get];
    
    NSMutableDictionary *dataDic=[NSMutableDictionary dictionary];
    [dataDic setObject:dataString forKey:@"datacontext"];
    [dataDic setObject:[getDic lzNSStringForKey:@"uiid"] forKey:@"uiid"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_DeleteFriendApply, dataDic);
    });
}

/**
 *  移除标签分组
 */
-(void)parseRemove:(NSMutableDictionary *)dataDict{
    NSNumber *dataContext=[dataDict lzNSNumberForKey:WebApi_DataContext];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_RemoveLabelInfo, dataContext);
    });
}

/**
 *  通讯录管理中，根据筛选条件返回某个企业下的用户列表
 */
-(void)parseGetColorgUserByFilter:(NSMutableDictionary *)dataDict{
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_GetColorgUserByFilter, dataDict);
    });
}

/**
 *  设置详情
 */
-(void)paresUpdateUserDetail:(NSMutableDictionary *)dataDict{
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block ColleaguelistParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_UpdateUserDetail, dataDict);
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
