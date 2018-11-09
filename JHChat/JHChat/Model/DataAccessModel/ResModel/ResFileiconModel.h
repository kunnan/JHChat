//
//  ResFileiconModel.h
//  LeadingCloud
//
//  Created by gjh on 2017/9/20.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResFileiconModel : NSObject

/* 图片id */
@property (nonatomic, strong) NSString *iconid;
/* 图片扩展名 */
@property (nonatomic, strong) NSString *iconext;
/* 添加时间 */
@property (nonatomic, strong) NSDate *addtime;

@end
