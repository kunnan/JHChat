//
//  ResourceShareFolderModel.m
//  LeadingCloud
//
//  Created by SY on 2017/11/25.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "ResourceShareFolderModel.h"

@implementation ResourceShareFolderModel

-(void)setCreatedate:(NSDate *)createdate {
    if([createdate isKindOfClass:[NSString class]]){
        
        NSString *strDate = (NSString *)createdate;
        _createdate = [LZFormat String2Date:strDate];
    }
    else {
        _createdate = createdate;
    }
}
@end
