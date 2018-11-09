//
//  RemotelyAccountModel.m
//  LeadingCloud
//
//  Created by SY on 2017/6/23.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "RemotelyAccountModel.h"

@implementation RemotelyAccountModel
-(void)setExpiration:(NSDate *)expiration {
    if([expiration isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)expiration;
        _expiration = [LZFormat String2Date:strDate];
    }
    else {
        _expiration = expiration;
    }
}
@end
