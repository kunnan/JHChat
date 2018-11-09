//
//  ContactSelectParamsModel.m
//  LeadingCloud
//
//  Created by wchMac on 16/5/30.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "ContactSelectParamsModel.h"
#import "UserModel.h"

@implementation ContactSelectParamsModel

- (instancetype)init{
    
    self = [super init];
    if (self) {
        self.disableSelectedUsers = [NSMutableArray array];
    }
    return self;
}

-(NSMutableArray *)selectedUserModels{
    if(_selectedUserModels.count==0){
        return [[NSMutableArray alloc] init];
    }
    return _selectedUserModels;
}

-(void)setDisableSelectedUsers:(NSMutableArray *)disableSelectedUsers{
    if(disableSelectedUsers && disableSelectedUsers.count > 0){
        id data = [disableSelectedUsers objectAtIndex:0];
        if( [data isKindOfClass:[NSString class]] ){
            _disableSelectedUsers = disableSelectedUsers;
        } else {
            _disableSelectedUsers = [disableSelectedUsers valueForKeyPath:@"uid"];
        }
    }
    else {
        _disableSelectedUsers = disableSelectedUsers;
    }
}

@end
