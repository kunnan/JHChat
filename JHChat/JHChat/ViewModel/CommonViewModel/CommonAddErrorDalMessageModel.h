//
//  CommonAddErrorDalMessageModel.h
//  LeadingCloud
//
//  Created by wang on 2017/11/17.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonAddErrorDalMessageModel : NSObject


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CommonAddErrorDalMessageModel *)defaultManager;


/**
 添加错误数据
 @param tableName 表名
 @param sql sql语句
 @param error 错误信息（可能没有吧）
 @param other 其他信息 （有备无患）

 @return
 */
- (void)addDalMessageTableName:(NSString*)tableName Sql:(NSString*)sql Error:(NSString*)error Other:(NSDictionary*)other;



/**
 得到错误信息数组
 @param filePathName 文件路径名称
 @return
 */
- (NSMutableArray*)getErrorMeaasgeArrFilePathName:(NSString*)filePathName;

- (NSArray*)getErrorFileArr;

- (void)removeErrorFile;

@end
