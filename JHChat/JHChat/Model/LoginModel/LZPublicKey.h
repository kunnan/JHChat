//
//  LZPublicKey.h
//  LeadingCloud
//
//  Created by admin on 15/11/11.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZPublicKey : NSObject
/**
 *  tokenid
 */
@property (nonatomic, copy) NSString *key;
/**
 *  RSA 的 N值
 */
@property (nonatomic, copy) NSString *modulus;
/**
 *  RSA 的 E值
 */
@property (nonatomic, copy) NSString *exponent;


/**
 初始化
 */
- (id)initWithRsa:(NSString *)key
          modulus:(NSString *)modulus
         exponent:(NSString *)exponent;
@end
