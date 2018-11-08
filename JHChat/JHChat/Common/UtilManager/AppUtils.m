//
//  AppUtils.m
//  LeadingCloud
//
//  Created by wchMac on 16/1/18.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "AppUtils.h"
#import "OrgEnterPriseDAL.h"
#import "OrgEnterPriseModel.h"
#import "NSString+IsNullOrEmpty.h"
#import "GalleryImageViewModel.h"

#import "UIImageView+WebCache.h"
#import "UIImageView+Icon.h"
#import "AppDateUtil.h"
#import "AppDelegate.h"
#import "NSString+Replace.h"
#import "LZRSA.h"
#import "ErrorDAL.h"
#import "DDRSAWrapper.h"
#import <WebKit/WebKit.h>
//@import Darwin.sys.mount;

@implementation AppUtils

/**
 *  获取当前用户ID
 *
 *  @return uid
 */
+(NSString *)GetCurrentUserID{
    return [[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"uid"];
}
/**
 *  获取当前用户名
 *
 *  @return uid
 */
+(NSString *)GetCurrentUserName{
    return [[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"username"];
}
/**
 *  获取当前企业ID
 *
 *  @return uid
 */
+(NSString *)GetCurrentOrgID{
    return [[[LZUserDataManager readCurrentUserInfo] lzNSMutableDictionaryForKey:@"notificaton"] lzNSStringForKey:@"selectoid"];
}

/**
 *  获取当前组织model
 *
 *  @return 当前组织model
 */
+(OrgEnterPriseModel*)GetCurrentOrgEnterPrise {
    
    NSString *orgid=[[[LZUserDataManager readCurrentUserInfo] lzNSMutableDictionaryForKey:@"notificaton"] lzNSStringForKey:@"selectoid"];
    
    OrgEnterPriseModel *orgModel =[[OrgEnterPriseDAL shareInstance]getEnterpriseByEId:orgid];
    
    return orgModel;
}

/**
 *  获取当前人在当前企业下的名称
 *
 *  @return 在当前企业下的名称
 */
+(NSString *)GetCurrentOrgUsername {
    OrgEnterPriseModel *orgModel = [AppUtils GetCurrentOrgEnterPrise];
    return [NSString isNullOrEmpty:orgModel.username] ? [[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"username"] : orgModel.username;
}

/**
 *  获取当前身份类型
 *
 *  @return 当前身份
 */
+(NSString *)GetCurrentIdentityType{
    NSNumber *identitytypeNum = [[[LZUserDataManager readCurrentUserInfo] lzNSMutableDictionaryForKey:@"notificaton"] objectForKey:@"identitytype"];
    return [NSString stringWithFormat:@"%@",identitytypeNum];
}

/**
 *  检测是否需要新实例
 *
 *  @param tag 之前实例的Tag值
 *
 *  @return 是否需要
 */
+(BOOL)CheckIsRestInstance:(NSString *)useridTag guidTag:(NSString *)guidTag{
    BOOL result = ![useridTag isEqualToString:[[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"uid"]];
    if(!result){
        result = ![guidTag isEqualToString:[LZUserDataManager getDBGuidTag]];
    }
    
    return result;
}

/**
 *  根据名称检测是否为图片
 *
 *  @param name 文件名称或扩展名
 *
 *  @return 是否是图片
 */
+(BOOL)CheckIsImageWithName:(NSString *)name{
    
    
    NSString *ext = @"";
    if([name rangeOfString:@"."].location!=NSNotFound){
        ext = [[name substringFromIndex:[name rangeOfString:@"." options:NSBackwardsSearch].location+1] lowercaseString];
    }
    else {
        ext = [name lowercaseString];
    }
    
    if([ext isEqualToString:@"jpg"] || [ext isEqualToString:@"jpeg"] || [ext isEqualToString:@"png"] || [ext isEqualToString:@"gif"] || [ext isEqualToString:@"bmp"] || [ext isEqualToString:@"tif"] || [ext isEqualToString:@"tiff"] || [ext isEqualToString:@"webp"]){
        return YES;
    }
    
    return NO;
}


/**
 *  根据图片名称检查gif 是否大于5M  没调用，没实现
 *
 *  @param name 文件名称或扩展名
 *
 *  @return 是否是图片
 */
+(BOOL)CheckIsGifImageSizeWithName:(NSString *)name Size:(CGFloat)size{
    
    
    NSString *ext = @"";
    if([name rangeOfString:@"."].location!=NSNotFound){
        ext = [[name substringFromIndex:[name rangeOfString:@"." options:NSBackwardsSearch].location+1] lowercaseString];
    }
    else {
        ext = [name lowercaseString];
    }
    
    if([ext isEqualToString:@"jpg"] || [ext isEqualToString:@"jpeg"] || [ext isEqualToString:@"png"] || [ext isEqualToString:@"gif"] || [ext isEqualToString:@"bmp"] || [ext isEqualToString:@"tif"] || [ext isEqualToString:@"tiff"]){
        return YES;
    }
    
    return NO;
}

/**
 *  根据文件类型获取文件图片
 *
 *  @param name 文件名或扩展名
 *
 *  @return 图片名称
 */
+(NSString *)GetImageNameWithName:(NSString *)name{
    NSString *ext = @"";
    if([name rangeOfString:@"."].location!=NSNotFound){
        ext = [[name substringFromIndex:[name rangeOfString:@"." options:NSBackwardsSearch].location+1] lowercaseString];
    }
    else {
        ext = [name lowercaseString];
    }
    
    if([ext isEqualToString:@"avi"]){
        return @"file_avi";
    }
    else if([ext isEqualToString:@"doc"]){
        return @"file_word";
    }
    else if([ext isEqualToString:@"docx"]){
        return @"file_word";
    }
    else if([ext isEqualToString:@"dwf"]){
        return @"file_dwg";
    }
    else if([ext isEqualToString:@"dwg"]){
        return @"file_dwg";
    }
    else if([ext isEqualToString:@"exe"]){
        return @"file_exe";
    }
    else if([ext isEqualToString:@"gif"]){
        return @"file_jpg";
    }
    else if([ext isEqualToString:@"htm"]){
        return @"file_htm";
    }
    else if([ext isEqualToString:@"jpg"]){
        return @"file_jpg";
    }
    else if ([ext isEqualToString:@"jpeg"]) {
        return @"file_jpg";
    }
    else if ([ext isEqualToString:@"png"]) {
        return @"file_jpg";
    }
    else if([ext isEqualToString:@"mov"]){
        return @"file_avi";
    }
    else if([ext isEqualToString:@"mp4"]){
        return @"file_avi";
    }
    else if([ext isEqualToString:@"mp3"]){
        return @"file_avi";
    }
    else if([ext isEqualToString:@"pdf"]){
        return @"file_pdf";
    }
    else if([ext isEqualToString:@"ppt"]){
        return @"file_ppt";
    }
    else if([ext isEqualToString:@"pptx"]){
        return @"file_ppt";
    }
    else if([ext isEqualToString:@"rar"]){
        return @"file_rar";
    }
    else if([ext isEqualToString:@"txt"]){
        return @"file_txt";
    }
    else if([ext isEqualToString:@"xls"]){
        return @"file_excel";
    }
    else if([ext isEqualToString:@"xlsx"]){
        return @"file_excel";
    }
    else if([ext isEqualToString:@"xlt"]){
        return @"file_excel";
    }
    else if([ext isEqualToString:@"xltx"]){
        return @"file_excel";
    }
    else if([ext isEqualToString:@"zip"]){
        return @"file_rar";
    }
    else if([ext isEqualToString:@"bag"]){
        return @"file_bag";
    }
    else if ([ext isEqualToString:@"folder"]) {
        return @"list_folder";
    }
    else if ([ext isEqualToString:@"link"]) {
        return @"dropdown_link";
    }
    else if ([ext isEqualToString:@"mainappdef"]) {
        return @"main_app_default";
    }
    else if ([ext isEqualToString:@"mainappsel"]) {
        return @"main_app_select";
    }
    else if ([ext isEqualToString:@"sharefolder"]) {
        return @"dropdown_share_folder";
    }
    else if ([ext isEqualToString:@"addshare"]) {
        return @"dropdown_quote_folder";
    }
    return @"file_file";
}
/**
 *  根据文件id获取文件图片(小图)main_app_default main_app_select
 *
 *  @param name 文件id
 *
 *  @return 图片
 */
+(UIImage *)GetImageWithID:(NSString *)fileId exptype:(NSString *)exptype GetNewImage:(GetNextImage)getNewImage{

//    NSString *exp = @"";
//    if([exptype rangeOfString:@"."].location!=NSNotFound){
//        exp = [[exptype substringFromIndex:[exptype rangeOfString:@"." options:NSBackwardsSearch].location+1] lowercaseString];
//    }
//    else {
//        exp = [exptype lowercaseString];
//    }
    
    // 得到文件路径
    NSString *facePath = [FilePathUtil getSmallPicDicAbsolutePath];
    NSString *toFacePath = [NSString stringWithFormat:@"%@%@.jpg",facePath,fileId];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:toFacePath]) {
        UIImage *image2 = [UIImage imageWithContentsOfFile:toFacePath];
        if(image2!=nil){
            getNewImage(image2);
        } else {
            getNewImage([UIImage imageNamed:[AppUtils GetImageNameWithName:exptype]]);
        }
    }
    else {
        /* 先返回默认图片 */
        getNewImage([UIImage imageNamed:[AppUtils GetImageNameWithName:exptype]]);
        
        if ([NSString isNullOrEmpty:fileId]) {
            return nil;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             NSString *iconUrl = [GalleryImageViewModel GetGalleryIconImageUrlFileId:fileId size:@"128X128"];
             dispatch_async(dispatch_get_main_queue(), ^{
                SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
                [downloader downloadImageWithURL:[NSURL URLWithString:iconUrl]
                                         options:0
                                        progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                            // progression tracking code
                                            
                                            
                                        }
                                       completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                           
                                           
                                           if (finished) {
                                               
                                               NSString *faceImgName = [NSString stringWithFormat:@"%@.jpg",fileId];
                                               
                                               /* 保存图片 */
                                               NSString *pathName = [NSString stringWithFormat:@"%@%@",[FilePathUtil getSmallPicDicAbsolutePath],faceImgName];
                                               [[NSFileManager defaultManager] createFileAtPath:pathName contents:data attributes:nil];
                                               
                                               // 得到文件路径
                                               NSString *facePath = [FilePathUtil getSmallPicDicAbsolutePath];
                                               NSString *toFacePath = [NSString stringWithFormat:@"%@%@.jpg",facePath,fileId];
                                               
                                               UIImage *image2 = [UIImage imageWithContentsOfFile:toFacePath];
                                               if(image2!=nil ){
                                                   getNewImage(image2);
                                               }
                                           }
                                       }];
             });
        });
    }
    
       return nil;
}

/**
 *  根据文件id 下载图片 只下不存
 *
 *  @param name 文件id
 *
 *  @return 图片
 */
+ (void)GetImageWithFileID:(NSString *)fileId Size:(NSString*)size GetNewImage:(GetDataImage)getNewImage{
	
		NSString *iconUrl = [GalleryImageViewModel GetGalleryOriImageUrlFileId:fileId];
		SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
		[downloader downloadImageWithURL:[NSURL URLWithString:iconUrl]
								 options:0
								progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
									// progression tracking code
									
									
								}
							   completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
								   
								   
								   if (finished) {
									   
									   getNewImage(image,data);
								   }
							   }];
}
/**
 *  获取当前APP版本号
 *
 *  @return 版本
 */
+(NSString *)getNowAppVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary lzNSStringForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

//获取long类型的版本号
+(long)getLongTypeVersion:(NSString *)version{
    
    NSArray *verArr = [version componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    NSMutableString *longString = [NSMutableString stringWithString:@"1"];
    for(int i=0;i<verArr.count;i++){
        if(i==0){
            longString = [NSMutableString stringWithString:verArr[i]];
        } else {
            NSString *verValue = verArr[i];
            int verInt = 1000 + verValue.intValue;
            NSString *newVerValue = [NSString stringWithFormat:@"%d",verInt];
            [longString appendString:[newVerValue substringFromIndex:1]];
//            longString = [longString stringByAppendingString:[newVerValue substringFromIndex:1]];       //[[newVerValue substringFromIndex:1] stringByAppendingString:longString];
        }
    }
    return longString.longLongValue;
}

/**
 *  获取首字母
 */
+(NSString *)getRightFirstChar:(NSString *)firseChar{
    NSString *all = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    if([NSString isNullOrEmpty:firseChar] || [all rangeOfString:firseChar].location == NSNotFound ){
        return @"#";
    }
    return firseChar;
}

/**
 *  获取当前设备型号（未转化）
 *
 */
+ (NSString *)getPlatform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

/**
 *  获取设备的版本
 */
//+ (NSString *)getDeveiceModel{
//    size_t size;
//    sysctlbyname("hw.machine",NULL, &size, NULL,0);
//    char *machine = malloc(size);
//    sysctlbyname("hw.machine", machine, &size,NULL, 0);
//    NSString*platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
//    
//    if ([platform isEqualToString:@"iPhone1,1"]) {
//        platform = @"iPhone";
//    } else if ([platform isEqualToString:@"iPhone1,2"]) {
//        platform = @"iPhone 3G";
//    } else if ([platform isEqualToString:@"iPhone2,1"]) {
//        platform = @"iPhone 3GS";
//    } else if ([platform isEqualToString:@"iPhone3,1"]||[platform isEqualToString:@"iPhone3,2"]||[platform isEqualToString:@"iPhone3,3"]) {
//        platform = @"iPhone 4";
//    } else if ([platform isEqualToString:@"iPhone4,1"]) {
//        platform = @"iPhone 4S";
//    } else if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"]) {
//        platform = @"iPhone 5";
//    }else if ([platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"]) {
//        platform = @"iPhone 5C";
//    }else if ([platform isEqualToString:@"iPhone6,2"]||[platform isEqualToString:@"iPhone6,1"]) {
//        platform = @"iPhone 5S";
//    } else if ([platform isEqualToString:@"iPhone7,1"]) {
//        platform = @"iPhone 6 Plus";
//    } else if ([platform isEqualToString:@"iPhone7,2"]) {
//        platform = @"iPhone 6";
//    } else if ([platform isEqualToString:@"iPhone8,1"]) {
//        platform = @"iPhone 6S";
//    } else if ([platform isEqualToString:@"iPhone8,2"]) {
//        platform = @"iPhone 6S Plus";
//    } else if ([platform isEqualToString:@"iPhone8,4"]) {
//        platform = @"iPhone SE";
//    }
//    
//    else if ([platform isEqualToString:@"iPod7,1"]) {
//        platform = @"iPod Touch 6";
//    }else if ([platform isEqualToString:@"iPod5,1"]) {
//        platform = @"iPod Touch 5";
//    }else if ([platform isEqualToString:@"iPod4,1"]) {
//        platform = @"iPod Touch 4";
//    }else if ([platform isEqualToString:@"iPod3,1"]) {
//        platform = @"iPod Touch 3";
//    }else if ([platform isEqualToString:@"iPod2,1"]) {
//        platform = @"iPod Touch 2";
//    }else if ([platform isEqualToString:@"iPod1,1"]) {
//        platform = @"iPod Touch 1";
//    }
//    
//    else if ([platform isEqualToString:@"iPad2,2"]||[platform isEqualToString:@"iPad2,1"]||[platform isEqualToString:@"iPad2,3"]||[platform isEqualToString:@"iPad2,4"]) {
//        platform = @"iPad 2";
//    } else if ([platform isEqualToString:@"iPad1,1"]) {
//        platform = @"iPad 1";
//    } else if ([platform isEqualToString:@"iPad3,1"]||[platform isEqualToString:@"iPad3,2"]||[platform isEqualToString:@"iPad3,3"]) {
//        platform = @"iPad 3";
//    } else if ([platform isEqualToString:@"iPad3,4"]||[platform isEqualToString:@"iPad3,5"]||[platform isEqualToString:@"iPad3,6"]) {
//        platform = @"iPad 4";
//    } else if ([platform isEqualToString:@"iPad4,1"]||[platform isEqualToString:@"iPad4,2"]||[platform isEqualToString:@"iPad4,3"]) {
//        platform = @"iPad Air";
//    } else if ([platform isEqualToString:@"iPad5,3"]||[platform isEqualToString:@"iPad5,4"]) {
//        platform = @"iPad Air2";
//    } else if ([platform isEqualToString:@"iPad2,5"]||[platform isEqualToString:@"iPad2,6"]||[platform isEqualToString:@"iPad2,7"]) {
//        platform = @"iPadMini1";
//    } else if ([platform isEqualToString:@"iPad4,4"]||[platform isEqualToString:@"iPad4,5"]||[platform isEqualToString:@"iPad4,6"]) {
//        platform = @"iPadMini2";
//    } else if ([platform isEqualToString:@"iPad4,7"]||[platform isEqualToString:@"iPad4,8"]||[platform isEqualToString:@"iPad4,9"]) {
//        platform = @"iPadMini3";
//    } else if ([platform isEqualToString:@"iPad5,1"]||[platform isEqualToString:@"iPad5,2"]) {
//        platform = @"iPadMini4";
//    } else if ([platform isEqualToString:@"iPad6,7"]||[platform isEqualToString:@"iPad6,8"]) {
//        platform = @"iPad Pro";
//    } else if ([platform isEqualToString:@"iPad6,3"]||[platform isEqualToString:@"iPad6,4"]) {
//        platform = @"iPad Pro(9.7)";
//    }
//    
//    else if ([platform isEqualToString:@"i386"]||[platform isEqualToString:@"x86_64"]) {
//        platform = @"iPhone Simulator";
//    }
//    return platform;
//}

/**
 获取设备剩余容量

 @return 字节数
 */
+ (long long) freeDiskSpaceInBytes{
    
//    float totalSpace;
    float freeSpace;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary) {
//        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
//        totalSpace = [fileSystemSizeInBytes floatValue]/1024.0f/1024.0f/1024.0f;
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        freeSpace = [freeFileSystemSizeInBytes floatValue]/1024.0f/1024.0f;
    } else {
//        totalSpace = 0;
        freeSpace = 0;
    }
    
    return freeSpace;
    
//    struct statfs buf;
//    long long freespace = -1;
//    if(statfs("/var", &buf) >= 0){
//        freespace = (long long)(buf.f_bsize * buf.f_bfree);
//    }
//    return freespace/1024/1024;
}

#pragma mark 汉字转拼音
/**
 汉字转拼音
 
 @return 拼音
 */
+ (NSString *)transform:(NSString *)chinese
{
    if ([chinese length]) {
        NSMutableString *pinyin = [chinese mutableCopy];
        CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
        NSLog(@"%@", pinyin);
        return [pinyin uppercaseString];

    }
    return nil;
}
#pragma mark 数组转字符串

/**
 数组转字符串

 @param array 数组

 @return 字符串
 */
+ (NSString*)arrayTransformString:(NSMutableArray*)array {
    if (array.count == 0) {
        return @"";
    }
//    if (array.count == 1) {
//        return array[0];
//    }
     return [array componentsJoinedByString:@","];
}
#pragma mark 字符串转数组

/**
 字符串转数组

 @param str 字符转

 @return 数组
 */
+ (NSMutableArray*)StringTransformArray:(NSString*)str {
    
    /* 字符串转数组 */
    return  [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@","]];
}
#pragma mark - 通过字符截取字符串

/**
 通过字符截取字符串

 @param str 需要截取的字符串
 @param sepByStr 通过哪个字符串截取
 @return 截取完的字符串数组
 */
+ (NSMutableArray*)StringTransformArray:(NSString *)str SeparatedByString:(NSString*)sepByStr {
    return  [NSMutableArray arrayWithArray:[str componentsSeparatedByString:sepByStr]];
}
#pragma 通过字符z从后往前截取字符串
+(NSString*)SubStringBackwardsSearchWithSubStr:(NSString*)str stringName:(NSString*)stringName{
    
    if ([stringName containsString:str]) {
        return  [stringName substringFromIndex:[stringName rangeOfString:str options:NSBackwardsSearch].location+1];
    }
    return nil;
    
}
#pragma mark - 获取文件拓展名
+ (NSString*)getExpType:(NSString*)stringName {
    if ([stringName containsString:@"."]) {
        return  [stringName substringFromIndex:[stringName rangeOfString:@"." options:NSBackwardsSearch].location+1];
    }
    return nil;
   
}
#pragma mark - 获取文件名
+ (NSString*)getFileName:(NSString*)stringName {
    if ([stringName containsString:@"/"]) {
        return  [stringName substringFromIndex:[stringName rangeOfString:@"/" options:NSBackwardsSearch].location+1];
    }
    return nil;
}
+ (NSString*)getFileNameRangePoint:(NSString*)stringName {
    if ([stringName containsString:@"."]) {
        return  [stringName substringToIndex:[stringName rangeOfString:@"." options:NSBackwardsSearch].location];
    }
    return stringName;
}
+ (NSString*)getStringRangePoint:(NSString*)stringName substring:(NSString*)substring{
    if ([stringName containsString:substring]) {
        return  [stringName substringFromIndex:[stringName rangeOfString:substring options:NSBackwardsSearch].location + 1];
    }
    return stringName;
}
#pragma mark - 返回非法字符
+(NSMutableArray*)isIncludIllegaCharaWithStr:(NSString*)fieldNewValue {
    NSString *illstr = IllegalChar;
   // NSCharacterSet *characterStr = [NSCharacterSet characterSetWithCharactersInString:@"\n\\{}[]()"];
    //NSRange range = [fieldNewValue rangeOfCharacterFromSet:characterStr];
    
    NSMutableArray *illStrArr = [[NSMutableArray alloc] init];
    for(int i =0; i < [illstr length]; i++)
    {
        NSString * temp = [illstr substringWithRange:NSMakeRange(i, 1)];
        for (int j = 0; j < [fieldNewValue length]; j++) {
            NSString *ill = [fieldNewValue substringWithRange:NSMakeRange(j, 1)];
            if ([temp isEqualToString:ill]) {
                [illStrArr addObject:temp];
            }
        }
    }
    NSMutableArray *newIllArr = [[NSMutableArray alloc] init];
    for (int i =0 ; i < illStrArr.count; i++) {
        if (![newIllArr containsObject:[illStrArr objectAtIndex:i]]){
            [newIllArr addObject:[illStrArr objectAtIndex:i]];
        }
    }
   // NSString *str = [self arrayTransformString:newIllArr];
    
    //NSString *trimStr = [str stringByTrimmingCharactersInSet:characterStr];
    return newIllArr;
//    
//    if (range.location<fieldNewValue.length) {
//        [self showWarningWithText:LZGDCommonLocailzableString(@"cooperation_have_illegality_word")];
//        return;
//    }
}
#pragma mark - 清缓存
+(void)clearCache {
    
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }

    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];

    NSString *libraryDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
                            objectForKey:@"CFBundleIdentifier"];
    NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
    NSString *webKitFolderInCaches = [NSString
                                      stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
    NSString *webKitFolderInCachesfs = [NSString
                                        stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
    NSError *error;
    /*  WebView Cache的存放路径 */
    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
    /*  WebView Cache的存放路径 */
    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
    NSString *cookiesFolderPath = [libraryDir stringByAppendingString:@"/Cookies"];
    [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&error];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
   // wkwebview 删除所有缓存和cookie的
    if (LZ_IS_IOS9) {
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        
        //// Date from
        
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        //// Execute
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
            
        }];
        
       
    }
}

/**
 判断是否为appstore版本
 */
+(BOOL)CheckIsAppStoreVersion{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    if([[identifier lowercaseString] isEqualToString:@"com.leading.leadingcloud.ee"])
    {
        return NO;
    }
    return YES;
}

/**
 获取高德地图使用的Key
 */
+(NSString *)GetGaoDeKey{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    if([[identifier lowercaseString] isEqualToString:@"com.leading.leadingcloud.ee"])
    {
        return APIKEY_EE;
    }
    return APIKEY_APPSTORE;
}

/**
 获取友盟使用的Key
 */
+(NSString *)GetUMengKey{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    if([[identifier lowercaseString] isEqualToString:@"com.leading.leadingcloud.ee"])
    {
        return UMENG_KEY_EE;
    }
    return UMENG_KEY_APPSTORE;
}

//URL UTF8处理
+ (NSURL *)urlToNsUrl:(NSString *)strUrl{
    NSURL *url = [NSURL URLWithString:strUrl];
    if(url == nil){
        url = [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    return url;
}

#pragma mark - 加密处理
//对内容进行RSA加密
+ (NSString *)encryWithModulus:(NSString *)modulus exponent:(NSString *)exponent content:(NSString *)password{
    NSString *result = @"";
    

    #ifdef DEBUG
    #else
//        //1. 使用LZRSA进行加密
//        LZRSA *rsa = [[LZRSA alloc] init];
//        result = [rsa encrypt:modulus exponent:exponent  content:password];
//        if(![NSString isNullOrEmpty:result]){
//            return result;
//        } else {
//            [[ErrorDAL shareInstance] addDataWithTitle:@"LZRSA加密出错" data:[NSString stringWithFormat:@"content:%@   \n modules:%@  \n exponent:%@ \n rsaPassword:%@",password,modulus,exponent,result] errortype:Error_Type_Seventeen];
//        }
    #endif
    
    //2. 使用DDRSA 方式一PublicKey 进行加密
    result = [DDRSAWrapper encryptWithPublicKey:modulus exponent:exponent content:password];
    if(![NSString isNullOrEmpty:result]){
        [[ErrorDAL shareInstance] addDataWithTitle:@"DDRSAWrapper加密结果" data:[NSString stringWithFormat:@"content:%@   \n modules:%@  \n exponent:%@ \n rsaPassword:%@",password,modulus,exponent,result] errortype:Error_Type_Seventeen];
        return result;
    } else {
        [[ErrorDAL shareInstance] addDataWithTitle:@"DDRSAWrapper加密出错" data:[NSString stringWithFormat:@"content:%@   \n modules:%@  \n exponent:%@ \n rsaPassword:%@",password,modulus,exponent,result] errortype:Error_Type_Seventeen];
    }
    
//    //3. 使用DDRSA 方式二PublicKeyRef 进行加密
//    result = [DDRSAWrapper encryptWithPublicKeyRef:modulus exponent:exponent content:password];
    return result;
}

#pragma mark - 替换Url中的参数
+(NSString *)replaceUrlParameter:(NSString *)url{
   NSMutableDictionary *currentDic = [LZUserDataManager readCurrentUserInfo];
   NSString *ssotokenid = [currentDic lzNSStringForKey:@"ssotokenid"];
   AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   
//   {@"AppClientType":@"iOS",
//      @"AppDeviceModel":[AppUtils getDeveiceModel],
//      @"AppID":@"LeadingCloud",
//      @"AppVersion":[AppUtils getNowAppVersion]};
   
   NSString *clientType = [[LZUtils GetDeveiceModel] stringByReplacingOccurrencesOfString:@" " withString:@""];
   
    NSString *loadUrl = [[[[[[[[[[url stringByReplacingIGNOREOccurrencesOfString:@"{ssotokenid}" withString:ssotokenid] stringByReplacingIGNOREOccurrencesOfString:@"{tokenid}" withString:appDelegate.lzservice.tokenId] stringByReplacingIGNOREOccurrencesOfString:@"{appdevicecode}" withString:@"iOS"] stringByReplacingIGNOREOccurrencesOfString:@"{appclienttype}" withString:@"iOS"] stringByReplacingIGNOREOccurrencesOfString:@"{appdevicetype}" withString:clientType] stringByReplacingIGNOREOccurrencesOfString:@"{appdevicemodel}" withString:clientType] stringByReplacingIGNOREOccurrencesOfString:@"{appid}" withString:@"LeadingCloud"] stringByReplacingIGNOREOccurrencesOfString:@"{appversion}" withString:[AppUtils getNowAppVersion]]    stringByReplacingIGNOREOccurrencesOfString:@"$ssotokenid$" withString:ssotokenid] stringByReplacingIGNOREOccurrencesOfString:@"$tokenid$" withString:appDelegate.lzservice.tokenId];
    
    loadUrl = [loadUrl stringByReplacingIGNOREOccurrencesOfString:@"{oauthcode}" withString:[LZUserDataManager readAESToken]];
   
   return loadUrl;
}

#pragma mark - 数据库旧表
+(void)creatPlistWithVersion:(NSInteger)checkVersion {
    
    NSString *path = [FilePathUtil getPersonalDicAbsolutePath];
    NSString *plistNewPath = [path stringByAppendingPathComponent:@"DBDALNewInfo.plist"];
    
    /* 解析plist文件，判断表名和字段名是否存在 */
    NSString *plistPath =  [[NSBundle mainBundle] pathForResource:@"DBDALInfo" ofType:@"plist"];
    NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
     NSMutableDictionary *newdic = [[NSMutableDictionary alloc] init];
    /* 得到所有的表名 */
    for (NSString *tableName in [mutableDic allKeys]) {
      
            /* 表创建成功，接着判断字段有没有创建成功 */
            NSMutableDictionary *obj = [mutableDic lzNSMutableDictionaryForKey:tableName];
            /* 得到表中所有字段名 */
            for (NSString *fieldName in [obj allKeys]) {
                
                NSString *descript = [obj lzNSStringForKey:fieldName];
                //if(![descript isEqualToString:@"1"]){
                    /* 判断是否不需要判断此版本(需要判断currentDbVersion之后的版本) */
                    NSInteger version = 0;
                    descript = [[descript stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
                    if([descript rangeOfString:@"version:"].location != NSNotFound
                       && [descript rangeOfString:@"author:"].location != NSNotFound){
                        NSUInteger start = [descript rangeOfString:@"version:"].location+8;
                        descript = [descript substringFromIndex:start];
                        NSUInteger end = [descript rangeOfString:@"author:"].location;
                        descript = [descript substringToIndex:end];
                        version = [LZFormat Safe2Int32:descript];
                    }
                    /* 如果旧版本大于所传版本 就把旧版本移到一个新的plist的文件里面 */
                    if([descript isEqualToString:@"1"] || version < checkVersion){
                        [obj removeObjectForKey:fieldName];
                        //[newdic setObject:obj forKey:tableName];
                    }
                    else {
                        [newdic setObject:obj forKey:tableName];
                    }
                
                    DDLogVerbose(@"需要判断，version:%ld---Table:%@字段:%@",version,tableName,fieldName);
                
                    /* 判断表中的所有字段是否都创建成功 */
                    if (![[[LZFMDatabase alloc] init] checkIsExistsFieldInTable:tableName fieldName:fieldName]) {
                        DDLogError(@"%@表中的%@字段没有创建成功！", tableName, fieldName);
                        //dbIsRight = NO;
                        break;
                    }
               // }
            }
     
       [newdic writeToFile:plistNewPath  atomically:YES];
    }
     NSLog(@" 移动过后的plist文件：%@", [[NSMutableDictionary alloc] initWithContentsOfFile:plistNewPath]);
}

#pragma mark - 判断是否为公有云
//是否是公有云
+(BOOL)checkIsPublicServer:(NSString *)module{
	
    if([module isEqualToString:@"service"]){
        if([self checkFunctionSetting:Function_Set_ServiceCircle]){
            return YES;
        }
    }
    if([module isEqualToString:@"chatvideo"]){
        if([self checkFunctionSetting:Function_Set_ChatVideo]){
            return YES;
        }
    }
    if([module isEqualToString:@"sethelp"]){
        return NO;
//        if([self checkFunctionSetting:Function_Set_InfoHelp]){
//            return YES;
//        }
    }
    if([module isEqualToString:@"setshare"]){
        if([self checkFunctionSetting:Function_Set_InfoShare]){
            return YES;
        }
    }
    if([module isEqualToString:@"documentcoop"]){
        if([self checkFunctionSetting:Function_Set_DocumentCoop]){
            return YES;
        }
    }
    if([module isEqualToString:@"projectbranch"]){
        if([self checkFunctionSetting:Function_Set_ProjectBranch]){
            return YES;
        }
        else{
            return NO;
        }
    }
    
    NSString *curApi = [LZUserDataManager readServer];
    
    if([curApi isEqualToString:[LZUserDataManager readPublicServer]]
       || [[curApi lowercaseString] rangeOfString:@"y.lizheng.com.cn"].location!=NSNotFound){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 功能设置开关
//打开或关闭某功能
+(void)setFunctionSetting:(NSString *)item{
    NSMutableDictionary *dic = [LZUserDataManager readFunctionSettingInfo];
    NSMutableDictionary *copyDic = [dic mutableCopy];
    NSString *itemValue = [copyDic lzNSStringForKey:item];
    if([NSString isNullOrEmpty:itemValue] || ![itemValue isEqualToString:@"1"]){
        [copyDic setValue:@"1" forKey:item];
    } else {
        [copyDic setValue:@"" forKey:item];
    }
    [LZUserDataManager saveFunctionSettingInfo:copyDic];
}
//判断某功能是否打开
+(BOOL)checkFunctionSetting:(NSString *)item{
    NSMutableDictionary *dic = [LZUserDataManager readFunctionSettingInfo];
    NSString *itemValue = [dic lzNSStringForKey:item];
    if([NSString isNullOrEmpty:itemValue] || ![itemValue isEqualToString:@"1"]){
        return NO;
    } else {
        return YES;
    }
}

//是否使用友盟跟踪日志
+(BOOL)isUseUmengTrack{
    return ![LZUserDataManager readIsGayScaleUser];
}

#pragma mark - 获取当前手机的唯一标识ID
+(NSString *)getPhoneUniqueID{
    NSString *phoneUniqueID = [LZUserDataManager readPhoneUniqueID];
    if([NSString isNullOrEmpty:phoneUniqueID]){
        NSDate *now = [[NSDate alloc] init];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddhhmmss"];
        NSString *nowDateStr = [dateFormatter stringFromDate:now];
        nowDateStr = [nowDateStr stringByReplacingOccurrencesOfString:@":" withString:@""];
        
        phoneUniqueID = [NSString stringWithFormat:@"%@_%@",[LZUtils CreateGUID],nowDateStr];
        [LZUserDataManager savePhoneUniqueID:phoneUniqueID];
    }
    return phoneUniqueID;
}

#pragma mark - 清空临时通知，更改值为0
+(void)setTempNotificationValue{
    NSMutableDictionary *syncDic = [LZUserDataManager readSynkInfo];
    NSMutableDictionary *syncDicCopy = [[NSMutableDictionary alloc] init];
    for (NSString *key in [syncDic allKeys]) {
        NSString *synkValue = [syncDic lzNSStringForKey:key];
        NSArray *synkArray = [synkValue componentsSeparatedByString:@"_"];
        NSMutableArray *synkMutArray = [NSMutableArray arrayWithArray:synkArray];
        if(synkMutArray.count>=2){
            [synkMutArray replaceObjectAtIndex:1 withObject:@"0"];
        }
        NSString *newSynk = [synkMutArray componentsJoinedByString:@"_"];
        [syncDicCopy setObject:newSynk forKey:key];
    }
    [LZUserDataManager saveSynkInfo:syncDicCopy];
}

@end
