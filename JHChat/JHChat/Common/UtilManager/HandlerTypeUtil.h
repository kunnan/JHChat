//
//  HandlerTypeUtil.h
//  LeadingCloud
//
//  Created by gjh on 16/5/10.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  gjh
 Date：   2016-05-10
 Version: 1.0
 Description: 从handlertype得到一二级的key工具类
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import <Foundation/Foundation.h>

@interface HandlerTypeUtil : NSObject

@property(nonatomic,strong) NSMutableDictionary *handlerTypeDic;

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(HandlerTypeUtil *)shareInstance;

/**
 *  初始化HandlerType数据
 */
-(void)initHandlerTypeData;

/**
 *  获取第一级名称
 *
 *  @param handlerType 处理类型
 *
 *  @return 第一级名称
 */
-(NSString *)getMainModel:(NSString *) handlerType;

/**
 *  获取第二级名称
 *
 *  @param handlerType 处理类型
 *
 *  @return 第二级名称
 */
-(NSString *)getSecondModel:(NSString *) handlerType;

@end
