//
//  OrgAdminTempParse.h
//  LeadingCloud
//
//  Created by wchMac on 16/6/7.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "MsgBaseParse.h"

@interface OrgAdminTempParse : MsgBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(OrgAdminTempParse *)shareInstance;

#pragma mark - 解析临时通知数据

/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic;

@end
