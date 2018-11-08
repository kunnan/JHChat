//
//  KeyCenter.m
//  OpenVideoCall
//
//  Created by GongYuhua on 2016/9/12.
//  Copyright © 2016年 Agora. All rights reserved.
//

#import "KeyCenter.h"
#import "NSString+XHMD5.h"

@implementation KeyCenter
+ (NSString *)AppId {
	
	//return @"8c68a879d01d49dc9bb894e4dd90093a";
	
    return @"9621aed54762460bbc2e3070a29c0d9b";
}

+ (NSString*)Secret{
    
    return @"12345654321";
}
+(NSString *)AppCertificate{
    
    return @"9868e016855045d7b82d2804c4352b2a";
}

+(NSString*)account{
    
    return @"leadingenterprise@163.com";
}

+(NSString*)ChannelKey{
    
    return nil;
//    NSDate *senddate = [NSDate date];
//
//    NSString *time = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]+3600];
//    
//    NSString *secretkey = [NSString stringWithFormat:@"%@%@%@%@",[self account],[self AppId],[self AppCertificate],time];
//    
//    
////    token       = "1:appId:expiredTime:md5(account + appId + appCertificate + expiredTime)"
////    = "1:C5D15F8FD394285DA5227B533302A518:2592000:md5(test@agora.ioC5D15F8FD394285DA5227B533302A518fe1a0437bf217bdd34cd65053fb0fe1d2592000)"
////    = "1:C5D15F8FD394285DA5227B533302A518:2592000:5c0ee12fdf2020d0d0fdad04d6395473"
//    
//    return [NSString stringWithFormat:@"1:%@:%@%@",[self AppId],time,[secretkey MD5Hash]];
}
@end
