//
//  UnAllowUpLoadFileTypeViewModel.h
//  LeadingCloud
//
//  Created by dfl on 16/12/30.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2016-12-30
 Version: 1.0
 Description: 文件类型过滤
 
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>

@interface FilterFileTypeViewModel : NSObject

#pragma mark - 是否允许上传该文件类型的文档

/**
 不允许上传的文件类型

 @param type 文件名

 @return 
 */
+(BOOL)isAllowUploadWithCurrentType:(NSString*)type;

@end
