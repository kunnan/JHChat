//
//  XHMessageModel.h
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "XHMessageBubbleFactory.h"
#import "ImChatLogModel.h"
#import "FLAnimatedImage.h"

/**
 *  图片类型，下载完缩略图之后的回调
 */
typedef void (^LZBubbleMessageMediaTypeSmallPhoto)(UIImage *image, NSData *data, NSError *error, BOOL finished);

@class XHMessage;
//@block LZBubbleMessageMediaTypeSmallPhoto;

@protocol XHMessageModel <NSObject>

@required
- (NSString *)text;

- (UIImage *)photo;
- (void)setPhoto:(UIImage *)photo;
- (NSString *)thumbnailUrl;
- (LZBubbleMessageMediaTypeSmallPhoto)lzSmallPhoto;
- (NSString *)originPhotoUrl;
- (NSString *)uploadProgress;

- (UIImage *)videoConverPhoto;
- (NSString *)videoPath;
- (NSString *)videoUrl;

- (NSString *)voicePath;
- (NSString *)voiceUrl;
- (NSString *)voiceDuration;

- (NSString *)callstatus;
- (NSString *)duration;
- (NSString *)channelid;

- (UIImage *)localPositionPhoto;
- (NSString *)geolocations;
- (CLLocation *)location;

- (FLAnimatedImage *)emotionImage;
- (NSString *)emotionPath;
- (NSString *)emotionFileID;
- (LZBubbleMessageMediaTypeSmallPhoto)emotionImageBlock;

- (UIImage *)emotionSmallImage;
- (NSString *)emotionSmallPath;
- (LZBubbleMessageMediaTypeSmallPhoto)emotionSmallImageBlock;

- (NSString *)faceid;
- (UIImage *)avatar;
- (NSString *)avatarUrl;

- (NSString *)cardShowName;
- (NSString *)iconName;

- (NSString *)fileShowName;
- (NSString *)fileIconName;
- (long)fileSize;

- (NSString *)urlViewTitle;
- (NSString *)urlStr;
- (NSString *)urlViewImage;

- (NSString *)consultNotice;
- (NSString *)noticetimeStr;

- (NSString *)systemMsg;

- (XHBubbleMessageMediaType)messageMediaType;

- (XHBubbleMessageType)bubbleMessageType;

@optional

- (BOOL)shouldShowUserName;

- (NSString *)sender;

- (NSDate *)timestamp;

- (BOOL)isRead;
- (void)setIsRead:(BOOL)isRead;

- (NSInteger)sendStatus;
- (NSString *)sendStatusText;
- (BOOL)sendStatusTextIsClick;
- (BOOL)sendStatusTextIsHL;

- (ImChatLogModel *)imChatLogModel;

- (id)customMsgModel;
- (id)customTemplateInfo;



@end

