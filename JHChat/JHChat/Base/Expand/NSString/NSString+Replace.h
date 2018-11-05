//
//  NSString+Replace.h
//  LeadingCloud
//
//  Created by wchMac on 2016/11/23.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Replace)

-(NSString *)stringByReplacingIGNOREOccurrencesOfString:(NSString *)forReplace withString:(NSString *)toRelace;

// 截取字符串方法封装
- (NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString;

@end
