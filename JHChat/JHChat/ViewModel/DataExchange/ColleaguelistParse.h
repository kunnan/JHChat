//
//  ColleaguelistParse.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "LZBaseParse.h"

@interface ColleaguelistParse : LZBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ColleaguelistParse *)shareInstance;

-(void)parse:(NSMutableDictionary *)dataDic;

@end
