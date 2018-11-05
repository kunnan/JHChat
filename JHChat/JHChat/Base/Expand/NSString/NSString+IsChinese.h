//
//  NSString+IsChinese.h
//  LeadingCloud
//
//  Created by gjh on 2017/6/7.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IsChinese)

- (BOOL)isChinese;//判断是否是纯汉字

- (BOOL)includeChinese;//判断是否含有汉字

@end
