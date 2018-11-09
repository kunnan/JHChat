//
//  CoTransactionTypeModel.h
//  LeadingCloud
//
//  Created by wang on 16/10/28.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-10-28
 Version: 1.0
 Description: 事务类型列表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"
#import "CommonTemplateModel.h"

@interface CoTransactionTypeModel : NSObject

/*任务类型id*/
@property (nonatomic,strong)NSString *ttid;
/*事物类型名称*/
@property (nonatomic,strong)NSString *name;
/*描述*/
@property (nonatomic,strong)NSString *descript;
/*办理模板 会根据客户端类型自动返回相应的处理模板*/
@property (nonatomic,strong)NSString *handler;
/*应用id*/
@property (nonatomic,strong)NSString *appid;
/*工具id*/
@property (nonatomic,strong)NSString *toolid;
/*是否显示工具(默认为1)*/
@property (nonatomic,assign)NSInteger isshowcommontool;


/* iOS模板配置信息 */
@property(nonatomic,strong) CommonTemplateModel *templateModel;
@end
