//
//  BasicinfoTempParse.m
//  LeadingCloud
//
//  Created by dfl on 16/6/21.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-06-21
 Version: 1.0
 Description: 临时消息--个人基本信息--用户名称改变
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "BasicinfoTempParse.h"
#import "AppUtils.h"
#import "UserDAL.h"
#import "LCProgressHUD.h"
#import "CooperationRootViewController2.h"
#import "AppViewController2.h"


@implementation BasicinfoTempParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(BasicinfoTempParse *)shareInstance{
    static BasicinfoTempParse *instance = nil;
    if (instance == nil) {
        instance = [[BasicinfoTempParse alloc] init];
    }
    return instance;
}

#pragma mark - 解析临时通知数据

/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic{
    NSString *handlertype = [dataDic lzNSStringForKey:@"handlertype"];
    
    BOOL isSendReport = NO;
    
    /* 用户名称改变 */
    if([handlertype isEqualToString:Handler_User_Basicinfo_UpdateUserName]){
        isSendReport = [self parseUserUpdateUserName:dataDic];
    }
    /* 用户身份切换的通知 */
    else if ([handlertype isEqualToString:Handler_User_Basicinfo_SwitchIdentiType]){
        isSendReport = [self parseUserSwitchIdentiType:dataDic];
    }
    /* 用户设置主企业的通知 */
    else if ([handlertype isEqualToString:Handler_User_Basicinfo_SetMainOeid]){
        isSendReport = [self parseUserSetMainOeid:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

/**
 *  用户名称改变的通知
 */
-(BOOL)parseUserUpdateUserName:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *uid=[body lzNSStringForKey:@"uid"];
    NSString *username=[body lzNSStringForKey:@"username"];
    NSString *quancheng=[body lzNSStringForKey:@"quancheng"];
    NSString *jiancheng=[body lzNSStringForKey:@"jiancheng"];
    if([[AppUtils GetCurrentUserID] isEqualToString:uid]){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[LZUserDataManager readCurrentUserInfo]];
        [dic setObject:username forKey:@"username"];
        [LZUserDataManager saveCurrentUserInfo:dic];
    }
    
    /* 修改数据库 */
    UserModel *usermodel = [[UserModel alloc] init];
    usermodel.uid = uid;
    usermodel.username=username;
    usermodel.quancheng = quancheng;
    usermodel.jiancheng = jiancheng;
    [[UserDAL shareInstance] updateAllTableUserInfo:usermodel];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        DDLogError(@"开始发送");
        __block BasicinfoTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_User_Account_ChangeFace, uid);
    });
    
    return YES;
}

/**
 *  用户身份切换的通知
 */
-(BOOL)parseUserSwitchIdentiType:(NSMutableDictionary *)dataDic{

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *preNavigationVC = appDelegate.lzGlobalVariable.currentNavigationController;
    //当前根视图控制器
    UIViewController *rootVC = [preNavigationVC.viewControllers objectAtIndex:0];
    
    
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *selectoid = [body lzNSStringForKey:@"selectoid"];
    NSString *useridentitype = [NSString stringWithFormat:@"%@",[body lzNSNumberForKey:@"useridentitype"]];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[LZUserDataManager readCurrentUserInfo]];
    NSMutableDictionary *notificaton = [dic lzNSMutableDictionaryForKey:@"notificaton"];
    if([useridentitype isEqualToString:@"1"]){
        [[self appDelegate].lzservice sendToServerForGet:WebApi_CloudUser routePath:WebApi_CloudUser_SwitchPersonidenType moduleServer:Modules_Default getData:nil otherData:nil];
        [notificaton setObject:[NSNumber numberWithUnsignedInt:1] forKey:@"identitytype"];
        [notificaton setObject:[AppUtils GetCurrentUserID] forKey:@"selectoid"];
        [dic setObject:notificaton forKey:@"notificaton"];
        [LZUserDataManager saveCurrentUserInfo:dic];
    }
    else{
        /* 从服务器端请求模板   企业的过期时间判断，true:未到期，false:到期 */
        WEAKSELF
        WebApiSendBackBlock backBlock = ^(NSMutableDictionary *dataDic){
            NSNumber *dataContext = [dataDic lzNSNumberForKey:WebApi_DataContext];
            NSString *dataString = [NSString stringWithFormat:@"%@",dataContext];
            if([dataString isEqualToString:@"0"]){//切换到个人
                [UIAlertView alertViewWithMessage:@"当前企业授权已过期，已切换至个人身份!"];
                [[weakSelf appDelegate].lzservice sendToServerForGet:WebApi_CloudUser routePath:WebApi_CloudUser_SwitchPersonidenType moduleServer:Modules_Default getData:nil otherData:nil];
                [notificaton setObject:[NSNumber numberWithUnsignedInt:1] forKey:@"identitytype"];
                [notificaton setObject:[AppUtils GetCurrentUserID] forKey:@"selectoid"];
            }
            else{
                NSMutableDictionary *postData = [NSMutableDictionary dictionary];
                
                [postData setObject:[AppUtils GetCurrentUserID] forKey:@"uid"];
                [postData setObject:selectoid forKey:@"selectoid"];
                
                [[weakSelf appDelegate].lzservice sendToServerForPost:WebApi_CloudUser routePath:WebApi_CloudUser_Update_Selected_Org moduleServer:Modules_Default getData:nil postData:postData otherData:nil];
                [notificaton setObject:[NSNumber numberWithUnsignedInt:2] forKey:@"identitytype"];
                [notificaton setObject:selectoid forKey:@"selectoid"];
            }
            [dic setObject:notificaton forKey:@"notificaton"];
            [LZUserDataManager saveCurrentUserInfo:dic];
        };
        NSDictionary *otherData = @{WebApi_DataSend_Other_BackBlock:backBlock,
                                    WebApi_DataSend_Other_ShowError:WebApi_DataSend_Other_SE_NotShowAll,
                                    };
        /* 企业的过期时间判断，true:未到期，false:到期 */
        [self.appDelegate.lzservice sendToServerForGet:WebApi_Organization routePath:WebApi_Organization_EnterLic_DeadLineAuthCheck moduleServer:Modules_Default getData:@{@"oeid" : [AppUtils GetCurrentOrgID]} otherData:otherData];
        
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block BasicinfoTempParse * service = self;
        
        if(([rootVC isKindOfClass:[CooperationRootViewController2 class]]||[rootVC isKindOfClass:[AppViewController2 class]]) && preNavigationVC.viewControllers.count>1){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您已在PC端切换身份，请重新进入!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAc = [UIAlertAction actionWithTitle:LZGDCommonLocailzableString(@"common_confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                UINavigationController *preNavigationVC = appDelegate.lzGlobalVariable.currentNavigationController;
//                [[appDelegate getMainController] selectTab:nil];
                [preNavigationVC popToRootViewControllerAnimated:NO];
                
            }];
            [alert addAction:sureAc];
            [[preNavigationVC.viewControllers objectAtIndex:preNavigationVC.viewControllers.count-1] presentViewController:alert animated:YES completion:^{
                
            }];
        }
        
        EVENT_PUBLISH_WITHDATA(service, EventBus_User_SwitchIdentiType, body);
    });
    
    return YES;
}


/**
 *  用户设置主企业的通知
 */
-(BOOL)parseUserSetMainOeid:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    if([[AppUtils GetCurrentUserID] isEqualToString:[body lzNSStringForKey:@"uid"]]){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[LZUserDataManager readCurrentUserInfo]];
        NSMutableDictionary *notification= [[NSMutableDictionary alloc] initWithDictionary:[dic objectForKey:@"notificaton"]];
        [notification setObject:[body lzNSStringForKey:@"oeid"] forKey:@"mainoeid"];
        [dic setObject:notification forKey:@"notificaton"];
        
        [LZUserDataManager saveCurrentUserInfo:dic];
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block BasicinfoTempParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_User_SetMainOeid, nil);
    });
    
    return YES;
}


@end
