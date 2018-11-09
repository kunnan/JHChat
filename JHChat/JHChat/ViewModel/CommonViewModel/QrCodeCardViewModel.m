//
//  QrCodeCardViewModel.m
//  LeadingCloud
//
//  Created by dfl on 16/4/21.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-04-21
 Version: 1.0
 Description: 通用二维码名片处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "QrCodeCardViewModel.h"
#import "ModuleServerUtil.h"
#import "AppDelegate.h"
#import "AppDateUtil.h"

@implementation QrCodeCardViewModel


/**
 *  获取二维码的Url地址
 *
 *  @param action 类型
 *  @param validID   所属ID
 *
 *  @return 地址
 */
+(NSString *)GetQrCodeCardAction:(NSString *)action validID:(NSString *)validid{

    NSString *server = [ModuleServerUtil GetH5ServerWithModule:Modules_H5_Default];
    NSString *iconUrl = [NSString stringWithFormat:@"%@/T/%@/%@",server,action, validid];
    
    return iconUrl;
}

/**
 *  获取带有时间戳二维码的Url地址
 *
 *  @param action 类型
 *  @param validID   所属ID
 *  @param timestamp   时间戳
 *
 *  @return 地址
 */
+(NSString *)GetQrCodeCardAction:(NSString *)action validID:(NSString *)validid timesTamp:(NSString *)timestamp{
    NSString *server = [ModuleServerUtil GetH5ServerWithModule:Modules_H5_Default];
    NSString *iconUrl = [NSString stringWithFormat:@"%@/T/%@/%@/%@",server,action, validid,timestamp];
    
    return iconUrl;
}

@end
