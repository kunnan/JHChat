//
//  ShareActivityModel.h
//  LeadingCloud
//
//  Created by SY on 2017/5/24.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ShareType_NetPage @"sharetype_netpage"
#define ShareType_Image @"sharetype_image"
#define ShareType_Text @"sharetype_text"
#define ShareType_Video @"sharetype_Video"
#define ShareType_File @"sharetype_file"

@interface ShareActivityModel : NSObject

@property (nonatomic, strong) UIActivityViewController *activityVC;
@property (nonatomic, strong)  NSString *shareTag;
/**
 分享网页
 
 @param text title
 @param imageArr 图片
 @param shareUrl url
 @param controller 当前控制器
 */
-(void)shareWithText:(NSString*)text image:(UIImage*)image url:(NSURL*)shareUrl controller:(UIViewController*)controller;
/**
 文件分享
 
 @param text title
 @param image iamge
 @param controller 当前图片
 */
-(void)shareWithDataArr:(NSMutableArray*)array controller:(UIViewController*)controller;
@end
