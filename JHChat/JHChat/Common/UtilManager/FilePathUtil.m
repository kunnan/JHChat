//
//  FilePathUtil.m
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

#import "FilePathUtil.h"

@implementation FilePathUtil

#pragma mark - 基础方法

/**
 *  获取沙盒路径
 *
 *  @return ".../934AEECD-72EE-4D70-B5A4-A6849F64ACF0/Documents"
 */
+(NSString *)getDocument
{
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

/**
 *  获取PreferencePanes路径
 *
 *  @return ".../520A40FC-E2E5-4315-88FB-6CCEBFBA9CC8/Library/Preferences"
 */
+(NSString *)getPreferences
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *preferencesDirectory = [NSString stringWithFormat:@"%@/Preferences/",[paths objectAtIndex:0]];
    return preferencesDirectory;
}

/**
 *  获取个人文件夹的绝对路径
 *
 *  @return 文件夹路径
 */
+ (NSString *)getPersonalDicAbsolutePath {
    
    NSMutableDictionary *userinfo = [LZUserDataManager readCurrentUserInfo];
    NSString *uid = [userinfo objectForKey:@"uid"];
    if(uid == nil){
        uid = @"uid";
    }
    
    NSString *absolutePath = [[FilePathUtil getDocument] stringByAppendingFormat:@"/%@/",uid];
    return absolutePath;
}

/**
 *  获取个人文件夹的相对路径
 *
 *  @return 文件夹路径
 */
+ (NSString *)getPersonalDicRelatePath {
    
    NSMutableDictionary *userinfo = [LZUserDataManager readCurrentUserInfo];
    NSString *uid = [userinfo objectForKey:@"uid"];
    if(uid == nil){
        uid = @"uid";
    }
    
    NSString *relatePath = [NSString stringWithFormat:@"/%@/",uid];
    return relatePath;
}

/**
 *  文件夹不存在时，创建文件夹
 *
 *  @param dicPath 文件夹路径
 */
+ (void)createDicIfNotExists:(NSString *)dicPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:dicPath isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:dicPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir)
        {
            DDLogError(@"创建文件夹出错！");
        }
    }
}

#pragma mark - 数据库路径

/**
 *  获取数据库所在文件夹路径
 *
 *  @return 文件夹路径
 */
+ (NSString *)getDbDicPath {
    
    NSString *dbFileDic = [[FilePathUtil getPersonalDicAbsolutePath] stringByAppendingFormat:@"db/"];
    [FilePathUtil createDicIfNotExists:dbFileDic];
    return dbFileDic;
}

#pragma mark - Icon文件路径

/**
 *  获取存放头像以及其他文件根目录绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getCommonIconImageDicAbsolutePath{
    NSString *fileDic = [[FilePathUtil getDocument] stringByAppendingFormat:@"/CommonIcon/"];
    [FilePathUtil createDicIfNotExists:fileDic];
    return fileDic;
}

/**
 *  获取存放头像以及其他文件根目录相对路径
 *
 *  @return 路径
 */
+ (NSString *)getCommonImageDicRelatePath{
    NSString *dbFileDic = @"/CommonIcon/";
    return dbFileDic;
}

/**
 *  获取头像，小图文件绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getFaceIconImageSmallDicAbsolutePath{
    NSString *fileDic = [[FilePathUtil getDocument] stringByAppendingFormat:@"/CommonIcon/FaceIcon/Small/"];
    [FilePathUtil createDicIfNotExists:fileDic];
    return fileDic;
}

/**
 *  获取头像，原图文件绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getFaceIconImageDicAbsolutePath{
    NSString *fileDic = [[FilePathUtil getDocument] stringByAppendingFormat:@"/CommonIcon/FaceIcon/"];
    [FilePathUtil createDicIfNotExists:fileDic];
    return fileDic;
}

/**
 *  获取头像文件相对路径
 *
 *  @return 路径
 */
+ (NSString *)getFaceImageDicRelatePath{
    NSString *dbFileDic = @"/CommonIcon/FaceIcon/";
    return dbFileDic;
}

/**
 *  获取消息页签应用头像，小图文件绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getMsgTemplateImageDicRelatePath{
    NSString *fileDic = [[FilePathUtil getDocument] stringByAppendingFormat:@"/CommonIcon/MsgTemplateIcon/Small/"];
    [FilePathUtil createDicIfNotExists:fileDic];
    return fileDic;
}

/**
 *  获取企业Logo绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getOrganizationIconImageSmallDicAbsolutePath{
    NSString *fileDic = [[FilePathUtil getDocument] stringByAppendingFormat:@"/CommonIcon/OrganizationIcon/Small/"];
    [FilePathUtil createDicIfNotExists:fileDic];
    return fileDic;
}

/**
 *  获取应用，小图图片绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getAppIconImageSmallDicAbsolutePath{
    NSString *fileDic = [[FilePathUtil getDocument] stringByAppendingFormat:@"/CommonIcon/AppIcon/Small/"];
    [FilePathUtil createDicIfNotExists:fileDic];
    return fileDic;
}

/**
 *  获取应用，原图图片绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getAppIconImageDicAbsolutePath{
    NSString *fileDic = [[FilePathUtil getDocument] stringByAppendingFormat:@"/CommonIcon/AppIcon/"];
    [FilePathUtil createDicIfNotExists:fileDic];
    return fileDic;
}

/**
 *  获取服务圈，小图图片绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getServiceCirlesIconImageSmallDicAbsolutePath{
    NSString *fileDic = [[FilePathUtil getDocument] stringByAppendingFormat:@"/CommonIcon/ServiceCirlesIcon/Small/"];
    [FilePathUtil createDicIfNotExists:fileDic];
    return fileDic;
}

/**
 *  获取服务圈，原图图片绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getServiceCirlesIconImageDicAbsolutePath{
    NSString *fileDic = [[FilePathUtil getDocument] stringByAppendingFormat:@"/CommonIcon/ServiceCirlesIcon/"];
    [FilePathUtil createDicIfNotExists:fileDic];
    return fileDic;
}
/**
 *  获取服务圈原图相对路径
 *
 *  @return 路径
 */
+ (NSString *)getServiceCirlesIconImageRelatePath{
    NSString *dbFileDic = @"/CommonIcon/ServiceCirlesIcon/";
    return dbFileDic;
}

/**
 *  获取服务圈小图相对路径
 *
 *  @return 路径
 */
+ (NSString *)getServiceCirlesIconSmaleImageRelatePath{
    NSString *dbFileDic = @"/CommonIcon/ServiceCirlesIcon/Small/";
    return dbFileDic;
}

/**
 *  获取协作、工作组，小图图片绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getCooperationWorkGroupIconImageSmallDicAbsolutePath{
    NSString *fileDic = [[FilePathUtil getDocument] stringByAppendingFormat:@"/CommonIcon/CooperationWorkGroupIcon/Small/"];
    [FilePathUtil createDicIfNotExists:fileDic];
    return fileDic;
}

/**
 *  获取协作、工作组，原图图片绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getCooperationWorkGroupIconImageDicAbsolutePath{
    NSString *fileDic = [[FilePathUtil getDocument] stringByAppendingFormat:@"/CommonIcon/CooperationWorkGroupIcon/"];
    [FilePathUtil createDicIfNotExists:fileDic];
    return fileDic;
}

/**
 *  获取协作、工作组，原图图片相对路径
 *
 *  @return 路径
 */
+ (NSString *)getCooperationWorkGroupIconImageRelatePath{
    NSString *dbFileDic = @"/CommonIcon/CooperationWorkGroupIcon/";
    return dbFileDic;
}

/**
 *  获取协作、项目，小图图片绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getCooperationProjectIconImageSmallDicAbsolutePath{
    NSString *fileDic = [[FilePathUtil getDocument] stringByAppendingFormat:@"/CommonIcon/CooperationProjectIcon/Small/"];
    [FilePathUtil createDicIfNotExists:fileDic];
    return fileDic;
}

/**
 *  获取协作、项目，原图图片绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getCooperationProjectIconImageDicAbsolutePath{
    NSString *fileDic = [[FilePathUtil getDocument] stringByAppendingFormat:@"/CommonIcon/CooperationProjectIcon/"];
    [FilePathUtil createDicIfNotExists:fileDic];
    return fileDic;
}

/**
 *  获取协作、项目，原图图片相对路径
 *
 *  @return 路径
 */
+ (NSString *)getCooperationProjectIconImageRelatePath{
    NSString *dbFileDic = @"/CommonIcon/CooperationProjectIcon/";
    return dbFileDic;
}

/**
 *  获取插件H5调用图片绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getTmpRunParameterForImageSmallDicAbsolutePath{
    NSString *fileDic = [[FilePathUtil getDocument] stringByAppendingFormat:@"/CommonIcon/TmpRunParameterForImage/Small/"];
    [FilePathUtil createDicIfNotExists:fileDic];
    return fileDic;
}

/**
 *  获取插件H5调用原图图片绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getTmpRunParameterForImageDicAbsolutePath{
    NSString *fileDic = [[FilePathUtil getDocument] stringByAppendingFormat:@"/CommonIcon/TmpRunParameterForImage/"];
    [FilePathUtil createDicIfNotExists:fileDic];
    return fileDic;
}

/**
 *  获取插件H5调用图片相对路径
 *
 *  @return 路径
 */
+ (NSString *)getTmpRunParameterForImageRelatePath{
    NSString *dbFileDic = @"/CommonIcon/TmpRunParameterForImage/";
    return dbFileDic;
}

#pragma mark - 聊天窗口文件路径

/**
 *  获取聊天界面，发送图片的绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getChatSendImageDicAbsolutePath{
    NSString *dbFileDic = [[FilePathUtil getPersonalDicAbsolutePath] stringByAppendingFormat:@"Chat/Send/"];
    [FilePathUtil createDicIfNotExists:dbFileDic];
    return dbFileDic;
}

/**
 *  获取聊天界面，发送图片的相对路径
 *
 *  @return 路径
 */
+ (NSString *)getChatSendImageDicRelatePath{
    NSString *dbFileDic = [[FilePathUtil getPersonalDicRelatePath] stringByAppendingFormat:@"Chat/Send/"];
    return dbFileDic;
}

/**
 *  获取聊天界面，发送图片的小图绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getChatSendImageSmallDicAbsolutePath{
    NSString *dbFileDic = [[FilePathUtil getPersonalDicAbsolutePath] stringByAppendingFormat:@"Chat/Send/Small/"];
    [FilePathUtil createDicIfNotExists:dbFileDic];
    return dbFileDic;
}

/**
 *  获取聊天界面，下载文件的绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getChatRecvImageDicAbsolutePath{
    NSString *dbFileDic = [[FilePathUtil getPersonalDicAbsolutePath] stringByAppendingFormat:@"Chat/Recv/"];
    [FilePathUtil createDicIfNotExists:dbFileDic];
    return dbFileDic;
}

/**
 *  获取聊天界面，下载文件的相对路径
 *
 *  @return 路径
 */
+ (NSString *)getChatRecvImageDicRelatePath{
    NSString *dbFileDic = [[FilePathUtil getPersonalDicRelatePath] stringByAppendingFormat:@"Chat/Recv/"];
    return dbFileDic;
}

/**
 *  获取聊天界面，下载文件的小图绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getChatRecvImageSmallDicAbsolutePath{
    NSString *dbFileDic = [[FilePathUtil getPersonalDicAbsolutePath] stringByAppendingFormat:@"Chat/Recv/Small/"];
    [FilePathUtil createDicIfNotExists:dbFileDic];
    return dbFileDic;
}

#pragma mark - 云盘文件路径

/**
 *  获取云盘，文件的绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getNetDiskFileDicAbsolutePath{
    NSString *dbFileDic = [[FilePathUtil getPersonalDicAbsolutePath] stringByAppendingFormat:@"NetDisk/"];
    [FilePathUtil createDicIfNotExists:dbFileDic];
    return dbFileDic;
}

/**
 *  获取云盘，文件的相对路径
 *
 *  @return 路径
 */
+ (NSString *)getNetDiskFileDicRelatePath{
    NSString *dbFileDic = [[FilePathUtil getPersonalDicRelatePath] stringByAppendingFormat:@"NetDisk/"];
    return dbFileDic;
}

/**
 *  获取云盘，文件的小图绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getNetDiskFileSmallDicAbsolutePath{
    NSString *dbFileDic = [[FilePathUtil getPersonalDicAbsolutePath] stringByAppendingFormat:@"NetDisk/Small/"];
    [FilePathUtil createDicIfNotExists:dbFileDic];
    return dbFileDic;
}
/**
 *  获取缩略图，缩略图的绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getSmallPicDicAbsolutePath{
    NSString *dbFileDic = [[FilePathUtil getPersonalDicAbsolutePath] stringByAppendingFormat:@"Thumbnail/"];
    [FilePathUtil createDicIfNotExists:dbFileDic];
    return dbFileDic;
}
/**
 *  获取云盘，文件上传的小图绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getNetDiskFileUploadSmallDicAbsolutePath{
    NSString *dbFileDic = [[FilePathUtil getPersonalDicAbsolutePath] stringByAppendingFormat:@"NetDisk/UploadSmall/"];
    [FilePathUtil createDicIfNotExists:dbFileDic];
    return dbFileDic;
}
/**
 *  获取云盘，copy文件绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getNetDiskFileCopyDicAbsolutePath{
    NSString *dbFileDic = [[FilePathUtil getPersonalDicAbsolutePath] stringByAppendingFormat:@"NetDisk/Copy/"];
    [FilePathUtil createDicIfNotExists:dbFileDic];
    return dbFileDic;
}

#pragma mark - 动态文件路径

/**
 *  获取动态图片的绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getPostFileDownloadDicAbsolutePath{
    NSString *dbFileDic = [[FilePathUtil getPersonalDicAbsolutePath] stringByAppendingFormat:@"Post/"];
    [FilePathUtil createDicIfNotExists:dbFileDic];
    return dbFileDic;
}

/**
 *   获取动态图片的相对路径

 *
 *  @return 路径
 */
+ (NSString *)getPostFileDownloadDicRelatePath{
    NSString *dbFileDic = [[FilePathUtil getPersonalDicRelatePath] stringByAppendingFormat:@"Post/"];
    return dbFileDic;
}

/**
 *  获取动态图片小图的绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getPostFileSmallDownloadDicAbsolutePath{
    NSString *dbFileDic = [[FilePathUtil getPersonalDicAbsolutePath] stringByAppendingFormat:@"Post/Small/"];
    [FilePathUtil createDicIfNotExists:dbFileDic];
    return dbFileDic;
}


#pragma mark - 错误文件路径

/**
 *  获取错误信息文件的绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getErrorFileDownloadDicAbsolutePath{
	NSString *dbFileDic = [[FilePathUtil getPersonalDicAbsolutePath] stringByAppendingFormat:@"Error/"];
	[FilePathUtil createDicIfNotExists:dbFileDic];
	return dbFileDic;
}

/**
 *   获取错误信息文件的相对路径
 
 *
 *  @return 路径
 */
+ (NSString *)getErrorFileDownloadDicRelatePath{
	NSString *dbFileDic = [[FilePathUtil getPersonalDicRelatePath] stringByAppendingFormat:@"Error/"];
	return dbFileDic;
}

#pragma mark - 收藏小图文件路径

/**
 *  获取收藏文件绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getFavoritesImageDicAbsolutePath{
    NSString *fileDic = [[FilePathUtil getPersonalDicAbsolutePath] stringByAppendingFormat:@"Favorites/"];
    [FilePathUtil createDicIfNotExists:fileDic];
    return fileDic;
}

#pragma mark - 音频文件路径

/**
 *  获取音频文件的绝对路径
 *
 *  @return 路径
 */
+ (NSString *)getAudioDicAbsolutePath{
    NSString *dbFileDic = [[FilePathUtil getPersonalDicAbsolutePath] stringByAppendingFormat:@"Audio/"];
    [FilePathUtil createDicIfNotExists:dbFileDic];
    return dbFileDic;
}

/**
 *   获取音频文件的相对路径
 *
 *  @return 路径
 */
+ (NSString *)getAudioDicRelatePath{
    NSString *dbFileDic = [[FilePathUtil getPersonalDicRelatePath] stringByAppendingFormat:@"Audio/"];
    return dbFileDic;
}

@end
