//
//  LZGlobalVariable.h
//  LeadingCloud
//
//  Created by wchMac on 16/2/17.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-02-17
 Version: 1.0
 Description: 全局变量存储
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EventBus.h"
#import "EventPublisher.h"

typedef NS_ENUM(NSInteger, MsgCallStatus) {
    MsgCallStatusIsVoice = 0,  //语音通话
    MsgCallStatusIsVideo,  //视频通话
    MsgCallStatusNone,   //没有通话
};

typedef NS_ENUM(NSInteger, PCLoginInStatus) {
    PCLoginInStatusOutLine = 0, // PC端不在线
    PCLoginInStatusInLineNoNotice = 1, // PC端在线手机静音
    PCLoginInStatusInLineAndNotice = 2, // PC端在线手机不静音
    PCLoginInStatusOther,  //其他情况
};
@class MessageRootViewController;
@class CooperationRightModel;

typedef void (^LZLoginWebSuccess)(NSString * tokenId);

@interface LZGlobalVariable : NSObject<EventSyncPublisher>

/* TabBar的高度 */
@property (assign, nonatomic) CGFloat currentTabBarHeight;

/* 当前的XHNavigationController */
@property (strong, nonatomic) UINavigationController *currentNavigationController;

@property (nonatomic, strong) MessageRootViewController *messageRootVC;

/* 当前聊天窗口的DialogID */
@property (strong, nonatomic) NSString *currentChatViewControllerDialogid;

/* 当前WebView模板消息的code */
@property (strong, nonatomic) NSString *currentNewWebViewControllerCode;

/* 登录标识值 */
@property (strong, nonatomic) NSString *loginGUID;

/* 登录的时间点 */
@property (strong, nonatomic) NSDate *justLoginTime;

/* 刷新消息页签时需要携带的对话框id */
@property (strong, nonatomic) NSString *chatDialogID;

/* 刷新消息页面标识，避免多次调用 */
@property (strong, nonatomic) NSString *messageRootSelectGUID;

/* 是否需要刷新MessageRootViewController */
@property (assign, nonatomic) BOOL isNeedRefreshMessageRootVC;
@property (assign, nonatomic) BOOL isNeedRefreshMessageRootForChatVC;
@property (assign, nonatomic) BOOL isNeedRefreshMessageRootHeaderView;
@property (assign, nonatomic) BOOL isNeedRefreshMessageRootForPermanentNotice;

/* 二级消息列表DialogID */
//@property (strong, nonatomic) NSString *secondChatDialogID;
/* 是否需要刷新二级消息列表 */
@property (assign, nonatomic) BOOL isNeedRefreshSecondMsgListVC;

/* 是否需要刷新ContactRootViewController2 */
@property (assign, nonatomic) BOOL isNeedRefreshContactRootVC2;

/* 是否需要刷新ContactFriendListViewController2 */
@property (assign, nonatomic) BOOL isNeedRefreshContactFriendListVC2;

/* 是否需要刷新ContactFriendLabelListViewController2 */
@property (assign, nonatomic) BOOL isNeedRefreshContactFriendLabelListViewController2;

/* 是否需要刷新ContactFriendInfoViewController */
@property (assign, nonatomic) BOOL isNeedRefreshContactFriendInfoViewController;

/* 当前打开的企业 */
@property (strong, nonatomic) NSString *currentOpenedOeid;

/* 当前打开的应用 */
@property (strong, nonatomic) NSArray *currentAppCode;

/* 当前打开应用的应用ID */
@property (strong, nonatomic) NSString *currentOpenedAppId;

/* 是否需要reload CooperationTaskRootViewController */
@property (assign, nonatomic) BOOL isNeedReloadCooperationTaskRootVC;

/* 是否需要reload AppNetDiskRecycleViewController */
@property (assign, nonatomic) BOOL isNeedAppNetDiskRecycleVC;
@property (assign, nonatomic) BOOL isNeedRefreshNetDiskVC;
/* 云盘是否删除本地 */
@property (assign, nonatomic) BOOL isDeleteLocalData;
/* 云盘收藏界面取消收藏后刷新我的文件界面 */
@property (assign ,nonatomic) BOOL isRefreshMyfileWhenCancelFavority;
/* 云盘收藏是否删除本地 */
@property (assign, nonatomic) BOOL isDelNetFavoriteLocal;
/* 获取组织云盘根文件夹 */
@property (assign ,nonatomic) BOOL isGetOrgNetDiskRootFolder;
/* 协作文件是否不删除本地 */
@property (assign, nonatomic) BOOL cooFileisNotDeleteLocalData;
/* 协作文件夹是否在添加本地 */
@property (assign, nonatomic) BOOL cooFolderisAddData;
/* 是否是下一页数据<##> */
@property (nonatomic, assign) BOOL isNextFolderData;

@property (strong ,nonatomic) NSMutableDictionary *cooFileAuthorityDic;
/* 是否需要切换企业刷新 */
@property (assign, nonatomic) BOOL isNeedSelectedOrg;

/* 是否刷新项目分组 */
@property (assign, nonatomic) BOOL isNeedRefreshMorePersonalDataVC;
/* 是否需要刷新MoreCollectionViewController */
@property (assign, nonatomic) BOOL isNeedRefreshMoreCollectionVC;

/* 是否需要刷新AppRootViewController */
@property (assign, nonatomic) BOOL isNeedRefreshAppRootVC;

/* 是否需要刷新CooperationProjectAppInfoViewController */
@property (assign, nonatomic) BOOL isNeedRefreshCoProAppInfoVC;

/* 新的协作是否删除本地 */
@property (assign, nonatomic) BOOL isDeleteNewCooLocalData;

/* 是否正常退出 */
@property (assign, nonatomic) BOOL isLogoutError;
/* 是否发送api项目拍完序后 */
@property (assign, nonatomic) BOOL isSendApiProjectsDidSort;
/* 是否刷新所有项目数据 */
@property (assign, nonatomic) BOOL isRefreshAllProjectsData;
/* 是否刷新项目分组 */
@property (assign, nonatomic) BOOL isRefreshAllPrGroupData;

/* 是否刷新BusinessSessionAttachmentViewController */
@property (assign, nonatomic) BOOL isRefreshBusinessSessionAttachmentVC;

/* 是否刚连接上轨道vpn */
@property (assign, nonatomic) BOOL isJustConnectTonBJGDVpn;
@property (assign, nonatomic) BOOL isNotOpenVPNWebView;
@property (assign, nonatomic) BOOL isOpenedVPNWebView;

/* 当前是否在进行音视频通话中 */
@property (assign, nonatomic) MsgCallStatus msgCallStatus;

/* PC端登录状态 */
@property (nonatomic, assign) PCLoginInStatus pcLoginInStatus;

/* 是否在登录页面成功登录了Web */
@property (assign, nonatomic) BOOL isShowLoadingWhenLoginWebFromLoginVC;

/* 是否刚清空临时通知 */
@property (assign, nonatomic) BOOL isJustSetTempNotificationToZero;

/* 阿里云服务器相关临时变量 */
@property (nonatomic, strong) id aliyunServerModel;
@property (nonatomic, strong) id aliyunAccountModel;

/* 是否正在展现着服务器启动图 */
@property (strong, nonatomic) NSDate *isShowServiceCircleAd;

/* 消息模板临时数据 */
@property (strong, nonatomic) NSMutableDictionary *msgTemplateDic;

/* 重新登录成功之后，回调此block */
@property (copy, nonatomic) LZLoginWebSuccess lzLoginWebSuccess;

/* 右侧筛选model */
@property (strong, nonatomic)CooperationRightModel *cooRightModel;
@property (strong, nonatomic)NSMutableArray *cooRightModelArr;

/* WKWebView中的Alert使用（presentViewController不能并发） */
@property (strong, nonatomic) NSMutableArray *alertArr;
@property (assign, nonatomic) BOOL isShowingAlert;

@property(nonatomic, assign) BOOL isSendapiForShareFolder;
@property(nonatomic, assign) BOOL isSendapiForQouteShareFolder;
@property(nonatomic, assign) BOOL isSendingAliyunApi;

@property (nonatomic, assign) BOOL isUseOldShare;

@property (nonatomic, assign) BOOL isInitAliyunClient;

/* 是否检测消息通知 */
@property (nonatomic, assign) BOOL isCheckMessagePush;

/* 办理数量 */
@property (nonatomic, assign) NSInteger pendCount;
/* 动态数量 */
@property (nonatomic, assign) NSInteger postCount;

/* 是否读取了服务区列表 */
@property (nonatomic, assign) BOOL loadingMain;
/**
 *  解析消息的串行队列
 */
#if OS_OBJECT_USE_OBJC
@property (strong, nonatomic) dispatch_queue_t msgQueue;
#else
@property (assign, nonatomic) dispatch_queue_t msgQueue;
#endif

///**
// *  是否需要刷新二级消息列表
// */
//-(void)setSeconMsgListRefresh:(BOOL)isNeedRefresh secondChatDialogID:(NSString *)secondChatDialogID;

/**
 *  获取展现在当前页面的ViewController
 *
 *  @return 当前ViewController
 */
- (UIViewController *)getCurrentViewController;

//- (MessageRootViewController *)getMessageRootVC;
@end
