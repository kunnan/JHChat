//
//  LZPublicKey.m
//  LeadingCloud
//
//  Created by admin on 15/11/11.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "LZPublicKey.h"

@implementation LZPublicKey
/**
 初始化
 */
- (id)initWithRsa:(NSString *)key
                      modulus:(NSString *)modulus
                   exponent:(NSString *)exponent {
    self = [super init];
    if (self) {
        self.key = key;
        
        self.modulus = modulus;
        self.exponent = exponent;
        
    }
    return self;
}
/*
 销毁
 */
- (void)dealloc {
    self.key = nil;
    self.exponent = nil;
    self.modulus = nil;
}
@end
