//
//  PostPromptModel.h
//  LeadingCloud
//
//  Created by wang on 16/3/9.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wzb
 Date：   2016-03-09
 Version: 1.0
 Description: 动态常用语
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface PostPromptModel : NSObject
/*创建时间*/
@property(nonatomic,strong)NSDate *createdate;
/*常用语内容 */
@property(nonatomic,strong)NSString *cuename;
/*常用语企业id */
@property(nonatomic,strong)NSString *cueorgid;
/*主键*/
@property(nonatomic,strong)NSString *pcid;
/*常用语添加用户id*/
@property(nonatomic,strong)NSString *cueuid;

//#pragma mark 新增
//@property(nonatomic,assign)NSInteger cuetype;

//创建时不传
@property(nonatomic,strong)NSString *cuehtml;
@end
