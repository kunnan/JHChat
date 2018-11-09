//
//  BusinessTempParse.h
//  LeadingCloud
//
//  Created by wchMac on 2018/5/3.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import "MsgBaseParse.h"

@interface BusinessTempParse : MsgBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(BusinessTempParse *)shareInstance;

#pragma mark - 解析临时通知数据

/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic;

@end
