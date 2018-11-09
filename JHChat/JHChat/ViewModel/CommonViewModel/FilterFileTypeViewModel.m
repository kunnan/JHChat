//
//  UnAllowUpLoadFileTypeViewModel.m
//  LeadingCloud
//
//  Created by dfl on 16/12/30.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "FilterFileTypeViewModel.h"
#import "NSString+IsNullOrEmpty.h"
#import "LCProgressHUD.h"

@implementation FilterFileTypeViewModel

/**
 不允许上传的文件类型
 
 @param type 文件名
 
 @return
 */
+(BOOL)isAllowUploadWithCurrentType:(NSString*)type{

    NSString *exp = nil;
    NSString *unallowUpload = [LZUserDataManager readUnallowUpLoadFileType];
    if ([NSString isNullOrEmpty:type]) {
        return YES;
    }
    if([type rangeOfString:@"."].location!=NSNotFound){
        exp = [[type substringFromIndex:[type rangeOfString:@"." options:NSBackwardsSearch].location+1] lowercaseString];
    }
    else {
        exp = [type lowercaseString];
    }
    
    if (![NSString isNullOrEmpty:unallowUpload]) {
        
        if ([unallowUpload rangeOfString:exp].location != NSNotFound) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [LCProgressHUD showInfoMsg:[NSString stringWithFormat:@"暂不支持(%@)类型文件上传",unallowUpload]];
            });
            return NO;
        }
        else {
            return YES;
        }
    }
    return YES;
}

@end
