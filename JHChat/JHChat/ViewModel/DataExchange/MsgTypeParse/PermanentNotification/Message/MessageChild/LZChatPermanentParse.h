//
//  LZChatPermanentParse.h
//  LeadingCloud
//
//  Created by gjh on 2017/8/3.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "MsgBaseParse.h"

@interface LZChatPermanentParse : MsgBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(LZChatPermanentParse *)shareInstance;

#pragma mark - 解析临时通知数据

/**
 *  解析持久通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic;

@end
