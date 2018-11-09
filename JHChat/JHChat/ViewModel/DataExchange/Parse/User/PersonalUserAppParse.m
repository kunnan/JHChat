//
//  personalUserAppParse.m
//  LeadingCloud
//
//  Created by lz on 16/3/19.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-03-19
 Version: 1.0
 Description: 个人ios应用
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "PersonalUserAppParse.h"
#import "AppDAL.h"
#import "NSDictionary+DicSerial.h"
#import "SelfAppDAL.h"
#import "AppMenuDAL.h"
#import "ErrorDAL.h"
#import "ImMsgAppDAL.h"
#import "ImMsgAppModel.h"

@implementation PersonalUserAppParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PersonalUserAppParse *)shareInstance{
    static PersonalUserAppParse *instance = nil;
    if (instance == nil) {
        instance = [[PersonalUserAppParse alloc] init];
    }
    return instance;
}

/**
 *  解析数据
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parse:(NSMutableDictionary *)dataDic{
    NSString *route = [dataDic objectForKey:WebApi_Route];
//    //ios个人应用
//    if([route isEqualToString:WebApi_CloudApp_IOSApp]){
//        [self parseIOSApp:dataDic];
//    }
//    //获取当前组织和个人iOS应用
//    else if([route isEqualToString:WebApi_CloudApp_Org_IOSApp]){
//        [self parseOrgIOSApp:dataDic];
//    }
    /* 获取当前用户企业下的配置 */
    if([route isEqualToString:WebApi_CloudApp_GetPhoneUserOrgModel]){
        [self parseGetPhoneUserOrgModel:dataDic];
    }
    /* 获取当前用户企业下更多 */
    else if([route isEqualToString:WebApi_CloudApp_GetPhoneMoreModel]){
        [self parseGetPhoneMoreModel:dataDic];
    }
    /* 保存用户企业导航数据 */
    else if([route isEqualToString:WebApi_CloudApp_SaveUserOrgModel]){
        [self parseSaveUserOrgModel:dataDic];
    }
    /* 根据appid获取单个应用提醒数字 */
    else if ([route isEqualToString:WebApi_App_GetAppNumber]){
        [self parseGetAppNumber:dataDic];
    }
    /* 获取支持消息的应用 */
    else if ([route isEqualToString:WebApi_App_GetMagApp]) {
        [self parseGetMagApp:dataDic];
    }
    
}

#pragma mark - ios个人应用数据
/**
 *  ios个人应用数据
 *  @param dataDict
 */
//-(void)parseIOSApp:(NSMutableDictionary *)dataDict{
//    AppModel *appModel;
//    appModel=[[AppModel alloc]init];
//    NSMutableDictionary *allUserAppDic;
//    
//    NSMutableArray *allUserAppArray=[[NSMutableArray alloc]init];
//    NSMutableDictionary *userAppInfo  = [dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
//    for (NSString *appkey in userAppInfo.allKeys) {
//        allUserAppDic=[[NSMutableDictionary alloc]init];
//        appModel=[[AppModel alloc]init];
//        allUserAppDic=[userAppInfo objectForKey:appkey];
//        [appModel serializationWithDictionary:allUserAppDic];
//        if( [allUserAppDic objectForKey:@"appserver"] != [NSNull null]){
//            appModel.appserver = [[allUserAppDic objectForKey:@"appserver"] dicSerial];
//        }
//        else {
//            appModel.appserver = @"";
//        }
//        [allUserAppArray addObject:appModel];
//        
//    }
//    
//    [[AppDAL shareInstance] deleteAllData];
//    
//    [[AppDAL shareInstance] addDataWithAppArray:allUserAppArray];
//
//    /* 在主线程中发送通知 */
//    dispatch_async(dispatch_get_main_queue(), ^{
//        __block PersonalUserAppParse * service = self;
//        EVENT_PUBLISH_WITHDATA(service, EventBus_App_IOSApp, allUserAppArray);
//    });
//    
//}
//#pragma mark - 获取当前组织和个人iOS应用
///**
// *  获取当前组织和个人iOS应用
// *  @param dataDict
// */
//-(void)parseOrgIOSApp:(NSMutableDictionary *)dataDict{
//    AppModel *appModel;
//    appModel=[[AppModel alloc]init];
//    NSMutableDictionary *allUserAppDic;
//    
//    NSMutableArray *allUserAppArray=[[NSMutableArray alloc]init];
//    NSMutableDictionary *userOrgAppInfo  = [dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
//    for (NSString *appkey in userOrgAppInfo.allKeys) {
//        allUserAppDic=[[NSMutableDictionary alloc]init];
//        appModel=[[AppModel alloc]init];
//        allUserAppDic=[userOrgAppInfo objectForKey:appkey];
//        [appModel serializationWithDictionary:allUserAppDic];
//        if( [allUserAppDic objectForKey:@"appserver"] != [NSNull null]){
//            appModel.appserver = [[allUserAppDic objectForKey:@"appserver"] dicSerial];
//        }
//        else {
//            appModel.appserver = @"";
//        }
//        [allUserAppArray addObject:appModel];
//        
//    }
//    
//    [[AppDAL shareInstance] deleteAllData];
//    
//    [[AppDAL shareInstance] addDataWithAppArray:allUserAppArray];
//
//    /* 在主线程中发送通知 */
//    dispatch_async(dispatch_get_main_queue(), ^{
//        __block PersonalUserAppParse * service = self;
//        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Org_IOSApp, allUserAppArray);
//    });
//    
//}

/**
 *  获取当前用户企业下的配置
 *  @param dataDict
 */
-(void)parseGetPhoneUserOrgModel:(NSMutableDictionary *)dataDict{
    
    NSMutableArray *allUserAppArray=[[NSMutableArray alloc]init];
    NSMutableArray *allUserSelfAppArray = [[NSMutableArray alloc]init];
    NSMutableArray *newMenu = [NSMutableArray array];
    
    NSMutableDictionary *userOrgAppInfo  = [dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableDictionary *iosmenuconfigdic = [userOrgAppInfo lzNSMutableDictionaryForKey:@"iosmenuconfigdic"];
    NSDictionary *iosapp=[iosmenuconfigdic lzNSDictonaryForKey:@"iosapp"];
    NSDictionary *selfapplist = [iosmenuconfigdic lzNSDictonaryForKey:@"selfapplist"];
    NSArray *menu=[iosmenuconfigdic lzNSArrayForKey:@"menu"];
    for(NSString *iosappkey in iosapp){
        AppModel *appModel=[[AppModel alloc]init];
        NSMutableDictionary *iosappdic=[iosapp objectForKey:iosappkey];
        [appModel serializationWithDictionary:iosappdic];
        appModel.orgid = [AppUtils GetCurrentOrgID];
        appModel.appid = [NSString stringWithFormat:@"%@%@",[iosappdic lzNSStringForKey:@"appid"],[AppUtils GetCurrentOrgID]];
        appModel.nowappid = [iosappdic lzNSStringForKey:@"appid"];
        if( [iosappdic objectForKey:@"appserver"] != [NSNull null]){
            appModel.appserver = [[iosappdic objectForKey:@"appserver"] dicSerial];
        }
        else {
            appModel.appserver = @"";
        }
        [allUserAppArray addObject:appModel];
    }
    for(NSString *iosselfappkey in selfapplist){
        SelfAppModel *selfAppModel = [[SelfAppModel alloc]init];
        NSMutableDictionary *iosselfappdic=[selfapplist objectForKey:iosselfappkey];
        [selfAppModel serializationWithDictionary:iosselfappdic];
        selfAppModel.noworgid = [AppUtils GetCurrentOrgID];
        selfAppModel.osappid = [LZUtils CreateGUID];
        selfAppModel.nowosappid = [iosselfappdic lzNSStringForKey:@"osappid"];
        [allUserSelfAppArray addObject:selfAppModel];
    }
    for(int i=0;i<menu.count;i++){
        AppMenuModel *appMenuModel= [[AppMenuModel alloc]init];
        NSDictionary *appdic=[menu objectAtIndex:i];
        [appMenuModel serializationWithDictionary:appdic];
        appMenuModel.appmenuid = [LZUtils CreateGUID];
        appMenuModel.nowid = [appdic lzNSStringForKey:@"id"];
        appMenuModel.orgid = [AppUtils GetCurrentOrgID];
        [newMenu addObject:appMenuModel];
    }
    
    [[AppMenuDAL shareInstance] deleteAppMenuWithOrgid:[AppUtils GetCurrentOrgID]];
    [[AppMenuDAL shareInstance] addDataWithAppMenuArray:newMenu];
    
    [[AppDAL shareInstance] deleteAppWithOrgid:[AppUtils GetCurrentOrgID]];
    [[AppDAL shareInstance] addDataWithAppArray:allUserAppArray];
    
    [[SelfAppDAL shareInstance] deleteSelfAppWithOrgid:[AppUtils GetCurrentOrgID]];
    [[SelfAppDAL shareInstance] addDataWithSelfAppArray:allUserSelfAppArray];
    
    [iosmenuconfigdic setObject:newMenu forKey:@"menu"];
    
    NSMutableDictionary *appDics=[NSMutableDictionary dictionary];
    appDics[@"uoid"]=[userOrgAppInfo lzNSStringForKey:@"uoid"];
    appDics[@"uid"]=[userOrgAppInfo lzNSStringForKey:@"uid"];
    appDics[@"orgid"]=[userOrgAppInfo lzNSStringForKey:@"orgid"];
    appDics[@"iosmenuconfigdic"]=iosmenuconfigdic;

//    /* 刷新 */
//    NSDictionary *otherDic = [dataDict lzNSDictonaryForKey:WebApi_DataSend_Other];
//    if([[otherDic lzNSStringForKey:WebApi_DataSend_Other_Operate] isEqualToString:@"selectedApp"]){
//        /* 在主线程中发送通知 */
//        dispatch_async(dispatch_get_main_queue(), ^{
//            /* 刷新TabBar上的数字 */
//            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MainViewController_RefreshAppRemindBadge object:nil];
//            __block PersonalUserAppParse * service = self;
//            EVENT_PUBLISH_WITHDATA(service, EventBus_App_Org_GetPhoneUserOrgModel_SelectApp, appDics);
//        });
//        return;
//    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        /* 刷新TabBar上的数字 */
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MainViewController_RefreshAppRemindBadge object:nil];
        __block PersonalUserAppParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Org_GetPhoneUserOrgModel, appDics);
    });
}

/**
 *  获取当前用户企业下更多
 *  @param dataDict
 */
-(void)parseGetPhoneMoreModel:(NSMutableDictionary *)dataDict{
    NSMutableDictionary *userOrgMoreAppInfo  = [dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSDictionary *iosapp=[userOrgMoreAppInfo lzNSDictonaryForKey:@"iosapp"];
    NSArray *menu=[userOrgMoreAppInfo lzNSArrayForKey:@"menu"];
    NSDictionary *selfapplist = [userOrgMoreAppInfo lzNSDictonaryForKey:@"selfapplist"];
    NSMutableArray *allUserAppArray=[[NSMutableArray alloc]init];
    NSMutableArray *allUserSelfAppArray = [[NSMutableArray alloc]init];
    
    for(int i=0;i<menu.count;i++){
        AppMenuModel *appMenuModel= [[AppMenuModel alloc]init];
        AppModel *appModel=[[AppModel alloc]init];
        SelfAppModel *selfAppModel = [[SelfAppModel alloc]init];
        NSDictionary *appdic=[menu objectAtIndex:i];
        [appMenuModel serializationWithDictionary:appdic];
        appMenuModel.appmenuid = [appdic lzNSStringForKey:@"id"];
        appMenuModel.orgid = [AppUtils GetCurrentOrgID];
        if (appMenuModel.type == 4){//自建应用
            NSMutableDictionary *iosselfappdic=[selfapplist objectForKey:appMenuModel.appmenuid];
            [selfAppModel serializationWithDictionary:iosselfappdic];
            
            if(![NSString isNullOrEmpty:selfAppModel.osappid]){
                [allUserSelfAppArray addObject:selfAppModel];
            }
        }
        else{//原生应用
            NSMutableDictionary *iosappdic=[iosapp objectForKey:appMenuModel.appmenuid];
            [appModel serializationWithDictionary:iosappdic];
            appModel.sortid=[NSString stringWithFormat:@"%d",i];
            appModel.selecttype=0;
            appModel.orgid = [AppUtils GetCurrentOrgID];
            if( [iosappdic objectForKey:@"appserver"] != [NSNull null]){
                appModel.appserver = [[iosappdic objectForKey:@"appserver"] dicSerial];
            }
            else {
                appModel.appserver = @"";
            }
            if(![NSString isNullOrEmpty:appModel.appid]){
                [allUserAppArray addObject:appModel];
            }
        }
    
    }

    [[AppDAL shareInstance] addDataWithAppArray:allUserAppArray];
    
    [[SelfAppDAL shareInstance] addDataWithSelfAppArray:allUserSelfAppArray];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block PersonalUserAppParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Org_GetPhoneMoreModel, userOrgMoreAppInfo);
    });
}

/**
 *  保存用户企业导航数据
 *  @param dataDict
 */
-(void)parseSaveUserOrgModel:(NSMutableDictionary *)dataDict{
//    NSString *datacontext=[dataDict lzNSStringForKey:WebApi_DataContext];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
       self.appDelegate.lzGlobalVariable.isNeedRefreshAppRootVC = YES;
        __block PersonalUserAppParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Org_SaveUserOrgModel, nil);
    });
    
}

/**
 *  根据appid获取单个应用提醒数字
 *  @param dataDict
 */
-(void)parseGetAppNumber:(NSMutableDictionary *)dataDict{
    NSNumber *dataNumber = [dataDict lzNSNumberForKey:WebApi_DataContext];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block PersonalUserAppParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Org_GetAppNumber, dataNumber);
    });
}
/**
 *  获取支持消息的应用
 *  @param dataDict
 */
-(void)parseGetMagApp:(NSMutableDictionary *)dataDict{
    NSMutableDictionary *datacontext = [dataDict lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSArray *allValues = [datacontext allValues];
    /* 先清库 */
    [[ImMsgAppDAL shareInstance] deleteImMsgAppModel];
    for (NSDictionary *tmpDic in allValues) {
        ImMsgAppModel *imMsgAppModel = [[ImMsgAppModel alloc] init];
        imMsgAppModel.appid = [tmpDic lzNSStringForKey:@"appid"];
        imMsgAppModel.name = [tmpDic lzNSStringForKey:@"name"];
        imMsgAppModel.appcode = [tmpDic lzNSStringForKey:@"appcode"];
        imMsgAppModel.appcolour = [tmpDic lzNSStringForKey:@"appcolour"];
        imMsgAppModel.state = [tmpDic lzNSStringForKey:@"state"];
        imMsgAppModel.msgandroidconfig = [tmpDic lzNSStringForKey:@"msgandroidconfig"];
        imMsgAppModel.msgiosconfig = [tmpDic lzNSStringForKey:@"msgiosconfig"];
        imMsgAppModel.msgwebconfig = [tmpDic lzNSStringForKey:@"msgwebconfig"];
        imMsgAppModel.valid = [tmpDic lzNSStringForKey:@"valid"];
        imMsgAppModel.synthetiselogo = [tmpDic lzNSStringForKey:@"synthetiselogo"];
        imMsgAppModel.logo = [tmpDic lzNSStringForKey:@"logo"];
        [[ImMsgAppDAL shareInstance] addImMsgAppModel:imMsgAppModel];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block PersonalUserAppParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_GetMagApp, nil);
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
