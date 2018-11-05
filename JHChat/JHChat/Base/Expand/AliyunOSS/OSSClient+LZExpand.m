//
//  OSSClient+LZExpand.m
//  LeadingCloud
//
//  Created by wchMac on 2017/7/11.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "OSSClient+LZExpand.h"

@implementation OSSClient (LZExpand)

- (OSSTask *)lzPresignConstrainURLWithBucketName:(NSString *)bucketName
                                   withObjectKey:(NSString *)objectKey
                          withExpirationInterval:(NSTimeInterval)interval
                                  withParameters:(NSDictionary *)parameters {
    
    return [[OSSTask taskWithResult:nil] continueWithBlock:^id(OSSTask *task) {
        NSString * resource = [NSString stringWithFormat:@"/%@/%@", bucketName, objectKey];
        NSString * expires = [@((int64_t)[[NSDate oss_clockSkewFixedDate] timeIntervalSince1970] + interval) stringValue];
        NSString * wholeSign = nil;
        OSSFederationToken * token = nil;
        NSError * error = nil;
        NSMutableDictionary * params = [NSMutableDictionary new];
        
        if (parameters) {
            [params addEntriesFromDictionary:parameters];
        }
        
        if ([self.credentialProvider isKindOfClass:[OSSFederationCredentialProvider class]]) {
            token = [(OSSFederationCredentialProvider *)self.credentialProvider getToken:&error];
            if (error) {
                return [OSSTask taskWithError:error];
            }
        } else if ([self.credentialProvider isKindOfClass:[OSSStsTokenCredentialProvider class]]) {
            token = [(OSSStsTokenCredentialProvider *)self.credentialProvider getToken];
        }
        
        if ([self.credentialProvider isKindOfClass:[OSSFederationCredentialProvider class]]
            || [self.credentialProvider isKindOfClass:[OSSStsTokenCredentialProvider class]]) {
            if (token.tToken) {
                [params setObject:token.tToken forKey:@"security-token"];
            }
            //            resource = [NSString stringWithFormat:@"%@?%@", resource, [OSSUtil populateSubresourceStringFromParameter:params]];
            resource = [NSString stringWithFormat:@"%@?%@", resource, [self lzPopulateSubresourceStringFromParameter:params]];
            NSString * string2sign = [NSString stringWithFormat:@"GET\n\n\n%@\n%@", expires, resource];
            wholeSign = [OSSUtil sign:string2sign withToken:token];
        }
        else {
            NSString * subresource = [self lzPopulateSubresourceStringFromParameter:params];
            //            NSString * subresource = [OSSUtil populateSubresourceStringFromParameter:params];
            if ([subresource length] > 0) {
                //                resource = [NSString stringWithFormat:@"%@?%@", resource, [OSSUtil populateSubresourceStringFromParameter:params]];
                resource = [NSString stringWithFormat:@"%@?%@", resource, [self lzPopulateSubresourceStringFromParameter:params]];
            }
            NSString * string2sign = [NSString stringWithFormat:@"GET\n\n\n%@\n%@", expires, resource];
            wholeSign = [self.credentialProvider sign:string2sign error:&error];
            if (error) {
                return [OSSTask taskWithError:error];
            }
        }
        
        NSArray * splitResult = [wholeSign componentsSeparatedByString:@":"];
        if ([splitResult count] != 2
            || ![((NSString *)[splitResult objectAtIndex:0]) hasPrefix:@"OSS "]) {
            return [OSSTask taskWithError:[NSError errorWithDomain:OSSClientErrorDomain
                                                              code:OSSClientErrorCodeSignFailed
                                                          userInfo:@{OSSErrorMessageTOKEN: @"the returned signature is invalid"}]];
        }
        NSString * accessKey = [(NSString *)[splitResult objectAtIndex:0] substringFromIndex:4];
        NSString * signature = [splitResult objectAtIndex:1];
        
        NSURL * endpointURL = [NSURL URLWithString:self.endpoint];
        NSString * host = endpointURL.host;
        if ([OSSUtil isOssOriginBucketHost:host]) {
            host = [NSString stringWithFormat:@"%@.%@", bucketName, host];
        }
        [params setObject:signature forKey:@"Signature"];
        [params setObject:accessKey forKey:@"OSSAccessKeyId"];
        [params setObject:expires forKey:@"Expires"];
        //        NSString * stringURL = [NSString stringWithFormat:@"%@://%@/%@?%@",
        //                                endpointURL.scheme,
        //                                host,
        //                                [OSSUtil encodeURL:objectKey],
        //                                [OSSUtil populateQueryStringFromParameter:params]];
        
        NSString * stringURL = [NSString stringWithFormat:@"%@://%@/%@?%@",
                                endpointURL.scheme,
                                host,
                                [OSSUtil encodeURL:objectKey],
                                [self lzPopulateQueryStringFromParameter:params]];
        return [OSSTask taskWithResult:stringURL];
    }];
}


#pragma mark - private function
- (BOOL)lzIsSubresource:(NSString *)param {
    /****************************************************************
     * define a constant array to contain all specified subresource */
    static NSArray * OSSSubResourceARRAY = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OSSSubResourceARRAY = @[
                                @"acl", @"uploads", @"location", @"cors", @"logging", @"website", @"referer", @"lifecycle", @"delete", @"append",
                                @"tagging", @"objectMeta", @"uploadId", @"partNumber", @"security-token", @"position", @"img", @"style",
                                @"styleName", @"replication", @"replicationProgress", @"replicationLocation", @"cname", @"bucketInfo", @"comp",
                                @"qos", @"live", @"status", @"vod", @"startTime", @"endTime", @"symlink", @"x-oss-process", @"response-content-type",
                                @"response-content-language", @"response-expires", @"response-cache-control", @"response-content-disposition", @"response-content-encoding"
                                ];
    });
    /****************************************************************/
    
    return [OSSSubResourceARRAY containsObject:param];
}

- (NSString *)lzPopulateSubresourceStringFromParameter:(NSDictionary *)parameters {
    NSMutableArray * subresource = [NSMutableArray new];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString * keyStr = [key oss_trim];
        NSString * valueStr = [obj oss_trim];
        if (![self lzIsSubresource:keyStr]) {
            return;
        }
        if ([valueStr length] == 0) {
            [subresource addObject:keyStr];
        } else {
            [subresource addObject:[NSString stringWithFormat:@"%@=%@", keyStr, valueStr]];
        }
    }];
    NSArray * sortedSubResource = [subresource sortedArrayUsingSelector:@selector(compare:)]; // 升序
    return [sortedSubResource componentsJoinedByString:@"&"];
}
- (NSString *)lzPopulateQueryStringFromParameter:(NSDictionary *)parameters {
    NSMutableArray * subresource = [NSMutableArray new];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString * keyStr = [OSSUtil encodeURL:[key oss_trim]];
        NSString * valueStr = [OSSUtil encodeURL:[obj oss_trim]];
        if ([valueStr length] == 0) {
            [subresource addObject:keyStr];
        } else {
            [subresource addObject:[NSString stringWithFormat:@"%@=%@", keyStr, valueStr]];
        }
    }];
    return [subresource componentsJoinedByString:@"&"];
}

@end
