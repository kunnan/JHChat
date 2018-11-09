//
//  CooLayoutModel.m
//  LeadingCloud
//
//  Created by SY on 16/5/6.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CooLayoutModel.h"
#import "NSObject+JsonSerial.h"
@implementation CooLayoutModel


/**
 getter方法
 */
-(CooLayoutInfoModel *)layoutInfoModel{
    
    CooLayoutInfoModel *layoutBady = [[CooLayoutInfoModel alloc] init];
    // 把json字典给CooLayoutInfoModel里面的属性
    [layoutBady serializationWithDictionary:self.layout];
    return layoutBady;
}
-(CooGroupLayoutInfoModel *)groupLayoutModel {
    CooGroupLayoutInfoModel *groupLayout = [[CooGroupLayoutInfoModel alloc] init];
    [groupLayout serializationWithDictionary:self.layout];
    return groupLayout;
}

@end
