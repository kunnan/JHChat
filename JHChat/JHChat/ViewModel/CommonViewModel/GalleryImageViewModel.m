//
//  GalleryImageViewModel.m
//  LeadingCloud
//
//  Created by wchMac on 16/2/3.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-02-03
 Version: 1.0
 Description: 缩略图相关处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "GalleryImageViewModel.h"
#import "ModuleServerUtil.h"
#import "AppDelegate.h"
#import "MWPhotoBrowser.h"
#import "SDWebImageDownloader.h"
#import "AliyunRemotrlyServerDAL.h"
#import "AliyunRemotelyAccountDAL.h"
#import "RemotelyServerModel.h"
#import "RemotelyAccountModel.h"
#import "AliyunOSS.h"
#import "OSSClient+LZExpand.h"
#import "AliyunViewModel.h"
#import "LZBaseAppDelegate.h"
#import "NSString+IsNullOrEmpty.h"
#import "FilePathUtil.h"
#import "AppDateUtil.h"
@implementation GalleryImageViewModel

AppDelegate *appdelegatel;

/**
 *  获取图标的Url地址
 *
 *  @param fileid 文件ID
 *  @param size   尺寸
 *
 *  @return 地址
 */
+(NSString *)GetGalleryIconImageUrlFileId:(NSString *)fileid size:(NSString *)size{
//    NSLog(@"获取等比例缩略图的Url地址fileid: %@",fileid);
    NSString *downurl = nil;
    if ([self isAliyunDownWithFileid:fileid]) {
        downurl = [self getAliyunDownUrlFileid:fileid size:size para:@"fixed"];
        if (![NSString isNullOrEmpty:downurl]) {
//            NSLog(@"缩略图走了阿里云下载");
            return downurl;
        }
    }
//     NSLog(@"缩略图走了理正云下载");
    NSString *server = [ModuleServerUtil GetServerWithModule:Modules_File];
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AppDelegate *appDelegate = [LZBaseAppDelegate shareInstance].appDelegate;
    NSString *iconUrl = [NSString stringWithFormat:@"%@/api/fileserver/galleryiocnimg/%@/%@/%@",server,fileid, size,appDelegate.lzservice.tokenId];
    
    return iconUrl;
}

/**
 *  获取等比例缩略图的Url地址
 *
 *  @param fileid 文件ID
 *  @param size   尺寸
 *
 *  @return 地址
 */
+(NSString *)GetGalleryThumbnailImageUrlFileId:(NSString *)fileid size:(NSString *)size{
//    NSLog(@"获取等比例缩略图的Url地址fileid: %@",fileid);
    NSString *downurl = nil;
    if ([self isAliyunDownWithFileid:fileid] ) {
        downurl = [self getAliyunDownUrlFileid:fileid size:size para:@"lfit"];
        if (![NSString isNullOrEmpty:downurl]) {
//            NSLog(@"缩略图走了阿里云下载");
            return downurl;
        }
    }
//     NSLog(@"缩略图走了理正云下载");
    NSString *server = [ModuleServerUtil GetServerWithModule:Modules_File];
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AppDelegate *appDelegate = [LZBaseAppDelegate shareInstance].appDelegate;
    NSString *iconUrl = [NSString stringWithFormat:@"%@/api/fileserver/gallerythumbnailimg/%@/%@/%@",server,fileid, size,appDelegate.lzservice.tokenId];
    
    return iconUrl;
}
/**
 *  获取原图的Url地址
 *
 *  @param fileid 文件ID
 *
 *  @return 地址
 */
+(NSString *)GetGalleryOriImageUrlFileId:(NSString *)fileid{
//    NSLog(@"获取等比例缩略图的Url地址fileid: %@",fileid);
    NSString *downurl = nil;
    if ([self isAliyunDownWithFileid:fileid]) {
        downurl = [self getAliyunDownUrlFileid:fileid size:nil para:nil];
        
        if (![NSString isNullOrEmpty:downurl]) {
//            NSLog(@"缩略图走了阿里云下载");
            return downurl;
        }
    }

//    NSLog(@"缩略图走了理正云下载");
    NSString *server = [ModuleServerUtil GetServerWithModule:Modules_File];
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AppDelegate *appDelegate = [LZBaseAppDelegate shareInstance].appDelegate;
    NSString *iconUrl = [NSString stringWithFormat:@"%@/api/fileserver/galleryoriginalimg/%@/%@",server,fileid,appDelegate.lzservice.tokenId];
    
    return iconUrl;
}

/**
 *  获取灰色图片的Url地址
 *
 *  @param fileid 文件ID
 *
 *  @return 地址
 */
+(NSString *)GetGrayIconUrlFileId:(NSString *)fileid{
    //    NSLog(@"获取等比例缩略图的Url地址fileid: %@",fileid);
//    NSString *downurl = nil;
//    if ([self isAliyunDownWithFileid:fileid]) {
//        downurl = [self getAliyunDownUrlFileid:fileid size:nil para:nil];
//        
//        if (![NSString isNullOrEmpty:downurl]) {
//            //            NSLog(@"缩略图走了阿里云下载");
//            return downurl;
//        }
//    }
    
    //    NSLog(@"缩略图走了理正云下载");
    NSString *server = [ModuleServerUtil GetServerWithModule:Modules_File];
    AppDelegate *appDelegate = [LZBaseAppDelegate shareInstance].appDelegate;
    NSString *iconUrl = [NSString stringWithFormat:@"%@/api/filemanager/img/getgrayicon/%@/%@",server,fileid,appDelegate.lzservice.tokenId];
    
    return iconUrl;
}
/**
 获取图的Url地址(加入url是否永久有效)

 @param fileid 文件id
 @param isThumbnailImageUrl 是否下载缩略图
 @param size 大熊啊
 @param isread is否永久
 @return url地址
 */
+(NSString *)GetGalleryOriImageUrlIsReadFileId:(NSString *)fileid isThumbnailImageUrl:(BOOL)isThumbnailImageUrl size:(NSString *)size withisRead:(BOOL)isread {
    
    [AliyunOSS sharedInstance].isread = isread;

    NSString *downurl = nil;
    if ([self isAliyunDownWithFileid:fileid] && !isThumbnailImageUrl) {
        downurl = [self getAliyunDownUrlFileid:fileid size:nil para:nil];
        
        if (![NSString isNullOrEmpty:downurl]) {
            return downurl;
        }
    }
    
    //    NSLog(@"缩略图走了理正云下载");
    NSString *server = [ModuleServerUtil GetServerWithModule:Modules_File];
    //    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AppDelegate *appDelegate = [LZBaseAppDelegate shareInstance].appDelegate;
    NSString *iconUrl = @"";
    if (!isThumbnailImageUrl) {
         iconUrl = [NSString stringWithFormat:@"%@/api/fileserver/galleryoriginalimg/%@/%@",server,fileid,appDelegate.lzservice.tokenId];
    }
    else {
        iconUrl = [NSString stringWithFormat:@"%@/api/fileserver/gallerythumbnailimg/%@/%@/%@",server,fileid, size,appDelegate.lzservice.tokenId];
    }
   
    
    return iconUrl;
}

/**
 获取图形验证码的Url地址
 
 @param typeid 类型id
 @param key 当前id
 @param codelength 图形验证码长度
 @param graphsize 图形尺寸
 @param fontsize 字体大小
 @return url地址
 */
+(NSString *)GetGraphCodeImageUrlTypeId:(NSString *)typeid key:(NSString *)key{
    //    NSLog(@"缩略图走了理正云下载");
    NSString *server = [ModuleServerUtil GetServerWithModule:Modules_Default];
    //    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AppDelegate *appDelegate = [LZBaseAppDelegate shareInstance].appDelegate;
    NSString *iconUrl = [NSString stringWithFormat:@"%@/api/user/graphcode/%@/create/%@/4/85X28/14/%@?version=%@",server,typeid,key,appDelegate.lzservice.tokenId,[AppDateUtil GetCurrentDateForString]];
    return iconUrl;
}


/**
 得到阿里云服务器
 */
+(RemotelyServerModel*)getAliyunServerModel {
//     appdelegatel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegatel = [LZBaseAppDelegate shareInstance].appDelegate;
   // RemotelyServerModel *serverModel = appdelegatel.lzGlobalVariable.aliyunServerModel;
    RemotelyServerModel *serverModel = [AliyunViewModel getAliyunServer];
    
    return serverModel;
}
+(RemotelyAccountModel*)getAliyunAccountModel {
//    appdelegatel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegatel = [LZBaseAppDelegate shareInstance].appDelegate;
    return [AliyunViewModel getAcountModelFormLocal];
}
+(BOOL)isAliyunDownWithFileid:(NSString*)fileid {
    
    /* 在这之前要保证不为空 */
    if (([[self getAliyunServerModel].minpartition longLongValue] < [fileid longLongValue])&& [self getAliyunServerModel] != nil && [self getAliyunAccountModel] != nil) {
        
        return YES;
    }
    return NO;
}

+(NSString*)getAliyunDownUrlFileid:(NSString*)fileid size:(NSString*)size para:(NSString*)para {
    BOOL isExistedImg =NO;
    NSString *faceIconPath = [NSString stringWithFormat:@"%@%@.jpg",[FilePathUtil getFaceIconImageSmallDicAbsolutePath],fileid];
    NSString *msgTemplateImage = [NSString stringWithFormat:@"%@%@.jpg",[FilePathUtil getMsgTemplateImageDicRelatePath],fileid];
    if ([[NSFileManager defaultManager] fileExistsAtPath:faceIconPath] || [[NSFileManager defaultManager] fileExistsAtPath:msgTemplateImage]) {
        isExistedImg = YES;
    }
    NSString *str = nil;
    if (size != nil) { //获取指定大小的图片
        NSString *sizeCur = [size substringToIndex:[size rangeOfString:@"X" options:NSBackwardsSearch].location];
        
        str = [[AliyunOSS sharedInstance] getDownImageUrlWithObjectKey:fileid withSize:sizeCur fixedOrLfit:para isExistedImg:isExistedImg];
    }
    else { // 浏览原图
        str = [[AliyunOSS sharedInstance] getDownImageUrlWithObjectKey:fileid withSize:nil fixedOrLfit:nil isExistedImg:isExistedImg];
    }
   
    NSLog(@"获取图片下载的url:%@",str);
    return str;
}
@end
