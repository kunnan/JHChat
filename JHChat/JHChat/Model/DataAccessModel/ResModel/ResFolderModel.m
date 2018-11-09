//
//  ResFolderModel.m
//  LeadingCloud
//
//  Created by wchMac on 16/1/13.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  dfl
 Date：   2016-01-13
 Version: 1.0
 Description: 资源文件夹
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ResFolderModel.h"

@implementation ResFolderModel
-(id)valueForUndefinedKey:(NSString *)key {
    
    return nil;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}
-(void)setCreatedate:(NSDate *)createdate{
    if([createdate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)createdate;
        _createdate = [LZFormat String2Date:strDate];
    }
    else {
        _createdate = createdate;
    }
}

-(void)setUpdatedate:(NSDate *)newUpdatedate{
    if([newUpdatedate isKindOfClass:[NSString class]]){
        NSString *strUpdateDate = (NSString *)newUpdatedate;
        _updatedate = [LZFormat String2Date:strUpdateDate];
    }
    else {
        _updatedate = newUpdatedate;
    }
}

@end
