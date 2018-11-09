//
//  WebViewAppModel.h
//  LeadingCloud
//
//  Created by wchMac on 2017/9/6.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebViewAppModel : NSObject

/* 应用码 */
@property (nonatomic, strong) NSString *appcode;

/* 0：只写入webapi  1：只写入web  2：写入webapi和web */
@property(nonatomic, assign) NSInteger mode;

@end
