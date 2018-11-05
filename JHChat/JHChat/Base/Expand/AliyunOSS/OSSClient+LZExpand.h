//
//  OSSClient+LZExpand.h
//  LeadingCloud
//
//  Created by wchMac on 2017/7/11.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <AliyunOSSiOS/AliyunOSSiOS.h>

@interface OSSClient (LZExpand)

- (OSSTask *)lzPresignConstrainURLWithBucketName:(NSString *)bucketName
                                   withObjectKey:(NSString *)objectKey
                          withExpirationInterval:(NSTimeInterval)interval
                                  withParameters:(NSDictionary *)parameters ;

@end
