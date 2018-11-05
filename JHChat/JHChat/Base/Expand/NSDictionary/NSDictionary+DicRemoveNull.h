//
//  NSDictionary+DicRemoveNull.h
//  LeadingCloud
//
//  Created by gjh on 16/4/20.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  gjh
 Date：   2016-04-20
 Version: 1.0
 Description: 去掉json返回字典中的<null>值
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface NSDictionary (DicRemoveNull)

+ (id) removeJsonNullFromDic:(id)obj;

@end
