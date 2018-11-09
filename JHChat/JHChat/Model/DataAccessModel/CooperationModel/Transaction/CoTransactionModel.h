//
//  CoTransactionModel.h
//  LeadingCloud
//
//  Created by wang on 16/10/17.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-10-17
 Version: 1.0
 Description: 事务列表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface CoTransactionModel : NSObject
/*主键id*/
@property (nonatomic,strong)NSString *tiid;
/*业务id*/
@property (nonatomic,strong)NSString *businessid;
/*名称*/
@property (nonatomic,strong)NSString *name;
/*接收时间*/
@property (nonatomic,strong)NSString *receivedate;
/*完成时间*/
@property (nonatomic,strong)NSString *finishdate;
/*办理人*/
@property (nonatomic,strong)NSString *transactor;
/*办理人头像*/
@property (nonatomic,strong)NSString *transactorfaceid;
/*状态 0待办 1在办 2办结*/
@property (nonatomic,assign)NSInteger status;
/*所属事务id*/
@property (nonatomic,strong)NSString *tid;
/*应用id*/
@property (nonatomic,strong)NSString *appid;
/*应用名称*/
@property (nonatomic,strong)NSString *appName;
/*应用颜色*/
@property (nonatomic,strong)NSString *appcolor;

@property (nonatomic,strong)NSString *appcode;

/*业务id*/
@property (nonatomic,strong)NSString *bid;
/*业务名称*/
@property (nonatomic,strong)NSString *bname;

/*信息ID*/
@property (nonatomic,strong)NSString *infoid;
/*来源类型 0:个人 1:岗位*/
@property (nonatomic,strong)NSString *fromtype;
/*来源*/
@property (nonatomic,strong)NSString *fromvalue;
/*所属企业id*/
@property (nonatomic,strong)NSString *eid;
/*事项描述*/
@property (nonatomic,strong)NSString *descript;
/*事务类型ID*/
@property (nonatomic,strong)NSString *ttid;
/*事务类型名称*/
@property (nonatomic,strong)NSString *ttname;
/*提交人*/
@property (nonatomic,strong)NSString *submiter;
/*头像ID*/
@property (nonatomic,strong)NSString *submiterfaceid;
/*是否显示,当一个事物中有多个重复办理人员的事物项时,只显示一个*/
@property (nonatomic,assign)NSInteger isshow;

@property (nonatomic,strong)NSString *paramsdata;
/* 扩展数据*/
@property (nonatomic,strong)NSString *dataexpend;

/* 任务类型状态id*/
@property (nonatomic,strong)NSString *tsid;

/* 任务类型状态名称*/
@property (nonatomic,strong)NSString *tsname;


@end
