//
//  MoreUserParse.m
//  LeadingCloud
//
//  Created by lz on 16/2/23.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-02-23
 Version: 1.0
 Description: 更多页签-我的资料
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "MoreUserParse.h"
#import "UserModel.h"
#import "UserDAL.h"
#import "NSDictionary+DicSerial.h"
#import "LZFormat.h"
#import "NSString+IsNullOrEmpty.h"
#import "ImRecentDAL.h"
#import "SysApiVersionDAL.h"

@implementation MoreUserParse

+(MoreUserParse *)shareInstance{
    static MoreUserParse *instance = nil;
    if (instance == nil) {
        instance = [[MoreUserParse alloc] init];
    }
    return instance;
}

-(void)parse:(NSMutableDictionary *)dataDic{
    
    
    NSString *route = [dataDic objectForKey:WebApi_Route];
    
    UserModel *userModel;
    
    if([route isEqualToString:WebApi_CloudUser_LoadUser]){
        [self parseLoadUser:dataDic];
    }
    else if([route isEqualToString:WebApi_CloudUser_List]){
        //得到我的资料数据
        NSMutableDictionary *userDataDic  = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
        NSDictionary *otherData  = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
        NSString *otherOperate  = [otherData lzNSStringForKey:WebApi_DataSend_Other_Operate];

        userModel=[[UserModel alloc] init];
        [userModel serializationWithDictionary:userDataDic];
        
        [[UserDAL shareInstance] addUserModel:userModel];
        
        /* 收到解绑手机的通知 */
        if([otherOperate isEqualToString:@"accountCancelBindMobile"]){
            if(![NSString isNullOrEmpty:userModel.email]){
                [LZUserDataManager saveUserLoginName:userModel.email];
            }
        }
        /* 收到解绑邮箱的通知 */
        else if([otherOperate isEqualToString:@"accountCancelBindEmail"]){
            if(![NSString isNullOrEmpty:userModel.mobile]){
                [LZUserDataManager saveUserLoginName:userModel.mobile];
            }
        }
        
        /* 更新SysApiVersion */
        [[SysApiVersionDAL shareInstance] updateServerVersionToClientVersionWithCode:LogoinWebApi_api_user_getusercenter_S13];

        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block MoreUserParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_More_User_List, userModel);
            EVENT_PUBLISH_WITHDATA(service, EventBus_SendFirstLaunchPercentage, nil);
        });
    }
    else if([route isEqualToString:WebApi_CloudUser_Update_User]){
        NSString *datacontext=[dataDic lzNSStringForKey:WebApi_DataContext];
        NSMutableDictionary *datasend_post=[dataDic lzNSMutableDictionaryForKey:WebApi_DataSend_Post];
        NSString *uid=[datasend_post objectForKey:@"uid"];
        NSString *sub=[datasend_post objectForKey:@"subject"];
        userModel=[[UserModel alloc] init];
        if([datacontext isEqualToString:uid]){
            if([sub isEqualToString:@"1"]){//修改个人昵称
                userModel.uid=datacontext;
                NSString *userName=[datasend_post objectForKey:@"username"];
                [[UserDAL shareInstance] updateUserWithUid:userModel userName:userName];
            }else if ([sub isEqualToString:@"2"]){//修改性别
                userModel.uid=datacontext;
                NSInteger gender=[LZFormat Safe2Int32:[datasend_post objectForKey:@"gender"]];
                [[UserDAL shareInstance] updateUserWithUid:userModel userSex:gender];
            }else if ([sub isEqualToString:@"3"]){//修改地区
                userModel.uid=datacontext;
                NSString *province=[datasend_post objectForKey:@"province"];
                NSString *city=[datasend_post objectForKey:@"city"];
                NSString *county=[datasend_post objectForKey:@"county"];
                [[UserDAL shareInstance] updateUserWithUid:userModel province:province city:city county:county];
            }else if ([sub isEqualToString:@"4"]){//修改生日
                userModel.uid=datacontext;
                NSDate *birthday=[LZFormat String2Date:[datasend_post objectForKey:@"birthday"]];
                [[UserDAL shareInstance]updateUserWithUid:userModel userBirthday:birthday];
            }
            else if ([sub isEqualToString:@"5"]){//修改办公电话
                userModel.uid = datacontext;
                NSString *officecall = [datasend_post lzNSStringForKey:@"officecall"];
                [[UserDAL shareInstance]updateUserWithUid:userModel officecall:officecall];
            }
            else if ([sub isEqualToString:@"6"]){//修改详细地址
                userModel.uid = datacontext;
                NSString *address = [datasend_post lzNSStringForKey:@"address"];
                [[UserDAL shareInstance]updateUserWithUid:userModel address:address];
            }

        }
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 通知界面 如果成功的话就把解析过的值传到 EventBus_LZOneFieldValueEdit_Success 页面*/
            __block MoreUserParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_LZOneFieldValueEdit_Success, dataDic);
        });
        
    }
    /* 修改头像 */
    else if ([route isEqualToString:WebApi_CloudUser_Update_UserFace]){
        
//        NSString *dataContext=[NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
        NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
        NSString *dataContext = [NSString stringWithFormat:@"%@",dataNumber];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block MoreUserParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_More_User_Update_UserFace, dataContext);
        });
    }
    /* 组织切换 */
    else if([route isEqualToString:WebApi_CloudUser_Update_Selected_Org]){
        NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Post];
    
        NSString *selectoid=[param objectForKey:@"selectoid"];
        NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
        NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[LZUserDataManager readCurrentUserInfo]];
        NSMutableDictionary *notification= [[NSMutableDictionary alloc] initWithDictionary:[dic objectForKey:@"notificaton"]];
        
        [notification setObject:selectoid forKey:@"selectoid"];
        [notification setObject:[NSNumber numberWithUnsignedInt:2] forKey:@"identitytype"];
        [dic setObject:notification forKey:@"notificaton"];
        
        [LZUserDataManager saveCurrentUserInfo:dic];

//        [LZUserDataManager saveEnterpriseidInfo:enterprisesDict];
        /* 通知界面 如果成功的话就把解析过的值传到 EventBus_LZOneFieldValueEdit_Success 页面*/
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block MoreUserParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_Update_Selected_Org, dataString);
            EVENT_PUBLISH_WITHDATA(service, EventBus_SendFirstLaunchPercentage, nil);
        });
    }
    /* 修改密码 */
    else if ([route isEqualToString:WebApi_CloudUser_Update_UserPwdByUp]){
//        NSString *dataString  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
        NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
        NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block MoreUserParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_More_User_Update_UserPwdByUp, dataString);
        });
    }
    /* 换绑验证密码 */
    else if ([route isEqualToString:WebApi_CloudUser_ValidPassword]){
        [self parseValidPassword:dataDic];
    }
    /* 发送手机验证码 */
    else if ([route isEqualToString:WebApi_CloudUser_SendMobileValidCode]){
        [self parseSendMobileValidCode:dataDic];
    }
    /* 修改手机号码绑定 */
    else if ([route isEqualToString:WebApi_CloudUser_UpdateBindUserPhone]){
        [self parseUpdateBindUserPhone:dataDic];
    }
    /* 判断是否需要对发送验证码进行图形校验 */
    else if ([route isEqualToString:WebApi_CloudUser_IsNeedEmailValidGraph] || [route isEqualToString:WebApi_CloudUser_IsNeedMobileValidGraph]){
        [self parseIsNeedValidGraph:dataDic];
    }
    /* 发送邮箱验证码 */
    else if ([route isEqualToString:WebApi_CloudUser_SendEmailValidCode]){
        [self parseSendEmailValidCode:dataDic];
    }
    /* 修改邮箱绑定 */
    else if ([route isEqualToString:WebApi_CloudUser_UpdateBindUserEmail]){
        [self parseUpdateBindUserEmail:dataDic];
    }
    /* 解除邮箱绑定 */
    else if ([route isEqualToString:WebApi_CloudUser_CancelBindEmail]){
        [self parseCancelBindeMail:dataDic];
    }
    /* 解除手机绑定 */
    else if ([route isEqualToString:WebApi_CloudUser_CancelBindPhone]){
        [self parseCancelBindPhone:dataDic];
    }
    /* 切换个人身份 */
    else if ([route isEqualToString:WebApi_CloudUser_SwitchPersonidenType]){
        [self parseSwitchPersonidenType:dataDic];
    }
    /* 组织管理员重置成员密码 */
    else if ([route isEqualToString:WebApi_CloudUser_UpadteUserPwdBySetting]){
        [self parseUpadteUserPwdBySetting:dataDic];
    }
    /* 用户设置主企业 */
    else if ([route isEqualToString:WebApi_CloudUser_SetMainOrg]){
        [self parseSetMainOrg:dataDic];
    }
    /* 解绑第三方登录 */
    else if ([route isEqualToString:WebApi_CloudUser_CancelBindWeChat] || [route isEqualToString:WebApi_CloudUser_CancelBindWeBo] || [route isEqualToString:WebApi_CloudUser_CancelBindQQ]){
        [self parseCancelBindIndentity:dataDic];
    }
    /* 登录校验判断验证码 */
    else if ([route isEqualToString:WebApi_CloudUser_IsMatchValidCode]){
        [self parseIsMatchValidCode:dataDic];
    }
    
}

/**
 *  解析用户基本信息
 */
-(void)parseLoadUser:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *userDic  = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    
    if([NSString isNullOrEmpty:[userDic lzNSStringForKey:@"uid"]]){
        return;
    }
    
    UserModel *userModel = [[UserModel alloc] init];
    [userModel serializationWithDictionary:userDic];

    [[UserDAL shareInstance] addUserModel:userModel];
    
    __block MoreUserParse * service = self;
    
    NSDictionary *otherData  = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
    NSString *otherOperate  = [otherData lzNSStringForKey:WebApi_DataSend_Other_Operate];

    /* 获取用户信息，更新最近联系人使用 */
    if(![NSString isNullOrEmpty:otherOperate]){
        if([otherOperate isEqualToString:@"update_imrecent"]){
            NSString *contactid  = [dataDic objectForKey:WebApi_DataSend_Post];
            [[ImRecentDAL shareInstance] updateContactNameAndRelattypeAndFace:contactid];
            self.appDelegate.lzGlobalVariable.chatDialogID = contactid;
            self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
        }
        else if( [otherOperate isEqualToString:@"update_imrecent_lastusername"]){
            NSString *from  = [dataDic objectForKey:WebApi_DataSend_Post];
            [[ImRecentDAL shareInstance] updateLastMsgUsernam:userModel.username userid:from];
            self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
        }
        else if( [otherOperate isEqualToString:@"reloadchatview"]) {
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                EVENT_PUBLISH_WITHDATA(service, EventBus_More_User_LoadUser_ReloadChatView, dataDic);
            });
        }
        else if( [otherOperate isEqualToString:@"chatgrouprecvlist"] ){
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *sendDic = @{@"usermodel":userModel,@"datadic":dataDic};
                EVENT_PUBLISH_WITHDATA(service, EventBus_More_User_LoadUserForChatGroupRecvList, sendDic);
            });
        }
        else if( [otherOperate isEqualToString:@"nooperate"]) {
            return;
        }
    }
    else {
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_More_User_LoadUser, userModel);
        });
    }
}


/**
 *  换绑验证密码
 */
-(void)parseValidPassword:(NSMutableDictionary *)dataDict{
    //    NSString *dataString  = [NSString stringWithFormat:@"%@",[dataDict lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block MoreUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_User_ValidPassword, dataString);
    });
}

/**
 *  发送手机验证码
 */
-(void)parseSendMobileValidCode:(NSMutableDictionary *)dataDict{
    //    NSString *dataString  = [NSString stringWithFormat:@"%@",[dataDict lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    NSString *sendData= [[dataDict lzNSMutableDictionaryForKey:WebApi_DataSend_Post] lzNSStringForKey:@"uvobj"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:dataString forKey:@"datacontext"];
    [dic setObject:sendData forKey:@"sendData"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block MoreUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_User_SendMobileValidCode, dic);
    });
}

/**
 *  修改手机号码绑定
 */
-(void)parseUpdateBindUserPhone:(NSMutableDictionary *)dataDict{
    //    NSString *dataString  = [NSString stringWithFormat:@"%@",[dataDict lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block MoreUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_User_UpdateBindUserPhone, dataString);
    });
}


/**
 *  判断是否需要对发送验证码进行图形校验
 */
-(void)parseIsNeedValidGraph:(NSMutableDictionary *)dataDict{

    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    NSString *uvobj= [[dataDict lzNSMutableDictionaryForKey:WebApi_DataSend_Post] lzNSStringForKey:@"uvobj"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:dataString forKey:@"datastring"];
    [dic setObject:uvobj forKey:@"uvobj"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block MoreUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_User_IsNeedValidGraph, dic);
    });
}

/**
 *  发送邮箱验证码
 */
-(void)parseSendEmailValidCode:(NSMutableDictionary *)dataDict{
    //    NSString *dataString  = [NSString stringWithFormat:@"%@",[dataDict lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    NSString *sendData= [[dataDict lzNSMutableDictionaryForKey:WebApi_DataSend_Post] lzNSStringForKey:@"uvobj"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:dataString forKey:@"datacontext"];
    [dic setObject:sendData forKey:@"sendData"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block MoreUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_User_SendEmailValidCode, dic);
    });
}

/**
 *  修改邮箱绑定
 */
-(void)parseUpdateBindUserEmail:(NSMutableDictionary *)dataDict{
    //    NSString *dataString  = [NSString stringWithFormat:@"%@",[dataDict lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block MoreUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_User_UpdateBindUserEmail, dataString);
    });
}

/**
 *  解除邮箱绑定
 */
-(void)parseCancelBindeMail:(NSMutableDictionary *)dataDict{
    //    NSString *dataString  = [NSString stringWithFormat:@"%@",[dataDict lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block MoreUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_User_CancelBindeMail, dataString);
    });
}

/**
 *  解除手机绑定
 */
-(void)parseCancelBindPhone:(NSMutableDictionary *)dataDict{
    //    NSString *dataString  = [NSString stringWithFormat:@"%@",[dataDict lzNSStringForKey:WebApi_DataContext]];
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block MoreUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_User_CancelBindPhone, dataString);
    });
}

/**
 *  切换个人身份
 */
-(void)parseSwitchPersonidenType:(NSMutableDictionary *)dataDict{
    
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[LZUserDataManager readCurrentUserInfo]];
    NSMutableDictionary *notification= [[NSMutableDictionary alloc] initWithDictionary:[dic objectForKey:@"notificaton"]];
    [notification setObject:[AppUtils GetCurrentUserID] forKey:@"selectoid"];
    [notification setObject:[NSNumber numberWithUnsignedInt:1] forKey:@"identitytype"];
    [dic setObject:notification forKey:@"notificaton"];
    
    [LZUserDataManager saveCurrentUserInfo:dic];

    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block MoreUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_User_SwitchPersonidenType, dataString);
    });
}

/**
 *  组织管理员重置成员密码
 */
-(void)parseUpadteUserPwdBySetting:(NSMutableDictionary *)dataDict{
    
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block MoreUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_User_UpadteUserPwdBySetting, dataString);
    });
}


/**
 *  用户设置主企业
 */
-(void)parseSetMainOrg:(NSMutableDictionary *)dataDict{
    
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    NSString *oeid= [[dataDict lzNSMutableDictionaryForKey:WebApi_DataSend_Get] lzNSStringForKey:@"oeid"];
    if([dataString isEqualToString:@"1"]){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[LZUserDataManager readCurrentUserInfo]];
        NSMutableDictionary *notification= [[NSMutableDictionary alloc] initWithDictionary:[dic objectForKey:@"notificaton"]];
        [notification setObject:oeid forKey:@"mainoeid"];
        [dic setObject:notification forKey:@"notificaton"];
        
        [LZUserDataManager saveCurrentUserInfo:dic];
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block MoreUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_User_SetMainOrg, dataString);
    });
}


/**
 *  解除第三方登录绑定
 */
-(void)parseCancelBindIndentity:(NSMutableDictionary *)dataDict{
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block MoreUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_User_CancelBindIndentity, dataString);
    });
}


/**
 *  登录校验判断验证码
 */
-(void)parseIsMatchValidCode:(NSMutableDictionary *)dataDict{
    NSNumber *dataNumber  = [dataDict lzNSNumberForKey:WebApi_DataContext];
    NSString *dataString = [NSString stringWithFormat:@"%@",dataNumber];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block MoreUserParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_User_IsMatchValidCode, dataString);
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
