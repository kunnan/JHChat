//
//  CloudDiskDocumentTempParse.h
//  LeadingCloud
//
//  Created by SY on 16/5/18.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "MsgBaseParse.h"

@interface CloudDiskDocumentTempParse : MsgBaseParse
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CloudDiskDocumentTempParse *)shareInstance;

#pragma mark - 解析临时通知数据

/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic;
@end
