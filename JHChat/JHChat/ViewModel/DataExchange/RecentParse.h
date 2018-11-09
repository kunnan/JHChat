//
//  RecentParse.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "LZBaseParse.h"

@interface RecentParse : LZBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(RecentParse *)shareInstance;

-(void)parse:(NSMutableDictionary *)dataDic;

@end
