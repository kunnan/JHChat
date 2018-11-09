//
//  ImGroupModel.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/2.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "ImGroupModel.h"
#import "NSString+SerialToArray.h"
#import "NSObject+JsonSerial.h"

@implementation ImGroupModel

-(void)setCreatedate:(NSDate *)createdate{
    if([createdate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)createdate;
        _createdate = [LZFormat String2Date:strDate];
    }
    else {
        _createdate = createdate;
    }
}

-(void)setLastmsgdate:(NSDate *)lastmsgdate{
    if([lastmsgdate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)lastmsgdate;
        _lastmsgdate = [LZFormat String2Date:strDate];
    }
    else {
        _lastmsgdate = lastmsgdate;
    }
}

- (GroupResourceModel *)groupResourceModel {
    GroupResourceModel *resourceModel = [[GroupResourceModel alloc] init];
    [resourceModel serialization:self.groupresource];
    return resourceModel;
}

- (NSMutableArray<ImGroupRobotModel *> *)imGroupRobotsModels {
    NSMutableArray *tmpArr = [self.imgrouprobots serialToArr];
    NSMutableArray<ImGroupRobotModel *> *resultArr = [NSMutableArray array];
    for (NSDictionary *tmpDic in tmpArr) {
        ImGroupRobotModel *robotModel = [[ImGroupRobotModel alloc] init];
        /* 字典转model */
        [robotModel serializationWithDictionary:tmpDic];
        [resultArr addObject:robotModel];
    }
    
    return resultArr;
}

@end
