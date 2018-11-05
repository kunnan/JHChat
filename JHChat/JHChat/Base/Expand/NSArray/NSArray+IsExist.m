//
//  NSArray+IsExist.m
//  LeadingCloud
//
//  Created by wchMac on 2017/8/12.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "NSArray+IsExist.h"

@implementation NSArray (IsExist)

-(BOOL)isExistString:(NSString *)str{
    BOOL isExist = NO;
    for(NSString *item in self){
        if([[item lowercaseString] isEqualToString:[str lowercaseString]]){
            isExist = YES;
            break;
        }
    }
    return isExist;
}

@end
