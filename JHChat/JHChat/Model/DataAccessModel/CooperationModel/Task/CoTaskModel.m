//
//  CoTaskModel.m
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "CoTaskModel.h"

@implementation CoTaskModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.des = [NSString string];
    }
    return self;
    
}
-(void)setPlandate:(NSDate *)plandate{
    if([plandate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)plandate;
        _plandate = [LZFormat String2SystemDate:strDate];
    }
    else {
        _plandate = plandate;
    }
}

-(void)setEnddate:(NSDate *)enddate{
    if([enddate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)enddate;
        _enddate = [LZFormat String2SystemDate:strDate];
    }
    else {
        _enddate = enddate;
    }
}


-(void)setCreatedate:(NSDate *)createdate{
    if([createdate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)createdate;
        _createdate = [LZFormat String2SystemDate:strDate];
    }
    else {
        _createdate = createdate;
    }
}

-(void)setLockdate:(NSDate *)lockdate{
    
    if([lockdate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)lockdate;
        _lockdate = [LZFormat String2SystemDate:strDate];
    }
    else {
        _lockdate = lockdate;
    }

}

-(void)setDes:(NSString *)des{
    
    if (des && [des length]!=0) {
        
        _des =des;
    }else{
        _des = [NSString string];
    }
}

- (void)setPname:(NSString *)pname{
    if (pname && [pname length]!=0) {
        
        _pname =pname;
    }else{
        _pname = [NSString string];
    }
}

- (void)setRootid:(NSString *)rootid{
    
    if (rootid && [rootid length]!=0) {
        
        _rootid =rootid;
    }else{
        _rootid = [NSString string];
    }

}
@end
