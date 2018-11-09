//
//  CooperationDocumentParse.h
//  LeadingCloud
//
//  Created by SY on 16/6/2.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  sy
 Date：   2016-06-02
 Version: 1.0
 Description: 协作-文件-解析
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZBaseParse.h"

@interface CooperationDocumentParse : LZBaseParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CooperationDocumentParse *)shareInstance;

/**
 *  解析数据
 *
 *  @param dataDic
 */
-(void)parse:(NSMutableDictionary *)dataDic;

/**
 *  解析数据(服务器返回的ErrorCode非0)
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parseErrorDataContext:(NSMutableDictionary *)dataDic;
@end
