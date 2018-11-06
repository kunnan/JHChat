//
//  ImageManager.h
//  LeadingCloud
//
//  Created by wchMac on 15/11/19.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-11-19
 Version: 1.0
 Description: 图片管理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageManager : NSObject

/*
 * 根据图片名称获取UIImage
 * @para imageName:  图片名称
 */
+(UIImage *)imageNamed:(NSString *)imageName;

/**
 将项目中某些图片的名称可以转成其他的名称
 
 @param imageName 他们的图片名称
 
 @return 项目中的名称
 */
+(NSString *)GetImageNameWithShowName:(NSString *)showName;

/**
 测试修改图片加载方式对内存的影响

 @param imageName 图片名称

 @return 图片文件
 */
+(UIImage *)LZGetImageByFileName:(NSString *)imageName;
@end
