//
//  PostModel.m
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "PostModel.h"

@implementation PostModel

-(id)init{
    self=[super init];
    if (self) {
        
        self.replypostlist=[NSMutableArray array];
        self.tagdata=[NSMutableArray array];
        self.rosourlist=[NSMutableArray array];
        self.posttemplatedatadic=[NSDictionary dictionary];
        self.prainseusername=[NSMutableArray array];
        self.postfavorite=[NSDictionary dictionary];
        self.expanddatadic=[NSDictionary dictionary];

    }
    return self;
}

-(void)setReleasedate:(NSDate *)releasedate{
    if([releasedate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)releasedate;
        _releasedate = [LZFormat String2Date:strDate];
    }
    else {
        _releasedate = releasedate;
    }
}


@end
