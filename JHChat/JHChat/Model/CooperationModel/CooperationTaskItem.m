//
//  CooperationTaskItem.m
//  LeadingCloud
//
//  Created by wnngxzhibin on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "CooperationTaskItem.h"

@implementation CooperationTaskItem

-(id)init{
    
    self=[super init];
    
    if (self) {
        self.childArray=[NSMutableArray array];
        self.memberArray=[NSMutableArray array];
        self.parentName = [NSString string];
        self.rootname = [NSString string];
        self.taskDesciption = [NSString string];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
