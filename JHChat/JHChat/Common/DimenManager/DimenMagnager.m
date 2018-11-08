//
//  DimenMagnager.m
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

#import "DimenMagnager.h"

/* RootDimen文件中内容静态化 */
static NSMutableDictionary *staticRootDimenInfo = nil;
/* 所有Dimens文件中指定大小静态化 
 如:{LoginDimen:{LoginViewController:{lblLoginNameHeight:28,lblLoginNameWidth:30,...}...}, MainDimen{}... }
 */
static NSMutableDictionary *staticDimensInfo = nil;

@implementation DimenMagnager

/*
 * 获取指定对象的大小
 * @para key:      指定Key的名称
 * @para viewName: ViewControl或View的名称，需要在应用中唯一
 */
+(NSNumber *)dimenForKey:(NSString *)key inView:(NSString *)viewName{
    NSNumber *number = [[NSNumber alloc] init];

    /* 分类中的所有ViewControl */
    NSMutableDictionary *targetDimenAllViewControllers = nil;
    
    //=============获取targetDimenViewControllers=================
    
    /* 获取RootDimen管理的所有Dimens文件,Key值为LoginDimen等文件名称 */
    NSMutableDictionary *rootDimenDictionary = [DimenMagnager getRootDimenInfo];
    for(id key in [rootDimenDictionary allKeys]){
        NSArray *array = [rootDimenDictionary objectForKey:key];
        
        /* 匹配出对于的Dimen文件名称 */
        if([array containsObject:viewName]){
            if(staticDimensInfo == nil){
                staticDimensInfo = [[NSMutableDictionary alloc] init];
            }
            
            /* 判断staticDimensInfo中是否已经含有了Dimen文件中的内容 */
            if([[staticDimensInfo allKeys] containsObject:key]){
                /* 已含有 */
                targetDimenAllViewControllers = [staticDimensInfo objectForKey:key];
            } else {
                /* 不含有，从文件中读取，并存入staticDimensInfo中 */
                NSString *plistPath = [[NSBundle mainBundle] pathForResource:key ofType:@"plist"];
                NSMutableDictionary *targetDimenFile = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
                targetDimenAllViewControllers = [targetDimenFile objectForKey:@"Default"];

                [staticDimensInfo setValue:targetDimenAllViewControllers forKey:key];
            }
            
        }
    }
    
    //========================================================
    
    /* 根据指定viewName和key获取对应的值 */
    if(targetDimenAllViewControllers!=nil){
        NSMutableDictionary *targetViewControlDimens = [targetDimenAllViewControllers objectForKey:viewName];
        if(targetViewControlDimens!=nil){
            number = [targetViewControlDimens objectForKey:key];
        }
    }
    
    return number;
}

/*
 * 获取RootDimen管理的所有Dimens文件
 * { LoginDimen:[LoginViewController,RegisterViewController],BaseDimen:.... }
 */
+(NSMutableDictionary *)getRootDimenInfo{
    if(staticRootDimenInfo == nil){
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"RootDimen" ofType:@"plist"];
        staticRootDimenInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }
    return staticRootDimenInfo;
}

@end
