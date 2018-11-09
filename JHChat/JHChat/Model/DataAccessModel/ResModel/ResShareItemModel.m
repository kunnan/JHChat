//
//  ResShareItemModel.m
//  LeadingCloud
//
//  Created by SY on 16/2/23.
/************************************************************
 Author:  sy
 Date：   2016-02-23
 Version: 1.0
 Description: 【云盘】 分享文件模型
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ResShareItemModel.h"

@implementation ResShareItemModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}
/**
 *  日期的处理
 *
 *  @param sharedate 日期
 */
-(void)setSharedate:(NSDate *)sharedate
{
    if([sharedate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)sharedate;
        _sharedate = [LZFormat String2Date:strDate];
    }
    else {
        _sharedate = sharedate;
    }

}
@end
