//
//  NSString+SerialToArray.m
//  LeadingCloud
//
//  Created by gjh on 2017/8/22.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "NSString+SerialToArray.h"

@implementation NSString (SerialToArray)

- (NSMutableArray *)serialToArr {
    if(self == nil){
        return [NSMutableArray array];
    }
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    // 将JSON串转化为字典或者数组
    NSError *error = nil;
    NSMutableArray *chatUsers = [NSMutableArray array];
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                          options:NSJSONReadingAllowFragments
                                                            error:&error];
    [chatUsers addObjectsFromArray:jsonObject];
                
                return chatUsers;
}

@end
