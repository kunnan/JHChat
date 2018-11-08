//
//  FilePathUtil.h
//  LeadingCloud
//
//  Created by wchMac on 16/1/18.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-01-18
 Version: 1.0
 Description: 客户端路径管理类
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface FilePathUtil : NSObject

/**
 *  获取沙盒路径
 *
 *  @return ".../934AEECD-72EE-4D70-B5A4-A6849F64ACF0/Documents"
 */
+(NSString *)getDocument;

/**
 *  获取PreferencePanes路径
 *
 *  @return ".../520A40FC-E2E5-4315-88FB-6CCEBFBA9CC8/Library/Preferences"
 */
+(NSString *)getPreferences;

/**
 *  获取个人文件夹的路径
 *
 *  @return 文件夹路径
 */
+ (NSString *)getPersonalDicAbsolutePath;

/**
 *  获取个人文件夹的相对路径
 *
 *  @return 文件夹路径
 */
+ (NSString *)getPersonalDicRelatePath;

/**
 *  文件夹不存在时，创建文件夹
 *
 *  @param dicPath 文件夹路径
 */
+ (void)createDicIfNotExists:(NSString *)dicPath;

#pragma mark - 数据库路径

/**
 *  获取数据库所在文件夹路径
 *
 *  @return 文件夹路径
 */
+ (NSString *)getDbDicPath;

#pragma mark - 头像文件路径

/**
 *  获取存放头像以及其他文件根目录绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getCommonIconImageDicAbsolutePath;

/**
 *  获取存放头像以及其他文件根目录相对路径
 *
 *  @return 路径
 */
+ (NSString *)getCommonImageDicRelatePath;

/**
 *  获取头像文件绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getFaceIconImageSmallDicAbsolutePath;

/**
 *  获取头像，原图文件绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getFaceIconImageDicAbsolutePath;

/**
 *  获取头像文件相对路径
 *
 *  @return 路径
 */
+ (NSString *)getFaceImageDicRelatePath;

/**
 *  获取消息页签应用头像，小图文件绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getMsgTemplateImageDicRelatePath;

/**
 *  获取企业Logo绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getOrganizationIconImageSmallDicAbsolutePath;

/**
 *  获取应用，小图图片绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getAppIconImageSmallDicAbsolutePath;

/**
 *  获取应用，原图图片绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getAppIconImageDicAbsolutePath;

/**
 *  获取服务圈，小图图片绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getServiceCirlesIconImageSmallDicAbsolutePath;

/**
 *  获取服务圈，原图图片绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getServiceCirlesIconImageDicAbsolutePath;

/**
 *  获取服务圈原图相对路径
 *
 *  @return 路径
 */
+ (NSString *)getServiceCirlesIconImageRelatePath;

/**
 *  获取服务圈小图相对路径
 *
 *  @return 路径
 */
+ (NSString *)getServiceCirlesIconSmaleImageRelatePath;

/**
 *  获取协作、工作组,小图图片绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getCooperationWorkGroupIconImageSmallDicAbsolutePath;

/**
 *  获取协作、工作组，原图图片绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getCooperationWorkGroupIconImageDicAbsolutePath;

/**
 *  获取协作、工作组，原图图片相对路径
 *
 *  @return 路径
 */
+ (NSString *)getCooperationWorkGroupIconImageRelatePath;

/**
 *  获取协作、项目，小图图片绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getCooperationProjectIconImageSmallDicAbsolutePath;

/**
 *  获取协作、项目，原图图片绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getCooperationProjectIconImageDicAbsolutePath;

/**
 *  获取协作、项目，原图图片相对路径
 *
 *  @return 路径
 */
+ (NSString *)getCooperationProjectIconImageRelatePath;

/**
 *  获取插件H5调用图片绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getTmpRunParameterForImageSmallDicAbsolutePath;

/**
 *  获取插件H5调用原图图片绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getTmpRunParameterForImageDicAbsolutePath;

/**
 *  获取插件H5调用图片相对路径
 *
 *  @return 路径
 */
+ (NSString *)getTmpRunParameterForImageRelatePath;

#pragma mark - 聊天窗口文件路径

/**
 *  获取聊天界面，发送图片的绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getChatSendImageDicAbsolutePath;

/**
 *  获取聊天界面，发送图片的相对路径
 *
 *  @return 路径
 */
+ (NSString *)getChatSendImageDicRelatePath;

/**
 *  获取聊天界面，发送图片的小图绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getChatSendImageSmallDicAbsolutePath;

/**
 *  获取聊天界面，下载文件的绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getChatRecvImageDicAbsolutePath;

/**
 *  获取聊天界面，下载文件的相对路径
 *
 *  @return 路径
 */
+ (NSString *)getChatRecvImageDicRelatePath;
/**
 *  获取聊天界面，下载文件的小图绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getChatRecvImageSmallDicAbsolutePath;

#pragma mark - 云盘文件路径

/**
 *  获取云盘，文件的绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getNetDiskFileDicAbsolutePath;

/**
 *  获取云盘，文件的相对路径
 *
 *  @return 路径
 */
+ (NSString *)getNetDiskFileDicRelatePath;

/**
 *  获取云盘，文件的小图绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getNetDiskFileSmallDicAbsolutePath;
/**
 *  获取缩略图，缩略图的绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getSmallPicDicAbsolutePath;

/**
 *  获取云盘，文件上传的小图绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getNetDiskFileUploadSmallDicAbsolutePath;

/**
 *  获取云盘，copy文件绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getNetDiskFileCopyDicAbsolutePath;

#pragma mark - 动态文件路径

/**
 *  获取动态图片的绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getPostFileDownloadDicAbsolutePath;

/**
 *   获取动态图片的相对路径
 *
 *  @return 路径
 */
+ (NSString *)getPostFileDownloadDicRelatePath;

/**
 *  获取动态图片小图的绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getPostFileSmallDownloadDicAbsolutePath;


#pragma mark - 错误文件路径

/**
 *  获取错误信息文件的绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getErrorFileDownloadDicAbsolutePath;

/**
 *   获取错误信息文件的相对路径
 
 *
 *  @return 路径
 */
+ (NSString *)getErrorFileDownloadDicRelatePath;


#pragma mark - 收藏小图文件路径

/**
 *  获取收藏小图文件绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getFavoritesImageDicAbsolutePath;

#pragma mark - 音频文件路径

/**
 *  获取音频文件的绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getAudioDicAbsolutePath;

/**
 *   获取音频文件的相对路径
 *
 *  @return 路径
 */
+ (NSString *)getAudioDicRelatePath;


@end
