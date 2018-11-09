//
//  CoTransactionPostInfoModel.h
//  LeadingCloud
//
//  Created by wang on 16/10/19.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-10-19
 Version: 1.0
 Description: 事务岗位列表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface CoTransactionPostInfoModel : NSObject

//名字
@property (nonatomic,strong)NSString *name;

//岗位id
@property (nonatomic,strong)NSString *postid;

@end
