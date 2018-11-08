//
//  FileUtil.h
//  LeadingCloud
//
//  Created by wang on 17/1/9.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtil : NSObject


/**
 更改文件的名称

 @param filepath    文件路径
 @param orgFileName 文件初始名称
 @param newFileName 修改后名称
 */
+(void)replaceNameFilePath:(NSString*)filepath OrgName:(NSString*)orgFileName NewFileName:(NSString*)newFileName;

// 获取沙盒目录下所有文件的大小
+( CGFloat )documentSize;

+( CGFloat ) folderSizeAtPath:( NSString *) folderPath;
// 清理缓存
+ (void)clearFile;

@end
