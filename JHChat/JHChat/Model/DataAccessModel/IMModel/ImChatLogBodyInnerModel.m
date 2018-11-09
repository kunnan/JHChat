//
//  ImChatLogBodyInnerModel.m
//  LeadingCloud
//
//  Created by wchMac on 16/2/1.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "ImChatLogBodyInnerModel.h"
#import "NSString+SerialToArray.h"

/**
 *  Body的Model
 */
@implementation ImChatLogBodyInnerModel

- (NSMutableArray *)chatlogArr{
    return [self.chatlog serialToArr];
}

@end

/**
 *  文件信息Model
 */
@implementation ImChatLogBodyFileModel

@end

/**
 *  语音信息Model
 */
@implementation ImChatLogBodyVoiceModel

@end

/**
 *  位置信息Model
 */
@implementation ImChatLogBodyGeolocationModel

@end

/**
 *  已读信息Model
 */
@implementation ImChatLogBodyReadStatusModel

@end
