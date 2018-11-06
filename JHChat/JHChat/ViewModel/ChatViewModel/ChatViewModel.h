//
//  ChatViewModel.h
//  LeadingCloud
//
//  Created by wchMac on 15/11/25.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "BaseViewModel.h"
#import "FilePathUtil.h"
#import "LZCloudFileTransferMain.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "AppUtils.h"
#import "ImRecentModel.h"

/* 时间间隔，3分钟 */
#define DEFAULT_TIMESTAMP_INTERVAL 180

@class XHMessage,ImChatLogModel;

/**
 *  文件上传更改进度
 *
 *  @param percent      进度
 *  @param chatLogModel 聊天记录信息
 */
typedef void (^ChatViewModelUpdateFileUploadProgress)(float percent, ImChatLogModel *chatLogModel);

typedef void (^CreateFileToRes)(BOOL reslut, id data);

@interface ChatViewModel : BaseViewModel

//@property (nonatomic,strong) NSMutableArray *arrCellItem;

/**
 *  正在上传的文件进度
 */
@property (nonatomic,strong) NSMutableDictionary *uploadingDic;

@property (copy, nonatomic) ChatViewModelUpdateFileUploadProgress updateFileUploadProgress;

@property (nonatomic, assign) NSInteger contactType;  //聊天框类型

@property (assign, nonatomic) NSInteger sendMode;   //sendmode值
@property (nonatomic, assign) NSInteger sendToType;  //聊天框类型
@property (copy, nonatomic) NSString *appCode; //发送消息的应用Code

@property (copy, nonatomic) NSString *bkid; //业务ID
@property (nonatomic, assign) NSInteger parsetype;  //消息解析类型 0：顶级，1：二级

@property (nonatomic, strong) ImRecentModel *imRecentModel;

@property (nonatomic, strong) NSMutableDictionary *consultBody; // 业务会话咨询内容

/**
 *  获取ViewModel数据源
 *
 *  @param dialogid 对话框ID
 *  @param start    起始记录
 *  @param count    获取记录数量
 */
-(NSMutableArray *)getViewDataSource:(NSString *)dialogid startCount:(NSInteger)start queryCount:(NSInteger)count;

/**
 *  添加发送状态
 */
-(void)addReadStatusToMessage:(XHMessage *)message chatLogModel:(ImChatLogModel *)chatLogModel;

#pragma mark - 自动下载聊天记录

/**
 *  检测是否需要自动下载聊天记录
 */
-(void)checkIsNeedDownChatLog:(NSString *)dialogid;

/**
 到达顶端之后，下载150条聊天记录
 */
- (void)downloadMoreMessage:(NSString *)dialogid messageCount:(NSInteger)messageCount;

/**
 *  请求群管理员，200条群成员数据
 */
-(void)loadGroupAdminAndUser:(NSString *)dialogid;

#pragma mark - 刷新未读数字、发送回执   （供所有显示在消息页签的VC调用）

/**
 *  刷新未读数字
 */
-(void)refreshMsgUnReadCount:(NSString *)dialogid;

/**
 *  发送回执
 */
-(void)sendReportToServer:(NSString *)dialogid;

#pragma mark - 消息删除添加队列

/**
 消息删除添加队列

 @param msgidArr 
 */
- (void)addDeleteMsgToMsgQueue:(NSMutableArray *)msgidArr dialogID:(NSString *)dialogID;

#pragma mark - 消息发送相关

/**
 *  将发送信息保存至数据库
 *
 *  @param msgInfo 发送至服务器的信息
 *
 *  @return 新添加的Model
 */
-(ImChatLogModel *)saveChatLogModelWithDic:(NSMutableDictionary *)msgInfo;

/**
 *  组织发送的服务器的MsgInfo信息
 *
 *  @param toDialogID  发送至的用户ID
 *  @param handlerType 处理类型
 *
 *  @return 组织好的字典数据
 */
-(NSMutableDictionary *)getSendMsgInfo:(NSString *)toDialogID
                           handlerType:(NSString *)handlerType;

#pragma mark - 消息发送、接收通用方法

/**
 *  添加新的聊天记录
 *
 *  @param chatLogModel 聊天信息
 *
 *  @return XHMessage对象
 */
-(XHMessage *)addNewXHMessageWithImChatLogModel:(ImChatLogModel *)chatLogModel messages:(NSMutableArray *)messages;

#pragma mark - 加入到消息队列
/**
 *  将待发送消息添加至队列
 *
 *  @param data 消息数据
 */
-(void)addToMsgQueue:(NSMutableDictionary *)data;

#pragma mark - 文件上传

/**
 *  添加上传文件到队列
 *
 *  @param imChatLogModel 上传文件所需信息
 */
-(void)addToUploadFileQueue:(ImChatLogModel *)imChatLogModel;

/**
 *  添加上传文件信息
 *
 *  @param imChatLogModel 上传文件所需信息
 *  @param progressBlock  更新进度上传block方法
 */
-(void)addToUploadFileQueueAndBegin:(ImChatLogModel *)imChatLogModel
                      progressBlock:(ChatViewModelUpdateFileUploadProgress)fileUploadProgress;

//生成资源
-(void)createFileToRes:(NSString *)fileid reult:(CreateFileToRes)result;

#pragma mark - 图片浏览

/**
 *  获取图片类型的聊天记录
 *
 *  @param dialogid 对话框ID
 *
 *  @return 图片类型的消息数组
 */
-(NSMutableArray *)getImageViewDataSource:(NSString *)dialogid;

/**
 通过chatlogmodel发送通知
 
 @param chatLogModel
 */
- (void)sendNotificationWithChatLogModel:(ImChatLogModel *)imChatLogModel isDelay:(BOOL)isDelay;

#pragma mark - 刷新消息列表
//刷新消息列表
-(void)refreshMessageRootVC:(NSString *)dialogid;

/**
 *  将聊天记录转换为XHMessage对象
 *
 *  @param chatLogModel 聊天记录
 *
 *  @return XHMessage对象
 */
- (XHMessage *)convertChatLogModelToXHMessage:(ImChatLogModel *)chatLogModel;

@end
