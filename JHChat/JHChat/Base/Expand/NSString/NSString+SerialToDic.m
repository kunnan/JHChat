//
//  NSString+SerialToDic.m
//  LeadingCloud
//
//  Created by wchMac on 16/1/20.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "NSString+SerialToDic.h"

@implementation NSString (SerialToDic)

- (NSDictionary *)seriaToDic{
    if(self == nil){
        return [[NSDictionary alloc] init];;
    }
    
    NSDictionary *dataSource = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                                               options:NSJSONReadingMutableLeaves
                                                                 error:nil];
    return dataSource;
}

@end
