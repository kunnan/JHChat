//
//  XHMessage.h
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "XHMessageModel.h"
#import "ImChatLogModel.h"
#import "FLAnimatedImage.h"

@interface XHMessage : NSObject <XHMessageModel, NSCoding, NSCopying>



@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, copy) NSString *thumbnailUrl;
@property (nonatomic, copy) LZBubbleMessageMediaTypeSmallPhoto lzSmallPhoto;
@property (nonatomic, copy) NSString *originPhotoUrl;
@property (nonatomic, copy) NSString *uploadProgress;

@property (nonatomic, strong) UIImage *videoConverPhoto;
@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, copy) NSString *videoUrl;

@property (nonatomic, copy) NSString *voicePath;
@property (nonatomic, copy) NSString *voiceUrl;
@property (nonatomic, copy) NSString *voiceDuration;

@property (nonatomic, copy) NSString *callstatus;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *channelid;

@property (nonatomic, strong) FLAnimatedImage *emotionImage;
@property (nonatomic, copy) NSString *emotionPath;
@property (nonatomic, copy) NSString *emotionFileID;
@property (nonatomic, copy) LZBubbleMessageMediaTypeSmallPhoto emotionImageBlock;

@property (nonatomic, strong) UIImage *emotionSmallImage;
@property (nonatomic, copy) NSString *emotionSmallPath;
@property (nonatomic, copy) LZBubbleMessageMediaTypeSmallPhoto emotionSmallImageBlock;


@property (nonatomic, strong) UIImage *localPositionPhoto;
@property (nonatomic, copy) NSString *geolocations;
@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, copy) NSString *faceid;
@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, copy) NSString *cardShowName;
@property (nonatomic, copy) NSString *iconName;

@property (nonatomic, copy) NSString *fileShowName;
@property (nonatomic, copy) NSString *fileIconName;
@property (nonatomic, assign) long long fileSize;

@property (nonatomic, copy) NSString *urlViewTitle;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, copy) NSString *urlViewImage;

@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareCode;

@property (nonatomic, copy) NSString *consultNotice;
@property (nonatomic, copy) NSString *noticetimeStr;

@property (nonatomic, copy) NSString *chatLogTitle;
@property (nonatomic, strong) NSMutableArray *contentArray;

@property (nonatomic, copy) NSString *systemMsg;

@property (nonatomic, copy) NSString *sender;

@property (nonatomic, strong) NSDate *timestamp;

@property (nonatomic, assign) BOOL shouldShowUserName;

@property (nonatomic, assign) BOOL sended;

@property (nonatomic, assign) XHBubbleMessageMediaType messageMediaType;

@property (nonatomic, assign) XHBubbleMessageType bubbleMessageType;

@property (nonatomic) BOOL isRead;

@property (nonatomic) BOOL isDisplayTimestamp;



/**
 *  消息发送状态
 */
@property (nonatomic, assign) NSInteger sendStatus;

@property (nonatomic, copy) NSString *sendStatusText;
@property (nonatomic) BOOL sendStatusTextIsClick;
@property (nonatomic) BOOL sendStatusTextIsHL;

/**
 *  消息数据Model
 */
@property (nonatomic, strong) ImChatLogModel *imChatLogModel;

@property (nonatomic, copy) id customMsgModel;
@property (nonatomic, copy) id customTemplateInfo;

/**
 *  初始化文本消息
 *
 *  @param text   发送的目标文本
 *  @param sender 发送者的名称
 *  @param date   发送的时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithText:(NSString *)text
                      sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp;

/**
 *  初始化图片类型的消息
 *
 *  @param photo          目标图片
 *  @param thumbnailUrl   目标图片在服务器的缩略图地址
 *  @param thumbnailBlock 下载完小图之后的回调
 *  @param originPhotoUrl 目标图片在服务器的原图地址
 *  @param sender         发送者
 *  @param date           发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithPhoto:(UIImage *)photo
                 thumbnailUrl:(NSString *)thumbnailUrl
               thumbnailBlock:(LZBubbleMessageMediaTypeSmallPhoto)smallPhotoBlock
               originPhotoUrl:(NSString *)originPhotoUrl
                       sender:(NSString *)sender
                         timestamp:(NSDate *)timestamp;

/**
 *  初始化视频类型的消息
 *
 *  @param videoConverPhoto 目标视频的封面图
 *  @param videoPath        目标视频的本地路径，如果是下载过，或者是从本地发送的时候，会存在
 *  @param videoUrl         目标视频在服务器上的地址
 *  @param sender           发送者
 *  @param date             发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVideoConverPhoto:(UIImage *)videoConverPhoto
                               videoPath:(NSString *)videoPath
                            thumbnailUrl:(NSString *)thumbnailUrl
                          thumbnailBlock:(LZBubbleMessageMediaTypeSmallPhoto)smallPhotoBlock
                                videoUrl:(NSString *)videoUrl
                                  sender:(NSString *)sender
                               timestamp:(NSDate *)timestamp;

/**
 初始化语音通话的消息
 */
- (instancetype)initWithVoiceCall:(NSString *)callstatus
                     callDuration:(NSString *)duration
                         channelid:(NSString *)channelid
                           sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp;
/**
 初始化视频通话的消息
 */
- (instancetype)initWithVideoCall:(NSString *)callstatus
                     callDuration:(NSString *)duration
                         channelid:(NSString *)channelid   
                           sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp;
/**
 *  初始化语音类型的消息
 *
 *  @param voicePath        目标语音的本地路径
 *  @param voiceUrl         目标语音在服务器的地址
 *  @param voiceDuration    目标语音的时长
 *  @param sender           发送者
 *  @param date             发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVoicePath:(NSString *)voicePath
                         voiceUrl:(NSString *)voiceUrl
                    voiceDuration:(NSString *)voiceDuration
                           sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp;

/**
 *  初始化语音类型的消息。增加已读未读标记
 *
 *  @param voicePath        目标语音的本地路径
 *  @param voiceUrl         目标语音在服务器的地址
 *  @param voiceDuration    目标语音的时长
 *  @param sender           发送者
 *  @param date             发送时间
 *  @param isRead           已读未读标记
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVoicePath:(NSString *)voicePath
                         voiceUrl:(NSString *)voiceUrl
                    voiceDuration:(NSString *)voiceDuration
                           sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp
                           isRead:(BOOL)isRead;

/**
 *  初始化gif表情类型的消息
 *
 *  @param emotionPath 表情的路径
 *  @param sender      发送者
 *  @param timestamp   发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithEmotionPath:(NSString *)emotionPath
                      emotionFileID:(NSString *)emotionFileID
                           sender:(NSString *)sender
                             timestamp:(NSDate *)timestamp;

/**
 *  初始化地理位置的消息
 *
 *  @param localPositionPhoto 地理位置默认显示的图
 *  @param geolocations       地理位置的信息
 *  @param location           地理位置的经纬度
 *  @param sender             发送者
 *  @param timestamp          发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithLocalPositionPhoto:(UIImage *)localPositionPhoto
                              geolocations:(NSString *)geolocations
                                  location:(CLLocation *)location
                          sender:(NSString *)sender
                            timestamp:(NSDate *)timestamp;

/**
 *  初始化名片类型消息
 *
 *  @param cardShowName 显示名称
 *  @param iconName     图标
 *  @param sender       发送者
 *  @param date         发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithCardShowName:(NSString *)cardShowName
                                icon:(NSString *)iconName
                              sender:(NSString *)sender
                           timestamp:(NSDate *)timestamp;

/**
 *  初始化文件类型消息
 *
 *  @param fileShowName 文件显示名称
 *  @param iconName     文件图标
 *  @param fileSize     文件大小
 *  @param sender       发送者
 *  @param timestamp    发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithFileShowName:(NSString *)fileShowName
                                icon:(NSString *)iconName
                                size:(long long)fileSize
                              sender:(NSString *)sender
                           timestamp:(NSDate *)timestamp;

/**
 初始化urlView类型消息

 @param titleName 标题
 @param iconImage 图片
 @param detailName 详细
 @param sender 发送者
 @param timestamp 时间
 @return 返回
 */
- (instancetype)initWithUrlLinkTitleName:(NSString *)titleName
                               iconImage:(NSString *)iconImage
                                  urlStr:(NSString *)urlStr
                                  sender:(NSString *)sender
                               timestamp:(NSDate *)timestamp;


/**
 初始化共享文件的
 */
- (instancetype)initWithShareMsgTitle:(NSString *)shareTitle
                            shareCode:(NSString *)shareCode
                               sender:(NSString *)sender
                            timestamp:(NSDate *)timestamp;
/**
 *  初始化系统消息
 *
 *  @param sysMsg    系统消息
 *  @param sender    发送者
 *  @param timestamp 发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithSystemMsg:(NSString *)sysMsg
                           sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp;

/**
 初始化urlView类型消息
 
 @param titleName 标题
 @param iconImage 图片
 @param detailName 详细
 @param sender 发送者
 @param timestamp 时间
 @return 返回
 */
- (instancetype)initWithChatLogTitle:(NSString *)chatLogTitle
                        contentArray:(NSMutableArray *)contentArray
                              sender:(NSString *)sender
                           timestamp:(NSDate *)timestamp;
/**
 *  初始化业务会话咨询消息
 *
 *  @param sysMsg    系统消息
 *  @param sender    发送者
 *  @param timestamp 发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithConsultNoticeMsg:(NSString *)noticetitle
                                 timestr:(NSString *)timeStr
                                  sender:(NSString *)sender
                               timestamp:(NSDate *)timestamp;
/**
 *  自定义消息类型
 *
 *  @param msgModel  消息数据
 *  @param sender    发送者
 *  @param timestamp 发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithCustomMsg:(id)msgModel
               customTemplateInfo:(id)customTemplateInfo
                           sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp;

@end
