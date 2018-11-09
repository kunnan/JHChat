//
//  PCLoginTempParse.h
//  LeadingCloud
//
//  Created by gjh on 2017/10/10.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "MsgBaseParse.h"

@interface PCLoginTempParse : MsgBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(PCLoginTempParse *)shareInstance;

#pragma mark - 解析临时通知数据

/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic;

@end
