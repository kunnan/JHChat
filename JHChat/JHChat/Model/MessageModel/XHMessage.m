//
//  XHMessage.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessage.h"

@implementation XHMessage

- (void)setBubbleMessageType:(XHBubbleMessageType)bubbleMessageType {
    _bubbleMessageType = bubbleMessageType;
}

- (instancetype)initWithText:(NSString *)text
                      sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp {
    self = [super init];
    if (self) {
        self.text = text;
        
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.messageMediaType = XHBubbleMessageMediaTypeText;
    }
    return self;
}

/**
 初始化语音通话的消息
 */
- (instancetype)initWithVoiceCall:(NSString *)callstatus
                     callDuration:(NSString *)duration
                         channelid:(NSString *)channelid
                           sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp {
    self = [super init];
    if (self) {
        self.callstatus = callstatus;
        self.duration = duration;
        self.channelid = channelid;
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.messageMediaType = XHBubbleMessageMediaTypeVoiceCall;
    }
    return self;
}
/**
 初始化视频通话的消息
 */
- (instancetype)initWithVideoCall:(NSString *)callstatus
                     callDuration:(NSString *)duration
                         channelid:(NSString *)channelid
                           sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp {
    self = [super init];
    if (self) {
        self.callstatus = callstatus;
        self.duration = duration;
        self.channelid = channelid;
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.messageMediaType = XHBubbleMessageMediaTypeVideoCall;
    }
    return self;
}
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
                    timestamp:(NSDate *)timestamp{
    
    self = [super init];
    if (self) {
        self.photo = photo;
        self.thumbnailUrl = thumbnailUrl;
        self.lzSmallPhoto = smallPhotoBlock;
        self.originPhotoUrl = originPhotoUrl;
        
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.messageMediaType = XHBubbleMessageMediaTypePhoto;
    }
    return self;
}

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
                                    timestamp:(NSDate *)timestamp {
    self = [super init];
    if (self) {
        self.videoConverPhoto = videoConverPhoto;
        self.videoPath = videoPath;
        self.videoUrl = videoUrl;
        self.thumbnailUrl = thumbnailUrl;
        self.lzSmallPhoto = smallPhotoBlock;
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.messageMediaType = XHBubbleMessageMediaTypeVideo;
    }
    return self;
}

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
                        timestamp:(NSDate *)timestamp {
    
    return [self initWithVoicePath:voicePath voiceUrl:voiceUrl voiceDuration:voiceDuration sender:sender timestamp:timestamp isRead:YES];
}

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
                           isRead:(BOOL)isRead {
    self = [super init];
    if (self) {
        self.voicePath = voicePath;
        self.voiceUrl = voiceUrl;
        self.voiceDuration = voiceDuration;
        
        self.sender = sender;
        self.timestamp = timestamp;
        self.isRead = isRead;
        
        self.messageMediaType = XHBubbleMessageMediaTypeVoice;
    }
    return self;
}

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
                          timestamp:(NSDate *)timestamp {
    self = [super init];
    if (self) {
        self.emotionPath = emotionPath;
        self.emotionFileID = emotionFileID;
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.messageMediaType = XHBubbleMessageMediaTypeEmotion;
    }
    return self;
}

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
                                 timestamp:(NSDate *)timestamp {
    self = [super init];
    if (self) {
        self.localPositionPhoto = localPositionPhoto;
        self.geolocations = geolocations;
        self.location = location;
        
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.messageMediaType = XHBubbleMessageMediaTypeLocalPosition;
    }
    return self;
}

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
                           timestamp:(NSDate *)timestamp {
    self = [super init];
    if (self) {
        self.cardShowName = cardShowName;
        self.iconName = iconName;
        
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.messageMediaType = XHBubbleMessageMediaTypeCard;
    }
    return self;
}

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
                           timestamp:(NSDate *)timestamp{
    self = [super init];
    if (self) {
        self.fileIconName = iconName;
        self.fileShowName = fileShowName;
        self.fileSize = fileSize;
        
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.messageMediaType = XHBubbleMessageMediaTypeFile;
    }
    return self;
}
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
                               timestamp:(NSDate *)timestamp{
    self = [super init];
    if (self) {
        self.urlViewImage = iconImage;
        self.urlViewTitle = titleName;
        self.urlStr = urlStr;
        
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.messageMediaType = XHBubbleMessageMediaTypeUrl;
    }
    return self;
}

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
                               timestamp:(NSDate *)timestamp{
    self = [super init];
    if (self) {
        self.chatLogTitle = chatLogTitle;
        self.contentArray = contentArray;
        
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.messageMediaType = XHBubbleMessageMediaTypeChatLog;
    }
    return self;
}

/**
 初始化共享文件的
 */
- (instancetype)initWithShareMsgTitle:(NSString *)shareTitle
                            shareCode:(NSString *)shareCode
                               sender:(NSString *)sender
                            timestamp:(NSDate *)timestamp {
    self = [super init];
    if (self) {
        self.shareTitle = shareTitle;
        self.shareCode = shareCode;
        self.sender = sender;
        self.timestamp = timestamp;
        self.messageMediaType = XHBubbleMessageMediaTypeShare;
    }
    return self;
}
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
                        timestamp:(NSDate *)timestamp{
    self = [super init];
    if (self) {
        self.systemMsg = sysMsg;
        
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.messageMediaType = XHBubbleMessageMediaSystemMsg;
    }
    return self;
}
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
                               timestamp:(NSDate *)timestamp{
    self = [super init];
    if (self) {
        self.consultNotice = noticetitle;
        self.noticetimeStr = timeStr;
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.messageMediaType = XHBubbleMessageMediaTypeConsultNotice;
    }
    return self;
}

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
                        timestamp:(NSDate *)timestamp{
    self = [super init];
    if (self) {
        self.customMsgModel = msgModel;
        self.customTemplateInfo = customTemplateInfo;
        self.sender = sender;
        self.timestamp = timestamp;
        
        self.messageMediaType = XHBubbleMessageMediaCustomMsg;
    }
    return self;
}


- (void)dealloc {
    _text = nil;
    
    _photo = nil;
    _thumbnailUrl = nil;
    _originPhotoUrl = nil;
    
    _videoConverPhoto = nil;
    _videoPath = nil;
    _videoUrl = nil;
    
    _voicePath = nil;
    _voiceUrl = nil;
    _voiceDuration = nil;
    
    _callstatus = nil;
    _duration = nil;
    _channelid = nil;
    
    _emotionPath = nil;
    _emotionFileID = nil;
    
    _localPositionPhoto = nil;
    _geolocations = nil;
    _location = nil;
    
    _avatar = nil;
    _avatarUrl = nil;
    
    _cardShowName = nil;
    _iconName = nil;
    
    _fileIconName = nil;
    _fileShowName = nil;
    
    _urlViewImage = nil;
    _urlViewTitle = nil;
    _urlStr = nil;
    
    _shareCode = nil;
    _shareTitle = nil;
    
    _consultNotice = nil;
    
    _sender = nil;
    
    _timestamp = nil;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _text = [aDecoder decodeObjectForKey:@"text"];
        
        _photo = [aDecoder decodeObjectForKey:@"photo"];
        _thumbnailUrl = [aDecoder decodeObjectForKey:@"thumbnailUrl"];
        _originPhotoUrl = [aDecoder decodeObjectForKey:@"originPhotoUrl"];
        
        _videoConverPhoto = [aDecoder decodeObjectForKey:@"videoConverPhoto"];
        _videoPath = [aDecoder decodeObjectForKey:@"videoPath"];
        _videoUrl = [aDecoder decodeObjectForKey:@"videoUrl"];
        
        _voicePath = [aDecoder decodeObjectForKey:@"voicePath"];
        _voiceUrl = [aDecoder decodeObjectForKey:@"voiceUrl"];
        _voiceDuration = [aDecoder decodeObjectForKey:@"voiceDuration"];
        
        _callstatus = [aDecoder decodeObjectForKey:@"callstatus"];
        _duration = [aDecoder decodeObjectForKey:@"duration"];
        _channelid = [aDecoder decodeObjectForKey:@"channelid"];
        
        _emotionPath = [aDecoder decodeObjectForKey:@"emotionPath"];
        _emotionFileID = [aDecoder decodeObjectForKey:@"emotionFileID"];
        
        _localPositionPhoto = [aDecoder decodeObjectForKey:@"localPositionPhoto"];
        _geolocations = [aDecoder decodeObjectForKey:@"geolocations"];
        _location = [aDecoder decodeObjectForKey:@"location"];
        
        _avatar = [aDecoder decodeObjectForKey:@"avatar"];
        _avatarUrl = [aDecoder decodeObjectForKey:@"avatarUrl"];
        
        _sender = [aDecoder decodeObjectForKey:@"sender"];
        _timestamp = [aDecoder decodeObjectForKey:@"timestamp"];
      
        _messageMediaType = [[aDecoder decodeObjectForKey:@"messageMediaType"] integerValue];
        _bubbleMessageType = [[aDecoder decodeObjectForKey:@"bubbleMessageType"] integerValue];
        _isRead = [[aDecoder decodeObjectForKey:@"isRead"] boolValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.text forKey:@"text"];
    
    [aCoder encodeObject:self.photo forKey:@"photo"];
    [aCoder encodeObject:self.thumbnailUrl forKey:@"thumbnailUrl"];
    [aCoder encodeObject:self.originPhotoUrl forKey:@"originPhotoUrl"];
    
    [aCoder encodeObject:self.videoConverPhoto forKey:@"videoConverPhoto"];
    [aCoder encodeObject:self.videoPath forKey:@"videoPath"];
    [aCoder encodeObject:self.videoUrl forKey:@"videoUrl"];
    
    [aCoder encodeObject:self.callstatus forKey:@"callstatus"];
    [aCoder encodeObject:self.duration forKey:@"duration"];
    [aCoder encodeObject:self.channelid forKey:@"channelid"];
    
    [aCoder encodeObject:self.voicePath forKey:@"voicePath"];
    [aCoder encodeObject:self.voiceUrl forKey:@"voiceUrl"];
    [aCoder encodeObject:self.voiceDuration forKey:@"voiceDuration"];
    
    [aCoder encodeObject:self.emotionPath forKey:@"emotionPath"];
    [aCoder encodeObject:self.emotionFileID forKey:@"emotionFileID"];
    
    [aCoder encodeObject:self.localPositionPhoto forKey:@"localPositionPhoto"];
    [aCoder encodeObject:self.geolocations forKey:@"geolocations"];
    [aCoder encodeObject:self.location forKey:@"location"];

    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.avatarUrl forKey:@"avatarUrl"];
    
    
    [aCoder encodeObject:self.sender forKey:@"sender"];
    [aCoder encodeObject:self.timestamp forKey:@"timestamp"];
  
    [aCoder encodeObject:[NSNumber numberWithInteger:self.messageMediaType] forKey:@"messageMediaType"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.bubbleMessageType] forKey:@"bubbleMessageType"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isRead] forKey:@"isRead"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    switch (self.messageMediaType) {
        case XHBubbleMessageMediaTypeText:
            return [[[self class] allocWithZone:zone] initWithText:[self.text copy]
                                                            sender:[self.sender copy]
                                                              timestamp:[self.timestamp copy]];
        case XHBubbleMessageMediaTypePhoto:
            return [[[self class] allocWithZone:zone] initWithPhoto:[self.photo copy]
                                                       thumbnailUrl:[self.thumbnailUrl copy]
                                                     thumbnailBlock:[self.lzSmallPhoto copy]
                                                     originPhotoUrl:[self.originPhotoUrl copy]
                                                             sender:[self.sender copy]
                                                               timestamp:[self.timestamp copy]];
        case XHBubbleMessageMediaTypeVideo:
            return [[[self class] allocWithZone:zone] initWithVideoConverPhoto:[self.videoConverPhoto copy]
                                                                     videoPath:[self.videoPath copy]
                                                                  thumbnailUrl:[self.thumbnailUrl copy]
                                                                thumbnailBlock:[self.lzSmallPhoto copy]
                                                                      videoUrl:[self.videoUrl copy]
                                                                        sender:[self.sender copy]
                                                                          timestamp:[self.timestamp copy]];
        case XHBubbleMessageMediaTypeVoiceCall:
            return [[[self class] allocWithZone:zone] initWithVoiceCall:[self.callstatus copy]
                                                           callDuration:[self.duration copy]
                                                               channelid:[self.channelid copy]
                                                                 sender:[self.sender copy]
                                                              timestamp:[self.timestamp copy]];
        case XHBubbleMessageMediaTypeVideoCall:
            return [[[self class] allocWithZone:zone] initWithVideoCall:[self.callstatus copy]
                                                           callDuration:[self.duration copy]
                                                               channelid:[self.channelid copy]
                                                                 sender:[self.sender copy]
                                                              timestamp:[self.timestamp copy]];
        case XHBubbleMessageMediaTypeVoice:
            return [[[self class] allocWithZone:zone] initWithVoicePath:[self.voicePath copy]
                                                               voiceUrl:[self.voiceUrl copy]
                                                          voiceDuration:[self.voiceDuration copy]
                                                                 sender:[self.sender copy]
                                                              timestamp:[self.timestamp copy]];
        case XHBubbleMessageMediaTypeEmotion:
            return [[[self class] allocWithZone:zone] initWithEmotionPath:[self.emotionPath copy]
                                                            emotionFileID:[self.emotionFileID copy]
                                                                sender:[self.sender copy]
                                                                  timestamp:[self.timestamp copy]];
        case XHBubbleMessageMediaTypeLocalPosition:
            return [[[self class] allocWithZone:zone] initWithLocalPositionPhoto:[self.localPositionPhoto copy]
                                                                    geolocations:self.geolocations
                                                                        location:[self.location copy]
                                                                          sender:[self.sender copy]
                                                                       timestamp:[self.timestamp copy]];
        case XHBubbleMessageMediaTypeCard:
            return [[[self class] allocWithZone:zone] initWithCardShowName:[self.cardShowName copy]
                                                                      icon:[self.cardShowName copy]
                                                                    sender:[self.sender copy]
                                                                 timestamp:[self.timestamp copy]];
//        case XHBubbleMessageMediaTypeShare:
//            return [[[self class] allocWithZone:zone] initWithShareMsgTitle:[self.shareTitle copy]
//                                                                  shareCode:[self.shareCode copy]
//                                                                     sender:[self.sender copy]
//                                                                  timestamp:[self.timestamp copy]];
        case XHBubbleMessageMediaTypeFile:
            return [[[self class] allocWithZone:zone] initWithFileShowName:[self.fileShowName copy]
                                                                      icon:[self.fileShowName copy]
                                                                      size:self.fileSize
                                                                    sender:[self.sender copy]
                                                                 timestamp:[self.timestamp copy]];
        case XHBubbleMessageMediaTypeUrl:
            return [[[self class] allocWithZone:zone] initWithUrlLinkTitleName:[self.urlViewTitle copy]
                                                                     iconImage:[self.urlViewImage copy]
                                                                        urlStr:[self.urlStr copy]
                                                                        sender:[self.sender copy]
                                                                     timestamp:[self.timestamp copy]];
        case XHBubbleMessageMediaTypeChatLog:
            return [[[self class] allocWithZone:zone] initWithChatLogTitle:[self.chatLogTitle copy]
                                                              contentArray:[self.contentArray copy]
                                                                    sender:[self.sender copy]
                                                                 timestamp:[self.timestamp copy]];
        case XHBubbleMessageMediaSystemMsg:
            return [[[self class] allocWithZone:zone] initWithSystemMsg:[self.systemMsg copy]
                                                                 sender:[self.sender copy]
                                                              timestamp:[self.timestamp copy]];
            
        case XHBubbleMessageMediaCustomMsg:
            return [[[self class] allocWithZone:zone] initWithCustomMsg:[self.customMsgModel copy]
                                                     customTemplateInfo:[self.customTemplateInfo copy]
                                                                 sender:[self.sender copy]
                                                              timestamp:[self.timestamp copy]];
            
        case XHBubbleMessageMediaTypeConsultNotice:
            return [[[self class] allocWithZone:zone] initWithConsultNoticeMsg:[self.consultNotice copy]
                                                                       timestr:[self.noticetimeStr copy]
                                                                        sender:[self.sender copy]
                                                                     timestamp:[self.timestamp copy]];
            
        default:
            return nil;
    }
}

@end
