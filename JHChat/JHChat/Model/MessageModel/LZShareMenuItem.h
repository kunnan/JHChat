//
//  LZShareMenuItem.h
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

#import <Foundation/Foundation.h>

@interface LZShareMenuItem : NSObject

/* 正常显示图片 */
@property(nonatomic,strong) NSString *normalImg;
/* 高亮显示图片 */
@property(nonatomic,strong) NSString *hlImg;
/* 标题 */
@property(nonatomic,strong) NSString *title;

- (instancetype)initWithNormalImageName:(NSString *)normalImg
                            hlImageName:(NSString *)hlImg
                                  title:(NSString *)title;

@end
