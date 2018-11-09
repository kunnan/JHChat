//
//  LZShareMenuItem.m
//  LeadingCloud
//
//  Created by wchMac on 16/1/4.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2015-01-04
 Version: 1.0
 Description: 更过功能项Model
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZShareMenuItem.h"

@implementation LZShareMenuItem

- (instancetype)initWithNormalImageName:(NSString *)normalImg
                            hlImageName:(NSString *)hlImg
                                  title:(NSString *)title {
    self = [super init];
    if (self) {
        self.normalImg = normalImg;
        self.hlImg = hlImg;
        self.title = title;
    }
    return self;
}

- (void)dealloc {
    self.normalImg = nil;
    self.hlImg = nil;
    self.title = nil;
}

@end
