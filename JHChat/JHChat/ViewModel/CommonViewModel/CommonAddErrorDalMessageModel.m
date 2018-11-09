//
//  CommonAddErrorDalMessageModel.m
//  LeadingCloud
//
//  Created by wang on 2017/11/17.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "CommonAddErrorDalMessageModel.h"
#import "AppUtils.h"
#import "FilePathUtil.h"
#import "AppDateUtil.h"


@implementation CommonAddErrorDalMessageModel


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CommonAddErrorDalMessageModel *)defaultManager{
	static CommonAddErrorDalMessageModel *instance = nil;
	if (instance == nil) {
		instance = [[CommonAddErrorDalMessageModel alloc] init];
	}
	return instance;
}

/**
 添加错误数据
 
 @param sql sql语句
 @param error 错误信息（可能没有吧）
 @param other 其他信息 （有备无患）
 
 @return
 */
- (void)addDalMessageTableName:(NSString*)tableName Sql:(NSString*)sql Error:(NSString*)error Other:(NSDictionary*)other{
	
	NSString *filePath = [FilePathUtil getErrorFileDownloadDicAbsolutePath];
	
	filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"error_%@.json",tableName]];
	
	NSMutableArray *dataArr = [self getErrorMeaasgeArrFilePathName:filePath];
	
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:sql,@"sql",error,@"error",[AppDateUtil GetCurrentDateForString],@"date", nil];
	
	//判读第一条时间，超过三天清空
	if (dataArr.count>0) {
		
		NSDictionary *firstDic = [dataArr firstObject];
		NSString *date = [firstDic lzNSStringForKey:@"date"];
		
		NSInteger day = [AppDateUtil IntervalDays:[LZFormat String2Date:date] endDate:[AppDateUtil GetCurrentDate]] ;
	 
		if(day>3){
			[dataArr removeAllObjects];
		}
	}
	
	[dataArr insertObject:dic atIndex:0];
	
	NSData *data=[NSJSONSerialization dataWithJSONObject:dataArr options:NSJSONWritingPrettyPrinted error:nil];
	[[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
	
}



/**
 得到错误信息数组
 @param filePathName 文件路径名称
 @return
 */
- (NSMutableArray*)getErrorMeaasgeArrFilePathName:(NSString*)filePathName
{
	NSMutableArray *dataArr = [NSMutableArray array];
	
	NSData *data = [[NSFileManager defaultManager]contentsAtPath:filePathName];
	
	if(!data) return dataArr;
	NSArray * arr =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
	if (arr) {
		[dataArr addObjectsFromArray:arr];
	}
	return  dataArr;
}

- (NSArray*)getErrorFileArr{
	
	NSString *filePath = [FilePathUtil getErrorFileDownloadDicAbsolutePath];
	NSError *error = nil;
	NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:&error];
	
	return arr;
}

- (void)removeErrorFile{
	
	NSString *filePath = [FilePathUtil getErrorFileDownloadDicAbsolutePath];
	
	[[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

@end
