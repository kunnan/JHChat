//
//  ImChatLogModel.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/2.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "ImChatLogModel.h"

@implementation ImChatLogModel

-(void)setShowindexdate:(NSDate *)showindexdate{
    if([showindexdate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)showindexdate;
        _showindexdate = [LZFormat String2Date:strDate];
    }
    else {
        _showindexdate = showindexdate;
    }
}

- (ImChatLogBodyModel *)imClmBodyModel
{
    ImChatLogBodyModel *bodyModel = [[ImChatLogBodyModel alloc] init];
    [bodyModel serialization:self.body];
    return bodyModel;
}

@end
