//
//  OrgUserParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/5/24.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "OrgUserParse.h"
#import "OrgUserModel.h"
#import "NSDictionary+DicSerial.h"
#import "UserDAL.h"

@implementation OrgUserParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrgUserParse *)shareInstance{
    static OrgUserParse *instance = nil;
    if (instance == nil) {
        instance = [[OrgUserParse alloc] init];
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
    /* 申请加入组织 */
    if([route isEqualToString:WebApi_OrgUser_UserApplyJoinOrg]){
        [self parseUserApplyJoinOrg:dataDic];
    }
    /* 获取当前部门下的人员(浏览、选人模式)--分页 */
    else if( [route isEqualToString:WebApi_OrgUser_GetColleagueUserByOIdPages] ){
        [self parseGetColleagueUserByOIdPages:dataDic];
    }
    /* 获取当前部门下的人员(管理模式)--分页 */
    else if( [route isEqualToString:WebApi_OrgUser_GetUserByOIdPages] ){
        [self parseGetUserByOIdPages:dataDic];
    }
    /* 修改员工所属部门 */
    else if( [route isEqualToString:WebApi_OrgUser_AdjustUserOrg] ){
        [self parseAdjustUserOrg:dataDic];
    }
    /* 添加员工 */
    else if ([route isEqualToString:WebApi_OrgUser_IntervateUserByUsingMobile] || [route isEqualToString:WebApi_OrgUser_IntervateUserByUsingMobile_GraphCode]){
        [self parseIntervateUserByUsingMobile:dataDic];
    }
    /* 修改员工名称 */
    else if( [route isEqualToString:WebApi_OrgUser_UpdateEnterUserName] ){
        [self parseUpdateEnterUserName:dataDic];
    }
    /* 删除部门下组织人员 */
    else if( [route isEqualToString:WebApi_OrgUser_DeleteOrgUser] ){
        [self parseDeleteOrgUser:dataDic];
    }
    /* 企业中删除组织人员 */
    else if ([route isEqualToString:WebApi_OrgUser_DeleteUserFromEnter]){
        [self parseDeleteUserFromEnter:dataDic];
    }
    /* 设置管理员 */
    else if( [route isEqualToString:WebApi_OrgUser_GetUserBySetBatchAdmin] ){
        [self parseGetUserBySetBatchAdmin:dataDic];
    }
    /* 取消管理员 */
    else if([route isEqualToString:WebApi_OrgUser_CancleAdmin]){
        [self parseCancleAdmin:dataDic];
    }
    /* 获取部门下的管理员 */
    else if ([route isEqualToString:WebApi_OrgUser_GetAdminiUserByOidPages] ){
        [self parseGetAdminiUserByOidPages:dataDic];
    }
    /* 公开用户在企业下的手机号码 */
    else if ([route isEqualToString:WebApi_OrgUser_OpenShowUserMobile]){
        [self parseOpenShowUserMobile:dataDic];
    }
    /* 屏蔽用户在企业下的手机号码公开 */
    else if ([route isEqualToString:WebApi_OrgUser_CloseShowUserMobile]){
        [self parseCloseShowUserMobile:dataDic];
    }
    /* 通过用户id集合邀请员工 */
    else if ([route isEqualToString:WebApi_OrgUser_Mobile_InviteuserByUids]){
        [self parseMobileInviteuserByUids:dataDic];
    }
    /* 修改员工所属部门（新） */
    else if ([route isEqualToString:WebApi_OrgUser_AdjustUserOrg_V2]){
        [self parseAdjustUserOrg:dataDic];
    }
}

#pragma mark - 解析数据

/**
 *  申请加入组织
 */
-(void)parseUserApplyJoinOrg:(NSMutableDictionary *)dataDict{
//    NSString *datacontext=[NSString stringWithFormat:@"%@",[dataDict lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *datacontext = [NSString stringWithFormat:@"%@",dataNumber];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_ApplyJoinOrg, datacontext);
    });
}

/**
 *  获取当前部门下的人员(浏览、选人模式)--分页
 */
-(void)parseGetColleagueUserByOIdPages:(NSMutableDictionary *)dataDict{
    NSMutableArray *orgUserArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *otherData = [dataDict lzNSMutableDictionaryForKey:WebApi_DataSend_Other];
    NSString *isLoadNextPage = [otherData lzNSStringForKey:@"isloadnextpage"];
    
    /* 解析部门人员数据 */
    NSMutableArray *datacontext = [dataDict lzNSMutableArrayForKey:WebApi_DataContext];
    for(NSDictionary *dic in datacontext){
        OrgUserModel *orgUserModel = [[OrgUserModel alloc] init];
        [orgUserModel serializationWithDictionary:dic];

        NSMutableDictionary *usermodel = [[NSMutableDictionary alloc] init];
        [usermodel setValue:orgUserModel.username forKey:@"username"];
        [usermodel setValue:orgUserModel.uid forKey:@"uid"];
        [usermodel setValue:orgUserModel.face forKey:@"face"];
        [usermodel setValue:[NSNumber numberWithInteger:orgUserModel.isadmin] forKey:@"isadmin"];
        orgUserModel.usermodelstr = [usermodel dicSerial];
        
        [orgUserArray addObject:orgUserModel];
    }
    
    NSDictionary *returnData = @{@"orgusers":orgUserArray,
                                 @"oid":[[dataDict objectForKey:WebApi_DataSend_Post] objectForKey:@"oid"],
                                 @"isloadnextpage":isLoadNextPage};
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetUserByOIdPages, returnData);
    });
}

/**
 *  获取当前部门下的人员(管理模式)--分页
 */
-(void)parseGetUserByOIdPages:(NSMutableDictionary *)dataDict{
    NSMutableArray *orgUserArray = [[NSMutableArray alloc] init];
    NSMutableArray *userArr = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *otherData = [dataDict lzNSMutableDictionaryForKey:WebApi_DataSend_Other];
//    NSString *pageViewModel = [otherData lzNSStringForKey:@"pageviewmodel"];
    NSString *isLoadNextPage = [otherData lzNSStringForKey:@"isloadnextpage"];
    
    /* 解析部门人员数据 */
    NSMutableDictionary *datacontextDic = [dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableArray *datacontext = [datacontextDic objectForKey:@"orgusersmodel"];
    for(NSDictionary *dic in datacontext){
        OrgUserModel *orgUserModel = [[OrgUserModel alloc] init];
        [orgUserModel serializationWithDictionary:dic];
        orgUserModel.usermodelstr = [[dic objectForKey:@"usermodel"] dicSerial];
        UserModel *usermodel=[[UserModel alloc]init];
        [usermodel serializationWithDictionary:[dic lzNSDictonaryForKey:@"usermodel"]];
//        /* 只有管理模式，才显示未激活人员 */
//        if(![pageViewModel isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)ContactPageViewModeEnterpriseManage]]){
//            if(orgUserModel.state!=1){
//                continue;
//            }
//        }
        
        [orgUserArray addObject:orgUserModel];
        [userArr addObject:usermodel];
    }
    
    
    NSDictionary *returnData = @{@"orgusers":orgUserArray,
                                 @"oid":[[dataDict objectForKey:WebApi_DataSend_Post] objectForKey:@"oid"],
                                 @"isloadnextpage":isLoadNextPage};
    /* 子线程执行 */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[UserDAL shareInstance]addDataWithUserArray:userArr];
    });
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetUserByOIdPages, returnData);
    });
}

/**
 *  修改员工所属部门
 */
-(void)parseAdjustUserOrg:(NSMutableDictionary *)dataDict{
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_AdjustUserOrg, dataDict);
    });
}

/**
 *  添加员工
 */
-(void)parseIntervateUserByUsingMobile:(NSMutableDictionary *)dataDict{
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_InvitateUserOrModifyUser, dataDict);
    });
}

/**
 *  修改员工名称
 */
-(void)parseUpdateEnterUserName:(NSMutableDictionary *)dataDict{
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_InvitateUserOrModifyUser, dataDict);
    });
}

/**
 *  删除部门下组织人员
 */
-(void)parseDeleteOrgUser:(NSMutableDictionary *)dataDict{
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_DeleteOrgUser, dataDict);
    });
}

/**
 *  企业中删除组织人员
 */
-(void)parseDeleteUserFromEnter:(NSMutableDictionary *)dataDict{
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_DeleteUserFromEnter, dataDict);
    });
}

/**
 *  设置管理员
 */
-(void)parseGetUserBySetBatchAdmin:(NSMutableDictionary *)dataDict{
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_SetBatchAdmin, dataDict);
    });
}

/**
 *  取消管理员
 */
-(void)parseCancleAdmin:(NSMutableDictionary *)dataDict{
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_CancleAdmin, dataDict);
    });
}

/**
 *  获取部门下的管理员
 */
-(void)parseGetAdminiUserByOidPages:(NSMutableDictionary *)dataDict{
    NSMutableArray *orgUserArray = [[NSMutableArray alloc] init];
    
    /* 解析部门下管理员数据 */
    NSMutableDictionary *datacontextDic = [dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableArray *datacontext = [datacontextDic objectForKey:@"orgusersmodel"];
    for(NSDictionary *dic in datacontext){
        OrgUserModel *orgUserModel = [[OrgUserModel alloc] init];
        [orgUserModel serializationWithDictionary:dic];
        orgUserModel.usermodelstr = [[dic objectForKey:@"usermodel"] dicSerial];
        
        [orgUserArray addObject:orgUserModel];
    }
    
    NSDictionary *returnData = @{@"adminusers":orgUserArray,
                                 @"oid":[[dataDict objectForKey:WebApi_DataSend_Post] objectForKey:@"oid"]};
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_GetAdminUsersByOid, returnData);
    });
}


/**
 *  公开用户在企业下的手机号码
 */
-(void)parseOpenShowUserMobile:(NSMutableDictionary *)dataDict{
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_OpenShowUserMobile, dataDict);
    });
}

/**
 *  屏蔽用户在企业下的手机号码
 */
-(void)parseCloseShowUserMobile:(NSMutableDictionary *)dataDict{
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_CloseShowUserMobile, dataDict);
    });
}

/**
 *  通过用户id集合邀请员工
 */
-(void)parseMobileInviteuserByUids:(NSMutableDictionary *)dataDict{
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block OrgUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_InvitateUserOrModifyUser, dataDict);
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
