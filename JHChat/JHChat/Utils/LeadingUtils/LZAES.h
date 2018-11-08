//
//  LZAES.h
//  LeadingCloud
//
//  Created by dfl on 2017/6/27.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZAES : NSObject


+(NSData *)AES256ParmEncryptWithKey:(NSString *)key Encrypttext:(NSData *)text;   //加密
+(NSData *)AES256ParmDecryptWithKey:(NSString *)key Decrypttext:(NSData *)text;   //解密
+(NSString *) aes256_encrypt:(NSString *)key Encrypttext:(NSString *)text;
+(NSString *) aes256_decrypt:(NSString *)key Decrypttext:(NSString *)text;

@end
