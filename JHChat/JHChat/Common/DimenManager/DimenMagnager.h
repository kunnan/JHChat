//
//  DimenMagnager.h
//  LeadingCloud
//
//  Created by wchMac on 15/11/18.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wch
 Date：   2015-11-18
 Version: 1.0
 Description: 尺寸管理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface DimenMagnager : NSObject

/*
 * 获取指定对象的大小
 * @para key:      指定Key的名称
 * @para viewName: ViewControl或View的名称，需要在应用中唯一
 */
+(NSNumber *)dimenForKey:(NSString *)key inView:(NSString *)viewName;

/*
 * 获取RootDimen管理的所有Dimens文件
 * { LoginDimen:[LoginViewController,RegisterViewController],BaseDimen:.... }
 */
+(NSMutableDictionary *)getRootDimenInfo;

@end
