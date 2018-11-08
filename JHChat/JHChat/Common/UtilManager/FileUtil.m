//
//  FileUtil.m
//  LeadingCloud
//
//  Created by wang on 17/1/9.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "FileUtil.h"
#import "FilePathUtil.h"
#import "LZFMDatabase.h"
#import "SDWebImageManager.h"


@implementation FileUtil


+(void)replaceNameFilePath:(NSString*)filepath OrgName:(NSString*)orgFileName NewFileName:(NSString*)newFileName{
    // 更改磁盘名
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@%@" ,filepath,orgFileName];
    NSLog(@"原路径名：%d",[[NSFileManager defaultManager] fileExistsAtPath:path]);
    
    NSString *movePath = [NSString stringWithFormat:@"%@%@" ,filepath,newFileName];
    NSError *error;
    [fileManage moveItemAtPath:path toPath:movePath error:&error];
    NSLog(@"新路径名：%d",[[NSFileManager defaultManager] fileExistsAtPath:movePath]);
    
}


#pragma mark 清理缓存

// 获取沙盒目录下所有文件的大小
+(CGFloat )documentSize
{
    //    CGFloat documentSizes=
    //    [self folderSizeAtPath :[FilePathUtil getPersonalDicAbsolutePath]]
    //    -[self folderSizeAtPath:[FilePathUtil getDbDicPath]]
    //    -[self folderSizeAtPath:[FilePathUtil getChatSendImageSmallDicAbsolutePath]]
    //    -[self folderSizeAtPath:[FilePathUtil getChatRecvImageSmallDicAbsolutePath]]
    //    -[self folderSizeAtPath:[FilePathUtil getNetDiskFileSmallDicAbsolutePath]]
    //    -[self folderSizeAtPath:[FilePathUtil getPostFileSmallDownloadDicAbsolutePath]]
    //    -[self folderSizeAtPath:[FilePathUtil getNetDiskFileUploadSmallDicAbsolutePath]];
    CGFloat documentSizes=
    [FileUtil folderSizeAtPath :[FilePathUtil getPersonalDicAbsolutePath]]
    +[FileUtil folderSizeAtPath:[FilePathUtil getCommonIconImageDicAbsolutePath]]
    -[FileUtil folderSizeAtPath:[FilePathUtil getDbDicPath]];
    NSLog(@"size:%f",documentSizes);
    return documentSizes;
    
}

//2:遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）

+( CGFloat ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    
    return folderSize/( 1000.0 * 1000.0 );
    
}

//1:计算 单个文件的大小

+ ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    
    return 0 ;
    
}

+(CGFloat)dbSize{
    long long folderSize = [FileUtil fileSizeAtPath :[LZFMDatabase getDbPath:@""]];
//    long long errorSize = [FileUtil fileSizeAtPath :[LZFMDatabase getDbPath:LeadingCloudError_Type]];
//    folderSize = folderSize + errorSize;
    
    CGFloat dbSizes=folderSize/( 1000.0 * 1000.0 );
    NSLog(@"size:%f",dbSizes);
    return dbSizes;
}

// 清理缓存
+ (void)clearFile
{
    //获取存放头像以及其他文件根目录绝对路径
    NSArray * commonIconImages = [[ NSFileManager defaultManager ] subpathsAtPath :[FilePathUtil getCommonIconImageDicAbsolutePath]];
    for ( NSString * img in commonIconImages) {
        //        if([img isKindOfClass:[NSMutableString class]]){
        NSError * error = nil ;
        NSString * path = [[FilePathUtil getCommonIconImageDicAbsolutePath] stringByAppendingPathComponent :img];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
    }
    SDWebImageManager *sharedSmallManager = [SDWebImageManager sharedManager:[FilePathUtil getFaceIconImageSmallDicAbsolutePath]];
    [sharedSmallManager.imageCache clearMemory];
    SDWebImageManager *sharedManager = [SDWebImageManager sharedManager:[FilePathUtil getFaceIconImageDicAbsolutePath]];
    [sharedManager.imageCache clearMemory];
//    __block MoreSettingViewController *service = self;
//    EVENT_PUBLISH_WITHDATA(service, EventBus_User_Account_ChangeFace, @"all");
    
    //获取聊天界面，发送图片的绝对路径
    NSArray * chatSendImgFiles = [[ NSFileManager defaultManager ] subpathsAtPath :[FilePathUtil getChatSendImageDicAbsolutePath]];
    for ( NSString * img in chatSendImgFiles) {
        //        if([img isKindOfClass:[NSMutableString class]]){
        NSError * error = nil ;
        NSString * path = [[FilePathUtil getChatSendImageDicAbsolutePath] stringByAppendingPathComponent :img];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            //            }
        }
    }
    SDWebImageManager *chatFileManager = [SDWebImageManager sharedManager:[FilePathUtil getChatSendImageDicAbsolutePath]];
    [chatFileManager.imageCache clearMemory];
    SDWebImageManager *chatSmallFileManager = [SDWebImageManager sharedManager:[FilePathUtil getChatSendImageSmallDicAbsolutePath]];
    [chatSmallFileManager.imageCache clearMemory];
    //获取聊天界面，下载文件的绝对路径
    NSArray * chatRecvImgFiles=[[ NSFileManager defaultManager ] subpathsAtPath :[FilePathUtil getChatRecvImageDicAbsolutePath]];
    for ( NSString * img in chatRecvImgFiles) {
        //        if([img isKindOfClass:[NSMutableString class]]){
        NSError * error = nil ;
        NSString * path = [[FilePathUtil getChatRecvImageDicAbsolutePath] stringByAppendingPathComponent :img];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
        //        }
    }
    SDWebImageManager *chatRecvManager = [SDWebImageManager sharedManager:[FilePathUtil getChatRecvImageDicAbsolutePath]];
    [chatRecvManager.imageCache clearMemory];
    SDWebImageManager *chatSmallRecvManager = [SDWebImageManager sharedManager:[FilePathUtil getChatRecvImageSmallDicAbsolutePath]];
    [chatSmallRecvManager.imageCache clearMemory];
    
    //获取云盘，文件的绝对路径
    NSArray * diskFileUpload=[[ NSFileManager defaultManager ] subpathsAtPath :[FilePathUtil getNetDiskFileDicAbsolutePath]];
    for ( NSString * img in diskFileUpload) {
        //        if([img isKindOfClass:[NSMutableString class]]){
        NSError * error = nil ;
        NSString * path = [[FilePathUtil getNetDiskFileDicAbsolutePath] stringByAppendingPathComponent :img];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
        //        }
    }
    SDWebImageManager *diskFileManager = [SDWebImageManager sharedManager:[FilePathUtil getNetDiskFileDicAbsolutePath]];
    [diskFileManager.imageCache clearMemory];
    SDWebImageManager *diskSmallFileManager = [SDWebImageManager sharedManager:[FilePathUtil getNetDiskFileSmallDicAbsolutePath]];
    [diskSmallFileManager.imageCache clearMemory];
    
    //获取动态图片的绝对路径
    NSArray * postFileDownload=[[ NSFileManager defaultManager ] subpathsAtPath :[FilePathUtil getPostFileDownloadDicAbsolutePath]];
    for ( NSString * img in postFileDownload) {
        //        if([img isKindOfClass:[NSMutableString class]]){
        NSError * error = nil ;
        NSString * path = [[FilePathUtil getPostFileDownloadDicAbsolutePath] stringByAppendingPathComponent :img];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
        //        }
    }
    SDWebImageManager *postFileManager = [SDWebImageManager sharedManager:[FilePathUtil getPostFileDownloadDicAbsolutePath]];
    [postFileManager.imageCache clearMemory];
    SDWebImageManager *postSmallFileManager = [SDWebImageManager sharedManager:[FilePathUtil getPostFileSmallDownloadDicAbsolutePath]];
    [postSmallFileManager.imageCache clearMemory];
    
    //获取收藏文件绝对路径
    NSArray * favoritesImages=[[ NSFileManager defaultManager ] subpathsAtPath :[FilePathUtil getFavoritesImageDicAbsolutePath]];
    for ( NSString * img in favoritesImages) {
        //        if([img isKindOfClass:[NSMutableString class]]){
        NSError * error = nil ;
        NSString * path = [[FilePathUtil getFavoritesImageDicAbsolutePath] stringByAppendingPathComponent :img];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
        //        }
    }
    SDWebImageManager *favoriteFileManager = [SDWebImageManager sharedManager:[FilePathUtil getFavoritesImageDicAbsolutePath]];
    [favoriteFileManager.imageCache clearMemory];
    //获取音频文件绝对路径
    NSArray * audioImages=[[ NSFileManager defaultManager ] subpathsAtPath :[FilePathUtil getAudioDicAbsolutePath]];
    for ( NSString * img in audioImages) {
        //        if([img isKindOfClass:[NSMutableString class]]){
        NSError * error = nil ;
        NSString * path = [[FilePathUtil getAudioDicAbsolutePath] stringByAppendingPathComponent :img];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
        //        }
    }
    //获取缩略图，缩略图的绝对路径
    NSArray * smallPicImages=[[ NSFileManager defaultManager ] subpathsAtPath :[FilePathUtil getSmallPicDicAbsolutePath]];
    for ( NSString * img in smallPicImages) {
        NSError * error = nil ;
        NSString * path = [[FilePathUtil getSmallPicDicAbsolutePath] stringByAppendingPathComponent :img];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
    }
    SDWebImageManager *smallPicManager = [SDWebImageManager sharedManager:[FilePathUtil getSmallPicDicAbsolutePath]];
    [smallPicManager.imageCache clearMemory];
    //获取消息模板，缩略图的绝对路径
    NSArray * msgTemplateImg=[[ NSFileManager defaultManager ] subpathsAtPath :[FilePathUtil getMsgTemplateImageDicRelatePath]];
    for ( NSString * img in msgTemplateImg) {
        NSError * error = nil ;
        NSString * path = [[FilePathUtil getMsgTemplateImageDicRelatePath] stringByAppendingPathComponent :img];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
    }
    SDWebImageManager *msgTemplateManager = [SDWebImageManager sharedManager:[FilePathUtil getMsgTemplateImageDicRelatePath]];
    [msgTemplateManager.imageCache clearMemory];
//    [[ImChatLogDAL shareInstance] deleteImChatLog];
//    [[ImRecentDAL shareInstance] updateSynckToNil];
//    
//    [self.appDelegate.lzSingleInstance.chatDialogDictionary removeAllObjects];
//    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSMutableDictionary dictionary] forKey:@"GIFImage"];
}



@end
