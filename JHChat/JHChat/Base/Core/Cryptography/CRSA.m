#import "CRSA.h"

#define BUFFSIZE  1024
#import "NSData+Base64.h"
#import "NSString+Base64.h"

#define PADDING RSA_PKCS1_PADDING
#define PADDING_FLOAT_LEN ([self getBlockSizeWithRSA_PADDING_TYPE:PADDING] * 1.0)
#define DocumentsDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define OpenSSLRSAKeyDir [DocumentsDir stringByAppendingPathComponent:@".openssl_rsa"]
#define RSAPublickKeyFile [DocumentsDir stringByAppendingPathComponent:@"public_key.pem"]
#define RSAPreviteKeyFile [DocumentsDir stringByAppendingPathComponent:@"private_key.pem"]
@implementation CRSA

+ (id)shareInstance
{
    static CRSA *_crsa = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _crsa = [[self alloc] init];
    });
    return _crsa;
}

- (NSString *)formattKeyStr:(NSString *)str {
    if (str == nil) {
        return @"";
    }
    NSInteger count = str.length / 64;
    NSMutableString *foKeyStr = str.mutableCopy;
    for (int i = 0; i < count; i ++) {
        [foKeyStr insertString:@"\n" atIndex:64 + (64 + 1) * i];
    }
//    NSLog(@"%ld", @"\n".length);
    
    return foKeyStr == nil ? @"" : foKeyStr;
}

- (void)writePukWithKey:(NSString *)keystrr {
    NSError *error = nil;
    NSString *publicKeyStr = [NSString stringWithFormat:@"-----BEGIN PUBLIC KEY-----\n%@\n-----END PUBLIC KEY-----", [self formattKeyStr:keystrr]];
    [publicKeyStr writeToFile:RSAPublickKeyFile atomically:YES encoding:NSASCIIStringEncoding error:&error];
//    NSLog(@"%@", RSAPublickKeyFile);
}

- (void)writePrkWithKey:(NSString *)keystrr {
    NSError *error = nil;
    NSString *publicKeyStr = [NSString stringWithFormat:@"-----BEGIN RSA PRIVATE KEY-----\n%@\n-----END RSA PRIVATE KEY-----", [self formattKeyStr:keystrr]];
    [publicKeyStr writeToFile:RSAPreviteKeyFile atomically:YES encoding:NSASCIIStringEncoding error:&error];
//    NSLog(@"%@", RSAPreviteKeyFile);
}

- (BOOL)importRSAKeyWithType:(KeyType)type
{
    FILE *file;
    NSString *keyName = type == KeyTypePublic ? @"public_key" : @"private_key";
    
    NSString *keyPath = nil;
    if ([keyName isEqualToString:@"public_key"]) {
        keyPath = RSAPublickKeyFile;
    } else {
        keyPath = RSAPreviteKeyFile;
    }

    file = fopen([keyPath UTF8String], "rb");
    
    if (NULL != file)
    {
        if (type == KeyTypePublic)
        {
            _rsa = PEM_read_RSA_PUBKEY(file, NULL, NULL, NULL);
            assert(_rsa != nil);
        }
        else
        {
            _rsa = PEM_read_RSAPrivateKey(file, NULL, NULL, NULL);
            assert(_rsa != NULL);
        }
        
        fclose(file);
        
        return (_rsa != NULL) ? YES : NO;
    }
    
    return NO;
}

- (NSString *)encryptByRsa:(NSString*)content withKeyType:(KeyType)keyType
{
    NSString *ret = [[self encryptByRsaToData:content withKeyType:keyType] base64EncodedString];
    return ret;
}

- (NSData *)encryptByRsaToData:(NSString*)content withKeyType:(KeyType)keyType {
    if (![self importRSAKeyWithType:keyType])
        return nil;
    
    int status;
    long int length  = [content length];
    unsigned char input[length + 1];
    bzero(input, length + 1);
    int i = 0;
    for (; i < length; i++)
    {
        input[i] = [content characterAtIndex:i];
    }
    
    NSInteger  flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING];
    
    char *encData = (char*)malloc(flen);
    bzero(encData, flen);
    
    switch (keyType) {
        case KeyTypePublic:
            status = RSA_public_encrypt(length, (unsigned char*)input, (unsigned char*)encData, _rsa, PADDING);
            break;
            
        default:
            status = RSA_private_encrypt(length, (unsigned char*)input, (unsigned char*)encData, _rsa, PADDING);
            break;
    }
    
    if (status)
    {
        NSData *returnData = [NSData dataWithBytes:encData length:status];
        free(encData);
        encData = NULL;
        
//        NSString *ret = [returnData base64EncodedString];
        return returnData;
    }
    
    free(encData);
    encData = NULL;
    
    return nil;
}



- (NSString *) decryptByRsa:(NSString*)content withKeyType:(KeyType)keyType
{
    if (![self importRSAKeyWithType:keyType])
        return nil;
    
    int status;
    
    NSData *data = [content base64DecodedData];
    long int length = [data length];
    
    NSInteger flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING];
    char *decData = (char*)malloc(flen);
    bzero(decData, flen);
    
    switch (keyType) {
        case KeyTypePublic:
            status = RSA_public_decrypt(length, (unsigned char*)[data bytes], (unsigned char*)decData, _rsa, PADDING);
            break;
            
        default:
            status = RSA_private_decrypt(length, (unsigned char*)[data bytes], (unsigned char*)decData, _rsa, PADDING);
            break;
    }
    
    if (status)
    {
        NSMutableString *decryptString = [[NSMutableString alloc] initWithBytes:decData length:strlen(decData) encoding:NSASCIIStringEncoding];
        free(decData);
        decData = NULL;
        
        return decryptString;
    }
    
    free(decData);
    decData = NULL;
    
    return nil;
}

- (int)getBlockSizeWithRSA_PADDING_TYPE:(RSA_PADDING_TYPE)padding_type
{
    int len = RSA_size(_rsa);
    
    if (padding_type == RSA_PADDING_TYPE_PKCS1 || padding_type == RSA_PADDING_TYPE_SSLV23) {
        len -= 11;
    }

    return len;
}

- (NSString *)encryptByRsaWith:(NSString *)str keyType:(KeyType)keyType {
    if (![self importRSAKeyWithType:keyType])
        return nil;

    NSString *orstr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *encryptStr = @"".mutableCopy;
    for (NSInteger i = 0; i < ceilf(orstr.length / PADDING_FLOAT_LEN); i ++) {
        NSString *subStr = [orstr substringWithRange:NSMakeRange(i * PADDING_FLOAT_LEN, MIN(PADDING_FLOAT_LEN, orstr.length - i * PADDING_FLOAT_LEN))];
        if (subStr.length < PADDING_FLOAT_LEN) {
            NSMutableString *paddingStr = subStr.mutableCopy;
            char *enData = (char*)malloc(PADDING_FLOAT_LEN - subStr.length);
            bzero(enData, PADDING_FLOAT_LEN - subStr.length);
            NSString *zeroStr = [NSString stringWithFormat:@"%s", enData];
            [paddingStr appendString:zeroStr];
            subStr = paddingStr;
            free(enData);
            enData = NULL;
        }
        NSString *ss = [[self encryptByRsaToData:subStr withKeyType:(keyType)] base64EncodedString];
        [encryptStr appendString:ss];
    }
    return encryptStr;
}


- (NSString *)decryptByRsaWith:(NSString *)str keyType:(KeyType)keyType {
    if (![self importRSAKeyWithType:keyType])
        return nil;
    NSMutableString *mutableResultStr = @"".mutableCopy;
    for (NSInteger i = 0; i < ceilf(str.length / 172); i ++) {
        NSString *subStr = [str substringWithRange:NSMakeRange(i * 172, 172)];
        NSString *rrr = [self decryptByRsa:subStr withKeyType:(keyType)];
        NSString *sss = rrr.length <= PADDING_FLOAT_LEN ? rrr : [rrr substringToIndex:PADDING_FLOAT_LEN];
        [mutableResultStr appendString:sss];
    }
    return [mutableResultStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

}

- (NSString *)encryptByRsaWithCutData:(NSString*)content keyType:(KeyType)keyType {
    if (![self importRSAKeyWithType:keyType])
        return nil;
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSInteger length = [data length];
    float block_length = PADDING_FLOAT_LEN;
    NSMutableData *muData = [NSMutableData data];

    for (NSInteger i = 0; i < ceilf(length / block_length); i++) {
        NSInteger location = i * block_length;
        NSData *tmpData = nil;
        if (length - location > block_length) {
            tmpData = [data subdataWithRange:NSMakeRange(location, block_length)];
        } else {
            tmpData = [data subdataWithRange:NSMakeRange(location, length - location)];
            if (PADDING == RSA_PADDING_TYPE_NONE) {
                long len = block_length - (length - location);
                NSMutableData *paddingData = tmpData.mutableCopy;
                char *enData = (char*)malloc(len);
                memset(enData, '0', block_length - length);
                [paddingData appendBytes:enData length:len];
                tmpData = paddingData;
            }
           
        }
        char *enData = (char*)malloc(block_length);
        bzero(enData, block_length);
        int status = 0;
        if (keyType == KeyTypePublic) {
            status = RSA_public_encrypt([tmpData length], (unsigned char *)[tmpData bytes], (unsigned char *)enData, _rsa, PADDING);
        } else {
            status = RSA_private_encrypt([tmpData length], (unsigned char *)[tmpData bytes], (unsigned char *)enData, _rsa, PADDING);
        }
        NSLog(@"%@", tmpData);
        if (status) {
            NSLog(@"%d", status);
            [muData appendBytes:enData length:status];
            free(enData);
            enData = NULL;
        } else {
            free(enData);
            enData = NULL;
            return @"";
        }
    }
    

//    NSLog(@"%s", enData);

    return [muData base64EncodedString];
    
}

- (NSString *)decryptByRsaWithCutData:(NSString*)content keyType:(KeyType)keyType {
    if (![self importRSAKeyWithType:keyType])
        return nil;
    
    NSData *data = [content base64DecodedData];
    NSInteger length = [data length];
    float block_length = 128.0;
    char *muData = (char*)malloc(1);
    *muData = 0;
    for (NSInteger i = 0; i < ceilf(length / block_length); i++) {
        NSInteger location = i * block_length;
        NSData *tmpData = nil;
        if (length - location > block_length) {
            tmpData = [data subdataWithRange:NSMakeRange(location, block_length)];
        } else {
            tmpData = [data subdataWithRange:NSMakeRange(location, length - location)];
        }
        int status = 0;
        char *decData = (char*)malloc([tmpData length]);
        bzero(decData, [tmpData length]);
        if (keyType == KeyTypePublic) {
            status = RSA_public_decrypt([tmpData length], (unsigned char *)[tmpData bytes], (unsigned char *)decData, _rsa, PADDING);
        } else {
            status = RSA_private_decrypt([tmpData length], (unsigned char *)[tmpData bytes], (unsigned char *)decData, _rsa, PADDING);
        }
        char sub[128];
        strncpy(sub, decData,128);
        if (status) {
            muData = join(muData, sub);
            tmpData = nil;
            free(decData);
            decData = NULL;
        } else {
            tmpData = nil;
            free(decData);
            decData = NULL;
            free(muData);
            return @"";
        }
    }
    
    NSMutableString *decryptString = [[NSMutableString alloc] initWithBytes:muData length:strlen(muData) encoding:NSASCIIStringEncoding];
    free(muData);
    muData = NULL;
    return [decryptString == nil ? @"" : decryptString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

char *join(char *a, char *b) {
    char *c = (char *) malloc(strlen(a) + strlen(b) + 1);
    char *head = a;
    if (c == NULL) exit (1);
    char *tempc = c;
    while (*a != '\0') {
        *c++ = *a++;
    }
    while ((*c++ = *b++) != '\0') {
        ;
    }
    free(head);
    head = NULL;
    return tempc;
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

/**
 *  Encrypt Using Modulus and Exponent
 */
-(NSString*)encrypt:(NSString*)modulus exponent:(NSString*)exponent content:(NSString*)content
{
    NSData *modulusData=  [NSData dataWithBase64EncodedString:modulus];
    NSData *expoData=  [NSData dataWithBase64EncodedString:exponent];
    NSData* publicKeyData= [self generateRSAPublicKeyWithModulus:modulusData exponent:expoData];
    NSString *publicKeyString = [publicKeyData base64EncodedString];
    [self writePukWithKey:publicKeyString];
    NSString* encryptedString = [self encryptByRsaWith:content keyType:(KeyTypePublic)];
    
    return encryptedString;
}

@end
