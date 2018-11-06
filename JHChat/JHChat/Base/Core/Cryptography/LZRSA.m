//
//  LZRSA.m
//  LeadingCloudFramework
//
//  Created by admin on 15/11/9.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "LZRSA.h"
#import "NSData+Base64.h"

@implementation LZRSA

-(void)test
{
    
    NSString *modulus =@"py8SL2Hggvnjxn07tNsn+1SrrJ4/Ymd1DeWMV8oVREzRE3MVP0+k2QFunYwHnxmJ7+YUwX+3/nJl0duTNsKtc/1RmUc8t90ZSAoY+6ebykTG6PXo1tAOM4ULUihH5yXniuMKgvvFfwshZsZH0lwUUJWMvT+Xeaa1M1G8bpgtOp0=";//[self getModulusWithTag:publicTag];
    
    NSString *exponent =@"AQAB";//[self getExponentWithTag:publicTag] ;
    
    //encryption
    NSString* cipherText= [self encrypt:modulus exponent:exponent  content:@"plainText - 眩 - 黄岳"];
    
    NSLog(@"cipherText:%@",cipherText);
    
    //decryption using mod and expo
    //NSString* plainText= [self decrypt:cipherText privateTag:privateTag];
    
    //NSLog(@"plainText:%@",plainText);
    
}



/**
 *  Encrypt Using Modulus and Exponent
 */
-(NSString*)encrypt:(NSString*)modulus exponent:(NSString*)exponent content:(NSString*)content
{
    NSString * publicKeyTag = @"LZ0000000000000000";
    NSData *modulusData=  [self dataWithBase64EncodedString:modulus];
    NSData *expoData=  [self dataWithBase64EncodedString:exponent];
    NSData* publicKeyData= [self generateRSAPublicKeyWithModulus:modulusData exponent:expoData];
//    publicKeyData = [publicKeyData base64EncodedDataWithOptions:0];
//    NSString *ret = [[NSString alloc] initWithData:publicKeyData encoding:NSUTF8StringEncoding];

    bool success= [self saveRSAPublicKey:publicKeyData appTag:publicKeyTag overwrite:YES];
    NSString* encryptedString;
    if (success) {
        SecKeyRef publicKey= [self loadRSAPublicKeyRefWithAppTag:publicKeyTag];
        
        NSData* encryptedData= [self encryptString:content RSAPublicKey:publicKey padding:kSecPaddingPKCS1];
        encryptedString=[encryptedData base64EncodedString];
        
        CFRelease(publicKey);
    }
    else
    {
        NSLog(@"RSA Public key couldn't be saved.");
    }
    return encryptedString;
    
}


- (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    const char lookup[] =
    {
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62, 99, 99, 99, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99, 99, 99, 99, 99,
        99,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99, 99, 99, 99, 99,
        99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99, 99, 99, 99, 99
    };
    
    NSData *inputData = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    long long inputLength = [inputData length];
    const unsigned char *inputBytes = [inputData bytes];
    
    long long maxOutputLength = (inputLength / 4 + 1) * 3;
    NSMutableData *outputData = [NSMutableData dataWithLength:maxOutputLength];
    unsigned char *outputBytes = (unsigned char *)[outputData mutableBytes];
    
    int accumulator = 0;
    long long outputLength = 0;
    unsigned char accumulated[] = {0, 0, 0, 0};
    for (long long i = 0; i < inputLength; i++)
    {
        unsigned char decoded = lookup[inputBytes[i] & 0x7F];
        if (decoded != 99)
        {
            accumulated[accumulator] = decoded;
            if (accumulator == 3)
            {
                outputBytes[outputLength++] = (accumulated[0] << 2) | (accumulated[1] >> 4);
                outputBytes[outputLength++] = (accumulated[1] << 4) | (accumulated[2] >> 2);
                outputBytes[outputLength++] = (accumulated[2] << 6) | accumulated[3];
            }
            accumulator = (accumulator + 1) % 4;
        }
    }
    
    //handle left-over data
    if (accumulator > 0) outputBytes[outputLength] = (accumulated[0] << 2) | (accumulated[1] >> 4);
    if (accumulator > 1) outputBytes[++outputLength] = (accumulated[1] << 4) | (accumulated[2] >> 2);
    if (accumulator > 2) outputLength++;
    
    //truncate data to match actual output length
    outputData.length = outputLength;
    return outputLength? outputData: nil;
}


-(NSData*)generateRSAPublicKeyWithModulus:(NSData*)modulus exponent:(NSData*)exponent
{
    const uint8_t DEFAULT_EXPONENT[] = {0x01, 0x00, 0x01,};	//default: 65537
    const uint8_t UNSIGNED_FLAG_FOR_BYTE = 0x81;
    const uint8_t UNSIGNED_FLAG_FOR_BYTE2 = 0x82;
    const uint8_t UNSIGNED_FLAG_FOR_BIGNUM = 0x00;
    const uint8_t SEQUENCE_TAG = 0x30;
    const uint8_t INTEGER_TAG = 0x02;
    
    uint8_t* modulusBytes = (uint8_t*)[modulus bytes];
    uint8_t* exponentBytes = (uint8_t*)(exponent == nil ? DEFAULT_EXPONENT : [exponent bytes]);
    
    //(1) calculate lengths
    //- length of modulus
    int lenMod = [modulus length];
    if(modulusBytes[0] >= 0x80)
        lenMod ++;	//place for UNSIGNED_FLAG_FOR_BIGNUM
    int lenModHeader = 2 + (lenMod >= 0x80 ? 1 : 0) + (lenMod >= 0x0100 ? 1 : 0);
    //- length of exponent
    int lenExp = exponent == nil ? sizeof(DEFAULT_EXPONENT) : [exponent length];
    int lenExpHeader = 2;
    //- length of body
    int lenBody = lenModHeader + lenMod + lenExpHeader + lenExp;
    //- length of total
    int lenTotal = 2 + (lenBody >= 0x80 ? 1 : 0) + (lenBody >= 0x0100 ? 1 : 0) + lenBody;
    
    int index = 0;
    uint8_t* byteBuffer = malloc(sizeof(uint8_t) * lenTotal);
    memset(byteBuffer, 0x00, sizeof(uint8_t) * lenTotal);
    
    //(2) fill up byte buffer
    //- sequence tag
    byteBuffer[index ++] = SEQUENCE_TAG;
    //- total length
    if(lenBody >= 0x80)
        byteBuffer[index ++] = (lenBody >= 0x0100 ? UNSIGNED_FLAG_FOR_BYTE2 : UNSIGNED_FLAG_FOR_BYTE);
    if(lenBody >= 0x0100)
    {
        byteBuffer[index ++] = (uint8_t)(lenBody / 0x0100);
        byteBuffer[index ++] = lenBody % 0x0100;
    }
    else
        byteBuffer[index ++] = lenBody;
    //- integer tag
    byteBuffer[index ++] = INTEGER_TAG;
    //- modulus length
    if(lenMod >= 0x80)
        byteBuffer[index ++] = (lenMod >= 0x0100 ? UNSIGNED_FLAG_FOR_BYTE2 : UNSIGNED_FLAG_FOR_BYTE);
    if(lenMod >= 0x0100)
    {
        byteBuffer[index ++] = (int)(lenMod / 0x0100);
        byteBuffer[index ++] = lenMod % 0x0100;
    }
    else
        byteBuffer[index ++] = lenMod;
    //- modulus value
    if(modulusBytes[0] >= 0x80)
        byteBuffer[index ++] = UNSIGNED_FLAG_FOR_BIGNUM;
    memcpy(byteBuffer + index, modulusBytes, sizeof(uint8_t) * [modulus length]);
    index += [modulus length];
    //- exponent length
    byteBuffer[index ++] = INTEGER_TAG;
    byteBuffer[index ++] = lenExp;
    //- exponent value
    memcpy(byteBuffer + index, exponentBytes, sizeof(uint8_t) * lenExp);
    index += lenExp;
    
    if(index != lenTotal)
        NSLog(@"lengths mismatch: index = %d, lenTotal = %d", index, lenTotal);
    
    NSMutableData* buffer = [NSMutableData dataWithBytes:byteBuffer length:lenTotal];
    free(byteBuffer);
    
    return buffer;
}
-(BOOL)saveRSAPublicKey:(NSData*)publicKey appTag:(NSString*)appTag overwrite:(BOOL)overwrite
{
    CFDataRef ref;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:
                                                            (__bridge id)kSecClassKey, kSecClass,
                                                            (__bridge id)kSecAttrKeyTypeRSA, kSecAttrKeyType,
                                                            (__bridge id)kSecAttrKeyClassPublic, kSecAttrKeyClass,
                                                            kCFBooleanTrue, kSecAttrIsPermanent,
                                                            [appTag dataUsingEncoding:NSUTF8StringEncoding], kSecAttrApplicationTag,
                                                            publicKey, kSecValueData,
                                                            kCFBooleanTrue, kSecReturnPersistentRef,
                                                            nil],
                                 (CFTypeRef *)&ref);
    
    NSLog(@"RSA saveRSAPublicKey result = %@", [self fetchStatus:status]);
    
    if(status == noErr)
        return YES;
    else if(status == errSecDuplicateItem && overwrite == YES)
        return [self
                updateRSAPublicKey:publicKey appTag:appTag];
    
    return NO;
}

- (BOOL)updateRSAPublicKey:(NSData*)publicKey appTag:(NSString*)appTag
{
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     (__bridge id)kSecClassKey, kSecClass,
                                                                     kSecAttrKeyTypeRSA, kSecAttrKeyType,
                                                                     kSecAttrKeyClassPublic, kSecAttrKeyClass,
                                                                     [appTag dataUsingEncoding:NSUTF8StringEncoding], kSecAttrApplicationTag,
                                                                     nil],
                                          NULL);	//don't need public key ref
    
    NSLog(@"RSA updateRSAPublicKey 1 result = %@", [self fetchStatus:status]);
    
    if(status == noErr)
    {
        status = SecItemUpdate((__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:
                                                          (__bridge id)kSecClassKey, kSecClass,
                                                          kSecAttrKeyTypeRSA, kSecAttrKeyType,
                                                          kSecAttrKeyClassPublic, kSecAttrKeyClass,
                                                          [appTag dataUsingEncoding:NSUTF8StringEncoding], kSecAttrApplicationTag,
                                                          nil],
                               (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:
                                                          publicKey, kSecValueData,
                                                          nil]);
        
        NSLog(@"RSA updateRSAPublicKey 2 result = %@", [self fetchStatus:status]);
        
        return status == noErr;
    }
    return NO;
}

/*
 * returned value(SecKeyRef) should be released with CFRelease() function after use.
 *
 */
- (SecKeyRef)loadRSAPublicKeyRefWithAppTag:(NSString*)appTag
{
    SecKeyRef publicKeyRef;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     (__bridge id)kSecClassKey, kSecClass,
                                                                     kSecAttrKeyTypeRSA, kSecAttrKeyType,
                                                                     kSecAttrKeyClassPublic, kSecAttrKeyClass,
                                                                     [appTag dataUsingEncoding:NSUTF8StringEncoding], kSecAttrApplicationTag,
                                                                     kCFBooleanTrue, kSecReturnRef,
                                                                     nil],
                                          (CFTypeRef*)&publicKeyRef);
    
    NSLog(@"RSA loadRSAPublicKeyRefWithAppTag result = %@", [self fetchStatus:status]);
    
    if(status == noErr)
        return publicKeyRef;
    else
        return NULL;
}

/**
 * encrypt with RSA public key
 *
 * padding = kSecPaddingPKCS1 / kSecPaddingNone
 *
 */
- (NSData*)encryptString:(NSString*)original RSAPublicKey:(SecKeyRef)publicKey padding:(SecPadding)padding
{
    @try
    {
        size_t encryptedLength = SecKeyGetBlockSize(publicKey);
        uint8_t encrypted[encryptedLength];
        
        const char* cStringValue = [original UTF8String];
        OSStatus status = SecKeyEncrypt(publicKey,
                                        padding,
                                        (const uint8_t*)cStringValue,
                                        strlen(cStringValue),
                                        encrypted,
                                        &encryptedLength);
        if(status == noErr)
        {
            NSData* encryptedData = [[NSData alloc] initWithBytes:(const void*)encrypted length:encryptedLength];
            return encryptedData ;
        }
        else
            return nil;
    }
    @catch (NSException * e)
    {
        //do nothing
        NSLog(@"exception: %@", [e reason]);
    }
    return nil;
}



- (NSString*)fetchStatus:(OSStatus)status
{
    if(status == 0)
        return @"success";
    else if(status == errSecNotAvailable)
        return @"no trust results available";
    else if(status == errSecItemNotFound)
        return @"the item cannot be found";
    else if(status == errSecParam)
        return @"parameter error";
    else if(status == errSecAllocate)
        return @"memory allocation error";
    else if(status == errSecInteractionNotAllowed)
        return @"user interaction not allowd";
    else if(status == errSecUnimplemented)
        return @"not implemented";
    else if(status == errSecDuplicateItem)
        return @"item already exists";
    else if(status == errSecDecode)
        return @"unable to decode data";
    else
        return [NSString stringWithFormat:@"%d", (int)status];
}

#pragma mark -
#pragma mark functions for debug purpose
//from: https://devforums.apple.com/message/123846#123846


@end
