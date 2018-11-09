//
//  AddressDAL.h
//  LeadingCloud
//
//  Created by dfl on 2018/8/31.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import "LZFMDatabase.h"

@interface AddressDAL : LZFMDatabase


/* 得到所有省 */
-(NSMutableArray *)getProvinceQueryData;


@end
