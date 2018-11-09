//
//  TagDataModel.h
//  LeadingCloud
//
//  Created by wang on 16/2/18.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-02-18
 Version: 1.0
 Description: 标签值模型
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface TagDataModel : NSObject
/*主键*/
@property(nonatomic,copy)NSString *tdid;

/*标签内容*/
@property(nonatomic,copy)NSString *name;
/*好友标签id*/
@property(nonatomic,copy)NSString *ttid;
/*协作id*/
@property(nonatomic,copy)NSString *dataid;
/*企业id*/
@property(nonatomic,copy)NSString *oid;
/*用户id*/
@property(nonatomic,copy)NSString *uid;
/*标签id*/
@property(nonatomic,copy)NSString *dataextend1;
/*标签列表id*/
@property(nonatomic,copy)NSString *dataextend2;
/*创建时间id*/
@property(nonatomic,copy)NSDate *createdate;

/**/
@property(nonatomic,copy)NSString *taid;
/**/
@property(nonatomic,copy)NSString *dataextend3;


/*签id*/
@property(nonatomic,copy)NSString *ctid;
@end
