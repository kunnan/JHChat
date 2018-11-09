//
//  PostModel.h
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-21
 Version: 1.0
 Description: 动态信息表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface PostModel : NSObject

/*****************第二版新增字段******************/
/*动态code*/
@property (nonatomic,strong)NSString *appcode;
/*代表哪个模块 动态用传Cooperation属性 */
@property (nonatomic,strong)NSString *relevanceappcode;
/**/
@property (nonatomic,strong)NSString *relevanceid;

/*判断动态类型*/
@property (nonatomic,strong)NSString *posttemplatetypes;
/*应用code*/
@property (nonatomic,strong)NSString *posttypecode;
/*应用id*/
@property (nonatomic,strong)NSString *appcodedataid;
/*收藏内容*/
@property (nonatomic,strong)NSString *favoritetitle;
/**/
@property (nonatomic,assign)BOOL isfiles;
/**/
@property (nonatomic,strong)NSString *posttemplateversion;
/**/
@property (nonatomic,assign)NSInteger posttemplatetype;
/***********************************************/


/* 内容 */
@property(nonatomic,strong) NSString *content;
/* 动态内容绑定对象 */
@property(nonatomic,strong) NSString *contentobjid;
/* 回复数 */
@property(nonatomic,assign)NSInteger countcomment;
/* 点赞 */
@property(nonatomic,assign) NSInteger countpraise;

/* 直接关联的人 */
@property(nonatomic,strong) NSString *directrelateduser;
/* 直接关联人姓名 */
@property(nonatomic,strong) NSString *directrelatedusername;
/* 直接关联人头像 */
@property(nonatomic,strong)NSString *directrelateduserface;

/* 消息类型  0 主动态 1 回复*/
@property(nonatomic,assign) NSInteger msgtype;
/* 主键ID */
@property(nonatomic,strong) NSString *pid;
/* 评论的文件id */
@property(nonatomic,strong)NSString *postfilesid;

/* 文件模板模板*/
@property(nonatomic,strong)NSDictionary *posttemplatedatadic;
/* 模板code*/
@property(nonatomic,strong)NSString *posttemplateid;
/* 点赞数组*/
@property(nonatomic,strong)NSMutableArray *prainseusername;

/* 所属范围名称 */
@property(nonatomic,strong)NSString *rangename;
/* 所属对象类型 */
@property(nonatomic,strong)NSString *rangetype;
/* 关联的主题ID */
@property(nonatomic,strong)NSString *relatedpid;
/* 发布时间 */
@property(nonatomic,strong)NSDate *releasedate;
/* 发布人 */
@property(nonatomic,strong)NSString *releaseuser;
/* 发布人姓名 */
@property(nonatomic,strong)NSString *releaseusername;
/* 发布人头像 */
@property(nonatomic,strong)NSString *releaseuserface;

/*回复集合*/
@property(nonatomic,strong)NSMutableArray *replypostlist;

/* 上传文件路径*/
@property(nonatomic,strong)NSMutableArray *rosourlist;
/*标签集合*/
@property(nonatomic,strong)NSMutableArray *tagdata;
/*企业id*/
@property(nonatomic,strong)NSString *oid;

@property(nonatomic,strong)NSArray *files;
/*收藏字典*/
@property(nonatomic,strong)NSDictionary *postfavorite;

#pragma mark 处理
/*是否展示文件名字*/
@property(nonatomic,assign)BOOL isShowFileName;
/*地理位置字典*/
@property(nonatomic,strong)NSDictionary *positiondiction;
/*维度*/
@property(nonatomic,strong)NSString *latitude;
/*经度*/
@property(nonatomic,strong)NSString *longitude;
/*地理名称*/
@property(nonatomic,strong)NSString *reference;
/*详细地址*/
@property(nonatomic,strong)NSString *address;
/*文件版本号*/
@property(nonatomic,assign)NSInteger postversion;



/* 模板*/
@property(nonatomic,strong)NSDictionary *positiondic;
@property(nonatomic,assign)NSInteger postdelperminssions;
/* 文件的评论内容*/
@property(nonatomic,strong)NSString *postfilesidcomment;
/* 文件的类型*/
@property(nonatomic,strong)NSString *postfilestype;
//文件状态
@property(nonatomic,assign)NSInteger postresourcetype;

@property(nonatomic,strong)NSData *posttemplatedata;
//
@property(nonatomic,strong)NSArray *postuser;
/* 所属类型标签 */
@property(nonatomic,strong)NSString *rangetag;
/* 关联地址 */
@property(nonatomic,strong)NSString *rangeurl;
/* 所属对象ID */
@property(nonatomic,strong)NSString *rangevalue;
@property(nonatomic,strong)NSString *rosourfiles;
//@
@property(nonatomic,strong)NSArray *useridlist;

@property(nonatomic,strong)NSString *expanddata;
@property(nonatomic,strong)NSDictionary *expanddatadic;


@end
