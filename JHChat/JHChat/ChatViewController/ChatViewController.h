//
//  ChatViewController.h
//  LeadingCloud
//
//  Created by wchMac on 15/11/25.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2015-11-16
 Version: 1.0
 Description: 聊天界面
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "XHMessageTableViewController.h"
#import "UINavigationController+LZExpand.h"
#import "NetIndexFileSelectViewController.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "UploadFileModel.h"


typedef void (^ChatViewDidAppearBlock)();

typedef void (^ChatViewButton2ClickBlock)(ChatViewController *chatVC);

@class ContactTableViewCellModel;
@class UserModel, TZAlbumModel;
@interface ChatViewController : XHMessageTableViewController<EventSyncSubscriber,NetIndexFileSelectDelegate,MWPhotoBrowserDelegate>

/**
 *  下拉是否可以继续加载
 */
@property (nonatomic, assign) BOOL existsMoreDateForLoading;

@property (nonatomic, assign) NSInteger contactType;  //聊天框类型
@property (copy, nonatomic) NSString *dialogid;     //对话框ID
@property (copy, nonatomic) NSString *popToViewController;   //返回的控制器

@property (copy, nonatomic) ChatViewDidAppearBlock chatViewDidAppearBlock;

//@property (assign, nonatomic) NSInteger sendMode;   //sendmode值
@property (nonatomic, assign) NSInteger sendToType;  //聊天框类型
@property (copy, nonatomic) NSString *appCode; //发送消息的应用Code
@property (copy, nonatomic) NSString *isShowSetting; //是否显示设置按钮

@property (copy, nonatomic) NSString *bkid; //业务ID
@property (nonatomic, assign) NSInteger parsetype;  //消息解析类型 0：顶级，1：二级

@property (nonatomic, assign) BOOL isPopToMsgTab; //转发后，点击返回是否返回到消息页签

@property (nonatomic, assign) BOOL isNotShowOpenWorkGroupBtn; // 是否显示右上角打开工作圈的按钮

@property (nonatomic, assign) BOOL isNotAllowSlideBack; //是否不允许右划返回

/* 需要用到的导航栏左侧“取消”按钮 */
@property (nonatomic, strong) UIView *leftButtonView;

/* 群组的标题 */
@property (nonatomic, strong) UILabel *num;
@property (nonatomic, strong) UILabel *nameText;
@property (nonatomic, strong) UIView *titleView;

/* 自定义右上角按钮 */
@property (copy, nonatomic) NSString *customButton1Img;
@property (copy, nonatomic) NSString *customButton2Img;
@property (copy, nonatomic) ChatViewButton2ClickBlock chatViewButton2ClickBlock;
/* 自定义按钮点击事件交互 */
@property (nonatomic, assign) BOOL isCustomBtnClickExchange;

@property (nonatomic, strong) NSDictionary *tempContex;

/**
 *  解析消息的串行队列
 */
#if OS_OBJECT_USE_OBJC
@property (strong, nonatomic) dispatch_queue_t chatQueue;
#else
@property (assign, nonatomic) dispatch_queue_t chatQueue;
#endif

#pragma mark - 数据获取

/**
 *  页面显示之后加载数据
 */
- (void)loadInitChatLog:(BOOL)isViewDidLoad newBottomMsgs:(NSMutableArray *)newMsgids;

/**
 *  刷新数据
 */
- (void)reloadNavigationData;

/**
 *  刷新数字
 */
-(void)refreshUnreadCount;

#pragma mark - 发送消息

/**
 *  发送文本消息
 *
 *  @param text 消息内容
 */
- (void)didSendTextAction:(NSString *)text;

/**
 多人通话消息发送
 */
- (void)sendVideoCallForGroup:(NSString *)status userArr:(NSMutableArray *)userArr channelid:(NSString *)channelid other:(NSDictionary *)other;

/**
 *  发送语音
 *
 *  @param voicePath     文件路径
 *  @param voiceName     文件名称
 *  @param voiceDuration 时间长度
 */
- (void)didSendMessageWithVoice:(NSString *)voicePath name:(NSString *)voiceName voiceDuration:(NSString*)voiceDuration;

/**
 *  发送拍照、图片
 *
 *  @param sendArr   发送图片数组
 */
- (void)didSendAblumAction:(NSMutableArray *)sendArr;

/**
 *  发送视频（上传物理文件）
 *
 *  @param sendArr   发送视频数组
 *  @param outputPath   发送视频物理位置
 */
- (void)didSendVideoActionCoverName:(NSString *)coverName filePhysicalName:(NSString *)filePhysicalName;

/**
 *  转发，当前人发出的图片
 *  （msgid,clientTempId,filePath,filePhysicalName） （filePath,filePhysicalName,field,fileShowName）
 */
- (void)didResendAblumWithMsgId:(NSString *)msgid clienttempid:(NSString *)clientTempId filePath:(NSString *)filePath filePhysicalName:(NSString *)filePhysicalName fileid:(NSString *)fileid fileShowName:(NSString *)fileShowName;

/**
 *  转发，消息模板类型消息
 */
- (void)didResendCustomMsg:(ImChatLogModel *)imChatLogModel;

/**
 *  发送云盘文件
 *
 *  @param text 消息内容
 */
- (void)didSendNetDiskFile:(ResModel *)resModel;

/**
 *  发送文件（上传物理文件）
 *
 *  @param sendArr   发送文件数组
 */
- (void)didSendFileAction:(NSMutableArray *)sendArr;

/**
 *  发送名片
 *
 *  @param text 消息内容
 */
- (void)didSendCard:(UserModel *)userModel;

/**
 发送url链接视图
 
 @param urlTitle
 */
- (void)didSendUrlLink:(NSString *)urlTitle urlStr:(NSString *)urlStr urlImage:(NSString *)urlImage;

/**
 发送共享文件消息
 
 @param shareTitle 标题
 @param shareCode 共享码
 */
- (void)didSendShareMsg:(NSMutableDictionary *)shareDataDic;
/**
 *  发送位置
 *
 *  @param sendArr   发送位置
 */
- (void)didSendLocationAction:(NSString *)geoimagename
                         zoom:(CGFloat)zoom
                    longitude:(CGFloat)longitude
                     latitude:(CGFloat)latitude
                      address:(NSString *)address
                     position:(NSString *)position;

-(void)finishAliPlayShortVideo:(NSString *)videoPath;

/**
 组织音视频的msgInfo
 
 @param callstatus 呼叫状态
 @param callDuration 呼叫时长
 @param channelid 房间号
 @param isVideo 是否是视频
 */
- (void)sendVoiceOrVideoCall:(NSString *)callstatus callDuration:(NSString*)callDuration channelid:(NSString *)channelid isVideo:(BOOL)isVideo;
@end
