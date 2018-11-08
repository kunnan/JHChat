//
//  AppUtils.h
//  LeadingCloud
//
//  Created by wchMac on 16/1/18.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OrgEnterPriseModel;

#define IllegalChar  @"[\\/:*?<>|\"]" // 非法字符
@interface AppUtils : NSObject

typedef void(^GetNextImage)(UIImage *dataImage);

typedef void(^GetDataImage)(UIImage *image,NSData *data);

/**
 *  获取当前用户ID
 *
 *  @return uid
 */
+(NSString *)GetCurrentUserID;
/**
 *  获取当前用户名
 *
 *  @return uid
 */
+(NSString *)GetCurrentUserName;
/**
 *  获取当前企业ID
 *
 *  @return uid
 */
+(NSString *)GetCurrentOrgID;

/**
 *  获取当前组织model
 *
 *  @return 当前组织model
 */
+(OrgEnterPriseModel*)GetCurrentOrgEnterPrise;

/**
 *  获取当前人在当前企业下的名称
 *
 *  @return 在当前企业下的名称
 */
+(NSString *)GetCurrentOrgUsername;

/**
 *  获取当前身份类型
 *
 *  @return 当前身份
 */
+(NSString *)GetCurrentIdentityType;

/**
 *  检测是否需要新实例
 *
 *  @param tag 之前实例的Tag值
 *
 *  @return 是否需要
 */
+(BOOL)CheckIsRestInstance:(NSString *)useridTag guidTag:(NSString *)guidTag;

/**
 *  根据名称检测是否为图片
 *
 *  @param name 文件名称或扩展名
 *
 *  @return 是否是图片
 */
+(BOOL)CheckIsImageWithName:(NSString *)name;

/**
 *  根据图片名称检查gif 是否大于5M
 *
 *  @param name 文件名称或扩展名
 *
 *  @return 是否是图片
 */
+(BOOL)CheckIsGifImageSizeWithName:(NSString *)name Size:(CGFloat)size;
/**
 *  根据文件类型获取文件图片
 *
 *  @param name 文件名或扩展名
 *
 *  @return 图片名称
 */
+(NSString *)GetImageNameWithName:(NSString *)name;
/**
 *  根据文件id获取文件图片
 *
 *  @param name 文件id
 *
 *  @return 图片
 */
+(UIImage *)GetImageWithID:(NSString *)fileId exptype:(NSString *)exptype GetNewImage:(GetNextImage)getNewImage;

/**
 *  根据文件id 下载图片 只下不存
 *
 *  @param name 文件id
 *
 *  @return 图片
 */
+ (void)GetImageWithFileID:(NSString *)fileId Size:(NSString*)size GetNewImage:(GetDataImage)getNewImage;

/**
 *  获取当前APP版本号
 *
 *  @return 版本
 */
+(NSString *)getNowAppVersion;

//获取long类型的版本号
+(long)getLongTypeVersion:(NSString *)version;

/**
 *  获取首字母
 */
+(NSString *)getRightFirstChar:(NSString *)firseChar;

/**
 *  获取当前设备型号（未转化）
 *
 */
+ (NSString *)getPlatform;

/**
 *  获取设备的版本
 */
//+ (NSString *)getDeveiceModel;

/**
 获取设备剩余容量
 
 @return 字节数
 */
+ (long long) freeDiskSpaceInBytes;
#pragma mark 汉字转拼音
/**
 汉字转拼音
 
 @return 拼音
 */
+ (NSString *)transform:(NSString *)chinese;
#pragma mark 数组转字符串

/**
 数组转字符串

 @param array 数组

 @return 字符串
 */
+ (NSString*)arrayTransformString:(NSMutableArray*)array;
/**
 字符串转数组
 
 @param str 字符转
 
 @return 数组
 */
+ (NSMutableArray*)StringTransformArray:(NSString*)str;
/**
 通过字符截取字符串
 
 @param str 需要截取的字符串
 @param sepByStr 通过哪个字符串截取
 @return 截取完的字符串数组
 */
+ (NSMutableArray*)StringTransformArray:(NSString *)str SeparatedByString:(NSString*)sepByStr;
#pragma mark - 截取字符串（从后开始截直到匹配到相应的字符）
+(NSString*)SubStringBackwardsSearchWithSubStr:(NSString*)str stringName:(NSString*)stringName;
#pragma mark - 获取文件拓展名

/**
 获取文件拓展名

 @param stringName 带拓展名的名字
 @return 拓展名
 */
+ (NSString*)getExpType:(NSString*)stringName;

/**
 获取文件名

 @param stringName URL
 @return 文件名
 */
+ (NSString*)getFileName:(NSString*)stringName;

/**
 通过 . 获取文件夹名

 @param stringName 带拓展名的文件夹名
 @return 文件名
 */
+ (NSString*)getFileNameRangePoint:(NSString*)stringName;

/**
 获取截取的字符串（通过指定字符截取后面字符串）

 @param stringName 要截取的字符串
 @param substring 通过某个字符截取
 @return 截取完的字符串
 */
+ (NSString*)getStringRangePoint:(NSString*)stringName substring:(NSString*)substring;
#pragma mark - 校验非法字符
+(NSMutableArray*)isIncludIllegaCharaWithStr:(NSString*)fieldNewValue;
#pragma mark - 清缓存

/**
 清缓存
 */
+(void)clearCache;
#pragma mark - 获取友盟用到的Key

/**
 判断是否为appstore版本
 */
+(BOOL)CheckIsAppStoreVersion;

/**
 获取高德地图使用的Key
 */
+(NSString *)GetGaoDeKey;

/**
 获取友盟使用的Key
 */
+(NSString *)GetUMengKey;

//URL UTF8处理
+ (NSURL *)urlToNsUrl:(NSString *)strUrl;

#pragma mark - 加密处理
//对内容进行RSA加密
+ (NSString *)encryWithModulus:(NSString *)modulus exponent:(NSString *)exponent content:(NSString *)password;

#pragma mark - 替换Url中的参数
+(NSString *)replaceUrlParameter:(NSString *)url;

#pragma mark - 数据库旧表

/**
 数据库plist文件的移动
 */
+(void)creatPlistWithVersion:(NSInteger)checkVersion;

#pragma mark - 判断是否为公有云
//是否是公有云
+(BOOL)checkIsPublicServer:(NSString *)module;

#pragma mark - 功能设置开关
//打开或关闭某功能
+(void)setFunctionSetting:(NSString *)item;
//判断某功能是否打开
+(BOOL)checkFunctionSetting:(NSString *)item;

//是否使用友盟跟踪日志
+(BOOL)isUseUmengTrack;

#pragma mark - 获取当前手机的唯一标识ID
+(NSString *)getPhoneUniqueID;

#pragma mark - 清空临时通知，更改值为0
+(void)setTempNotificationValue;

@end
