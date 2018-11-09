//
//  CoManageModel.h
//  LeadingCloud
//
//  Created by wang on 16/6/1.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-06-01
 Version: 1.0
 Description: 成员表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import "LZFMDatabase.h"
#import "NSObject+JsonSerial.h"

@interface CoManageModel : NSObject

/*协作Id*/
@property(nonatomic,strong)NSString *cid;
/*当前企业ID*/
@property(nonatomic,strong)NSString *oid;
/*协作类型*/
@property(nonatomic,strong)NSString *type;

@end
