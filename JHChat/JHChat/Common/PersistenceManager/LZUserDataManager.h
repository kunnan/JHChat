//
//  LZUserDataManager.h
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

#import <Foundation/Foundation.h>

@interface LZUserDataManager : NSObject

#pragma mark - KeyChain中存储数据

/*
 * 读取KeyChain通用方法
 */
+(NSMutableDictionary *)commonReadKeyChain;

/*
 * 登录方式
 */
+(void)saveLoginType:(NSString *)loginType;
+(NSString *)readLoginType;

/*
 * 用户登录名
 */
+(void)saveUserLoginName:(NSString *)loginName;
+(NSString *)readUserLoginName;

/*
 * 用户登录密码
 */
+(void)saveUserPassWord:(NSString *)passWord;
+(NSString *)readUserPassword;

/*
 * 第三方App的OpenID
 */
+(void)saveThirdAppOpenID:(NSString *)openID;
+(NSString *)readThirdAppOpenID;

/*
 * 第三方App的RefreshToken
 */
+(void)saveThirdAppRefreshToken:(NSString *)refreshToken;
+(NSString *)readThirdAppRefreshToken;

/*
 * 用户注册密码
 */
+(void)saveUserRegisterPassWord:(NSString *)passWord;
+(NSString *)readUserRegisterPassword;

/*
 * 公有云服务器
 */
+(void)savePublicServer:(NSString *)server;
+(NSString *)readPublicServer;

/*
 * 服务器
 */
+(void)saveServer:(NSString *)server;
+(NSString *)readServer;

/*
 * 服务器协议：http 或 https
 */
+(void)saveServerProtocol:(NSString *)serverProtocol;
+(NSString *)readServerProtocol;

/**
 *  记录服务器模式是公有还是私有
 */
+(void)saveIsServerModel:(NSString *)data;
+(NSString *)readServerModel;

///*
// * 注册显影性
// */
//+(void)saveRegistrable:(NSString *)registrable;
//+(NSString *)readRegistrable;

/**
 *  删除登录信息
 */
+(void)deleteLoginInfo;

/**
 *  设备推送ID
 */
+(void)saveDeviceToken:(NSString *)token;
+(NSString *)readDeviceToken;

/**
 *  手机唯一标识ID
 */
+(void)savePhoneUniqueID:(NSString *)phoneUniqueID;
+(NSString *)readPhoneUniqueID;

#pragma mark - NSUserDefaults中存储数据


+(void)commonSaveBoolTypeWithKey:(NSString *)key value:(BOOL)value;

+(void)commonSaveDoubleTypeWithKey:(NSString *)key value:(double)value;

+(void)commonSaveFloatTypeWithKey:(NSString *)key value:(float)value;

+(void)commonSaveIntegerTypeWithKey:(NSString *)key value:(NSInteger)value;

+(void)commonSaveNSObjectTypeWithKey:(NSString *)key value:(NSObject *)value;

+(void)commonSaveArrayTypeWithKey:(NSString *)key value:(NSMutableArray*)value;

+(BOOL)commonReadBoolTypeWithKey:(NSString *)key;

+(float)commonReadFloatTypeWithKey:(NSString *)key;

+(NSInteger)commonReadIntegerTypeWithKey:(NSString *)key;

+(double)commonReadDoubleTypeWithKey:(NSString *)key;

+(NSObject*)commonReadNSObjectTypeWithKey:(NSString *)key;

+(NSMutableArray*)commonReadArrayTypeWithKey:(NSString *)key;
/*
 * 示例
 */
+(void)saveDemoData:(NSString *)data;
+(NSString *)readDemoData;

/**
 *  各个模块对应的服务器地址
 *
 *  @param data 字典格式数据
 */
+(void)saveModulesServerInfo:(NSDictionary *)data;
+(NSDictionary *)readModulesServerInfo;
/**
 获取云盘文容量
 
 @param data data description
 */
+(void)saveNetSizeInfo:(NSMutableDictionary*)data;
+(NSString*)readNetSizeInfo ;
/**
 *  客户端与服务器端时间差
 *
 *  @param seconds 间隔多少秒
 */
+(void)saveIntervalSeconds:(NSInteger)seconds;
+(NSInteger)readIntervalSeconds;

/**
 获取阿里云文件id

 @param fileids 文件id数组
 */
+(void)saveFileidsWithArray:(NSMutableArray*)fileids;
+(NSMutableArray*)readFileids;
+(void)clearAliyunFileids;
/**
 *  当前登录人信息
 *
 *  @param data 字典格式数据
 */
+(void)saveCurrentUserInfo:(NSMutableDictionary *)data;
+(NSMutableDictionary *)readCurrentUserInfo;

/**
 *  Synk信息
 *
 *  @param data Synk数据
 */
+(void)saveSynkInfo:(NSMutableDictionary *)data;
+(NSMutableDictionary *)readSynkInfo;

/**
 *  之前是否登录进系统
 *
 *  @param isLogin 是否登录进系统
 */
+(void)saveIsLoginBefore:(BOOL)isLogin;
+(BOOL)readIsLoginBefore;

/**
 * 保存这个版本是否显示引导页
 
 * @param isShow ss
 */
+ (void)saveisShowGuideVersion:(BOOL)isShow;
+ (BOOL)readIsShowGuideVersion;

/**
 *  是否启动过此App
 *
 *  @param isHaveInstall 是否启动过
 */
+(void)saveIsHaveInstall:(NSString *)isHaveInstall;
+(NSString *)readIsHaveInstall;

/**
 记录第一张相册照片的时间
 
 @param time 时间
 */
+ (void)saveFirstPhotoTime:(NSString *)time;
+ (NSString *)readFirstPhotoTime;
/**
 *  播放声音的时间
 *
 *  @param soundDate 时间
 */
+(void)saveTheDateForSound:(NSString *)soundDate;
+(NSString *)readTheDateForSound;

/**
 *  是否开启振动
 *
 *  @param isOpen 是否开启
 */
+(void)saveIsOpenSoundShake:(BOOL)isOpen;
+(BOOL)readIsOpenSoundShake;

/**
 *  是否开启声音
 *
 *  @param isOpen 是否开启
 */
+(void)saveIsOpenSoundVoice:(BOOL)isOpen;
+(BOOL)readIsOpenSoundVoice;

/**
 *  提示音类型
 *
 *  @param soundfile 提示音文件
 */
+(void)saveSoundFile:(NSString *)soundfile;
+(NSString *)readSoundFile;

/**
 *  是否连接网络
 *
 *  @param isConnect 是否连接
 */
+(void)saveIsConnectNetWork:(BOOL)isConnect;
+(BOOL)readIsConnectNetWork;

/**
 *  是否与服务器连接着
 *
 *  @param isConnectServer 是否连接
 */
+(void)saveIsConnectServer:(BOOL)isConnectServer;
+(BOOL)readIsConnectServer;

/**
 *  云盘排序规则
 *
 *  @param sortrule 规则标识
 */
+(void)saveAppNetDiskSortRule:(NSMutableDictionary *)sortrule;
+(NSMutableDictionary *)readAppNetDiskSortRule;

/**
 *  任务排序规则
 *
 *  @param sortrule 规则标识
 */
+(void)saveTaskSortRule:(NSString *)sortrule;

+(NSString *)readTaskSortRule;

/**
 *  个人组织信息
 *
 *  @param dataArray 数组格式数据
 */
+(void)savePersonalEnterpriseInfo:(NSMutableArray *)dataArray;
+(NSMutableArray *)readPersonalEnterpriseInfo;

/**
 *  当前登录人切换组织成功后的组织ID
 *
 *  @param data 字典格式数据
 */
+(void)saveEnterpriseidInfo:(NSMutableDictionary *)data;
+(NSMutableDictionary *)readEnterpriseidInfo;

/**
 *  通知内的数据
 *
 *  @param data 消息通知数据
 */
+(void)saveNotificationInfo:(NSMutableDictionary *)data;
+(NSMutableDictionary *)readNotificationInfo;

/**
 *  其它应用打开本应用时传递的数据
 *
 *  @param data 应用通知数据
 */
+(void)saveOtherAppToThisInfo:(NSMutableDictionary *)data;
+(NSMutableDictionary *)readOtherAppToThisInfo;
/**
 *  3Dtouch传递的数据
 *
 *  @param data 应用通知数据
 */
+(void)save3DTouchInfo:(NSMutableDictionary *)data;
+(NSMutableDictionary *)read3DTouchInfo;
/**
 *  是否执行过检查新版本
 *
 *  @param date 检查过新版本的当前时间
 */
+(void)saveCheckNewVersion:(NSString *)date;
+(NSString *)readCheckNewVersion;

/**
 *  获取服务器配置参数
 *
 *  @param data 服务器配置数据
 */
+(void)saveAvailableDataContext:(NSMutableDictionary *)data;
+(NSMutableDictionary *)readAvailableDataContext;

/*
 * 数据库唯一实例标识
 */
+(void)saveDBGuidTag:(NSString *)dbguidtag;
+(NSString *)getDBGuidTag;

/**
 为了过滤用的保存不显示的模板code值
 */
+(void)saveCodeStr:(NSString *)codeStr;
+(NSString *)getCodeStr;

/**
 为了过滤使用保存tvid
 */
+(void)saveTvidStr:(NSString *)tvidStr;
+(NSString *)getTvidStr;

/**
 * 记录不允许上传的文件类型
 */
+(void)saveUnallowUpLoadFileType:(NSString *)data;
+(NSString *)readUnallowUpLoadFileType;

/*
 * 记录最后一次登录成功的时间
 */
+(void)saveLastestLoginDate:(NSString *)loginDate;
+(NSString *)getLastestLoginDate;

/*
 * 记录是否清理webview缓存
 */
+(void)saveIsWebCacheVersion:(NSString *)data;
+(NSString *)readIsWebCacheVersion;

/*
 * 记录AES加密tokenid
 */
+(void)saveAESToken:(NSString *)data;
+(NSString *)readAESToken;

/*
 * 记录App进入后台的时间
 */
+(void)saveEnterBackgroundTime:(NSString *)datetime;
+(NSString *)readEnterBackgroundTime;

/*
 * 记录某些功能单独打开
 */
+(void)saveFunctionSettingInfo:(NSMutableDictionary *)data;
+(NSMutableDictionary *)readFunctionSettingInfo;

/*
 * 记录是否为第一次登陆APP
 */
+(void)saveIsFirstLaunch:(NSMutableDictionary *)data;
+(NSMutableDictionary *)readIsFirstLaunch;

/*
 * 记录是否在语音视频聊天
 */
+(void)saveIsVodioChating:(BOOL)isChating;

+(BOOL)isVodioChating;

/*
 * 当前是否为灰度用户
 */
+(void)saveIsGayScaleUser:(BOOL)isGayScale;
+(BOOL)readIsGayScaleUser;

/*
 * 记录是否加载动态视图
 */
+(void)saveIsCooperationLoading:(BOOL)load;
+(BOOL)isCooperationLoading;


/*
 * 保存系统字体
 */
+(void)saveSystemFont:(NSString*)font;
+(NSString*)getSystemFont;
/*
 * 富文本相关功能启用
 */
+(NSString *)readCooperationDes;
+(NSString *)readFixClassStringName;
+(NSString *)readWebBrowserStringName;

/*
 * 搜索历史记录
 */
+(void)saveSearchHistory:(NSMutableArray*)historyArr Uid:(NSString*)uid;
+(NSMutableArray*)readSearchHistoryUid:(NSString*)uid;

+(void)saveHomeSeriviceCircle:(NSDictionary*)dic Uid:(NSString*)uid;

+(NSDictionary*)readHomeSeriviceCircleUid:(NSString*)uid;

+(void)saveIsLoadHomeSeriviceCircle:(BOOL)isload Uid:(NSString*)uid;

+(BOOL)readIsHomeSeriviceCircleUid:(NSString*)uid;

/**
 *  是否记录日志
 *
 *  @param isOpen 是否开启
 */
+(void)saveIsOpenRecordLog:(BOOL)isOpen;
+(BOOL)readIsOpenRecordLog;

/**
 *  闪退后是否发送邮件
 *
 *  @param isOpen 是否开启
 */
+(void)saveIsOpenCrashSendEmail:(BOOL)isOpen;
+(BOOL)readIsOpenCrashSendEmail;

/**
 *  是否开启消息推送
 *
 *  @param isOpen 是否开启
 */
+(void)saveIsOpenMessagePush:(BOOL)isOpen;
+(BOOL)readIsOpenMessagePush;

/**
 *  消息推送通知关闭的当前时间
 *
 *  @param date 消息推送通知关闭的当前时间
 */
+(void)saveCloseMessagePushDate:(NSString *)date;
+(NSString *)readCloseMessagePushDate;

/**
 *  消息推送通知关闭的天数
 *
 *  day 消息推送通知关闭的当前时间
 */
+(void)saveCloseMessagePushDay:(NSInteger)day;
+(NSInteger)readCloseMessagePushDay;

/*
 * 记录是否开启登录安全校验
 */
/*
 * 记录是否开启登录安全校验
 */
+(void)saveIsPhoneValid:(BOOL)isPhoneValid;
+(BOOL)readIsPhoneValid;

@end
