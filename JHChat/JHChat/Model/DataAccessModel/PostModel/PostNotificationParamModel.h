//
//  PostNotificationParamModel.h
//  LeadingCloud
//
//  Created by wang on 16/3/23.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

/************************************************************
 Author:  wzb
 Date：   2016-03-23
 Version: 1.0
 Description: 动态提醒内容模型
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface PostNotificationParamModel : NSObject

/*应用名称*/
@property(nonatomic,strong)NSString *rangename;
/*应用id*/
@property(nonatomic,strong)NSString *appcodedataid;
/*应用code*/
@property(nonatomic,strong)NSString *appcode;
/*类型*/
@property(nonatomic,strong)NSString *type;
/*内容*/
@property(nonatomic,strong)NSString *content;
/*说说内容*/
@property(nonatomic,strong)NSString *postcontent;



@property(nonatomic,strong)NSString *contentobjid;
@property(nonatomic,strong)NSString *pid;
@property(nonatomic,strong)NSString *rangetag;
@property(nonatomic,strong)NSString *rangetype;
@property(nonatomic,strong)NSString *relevanceface;
@property(nonatomic,strong)NSString *relevancename;
@property(nonatomic,strong)NSString *relevanceuid;
@property(nonatomic,strong)NSString *relevanceappcode;



@end
