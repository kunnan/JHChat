//
//  ImChatLogBodyInnerModel.h
//  LeadingCloud
//
//  Created by wchMac on 16/2/1.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

/**
 *  Body的Model
 */
@interface ImChatLogBodyInnerModel : NSObject

/* 消息模板主键 */
@property(nonatomic,assign) NSInteger templateid;

/* 文件名称 */
@property(nonatomic,strong) NSString *name;
/* 文件大小 */
@property(nonatomic,assign) long long size;
/* 文件icon */
@property(nonatomic,strong) NSString *icon;
/* 类型 */
@property(nonatomic,strong) NSString *type;
/* 文件ID */
@property(nonatomic,strong) NSString *fileid;
/* height */
@property(nonatomic,assign) CGFloat height;
/* width */
@property(nonatomic,assign) CGFloat width;
/* 是否为资源包 */
@property(nonatomic,strong) NSString *isresource;
/* 资源id */
@property(nonatomic,strong) NSString *rid;
/* 资源版本 */
@property(nonatomic,assign) NSInteger rversion;


/* 名片,用户ID */
@property(nonatomic,strong) NSString *uid;
/* 名片,用户姓名 */
@property(nonatomic,strong) NSString *username;
/* 名片,用户头像ID */
@property(nonatomic,strong) NSString *face;

/* 语音,时间长度 */
@property(nonatomic,strong) NSString *duration;
/* 是否已读 */
@property(nonatomic,assign) BOOL status;


/* 地图缩放比例 */
@property(nonatomic,assign) CGFloat geozoom;
/* 经度 */
@property(nonatomic,assign) CGFloat geolongitude;
/* 纬度 */
@property(nonatomic,assign) CGFloat geolatitude;
/* 地址 */
@property(nonatomic,strong) NSString *geoaddress;
/* 具体位置 */
@property(nonatomic,strong) NSString *geodetailposition;

/* @的人员uid */
@property(nonatomic,strong) NSString *lzremindlist;

/* 呼叫状态 */
@property(nonatomic,strong) NSString *callstatus;

/* 房间id */
@property (nonatomic, strong) NSString *channelid;
/* url的标题 */
@property (nonatomic, strong) NSString *urltitle;
/* url */
@property (nonatomic, strong) NSString *urlstr;
/* url图片 */
@property (nonatomic, strong) NSString *urlimage;

/* 分享的标题 */
@property (nonatomic, strong) NSString *sharetitle;
/* 分享码 */
@property (nonatomic, strong) NSString *sharecode;

/* 合并聊天记录的标题 */
@property (nonatomic, strong) NSString *title;
/* 合并聊天记录的内容 */
@property (nonatomic, strong) NSString *chatlog;

- (NSMutableArray *)chatlogArr;

@end


/**
 *  文件信息Model
 */
@interface ImChatLogBodyFileModel : NSObject

/* 图片名称 */
@property(nonatomic,strong) NSString *smalliconclientname;
/* 宽度 */
@property(nonatomic,assign) CGFloat smalliconwidth;
/* 高度 */
@property(nonatomic,assign) CGFloat smalliconheight;

/* 文件名称 */
@property(nonatomic,strong) NSString *smallfileclientname;

/* 视频名称 */
@property (nonatomic, copy) NSString *smallvideoclientname;

@end


/**
 *  语音信息Model
 */
@interface ImChatLogBodyVoiceModel : NSObject

/* wav格式的文件名称 */
@property(nonatomic,strong) NSString *wavname;
/* ARM格式的文件名称 */
@property(nonatomic,strong) NSString *amrname;
/* 是否下载 */
@property(nonatomic,assign) BOOL voiceIsDown;
/* 是否下载失败 */
@property(nonatomic,assign) BOOL voiceIsDownFail;
/* 是否转换 */
@property(nonatomic,assign) BOOL voiceIsConvert;

@end



/**
 *  位置信息Model
 */
@interface ImChatLogBodyGeolocationModel : NSObject

/* 地理位置图片名称 */
@property(nonatomic,strong) NSString *geoimagename;

@end


/**
 *  已读信息Model
 */
@interface ImChatLogBodyReadStatusModel : NSObject

/* 未读人数，0表示全部已读 */
@property(nonatomic,assign) NSInteger unreadcount;

/* 总人数 */
@property(nonatomic,assign) NSInteger count;

/* 未读人员数组 */
@property(nonatomic,strong) NSMutableDictionary *unreaduserlist;

///* 已读人员数组 */
@property(nonatomic,strong) NSMutableDictionary *readuserlist;

@end
