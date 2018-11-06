//
//  LZUserDataManager.m
//  LeadingCloud
//
//  Created by wchMac on 15/11/18.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-11-18
 Version: 1.0
 Description: 用户数据持久化管理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZUserDataManager.h"
#import "LZKeyChain.h"
#import "NSString+IsNullOrEmpty.h"
#import "NSDictionary+DicRemoveNull.h"
#import "AppDateUtil.h"
#import "AppUtils.h"

/* 在KeyChain中存储的数据 */
static NSString * const KEYCHAIN_FILENAME = @"com.leading.leadingcloud.keychain.filename";  //KeyChain文件名
static NSString * const KEYCHAIN_LOGINTYPE = @"com.leading.leadingcloud.keychain.logintype"; //公有云，登录方式
static NSString * const KEYCHAIN_LOGINTYPE_PRIVATE = @"com.leading.leadingcloud.keychain.logintype.private"; //私有云，登录方式
static NSString * const KEYCHAIN_LOGINNAME = @"com.leading.leadingcloud.keychain.loginname"; //公有云，登录名
static NSString * const KEYCHAIN_LOGINNAME_PRIVATE = @"com.leading.leadingcloud.keychain.loginname.private"; //私有云，登录名
static NSString * const KEYCHAIN_PASSWORD = @"com.leading.leadingcloud.keychain.password";   //密码
static NSString * const KEYCHAIN_Register_PASSWORD = @"com.leading.leadingcloud.keychain.register.password";   //密码
static NSString * const KEYCHAIN_OPENID = @"com.leading.leadingcloud.keychain.openid";   //公有云，openid
static NSString * const KEYCHAIN_OPENID_PRIVATE = @"com.leading.leadingcloud.keychain.openid.private";   //私有云，openid
static NSString * const KEYCHAIN_REFRESHTOKEN = @"com.leading.leadingcloud.keychain.refreshtoken";   //公有云，refreshtoken
static NSString * const KEYCHAIN_REFRESHTOKEN_PRIVATE = @"com.leading.leadingcloud.keychain.refreshtoken.private";   //私有云，refreshtoken
static NSString * const KEYCHAIN_SERVERPublic = @"com.leading.leadingcloud.keychain.serverpublic";   //公有云服务器
static NSString * const KEYCHAIN_SERVER = @"com.leading.leadingcloud.keychain.server";   //服务器
static NSString * const KEYCHAIN_SERVERProcotol = @"com.leading.leadingcloud.keychain.serverprocotol";   //服务器协议名称
static NSString * const KEYCHAIN_SERVERProcotolPrivae = @"com.leading.leadingcloud.keychain.serverprocotolprivate";   //服务器协议名称
static NSString * const KEYCHAIN_ServerModel = @"com.leading.leadingcloud.ns.servermodel";  //公有还是私有
static NSString * const KEYCHAIN_REGISTRABLE = @"com.leading.leadingcloud.keychain.registrable";   //注册显影
static NSString * const KEY_IN_KEYCHAIN_DEVICETOKEN = @"com.leading.leadingcloud.keychain.devicetoken";  //推送ID
static NSString * const KEYCHAIN_PHONEUNIQUEID = @"com.leading.leadingcloud.keychain.phoneuniqueid";   //手机唯一标识ID


/* 在NSUserDefault中存储的数据 */
static NSString * const NS_DEMO = @"com.leading.leadingcloud.ns.demo";
/* 各模块对应的服务器地址 */
static NSString * const NS_MODULES_SERVER = @"com.leading.leadingcloud.ns.modulesserver";
/* 服务器与本地时间的差值 */
static NSString * const NS_INTERVAL_SECONDS = @"com.leading.leadingcloud.ns.intervalseconds";
/* 当前用户信息 */
static NSString * const NS_CURRENT_USERINFO = @"com.leading.leadingcloud.ns.currentuserinfo";
/* Synk信息 */
static NSString * const NS_SYNK = @"com.leading.leadingcloud.ns.synk.dic";
/* 是否登录进系统 */
static NSString * const NS_ISLOGINBEFORE = @"com.leading.leadingcloud.ns.isloginbefore";
/* 是否启动过此APP */
static NSString * const NS_ISHAVEINSTALL = @"com.leading.leadingcloud.ns.ishaveinstall";
/* 声音相关信息 */
static NSString * const NS_SOUND_DATE = @"com.leading.leadingcloud.ns.sound.date";
static NSString * const NS_SET_SOUNDSHAKE = @"com.leading.leadingcloud.ns.set.soundshake";
static NSString * const NS_SET_SOUNDVOICE = @"com.leading.leadingcloud.ns.set.sounvoice";
static NSString * const NS_SET_SOUNDFILE = @"com.leading.leadingcloud.ns.set.soundfilr";
/* 网络连接状态 */
static NSString * const NS_NET_WORKSTATUS = @"com.leading.leadingcloud.ns.networkstatus";
/* 与服务器连接状态 */
static NSString * const NS_SERVER_CONNECTSTATUS = @"com.leading.leadingcloud.ns.serverconnectstatus";
/* 云盘排序规则 */
static NSString * const NS_APP_NETDISK_SORT = @"com.leading.leadingcloud.ns.netdisk.sortrule";
/* 协作文件排序规则 */
static NSString * const NS_Coo_Res_SORT = @"com.leading.leadingcloud.ns.CooRes.sortrule";
/* 任务排序规则 */
static NSString * const NS_TASK_SORT = @"com.leading.leadingcloud.ns.TASK.sortrule";
/* 个人组织信息 */
static NSString * const NS_Personal_Enterprise = @"com.leading.leadingcloud.ns.personal.enterprise";
/* 当前登录人切换组织成功后的组织id */
static NSString * const NS_EnterpriseID = @"com.leading.leadingcloud.ns.enterpriseid";
/* 通知栏中的数据 */
static NSString * const NS_NotificationUserInfo = @"com.leading.leadingcloud.ns.notificationuserinfo";
/* 其它应用打开本应用传递的数据 */
static NSString * const NS_OtherAppToThisInfo = @"com.leading.leadingcloud.ns.otherapptothisinfo";
/* 从3DTouch点击菜单传递的数据 */
static NSString * const NS_3DTouchInfo = @"com.leading.leadingcloud.ns.3dtouchinfo";
/* 检查新版本 */
static NSString * const NS_CheckNewVersion = @"com.leading.leadingcloud.ns.checknewversion";
/* 服务器配置数据 */
static NSString * const NS_AvailableDataContext = @"com.leading.leadingcloud.ns.availabledatacontext";
/* 创建组织显影 */
static NSString * const NS_CreateOrgable = @"com.leading.leadingcloud.ns.createorgable";
/* 加入组织显影 */
static NSString * const NS_JoinOrgable = @"com.leading.leadingcloud.ns.joinorgable";
/* 是否允许修改绑定邮箱 */
static NSString * const NS_SetEmailAble = @"com.leading.leadingcloud.ns.setemailable";
/* 是否允许修改绑定手机 */
static NSString * const NS_SetMobilAble = @"com.leading.leadingcloud.ns.setmobilable";
/* 是否显示项目 */
static NSString * const NS_SetShowProject = @"com.leading.leadingcloud.ns.setprojectable";

/* 数据库实例标识 */
static NSString * const NS_DBGuidTag = @"com.leading.leadingcloud.ns.dbguidtag";
/* 切换身份标识 */
static NSString * const NS_IdentityTag = @"com.leading.leadingcloud.ns.identitytag";

/* 记录不允许上传的文件类型 */
static NSString * const NS_UnallowUpLoadFileType = @"com.leading.leadingcloud.ns.unallowuploadfiletype";
/* 最后登录时间标识 */
static NSString * const NS_LastestLoginDate = @"com.leading.leadingcloud.ns.lastestlogindatedic";

/* 记录是否清理webview缓存标识 */
static NSString * const NS_WebCacheVersion = @"com.leading.leadingcloud.ns.webcacheversion";

/* 记录AES加密tokenid */
static NSString * const NS_AESToken = @"com.leading.leadingcloud.ns.aestoken";

/* 记录App进入后台的时间 */
static NSString * const NS_EnterBackGroundTime = @"com.leading.leadingcloud.ns.enterbackgrouptime";

/* 当前应用信息 */
static NSString * const NS_FUNCTION_SETTING = @"com.leading.leadingcloud.ns.functionsetting";

/* 是否第一次登陆APP */
static NSString * const NS_ISFIRSTLAUNCH = @"com.leading.leadingcloud.ns.isfirstlaunch";

/* 动态是否已经加载 */
static NSString * const NS_COOPERATION_LOAD = @"Cooperation_load";

/* 系统字体大小 */
static NSString * const NS_SYSTEM_FONT = @"systemfont";

/* 是否正在视频通话 */
static NSString * const NS_VODIOCHATING= @"vodioChating";

/* 是否为灰度用户 */
static NSString * const NS_ISGAYSCALEUSER = @"com.leading.leadingcloud.ns.isgayscaleuser";

/*搜索历史记录searchhistory*/
static NSString * const NS_SEARCH_HISTORY = @"com.leading.leadingcloud.ns.search.history";
/*服务圈主页*/
static NSString * const NS_SERVIOCE_CIRCLE_HOME = @"com.leading.leadingcloud.ns.serivivecircle.home";
/*是否加载主页信息*/
static NSString * const NS_IS_SERVIOCE_CIRCLE_HOME = @"com.leading.leadingcloud.ns.is.serivivecircle.home";
/*是否记录日志信息 */
static NSString * const NS_ISRECORDLOG = @"com.leading.leadingcloud.ns.isrecordlog";
/*闪退后是否发送邮件 */
static NSString * const NS_ISCRASHSENDEMAIL = @"com.leading.leadingcloud.ns.iscrashsendemail";
/*是否开启消息推送 */
static NSString * const NS_ISMESSAGEPUSH = @"com.leading.leadingcloud.ns.ismessagepush";
/*消息推送通知关闭的当前时间 */
static NSString * const NS_CLOSEMESSAGEPUSHDATE = @"com.leading.leadingcloud.ns.closemessagepushdate";
/*消息推送通知关闭的天数 */
static NSString * const NS_CLOSEMESSAGEPUSHDAY = @"com.leading.leadingcloud.ns.closemessagepushday";
/* 记录是否开启登录安全校验 */
static NSString * const NS_IsPhoneValid = @"com.leading.leadingcloud.ns.isphonevalid";


@implementation LZUserDataManager

#pragma mark - KeyChain中存储数据

/*
 * 读取KeyChain通用方法
 */
+(NSMutableDictionary *)commonReadKeyChain
{
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[LZKeyChain load:KEYCHAIN_FILENAME];
    if (dictionary==nil) {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    return dictionary;
}

/*
 * 登录方式
 */
+(void)saveLoginType:(NSString *)loginType{
    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];
    
    /* 公有云 */
    if([[self readServerModel] isEqualToString:@"0"]){
        [dictionary setValue:loginType forKey:KEYCHAIN_LOGINTYPE];
    } else {
        [dictionary setValue:loginType forKey:KEYCHAIN_LOGINTYPE_PRIVATE];
    }
    
    [LZKeyChain save:KEYCHAIN_FILENAME data:dictionary];
}
+(NSString *)readLoginType{
    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];
    
    NSString *result = @"";
    /* 公有云 */
    if([[self readServerModel] isEqualToString:@"0"]){
        result = [dictionary lzNSStringForKey:KEYCHAIN_LOGINTYPE];
    } else {
        result = [dictionary lzNSStringForKey:KEYCHAIN_LOGINTYPE_PRIVATE];
    }
    return result;
}

/*
 * 用户登录名
 */
+(void)saveUserLoginName:(NSString *)loginName{
    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];
    
    /* 公有云 */
    if([[self readServerModel] isEqualToString:@"0"]){
        [dictionary setValue:loginName forKey:KEYCHAIN_LOGINNAME];
    } else {
        [dictionary setValue:loginName forKey:KEYCHAIN_LOGINNAME_PRIVATE];
    }
    
    [LZKeyChain save:KEYCHAIN_FILENAME data:dictionary];
}
+(NSString *)readUserLoginName{
    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];
    
    NSString *result = @"";
    /* 公有云 */
    if([[self readServerModel] isEqualToString:@"0"]){
        result = [dictionary lzNSStringForKey:KEYCHAIN_LOGINNAME];
    } else {
        result = [dictionary lzNSStringForKey:KEYCHAIN_LOGINNAME_PRIVATE];
        /* 兼容原数据 */
        if([NSString isNullOrEmpty:result]){
            result = [dictionary lzNSStringForKey:KEYCHAIN_LOGINNAME];
        }
    }
    return result;
}

/*
 * 用户登录密码
 */
+(void)saveUserPassWord:(NSString *)passWord{
    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];
    [dictionary setValue:passWord forKey:KEYCHAIN_PASSWORD];
    [LZKeyChain save:KEYCHAIN_FILENAME data:dictionary];
}
+(NSString *)readUserPassword{
    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];
    return [dictionary objectForKey:KEYCHAIN_PASSWORD];
}

/*
 * 第三方App的OpenID
 */
+(void)saveThirdAppOpenID:(NSString *)openID{
    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];
    
    /* 公有云 */
    if([[self readServerModel] isEqualToString:@"0"]){
        [dictionary setValue:openID forKey:KEYCHAIN_OPENID];
    } else {
        [dictionary setValue:openID forKey:KEYCHAIN_OPENID_PRIVATE];
    }
    
    [LZKeyChain save:KEYCHAIN_FILENAME data:dictionary];
}
+(NSString *)readThirdAppOpenID{
    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];
    
    NSString *result = @"";
    /* 公有云 */
    if([[self readServerModel] isEqualToString:@"0"]){
        result = [dictionary lzNSStringForKey:KEYCHAIN_OPENID];
    } else {
        result = [dictionary lzNSStringForKey:KEYCHAIN_OPENID_PRIVATE];
    }
    return result;
}

/*
 * 第三方App的RefreshToken
 */
+(void)saveThirdAppRefreshToken:(NSString *)refreshToken{
    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];
    
    /* 公有云 */
    if([[self readServerModel] isEqualToString:@"0"]){
        [dictionary setValue:refreshToken forKey:KEYCHAIN_REFRESHTOKEN];
    } else {
        [dictionary setValue:refreshToken forKey:KEYCHAIN_REFRESHTOKEN_PRIVATE];
    }
    
    [LZKeyChain save:KEYCHAIN_FILENAME data:dictionary];
}
+(NSString *)readThirdAppRefreshToken{
    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];
    
    NSString *result = @"";
    /* 公有云 */
    if([[self readServerModel] isEqualToString:@"0"]){
        result = [dictionary lzNSStringForKey:KEYCHAIN_REFRESHTOKEN];
    } else {
        result = [dictionary lzNSStringForKey:KEYCHAIN_REFRESHTOKEN_PRIVATE];
    }
    return result;
}


/*
 * 用户注册密码
 */
+(void)saveUserRegisterPassWord:(NSString *)passWord{
    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];
    [dictionary setValue:passWord forKey:KEYCHAIN_Register_PASSWORD];
    [LZKeyChain save:KEYCHAIN_FILENAME data:dictionary];
}
+(NSString *)readUserRegisterPassword{
    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];
    return [dictionary objectForKey:KEYCHAIN_Register_PASSWORD];
}

/*
 * 公有云服务器
 */
+(void)savePublicServer:(NSString *)server{
    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];
    [dictionary setValue:server forKey:KEYCHAIN_SERVERPublic];
    [LZKeyChain save:KEYCHAIN_FILENAME data:dictionary];
}
+(NSString *)readPublicServer{
    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];
    
    if(![[dictionary allKeys] containsObject:KEYCHAIN_SERVERPublic]
       || [NSString isNullOrEmpty:[dictionary objectForKey:KEYCHAIN_SERVERPublic]]){
        //return DEFAULTSERVER_YUN;
       return DEFAULTSERVER_PLAT;
    }else{
        return [dictionary objectForKey:KEYCHAIN_SERVERPublic];
    }
}

/*
 * 服务器
 */
+(void)saveServer:(NSString *)server{
    /* 若当前为公有云，则不再保存服务器 */
    if([[self readServerModel] isEqualToString:@"0"]){
//        [self savePublicServer:server];
        return;
    }
    
    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];
    [dictionary setValue:server forKey:KEYCHAIN_SERVER];
    [LZKeyChain save:KEYCHAIN_FILENAME data:dictionary];
}
+(NSString *)readServer{
    /* 若当前为公有云，则直接返回公有云服务器 */
    if([[self readServerModel] isEqualToString:@"0"]){
        return [self readPublicServer];
    }
    
    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];

    if(![[dictionary allKeys] containsObject:KEYCHAIN_SERVER]
       || [NSString isNullOrEmpty:[dictionary objectForKey:KEYCHAIN_SERVER]]){
        //return DEFAULTSERVER_YUN;
       return DEFAULTSERVER_PLAT;
    }else{
        return [dictionary objectForKey:KEYCHAIN_SERVER];
    }
}

/*
 * 服务器协议：http 或 https
 */
+(void)saveServerProtocol:(NSString *)serverProtocol{
    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];
    /* 公有云 */
    if([[self readServerModel] isEqualToString:@"0"]){
        [dictionary setValue:serverProtocol forKey:KEYCHAIN_SERVERProcotol];
    } else {
        [dictionary setValue:serverProtocol forKey:KEYCHAIN_SERVERProcotolPrivae];
    }
    [LZKeyChain save:KEYCHAIN_FILENAME data:dictionary];
}
+(NSString *)readServerProtocol{
    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];
    
    /* 公有云 */
    if([[self readServerModel] isEqualToString:@"0"]){
        if(![[dictionary allKeys] containsObject:KEYCHAIN_SERVERProcotol]
           || [NSString isNullOrEmpty:[dictionary lzNSStringForKey:KEYCHAIN_SERVERProcotol]]){
            return @"http";
        }else{
            return [dictionary lzNSStringForKey:KEYCHAIN_SERVERProcotol];
        }
    } else {
        if(![[dictionary allKeys] containsObject:KEYCHAIN_SERVERProcotolPrivae]
           || [NSString isNullOrEmpty:[dictionary lzNSStringForKey:KEYCHAIN_SERVERProcotolPrivae]]){
            return @"http";
        }else{
            return [dictionary lzNSStringForKey:KEYCHAIN_SERVERProcotolPrivae];
        }
    }
}

/**
 *  记录服务器模式是公有还是私有
 *
 *  @param isServer 公有还是私有
 */
+(void)saveIsServerModel:(NSString *)data
{
    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];
    [dictionary setValue:data forKey:KEYCHAIN_ServerModel];
    [LZKeyChain save:KEYCHAIN_FILENAME data:dictionary];
    
}
+(NSString *)readServerModel
{
    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];
    if(![[dictionary allKeys] containsObject:KEYCHAIN_ServerModel]
       || [NSString isNullOrEmpty:[dictionary objectForKey:KEYCHAIN_ServerModel]]){
        return @"0";
    } else {
        return [dictionary objectForKey:KEYCHAIN_ServerModel];
    }
}

///*
// * 注册显影性
// */
//+(void)saveRegistrable:(NSString *)registrable{
//    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];
//    [dictionary setValue:registrable forKey:KEYCHAIN_REGISTRABLE];
//    [LZKeyChain save:KEYCHAIN_FILENAME data:dictionary];
//}
//+(NSString *)readRegistrable{
//    NSMutableDictionary *dictionary = [LZUserDataManager commonReadKeyChain];
//    if(![[dictionary allKeys] containsObject:KEYCHAIN_REGISTRABLE]
//       || [NSString isNullOrEmpty:[dictionary objectForKey:KEYCHAIN_REGISTRABLE]]){
//        return @"0";
//    } else {
//        return [dictionary objectForKey:KEYCHAIN_REGISTRABLE];
//    }
//}

/**
 *  删除登录信息
 */
+(void)deleteLoginInfo
{
    [LZKeyChain delete:KEYCHAIN_FILENAME];
}

/**
 *  设备推送ID
 */
+(void)saveDeviceToken:(NSString *)token{
    NSMutableDictionary *tokenKVPairs = (NSMutableDictionary *)[LZKeyChain load:KEY_IN_KEYCHAIN_DEVICETOKEN];
    if (tokenKVPairs==nil) {
        tokenKVPairs = [[NSMutableDictionary alloc] init];
    }
    if (token==nil) {
        token=@"";
    }
    [tokenKVPairs setValue:token forKey:@"apptoken"];
    [LZKeyChain save:KEY_IN_KEYCHAIN_DEVICETOKEN data:tokenKVPairs];
}
+(NSString *)readDeviceToken{
    NSMutableDictionary *tokenKVPair = (NSMutableDictionary *)[LZKeyChain load:KEY_IN_KEYCHAIN_DEVICETOKEN];
    NSString *token = [tokenKVPair objectForKey:@"apptoken"]==nil ? @"" : [tokenKVPair objectForKey:@"apptoken"];
    return token;
}

/**
 *  手机唯一标识ID
 */
+(void)savePhoneUniqueID:(NSString *)phoneUniqueID{
    NSMutableDictionary *tokenKVPairs = (NSMutableDictionary *)[LZKeyChain load:KEYCHAIN_PHONEUNIQUEID];
    if (tokenKVPairs==nil) {
        tokenKVPairs = [[NSMutableDictionary alloc] init];
    }
    if (phoneUniqueID==nil) {
        phoneUniqueID=@"";
    }
    [tokenKVPairs setValue:phoneUniqueID forKey:@"phoneuniqueid"];
    [LZKeyChain save:KEYCHAIN_PHONEUNIQUEID data:tokenKVPairs];
}
+(NSString *)readPhoneUniqueID{
    NSMutableDictionary *tokenKVPair = (NSMutableDictionary *)[LZKeyChain load:KEYCHAIN_PHONEUNIQUEID];
    NSString *phoneUniqueID = [tokenKVPair objectForKey:@"phoneuniqueid"]==nil ? @"" : [tokenKVPair objectForKey:@"phoneuniqueid"];
    return phoneUniqueID;
}

#pragma mark - NSUserDefaults中存储数据

/*
 * 保存NSUserDefualts通用方法
 */
+(void)commonSaveBoolTypeWithKey:(NSString *)key value:(BOOL)value
{
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    [userDefaluts setBool:(BOOL)value forKey:key];
    [userDefaluts synchronize];
}

+(void)commonSaveDoubleTypeWithKey:(NSString *)key value:(double)value
{
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    [userDefaluts setDouble:value forKey:key] ;
    [userDefaluts synchronize];
}
+(void)commonSaveFloatTypeWithKey:(NSString *)key value:(float)value
{
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    [userDefaluts setFloat:value forKey:key];
    [userDefaluts synchronize];
}
+(void)commonSaveIntegerTypeWithKey:(NSString *)key value:(NSInteger)value
{
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    [userDefaluts setInteger:value forKey:key];
    [userDefaluts synchronize];
}
+(void)commonSaveNSObjectTypeWithKey:(NSString *)key value:(NSObject *)value
{
    if([value isKindOfClass:[NSDictionary class]]){
        value = [NSDictionary removeJsonNullFromDic:value];
    }
    
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    [userDefaluts setValue:value forKey:key];
    [userDefaluts synchronize];
}
+(void)commonSaveArrayTypeWithKey:(NSString *)key value:(NSMutableArray*)value
{
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    [userDefaluts setValue:value forKey:key];
    [userDefaluts synchronize];
}

+(BOOL)commonReadBoolTypeWithKey:(NSString *)key
{
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    return [userDefaluts boolForKey:key];
}

+(float)commonReadFloatTypeWithKey:(NSString *)key
{
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    return [userDefaluts floatForKey:key];
}

+(NSInteger)commonReadIntegerTypeWithKey:(NSString *)key
{
    if ([NSString isNullOrEmpty:key]) {
        return 0;
    }
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    return [userDefaluts integerForKey:key];
}

+(double)commonReadDoubleTypeWithKey:(NSString *)key
{
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    return [userDefaluts doubleForKey:key];
}

+(NSObject*)commonReadNSObjectTypeWithKey:(NSString *)key
{
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    return [userDefaluts objectForKey:key];
}
+(NSMutableArray*)commonReadArrayTypeWithKey:(NSString *)key
{
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    return [userDefaluts objectForKey:key];
}
/*
 * 示例
 */
+(void)saveDemoData:(NSString *)data{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_DEMO value:data];
}
+(NSString *)readDemoData
{
    return (NSString *)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_DEMO];
}

/**
 *  各个模块对应的服务器地址
 *
 *  @param data 字典格式数据
 */
+(void)saveModulesServerInfo:(NSDictionary *)data{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_MODULES_SERVER value:data];
}
+(NSDictionary *)readModulesServerInfo
{
    return (NSMutableDictionary *)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_MODULES_SERVER];
}

/**
 获取云盘文容量

 @param data data description
 */
+(void)saveNetSizeInfo:(NSMutableDictionary*)data {
    [LZUserDataManager commonSaveNSObjectTypeWithKey:@"netsize" value:data];
}
+(NSString*)readNetSizeInfo {
   NSDictionary *rightSize = (NSDictionary*)[LZUserDataManager commonReadNSObjectTypeWithKey:@"netsize"];
    NSString *maxsize = [rightSize lzNSStringForKey:@"maxsize"];
    NSString *cursize =[rightSize lzNSStringForKey:@"cursize"];

    return [NSString stringWithFormat:@"%@/%@",cursize,maxsize];
}

/**
 *  客户端与服务器端时间差
 *
 *  @param seconds 间隔多少秒
 */
+(void)saveIntervalSeconds:(NSInteger)seconds{
    [LZUserDataManager commonSaveIntegerTypeWithKey:NS_INTERVAL_SECONDS value:seconds];
}
+(NSInteger)readIntervalSeconds
{
    NSInteger seconds = [LZUserDataManager commonReadIntegerTypeWithKey:NS_INTERVAL_SECONDS];
    
    return seconds;
}

/**
 *  当前登录人信息
 *
 *  @param data 字典格式数据
 */
+(void)saveCurrentUserInfo:(NSMutableDictionary *)data{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_CURRENT_USERINFO value:data];
}
+(NSMutableDictionary *)readCurrentUserInfo
{
    return (NSMutableDictionary *)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_CURRENT_USERINFO];
}

/**
 *  Synk信息
 *
 *  @param data Synk数据
 */
+(void)saveSynkInfo:(NSMutableDictionary *)data{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_SYNK value:data];
}
+(NSMutableDictionary *)readSynkInfo
{
    NSMutableDictionary *result =[NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_SYNK]];
    if(!result){
        result = [[NSMutableDictionary alloc] init];
    }
    return result;
}

/**
 *  之前是否登录进系统
 *
 *  @param isLogin 是否登录进系统
 */
+(void)saveIsLoginBefore:(BOOL)isLogin
{
    [LZUserDataManager commonSaveBoolTypeWithKey:NS_ISLOGINBEFORE value:isLogin];
}
+(BOOL)readIsLoginBefore
{
    return [LZUserDataManager commonReadBoolTypeWithKey:NS_ISLOGINBEFORE];
}

/**
 保存这个版本是否显示引导页

 @param isShow
 */
+ (void)saveisShowGuideVersion:(BOOL)isShow {
    [LZUserDataManager commonSaveBoolTypeWithKey:BOOT_PAGE_IS_SHOW value:isShow];
}
+ (BOOL)readIsShowGuideVersion {
    return [LZUserDataManager commonReadBoolTypeWithKey:BOOT_PAGE_IS_SHOW];
}

/**
 *  是否启动过此App
 *
 *  @param isHaveInstall 是否启动过
 */
+(void)saveIsHaveInstall:(NSString *)isHaveInstall{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_ISHAVEINSTALL value:isHaveInstall];
}
+(NSString *)readIsHaveInstall
{
    return [LZFormat Null2String:[LZUserDataManager commonReadNSObjectTypeWithKey:NS_ISHAVEINSTALL]];
}

/**
 记录第一张相册照片的时间

 @param time 时间
 */
+ (void)saveFirstPhotoTime:(NSString *)time {
    [LZUserDataManager commonSaveNSObjectTypeWithKey:@"FirstTime" value:time];
}
+ (NSString *)readFirstPhotoTime {
    return [LZFormat Null2String:[LZUserDataManager commonReadNSObjectTypeWithKey:@"FirstTime"]];
}

/**
 *  播放声音的时间
 *
 *  @param soundDate 时间
 */
+(void)saveTheDateForSound:(NSString *)soundDate{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_SOUND_DATE value:soundDate];
}
+(NSString *)readTheDateForSound
{
    return [LZFormat Null2String:[LZUserDataManager commonReadNSObjectTypeWithKey:NS_SOUND_DATE]];
}

/**
 *  是否开启振动
 *
 *  @param isOpen 是否开启
 */
+(void)saveIsOpenSoundShake:(BOOL)isOpen
{
    [LZUserDataManager commonSaveBoolTypeWithKey:NS_SET_SOUNDSHAKE value:isOpen];
}
+(BOOL)readIsOpenSoundShake
{
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    if([userDefaluts valueForKey:NS_SET_SOUNDSHAKE]==nil){
        return YES;
    } else {
        return [LZUserDataManager commonReadBoolTypeWithKey:NS_SET_SOUNDSHAKE];
    }
}

/**
 *  是否开启声音
 *
 *  @param isOpen 是否开启
 */
+(void)saveIsOpenSoundVoice:(BOOL)isOpen
{
    [LZUserDataManager commonSaveBoolTypeWithKey:NS_SET_SOUNDVOICE value:isOpen];
}
+(BOOL)readIsOpenSoundVoice
{
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    if([userDefaluts valueForKey:NS_SET_SOUNDVOICE]==nil){
        return YES;
    } else {
        return [LZUserDataManager commonReadBoolTypeWithKey:NS_SET_SOUNDVOICE];
    }
}

/**
 *  提示音类型
 *
 *  @param soundfile 提示音文件
 */
+(void)saveSoundFile:(NSString *)soundfile
{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_SET_SOUNDFILE value:soundfile];
}
+(NSString *)readSoundFile
{
    return @"3";
//    NSString *result = [LZFormat Null2String:[LZUserDataManager commonReadNSObjectTypeWithKey:NS_SET_SOUNDFILE]];
//    if([NSString isNullOrEmpty:result]){
//        return @"1";
//    } else {
//        return result;
//    }
}

/**
 *  是否连接网络
 *
 *  @param isConnect 是否连接
 */
+(void)saveIsConnectNetWork:(BOOL)isConnect
{
    [LZUserDataManager commonSaveBoolTypeWithKey:NS_NET_WORKSTATUS value:isConnect];
}
+(BOOL)readIsConnectNetWork
{
    return [LZUserDataManager commonReadBoolTypeWithKey:NS_NET_WORKSTATUS];
}

/**
 *  是否与服务器连接着
 *
 *  @param isConnectServer 是否连接
 */
+(void)saveIsConnectServer:(BOOL)isConnectServer{
    [LZUserDataManager commonSaveBoolTypeWithKey:NS_SERVER_CONNECTSTATUS value:isConnectServer];
}
+(BOOL)readIsConnectServer{
    return [LZUserDataManager commonReadBoolTypeWithKey:NS_SERVER_CONNECTSTATUS];
}

/**
 *  云盘排序规则
 *
 *  @param sortrule 规则标识
 */
+(void)saveAppNetDiskSortRule:(NSMutableDictionary *)sortrule{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_APP_NETDISK_SORT value:sortrule];
}
+(NSMutableDictionary *)readAppNetDiskSortRule{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    NSObject *data = [LZUserDataManager commonReadNSObjectTypeWithKey:NS_APP_NETDISK_SORT];
    if([data isKindOfClass:[NSString class]]){
        if([NSString isNullOrEmpty:(NSString *)data]){
            [result setValue:App_NetDisk_Sort_Name_Asc forKey:[AppUtils GetCurrentUserID]];
        } else {
            [result setValue:data forKey:[AppUtils GetCurrentUserID]];
        }
    } else {
        result =[NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_APP_NETDISK_SORT]];
        if (![result.allKeys containsObject:[AppUtils GetCurrentUserID]]) {
            [result setValue:App_NetDisk_Sort_Name_Asc forKey:[AppUtils GetCurrentUserID]];
        }
    }
    return result;
}

/**
 *  任务排序规则
 *
 *  @param sortrule 规则标识
 */
+(void)saveTaskSortRule:(NSString *)sortrule{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_TASK_SORT value:sortrule];
}
+(NSString *)readTaskSortRule{
    return [LZFormat Null2String:[LZUserDataManager commonReadNSObjectTypeWithKey:NS_TASK_SORT] defaultStr:@"participant"];
}

/**
 *  个人组织信息
 *
 *  @param dataArray 数组格式数据
 */
+(void)savePersonalEnterpriseInfo:(NSMutableArray *)dataArray{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_Personal_Enterprise value:dataArray];
}
+(NSMutableArray *)readPersonalEnterpriseInfo{
    return (NSMutableArray *)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_Personal_Enterprise];
}
/**
 *  当前登录人切换组织成功后的组织ID
 *
 *  @param data 字典格式数据
 */
+(void)saveEnterpriseidInfo:(NSMutableDictionary *)data{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_EnterpriseID value:data];
}
+(NSMutableDictionary *)readEnterpriseidInfo
{
    return (NSMutableDictionary *)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_EnterpriseID];
}

/**
 *  通知内的数据
 *
 *  @param data 消息通知数据
 */
+(void)saveNotificationInfo:(NSMutableDictionary *)data{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_NotificationUserInfo value:data];
}
+(NSMutableDictionary *)readNotificationInfo{
    return (NSMutableDictionary *)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_NotificationUserInfo];
}

/**
 *  其它应用打开本应用时传递的数据
 *
 *  @param data 应用通知数据
 */
+(void)saveOtherAppToThisInfo:(NSMutableDictionary *)data{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_OtherAppToThisInfo value:data];
}
+(NSMutableDictionary *)readOtherAppToThisInfo{
    return (NSMutableDictionary *)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_OtherAppToThisInfo];
}

/**
 *  3Dtouch传递的数据
 *
 *  @param data 应用通知数据
 */
+(void)save3DTouchInfo:(NSMutableDictionary *)data{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_3DTouchInfo value:data];
}
+(NSMutableDictionary *)read3DTouchInfo{
    return (NSMutableDictionary *)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_3DTouchInfo];
}

/**
 *  是否执行过检查新版本
 *
 *  @param date 检查过新版本的当前时间
 */
+(void)saveCheckNewVersion:(NSString *)date{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_CheckNewVersion value:date];
}
+(NSString *)readCheckNewVersion{
    NSString *result = [LZFormat Null2String:[LZUserDataManager commonReadNSObjectTypeWithKey:NS_CheckNewVersion]];
    if([NSString isNullOrEmpty:result]){
        return [AppDateUtil GetCurrentDateForString];
    } else {
        return result;
    }
}

/**
 *  获取服务器配置参数
 *
 *  @param data 服务器配置数据
 */
+(void)saveAvailableDataContext:(NSMutableDictionary *)data{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_AvailableDataContext value:data];
}
+(NSMutableDictionary *)readAvailableDataContext{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_AvailableDataContext]];
    for(NSString *key in dataDic.allKeys){
        if(![key isEqualToString:@"enteradverment"]&&![key isEqualToString:@"pwdpattern"]&&![key isEqualToString:@"pwdpatternmsg"]){
            NSString *able = [NSString stringWithFormat:@"%@",[dataDic lzNSNumberForKey:key]];
            [dataDic setValue:able forKey:key];
        }
    }
    
    /* 应用配置 */
    NSString *enteradverment = [dataDic lzNSStringForKey:@"enteradverment"];
    [dataDic setValue:enteradverment forKey:@"enteradverment"];
    /* 密码正则配置 */
    NSString *pwdpattern = [dataDic lzNSStringForKey:@"pwdpattern"];
    [dataDic setValue:pwdpattern forKey:@"pwdpattern"];
    /* 密码提示配置 */
    NSString *pwdpatternmsg = [dataDic lzNSStringForKey:@"pwdpatternmsg"];
    [dataDic setValue:pwdpatternmsg forKey:@"pwdpatternmsg"];
    return dataDic;
}

/*
 * 数据库唯一实例标识
 */
+(void)saveDBGuidTag:(NSString *)dbguidtag{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_DBGuidTag value:dbguidtag];
}
+(NSString *)getDBGuidTag{
    NSString *result = [LZFormat Null2String:[LZUserDataManager commonReadNSObjectTypeWithKey:NS_DBGuidTag]];
    if([NSString isNullOrEmpty:result]){
        return @"DB64ADE6-BEE6-4797-9229-D712D2AA5C2F";
    } else {
        return result;
    }
}

/**
 为了过滤用的保存不显示的模板code值
 */
+(void)saveCodeStr:(NSString *)codeStr {
    [LZUserDataManager commonSaveNSObjectTypeWithKey:@"template_code" value:codeStr];
}
+(NSString *)getCodeStr {
    return (NSString *)[LZUserDataManager commonReadNSObjectTypeWithKey:@"template_code"];
}

/**
 为了过滤使用保存tvid
 */
+(void)saveTvidStr:(NSString *)tvidStr {
    [LZUserDataManager commonSaveNSObjectTypeWithKey:@"tvidStr" value:tvidStr];
}
+(NSString *)getTvidStr {
    return (NSString *)[LZUserDataManager commonReadNSObjectTypeWithKey:@"tvidStr"];
}

/*
 * 记录不允许上传的文件类型
 */
+(void)saveUnallowUpLoadFileType:(NSString *)data{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_UnallowUpLoadFileType value:data];
}
+(NSString *)readUnallowUpLoadFileType{
    return (NSString *)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_UnallowUpLoadFileType];
}

/*
 * 切换身份标识
 */
+(void)saveIdentityTag:(NSString *)dbguidtag{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_IdentityTag value:dbguidtag];
}
+(NSString *)readIdentityTag{
    NSString *result = [LZFormat Null2String:[LZUserDataManager commonReadNSObjectTypeWithKey:NS_IdentityTag]];
    if([[AppUtils GetCurrentOrgID] isEqualToString:[AppUtils GetCurrentUserID]]){
        return @"0";
    } else {
        return result;
    }
}

/*
 * 记录最后一次登录成功的时间
 */
+(void)saveLastestLoginDate:(NSString *)loginDate{
    
    /* 读取 */
    NSMutableDictionary *lastestLoginDateDic =[NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_LastestLoginDate]];
    if(!lastestLoginDateDic){
        lastestLoginDateDic = [[NSMutableDictionary alloc] init];
    }
    
    /* 写入 */
    NSMutableDictionary *lastestLoginDateDicCopy = [[NSMutableDictionary alloc] init];
    for (NSString *key in [lastestLoginDateDic allKeys]) {
        [lastestLoginDateDicCopy setValue:[lastestLoginDateDic objectForKey:key] forKey:key];
    }
    [lastestLoginDateDicCopy setValue:loginDate forKey:[AppUtils GetCurrentUserID]];
    
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_LastestLoginDate value:lastestLoginDateDicCopy];
}
+(NSString *)getLastestLoginDate{
    NSMutableDictionary *result =[NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_LastestLoginDate]];
    if(!result){
        result = [[NSMutableDictionary alloc] init];
    }
    
    NSString *lastestLoginDate = [result lzNSStringForKey:[AppUtils GetCurrentUserID]];
    
    return lastestLoginDate;
}

+(void)saveFileidsWithArray:(NSMutableArray*)fileids {
    [LZUserDataManager commonSaveArrayTypeWithKey:@"fileids" value:fileids];
}
+(NSMutableArray*)readFileids {
    return [LZUserDataManager commonReadArrayTypeWithKey:@"fileids"];
}

+(void)clearAliyunFileids {
     NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    [userDefaluts removeObjectForKey:@"fileids"];
}
/*
 * 记录是否清理webview缓存
 */
+(void)saveIsWebCacheVersion:(NSString *)data{
   [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_WebCacheVersion value:data];
}
+(NSString *)readIsWebCacheVersion{
   NSString *result = [LZFormat Null2String:[LZUserDataManager commonReadNSObjectTypeWithKey:NS_WebCacheVersion]];
   if([NSString isNullOrEmpty:result]){
      return @"";
   } else {
      return result;
   }
}

/*
 * 记录AES加密tokenid
 */
+(void)saveAESToken:(NSString *)data{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_AESToken value:data];
}
+(NSString *)readAESToken{
    NSString *result = [LZFormat Null2String:[LZUserDataManager commonReadNSObjectTypeWithKey:NS_AESToken]];
    return result;
}

/*
 * 记录App进入后台的时间
 */
+(void)saveEnterBackgroundTime:(NSString *)datetime{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_EnterBackGroundTime value:datetime];
}
+(NSString *)readEnterBackgroundTime{
    NSString *result = [LZFormat Null2String:[LZUserDataManager commonReadNSObjectTypeWithKey:NS_EnterBackGroundTime]];
    return result;
}

/*
 * 记录某些功能单独打开
 */
+(void)saveFunctionSettingInfo:(NSMutableDictionary *)data{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_FUNCTION_SETTING value:data];
}
+(NSMutableDictionary *)readFunctionSettingInfo
{
    NSMutableDictionary *dic = (NSMutableDictionary *)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_FUNCTION_SETTING];
    if(dic == nil){
        dic = [[NSMutableDictionary alloc] init];
    }
    return dic;
}

/**
 *  记录是否为第一次登陆APP
 *
 *  @param isFirstLaunch 是否第一次登陆
 */
+(void)saveIsFirstLaunch:(NSMutableDictionary *)data
{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_ISFIRSTLAUNCH value:data];
}
+(NSMutableDictionary *)readIsFirstLaunch
{
    NSMutableDictionary *dic = (NSMutableDictionary *)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_ISFIRSTLAUNCH];
    if(dic == nil){
        dic = [[NSMutableDictionary alloc] init];
    }
    return dic;
}

/*
 * 记录是否在语音视频聊天
 */
+(void)saveIsVodioChating:(BOOL)isChating{
	
	[LZUserDataManager commonSaveBoolTypeWithKey:NS_VODIOCHATING value:isChating];
}

+(BOOL)isVodioChating{
	
	return [LZUserDataManager commonReadBoolTypeWithKey:NS_VODIOCHATING];
}

/*
 * 当前是否为灰度用户
 */
+(void)saveIsGayScaleUser:(BOOL)isGayScale{
    [LZUserDataManager commonSaveBoolTypeWithKey:NS_ISGAYSCALEUSER value:isGayScale];
}
+(BOOL)readIsGayScaleUser{
    return [LZUserDataManager commonReadBoolTypeWithKey:NS_ISGAYSCALEUSER];
}



/*
 * 记录是否加载动态视图
 */
+(void)saveIsCooperationLoading:(BOOL)load{
	[LZUserDataManager commonSaveBoolTypeWithKey:NS_COOPERATION_LOAD value:load];

}


+(BOOL)isCooperationLoading{
	return [LZUserDataManager commonReadBoolTypeWithKey:NS_COOPERATION_LOAD];

}

/*
 * 保存系统字体
 */
+(void)saveSystemFont:(NSString*)font{
	
	[LZUserDataManager commonSaveNSObjectTypeWithKey:NS_SYSTEM_FONT value:font];
	
}
+(NSString*)getSystemFont{
	
	return [LZFormat Null2String:[LZUserDataManager commonReadNSObjectTypeWithKey:NS_SYSTEM_FONT]];
	
}

/*
 * 富文本相关功能启用
 */
+(NSString *)readCooperationDes{
	return @"1";
}
+(NSString *)readFixClassStringName{
	NSString *strNSString = @"UIWebBrowserViewMinusAccessoryView";
	return strNSString;
}
+(NSString *)readWebBrowserStringName{
	NSString *strNSString = @"UIWebBrowserView";
	return strNSString;
}


+(void)saveSearchHistory:(NSMutableArray*)historyArr Uid:(NSString*)uid{
	
	NSMutableDictionary *dic = (NSMutableDictionary *)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_SEARCH_HISTORY];
	if (!dic) {
		dic = [NSMutableDictionary dictionary];
	}
	//historyArr = [historyArr valueForKeyPath:@"@distinctUnionOfObjects.self"];
	NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
	
	if(historyArr.count>20){
		historyArr =(NSMutableArray*)[historyArr subarrayWithRange:NSMakeRange(0, 20)];
	}
	
	[mDic setValue:historyArr forKey:uid];
	[LZUserDataManager commonSaveNSObjectTypeWithKey:NS_SEARCH_HISTORY value:mDic];
}

+(NSMutableArray*)readSearchHistoryUid:(NSString*)uid{
	
	NSMutableDictionary *dic = (NSMutableDictionary *)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_SEARCH_HISTORY];
	NSMutableArray *historyArr = [dic lzNSMutableArrayForKey:uid];
	if(historyArr == nil) historyArr = [NSMutableArray array];
	
	return historyArr;
}

+(void)saveHomeSeriviceCircle:(NSDictionary*)dic Uid:(NSString*)uid{
	
	NSMutableDictionary *mdic = (NSMutableDictionary *)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_SERVIOCE_CIRCLE_HOME];
	if (!mdic) {
		mdic = [NSMutableDictionary dictionary];
	}
	//historyArr = [historyArr valueForKeyPath:@"@distinctUnionOfObjects.self"];
	NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:mdic];
	
	[mDic setValue:dic forKey:uid];
	[LZUserDataManager commonSaveNSObjectTypeWithKey:NS_SERVIOCE_CIRCLE_HOME value:mDic];

}

+(NSDictionary*)readHomeSeriviceCircleUid:(NSString*)uid{
	
	NSMutableDictionary *dic = (NSMutableDictionary *)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_SERVIOCE_CIRCLE_HOME];

	NSDictionary *homeDic = [dic lzNSDictonaryForKey:uid];
	
	return homeDic;
}

+(void)saveIsLoadHomeSeriviceCircle:(BOOL)isload Uid:(NSString*)uid{
	
	NSMutableDictionary *mdic = (NSMutableDictionary *)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_IS_SERVIOCE_CIRCLE_HOME];
	if (!mdic) {
		mdic = [NSMutableDictionary dictionary];
	}
	//historyArr = [historyArr valueForKeyPath:@"@distinctUnionOfObjects.self"];
	NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:mdic];
    if(isload){
        [mDic setValue:@"1" forKey:uid];
    } else {
        [mDic setValue:@"0" forKey:uid];
    }
	[LZUserDataManager commonSaveNSObjectTypeWithKey:NS_IS_SERVIOCE_CIRCLE_HOME value:mDic];
	
}

+(BOOL)readIsHomeSeriviceCircleUid:(NSString*)uid{
	
	NSMutableDictionary *dic = (NSMutableDictionary *)[LZUserDataManager commonReadNSObjectTypeWithKey:NS_IS_SERVIOCE_CIRCLE_HOME];
	
	NSString *isLoading = [dic lzNSStringForKey:uid];
	if (isLoading && [isLoading isEqualToString:@"1"]) {
		
		return YES;
	}
	return NO;
}

/**
 *  是否记录日志
 *
 *  @param isOpen 是否开启
 */
+(void)saveIsOpenRecordLog:(BOOL)isOpen
{
    [LZUserDataManager commonSaveBoolTypeWithKey:NS_ISRECORDLOG value:isOpen];
}
+(BOOL)readIsOpenRecordLog
{
    return [LZUserDataManager commonReadBoolTypeWithKey:NS_ISRECORDLOG];
}

/**
 *  闪退后是否发送邮件
 *
 *  @param isOpen 是否开启
 */
+(void)saveIsOpenCrashSendEmail:(BOOL)isOpen
{
    [LZUserDataManager commonSaveBoolTypeWithKey:NS_ISCRASHSENDEMAIL value:isOpen];
}
+(BOOL)readIsOpenCrashSendEmail
{
    return [LZUserDataManager commonReadBoolTypeWithKey:NS_ISCRASHSENDEMAIL];
}

/**
 *  是否开启消息推送
 *
 *  @param isOpen 是否开启
 */
+(void)saveIsOpenMessagePush:(BOOL)isOpen
{
    [LZUserDataManager commonSaveBoolTypeWithKey:NS_ISMESSAGEPUSH value:isOpen];
}
+(BOOL)readIsOpenMessagePush
{
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    if([userDefaluts valueForKey:NS_ISMESSAGEPUSH]==nil){
        return YES;
    } else {
        return [LZUserDataManager commonReadBoolTypeWithKey:NS_ISMESSAGEPUSH];
    }
}

/**
 *  消息推送通知关闭的当前时间
 *
 *  @param date 消息推送通知关闭的当前时间
 */
+(void)saveCloseMessagePushDate:(NSString *)date{
    [LZUserDataManager commonSaveNSObjectTypeWithKey:NS_CLOSEMESSAGEPUSHDATE value:date];
}
+(NSString *)readCloseMessagePushDate{
    NSString *result = [LZFormat Null2String:[LZUserDataManager commonReadNSObjectTypeWithKey:NS_CLOSEMESSAGEPUSHDATE]];
    if([NSString isNullOrEmpty:result]){
        return [AppDateUtil GetCurrentDateForString];
    } else {
        return result;
    }
}

/**
 *  消息推送通知关闭的天数
 *
 *  @param date 消息推送通知关闭的当前时间
 */
+(void)saveCloseMessagePushDay:(NSInteger)day{
    [LZUserDataManager commonSaveIntegerTypeWithKey:NS_CLOSEMESSAGEPUSHDAY value:day];
}
+(NSInteger)readCloseMessagePushDay{
    NSInteger result = [LZUserDataManager commonReadIntegerTypeWithKey:NS_CLOSEMESSAGEPUSHDAY];
    if(result==0 || result>=30){
        return 5;
    } else{
        return result;
    }
}


/*
 * 记录是否开启登录安全校验
 */
+(void)saveIsPhoneValid:(BOOL)isPhoneValid{
    [LZUserDataManager commonSaveBoolTypeWithKey:NS_IsPhoneValid value:isPhoneValid];
}
+(BOOL)readIsPhoneValid{
    return [LZUserDataManager commonReadBoolTypeWithKey:NS_IsPhoneValid];
}


@end
