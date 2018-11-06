//
//  ChatSettingChangeBackGroundDelegate.h
//  LeadingCloud
//
//  Created by gjh on 16/11/10.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChatSettingChangeBackGroundDelegate <NSObject>

/**
 改变聊天窗口的背景图片

 @param selectImage 背景图片
 */
- (void)setChangeChatViewControllerBackGround:(NSString *)filePhysicalName;

@end
