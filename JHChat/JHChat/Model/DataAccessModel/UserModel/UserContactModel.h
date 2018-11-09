//
//  UserContactModel.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/3.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  wch dfl
 Date：   2015-12-21
 Version: 1.0
 Description: 用户联系人表
 History:
 <author>  <time>   <version >   <desc>
 
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

@interface UserContactModel : NSObject

/* 主键ID(用户ID) */
@property(nonatomic,strong) NSString *ucid;
/* 联系人ID */
@property(nonatomic,strong) NSString *ctid;
/* 备注 */
@property(nonatomic,strong) NSString *remark;
/* 创建时间 */
@property(nonatomic,strong) NSDate *addtime;
/*是否是星标好友*/
@property(nonatomic,assign)NSInteger especially;
/* 是否有效 */
@property(nonatomic,assign) NSInteger isvalid;

@end
