//
//  ChatViewController.m
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

#import "ChatViewController.h"
#import "XHAudioPlayerHelper.h"
#import "ChatViewModel.h"
#import "NSDictionary+DicSerial.h"
#import "ImChatLogModel.h"
#import "ImChatLogBodyModel.h"
#import "ImChatLogDAL.h"
#import "FilePathUtil.h"
#import "LZImageUtils.h"
//#import "UIViewController+BackButtonHandler.h"
//#import <objc/runtime.h>
#import "ModuleServerUtil.h"
#import "GalleryImageViewModel.h"
#import "ImRecentDAL.h"
#import "XHBaseNavigationController.h"
#import "VoiceConverter.h"
#import "XHDisplayLocationViewController.h"
#import "ChatOneSettingController.h"
#import "UserModel.h"
#import "UserDAL.h"
#import "ImGroupModel.h"
#import "ImGroupDAL.h"
#import "ChatGroupSettingController.h"
#import "WebViewController.h"
#import "ChatGroupRecvListRootVC2.h"
#import "ChatGroupUserListViewController.h"
#import "ContactFriendInfoViewController2.h"
#import "PhotoBrowserViewModel.h"
#import "SelectMessageRootViewController.h"
#import "MoveFIleViewController.h"
#import "LZOneFieldValueEditViewController.h"
#import "TZImagePickerViewModel.h"
#import "LZMessageTextView.h"
#import "LZDisplayLocationViewController.h"
#import "ScanFileViewController.h"
#import "NSString+SerialToDic.h"
#import "ResFolderDAL.h"
#import "ContactRootViewController2.h"
#import "ImRecentModel.h"
#import "PhotoBrowserViewController.h"
#import "DownOrScanSingleFileViewController.h"
#import "LZAddAddressBook.h"
#import "ShareFileScanViewController.h"
#import "TZImageManager.h"
#import "XHDisplayMediaViewController.h"
#import "OrgEnterPriseDAL.h"
#import "MsgTemplateViewModel.h"
#import "ResFileiconDAL.h"
#import "ChatSettingChangeBackGroundDelegate.h"
#import "MapNearbyLocationViewController2.h"
#import "MARFaceBeautyController.h"
#import "FilterFileTypeViewModel.h"
#import "MessageRootViewController.h"
#import "NSString+CGSize.h"
#import "LZScanResultViewModel.h"
#import "Prompt.h"
#import "CoExtendTypeDAL.h"
#import "CoExtendTypeModel.h"
#import "OpenTemplateModel.h"
#import "LZChatVideoModel.h"
#import "ImGroupCallDAL.h"
#import "ImGroupCallModel.h"
#import "NSString+SerialToArray.h"
#import "NSArray+ArraySerial.h"
#import "ErrorDAL.h"
#import "ChatLogCombineViewController.h"
#import "ChatGroupRobotViewController.h"
#import "ImMsgAppDAL.h"
#import "ImMsgAppModel.h"
#import "MoreSwitchIdentityViewController.h"
#import "LZToast.h"
#import "AppDAL.h"
#import "NSString+Replace.h"
#import "SimplePingHelper.h"

/* 默认每页的聊天记录数量 */
#define DEFAULT_CHAT_PAGECOUNT 15

@interface ChatViewController ()<SelectMessageRootDelegate,ContactSelectDelegate,FileCommentDelegate,MARFaceRecorderVideoDelegate,UIActionSheetDelegate,UIAlertViewDelegate, XHMessageTableViewCellDelegate, ChatSettingChangeBackGroundDelegate>{
    
    /* 单人时，对方UserModel */
    UserModel *toUserModel;
    /* 群聊时，群ImGroupModel */
    ImGroupModel *toGroupModel;
    
    /* 最近消息 */
    ImRecentModel *imRecentModel;
    
    /* 视图对应的ViewModel */
    ChatViewModel *chatViewModel;
    
    /* 当前用户ID */
    NSString *currentUserID;
    
    /* 图片容器 */
    NSMutableArray *photoBrowserArr;
    
    /* 是否点击了发送名片 */
    BOOL isJustClickSendCard;
    
    /* 其它人未读消息数量 */
    NSInteger otherNoReadCount;
    
    XHMessageTableViewCell *currentSelectedCell;
    
    LZAddAddressBook *lzAB;
    
    /* 输入框中之前的值 */
    NSString *preMsgText;

    /* @的好友信息 */
    NSMutableDictionary *atUsersDic;
    /* @机器人信息 */
    NSMutableDictionary *atRobotDic;
    
    /* 发送名片 */
    UserModel *sendCardUserModel;
    
    /* 转发，临时变量 */
    NSInteger resend_contactTyep;
    NSString *resend_dialogID;
    NSString *resend_contactName;
    NSMutableDictionary *resend_otherInfo;
    
    /* 图片浏览 */
//    NSMutableArray *mwPhotos;
//    MWPhotoBrowser *browser;
    
    /* 链接电话号码 */
    NSString *linkMobile;
    /* 链接电子邮箱 */
    NSString *linkEMail;
    
    /* 上一次返回时，输入框中的内容 */
    NSString *lastBackInputStr;
    
    /* 右上角的设置按钮 */
    UIButton *setBtn;
    
    /* 打开工作圈或者任务的按钮 */
//    UIButton *openWorkGroupBtn;
    
    /* 是否可点击cell */
    BOOL isEnableClickCell;
    
    /* 是否刚浏览完图片、文件 */
    BOOL isJustViewDisAppear;
    
    /* 左上角返回按钮文本 */
    NSString *backShowText;
    
    BOOL isTapButton;
    
    /* 源视频的文件名 */
    NSString *vedioStr;
    
    UIWindow *__sheetWindow;//window必须为全局变量或成员变量
    
    BOOL isFromAtPersonBack; // 是否从@人员界面退出
    
    LZPluginManager *lzplugin;
    /* 第一条消息的msgid */
    NSString *firstMsgid;
    /* 临时msgid数组 */
    NSMutableArray *tmpMsgidArr;
    /* 标记当前消息是否需要回执 */
    BOOL isrecordstatus;
    BOOL isFromPhotograph;
    
    UIView *left;
    UIView *right;
    UIView *center;
    
    UIView  *defaultTitleView;
    
    /* 被转发的消息 */
    NSMutableArray *transmitMsgArr;
    
    /* 动态留痕需要的 appcode */
    NSString *appcode;
    /* 消息下应用的 model */
    ImMsgAppModel *msgAppModel;
    
    AppModel *appModels;
}
@end

@implementation ChatViewController

- (void)viewDidLoad {
//    self.isHideInputView = YES;
    
    /* 读消息模板的配置 */
    if(_contactType != Chat_ContactType_Main_One &&
       _contactType != Chat_ContactType_Main_ChatGroup &&
       _contactType != Chat_ContactType_Main_CoGroup &&
       _contactType != Chat_ContactType_Main_App_Seven &&
       _contactType != Chat_ContactType_Main_App_Eight) {
        
        if(_contactType==Chat_ContactType_Main_App_Six){
            /* 是新的组织，隐藏输入框 */
            self.isHideInputView = YES;
        }
        else {
            /* 根据对话框ID获取模板模型 */
            ImMsgTemplateModel *imMsgTemplateModel = [MsgTemplateViewModel getMsgTemplateModel:_dialogid];
            
            if(imMsgTemplateModel.type==Chat_MsgTemplate_Three ||
               imMsgTemplateModel.type==Chat_MsgTemplate_Four){
                self.isHideInputView = YES;
            }
        }
    }
    self.xhContactType = _contactType;
    
    self.groupID = [self resetDialogID];
    /* 当加载该页面的时候，把控制器名称添加到数组中 */
    [self.appDelegate.lzSingleInstance.viewControllerArr addObject:[NSString stringWithUTF8String:object_getClassName(self)]];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan=NO;
    /* 进入后刷新内容 */
    [self reloadNavigationData];
    
    /* 设置更多功能中的接口 */
//    [self setLZMultiMediaFunctions];
    /* 设置原来的更多功能中的接口 */
    [self setMultiMediaFunctions];
    
    /* 设置ViewModel相关数据 */
    if (!chatViewModel) {
        chatViewModel = [[ChatViewModel alloc] init];
        chatViewModel.contactType = _contactType;
        chatViewModel.sendToType = _sendToType;
        chatViewModel.appCode = _appCode;
        chatViewModel.bkid = _bkid;
        chatViewModel.parsetype = _parsetype;
        if (self.isShowConsultNotice) {
            chatViewModel.consultBody = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.businessSessionSubTitle, @"consultTitle", self.businessSessionTime, @"consultTime", nil];
        }
    }
    
    /* 当前用户ID */
    currentUserID = [[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"uid"];
    
    /* 类似电话号码添加通讯录得接口 */
    lzAB = [[LZAddAddressBook alloc] init];
    
    /* @好友使用的临时数据 */
    preMsgText = @"";
    atUsersDic = [[NSMutableDictionary alloc] init];
    atRobotDic = [[NSMutableDictionary alloc] init];
    
    /* 获取数据源 */
    self.messages = [[NSMutableArray alloc] init];
    transmitMsgArr = [[NSMutableArray alloc] init];
    
    /* 输入框中内容 */
    lastBackInputStr = @"";
    
    /* 左上角返回按钮文本 */
    if( ![NSString isNullOrEmpty:_popToViewController] && [_popToViewController isEqualToString:@"back"]){
        backShowText = LZGDCommonLocailzableString(@"common_back");
    } else {
        backShowText = LZGDCommonLocailzableString(@"common_message");
    }
    [self addCustomDefaultBackButton:backShowText];
    
    /* 自动下载聊天记录 */
    [chatViewModel checkIsNeedDownChatLog:_dialogid];
    
    /* 初始化数据 */
    [self loadInitChatLog:YES newBottomMsgs:nil];

    /* 添加测试帧率的方法 */
    [self testFPSLabel];
    
    /* 是否点击右上角未读消息按钮 */
    isTapButton = NO;
    
    isFromPhotograph = NO;
    
    /* relatetype==5，获取 appcode */
    if (toGroupModel.relatetype == Chat_ContactType_Second_CoGroup_Other) {
        [self.appDelegate.lzservice sendToServerForGet:WebApi_CloudCooperation routePath:WebApi_Cooperation_Base_Get moduleServer:Modules_Default getData:@{@"cid":toGroupModel.relateid} otherData:nil];
    }
    
    EVENT_SUBSCRIBE(self, EventBus_ChatGroup_OperOrCloseGroup);
    EVENT_SUBSCRIBE(self, EventBus_Chat_RecallMsg);
    EVENT_SUBSCRIBE(self, EventBus_Chat_DeleteMsg);
    EVENT_SUBSCRIBE(self, EventBus_Chat_UpdateSendStatus);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToBottom) name:@"LZMessageTextViewNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSendState:) name:@"ChangeSendStateNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCallUserNum:) name:@"ChangeCallUserMember" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterSaveToCloudByBatch:) name:@"AfterSaveToCloudByBatch" object:nil];
    /* 发送一条消息并且删除的通知 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessageAndDeleteMsg:) name:@"SendMessageAndDeleteMsg" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UMengUtil beginLogPageView:@"ChatViewController"];
    // 设置整体背景颜色
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *savePath = [[FilePathUtil getChatSendImageDicAbsolutePath] stringByAppendingPathComponent:[defaults objectForKey:@"chatviewbackground"]];
//    if ([NSString isNullOrEmpty:[defaults objectForKey:@"chatviewbackground"]]) {
        [super setBackgroundColor:BACKGROUND_COLOR];
//    } else {
//        [super setBackgroundColor:[UIColor clearColor]];
//        [super setBackgroundImage:[UIImage imageWithContentsOfFile:savePath]];
//    }
    
    /* 设置长按消息后的弹框 */
    [self setPopMenuItems];
    /* 卸载插件 */
    if(lzplugin!=nil){
        [lzplugin unloadPlugin];
    }
    if(isJustViewDisAppear){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *newChatLogs = [[NSMutableArray alloc] init];
            // 当从设置界面返回的时候,要是在业务会话聊天框,将咨询视图这条消息去掉,避免出现错误
            if (_sendToType == Chat_ToType_Five || _sendToType == Chat_ToType_Six) {
                if(self.messages.count>1){
                    XHMessage *xhMessage = [self.messages objectAtIndex:self.messages.count-2];
                    ImChatLogModel *lastChatLogModel = xhMessage.imChatLogModel;
                    
                    newChatLogs = [[ImChatLogDAL shareInstance] getChatLogsWithDialogid:lastChatLogModel.dialogid datetime:lastChatLogModel.showindexdate];
                }
            } else {
                if(self.messages.count>0){
                    XHMessage *xhMessage = [self.messages objectAtIndex:self.messages.count-1];
                    ImChatLogModel *lastChatLogModel = xhMessage.imChatLogModel;
                    
                    newChatLogs = [[ImChatLogDAL shareInstance] getChatLogsWithDialogid:lastChatLogModel.dialogid datetime:lastChatLogModel.showindexdate];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(newChatLogs.count>0){
                    [self loadInitChatLog:NO newBottomMsgs:newChatLogs];
                }

                isJustViewDisAppear = NO;
            });
        });
    }
    
    [self refreshUnreadCount];
    
    /* 将右上角按钮置为可用 */
    setBtn.enabled = YES;
    /* 将点击图片、文件等置为可用 */
    isEnableClickCell = YES;
    /* 记录当前窗口的dialogID */
    self.appDelegate.lzGlobalVariable.currentChatViewControllerDialogid = _dialogid;

    /* 如果从@人员界面退出时，弹出键盘 */
    if (isFromAtPersonBack) {
        [self.messageInputView.inputTextView becomeFirstResponder];
        isFromAtPersonBack = NO;
    }
    /* 为了能在键盘没有关闭时，从其他页面返回 */
    BOOL sendMultiMedia = self.messageInputView.multiMediaSendButton.selected;
    BOOL faceSend = self.messageInputView.faceSendButton.selected;
    CGFloat tmp = LZ_SCREEN_HEIGHT-LZ_STATUS_NAV_HEIGHT-45 - self.keyboardViewHeight-LZ_TOOLBAR_HEIGHT;
    if ((sendMultiMedia || faceSend) && self.messageInputView.frame.origin.y != tmp && self.messageInputView.frame.origin.y != tmp+20) {
        sendMultiMedia = faceSend = NO;
    }
    if (self.messageInputView.frame.origin.y < LZ_SCREEN_HEIGHT-LZ_STATUS_NAV_HEIGHT-45-LZ_TOOLBAR_HEIGHT &&
        !sendMultiMedia && !faceSend) {
        [self.messageInputView.inputTextView becomeFirstResponder];
    }
    
    /* 显示正在视频通话的标识 */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ImGroupCallModel *groupCallModel = [[ImGroupCallDAL shareInstance] getimGroupCallModelWithGroupid:toGroupModel.igid];
        NSInteger callingCount = groupCallModel.usercout;
        NSLog(@"1---当前通话人数%ld", (long)callingCount);
        if (callingCount) {
            self.groupCallNum = callingCount;
        }
        /* 进入聊天框，更新一下最新的正在聊天的人 */
        if (![NSString isNullOrEmpty:groupCallModel.chatusers]) {
            NSMutableArray *chatUsers = [groupCallModel.chatusers serialToArr];
            NSMutableArray *realChatUsers = [groupCallModel.realchatusers serialToArr];
            NSString *realChatUserStr = @"";
            for (NSNumber *uid in realChatUsers) {
                realChatUserStr = [realChatUserStr stringByAppendingString:[NSString stringWithFormat:@",%@,",[uid stringValue]]];
            }
            NSMutableArray *newChatUsers = [NSMutableArray array];
            NSString *currentAgorauID = @"";
            for (NSDictionary *userDic in chatUsers) {
                if ([realChatUserStr rangeOfString:[NSString stringWithFormat:@",%@,",[userDic[@"agorauid"] stringValue]]].location == NSNotFound) {
                    NSString *currentDate = [AppDateUtil GetCurrentDateForString];
                    /* 两个时间点相差秒数 */
                    NSInteger intervals = [AppDateUtil IntervalSecondsForString:userDic[@"jointime"] endDate:currentDate];
                    if (intervals < 60) {
                        [newChatUsers addObject:userDic];
                    }
                } else {
                    [newChatUsers addObject:userDic];
                }
                if ([userDic[@"uid"] isEqualToString:currentUserID]) {
                    currentAgorauID = [userDic[@"agorauid"] stringValue];
                }
            }
            /* 前后数组人数有变化 */
            if (chatUsers.count > newChatUsers.count &&
                ![groupCallModel.realchatusers containsString:currentAgorauID]) {
                /* 得到最新正在通话的人员 */
                [self sendVideoCallForGroup:Chat_Group_Call_State_Clear userArr:newChatUsers channelid:groupCallModel.roomname other:nil];
            }
        }
    });
    /* 多选状态下跳转到下一个界面又跳转回来，左上角按钮的显示 */
    if (_leftButtonView.hidden) {
        _leftButtonView.hidden = NO;
    }
    //注册订阅
    EVENT_SUBSCRIBE(self, EventBus_Chat_RecvNewMsg);
    EVENT_SUBSCRIBE(self, EventBus_Chat_RecvSystemMsg);
    EVENT_SUBSCRIBE(self, EventBus_Chat_RecvReadList);
    EVENT_SUBSCRIBE(self, EventBus_Chat_RefreshMessageRootVC);
    EVENT_SUBSCRIBE(self, EventBus_Chat_DownloadChatlog);
    EVENT_SUBSCRIBE(self, EventBus_More_User_LoadUser_ReloadChatView);
    EVENT_SUBSCRIBE(self, EventBus_More_User_LoadUser);
    EVENT_SUBSCRIBE(self, EventBus_Chat_GetGroupInfo);
    EVENT_SUBSCRIBE(self, EventBus_Chat_UpdateVoiceDownloadStatus);
    EVENT_SUBSCRIBE(self, EventBus_Chat_LocalInChat);
    EVENT_SUBSCRIBE(self, EventBus_BusinessSession_GetExtendTypeByCode);
    EVENT_SUBSCRIBE(self, EventBus_CloudCoo_Base_Get);
    EVENT_SUBSCRIBE(self, EventBus_OrgLicenseIsExistsAuth);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    /* 当前View不可见 */
    isJustViewDisAppear = YES;
    /* 单人群聊默认没有回执状态 */
//    if (_contactType == Chat_ContactType_Main_One) {
//    } else {
//        /* 发送名片时候不走这个 */
//        if (sendCardUserModel == nil && !isFromPhotograph) {
//            isrecordstatus = NO;
//        }
//        isFromPhotograph = NO;
//    }
    
    if(_chatViewDidAppearBlock){
        _chatViewDidAppearBlock();
        _chatViewDidAppearBlock = nil;
    }
    /* 解决满足下面条件，再次进入不能右划返回的问题 */
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    if (_isNotAllowSlideBack) {
        /* 不允许滑动返回 */
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        NSLog(@"不允许滑动返回");
    }
    
//    self.isShowCheckBtn = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UMengUtil endLogPageView:@"ChatViewController"];
    [[XHAudioPlayerHelper shareInstance] stopAudio];
    
    if (_isNotAllowSlideBack) {
        /* 允许滑动返回 */
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        NSLog(@"允许滑动返回");
        /* 然后将变量重置 */
        _isNotAllowSlideBack = NO;
    }
    
    //取消订阅
    EVENT_UNSUBSCRIBE(self, EventBus_Chat_RecvNewMsg);
    EVENT_UNSUBSCRIBE(self, EventBus_Chat_RecvSystemMsg);
    EVENT_UNSUBSCRIBE(self, EventBus_Chat_RecvReadList);
    EVENT_UNSUBSCRIBE(self, EventBus_Chat_RefreshMessageRootVC);
    EVENT_UNSUBSCRIBE(self, EventBus_Chat_DownloadChatlog);
    EVENT_UNSUBSCRIBE(self, EventBus_More_User_LoadUser_ReloadChatView);
    EVENT_UNSUBSCRIBE(self, EventBus_More_User_LoadUser);
    EVENT_UNSUBSCRIBE(self, EventBus_Chat_GetGroupInfo);
    EVENT_UNSUBSCRIBE(self, EventBus_Chat_UpdateVoiceDownloadStatus);
    EVENT_UNSUBSCRIBE(self, EventBus_Chat_LocalInChat);
    EVENT_UNSUBSCRIBE(self, EventBus_BusinessSession_GetExtendTypeByCode);
    EVENT_UNSUBSCRIBE(self, EventBus_CloudCoo_Base_Get);
    EVENT_UNSUBSCRIBE(self, EventBus_OrgLicenseIsExistsAuth);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  控制器销毁的时候删除数组中的元素
 */
- (void)dealloc {
    DDLogVerbose(@"ChatViewController --- 被销毁了");
    toUserModel = nil;
    toGroupModel = nil;
    imRecentModel = nil;
    chatViewModel = nil;
    
    photoBrowserArr = nil;
    currentSelectedCell = nil;
    atUsersDic = nil;
    atRobotDic = nil;
    sendCardUserModel = nil;
    resend_otherInfo = nil;
    
    isTapButton = nil;
    [setBtn removeFromSuperview];
    /* 没有退出视频通话就退出了，将语音关闭 */
    [[LZChatVideoModel shareInstance] closeChatView];
    [[LZChatVideoModel shareInstance] closeGroupChatView];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LZMessageTextViewNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChangeSendStateNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChangeCallUserMember" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SendMessageAndDeleteMsg" object:nil];
    
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
    
    EVENT_UNSUBSCRIBE(self, EventBus_ChatGroup_OperOrCloseGroup);
    EVENT_UNSUBSCRIBE(self, EventBus_Chat_RecallMsg);
    EVENT_UNSUBSCRIBE(self, EventBus_Chat_DeleteMsg);
    EVENT_UNSUBSCRIBE(self, EventBus_Chat_UpdateSendStatus);
    
    [self.appDelegate.lzSingleInstance.viewControllerArr removeObject:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (BOOL)willDealloc {
    return NO;
}

#pragma mark - 页面初始化

/**
 *  设置更多功能
 */
- (void)setLZMultiMediaFunctions{
    /* 设置第三方接入数据 */
    NSMutableArray *lzShareMenuItems = [NSMutableArray array];

    /* 相册 */
    LZShareMenuItem *sharePicture = [[LZShareMenuItem alloc]
                                     initWithNormalImageName:@"msg_chat_tool_chooseimage_default"
                                                 hlImageName:@"msg_chat_tool_chooseimage_select"
                                                       title:LZGDCommonLocailzableString(@"message_photo")];
    /* 视频 */
    LZShareMenuItem *shareLittleVideo = [[LZShareMenuItem alloc]
                                     initWithNormalImageName:@"msg_chat_tool_choosetakepic_default"
                                                 hlImageName:@"msg_chat_tool_choosetakepic_select"
                                                       title:LZGDCommonLocailzableString(@"message_photo_video")]; // msg_chat_tool_video_default  msg_chat_tool_video_select
    /* 视频通话 */
    LZShareMenuItem *videoAndVoiceCall = [[LZShareMenuItem alloc]
                                    initWithNormalImageName:@"msg_chat_tool_video_default"
                                                hlImageName:@"msg_chat_tool_video_select"
                                                      title:LZGDCommonLocailzableString(@"message_video_voice_call")];
    /* 名片 */
    LZShareMenuItem *shareCard = [[LZShareMenuItem alloc]
                                  initWithNormalImageName:@"msg_chat_tool_usercard_default"
                                              hlImageName:@"msg_chat_tool_usercard_select"
                                                    title:LZGDCommonLocailzableString(@"message_IDcard")];
    
    /* 云盘 */
    LZShareMenuItem *shareRes = [[LZShareMenuItem alloc]
                                 initWithNormalImageName:@"msg_chat_tool_cloud_default"
                                             hlImageName:@"msg_chat_tool_cloud_select"
                                                   title:LZGDCommonLocailzableString(@"message_cloud")];
    
    /* 位置 */
    LZShareMenuItem *shareLocation = [[LZShareMenuItem alloc]
                                      initWithNormalImageName:@"msg_chat_tool_position_default"
                                                  hlImageName:@"msg_chat_tool_position_select"
                                                        title:LZGDCommonLocailzableString(@"message_location")];

//    [lzShareMenuItems addObject:shareCarema];
    [lzShareMenuItems addObject:sharePicture];
    [lzShareMenuItems addObject:shareLittleVideo];
    [lzShareMenuItems addObject:shareCard];
    [lzShareMenuItems addObject:shareRes];
    [lzShareMenuItems addObject:shareLocation];
    [lzShareMenuItems addObject:videoAndVoiceCall];
    self.lzShareMenuItems = lzShareMenuItems;

}

/**
 *  设置更多功能
 */
- (void)setMultiMediaFunctions{
    /* 设置第三方接入数据 */
    NSMutableArray *shareMenuItems = [NSMutableArray array];
    
    /* 相册 */
    XHShareMenuItem *sharePicture = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:@"msg_chat_tool_chooseimage_default"]
                                                                               title:LZGDCommonLocailzableString(@"message_photo")];
    /* 视频 */
    XHShareMenuItem *shareLittleVideo = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:@"msg_chat_tool_choosetakepic_default"]
                                                                                   title:LZGDCommonLocailzableString(@"message_photo_video")];
    /* 语音聊天 */
    XHShareMenuItem *videoAndVoiceCall = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:@"msg_chat_tool_videogroup_default"]
                                                                                    title:LZGDCommonLocailzableString(@"message_video_voice_call")];
    /* 回执消息 */
    XHShareMenuItem *readAndUnread = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:@"msg_chat_tool_receipt_default"]
                                                                                title:LZGDCommonLocailzableString(@"message_readback")];
    /* 名片 */
    XHShareMenuItem *shareCard = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:@"msg_chat_tool_usercard_default"]
                                                                            title:LZGDCommonLocailzableString(@"message_IDcard")];
    /* 云盘 */
    XHShareMenuItem *shareRes = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:@"msg_chat_tool_cloud_default"]
                                                                           title:LZGDCommonLocailzableString(@"message_cloud")];
    /* 位置 */
    XHShareMenuItem *shareLocation = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:@"msg_chat_tool_position_default"]
                                                                                title:LZGDCommonLocailzableString(@"message_location")];
    [shareMenuItems addObject:sharePicture];
    [shareMenuItems addObject:shareLittleVideo];
    if ([AppUtils checkIsPublicServer:@"chatvideo"] || [[[LZUserDataManager readAvailableDataContext] lzNSStringForKey:@"videoenable"] isEqualToString:@"1"]) {
        [shareMenuItems addObject:videoAndVoiceCall];
    }
    if (_contactType == Chat_ContactType_Main_One ||
        _contactType == Chat_ContactType_Main_ChatGroup ||
        _contactType == Chat_ContactType_Main_CoGroup) {
        [shareMenuItems addObject:readAndUnread];
    }
    [shareMenuItems addObject:shareCard];
    [shareMenuItems addObject:shareRes];
    [shareMenuItems addObject:shareLocation];
    
    if(_parsetype!=0){
        [shareMenuItems removeAllObjects];
        [shareMenuItems addObject:sharePicture];
        [shareMenuItems addObject:shareLittleVideo];
        [shareMenuItems addObject:shareRes];
    } else {
        NSMutableArray <ImMsgAppModel *>* msgAppModelArr = [[ImMsgAppDAL shareInstance] getimMsgAppModelArr];
        for (ImMsgAppModel *tmpModel in msgAppModelArr) {
            XHShareMenuItem *commonButton = [[XHShareMenuItem alloc] initWithNormalIconImage:nil title:tmpModel.name];
            [shareMenuItems addObject:commonButton];
        }
    }    
    
    self.shareMenuItems = shareMenuItems;
    
}
/**
 *  设置长按弹出项
 */
- (void)setPopMenuItems{
    NSArray *popMenuArr = [[NSArray alloc] init];
    if ([NSString isNullOrEmpty:toGroupModel.groupResourceModel.rpid] || toGroupModel.groupResourceModel == nil) {
        popMenuArr = [[NSArray alloc] initWithObjects:LZGDCommonLocailzableString(@"message_copy"),
                      LZGDCommonLocailzableString(@"message_transmit"),
                      LZGDCommonLocailzableString(@"message_reply"),
                      LZGDCommonLocailzableString(@"message_savetocloud"),
                      LZGDCommonLocailzableString(@"message_trace"),
                      LZGDCommonLocailzableString(@"messgae_delete"),
                      LZGDCommonLocailzableString(@"message_revoke"),
                      LZGDCommonLocailzableString(@"message_more..."),
                      nil];
    } else {
        popMenuArr = [[NSArray alloc] initWithObjects:LZGDCommonLocailzableString(@"message_copy"),
                      LZGDCommonLocailzableString(@"message_transmit"),
                      LZGDCommonLocailzableString(@"message_reply"),
                      LZGDCommonLocailzableString(@"message_savetocloud"),
                      toGroupModel.groupResourceModel.buttontitle,
                      LZGDCommonLocailzableString(@"message_trace"),
                      LZGDCommonLocailzableString(@"messgae_delete"),
                      LZGDCommonLocailzableString(@"message_revoke"),
                      LZGDCommonLocailzableString(@"message_more..."),
                      nil];
    }
    // 2018-08-24 打开业务会话消息长按事件
//    if(_parsetype!=0){
//        popMenuArr = [[NSArray alloc] init];
//    }
    [[XHConfigurationHelper appearance] setupPopMenuTitles:popMenuArr];
}

/**
 *  返回按钮方法处理
 */
-(void)customDefaultBackButtonClick
{
    if(_isPopToMsgTab){
        /* 清空底部未读消息 */
        [self.hideInBootomMsgArr removeAllObjects];
        [self.messageInputView resetBackBottomButtonNum:self.hideInBootomMsgArr.count];
        
        /* 是否需要显示草稿 */
        if(![lastBackInputStr isEqualToString:self.messageInputView.inputTextView.text]){
            [chatViewModel refreshMessageRootVC:_dialogid];
        }
        lastBackInputStr = self.messageInputView.inputTextView.text;
        
        //延时执行会造成再次进入，键盘显示有问题
        [self.messageInputView resignFirstResponder];
        [self resetKeyboardAndView];
        
        /* 从别的地方进入聊天框，返回后定位到消息页签 */
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MainViewController_SelectTab object:@"1"];
        //返回到跟视图，并定位到消息页签
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        /* 滚动到底部 */
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isKeyboardShow = NO;
            [self scrollToBottomAnimated:NO];
        });
        /* 重置回执按钮 */
        [self resetXHShareMenuView];
        //重置底部视图为原始状态
        [self performSelector:@selector(resetAfterPop) withObject:nil afterDelay:0.2];
    }
    _isPopToMsgTab = NO;
    /* 点击返回按钮的时候，关闭键盘 */
    [self hideKeyBoard];
    [self.navigationController popViewControllerAnimated:YES];

    
//    /* 清空底部未读消息 */
//    [self.hideInBootomMsgArr removeAllObjects];
//    [self.messageInputView resetBackBottomButtonNum:self.hideInBootomMsgArr.count];
//    
//    /* 是否需要显示草稿 */
//    if(![lastBackInputStr isEqualToString:self.messageInputView.inputTextView.text]){
//        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootForChatVC = YES;
//    }
//    lastBackInputStr = self.messageInputView.inputTextView.text;
//    
//    //延时执行会造成再次进入，键盘显示有问题
//    [self.messageInputView resignFirstResponder];
//    [self resetKeyboardAndView];

    /* 判断是否需要返回到特定的控制器 */
//    if( ![NSString isNullOrEmpty:_popToViewController] ){
//        if([_popToViewController isEqualToString:@"back"]){
//            [self.navigationController popViewControllerAnimated:YES];
//        } else {
//            BOOL isRightOne = NO;
//            for (UIViewController *controller in self.navigationController.viewControllers) {
//                if ([controller isKindOfClass:NSClassFromString(_popToViewController)]) {
//                    isRightOne = YES;
//                    [self.navigationController popToViewController:controller animated:YES];
//        //            [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -2)] animated:YES];
//                }
//            }
//            /* 未匹配上，返回至上一级 */
//            if(!isRightOne){
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//        }
//    }
//    else {
//        /* 从别的地方进入聊天框，返回后定位到消息页签 */
//        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MainViewController_SelectTab object:@"1"];
//        //返回到跟视图，并定位到消息页签
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    
//    /* 滚动到底部 */
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.isKeyboardShow = NO;
//        [self scrollToBottomAnimated:NO];
//    });
//
//     重置底部视图为原始状态 
//    [self performSelector:@selector(resetAfterPop) withObject:nil afterDelay:0.2];
//    
//    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 控制器左划返回调用方法
-(void)willMoveToParentViewController:(UIViewController *)parent {
    if (!parent) {
        /* 即将退出界面 */
        NSLog(@"即将退出界面");
        /* 清空底部未读消息 */
        [self.hideInBootomMsgArr removeAllObjects];
        [self.messageInputView resetBackBottomButtonNum:self.hideInBootomMsgArr.count];
        
        /* 是否需要显示草稿 */
        if(![lastBackInputStr isEqualToString:self.messageInputView.inputTextView.text]){
            [chatViewModel refreshMessageRootVC:_dialogid];
        }
        lastBackInputStr = self.messageInputView.inputTextView.text;
        
        //延时执行会造成再次进入，键盘显示有问题
        [self.messageInputView resignFirstResponder];
        [self resetKeyboardAndView];
        /* 重置回执按钮 */
        [self resetXHShareMenuView];
        
    } else {
        /* 即将进入界面 */
        NSLog(@"即将进入界面");
        
    }
}

-(void)didMoveToParentViewController:(UIViewController *)parent {
    if (!parent) {
        /* 已经退出界面 */
        self.newMessageNum = 0;
        isTapButton = NO;
        _isPopToMsgTab = NO;
        NSLog(@"已经退出界面");
        /* 判断是否需要返回到特定的控制器 */
//        if( ![NSString isNullOrEmpty:_popToViewController] ){
//            if([_popToViewController isEqualToString:@"back"]){
//                [self.navigationController popViewControllerAnimated:YES];
//            } else {
//                BOOL isRightOne = NO;
//                for (UIViewController *controller in self.navigationController.viewControllers) {
//                    if ([controller isKindOfClass:NSClassFromString(_popToViewController)]) {
//                        isRightOne = YES;
//                        [self.navigationController popToViewController:controller animated:YES];
//                        //            [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -2)] animated:YES];
//                    }
//                }
//                /* 未匹配上，返回至上一级 */
//                if(!isRightOne){
//                    [self.navigationController popViewControllerAnimated:YES];
//                }
//            }
//        }
//        else {
//            /* 从别的地方进入聊天框，返回后定位到消息页签 */
////            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MainViewController_SelectTab object:@"1"];
//            //返回到跟视图，并定位到消息页签
////            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
        
        /* 滚动到底部 */
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isKeyboardShow = NO;
            [self scrollToBottomAnimated:NO];
        });
    } else {
        /* 已经进入界面 */
        NSLog(@"已经进入界面");
    }
}

-(void)resetAfterPop{
    [self.messageInputView resignFirstResponder];
    [self resetKeyboardAndView];
}
/* 根据通知改变上方的正在通话指示条 */
- (void)changeCallUserNum:(NSNotification *)notif {
    NSDictionary *dic = notif.userInfo;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.groupID = [self resetDialogID];
        self.groupCallNum = [[dic lzNSNumberForKey:@"userscount"] integerValue];
        NSLog(@"2---当前通话人数%ld", (long)[[dic lzNSNumberForKey:@"userscount"] integerValue]);
    });
}

/**
 *  设置按钮的处理方法
 */
-(void)addSettingButton{
    /* 除单人、群组聊天之外，其它类型的不显示右上角按钮 */
    if(_contactType != Chat_ContactType_Main_One &&
       _contactType != Chat_ContactType_Main_ChatGroup &&
       _contactType != Chat_ContactType_Main_CoGroup &&
       _contactType != Chat_ContactType_Main_App_Seven &&
       _contactType != Chat_ContactType_Main_App_Eight){
        self.navigationItem.rightBarButtonItems = nil;
//        for (UIBarButtonItem *barBtn in self.navigationItem.rightBarButtonItems) {
//            barBtn.customView.hidden = YES;
//        }
        return;
    }
    
    /* 无对应数据时，不显示设置 */
    if(toGroupModel==nil && toUserModel==nil ){
        self.navigationItem.rightBarButtonItems = nil;
//        for (UIBarButtonItem *barBtn in self.navigationItem.rightBarButtonItems) {
//            barBtn.customView.hidden = YES;
//        }
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        /* 当前人不在此群组中的时候，不显示设置 */
        if(_contactType == Chat_ContactType_Main_ChatGroup ||
           _contactType == Chat_ContactType_Main_CoGroup ||
           _contactType == Chat_ContactType_Main_App_Seven ||
           _contactType == Chat_ContactType_Main_App_Eight) {
            
            imRecentModel = [[ImRecentDAL shareInstance] getRecentModelWithContactid:toGroupModel.igid];
            chatViewModel.imRecentModel = imRecentModel;
            if(_contactType != Chat_ContactType_Main_One &&
               (toGroupModel==nil || toGroupModel.isclosed==1 || (imRecentModel!=nil && imRecentModel.isexistsgroup==0)) ){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.navigationItem.rightBarButtonItems = nil;
                });
    //            for (UIBarButtonItem *barBtn in self.navigationItem.rightBarButtonItems) {
    //                barBtn.customView.hidden = YES;
    //            }
                return;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 若设置为不显示，则不显示 */
            if([_isShowSetting isEqualToString:@"false"]){
                self.navigationItem.rightBarButtonItems = nil;
        //        for (UIBarButtonItem *barBtn in self.navigationItem.rightBarButtonItems) {
        //            barBtn.customView.hidden = YES;
        //        }
                return;
            }
            
            setBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            setBtn.frame=CGRectMake(0, 0, 24, 24);
            SEL btn1Action =  _isCustomBtnClickExchange ? @selector(openWorkBtnClick:) : @selector(rightSetButtonClick:);
            [setBtn addTarget:self action:btn1Action forControlEvents:UIControlEventTouchUpInside];
            if(LZ_IS_IOS11) [setBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -8)];
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
            NSMutableArray *rightBarButtonItems = [NSMutableArray arrayWithObject:rightItem];
            if(_contactType == Chat_ContactType_Main_One){
                [setBtn setBackgroundImage:[ImageManager LZGetImageByFileName:@"msg_cota_btn_user"] forState:UIControlStateNormal];
            }
            else if(_contactType == Chat_ContactType_Main_ChatGroup ||
                    _contactType == Chat_ContactType_Main_CoGroup ||
                    _contactType == Chat_ContactType_Main_App_Seven ||
                    _contactType == Chat_ContactType_Main_App_Eight ){
                [setBtn setBackgroundImage:[ImageManager LZGetImageByFileName:@"msg_cota_btn_group.png"] forState:UIControlStateNormal];
                
                if(![NSString isNullOrEmpty:_customButton1Img]){
                    [setBtn setBackgroundImage:[ImageManager LZGetImageByFileName:_customButton1Img] forState:UIControlStateNormal];
                    
                }
                
                if ( (_contactType == Chat_ContactType_Main_CoGroup && ![NSString isNullOrEmpty:toGroupModel.relateopencode])
                    || ![NSString isNullOrEmpty:_customButton2Img] ) {
                    /* 只有从消息页签打开的聊天窗口，才会显示这个按钮，从工作圈打开的就不显示这个按钮 */
        //            if (!_isNotShowOpenWorkGroupBtn) {
                    /* 添加这个按钮 */
                    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
                    
                    negativeSpacer.width = -4;
                    UIImage *openWorkImage = [UIImage imageNamed:[NSString isNullOrEmpty:_customButton2Img] ? @"msg_chat_Coop" : _customButton2Img];
                    
                    SEL btn2Action =  _isCustomBtnClickExchange ? @selector(rightSetButtonClick:) : @selector(openWorkBtnClick:);
                    
                    UIBarButtonItem *openWorkItem = [[UIBarButtonItem alloc] initWithImage:openWorkImage style:UIBarButtonItemStylePlain target:self action:btn2Action];
                    
                    
                    
                    
                    if(LZ_IS_IOS11) openWorkItem.imageInsets = UIEdgeInsetsMake(0, 6, 0, -10);
                    else openWorkItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        //                openWorkGroupBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        //                openWorkGroupBtn.frame=CGRectMake(0, 0, 24, 24);
        //                [openWorkGroupBtn setBackgroundImage: forState:UIControlStateNormal];
        //                [openWorkGroupBtn addTarget:self action: forControlEvents:UIControlEventTouchUpInside];
        //                [[UIBarButtonItem alloc] initWithCustomView:openWorkGroupBtn];
        //            if (self.navigationItem.rightBarButtonItems.count == 1) {
                    [rightBarButtonItems addObject:negativeSpacer];
                    [rightBarButtonItems addObject:openWorkItem];
        //            }
        //            }
                }
            }
            
            self.navigationItem.rightBarButtonItems = rightBarButtonItems;
        });
    });
}

/**
 *  右上角按钮点击事件
 */
-(void)rightSetButtonClick:(UIButton *)btn{
//    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:btn];
//    [self performSelector:@selector(todoSomething:) withObject:btn afterDelay:0.2f];
    
//    WEAKSELF
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        for(int i=0;i<1000;i++){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self didSendTextAction:[NSString stringWithFormat:@"%d",i]];
//            });
//        }
//    });
    
    /* 将按钮置为不可用，避免点击多次 */
    if(!_isCustomBtnClickExchange)btn.enabled = NO;
        
    if(_contactType == Chat_ContactType_Main_One){
        ChatOneSettingController *oneSetVC = [[ChatOneSettingController alloc] init];
        oneSetVC.toUserModel = toUserModel;
        oneSetVC.changeDelegate = self;
        if(toUserModel==nil){
            UserModel *rightToUserModel = [[UserDAL shareInstance] getUserModelForNameAndFace:_dialogid];
            oneSetVC.toUserModel = rightToUserModel;
        }
        [self.navigationController pushViewController:oneSetVC animated:YES];
    }
    else if(_contactType == Chat_ContactType_Main_ChatGroup ||
            _contactType == Chat_ContactType_Main_CoGroup ||
            _contactType == Chat_ContactType_Main_App_Seven ||
            _contactType == Chat_ContactType_Main_App_Eight ){
        ChatGroupSettingController *groupSetVC = [[ChatGroupSettingController alloc] init];
        groupSetVC.toGroupModel = toGroupModel;
        groupSetVC.contactType = _contactType;
        groupSetVC.changeDelegate = self;
        [self.navigationController pushViewController:groupSetVC animated:YES];
    }
}

/**
 点击按钮进入工作组或者任务
 */
- (void)openWorkBtnClick:(UIButton *)btn {
    /* 使用自定义事件 */
    if(_chatViewButton2ClickBlock){
        _chatViewButton2ClickBlock(self);
        return;
    }
    
    if (_isNotShowOpenWorkGroupBtn) {
        [self popViewControllerAnimated:YES];
    } else {
        NSLog(@"我点击了工作组按钮");
        CoExtendTypeModel *model = [[CoExtendTypeDAL shareInstance] getModelFromCode:toGroupModel.relateopencode];
        
        NSMutableDictionary *context = [NSMutableDictionary dictionary];
        [context setObject:toGroupModel.relateid forKey:@"relateid"];
        
        if (model.config && [model.config length]!=0) {
            if (model.controllerModel.templatetype == 1){ //协作平台内部Controller
                [context setObject:toGroupModel.relateid forKey:@"appid"];
            }
			
			[OpenTemplateModel openTemplateViewController:self Context:context URLParamsData:nil Lzplugin:nil Model:model.controllerModel AppCode:model.appcode RelationAppCodes:nil BaskLinkCode:nil templateModule:Template_ChatRelateid];
	
        }
        else{
            [LCProgressHUD showInfoMsg:@"暂不支持此类型！"];
        }
    }
}
#pragma mark - 数据获取

/**
 *  页面显示之后加载数据
 */
- (void)loadInitChatLog:(BOOL)isViewDidLoad newBottomMsgs:(NSMutableArray *)newMsgids{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /* 请求群管理员，200条群成员数据 */
        [chatViewModel loadGroupAdminAndUser:[self resetDialogID]];
    });
    
    isJustViewDisAppear = NO;
    
    if(newMsgids ==nil || newMsgids.count<=0){  // || self.hideInBootomMsgArr.count==0
        /* 清空底部未读消息 */
        [self.hideInBootomMsgArr removeAllObjects];
        [self.messageInputView resetBackBottomButtonNum:self.hideInBootomMsgArr.count];
        
        WEAKSELF
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *resultArray = [chatViewModel getViewDataSource:weakSelf.dialogid startCount:0 queryCount:DEFAULT_CHAT_PAGECOUNT];
            //weakSelf.existsMoreDateForLoading = resultArray.count >= DEFAULT_CHAT_PAGECOUNT ? YES : NO;
            if(resultArray.count >= DEFAULT_CHAT_PAGECOUNT){
                XHMessage *lastMessage = [resultArray objectAtIndex:0];
                weakSelf.existsMoreDateForLoading = [[[ImChatLogDAL alloc] init] checkIsEarlierMsgWithDialogID:weakSelf.dialogid datetime:lastMessage.imChatLogModel.showindexdate msgid:lastMessage.imChatLogModel.msgid];
            } else {
                weakSelf.existsMoreDateForLoading = NO;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                DELAYEXECUTE(0.5, [weakSelf reloadNavigationData]);
                [weakSelf reloadNavigationData];
                
                weakSelf.messages = resultArray;
                [weakSelf.messageTableView reloadData];
                
                [weakSelf scrollToBottomAnimated:NO];
            });
        });
    }
    /* 从设置界面返回时收到了新消息 */
    else {
        for(int i=0;i<newMsgids.count;i++){
            ImChatLogModel *newChatLogModel = [newMsgids objectAtIndex:i];
            XHMessage *xhMessage = [chatViewModel addNewXHMessageWithImChatLogModel:newChatLogModel messages:self.messages];
            [self addMessage:xhMessage isSend:NO callBack:nil];
        }
        
//        /* 设置底部未读消息 */
//        [self.hideInBootomMsgArr addObjectsFromArray:newMsgids];
//        [self.messageInputView resetBackBottomButtonNum:self.hideInBootomMsgArr.count];
//        
//        WEAKSELF
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSMutableArray *resultArray = [chatViewModel getViewDataSource:weakSelf.dialogid startCount:0 queryCount:self.messages.count + newMsgids.count];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self reloadData];
//                
//                weakSelf.messages = resultArray;
//                [weakSelf.messageTableView reloadData];
//            });
//        });
    }
    
    /* 未读消息按钮的去除 */
    [self hideUnreadMsgButton];
    if (self.newMessageNum==0) {
        self.firstUnreadChatLogModel = nil;
    }
}

/**
 *  刷新数字
 */
-(void)refreshUnreadCount{
    [chatViewModel refreshMsgUnReadCount:_dialogid];
    
    /* 左侧，设置返回按钮 */
    [self refreshBackButtonText];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /* 发送消息回执 */
        [chatViewModel sendReportToServer:_dialogid];
    });
}

/**
 *  刷新数据
 */
- (void)reloadNavigationData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 单人的
        if(_contactType == Chat_ContactType_Main_One){
            /* 判断网络是否连通 */
            if (([LZUserDataManager readIsConnectNetWork])) {
    //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    toUserModel = [[UserDAL shareInstance] getUserDataWithUid:_dialogid];
                    /* 组织机构人员，数据未存表，需要发送api请求人员信息 */
                    if(toUserModel==nil){
                        [self.appDelegate.lzservice sendToServerForPost:WebApi_CloudUser routePath:WebApi_CloudUser_LoadUser moduleServer:Modules_Default getData:nil postData:_dialogid otherData:nil];
                    }
                    NSString *regetTitle = [self setTitleByTitle:toUserModel.username];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.title = regetTitle;
                    });
    //            });
            } else {
    //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    imRecentModel = [[ImRecentDAL shareInstance] getRecentModelWithContactid:_dialogid];
                    NSString *regetTitle = [self setTitleByTitle:imRecentModel.contactname];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.title = regetTitle;
                    });
    //            });
            }
        }
        // 个人提醒
        else if(_contactType == Chat_ContactType_Main_App_Six){
            ImMsgTemplateModel *imMsgTemplateModel = [MsgTemplateViewModel getMsgTemplateModel:_dialogid];
            /* 个人提醒 */
            if(imMsgTemplateModel.type == Chat_MsgTemplate_Five){
                NSString *regetTitle = [self setTitleByTitle:imMsgTemplateModel.name];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.title = regetTitle;
                });
            }
            /* 企业提醒 */
            else {
                OrgEnterPriseModel *orgEnterPriseModel = [[OrgEnterPriseDAL shareInstance] getEnterpriseByEId:_dialogid];
                if(orgEnterPriseModel!=nil){
                    NSString *regetTitle = [self setTitleByTitle:orgEnterPriseModel.shortname];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.title = regetTitle;
                    });
                }
                else {
                    imRecentModel = [[ImRecentDAL shareInstance] getRecentModelWithContactid:_dialogid];
                    NSString *regetTitle = [self setTitleByTitle:imRecentModel.contactname];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.title = regetTitle;
                    });
                }
            }
        }
        // 群聊
        else if(_contactType == Chat_ContactType_Main_ChatGroup ||
                _contactType == Chat_ContactType_Main_CoGroup ||
                _contactType == Chat_ContactType_Main_App_Seven ||
                _contactType == Chat_ContactType_Main_App_Eight ){
            toGroupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:[self resetDialogID]];
            if(_contactType == Chat_ContactType_Main_CoGroup){
                chatViewModel.sendMode = toGroupModel.showmode;
            }
        } else {
            imRecentModel = [[ImRecentDAL shareInstance] getRecentModelWithContactid:_dialogid];
            NSString *regetTitle = [self setTitleByTitle:imRecentModel.contactname];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.title = regetTitle;
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addSettingButton];
        });
        
        if(_contactType == Chat_ContactType_Main_ChatGroup ||
           _contactType == Chat_ContactType_Main_CoGroup ||
           _contactType == Chat_ContactType_Main_App_Seven ||
           _contactType == Chat_ContactType_Main_App_Eight ){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                /* 导航栏左边按钮和右边按钮的宽度 */
                CGFloat leftWidth = 16 + self.navigationItem.leftBarButtonItem.customView.width;
                CGFloat rightWidth = 0;
                if(self.navigationItem.rightBarButtonItems != nil){
                    rightWidth = self.navigationItem.rightBarButtonItem.customView.width + 17;
                    if(self.navigationItem.rightBarButtonItems.count>=2){
                        rightWidth *= 2;
                    } else {
                        rightWidth += 5;
                    }
                }
                /* 选取两者最大的 */
                CGFloat maxWidth = leftWidth >= rightWidth ? leftWidth : rightWidth;
                CGFloat titleWidth = LZ_SCREEN_WIDTH - maxWidth*2;
                
                /* 需要从网络获取群组信息 */
                if(toGroupModel==nil || (toGroupModel != nil && toGroupModel.isnottemp == 0)){
                    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
                    [postData setObject:[self resetDialogID] forKey:@"groupid"];
                    [postData setObject:[NSNumber numberWithInteger:ChatGroupList_PageSize] forKey:@"pagesize"];
                    [self.appDelegate.lzservice sendToServerForPost:WebApi_ImGroup routePath:WebApi_ImGroup_GetGroupInfoByPages moduleServer:Modules_Message getData:nil postData:postData otherData:nil];
                }
                if (!_titleView) {
                    _nameText = [[UILabel alloc] init];
                    [_nameText setFont:[UIFont boldSystemFontOfSize:17.0]];
                    //            _nameText.backgroundColor = [UIColor grayColor];
                    
                    _num = [[UILabel alloc] init];
                    [_num setFont:[UIFont boldSystemFontOfSize:17.0]];
                    //            _num.backgroundColor = [UIColor greenColor];
                    
                    _titleView = [[UIView alloc] init];
                    //            _titleView.frame = CGRectMake(0, 0, LZ_SCREEN_WIDTH, LZ_NAVGATIONBAR_HEIGHT);
                    //            _titleView.backgroundColor = [UIColor redColor];
                    //            _titleView.contentMode = NSTextAlignmentCenter;
                    //            _titleView.translatesAutoresizingMaskIntoConstraints = YES;
                    _titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
                    _titleView.autoresizesSubviews = YES;
                    [_titleView addSubview:_nameText];
                    [_titleView addSubview:_num];
                    
                    self.navigationItem.titleView = _titleView;
                    //            self.navigationItem.titleView.backgroundColor = [UIColor yellowColor];
                }
                
                /* 如果自己没有在组织中，不显示后面的人数 */
                if(toGroupModel==nil || toGroupModel.isclosed==1 || (imRecentModel!=nil && imRecentModel.isexistsgroup==0) ){
                    
                    CGSize nameSize = [toGroupModel.name sizeWithMaxSize:CGSizeMake(titleWidth, 50) font:[UIFont boldSystemFontOfSize:17.0]];
                    // 设置名称的宽高
                    CGRect nameFrame = _nameText.frame;
                    nameFrame.size = nameSize;
                    _nameText.frame = nameFrame;
                    _nameText.textAlignment = NSTextAlignmentCenter;
                    _nameText.numberOfLines = 1;
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NSString *regetTitle = [self setTitleByTitle:toGroupModel.name];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            _nameText.text = regetTitle;
                        });
                    });
                    
                    _num.hidden = YES;
                    // 整个视图的宽度就是名称的宽度
                    _titleView.frame = _nameText.frame;
                } else {
                    
                    /* 计算人数字的宽度 */
                    NSString *numText = [NSString stringWithFormat:@"(%ld)",(long)toGroupModel.usercount];
                    CGSize numSize = [numText sizeWithMaxSize:CGSizeMake(50, LZ_NAVGATIONBAR_HEIGHT) font:[UIFont boldSystemFontOfSize:17.0]];
                    
                    /* 计算title宽度 */
                    __block NSString *titleText = toGroupModel.name;
                    if ([NSString isNullOrEmpty:toGroupModel.name]) {
                        imRecentModel = [[ImRecentDAL shareInstance] getRecentModelWithContactid:_dialogid];
                        titleText = imRecentModel.contactname;
                    }
  
                    // 设置文字
                    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        titleText = [self setTitleByTitle:titleText];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            _nameText.text = titleText;
                        });
                    });
                    
                    // 计算名称的宽高
                    CGSize titleSize = [titleText sizeWithMaxSize:CGSizeMake(LZ_SCREEN_WIDTH/2-numSize.width, LZ_NAVGATIONBAR_HEIGHT) font:[UIFont boldSystemFontOfSize:17.0]];
                    
                    _num.text = numText;
                    
                    _nameText.frame = CGRectMake(0, 0, titleSize.width, 20.28f);
                    _num.frame = CGRectMake(titleSize.width, 0, numSize.width, 20.28f);
                    _titleView.frame = CGRectMake(0, 0, titleSize.width + numSize.width, 20.28f);
                    _titleView.centerX = LZ_SCREEN_WIDTH/2;
                    if (!LZ_IS_IOS11) {
                        _titleView.centerY = LZ_NAVGATIONBAR_HEIGHT/2;
                    }
                    _num.hidden = NO;
                }
            });
//            if (!_titleView) {
//                _nameText = [[UILabel alloc] init];
//                [_nameText setFont:[UIFont boldSystemFontOfSize:17.0]];
//                //                _nameText.backgroundColor = [UIColor grayColor];
//
//                _num = [[UILabel alloc] init];
//                [_num setFont:[UIFont boldSystemFontOfSize:17.0]];
//                //                _num.backgroundColor = [UIColor greenColor];
//
//                _titleView = [[UIView alloc] init];
//                _titleView.frame = CGRectMake(0, 0, LZ_SCREEN_WIDTH, LZ_NAVGATIONBAR_HEIGHT);
//                //                _titleView.backgroundColor = [UIColor redColor];
//                [_titleView addSubview:_nameText];
//                [_titleView addSubview:_num];
//
//                defaultTitleView = [[UIView alloc] init];
//                defaultTitleView.frame = CGRectMake(leftWidth, 0, LZ_SCREEN_WIDTH-(leftWidth)*2, LZ_NAVGATIONBAR_HEIGHT);
//                [defaultTitleView addSubview:_titleView];
//                //                defaultTitleView.backgroundColor = [UIColor purpleColor];
//
//                self.navigationItem.titleView = defaultTitleView;
//            }
//
//            if(leftWidth >= rightWidth){
//                _titleView.frame = CGRectMake(0, 0, titleWidth,LZ_NAVGATIONBAR_HEIGHT);
//            } else {
//                _titleView.frame = CGRectMake(LZ_SCREEN_WIDTH-leftWidth-rightWidth-titleWidth, 0, titleWidth,LZ_NAVGATIONBAR_HEIGHT);
//            }
//            /* 处理标题位置下移的问题 */
//            if(defaultTitleView.frame.origin.y != 0){
//                defaultTitleView.frame = CGRectMake(0, 0, LZ_SCREEN_WIDTH, LZ_NAVGATIONBAR_HEIGHT);
//            }
//
//            /* 需要从网络获取群组信息 */
//            if(toGroupModel==nil || (toGroupModel != nil && toGroupModel.isnottemp == 0)){
//                NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
//                [postData setObject:[self resetDialogID] forKey:@"groupid"];
//                [postData setObject:[NSNumber numberWithInteger:ChatGroupList_PageSize] forKey:@"pagesize"];
//                [self.appDelegate.lzservice sendToServerForPost:WebApi_ImGroup routePath:WebApi_ImGroup_GetGroupInfoByPages moduleServer:Modules_Message getData:nil postData:postData otherData:nil];
//            }
//
//            /* 如果自己没有在组织中，不显示后面的人数 */
//            if(toGroupModel==nil || toGroupModel.isclosed==1 || (imRecentModel!=nil && imRecentModel.isexistsgroup==0) ){
//                _nameText.frame = _titleView.frame;
//                _nameText.textAlignment = NSTextAlignmentCenter;
//                _nameText.text = [self setTitleByTitle:toGroupModel.name];
//
//                _num.hidden = YES;
//            } else {
//                /* 计算title宽度 */
//                NSString *titleText = toGroupModel.name;
//                if ([NSString isNullOrEmpty:toGroupModel.name]) {
//                    imRecentModel = [[ImRecentDAL shareInstance] getRecentModelWithContactid:_dialogid];
//                    titleText = imRecentModel.contactname;
//                }
//                CGSize titleSize = [titleText sizeWithMaxSize:CGSizeMake(LZ_SCREEN_WIDTH, LZ_NAVGATIONBAR_HEIGHT) font:[UIFont boldSystemFontOfSize:17.0]];
//
//                /* 计算人数字的宽度 */
//                NSString *numText = [NSString stringWithFormat:@"(%ld)",(long)toGroupModel.usercount];
//                CGSize numSize = [numText sizeWithMaxSize:CGSizeMake(200, LZ_NAVGATIONBAR_HEIGHT) font:[UIFont boldSystemFontOfSize:17.0]];
//
//                _nameText.text = [self setTitleByTitle:titleText];
//                _num.text = numText;
//                if((titleSize.width + numSize.width) < titleWidth){
//                    CGFloat pading = (titleWidth - (titleSize.width + numSize.width))/2;
//                    _nameText.frame = CGRectMake(pading, 0, titleSize.width, LZ_NAVGATIONBAR_HEIGHT);
//                    _num.frame = CGRectMake(_nameText.x+_nameText.width, 0, numSize.width, LZ_NAVGATIONBAR_HEIGHT);
//
//                } else {
//                    _nameText.frame = CGRectMake(0, 0, titleWidth-numSize.width, LZ_NAVGATIONBAR_HEIGHT);
//                    _num.frame = CGRectMake(titleWidth-numSize.width, 0, numSize.width, LZ_NAVGATIONBAR_HEIGHT);
//                }
//                _nameText.textAlignment = NSTextAlignmentRight;
//                _num.textAlignment = NSTextAlignmentLeft;
//
//                _num.hidden = NO;
//            }
//        }
        }
     });
}

/**
 title为空的时候，从ImRecentDAL中查

 @param title 设置的title
 */
- (NSString *)setTitleByTitle:(NSString *)title {
    NSString *theTitle = @"";
    if (![NSString isNullOrEmpty:title]) {
        theTitle = title;
    } else {
        imRecentModel = [[ImRecentDAL shareInstance] getRecentModelWithContactid:_dialogid];
        theTitle = imRecentModel.contactname;
    }
    return theTitle;
}

#pragma mark - XHMessageTableViewController Delegate

/**
 *  是否需要显示历史分隔线
 */
- (BOOL)shouldDisplayHistoryLineForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.firstUnreadChatLogModel == nil){
        return NO;
    }
    
    XHMessage *messgae = [self.messages objectAtIndex:indexPath.row];
    if([messgae.imChatLogModel.msgid isEqualToString:self.firstUnreadChatLogModel.msgid] && isTapButton){
        return YES;
    }
    return NO;
}

/**
 *  是否显示时间轴Label的回调方法
 *
 *  @param indexPath 目标消息的位置IndexPath
 *
 *  @return 根据indexPath获取消息的Model的对象，从而判断返回YES or NO来控制是否显示时间轴Label
 */
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    XHMessage *messgae = [self.messages objectAtIndex:indexPath.row];
    return messgae.isDisplayTimestamp;
}

/**
 *  是否显示用户名称
 *
 *  @param indexPath 目标消息的位置IndexPath
 *
 *  @return 根据indexPath获取消息的Model的对象，从而判断返回YES or NO来控制是否显示用户名称
 */
- (BOOL)shouldDisplayUserNameForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_contactType == Chat_ContactType_Main_ChatGroup ||
       _contactType == Chat_ContactType_Main_CoGroup ||
       _contactType == Chat_ContactType_Main_App_Seven ||
       _contactType == Chat_ContactType_Main_App_Eight ){
        XHMessage *message = [self.messages objectAtIndex:indexPath.row];
//        /* 系统消息和自定义消息需要判断 */
//        if(message.messageMediaType == XHBubbleMessageMediaSystemMsg
//           ||  (message.messageMediaType == XHBubbleMessageMediaCustomMsg && ![LZMessageCustomBubbleView checkIsShowIconImageView:message])){
//            return NO;
//        }
        return message.bubbleMessageType == XHBubbleMessageTypeReceiving;
    }
    return NO;
}

/**
 *  是否需要显示加载更多
 *
 *  @return true or false
 */
- (BOOL)shouldLoadMoreMessagesScrollToTop {
    if(self.existsMoreDateForLoading){
        return YES;
    } else {
        return NO;
    }
}

/**
 *  加载更多时的处理
 */
- (void)loadMoreMessagesScrollTotop {
//    if (!self.loadingMoreMessage) {
//        self.loadingMoreMessage = YES;
//        
        WEAKSELF
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *resultArray = [chatViewModel getViewDataSource:weakSelf.dialogid
                                                             startCount:self.messages.count
                                                             queryCount:DEFAULT_CHAT_PAGECOUNT];
            //weakSelf.existsMoreDateForLoading = resultArray.count >= DEFAULT_CHAT_PAGECOUNT ? YES : NO;
            if(resultArray.count >= DEFAULT_CHAT_PAGECOUNT){
                XHMessage *lastMessage = [resultArray objectAtIndex:0];
                weakSelf.existsMoreDateForLoading = [[[ImChatLogDAL alloc] init] checkIsEarlierMsgWithDialogID:weakSelf.dialogid datetime:lastMessage.imChatLogModel.showindexdate msgid:lastMessage.imChatLogModel.msgid];
            } else {
                weakSelf.existsMoreDateForLoading = NO;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf insertOldMessages:resultArray];
//                weakSelf.loadingMoreMessage = NO;
            });
        });
//    }
}

/**
 下拉加载到达顶部后，再次下载150条聊天记录
 */
- (void)downloadMoreMessagesScrollTotop {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [chatViewModel downloadMoreMessage:_dialogid messageCount:weakSelf.messages.count];
        
    });
}

#pragma mark - 发送

-(void)didCommonSaveAndSend:(NSMutableDictionary *)msgInfo mediaType:(XHBubbleMessageMediaType)mediaType{
    [self didCommonSaveAndSend:msgInfo mediaType:mediaType status:YES];
}

-(void)didCommonSaveAndSend:(NSMutableDictionary *)msgInfo mediaType:(XHBubbleMessageMediaType)mediaType status:(BOOL)status{
    /* 保存入库 */
    ImChatLogModel *imChatLogModel = [chatViewModel saveChatLogModelWithDic:msgInfo];
    
    /* 刷新页面 */
    XHMessage *xhMessage = [chatViewModel addNewXHMessageWithImChatLogModel:imChatLogModel messages:self.messages];
    xhMessage.sendStatus = Chat_Msg_Sending;
    /* 当前人不在群组中时，发送消息 */
    if(_contactType != Chat_ContactType_Main_One &&
       (toGroupModel==nil || toGroupModel.isclosed==1 || (imRecentModel!=nil && imRecentModel.isexistsgroup==0)) ){
        xhMessage.sendStatus = Chat_Msg_SendFail;
    }
    if(!status){
        xhMessage.sendStatus = Chat_Msg_SendFail;
    }
    [self addMessage:xhMessage isSend:YES callBack:nil];
    [self finishSendMessageWithBubbleMessageType:mediaType];
    
    /* 当前人不在群组中时，发送消息 */
    if(_contactType != Chat_ContactType_Main_One &&
       (toGroupModel==nil || toGroupModel.isclosed==1 || (imRecentModel!=nil && imRecentModel.isexistsgroup==0)) ){
        return;
    }
    if(!status){
        return;
    }
    
    /* 添加到消息队列 */
    [chatViewModel addToMsgQueue:msgInfo];
    
    /* 发送到服务器 */
    [self.appDelegate.lzservice send:msgInfo];
    
    if(mediaType == XHBubbleMessageMediaTypeText){
        [self.messageInputView.inputTextView setText:@""];
        self.messageInputView.inputTextRange = NSMakeRange(0, 0);
        preMsgText = @"";
        [self.emotionsDic removeAllObjects];
        [atUsersDic removeAllObjects];
        [atRobotDic removeAllObjects];
    }
}

/**
 *  发送文本消息
 *
 *  @param text 消息内容
 */
- (void)didSendTextAction:(NSString *)text {
    text = [text stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"];
    /* 判断是否需要打开或关闭某功能 */
    [self checkIsFunctionSetting:text];
    
    /* 得到组织好的消息信息字典 */
    NSMutableDictionary *msgInfo = [chatViewModel getSendMsgInfo:[self resetDialogID] handlerType:Handler_Message_LZChat_LZMsgNormal_Text];
    [msgInfo setObject:text forKey:@"content"];
    
    /* 添加@信息 */
    NSMutableArray *atOneArr = [NSMutableArray array];
    if ([atUsersDic allKeys].count == toGroupModel.usercount-1) {
        NSMutableDictionary *atDic = [[NSMutableDictionary alloc] init];
        [atDic setValue:@2 forKey:@"type"];
        [atOneArr addObject:atDic];
    } else {
        for(int i=0;i<[atUsersDic allKeys].count; i++){
            NSString *uid = [[atUsersDic allKeys] objectAtIndex:i];
            NSString *name = [[atUsersDic lzNSStringForKey:uid] stringByReplacingOccurrencesOfString:@"@" withString:@""];
            name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSMutableDictionary *atDic = [[NSMutableDictionary alloc] init];
            [atDic setValue:uid forKey:@"uid"];
            [atDic setValue:name forKey:@"name"];
            [atDic setValue:@0 forKey:@"type"];
            [atOneArr addObject:atDic];
        }
    }
    /* 如果有@机器人 */
    if (atRobotDic.allKeys.count > 0) {
        for(int i=0;i<[atRobotDic allKeys].count; i++){
            NSString *uid = [[atRobotDic allKeys] objectAtIndex:i];
            NSString *name = [[atRobotDic lzNSStringForKey:uid] stringByReplacingOccurrencesOfString:@"@" withString:@""];
            name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSMutableDictionary *atDic = [[NSMutableDictionary alloc] init];
            [atDic setValue:uid forKey:@"uid"];
            [atDic setValue:name forKey:@"name"];
            [atDic setValue:@1 forKey:@"type"];
            [atOneArr addObject:atDic];
        }
    }
    // 兼容老版@功能
    NSMutableDictionary *sendInfoBody = [[NSMutableDictionary alloc] init];
    NSString *lzremindlist = @"";
    if ([atUsersDic allKeys].count < toGroupModel.usercount-1) {
        for(int i=0;i<[atUsersDic allKeys].count; i++){
            NSString *uid = [[atUsersDic allKeys] objectAtIndex:i];
            if( ![lzremindlist isEqualToString:@""] ){
                lzremindlist = [lzremindlist stringByAppendingString:@","];
            }
            lzremindlist = [lzremindlist stringByAppendingString:uid];
        }
    }
    [sendInfoBody setObject:lzremindlist forKey:@"lzremindlist"];
    [msgInfo setObject:sendInfoBody forKey:@"body"];
    
    [msgInfo setObject:atOneArr forKey:@"at"];
    
    /* 回执状态 */
    [msgInfo setObject:[NSNumber numberWithInteger:isrecordstatus ? 1 : 0] forKey:@"isrecordstatus"];
    [self resetXHShareMenuView];
    [self didCommonSaveAndSend:msgInfo mediaType:XHBubbleMessageMediaTypeText];
}

#pragma mark - 音视频通话的方法
/**
 多人通话消息发送
 */
- (void)sendVideoCallForGroup:(NSString *)status userArr:(NSMutableArray *)userArr channelid:(NSString *)channelid other:(NSDictionary *)other {
    NSString *handlerType = @"";
    NSString *msgContent = @"";
    if ([status isEqualToString:Chat_Group_Call_State_Request]) {
        handlerType = Handler_Message_LZChat_Call_Main; // 发起通话
        UserModel *userModel = [[UserDAL shareInstance] getUserDataWithUid:[AppUtils GetCurrentUserID]];
        msgContent = [NSString stringWithFormat:@"%@发起了语音聊天", userModel.username];
    }
    else if ([status isEqualToString:Chat_Group_Call_State_Timeout]) {
        handlerType = Handler_Message_LZChat_Call_Unanswer; // 未接听
        msgContent = @"语音聊天未接听";
    }
    else if ([status isEqualToString:Chat_Group_Call_State_End]) {
        handlerType = Handler_Message_LZChat_Call_Finish; // 通话结束
        msgContent = @"语音聊天已经结束";
        [userArr removeLastObject];
    }
    else if ([status isEqualToString:Chat_Group_Call_State_Refuse] ||
             [status isEqualToString:Chat_Group_Call_State_Hangup] ||
             [status isEqualToString:Chat_Group_Call_State_Invite] ||
             [status isEqualToString:Chat_Group_Call_State_Join] ||
             [status isEqualToString:Chat_Group_Call_State_Update] ||
             [status isEqualToString:Chat_Group_Call_State_Clear]) {
        handlerType = Handler_Message_LZChat_Call_Notice; //只发通知
        msgContent = @"";
    }
    else if ([status isEqualToString:Chat_Group_Call_State_Receive]) {
        handlerType = Handler_Message_LZChat_Call_Receive; //只发通知
        msgContent = @"";
    }
    else if ([status isEqualToString:Chat_Group_Call_State_Speech]) {
        handlerType = Handler_Message_LZChat_Call_Speech; // 只发通知
        msgContent = @"";
    }
    /* 如果chatViewModel为空，重新组织 */
    if (chatViewModel == nil) {
        chatViewModel = [[ChatViewModel alloc] init];
        chatViewModel.contactType = _contactType;
        chatViewModel.sendToType = _sendToType;
        chatViewModel.appCode = _appCode;
        chatViewModel.bkid = _bkid;
        chatViewModel.parsetype = 0;
        if(_contactType == Chat_ContactType_Main_ChatGroup || _contactType == Chat_ContactType_Main_CoGroup) {
            toGroupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:[self resetDialogID]];
            imRecentModel = [[ImRecentDAL shareInstance] getRecentModelWithContactid:toGroupModel.igid];
            chatViewModel.imRecentModel = imRecentModel;
        }
    }
    NSMutableDictionary *msgInfo = [chatViewModel getSendMsgInfo:[self resetDialogID] handlerType:handlerType];
    /* 仅给自己发送，不给接受者发送 */
    if ([status isEqualToString:Chat_Group_Call_State_Timeout]) {
        [msgInfo setObject:@"3" forKey:@"self"];
    }
    [msgInfo setObject:msgContent forKey:@"content"];
    
    NSMutableDictionary *sendInfoBody = [[NSMutableDictionary alloc] init];
    [sendInfoBody setObject:channelid forKey:@"channelid"];
    [sendInfoBody setObject:status forKey:@"callstatus"];
    // Chat_Group_Call_State_Receive这个通知只有用自己接收，body 有channelid，callstatus
    if (![status isEqualToString:Chat_Group_Call_State_Receive] && ![status isEqualToString:Chat_Group_Call_State_Speech]) {
        [sendInfoBody setObject:[userArr arraySerial] forKey:@"chatusers"];
        if (other != nil) {
            [sendInfoBody setValue:[[other lzNSArrayForKey:@"realchatusers"] arraySerial] forKey:@"realchatusers"];
            [sendInfoBody setValue:[other lzNSStringForKey:@"timeout"] forKey:@"timeout"];
            [sendInfoBody setValue:[other lzNSStringForKey:@"iscallother"] forKey:@"iscallother"];
        }
        if ([status isEqualToString:Chat_Group_Call_State_Invite]) {
            ImGroupCallModel *callModel = [[ImGroupCallDAL shareInstance] getimGroupCallModelWithGroupid:[self resetDialogID]];
            [sendInfoBody setObject:callModel.iscallother forKey:@"iscallother"];
        }
        /* groupid groupname contacttype timeout iscallother */
        [sendInfoBody setValue:[self resetDialogID] forKey:@"groupid"]; // value 可以为空
        [sendInfoBody setValue:toGroupModel.name forKey:@"groupname"];
        [sendInfoBody setObject:[NSNumber numberWithInteger:_contactType] forKey:@"contacttype"];
    } else if ([status isEqualToString:Chat_Group_Call_State_Speech]) {

        [sendInfoBody addEntriesFromDictionary:other];
    }
    
    [msgInfo setObject:sendInfoBody forKey:@"body"];
    /* 回执状态 */
    [msgInfo setObject:[NSNumber numberWithInteger:isrecordstatus ? 1 : 0] forKey:@"isrecordstatus"];
    [self resetXHShareMenuView];
    /* 保存入库 */
    ImChatLogModel *imChatLogModel = [chatViewModel saveChatLogModelWithDic:msgInfo];
    /* 这三种状态下，才发送消息 */
    if ([status isEqualToString:Chat_Group_Call_State_Request] ||
        [status isEqualToString:Chat_Group_Call_State_Timeout] ||
        [status isEqualToString:Chat_Group_Call_State_End]) {
        /* 刷新页面 */
        XHMessage *xhMessage = [chatViewModel addNewXHMessageWithImChatLogModel:imChatLogModel messages:self.messages];
//        xhMessage.sendStatus = Chat_Msg_Sending;
//        /* 当前人不在群组中时，发送消息 */
//        if(_contactType != Chat_ContactType_Main_One &&
//           (toGroupModel==nil || toGroupModel.isclosed==1 || (imRecentModel!=nil && imRecentModel.isexistsgroup==0)) ){
//            xhMessage.sendStatus = Chat_Msg_SendFail;
//        }
        [self addMessage:xhMessage isSend:YES callBack:nil];
        [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaSystemMsg];
        
        /* 当前人不在群组中时，发送消息 */
        if(_contactType != Chat_ContactType_Main_One &&
           (toGroupModel==nil || toGroupModel.isclosed==1 || (imRecentModel!=nil && imRecentModel.isexistsgroup==0)) ){
            return;
        }
        
        /* 发送到服务器 */
        [self.appDelegate.lzservice send:msgInfo];
    }
    
    /* 发送持久通知API */
    [chatViewModel sendNotificationWithChatLogModel:imChatLogModel isDelay:true];
    
    /* 如果通话结束，设置变量为通话结束 */
    if ([status isEqualToString:Chat_Group_Call_State_Timeout] ||
        [status isEqualToString:Chat_Group_Call_State_End] ||
        [status isEqualToString:Chat_Group_Call_State_Hangup] ||
        [status isEqualToString:Chat_Group_Call_State_Refuse]) {
        self.appDelegate.lzGlobalVariable.msgCallStatus = MsgCallStatusNone;
    }
}
/**
 组织音视频的msgInfo
 
 @param callstatus 呼叫状态
 @param callDuration 呼叫时长
 @param channelid 房间号
 @param isVideo 是否是视频
 */
- (void)sendVoiceOrVideoCall:(NSString *)callstatus callDuration:(NSString*)callDuration channelid:(NSString *)channelid isVideo:(BOOL)isVideo {
    /* 组织通话的内容 */
    NSString *callStatusStr = [XHMessageBubbleView getCallStatusStrByCallStatus:callstatus duration:callDuration];
    NSString *handlerType = @"";
    NSString *msgContent = @"";
    NSInteger mediaType = 0;
    if (isVideo) {
        handlerType = Handler_Message_LZChat_VideoCall;
        msgContent = [NSString stringWithFormat:@"%@ %@",LZGDCommonLocailzableString(@"message_video_call_msg"),callStatusStr];
        mediaType = XHBubbleMessageMediaTypeVideoCall;
    } else {
        handlerType = Handler_Message_LZChat_VoiceCall;
        msgContent = [NSString stringWithFormat:@"%@ %@",LZGDCommonLocailzableString(@"message_voice_call_msg"),callStatusStr];
        mediaType = XHBubbleMessageMediaTypeVoiceCall;
    }
    /* 如果chatViewModel为空，重新组织 */
    if (chatViewModel == nil) {
        chatViewModel = [[ChatViewModel alloc] init];
        chatViewModel.contactType = Chat_ContactType_Main_One;
        chatViewModel.sendToType = 0;
        chatViewModel.parsetype = 0;
    }
    /* 音视频消息的msgInfo */
    NSMutableDictionary *callMsgInfo = [chatViewModel getSendMsgInfo:[self resetDialogID] handlerType:handlerType];
    [callMsgInfo setObject:msgContent forKey:@"content"];
    
    NSMutableDictionary *sendInfoBody = [[NSMutableDictionary alloc] init];
    [sendInfoBody setObject:callstatus forKey:@"callstatus"];
    [sendInfoBody setObject:callDuration forKey:@"duration"];
    [sendInfoBody setObject:channelid forKey:@"channelid"];
    [callMsgInfo setObject:sendInfoBody forKey:@"body"];
    
    /* 回执状态 */
    [callMsgInfo setObject:[NSNumber numberWithInteger:isrecordstatus ? 1 : 0] forKey:@"isrecordstatus"];
    /* 保存入库 */
    ImChatLogModel *imChatLogModel = [chatViewModel saveChatLogModelWithDic:callMsgInfo];
    
    if (![callstatus isEqualToString:Chat_Call_State_Calling]) {
        /* 刷新页面 */
        XHMessage *xhMessage = [chatViewModel addNewXHMessageWithImChatLogModel:imChatLogModel messages:self.messages];
        //    xhMessage.sendStatus = Chat_Msg_Sending;
        //    /* 当前人不在群组中时，发送消息 */
        //    if(_contactType != Chat_ContactType_Main_One &&
        //       (toGroupModel==nil || toGroupModel.isclosed==1 || (imRecentModel!=nil && imRecentModel.isexistsgroup==0)) ){
        //        xhMessage.sendStatus = Chat_Msg_SendFail;
        //    }
        [self addMessage:xhMessage isSend:YES callBack:nil];
        [self finishSendMessageWithBubbleMessageType:mediaType];
        
        /* 当前人不在群组中时，发送消息 */
        if(_contactType != Chat_ContactType_Main_One &&
           (toGroupModel==nil || toGroupModel.isclosed==1 || (imRecentModel!=nil && imRecentModel.isexistsgroup==0)) ){
            return;
        }
        /* 发送到服务器 */
        [self.appDelegate.lzservice send:callMsgInfo];
    }
    /* 发送临时通知API */
    [chatViewModel sendNotificationWithChatLogModel:imChatLogModel isDelay:false];
    
    /* 如果通话结束，设置变量为通话结束 */
    if (![callstatus isEqualToString:Chat_Call_State_Calling] &&
        ![callstatus isEqualToString:Chat_Call_State_Request]) {
        self.appDelegate.lzGlobalVariable.msgCallStatus = MsgCallStatusNone;
    }
}

/**
 *  发送语音
 *
 *  @param voicePath     文件路径
 *  @param voiceName     文件名称
 *  @param voiceDuration 时间长度
 */
- (void)didSendMessageWithVoice:(NSString *)voicePath name:(NSString *)voiceName voiceDuration:(NSString*)voiceDuration  {
    //voicePath-- [FilePathUtil getChatSendImageDicAbsolutePath]
    DLog(@"send voicePath : %@ --- voiceName : %@ ------voiceDuration ： %@", voicePath, voiceName, voiceDuration);
    
    NSMutableDictionary *msgInfo = [chatViewModel getSendMsgInfo:[self resetDialogID] handlerType:Handler_Message_LZChat_Voice];
    [msgInfo setObject:LZGDCommonLocailzableString(@"message_voice_msg") forKey:@"content"];
    
    NSMutableDictionary *sendInfoBody = [[NSMutableDictionary alloc] init];
    [sendInfoBody setObject:voiceDuration forKey:@"duration"];
    [msgInfo setObject:sendInfoBody forKey:@"body"];
    
    /* 转换为AMR格式 */
    NSString *amrRecorderPath = [FilePathUtil getChatSendImageDicAbsolutePath];
    NSString *amrname = [NSString stringWithFormat:@"voice_amr_%@.amr",[LZFormat FormatNow2String]];
    amrRecorderPath = [amrRecorderPath stringByAppendingFormat:@"%@", amrname];
    int result = [VoiceConverter ConvertWavToAmr:voicePath amrSavePath:amrRecorderPath];
    if(result != 1){
        [self showErrorWithText:LZGDCommonLocailzableString(@"message_voice_transf_error")];
        return;
    }
    
    ImChatLogBodyVoiceModel *voiceModel = [[ImChatLogBodyVoiceModel alloc] init];
    voiceModel.wavname = voiceName;
    voiceModel.amrname = amrname;
    NSMutableDictionary *dic = [voiceModel convertModelToDictionary];
    [msgInfo setObject:[dic dicSerial] forKey:@"voiceinfo"];
    
    /* 回执状态 */
    [msgInfo setObject:[NSNumber numberWithInteger:isrecordstatus ? 1 : 0] forKey:@"isrecordstatus"];
    [self resetXHShareMenuView];
    /* 保存入库 */
    ImChatLogModel *imChatLogModel = [chatViewModel saveChatLogModelWithDic:msgInfo];
    
    /* 刷新页面 */
    XHMessage *xhMessage = [chatViewModel addNewXHMessageWithImChatLogModel:imChatLogModel messages:self.messages];
    xhMessage.sendStatus = Chat_Msg_Sending;
    /* 当前人不在群组中时，发送消息 */
    if(_contactType != Chat_ContactType_Main_One &&
       (toGroupModel==nil || toGroupModel.isclosed==1 || (imRecentModel!=nil && imRecentModel.isexistsgroup==0)) ){
        xhMessage.sendStatus = Chat_Msg_SendFail;
    }
    [self addMessage:xhMessage isSend:YES callBack:nil];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVoice];
    
    /* 当前人不在群组中时，发送消息 */
    if(_contactType != Chat_ContactType_Main_One &&
       (toGroupModel==nil || toGroupModel.isclosed==1 || (imRecentModel!=nil && imRecentModel.isexistsgroup==0)) ){
        return;
    }
    
//    /* 添加到消息队列 */
//    [chatViewModel addToMsgQueue:msgInfo];

    [chatViewModel addToUploadFileQueueAndBegin:imChatLogModel progressBlock:nil];
}

/**
 *  发送拍照、图片（上传物理文件）（大于20M 发文件）
 *
 *  @param sendArr   发送图片数组
 */
- (void)didSendAblumAction:(NSMutableArray *)sendArr{
    DDLogVerbose(@"Ablum111---Name : %@", sendArr);
    WEAKSELF
    __weak ChatViewModel *weakChatViewModel = chatViewModel;
    /* 上传物理文件，成功后发送消息 */
    ChatViewModelUpdateFileUploadProgress lzFileProgressUpload = ^(float percent, ImChatLogModel *imChatLogModel){
        
        NSIndexPath *indexPath = [weakSelf getIndexPathByChatLogModel:imChatLogModel updateSendStatus:imChatLogModel.sendstatus recvIsread:-1];
        if(indexPath!=nil){
            /* 更改XHMessage中的值 */
            XHMessage *xhMessage = [weakSelf.messages objectAtIndex:indexPath.row];
            xhMessage.uploadProgress = [NSString stringWithFormat:@"%0.f",percent*100];
            [weakChatViewModel.uploadingDic setObject:xhMessage.uploadProgress forKey:imChatLogModel.clienttempid];

            /* 更改View中的状态 */
            XHMessageTableViewCell *cell = (XHMessageTableViewCell *)[weakSelf.messageTableView cellForRowAtIndexPath:indexPath];
            [cell changeSendProgressInCell:percent];
        }
    };
    for(int i=0;i<[sendArr count];i++){
        
//        NSString *name = [sendArr objectAtIndex:i];
        UploadFileModel *sendFileModel = [sendArr objectAtIndex:i];
        
        if (![FilterFileTypeViewModel isAllowUploadWithCurrentType:sendFileModel.filePhysicalName]) {
            return ;
        }
        if (sendFileModel.data.length >= 20*1024*1024 ) {
            // 发送文件
            [self didSendFileAction:sendArr];
            return;
        }
        
        /* 初步组织待发送数据 */
        NSMutableDictionary *msgInfo = [chatViewModel getSendMsgInfo:[self resetDialogID] handlerType:Handler_Message_LZChat_Image_Download];
        [msgInfo setObject:@"" forKey:@"body"];
        [msgInfo setObject:LZGDCommonLocailzableString(@"message_photo_msg") forKey:@"content"];
        
        /* 压缩图片，缩略图 */
        UIImage *image = [UIImage imageWithContentsOfFile:[[FilePathUtil getChatSendImageDicAbsolutePath] stringByAppendingString:sendFileModel.filePhysicalName]];
        UIImage *cutimage = [LZImageUtils ScaleImage:image width:CHATVIEW_IMAGE_Height_Width_Max height:CHATVIEW_IMAGE_Height_Width_Max];
        NSData *imageData = UIImageJPEGRepresentation(cutimage,1.0);
        [[NSFileManager defaultManager] createFileAtPath:[[FilePathUtil getChatSendImageSmallDicAbsolutePath] stringByAppendingString:sendFileModel.filePhysicalName] contents:imageData attributes:nil];
        
        /* 添加文件信息 */
        NSMutableDictionary *sendInfoBody = [[NSMutableDictionary alloc] init];
        [sendInfoBody setObject:[NSNumber numberWithFloat:image.size.height] forKey:@"height"];
        [sendInfoBody setObject:[NSNumber numberWithFloat:image.size.width] forKey:@"width"];
        [sendInfoBody setObject:[NSNumber numberWithInteger:image.imageOrientation] forKey:@"imageOrientation"];
        [sendInfoBody setObject:sendFileModel.fileShowName forKey:@"name"];
        [msgInfo setObject:sendInfoBody forKey:@"body"];
        
        /* 将客户端文件信息存至msgInfo */
        ImChatLogBodyFileModel *fileModel = [[ImChatLogBodyFileModel alloc] init];
        fileModel.smalliconclientname = sendFileModel.filePhysicalName;
        CGSize smallSize = [LZImageUtils CalculateSmalSize:CGSizeMake(image.size.width, image.size.height) maxSize:CHATVIEW_IMAGE_Height_Width_Max minSize:CHATVIEW_IMAGE_Height_Width_Min];
        fileModel.smalliconwidth = smallSize.width;
        fileModel.smalliconheight = smallSize.height;
        NSMutableDictionary *dic = [fileModel convertModelToDictionary];
        [msgInfo setObject:[dic dicSerial] forKey:@"fileinfo"];
        
        /* 回执状态 */
        [msgInfo setObject:[NSNumber numberWithInteger:isrecordstatus ? 1 : 0] forKey:@"isrecordstatus"];
        /* 保存入库 */
        ImChatLogModel *imChatLogModel = [chatViewModel saveChatLogModelWithDic:msgInfo];
        // 图片方向不是向上的就记录错误日志
        if (image.imageOrientation != UIImageOrientationUp) {
            NSString *errorTitle = [NSString stringWithFormat:@"msgid=%@",[msgInfo lzNSStringForKey:@"msgid"]];
            [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:[msgInfo dicSerial] errortype:Error_Type_Twenty];
        }
        /* 刷新页面 */
        XHMessage *xhMessage = [chatViewModel addNewXHMessageWithImChatLogModel:imChatLogModel messages:self.messages];
        xhMessage.sendStatus = Chat_Msg_Sending;
        /* 当前人不在群组中时，发送消息 */
        if(_contactType != Chat_ContactType_Main_One &&
           (toGroupModel==nil || toGroupModel.isclosed==1 || (imRecentModel!=nil && imRecentModel.isexistsgroup==0)) ){
            xhMessage.sendStatus = Chat_Msg_SendFail;
        }
        xhMessage.uploadProgress = @"0";
        [chatViewModel.uploadingDic setObject:@"0" forKey:imChatLogModel.clienttempid];
        WEAKSELF
        __block ChatViewModel *blockChatViewModel = chatViewModel;
        [weakSelf addMessage:xhMessage isSend:YES callBack:^(id data) {
            [weakSelf finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypePhoto];
            
            /* 当前人不在群组中时，发送消息 */
            if(_contactType != Chat_ContactType_Main_One &&
               (toGroupModel==nil || toGroupModel.isclosed==1 || (imRecentModel!=nil && imRecentModel.isexistsgroup==0)) ){
                return;
            } else {
//                /* 添加到消息队列 */
//                [blockChatViewModel addToMsgQueue:msgInfo];
                if(i==[sendArr count]-1){
                    [blockChatViewModel addToUploadFileQueueAndBegin:imChatLogModel progressBlock:lzFileProgressUpload];
                }
                else {
                    [blockChatViewModel addToUploadFileQueue:imChatLogModel];
                }
            }
        }];
    }
    /* 批量发送图片后，回执状态回零 */
    [self resetXHShareMenuView];
}

/**
 *  发送图片（不上传物理文件）（照片大于20M 发文件）
 *
 *  @param fileid        文件id
 *  @param fileName      名称
 *  @param size          大小
 *  @param expandInfoDic {width:5241,height:5613}
 */
- (void)didSendImageWithFileId:(NSString *)fileid fileName:(NSString *)fileName size:(long long)size expandInfoDic:(NSDictionary *)expandInfoDic{
    if (![FilterFileTypeViewModel isAllowUploadWithCurrentType:fileName]) {
        return ;
    }
    if (size >= 20*1024*1024) {
        // 发送文件
//        didSendFileAction
        return;
    }
    NSMutableDictionary *msgInfo = [chatViewModel getSendMsgInfo:[self resetDialogID] handlerType:Handler_Message_LZChat_Image_Download];
    [msgInfo setObject:LZGDCommonLocailzableString(@"message_photo_msg") forKey:@"content"];

	NSString *exptype = @"";
	if([fileName rangeOfString:@"."].location!=NSNotFound){
		exptype = [fileName substringFromIndex:[fileName rangeOfString:@"." options:NSBackwardsSearch].location+1];
	}
	
//    NSDictionary *expandInfoDic = [resModel.expandinfo seriaToDic];
    float oriWidth = CHATVIEW_IMAGE_Height_Width_Min;
    float oriHeight = CHATVIEW_IMAGE_Height_Width_Min;
    
    /* 添加文件信息 */
    NSMutableDictionary *sendInfoBody = [[NSMutableDictionary alloc] init];
    [sendInfoBody setObject:fileid forKey:@"fileid"];
    if([[expandInfoDic allKeys] containsObject:@"width"]){
        oriWidth = [expandInfoDic lzNSNumberForKey:@"width"].floatValue;
        [sendInfoBody setObject:[expandInfoDic objectForKey:@"width"] forKey:@"width"];
    } else {
        [sendInfoBody setObject:[NSNumber numberWithFloat:CHATVIEW_IMAGE_Height_Width_Min] forKey:@"height"];
    }
    if([[expandInfoDic allKeys] containsObject:@"height"]){
        oriHeight = [expandInfoDic lzNSNumberForKey:@"height"].floatValue;
        [sendInfoBody setObject:[expandInfoDic objectForKey:@"height"] forKey:@"height"];
    } else {
        [sendInfoBody setObject:[NSNumber numberWithFloat:CHATVIEW_IMAGE_Height_Width_Min] forKey:@"height"];
    }
    [sendInfoBody setObject:exptype forKey:@"icon"];
    [sendInfoBody setObject:fileName forKey:@"name"];
    [sendInfoBody setObject:[NSNumber numberWithLongLong:size] forKey:@"size"];
    [msgInfo setObject:sendInfoBody forKey:@"body"];
    
    /* 回执状态 */
    [msgInfo setObject:[NSNumber numberWithInteger:isrecordstatus ? 1 : 0] forKey:@"isrecordstatus"];
    
    CGSize smallSize = [LZImageUtils CalculateSmalSize:CGSizeMake(oriWidth, oriHeight) maxSize:CHATVIEW_IMAGE_Height_Width_Max minSize:CHATVIEW_IMAGE_Height_Width_Min];
    ImChatLogBodyFileModel *fileModel = [[ImChatLogBodyFileModel alloc] init];
    fileModel.smalliconclientname = [NSString stringWithFormat:@"%@.%@",fileid,exptype];
    fileModel.smalliconwidth = smallSize.width;
    fileModel.smalliconheight = smallSize.height;
    NSMutableDictionary *dic = [fileModel convertModelToDictionary];
    [msgInfo setObject:[dic dicSerial] forKey:@"fileinfo"];
    
    WEAKSELF
    [chatViewModel createFileToRes:fileid reult:^(BOOL reslut, id data) {
        if(reslut){
            [sendInfoBody setValue:data forKey:@"rmid"];
            [msgInfo setObject:sendInfoBody forKey:@"body"];
            
            [weakSelf didCommonSaveAndSend:msgInfo mediaType:XHBubbleMessageMediaTypeFile];
        } else {
            [weakSelf didCommonSaveAndSend:msgInfo mediaType:XHBubbleMessageMediaTypeFile status:NO];
        }
    }];
}

/**
 *  转发，当前人发出的图片
 *  （msgid,clientTempId,filePath,filePhysicalName） （filePath,filePhysicalName,fileid,fileShowName）
 */
- (void)didResendAblumWithMsgId:(NSString *)msgid clienttempid:(NSString *)clientTempId filePath:(NSString *)filePath filePhysicalName:(NSString *)filePhysicalName fileid:(NSString *)fileid fileShowName:(NSString *)fileShowName{
    if (![FilterFileTypeViewModel isAllowUploadWithCurrentType:filePhysicalName]) {
        return ;
    }
    /* 文件已上传到服务器 */
    if(![NSString isNullOrEmpty:fileid]){
        /* 转发的是聊天中的文件 */
        
        ImChatLogModel *imChatLogModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:msgid orClienttempid:clientTempId];
        if(![NSString isNullOrEmpty:msgid] && imChatLogModel != nil){
            /* 转发的是发送文件夹中的文件，不需要上传物理文件，只要发送fileid即可 */
            if([filePath isEqualToString:[FilePathUtil getChatSendImageDicAbsolutePath]]){
            }
            /* 将文件复制到聊天发送文件夹内，之后转发 */
            else {
                
                NSFileManager*fileManager =[NSFileManager defaultManager];
                
                /* 复制小图 */
                NSString *fromSmallPath = [NSString stringWithFormat:@"%@%@",[FilePathUtil getChatRecvImageSmallDicAbsolutePath],filePhysicalName];
                NSString *toSmallPath = [NSString stringWithFormat:@"%@%@",[FilePathUtil getChatSendImageSmallDicAbsolutePath],filePhysicalName];
                if ([fileManager fileExistsAtPath:fromSmallPath]) {
                    [fileManager copyItemAtPath:fromSmallPath toPath:toSmallPath error:nil];
                }
                
                /* 复制原图 */
                NSString *fromOriPath = [NSString stringWithFormat:@"%@%@",[FilePathUtil getChatRecvImageDicAbsolutePath],filePhysicalName];
                NSString *toOriPath = [NSString stringWithFormat:@"%@%@",[FilePathUtil getChatSendImageDicAbsolutePath],filePhysicalName];
                if ([fileManager fileExistsAtPath:fromOriPath]) {
                    [fileManager copyItemAtPath:fromOriPath toPath:toOriPath error:nil];
                }
            }
            
            NSMutableDictionary *msgInfo = [chatViewModel getSendMsgInfo:[self resetDialogID] handlerType:Handler_Message_LZChat_Image_Download];
            [msgInfo setObject:LZGDCommonLocailzableString(@"message_photo_msg") forKey:@"content"];
            [msgInfo setValue:imChatLogModel.imClmBodyModel.body forKey:@"body"];
            [msgInfo setValue:imChatLogModel.imClmBodyModel.fileinfo forKey:@"fileinfo"];
            
            /* 回执状态 */
            [msgInfo setObject:[NSNumber numberWithInteger:isrecordstatus ? 1 : 0] forKey:@"isrecordstatus"];
            WEAKSELF
            [chatViewModel createFileToRes:imChatLogModel.imClmBodyModel.bodyModel.fileid reult:^(BOOL reslut, id data) {
                if(reslut){
                    NSMutableDictionary *imBodyDic = [imChatLogModel.imClmBodyModel.body mutableCopy];
                    [imBodyDic setValue:data forKey:@"rmid"];
                    [msgInfo setValue:imBodyDic forKey:@"body"];
                    
                    [weakSelf resetXHShareMenuView];
                    [weakSelf didCommonSaveAndSend:msgInfo mediaType:XHBubbleMessageMediaTypePhoto];
                } else {
                    [weakSelf resetXHShareMenuView];
                    [weakSelf didCommonSaveAndSend:msgInfo mediaType:XHBubbleMessageMediaTypePhoto status:NO];
                }
            }];
            
        }
        /* 转发的是其它模块，浏览图片时通过长按的方式发送的图片 */
        else {
            NSFileManager*fileManager =[NSFileManager defaultManager];
            /* 保存原图到发送文件夹 */
            NSString *fromPath = [NSString stringWithFormat:@"%@%@",filePath,filePhysicalName];
            NSString *toPath = [NSString stringWithFormat:@"%@%@",[FilePathUtil getChatSendImageDicAbsolutePath],filePhysicalName];
            if ([fileManager fileExistsAtPath:fromPath]) {
                [fileManager copyItemAtPath:fromPath toPath:toPath error:nil];
            } else {
                return;
            }
            
            /* 生成对应小图 */
            UIImage *image = [UIImage imageWithContentsOfFile:[[FilePathUtil getChatSendImageDicAbsolutePath] stringByAppendingString:filePhysicalName]];
            UIImage *cutimage = [LZImageUtils ScaleImage:image  width:CHATVIEW_IMAGE_Height_Width_Max height:CHATVIEW_IMAGE_Height_Width_Max ];
            NSData *imageData = UIImageJPEGRepresentation(cutimage,1.0);
            [fileManager createFileAtPath:[[FilePathUtil getChatSendImageSmallDicAbsolutePath] stringByAppendingString:filePhysicalName] contents:imageData attributes:nil];
            
            long long size = [[fileManager attributesOfItemAtPath:toPath error:nil] fileSize];
            NSDictionary *expandInfoDic = @{@"width":[NSNumber numberWithFloat:image.size.width],
                                            @"height":[NSNumber numberWithFloat:image.size.height]};
            
            [self didSendImageWithFileId:fileid fileName:fileShowName size:size expandInfoDic:expandInfoDic];
            [self resetXHShareMenuView];
        }
    }
    /* 文件还未上传 */
    else {
        UploadFileModel *fileModel = [[UploadFileModel alloc] init];
        fileModel.filePhysicalName = filePhysicalName;
        fileModel.fileShowName = fileShowName;
        
        NSMutableArray *sendArr = [[NSMutableArray alloc] init];
        [sendArr addObject:fileModel];
        [self didSendAblumAction:sendArr];
    }
}

/**
 *  发送视频（上传物理文件）
 *
 *  @param sendArr   发送视频数组
 *  @param outputPath   发送视频物理位置
 */
- (void)didSendVideoActionCoverName:(NSString *)coverName filePhysicalName:(NSString *)filePhysicalName {
    if (![FilterFileTypeViewModel isAllowUploadWithCurrentType:filePhysicalName] || ![FilterFileTypeViewModel isAllowUploadWithCurrentType:coverName]) {
        return ;
    }
    /* 初步组织待发送数据 */
    NSMutableDictionary *msgInfo = [chatViewModel getSendMsgInfo:[self resetDialogID] handlerType:Handler_Message_LZChat_Micro_Video];
    [msgInfo setObject:LZGDCommonLocailzableString(@"message_video_msg") forKey:@"content"];
    
    UIImage *coverImage = [UIImage imageWithContentsOfFile:[[FilePathUtil getChatSendImageDicAbsolutePath] stringByAppendingString:coverName]];
    /* 压缩图片，缩略图 */
    UIImage *cutimage = [LZImageUtils ScaleImage:coverImage width:CHATVIEW_IMAGE_Height_Width_Max*2 height:CHATVIEW_IMAGE_Height_Width_Max*2];
    NSData *imageData = UIImagePNGRepresentation(cutimage);
    /* 压缩后的图片的名称 */
    NSString *imageName = [NSString stringWithFormat:@"%@.%@",[LZFormat FormatNow2String],@"PNG"];
    [[NSFileManager defaultManager] createFileAtPath:[[FilePathUtil getChatSendImageDicAbsolutePath] stringByAppendingString:imageName] contents:imageData attributes:nil];
    /* 删除原图 */
    [[NSFileManager defaultManager] removeItemAtPath:[[FilePathUtil getChatSendImageDicAbsolutePath] stringByAppendingString:coverName] error:nil];
    
    /* 得到视频时长 */
    NSDictionary *videoDurationAndSize = [self getVideoInfoWithSourcePath:[[FilePathUtil getChatSendImageDicAbsolutePath] stringByAppendingFormat:@"%@",filePhysicalName]];
    /* 添加文件信息 */
    __block NSMutableDictionary *sendInfoBody = [[NSMutableDictionary alloc] init];
    [sendInfoBody setObject:[videoDurationAndSize lzNSStringForKey:@"duration"] forKey:@"duration"];
    [sendInfoBody setObject:[NSNumber numberWithFloat:cutimage.size.height] forKey:@"height"];
    [sendInfoBody setObject:[NSNumber numberWithFloat:cutimage.size.width] forKey:@"width"];
    [sendInfoBody setObject:[videoDurationAndSize lzNSNumberForKey:@"size"] forKey:@"size"];
    [msgInfo setObject:sendInfoBody forKey:@"body"];
    
    /* 将视频信息存至msgInfo */
    __block ImChatLogBodyFileModel *fileModel = [[ImChatLogBodyFileModel alloc] init];
    fileModel.smallvideoclientname = filePhysicalName;
    fileModel.smalliconclientname = imageName;
    CGSize smallSize = [LZImageUtils CalculateSmalSize:CGSizeMake(cutimage.size.width, cutimage.size.height)
                                               maxSize:CHATVIEW_IMAGE_Height_Width_Max
                                               minSize:CHATVIEW_IMAGE_Height_Width_Min];
    fileModel.smalliconwidth = smallSize.width;
    fileModel.smalliconheight = smallSize.height;
    NSMutableDictionary *dic = [fileModel convertModelToDictionary];
    [msgInfo setObject:[dic dicSerial] forKey:@"fileinfo"];
    
    /* 回执状态 */
    [msgInfo setObject:[NSNumber numberWithInteger:isrecordstatus ? 1 : 0] forKey:@"isrecordstatus"];
    [self resetXHShareMenuView];
    /* 保存入库 */
    __block ImChatLogModel *imChatLogModel = [chatViewModel saveChatLogModelWithDic:msgInfo];
    
    /* 刷新页面 */
    XHMessage *xhMessage = [chatViewModel addNewXHMessageWithImChatLogModel:imChatLogModel messages:self.messages];
    xhMessage.sendStatus = Chat_Msg_Sending;
    WEAKSELF
    __block ChatViewModel *blockChatViewModel = chatViewModel;
    [self addMessage:xhMessage isSend:YES callBack:^(id data) {
        [weakSelf finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVideo];
        
        /* 当前人不在群组中时，发送消息 */
        if(_contactType != Chat_ContactType_Main_One &&
           (toGroupModel==nil || toGroupModel.isclosed==1 || (imRecentModel!=nil && imRecentModel.isexistsgroup==0)) ){
            return;
        } else {
//            /* 添加到消息队列 */
//            [blockChatViewModel addToMsgQueue:msgInfo];
           
            /* 上传封面图片，添加到上传队列 */
            [blockChatViewModel addToUploadFileQueue:imChatLogModel];
            
            /* 保存入库 */
            imChatLogModel = [blockChatViewModel saveChatLogModelWithDic:msgInfo];
            /* 上传视频 */
            [blockChatViewModel addToUploadFileQueueAndBegin:imChatLogModel progressBlock:nil];
            
//            [sendInfoBody setObject:@"0" forKey:@"isvideo"];
//            [msgInfo setObject:sendInfoBody forKey:@"body"];
            
//            /* 将客户端文件信息存至msgInfo */
//            fileModel.smalliconclientname = coverName;
//            fileModel.smallvideoclientname = filePhysicalName;
//            CGSize smallSize = [LZImageUtils CalculateSmalSize:CGSizeMake(coverImage.size.width, coverImage.size.height)
//                                                       maxSize:CHATVIEW_IMAGE_Height_Width_Max
//                                                       minSize:CHATVIEW_IMAGE_Height_Width_Min];
//            fileModel.smalliconwidth = smallSize.width;
//            fileModel.smalliconheight = smallSize.height;
//            NSMutableDictionary *dict = [fileModel convertModelToDictionary];
//            [msgInfo setObject:[dict dicSerial] forKey:@"fileinfo"];
            
//            /* 上传封面图片，添加到上传队列 */
//            [blockChatViewModel addToUploadFileQueue:imChatLogModel];
        }
    }];
}
/**
 *  转发，当前人发的视频
 */
- (void)didResendVideoWithMsgId:(NSString *)msgid clienttempid:(NSString *)clientTempId filePath:(NSString *)filePath iconName:(NSString *)iconName videoName:(NSString *)videoName {
    if (![FilterFileTypeViewModel isAllowUploadWithCurrentType:iconName] || ![FilterFileTypeViewModel isAllowUploadWithCurrentType:videoName]) {
        return ;
    }
    NSString *iconID = [[iconName componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *videoID = [[videoName componentsSeparatedByString:@"."] objectAtIndex:0];
    /* 封面图片和视频文件已上传到服务器 */
    if(![NSString isNullOrEmpty:iconID] && ![NSString isNullOrEmpty:videoID]){
        /* 转发的是聊天中的视频 */
        if(![NSString isNullOrEmpty:msgid]){
            /* 转发的是发送文件夹中的文件，不需要上传物理文件，只要发送fileid即可 */
            if([filePath isEqualToString:[FilePathUtil getChatSendImageDicAbsolutePath]]){
            }
            /* 将文件复制到聊天发送文件夹内，之后转发 */
            else {
                
                NSFileManager*fileManager =[NSFileManager defaultManager];
                
                /* 复制封面图 */
                NSString *fromSmallPath = [NSString stringWithFormat:@"%@%@",[FilePathUtil getChatRecvImageDicAbsolutePath],iconName];
                NSString *toSmallPath = [NSString stringWithFormat:@"%@%@",[FilePathUtil getChatSendImageDicAbsolutePath],iconName];
                if ([fileManager fileExistsAtPath:fromSmallPath]) {
                    [fileManager copyItemAtPath:fromSmallPath toPath:toSmallPath error:nil];
                }
                
                /* 复制视频文件 */
                NSString *fromVideoPath = [NSString stringWithFormat:@"%@%@",[FilePathUtil getChatRecvImageDicAbsolutePath],videoName];
                NSString *toVideoPath = [NSString stringWithFormat:@"%@%@",[FilePathUtil getChatSendImageDicAbsolutePath],videoName];
                if ([fileManager fileExistsAtPath:fromVideoPath]) {
                    [fileManager copyItemAtPath:fromVideoPath toPath:toVideoPath error:nil];
                }
            }
            
            ImChatLogModel *imChatLogModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:msgid orClienttempid:clientTempId];
            NSMutableDictionary *msgInfo = [chatViewModel getSendMsgInfo:[self resetDialogID] handlerType:Handler_Message_LZChat_Micro_Video];
            [msgInfo setObject:LZGDCommonLocailzableString(@"message_video_msg") forKey:@"content"];
            [msgInfo setObject:imChatLogModel.imClmBodyModel.body forKey:@"body"];
            [msgInfo setObject:imChatLogModel.imClmBodyModel.fileinfo forKey:@"fileinfo"];
            
            NSString *videoFileID = [imChatLogModel.imClmBodyModel.body lzNSStringForKey:@"videofileid"];
            /* 回执状态 */
            [msgInfo setObject:[NSNumber numberWithInteger:isrecordstatus ? 1 : 0] forKey:@"isrecordstatus"];
            WEAKSELF
            [chatViewModel createFileToRes:videoFileID reult:^(BOOL reslut, id data) {
                if(reslut){

                    NSMutableDictionary *imBodyDic = [imChatLogModel.imClmBodyModel.body mutableCopy];
                    [imBodyDic setValue:data forKey:@"rmid"];
                    [msgInfo setObject:imBodyDic forKey:@"body"];
                    
                    [weakSelf resetXHShareMenuView];
                    [weakSelf didCommonSaveAndSend:msgInfo mediaType:XHBubbleMessageMediaTypeVideo];
                } else {
                    [weakSelf resetXHShareMenuView];
                    [weakSelf didCommonSaveAndSend:msgInfo mediaType:XHBubbleMessageMediaTypeVideo status:NO];
                }
            }];
        }
    }
}

/**
 *  发送图片消息的回调方法 （大于20M 发文件）
 *
 *  @param photo  目标图片对象，后续有可能会换
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date {
    /* 保存图片的路径 */
    NSString *savePath=[FilePathUtil getChatSendImageDicAbsolutePath];
    NSData *data = UIImageJPEGRepresentation(photo, 0.5);
    if (data.length >= 20*1024*1024 ) {
        // 发送文件
//        didSendFileAction
        return;
    }
    TZImagePickerViewModel *imageModel = [[TZImagePickerViewModel alloc] init];
    NSString *filePhysicalName = [NSString stringWithFormat:@"%@.JPG",[LZFormat FormatNow2String]];
    NSString *fileShowName = [NSString stringWithFormat:@"IMG_%@.JPG", [[LZFormat FormatNow2String] substringWithRange:NSMakeRange(10, 4)]];
    NSMutableArray *sendArr = [NSMutableArray array];
    /* 保存图片 */
    UploadFileModel *fileModel = [imageModel savePhotoAndReturnModel:data savePath:savePath filePhysicalName:filePhysicalName fileShowName:fileShowName showIndex:0];
    if(fileModel!=nil){
        [sendArr addObject:fileModel];
    }
    [self didSendAblumAction:sendArr];
}

/**
 *  发送视频消息的回调方法
 *
 *  @param videoPath 目标视频本地路径
 *  @param sender    发送者的名字
 *  @param date      发送时间
 */
- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    /* 视频的存储名称 */
    NSString *filePhysicalName = [NSString stringWithFormat:@"%@.MP4",[LZFormat FormatNow2String]];
    /* 视频保存路径 */
    NSString *savePath = [FilePathUtil getChatSendImageDicAbsolutePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *outPath = [savePath stringByAppendingFormat:@"%@",filePhysicalName];
    [fileManager copyItemAtPath:videoPath toPath:outPath error:nil];
    /* 删除原路径的视频 */
    [fileManager removeItemAtPath:videoPath error:nil];
    
    NSData *data = [NSData dataWithContentsOfFile:outPath];
    NSLog(@"压缩前大小：%lu",(unsigned long)data.length);
    /* 视频压缩 */
    NSString *showName = [NSString stringWithFormat:@"IMG_%@.MP4", [[LZFormat FormatNow2String] substringWithRange:NSMakeRange(10, 4)]];
    NSString *newPlistPath =[savePath stringByAppendingPathComponent:showName];
    [TZImagePickerViewModel compressVideoWithInputURL:[NSURL fileURLWithPath:outPath] outputURL:[NSURL fileURLWithPath:newPlistPath] blockHandler:^(AVAssetExportSession *session) {
        if (session.status == AVAssetExportSessionStatusCompleted) {
            NSData *data = [NSData dataWithContentsOfFile:newPlistPath];
            NSLog(@"压缩完成后视频的大小：%lu",(unsigned long)data.length);
            /* 先将视频当做文件进行发送 */
            UploadFileModel *fileModel = [[UploadFileModel alloc] init];
            fileModel.filePhysicalName = showName;
            fileModel.fileShowName = showName;
            NSMutableArray *sendArr = [[NSMutableArray alloc] init];
            [sendArr addObject:fileModel];
            
            [self didSendFileAction:sendArr];
        }else if (session.status == AVAssetExportSessionStatusFailed) {
            NSLog(@"压缩失败");
        }
    }];
}

/**
 *  发送云盘文件(从聊天框)照片（
 *
 *  @param text 消息内容
 */
- (void)didSendNetDiskFile:(ResModel *)resModel{
    /* 图片，只发小于20M 的图片 */
    if([AppUtils CheckIsImageWithName:resModel.exptype] && (resModel.size < 20*1024*1024)){
        NSDictionary *expandInfoDic = [resModel.expandinfo seriaToDic];
        NSString *fileName = [NSString stringWithFormat:@"%@.%@",resModel.name,resModel.exptype];
        [self didSendImageWithFileId:resModel.expid fileName:fileName size:resModel.size expandInfoDic:expandInfoDic];
    }
    /* 文件或资源包 */
    else {
        NSMutableDictionary *msgInfo = [chatViewModel getSendMsgInfo:[self resetDialogID] handlerType:Handler_Message_LZChat_File_Download];
        [msgInfo setValue:LZGDCommonLocailzableString(@"message_files_msg") forKey:@"content"];
        
        NSMutableDictionary *sendInfoBody = [[NSMutableDictionary alloc] init];
        [sendInfoBody setValue:[NSString stringWithFormat:@"%@.%@",resModel.name,resModel.exptype] forKey:@"name"];
        [sendInfoBody setValue:[NSNumber numberWithLongLong:resModel.size] forKey:@"size"];
        if(![NSString isNullOrEmpty:resModel.icon]){
            [sendInfoBody setValue:resModel.icon forKey:@"icon"];
        } else {
            [sendInfoBody setValue:resModel.exptype forKey:@"icon"];
        }        
        [sendInfoBody setValue:[NSNumber numberWithInteger:resModel.version] forKey:@"rversion"];
        if(![NSString isNullOrEmpty:resModel.rid]){
            [sendInfoBody setValue:resModel.rid forKey:@"rid"];
        }
        
        if( resModel.rtype == 3 ){
            [sendInfoBody setValue:@"true" forKey:@"isresource"];
            
            [msgInfo setValue:sendInfoBody forKey:@"body"];
            
            ImChatLogBodyFileModel *fileModel = [[ImChatLogBodyFileModel alloc] init];
            fileModel.smalliconclientname = [NSString stringWithFormat:@"%@.%@",resModel.rid,resModel.exptype];
            
            NSMutableDictionary *dic = [fileModel convertModelToDictionary];
            [msgInfo setValue:[dic dicSerial] forKey:@"fileinfo"];
            
            /* 回执状态 */
            [msgInfo setValue:[NSNumber numberWithInteger:isrecordstatus ? 1 : 0] forKey:@"isrecordstatus"];
            [self didCommonSaveAndSend:msgInfo mediaType:XHBubbleMessageMediaTypeFile];
        } else {
            [sendInfoBody setValue:resModel.expid forKey:@"fileid"];
            [sendInfoBody setValue:@"false" forKey:@"isresource"];
            
            WEAKSELF
            [chatViewModel createFileToRes:resModel.expid reult:^(BOOL reslut, id data) {
                if(reslut){
                    [sendInfoBody setValue:data forKey:@"rmid"];
                    [msgInfo setValue:sendInfoBody forKey:@"body"];
                    
                    ImChatLogBodyFileModel *fileModel = [[ImChatLogBodyFileModel alloc] init];
                    fileModel.smalliconclientname = [NSString stringWithFormat:@"%@.%@",resModel.rid,resModel.exptype];
                    
                    NSMutableDictionary *dic = [fileModel convertModelToDictionary];
                    [msgInfo setValue:[dic dicSerial] forKey:@"fileinfo"];
                    
                    /* 回执状态 */
                    [msgInfo setValue:[NSNumber numberWithInteger:isrecordstatus ? 1 : 0] forKey:@"isrecordstatus"];
                    [weakSelf didCommonSaveAndSend:msgInfo mediaType:XHBubbleMessageMediaTypeFile];
                } else {
                    [msgInfo setValue:sendInfoBody forKey:@"body"];
                    
                    ImChatLogBodyFileModel *fileModel = [[ImChatLogBodyFileModel alloc] init];
                    fileModel.smalliconclientname = [NSString stringWithFormat:@"%@.%@",resModel.rid,resModel.exptype];
                    
                    NSMutableDictionary *dic = [fileModel convertModelToDictionary];
                    [msgInfo setValue:[dic dicSerial] forKey:@"fileinfo"];
                    
                    /* 回执状态 */
                    [msgInfo setValue:[NSNumber numberWithInteger:isrecordstatus ? 1 : 0] forKey:@"isrecordstatus"];
                    [weakSelf didCommonSaveAndSend:msgInfo mediaType:XHBubbleMessageMediaTypeFile status:NO];
                }
            }];
        }
    }
}

/**
 *  发送文件（上传物理文件）
 *
 *  @param sendArr   发送文件数组
 */
- (void)didSendFileAction:(NSMutableArray *)sendArr{
    WEAKSELF
    __weak ChatViewModel *weakChatViewModel = chatViewModel;
    /* 添加文件上传进度 */
    ChatViewModelUpdateFileUploadProgress lzFileProgressUpload = ^(float precent, ImChatLogModel *imChatlogModel) {
        NSIndexPath *indexPath = [weakSelf getIndexPathByChatLogModel:imChatlogModel updateSendStatus:imChatlogModel.sendstatus recvIsread:-1];
        if (indexPath != nil) {
            XHMessage *xhmessge = [weakSelf.messages objectAtIndex:indexPath.row];
            xhmessge.uploadProgress = [NSString stringWithFormat:@"%0.f",precent*100];
            [weakChatViewModel.uploadingDic setObject:xhmessge.uploadProgress forKey:imChatlogModel.clienttempid];
            
            XHMessageTableViewCell *cell = (XHMessageTableViewCell *)[weakSelf.messageTableView cellForRowAtIndexPath:indexPath];
            [cell changeSendProgressInCell:precent];
        }
    };
    for(int i=0;i<[sendArr count];i++){
    
        UploadFileModel *sendFileModel = [sendArr objectAtIndex:i];
        if (![FilterFileTypeViewModel isAllowUploadWithCurrentType:sendFileModel.filePhysicalName]) {
            return;
        }
        /* 初步组织待发送数据 */
        NSMutableDictionary *msgInfo = [chatViewModel getSendMsgInfo:[self resetDialogID] handlerType:Handler_Message_LZChat_File_Download];
        [msgInfo setObject:LZGDCommonLocailzableString(@"message_files_msg") forKey:@"content"];
        
        /* 添加文件信息 */
        NSString *filePath = [[FilePathUtil getChatSendImageDicAbsolutePath] stringByAppendingFormat:@"%@", sendFileModel.filePhysicalName];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        
        NSMutableDictionary *sendInfoBody = [[NSMutableDictionary alloc] init];
        [sendInfoBody setObject:[NSNumber numberWithLongLong:data.length] forKey:@"size"];
        [sendInfoBody setObject:[sendFileModel.fileShowName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"name"];
        [msgInfo setObject:sendInfoBody forKey:@"body"];
        
        /* 回执状态 */
        [msgInfo setObject:[NSNumber numberWithInteger:isrecordstatus ? 1 : 0] forKey:@"isrecordstatus"];
        /* 将客户端文件信息存至msgInfo */
        ImChatLogBodyFileModel *fileModel = [[ImChatLogBodyFileModel alloc] init];
        fileModel.smallfileclientname = sendFileModel.filePhysicalName;
        NSMutableDictionary *dic = [fileModel convertModelToDictionary];
        [msgInfo setObject:[dic dicSerial] forKey:@"fileinfo"];
        
        /* 根据扩展名请求对应的icon */
        WEAKSELF
        WebApiSendBackBlock backBlock = ^(NSMutableDictionary *dataDic){
            NSString *code = [[dataDic lzNSDictonaryForKey:WebApi_ErrorCode] lzNSStringForKey:@"Code"];
            if([code isEqualToString:@"0"]){
                /* 插入数据库 */
                NSString *fileext = [[dataDic lzNSDictonaryForKey:WebApi_DataSend_Get] lzNSStringForKey:@"format"];
                NSString *iconID = [dataDic lzNSStringForKey:WebApi_DataContext];
                
                ResFileiconModel *resFileIconModel = [[ResFileiconModel alloc] init];
                resFileIconModel.iconext = [fileext lowercaseString];
                resFileIconModel.iconid = iconID;
                resFileIconModel.addtime = [AppDateUtil GetCurrentDate];
                /* 库中有这个扩展名的数据，更新 */
                ResFileiconModel *iconModel = [[ResFileiconDAL shareInstance] getFileiconIDByFileEXT:[fileext lowercaseString]];
                if (iconModel != nil) {
                    [[ResFileiconDAL shareInstance] updateDataWithResFileIconModel:resFileIconModel];
                } else {
                    [[ResFileiconDAL shareInstance] addDataWithResFileIconModel:resFileIconModel];
                }
                [sendInfoBody setObject:iconID forKey:@"icon"];
            }
            
            [weakSelf sendFileAfterGetIcon:msgInfo progressBlock:lzFileProgressUpload];
        };
        NSDictionary *otherData = @{WebApi_DataSend_Other_BackBlock:backBlock};
        NSString *fileext = [sendFileModel.fileShowName substringFromIndex:[sendFileModel.fileShowName rangeOfString:@"." options:NSBackwardsSearch].location+1];
        
        /* 从数据库查询 */
        ResFileiconModel *resFileIconModel = [[ResFileiconDAL shareInstance] getFileiconIDByFileEXT:[fileext lowercaseString]];
        /* 获取上次添加数据到当前时间间隔天数 */
        NSInteger intervalDays = [AppDateUtil IntervalDays:resFileIconModel.addtime endDate:[AppDateUtil GetCurrentDate]];
        
        if([NSString isNullOrEmpty:resFileIconModel.iconid] || intervalDays >= 7){
            [self.appDelegate.lzservice sendToServerForGet:@"forgeticon" routePath:WebApi_Format_GetFormatIcon moduleServer:Modules_Default getData:@{@"format":fileext,@"ishandlerjpg":@"true"} otherData:otherData];
        }
        else {
            [sendInfoBody setObject:resFileIconModel.iconid forKey:@"icon"];
            [self sendFileAfterGetIcon:msgInfo progressBlock:lzFileProgressUpload];
        }
    }
    
    [self resetXHShareMenuView];
}
/**
 *  发送名片
 *
 *  @param text 消息内容
 */
- (void)didSendCard:(UserModel *)userModel {
    NSMutableDictionary *msgInfo = [chatViewModel getSendMsgInfo:[self resetDialogID] handlerType:Handler_Message_LZChat_Card];
    [msgInfo setObject:LZGDCommonLocailzableString(@"message_card_msg") forKey:@"content"];
    NSMutableDictionary *sendInfoBody = [[NSMutableDictionary alloc] init];
    [sendInfoBody setValue:userModel.uid forKey:@"uid"];
    [sendInfoBody setValue:userModel.username forKey:@"username"];
    [sendInfoBody setValue:userModel.face forKey:@"face"];
    [msgInfo setObject:sendInfoBody forKey:@"body"];
    
    /* 回执状态 */
    [msgInfo setObject:[NSNumber numberWithInteger:isrecordstatus ? 1 : 0] forKey:@"isrecordstatus"];
    [self resetXHShareMenuView];
    [self didCommonSaveAndSend:msgInfo mediaType:XHBubbleMessageMediaTypeCard];
}

/**
 发送url链接视图

 @param urlTitle
 */
- (void)didSendUrlLink:(NSString *)urlTitle urlStr:(NSString *)urlStr urlImage:(NSString *)urlImage{
    NSMutableDictionary *msgInfo = [chatViewModel getSendMsgInfo:[self resetDialogID] handlerType:Handler_Message_LZChat_UrlLink];
    [msgInfo setObject:[NSString stringWithFormat:@"%@%@", LZGDCommonLocailzableString(@"message_urlview_msg"), urlTitle] forKey:@"content"];
    NSMutableDictionary *sendInfoBody = [[NSMutableDictionary alloc] init];
    [sendInfoBody setValue:urlTitle forKey:@"urltitle"];
    [sendInfoBody setValue:urlStr forKey:@"urlstr"];
    [sendInfoBody setValue:urlImage forKey:@"urlimage"];
    [msgInfo setObject:sendInfoBody forKey:@"body"];
    
    /* 回执状态 */
    [msgInfo setObject:[NSNumber numberWithInteger:isrecordstatus ? 1 : 0] forKey:@"isrecordstatus"];
    [self resetXHShareMenuView];
    [self didCommonSaveAndSend:msgInfo mediaType:XHBubbleMessageMediaTypeUrl];
}
/**
 合并聊天消息
 */
- (void)didSendChatLogTitle:(NSString *)chatlogTitle contentArr:(NSMutableArray *)contentArr {
    NSMutableDictionary *msgInfo = [chatViewModel getSendMsgInfo:[self resetDialogID] handlerType:Handler_Message_LZChat_ChatLog];
    [msgInfo setObject:[NSString stringWithFormat:@"[聊天记录]"] forKey:@"content"];
    NSMutableDictionary *sendInfoBody = [[NSMutableDictionary alloc] init];
    [sendInfoBody setValue:chatlogTitle forKey:@"title"];
    NSString *chatlogStr = @"";
    [sendInfoBody setValue:[chatlogStr objArrayToJSON:contentArr] forKey:@"chatlog"];
    [msgInfo setObject:sendInfoBody forKey:@"body"];
    
    /* 回执状态 */
    [msgInfo setObject:[NSNumber numberWithInteger:isrecordstatus ? 1 : 0] forKey:@"isrecordstatus"];
    [self resetXHShareMenuView];
    [self didCommonSaveAndSend:msgInfo mediaType:XHBubbleMessageMediaTypeChatLog];
}

/**
 发送共享文件消息(app,body,handlertype,content)
 */
- (void)didSendShareMsg:(NSMutableDictionary *)shareDataDic {

    NSString *sharename = [shareDataDic lzNSStringForKey:@"sharename"];
    
    NSMutableDictionary *msgInfo = [chatViewModel getSendMsgInfo:[self resetDialogID] handlerType:[shareDataDic lzNSStringForKey:@"handlertype"]];
    [msgInfo setObject:[NSString stringWithFormat:@"%@%@", LZGDCommonLocailzableString(@"message_share_msg"), sharename] forKey:@"content"];

    [msgInfo setObject:shareDataDic forKey:@"body"];
    [msgInfo setValue:[shareDataDic lzNSStringForKey:@"app"] forKey:@"app"];
    //[msgInfo setValue:[shareDataDic lzNSStringForKey:@"messagecontent"] forKey:@"content"];
    // 回执状态
    [msgInfo setObject:[NSNumber numberWithInteger:isrecordstatus ? 1 : 0] forKey:@"isrecordstatus"];
    [self resetXHShareMenuView];
    [self didCommonSaveAndSend:msgInfo mediaType:XHBubbleMessageMediaCustomMsg];
}

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
                     position:(NSString *)position{

    /* 初步组织待发送数据 */
    NSMutableDictionary *msgInfo = [chatViewModel getSendMsgInfo:[self resetDialogID] handlerType:Handler_Message_LZChat_Geolocation];
    [msgInfo setObject:LZGDCommonLocailzableString(@"message_location_msg") forKey:@"content"];
    /* 添加文件信息 */
    NSMutableDictionary *sendInfoBody = [[NSMutableDictionary alloc] init];
    [sendInfoBody setObject:[NSNumber numberWithFloat:zoom] forKey:@"geozoom"];
    [sendInfoBody setObject:[NSNumber numberWithFloat:longitude] forKey:@"geolongitude"];
    [sendInfoBody setObject:[NSNumber numberWithFloat:latitude] forKey:@"geolatitude"];
    [sendInfoBody setObject:address forKey:@"geoaddress"];
    [sendInfoBody setObject:position forKey:@"geodetailposition"];

    NSString *picImagePath = [NSString stringWithFormat:@"%@%@",[FilePathUtil getChatSendImageDicAbsolutePath],geoimagename];
    UIImage *picImage = [UIImage imageWithContentsOfFile:picImagePath];
    [sendInfoBody setObject:[NSNumber numberWithFloat:picImage.size.height] forKey:@"height"];
    [sendInfoBody setObject:[NSNumber numberWithFloat:picImage.size.width] forKey:@"width"];
    
    [msgInfo setObject:sendInfoBody forKey:@"body"];

    /* 将客户端文件信息存至msgInfo */
    ImChatLogBodyGeolocationModel *geolocationInfo = [[ImChatLogBodyGeolocationModel alloc] init];
    geolocationInfo.geoimagename = geoimagename;
    NSMutableDictionary *dic = [geolocationInfo convertModelToDictionary];
    [msgInfo setObject:[dic dicSerial] forKey:@"geolocationinfo"];
    
    /* 回执状态 */
    [msgInfo setObject:[NSNumber numberWithInteger:isrecordstatus ? 1 : 0] forKey:@"isrecordstatus"];
    [self resetXHShareMenuView];
    /* 保存入库 */
    ImChatLogModel *imChatLogModel = [chatViewModel saveChatLogModelWithDic:msgInfo];

    /* 刷新页面 */
    XHMessage *xhMessage = [chatViewModel addNewXHMessageWithImChatLogModel:imChatLogModel messages:self.messages];
    xhMessage.sendStatus = Chat_Msg_Sending;
    /* 当前人不在群组中时，发送消息 */
    if(_contactType != Chat_ContactType_Main_One &&
       (toGroupModel==nil || toGroupModel.isclosed==1 || (imRecentModel!=nil && imRecentModel.isexistsgroup==0)) ){
        xhMessage.sendStatus = Chat_Msg_SendFail;
    }
    [self addMessage:xhMessage isSend:YES callBack:nil];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeLocalPosition];

    /* 当前人不在群组中时，发送消息 */
    if(_contactType != Chat_ContactType_Main_One &&
       (toGroupModel==nil || toGroupModel.isclosed==1 || (imRecentModel!=nil && imRecentModel.isexistsgroup==0)) ){
        return;
    }
    
//    /* 添加到消息队列 */
//    [chatViewModel addToMsgQueue:msgInfo];

    [chatViewModel addToUploadFileQueueAndBegin:imChatLogModel progressBlock:nil];
}


/**
 *  转发，当前人发出的图片
 *  （msgid,clientTempId,filePath,filePhysicalName） （filePath,filePhysicalName,fileid,fileShowName）
 */
- (void)didResendLocationAction:(ImChatLogModel *)imChatLogModel{
        /* 转发的是发送文件夹中的文件，不需要上传物理文件，只要发送fileid即可 */
        if([imChatLogModel.from isEqualToString:self.currentUid]){
        }
        /* 将文件复制到聊天发送文件夹内，之后转发 */
        else {
            
            NSFileManager*fileManager =[NSFileManager defaultManager];
            NSString *geoimagename = imChatLogModel.imClmBodyModel.geolocationModel.geoimagename;
            
            /* 复制小图 */
            NSString *fromSmallPath = [NSString stringWithFormat:@"%@%@",[FilePathUtil getChatRecvImageSmallDicAbsolutePath],geoimagename];
            NSString *toSmallPath = [NSString stringWithFormat:@"%@%@",[FilePathUtil getChatSendImageSmallDicAbsolutePath],geoimagename];
            if ([fileManager fileExistsAtPath:fromSmallPath]) {
                [fileManager copyItemAtPath:fromSmallPath toPath:toSmallPath error:nil];
            }
            
            /* 复制原图 */
            NSString *fromOriPath = [NSString stringWithFormat:@"%@%@",[FilePathUtil getChatRecvImageDicAbsolutePath],geoimagename];
            NSString *toOriPath = [NSString stringWithFormat:@"%@%@",[FilePathUtil getChatSendImageDicAbsolutePath],geoimagename];
            if ([fileManager fileExistsAtPath:fromOriPath]) {
                [fileManager copyItemAtPath:fromOriPath toPath:toOriPath error:nil];
            }
        }
        
//        ImChatLogModel *imChatLogModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:msgid orClienttempid:clientTempId];
        NSMutableDictionary *msgInfo = [chatViewModel getSendMsgInfo:[self resetDialogID] handlerType:Handler_Message_LZChat_Geolocation];
        [msgInfo setObject:LZGDCommonLocailzableString(@"message_location_msg") forKey:@"content"];
        [msgInfo setObject:imChatLogModel.imClmBodyModel.body forKey:@"body"];
        [msgInfo setObject:imChatLogModel.imClmBodyModel.geolocationinfo forKey:@"geolocationinfo"];
  
        /* 回执状态 */
        [msgInfo setObject:[NSNumber numberWithInteger:isrecordstatus ? 1 : 0] forKey:@"isrecordstatus"];
        WEAKSELF
        [chatViewModel createFileToRes:imChatLogModel.imClmBodyModel.bodyModel.fileid reult:^(BOOL reslut, id data) {
            if(reslut){
                
                NSMutableDictionary *imBodyDic = [imChatLogModel.imClmBodyModel.body mutableCopy];
                [imBodyDic setValue:data forKey:@"rmid"];
                [msgInfo setObject:imBodyDic forKey:@"body"];
                
                [weakSelf resetXHShareMenuView];
                [weakSelf didCommonSaveAndSend:msgInfo mediaType:XHBubbleMessageMediaTypePhoto];
            } else {
                [weakSelf resetXHShareMenuView];
                [weakSelf didCommonSaveAndSend:msgInfo mediaType:XHBubbleMessageMediaTypePhoto status:NO];
            }
        }];
}

/**
 *  转发，消息模板类型消息
 */
- (void)didResendCustomMsg:(ImChatLogModel *)imChatLogModel{

    NSMutableDictionary *msgInfo = [chatViewModel getSendMsgInfo:[self resetDialogID] handlerType:imChatLogModel.handlertype];
    [msgInfo setValue:imChatLogModel.imClmBodyModel.body forKey:@"body"];
    [msgInfo setValue:imChatLogModel.imClmBodyModel.app forKey:@"app"];
    [msgInfo setValue:imChatLogModel.imClmBodyModel.content forKey:@"content"];

    [self resetXHShareMenuView];
    [self didCommonSaveAndSend:msgInfo mediaType:XHBubbleMessageMediaTypePhoto];
}

#pragma mark - 发送物理文件，内部调用


/**
 发送物理文件，获取到icon之后执行

 @param msgInfo 待发送消息信息
 */
-(void)sendFileAfterGetIcon:(NSMutableDictionary *)msgInfo progressBlock:(ChatViewModelUpdateFileUploadProgress)progressBlock{
    /* 保存入库 */
    ImChatLogModel *imChatLogModel = [chatViewModel saveChatLogModelWithDic:msgInfo];
    
    /* 刷新页面 */
    XHMessage *xhMessage = [chatViewModel addNewXHMessageWithImChatLogModel:imChatLogModel messages:self.messages];
    xhMessage.sendStatus = Chat_Msg_Sending;
    /* 当前人不在群组中时，发送消息 */
    if(_contactType != Chat_ContactType_Main_One &&
       (toGroupModel==nil || toGroupModel.isclosed==1 || (imRecentModel!=nil && imRecentModel.isexistsgroup==0)) ){
        xhMessage.sendStatus = Chat_Msg_SendFail;
    }
    WEAKSELF
    __block ChatViewModel *blockChatViewModel = chatViewModel;
    [self addMessage:xhMessage isSend:YES callBack:^(id data) {
        [weakSelf finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeFile];
        
        /* 当前人不在群组中时，发送消息 */
        if(_contactType != Chat_ContactType_Main_One &&
           (toGroupModel==nil || toGroupModel.isclosed==1 || (imRecentModel!=nil && imRecentModel.isexistsgroup==0)) ){
            return;
        } else {
//            /* 添加到消息队列 */
//            [blockChatViewModel addToMsgQueue:msgInfo];
           
            [blockChatViewModel addToUploadFileQueueAndBegin:imChatLogModel progressBlock:progressBlock];
            
        }
    }];
}

#pragma mark - 接收

/**
 *  接收到新的消息
 *
 *  @param dataDic 消息数据
 *
 *  @return 消息ID
 */
-(NSString *)didReceiveMessage:(ImChatLogModel *)imChatLogModel{
    if( [imChatLogModel.dialogid  isEqualToString:_dialogid] ){
        /* 刷新页面 */
        XHMessage *xhMessage = [chatViewModel addNewXHMessageWithImChatLogModel:imChatLogModel messages:self.messages];
        [self addMessage:xhMessage isSend:NO callBack:nil];
        return imChatLogModel.msgid;
    } else {
        return nil;
    }
}

#pragma mark - LZShareMenuView Delegate更多操作的代理方法

/**
 *  点击更多功能后事件处理
 *
 *  @param lzShareMenuItem 功能项
 *  @param index           序号
 */
- (void)didSelecteLZShareMenuItem:(LZShareMenuItem *)lzShareMenuItem atIndex:(NSInteger)index {
    DDLogVerbose(@"title : %@   index:%ld", lzShareMenuItem.title, (long)index);
    [self.lzShareMenuView showOrHideThis:YES];

    switch (index) {
        /* 拍照 */
//        case 0: {
//            [super didSelecteLZShareMenuItem:lzShareMenuItem atIndex:index];
//            break;
//        }
        /* 图片 */
        case 0: {
            WEAKSELF
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithDelegate:nil];
            /* 控制显不显示视频文件 */
            imagePickerVc.allowPickingVideo = YES;
            
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                
                NSString *savePath=[FilePathUtil getChatSendImageDicAbsolutePath];
                [[[TZImagePickerViewModel alloc] init] operateSelectedPhotos:photos assets:assets isSelectOriginalPhoto:isSelectOriginalPhoto savePath:savePath callBack:^(NSMutableArray *backArr) {
                    [weakSelf didSendAblumAction:backArr];
                }];
            }];
            // 从相册中选择视频发送
            [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
                
                /* 视频保存路径 */
                NSString *savePath=[FilePathUtil getChatSendImageDicAbsolutePath];
                /* 把封面图片保存到沙盒中 */
                NSString *paths =[FilePathUtil getChatSendImageSmallDicAbsolutePath];
                [[[TZImagePickerViewModel alloc] init] operateSelectedVideo:coverImage asset:asset savePath:savePath smallPaths:paths callBack:^(NSString *imageName, NSString *path, NSString *filePhysicalName) {
                    
                    /* 先将视频当做文件进行发送 */
                    UploadFileModel *fileModel = [[UploadFileModel alloc] init];
                    fileModel.filePhysicalName = filePhysicalName;
                    fileModel.fileShowName = vedioStr;
                    NSMutableArray *sendArr = [[NSMutableArray alloc] init];
                    [sendArr addObject:fileModel];
                    
                    [weakSelf didSendFileAction:sendArr];
                    /* 视频当做视频发送 */
//                    [weakSelf didSendVideoAction:imageName path:path filePhysicalName:filePhysicalName];
                }];
            }];

            [self presentViewController:imagePickerVc animated:YES completion:nil];
            break;
        }
        /* 视频 */
        case 1: {
            MARFaceBeautyController *wechatShortVideoController = [[MARFaceBeautyController alloc] init];
            wechatShortVideoController.delegate = self;
            wechatShortVideoController.showStyle = GPUImageShowStyleAll;
            wechatShortVideoController.isShowEditButton = YES;
            [self presentViewController:wechatShortVideoController animated:YES completion:nil];
            break;
        }
        /* 名片 */
        case 2: {
            [self selectUserForCard];
            break;
        }
        /* 云盘 */
        case 3:{
            NSString *folderRpid = [[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"rpid"];
           // ResFolderModel *resFolderModel = [[ResFolderDAL shareInstance] getRootFolderModelWithRpid:folderRpid];
            if(folderRpid == nil)
            {
                [UIAlertView alertViewWithMessage:LZGDCommonLocailzableString(@"message_cloud_init_error")];
                return;
            }

            [self selectFileFromNetDisk];
            break;
        }
        /* 位置 */
        case 4:{
            [self selectGeolocations];
            break;
        }
        /* 通话（语音和视频）*/
        case 5:{
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:LZGDCommonLocailzableString(@"common_cancel")
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:LZGDCommonLocailzableString(@"message_voice_call"),
                                          LZGDCommonLocailzableString(@"message_video_call"), nil];
            actionSheet.tag=4000;
            [actionSheet showInView:self.view];
            break;
        }
        
        default:
            break;
    }
}

/* 根据聊天框下面更多菜单项目名称得到索引数 */
- (NSInteger)getIndexFromShareMenuItemTitle:(NSString *)title {
    if ([title isEqualToString:LZGDCommonLocailzableString(@"message_photo")]) {
        return 0;
    } else if ([title isEqualToString:LZGDCommonLocailzableString(@"message_photo_video")]) {
        return 1;
    } else if ([title isEqualToString:LZGDCommonLocailzableString(@"message_video_voice_call")]) {
        return 2;
    } else if ([title isEqualToString:LZGDCommonLocailzableString(@"message_readback")]) {
        return 3;
    } else if ([title isEqualToString:LZGDCommonLocailzableString(@"message_IDcard")]) {
        return 4;
    } else if ([title isEqualToString:LZGDCommonLocailzableString(@"message_cloud")]) {
        return 5;
    } else if ([title isEqualToString:LZGDCommonLocailzableString(@"message_location")]) {
        return 6;
    } else {
        return 100;
    }
}
#pragma mark - XHShareMenuView Delegate

- (void)didSelecteShareMenuItem:(XHShareMenuItem *)shareMenuItem atIndex:(NSInteger)index title:(NSString *)title {
    DDLogVerbose(@"title : %@   index:%ld", shareMenuItem.title, (long)index);
    
//    if (_contactType == Chat_ContactType_Main_One && index>2) {
//        index += 1;
//    }
//    if (![AppUtils checkIsPublicServer:@"chatvideo"] &&  ![[[LZUserDataManager readAvailableDataContext] lzNSStringForKey:@"videoenable"] isEqualToString:@"1"] && _parsetype!=0 && index>1) {
//        index += 1;
//    }
    NSInteger ind = [self getIndexFromShareMenuItemTitle:title];
    switch (ind) {
        case 0: {
            WEAKSELF
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithDelegate:nil];
            /* 控制显不显示视频文件 */
            imagePickerVc.allowPickingVideo = YES;
            
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                
                NSString *savePath=[FilePathUtil getChatSendImageDicAbsolutePath];
                [[[TZImagePickerViewModel alloc] init] operateSelectedPhotos:photos assets:assets isSelectOriginalPhoto:isSelectOriginalPhoto savePath:savePath callBack:^(NSMutableArray *backArr) {
                    [weakSelf didSendAblumAction:backArr];
                }];
            }];
            // 从相册中选择视频发送
            [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
                
                /* 视频保存路径 */
                NSString *savePath=[FilePathUtil getChatSendImageDicAbsolutePath];
                /* 把封面图片保存到沙盒中 */
//                NSString *paths =[FilePathUtil getChatSendImageDicAbsolutePath];
                [[[TZImagePickerViewModel alloc] init] operateSelectedVideo:coverImage asset:asset savePath:savePath smallPaths:savePath callBack:^(NSString *imageName, NSString *path, NSString *filePhysicalName) {
//                    vedioStr = [[asset valueForKey:@"filename"] uppercaseString];
//                    /* 先将视频当做文件进行发送 */
//                    UploadFileModel *fileModel = [[UploadFileModel alloc] init];
//                    fileModel.filePhysicalName = filePhysicalName;
//                    fileModel.fileShowName = [NSString isNullOrEmpty:vedioStr] ? @"IMG_1234.MP4" : vedioStr;
//                    NSMutableArray *sendArr = [[NSMutableArray alloc] init];
//                    [sendArr addObject:fileModel];
                    
//                    [weakSelf didSendFileAction:sendArr];
                    /* 视频当做视频发送 */
                    [weakSelf didSendVideoActionCoverName:imageName filePhysicalName:filePhysicalName];
                }];
            }];
            
            /* 发送编辑过后的图片 */
            [imagePickerVc setDidFinishImageEdit:^(UIImage * image, NSString *imagename){
                /* 保存图片 */
                NSData *data =UIImageJPEGRepresentation(image, 1.0);
                NSString *savePath=[FilePathUtil getChatSendImageDicAbsolutePath];
                UploadFileModel *fileModel =  [[[TZImagePickerViewModel alloc] init] savePhotoAndReturnModel:data savePath:savePath filePhysicalName:imagename fileShowName:imagename showIndex:0];
                
                if(fileModel!=nil){
                    [weakSelf didSendAblumAction:[NSMutableArray arrayWithObject:fileModel]];
                }
            }];
            imagePickerVc.isAllowEditImage = YES; // 是否允许编辑图片
            
            [self presentViewController:imagePickerVc animated:YES completion:nil];
            break;
        }
            /* 视频 */
        case 1: {
            MARFaceBeautyController *wechatShortVideoController = [[MARFaceBeautyController alloc] init];
            wechatShortVideoController.delegate = self;
            wechatShortVideoController.showStyle = GPUImageShowStyleAll;
            wechatShortVideoController.isShowEditButton = YES;
            [self presentViewController:wechatShortVideoController animated:YES completion:nil];
            break;
        }
            /* 通话（语音和视频）*/
        case 2:{
            /* 如果是单人聊天 */
            if (_contactType == Chat_ContactType_Main_One) {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                         delegate:self
                                                                cancelButtonTitle:LZGDCommonLocailzableString(@"common_cancel")
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:LZGDCommonLocailzableString(@"message_video_call"), LZGDCommonLocailzableString(@"message_voice_call"), nil];
                actionSheet.tag=4000;
                [actionSheet showInView:self.view];
            } else {
                ImGroupCallModel *model = [[ImGroupCallDAL shareInstance] getimGroupCallModelWithGroupid:[self resetDialogID]];
                /* 当前人不在群组中时，发送消息 */
                if(_contactType != Chat_ContactType_Main_One &&
                   (toGroupModel==nil || toGroupModel.isclosed==1 || (imRecentModel!=nil && imRecentModel.isexistsgroup==0)) ){
                    [self showErrorWithText:@"语音聊天发起失败"];
                }
                else if (self.appDelegate.lzGlobalVariable.msgCallStatus != MsgCallStatusNone) {
                    [self showMessageInfoWithText:@"正在语音聊天，不能再次发起"];
                }
                else if (self.groupCallNum > 0 && [model.chatusers rangeOfString:[AppUtils GetCurrentUserID]].location == NSNotFound) {
                    [self isJoinGroupCallBtnClick];
                } else {
                    ChatGroupUserListViewController *groupUserVC = [[ChatGroupUserListViewController alloc] init];
                    groupUserVC.toGroupModel = toGroupModel;
                    groupUserVC.mode = ChatGroupList_SelectGroupMember;
                    groupUserVC.pageViewMode = ContactPageViewModeSelect;
                    groupUserVC.selectDelegate = self;
                    [self modalShowController:groupUserVC];
                }
            }
            
            break;
        }
            /* 回执消息 */
        case 3: {
            isrecordstatus = !isrecordstatus;
            NSInteger index = 2;
            if (([AppUtils checkIsPublicServer:@"chatvideo"] || [[[LZUserDataManager readAvailableDataContext] lzNSStringForKey:@"videoenable"] isEqualToString:@"1"]) && _parsetype==0) {
                index = 3;
            }
            if (isrecordstatus) {
                XHShareMenuItem *readAndUnread = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:@"msg_chat_tool_receipt_active"] title:LZGDCommonLocailzableString(@"message_readback")];
                [self.shareMenuItems replaceObjectAtIndex:index withObject:readAndUnread];
                self.shareMenuView.shareMenuItems = self.shareMenuItems;
                [self.shareMenuView reloadData];
                self.messageInputView.inputTextView.placeHolder = @"回执消息...";
            } else {
                XHShareMenuItem *readAndUnread = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:@"msg_chat_tool_receipt_default"] title:LZGDCommonLocailzableString(@"message_readback")];
                [self.shareMenuItems replaceObjectAtIndex:index withObject:readAndUnread];
                self.shareMenuView.shareMenuItems = self.shareMenuItems;
                [self.shareMenuView reloadData];
                self.messageInputView.inputTextView.placeHolder = @"发送新消息";
            }
            /* 弹出键盘 */
            [self.messageInputView.inputTextView becomeFirstResponder];
            self.messageInputView.multiMediaSendButton.selected = NO;
            
            break;
        }
            /* 名片 */
        case 4: {
            [self selectUserForCard];
            break;
        }
            /* 云盘 */
        case 5:{
            NSString *folderRpid = [[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"rpid"];
            // ResFolderModel *resFolderModel = [[ResFolderDAL shareInstance] getRootFolderModelWithRpid:folderRpid];
            if(folderRpid == nil)
            {
                [UIAlertView alertViewWithMessage:LZGDCommonLocailzableString(@"message_cloud_init_error")];
                return;
            }
            
            [self selectFileFromNetDisk];
            break;
        }
            /* 位置 */
        case 6:{
            [self selectGeolocations];
            break;
        }
        case 100: {
            msgAppModel = [[ImMsgAppDAL shareInstance] getImMsgAppModelWithName:title];
            NSArray <OrgEnterPriseModel *> *orgArr= [[OrgEnterPriseDAL shareInstance] getOrgEnterPrises];
            if (orgArr.count == 0 || orgArr == nil) {
                [LZToast showWithText:@"暂无企业支持此应用"];
            } else if (orgArr.count == 1) {
                /* 判断网络是否连同 */
                if([LZUserDataManager readIsConnectNetWork]){
                    /* 判断企业下是否给某应用授权 */
                    [self.appDelegate.lzservice sendToServerQueueForGet:WebApi_Organization routePath:Contact_WebApi_OrgLicense_IsExistsAuth moduleServer:Modules_Default getData:@{@"orgid":[AppUtils GetCurrentOrgID],@"appid":msgAppModel.appid} otherData:nil];
                } else {
                    [self showNetWorkConnectFail];
                }
            } else {
                MoreSwitchIdentityViewController *mSwitchIdentityVC = [[MoreSwitchIdentityViewController alloc]init];
                mSwitchIdentityVC.msgAppModel = msgAppModel;
                mSwitchIdentityVC.switchIdentityMode = SwitchIdentityModeSelete;
                mSwitchIdentityVC.dialogid = [self resetDialogID];
                mSwitchIdentityVC.contactType = _contactType;
                [self pushNewViewController:mSwitchIdentityVC];
            }
            
            break;
        }
        
        default:
            break;
    }
}

/**
 每次发完消息，需要重新回到未选状态
 */
- (void)resetXHShareMenuView {
    if(!isrecordstatus){
        return;
    }
    if (_contactType == Chat_ContactType_Main_One ||
        _contactType == Chat_ContactType_Main_ChatGroup ||
        _contactType == Chat_ContactType_Main_CoGroup ||
        _contactType == Chat_ContactType_Main_App_Seven ||
        _contactType == Chat_ContactType_Main_App_Eight) {
        NSInteger index = 2;
        if (([AppUtils checkIsPublicServer:@"chatvideo"] || [[[LZUserDataManager readAvailableDataContext] lzNSStringForKey:@"videoenable"] isEqualToString:@"1"]) && _parsetype==0) {
            index = 3;
        }
        isrecordstatus = NO;
        XHShareMenuItem *readAndUnread = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:@"msg_chat_tool_receipt_default"] title:LZGDCommonLocailzableString(@"message_readback")];;
        [self.shareMenuItems replaceObjectAtIndex:index withObject:readAndUnread];
        self.shareMenuView.shareMenuItems = self.shareMenuItems;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.shareMenuView reloadData];
            self.messageInputView.inputTextView.placeHolder = @"发送新消息";
        });
    }
}

#pragma mark - WechatShortVideoDelegate

/**
 点击拍照，发送照片
 */
-(void)finishAliPhotoImage:(NSString *)imagePath {
    DDLogVerbose(@"照片的路径：%@", imagePath);
    /* 保存图片的路径 */
    NSString *savePath=[FilePathUtil getChatSendImageDicAbsolutePath];
    
    NSString *filePhysicalName = [NSString stringWithFormat:@"%@.JPG",[LZFormat FormatNow2String]];
    NSString *fileShowName = [NSString stringWithFormat:@"IMG_%@.JPG", [[LZFormat FormatNow2String] substringWithRange:NSMakeRange(10, 4)]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    /* 把图片拷到沙盒中 */
    [fileManager copyItemAtPath:imagePath toPath:[savePath stringByAppendingFormat:@"%@",filePhysicalName] error:nil];
    /* 删除原路径的图片 */
    [fileManager removeItemAtPath:imagePath error:nil];
    NSMutableArray *sendArr = [NSMutableArray array];
    /* 保存图片 */
    UploadFileModel *fileModel = [[UploadFileModel alloc] init];
    fileModel.filePhysicalName = filePhysicalName;
    fileModel.fileShowName = fileShowName;
    if(fileModel!=nil){
        [sendArr addObject:fileModel];
    }
    [self didSendAblumAction:sendArr];
}

-(void)finishAliPlayShortVideo:(NSString *)videoPath {
    NSLog(@"小视频的filePath is %@", videoPath);
    NSString *extendName = @""; //后缀名
    NSString *filePhysicalName = @""; //磁盘名称
    extendName = [videoPath pathExtension];
    filePhysicalName = [NSString stringWithFormat:@"%@.%@",[LZFormat FormatNow2String],extendName];
    
    /* 把文件保存到本地沙盒 */
    NSString *savePath=[FilePathUtil getChatSendImageDicAbsolutePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    /* 把文件拷到沙盒中 */
    [fileManager copyItemAtPath:videoPath toPath:[savePath stringByAppendingFormat:@"%@",filePhysicalName] error:nil];
    /* 删除原路径的视频 */
    [fileManager removeItemAtPath:videoPath error:nil];
    
    /* 得到小视频的封面 ,官方显示已知的地址类型字符串，就要用下面这个方法转成NSURL*/
    NSURL *url = [[NSURL alloc] initFileURLWithPath:[savePath stringByAppendingFormat:@"%@",filePhysicalName]];
    UIImage *coverImage = [self thumbnailImageForVideo:url];
    
    /* 把封面图片保存到沙盒中 */
    NSString *imageName = [NSString stringWithFormat:@"%@.%@",[LZFormat FormatNow2String],@"JPG"];
    NSString *filePaths = [savePath stringByAppendingPathComponent:imageName];  // 保存文件的名称
    [UIImagePNGRepresentation(coverImage) writeToFile:filePaths atomically:YES];// 将图片写入文件
    
    /* 视频压缩 */
    //    NSString *showName = [NSString stringWithFormat:@"IMG_%@.MP4", [[LZFormat FormatNow2String] substringWithRange:NSMakeRange(10, 4)]];
    NSString *newFilePhysicalName = [NSString stringWithFormat:@"%@.%@",[LZFormat FormatNow2String],extendName];
    NSString *newPlistPath =[savePath stringByAppendingPathComponent:newFilePhysicalName];
    [TZImagePickerViewModel compressVideoWithInputURL:url outputURL:[NSURL fileURLWithPath:newPlistPath] blockHandler:^(AVAssetExportSession *session) {
        if (session.status == AVAssetExportSessionStatusCompleted) {
            NSData *data = [NSData dataWithContentsOfFile:newPlistPath];
            /* 删除压缩前的视频 */
            [fileManager removeItemAtURL:url error:nil];
            NSLog(@"压缩后视频的大小：%lu",(unsigned long)data.length);
            NSLog(@"压缩完成");
            /* 将视频文件上传 */
            [self didSendVideoActionCoverName:imageName filePhysicalName:newFilePhysicalName];
        }else if (session.status == AVAssetExportSessionStatusFailed) {
            NSLog(@"压缩失败");
        }
    }];
}

/* 获取视频封面，本地视频，网络视频都可以用 */
- (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(2.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumbImg = [[UIImage alloc] initWithCGImage:image];
    return thumbImg;
}

/**
 根据路径获取视频时长和大小
 */
- (NSDictionary *)getVideoInfoWithSourcePath:(NSString *)path{
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    CMTime time = [asset duration];
    int totalSeconds = ceil(time.value/time.timescale);
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    NSString *duration = @"";
    if (hours > 0) {
        duration = [NSString stringWithFormat:@"%02d:%02d", hours, minutes];
    } else {
        duration = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
    NSInteger fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    return @{@"size" : @(fileSize),
             @"duration" : duration};
}

#pragma mark - 发送云盘文件

-(void)selectFileFromNetDisk{
    NetIndexFileSelectViewController *seclet = [[NetIndexFileSelectViewController alloc] init];
    seclet.delegate = self;
    XHBaseNavigationController *navController=[[XHBaseNavigationController alloc]initWithRootViewController:seclet];
    [self presentViewController:navController animated:YES completion:nil];
}

/* 调用选文件代理 */
-(void)didFinishFileSelectWithArray:(NSMutableArray *)didSelectFile
{
    for (int i = 0; i < [didSelectFile count]; i++) {
        ResModel *resModel = didSelectFile[i];
        NSLog(@"%@",resModel.name);
        
        [self didSendNetDiskFile:resModel];
    }
    [self resetXHShareMenuView];
}

#pragma mark - 发送名片

-(void)selectUserForCard{
    ContactRootViewController2 *controller = [[ContactRootViewController2 alloc] initWithPageViewModel:ContactPageViewModeSelect];
    ContactSelectParamsModel *selectParams = [[ContactSelectParamsModel alloc] init];
    selectParams.selectType = ContactSelectTypeSingle;
    controller.selectParams = selectParams;
    controller.selectDelegate = self;
    [self modalShowController:controller];
}

/**
 *  确定人员选择
 */
-(void)contactSelectOK:(UIViewController *)controller selectedUserModels:(NSMutableArray *)selectedUserModels otherInfo:(NSMutableDictionary *)otherInfo{
    if ([controller isKindOfClass:[ChatGroupUserListViewController class]] &&
        [[otherInfo objectForKey:@"info"] isEqualToString:@"selectMember"]) {
        if (selectedUserModels.count > 6) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请最多选择6人" message:nil delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm") otherButtonTitles:nil];
            [alertView show];
            return;
        }
        /* 发起多人视频通话 */
        NSString *roomID = [LZUtils CreateGUID];
        NSMutableArray *selectArr = [NSMutableArray array];
        for (UserModel *userModel in selectedUserModels) {
            NSInteger uid = [LZUtils getRandomNumber];
            NSDictionary *userDic = @{@"uid":userModel.uid, @"face":userModel.face, @"name":userModel.username, @"agorauid":[NSNumber numberWithInteger:uid], @"jointime":[[AppDateUtil GetCurrentDateForString] stringByReplacingOccurrencesOfString:@" " withString:@"T"]};
            
            [selectArr addObject:userDic];
        }
        UserModel *mineModel = [[UserDAL shareInstance] getUserDataWithUid:currentUserID];
        /* 将自己也加到数组中 */
        [selectArr addObject:@{@"uid":currentUserID, @"face":mineModel.face, @"name":mineModel.username, @"agorauid":[NSNumber numberWithInteger:[LZUtils getRandomNumber]], @"jointime":[[AppDateUtil GetCurrentDateForString] stringByReplacingOccurrencesOfString:@" " withString:@"T"]}];
        [self dismissViewControllerAnimated:YES completion:^{
            
            /* 设置正在通话中状态 */
            self.appDelegate.lzGlobalVariable.msgCallStatus = MsgCallStatusIsVoice;
            [[LZChatVideoModel shareInstance] addChatGroupRoomViewRoomName:roomID
                                                               UserInfoArr:selectArr
                                                                     Other:@{@"dialogid":[self resetDialogID],
                                                                             @"contacttype":[NSNumber numberWithInteger:_contactType],
                                                                             @"groupname":toGroupModel.name,
                                                                             @"iscanspeechuid":[toGroupModel.createuser isEqualToString:currentUserID] ?@"1":@"0",
                                                                             @"isinitiateuid":@"1"
                                                                             }
                                                                   IsVideo:nil];
            /* 发送系统消息（xxx发起视频通话） */
            [self sendVideoCallForGroup:Chat_Group_Call_State_Request userArr:selectArr channelid:roomID other:@{@"iscallother":@"1", @"timeout":@"60"}];
        }];
    }
    /* 发送名片 */
    else {
        sendCardUserModel = [selectedUserModels objectAtIndex:0];
        [self dismissViewControllerAnimated:YES completion:^{
            NSString *message = [NSString stringWithFormat:LZGDCommonLocailzableString(@"message_issendcardto_chat"),sendCardUserModel.username];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_cancel") otherButtonTitles:LZGDCommonLocailzableString(@"common_confirm"), nil];
            alertView.tag = 1;
            [alertView show];
        }];
    }
}


#pragma mark - 发送地理位置

-(void)selectGeolocations{
    
    MapNearbyLocationViewController2 * mapVc = [[MapNearbyLocationViewController2 alloc] init];
//    mapVc.isClickOnMAMapView=YES;
//    mapVc.mapLocationStyle = MapLocationStyleSelectSinglePOI;
    MapSelectPOIlocationsBlock poiBlock = ^(MAMapView *mapView, AMapPOI *poi){
        [self showLoadingWithText:LCProgressHUD_Show_Processing];
        
        CGFloat imgWidth = mapView.width > mapView.height ? mapView.height : mapView.width;
        CGFloat imgHeight = (imgWidth * CHATVIEW_GeoLocation_Height)/CHATVIEW_GeoLocation_Width;
//        CGFloat lblHeight = 30;
        /* 先成一张缩略图 */
//        [mapView takeSnapshotInRect:CGRectMake( (mapView.width-imgWidth)/2 , lblHeight, imgWidth, imgWidth) withCompletionBlock:^(UIImage *resultImage, CGRect rect) {
        [mapView takeSnapshotInRect:CGRectMake( XH_TextLeftTextHorizontalBubblePadding*2 , (mapView.height-(imgHeight))/2, imgWidth, imgHeight) withCompletionBlock:^(UIImage *resultImage, NSInteger state) {
            NSString *saveSendPath=[FilePathUtil getChatSendImageDicAbsolutePath];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *geoimagename = [NSString stringWithFormat:@"geolocation_%@.jpg",[LZFormat FormatNow2String]];
            /* 保存到原图路径 */
            UIImage *cutimage = [LZImageUtils ScaleImage:resultImage  width:CHATVIEW_GeoLocation_Width*1.5 height:CHATVIEW_GeoLocation_Height*1.5 ];
            [fileManager createFileAtPath:[saveSendPath stringByAppendingFormat:@"%@",geoimagename] contents:UIImageJPEGRepresentation(cutimage, 1) attributes:nil];
            
            /* 保存到小图路径 */
            [fileManager createFileAtPath:[[FilePathUtil getChatSendImageSmallDicAbsolutePath] stringByAppendingFormat:@"%@",geoimagename] contents:UIImageJPEGRepresentation(cutimage, 1) attributes:nil];
            
            /* 地图缩放比例 */
            CGFloat zoom = mapView.zoomLevel;
            /* 经度 */
            CGFloat longitude = poi.location.longitude;
            /* 维度 */
            CGFloat latitude = poi.location.latitude;
            /* 地址 */
            NSString *address = poi.name;
            /* 具体位置 */
            NSString *position = [NSString stringWithFormat:@"%@%@%@",poi.city,poi.district,poi.address];
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                [LCProgressHUD hide];
                [self hideLoading];
                [self didSendLocationAction:geoimagename zoom:zoom longitude:longitude latitude:latitude address:address position:position];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
    };
    mapVc.mapSuccessPOIBlocks = poiBlock;
    [self.navigationController pushViewController:mapVc animated:YES];
}

#pragma mark - 发送@

/**
 *  内容改变后调用
 *
 *  @param textView TextView
 */
- (void)textDidChange:(UITextView *)textView{

    toGroupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:[self resetDialogID]];
//    self.messageInputView.inputTextRange = textView.selectedRange;
    NSString *msg = textView.text;
    NSString *preMsg = @"";
    NSString *sufMsg = @"";
    if (![NSString isNullOrEmpty:msg]) {
        preMsg = [msg substringToIndex:textView.selectedRange.location];
        sufMsg = [msg substringFromIndex:textView.selectedRange.location];
    }
    
    DDLogVerbose(@"新的待处理消息---%@",msg);
    
    /* 重新处理表情信息，判断表情是否仍在输入框中 */
    NSMutableArray *forRemoveEmotionArr = [[NSMutableArray alloc] init];
    for(int i=0;i<[self.emotionsDic allKeys].count; i++){
        NSString *index = [[self.emotionsDic allKeys] objectAtIndex:i];
        NSString *name = [self.emotionsDic lzNSStringForKey:index];
        if( [msg rangeOfString:name].location == NSNotFound ){
            [forRemoveEmotionArr addObject:index];
        }
    }
    for( int i=0;i<forRemoveEmotionArr.count;i++ ){
        [self.emotionsDic removeObjectForKey:[forRemoveEmotionArr objectAtIndex:i]];
    }
    
    /* 处理@相关数据 */
    if(_contactType != Chat_ContactType_Main_One){
        /* 重新处理@的人员，判断@数组中的人员是否仍在输入框中 */
        NSMutableArray *forRemoveAtArr = [[NSMutableArray alloc] init];
        for(int i=0;i<[atUsersDic allKeys].count; i++){
            NSString *uid = [[atUsersDic allKeys] objectAtIndex:i];
            NSString *name = [atUsersDic lzNSStringForKey:uid];
            if(![msg containsString:@"@所有人 "] && [msg rangeOfString:name].location == NSNotFound){
                [forRemoveAtArr addObject:uid];
            }
        }
        for( int i=0;i<forRemoveAtArr.count;i++ ){
            [atUsersDic removeObjectForKey:[forRemoveAtArr objectAtIndex:i]];
        }
        
        /* 判断是否需要弹出@好友界面 */
        if((([preMsgText isEqualToString:@""] || [msg hasPrefix:preMsgText] || ([msg isEqualToString:@"@"] && ![NSString isNullOrEmpty:sufMsg])) && [msg hasSuffix:@"@"]) ||
           ([preMsg hasSuffix:@"@"] && ![NSString isNullOrEmpty:sufMsg])){
            
            isFromAtPersonBack = YES;
            ChatGroupUserListViewController *groupUserVC = [[ChatGroupUserListViewController alloc] init];
            groupUserVC.toGroupModel = toGroupModel;
            groupUserVC.mode = ChatGroupList_AtMode;
            
            /* 点击取消按钮的方法回调 */
            ChatGroupUserListCancleBlock cancleBlock = ^(){
                [self dismissViewControllerAnimated:YES completion:^{
//                    [self.messageInputView.inputTextView becomeFirstResponder];
                }];
            };
            /* 点击列表中人员的方法回调 */
            ChatGroupUserListSelectUserBlock selectUserBlock = ^(ImGroupUserModel *imGroupUserModel){
                [self dismissViewControllerAnimated:YES completion:^{
                    NSMutableString *tmpText = [textView.text mutableCopy];
//                    textView.text = [textView.text stringByAppendingFormat:@"%@ ",imGroupUserModel.username];
                    NSString *insertStr = [NSString stringWithFormat:@"%@ ", imGroupUserModel.username];
                    NSUInteger loc = textView.selectedRange.location;
                    [tmpText insertString:insertStr atIndex:loc];
                    textView.text = tmpText;
                    /* 设置当前光标到那个位置 */
                    NSRange range = textView.selectedRange;
                    range.location = loc + insertStr.length;
                    textView.selectedRange = range;
                    [textView setSelectedRange:textView.selectedRange];
                    if(![[atUsersDic allKeys] containsObject:imGroupUserModel.uid]){
                        [atUsersDic setObject:[NSString stringWithFormat:@"@%@ ",imGroupUserModel.username] forKey:imGroupUserModel.uid];
                    }
                    preMsgText = msg;
//                    [self.messageInputView.inputTextView becomeFirstResponder];
                }];
            };
            /* 点击@全员 */
            ChatGroupUserListSelectAtAllUserBlock selectAtAllUserBlock = ^(NSMutableArray<ImGroupUserModel *> *atAllGroupUserArr) {
                [self dismissViewControllerAnimated:YES completion:^{
                    NSMutableString *tmpText = [textView.text mutableCopy];
                    NSString *insertStr = @"所有人 ";
                    NSUInteger loc = textView.selectedRange.location;
                    [tmpText insertString:insertStr atIndex:loc];
                    textView.text = tmpText;
                    /* 设置当前光标到那个位置 */
                    NSRange range = textView.selectedRange;
                    range.location = loc + insertStr.length;
                    textView.selectedRange = range;
                    [textView setSelectedRange:textView.selectedRange];
                    for (ImGroupUserModel *tmpModel in atAllGroupUserArr) {
                        if(![[atUsersDic allKeys] containsObject:tmpModel.uid]){
                            [atUsersDic setObject:[NSString stringWithFormat:@"@%@ ",tmpModel.username] forKey:tmpModel.uid];
                        }
                    }
                    
                    preMsgText = msg;
                }];
            };
            /* 点击机器人 */
            ChatGroupUserListSelectRobotBlock selectRobotBlock = ^(ImGroupRobotModel *imGroupRobotModel) {
                [self dismissViewControllerAnimated:YES completion:^{
                    NSMutableString *tmpText = [textView.text mutableCopy];
                    //                    textView.text = [textView.text stringByAppendingFormat:@"%@ ",imGroupUserModel.username];
                    NSString *insertStr = [NSString stringWithFormat:@"%@ ", imGroupRobotModel.name];
                    NSUInteger loc = textView.selectedRange.location;
                    [tmpText insertString:insertStr atIndex:loc];
                    textView.text = tmpText;
                    /* 设置当前光标到那个位置 */
                    NSRange range = textView.selectedRange;
                    range.location = loc + insertStr.length;
                    textView.selectedRange = range;
                    [textView setSelectedRange:textView.selectedRange];
                    if(![[atRobotDic allKeys] containsObject:imGroupRobotModel.bussinessid]){
                        [atRobotDic setObject:[NSString stringWithFormat:@"@%@ ",imGroupRobotModel.name] forKey:imGroupRobotModel.bussinessid];
                    }
                    
                    preMsgText = msg;
                }];
            };
            groupUserVC.cancleBlock = cancleBlock;
            groupUserVC.selectUserBlock = selectUserBlock;
            groupUserVC.selectAtAllUserBlock = selectAtAllUserBlock;
            groupUserVC.selectRobotBlock = selectRobotBlock;
            
            XHBaseNavigationController *navController=[[XHBaseNavigationController alloc]initWithRootViewController:groupUserVC];
            [self presentViewController:navController animated:YES completion:nil];
        }
    }
    
    preMsgText = msg;
}

#pragma mark - XHMessageTableViewCell delegate

/**
 头像长按事件的处理
 */
- (void)longPressGestureInFaceButton:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    DDLogVerbose(@"在我这里处理长按问题");
    /* 所点人的uid */
    NSString *clickUid = message.imChatLogModel.from;
    NSString *sendUserName = message.imChatLogModel.imClmBodyModel.sendusername;
    /* 长按的头像不是自己并且不是单人聊天，才可以出现@ */
    if (![clickUid isEqualToString:currentUserID] && _contactType != Chat_ContactType_Main_One) {
        [self.messageInputView.inputTextView becomeFirstResponder];
        NSMutableString *tmpText = [self.messageInputView.inputTextView.text mutableCopy];
        if (message.imChatLogModel.fromtype == 20) {
            NSString *insertStr = [NSString stringWithFormat:@"@%@ ", sendUserName];
            NSUInteger loc = self.messageInputView.inputTextView.selectedRange.location;
            [tmpText insertString:insertStr atIndex:loc];
            self.messageInputView.inputTextView.text = tmpText;
            /* 设置当前光标到那个位置 */
            NSRange range = self.messageInputView.inputTextView.selectedRange;
            range.location = loc + insertStr.length;
            self.messageInputView.inputTextView.selectedRange = range;
            [self.messageInputView.inputTextView setSelectedRange:self.messageInputView.inputTextView.selectedRange];
            if(![[atRobotDic allKeys] containsObject:clickUid]){
                [atRobotDic setObject:[NSString stringWithFormat:@"@%@ ",sendUserName] forKey:clickUid];
            }
        } else {
            NSString *insertStr = [NSString stringWithFormat:@"@%@ ", sendUserName];
            NSUInteger loc = self.messageInputView.inputTextView.selectedRange.location;
            [tmpText insertString:insertStr atIndex:loc];
            self.messageInputView.inputTextView.text = tmpText;
            /* 设置当前光标到那个位置 */
            NSRange range = self.messageInputView.inputTextView.selectedRange;
            range.location = loc + insertStr.length;
            self.messageInputView.inputTextView.selectedRange = range;
            [self.messageInputView.inputTextView setSelectedRange:self.messageInputView.inputTextView.selectedRange];
            
            if(![[atUsersDic allKeys] containsObject:clickUid]){
                [atUsersDic setObject:[NSString stringWithFormat:@"@%@ ",sendUserName] forKey:clickUid];
            }
        }
        
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.messageInputView.holdDownButton.alpha = NO;
            self.messageInputView.inputTextView.alpha = YES;
        } completion:^(BOOL finished) {
            
        }];
        preMsgText = self.messageInputView.inputTextView.text;
        /* 滚动到底部 */
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollToBottomAnimated:YES];
        });
    }
}

/**
 *  Cell点击后事件处理
 *
 *  @param message              消息
 *  @param indexPath            序号
 *  @param messageTableViewCell cell
 */
- (void)multiMediaMessageDidSelectedOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    
    if(message.messageMediaType == XHBubbleMessageMediaTypeVideo
       || message.messageMediaType == XHBubbleMessageMediaTypePhoto
       || message.messageMediaType == XHBubbleMessageMediaTypeEmotion
       || message.messageMediaType == XHBubbleMessageMediaTypeLocalPosition
       || message.messageMediaType == XHBubbleMessageMediaTypeCard
       || message.messageMediaType == XHBubbleMessageMediaTypeFile
       || message.messageMediaType == XHBubbleMessageMediaTypeUrl){
//        [self showLoadingWithText:LCProgressHUD_Show_Processing];
        if(!isEnableClickCell){
            return;
        }
        isEnableClickCell = NO;
    }
    
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeVideo:
        {
            /* 点击播放视频 */
            NSString *videoID = [[[message.imChatLogModel.body seriaToDic] lzNSDictonaryForKey:@"body"] lzNSStringForKey:@"videofileid"];
//            NSString *name = [[[message.imChatLogModel.body seriaToDic] lzNSDictonaryForKey:@"body"] lzNSStringForKey:@"name"];
            NSString *name = message.imChatLogModel.imClmBodyModel.fileModel.smallvideoclientname;
            if ([NSString isNullOrEmpty:name]) {
                name = [NSString stringWithFormat:@"%@.mp4",videoID];
            }
            // 发送失败的时候查看
            if ([NSString isNullOrEmpty:videoID]) {
                NSString *tempfileid =  [name substringToIndex:[name rangeOfString:@"." options:NSBackwardsSearch].location];
                videoID = tempfileid;
            }
            NSString *savePath = @"";
            NSString *relatePath = @"";
            if([message.imChatLogModel.imClmBodyModel.from isEqualToString:currentUserID]){
                savePath=[FilePathUtil getChatSendImageDicAbsolutePath];
                relatePath = [FilePathUtil getChatSendImageDicRelatePath];
            } else {
                savePath=[FilePathUtil getChatRecvImageDicAbsolutePath];
                relatePath = [FilePathUtil getChatRecvImageDicRelatePath];
            }
            DLog(@"message : %@", message.videoConverPhoto);
            ScanFileViewController *scan = [[ScanFileViewController alloc] init];
            scan.scanFileExpId = videoID; /* 视频id */
            scan.scanFileName = name;
            scan.scanFilePhysicalName = name;
            scan.scanFileAbsolutePath = savePath;
            scan.isResItem= YES;
            scan.scanFileSize = [[[[message.imChatLogModel.body seriaToDic] lzNSDictonaryForKey:@"body"] objectForKey:@"size"] longLongValue];
            scan.scanFileSmallAbsolutePath = [FilePathUtil getPostFileSmallDownloadDicAbsolutePath];
            scan.scanFileReleatePath = relatePath;
            scan.Vc = self;
            
            [scan lookFileForScanFileWithController:self];
            break;
        }
        case XHBubbleMessageMediaTypePhoto:
        case XHBubbleMessageMediaTypeEmotion:
            [self multiMediaPhotoMessageDidSelected:message
                                       atIndexPath:indexPath
                            onMessageTableViewCell:messageTableViewCell];
            break;
        case XHBubbleMessageMediaTypeVoice:
        {
            NSLog(@"---播放声音---");
            DLog(@"message : %@", message.voicePath);
            
            /* 未下载完时，点击不处理 */
            if(messageTableViewCell.messageBubbleView.voiceDurationLabel.hidden){
                return;
            }
            
            // Mark the voice as read and hide the red dot.
            message.isRead = YES;
            messageTableViewCell.messageBubbleView.voiceUnreadDotImageView.hidden = YES;
            
            /* 更新数据库数据 */
            ImChatLogBodyModel *bodyModel = message.imChatLogModel.imClmBodyModel;
            
            ImChatLogBodyInnerModel *innerBodyModel = message.imChatLogModel.imClmBodyModel.bodyModel;
            innerBodyModel.status = YES;
            bodyModel.body = [innerBodyModel convertModelToDictionary];
            
//            ImChatLogBodyVoiceModel *voiceModel = message.imChatLogModel.imClmBodyModel.voiceModel;
//            voiceModel.voiceIsRead = YES;
//            bodyModel.voiceinfo = [[voiceModel convertModelToDictionary] dicSerial];
            
            message.imChatLogModel.body = [[bodyModel convertModelToDictionary] dicSerial];
            [[ImChatLogDAL shareInstance] updateBody:[[message.imChatLogModel.imClmBodyModel convertModelToDictionary] dicSerial]
                                           withMsgId:message.imChatLogModel.msgid];
            
            [[XHAudioPlayerHelper shareInstance] setDelegate:(id<NSFileManagerDelegate>)self];
            if (currentSelectedCell) {
                [currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
            }
            if (currentSelectedCell == messageTableViewCell && messageTableViewCell!=nil) {
                [messageTableViewCell.messageBubbleView.animationVoiceImageView stopAnimating];
                [[XHAudioPlayerHelper shareInstance] stopAudio];
                currentSelectedCell = nil;
                [[XHAudioPlayerHelper shareInstance] setPlayingInfo:nil];
            } else {
                currentSelectedCell = messageTableViewCell;
                [messageTableViewCell.messageBubbleView.animationVoiceImageView startAnimating];
                [[XHAudioPlayerHelper shareInstance] setOtherInfo:message];
                [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:message.voicePath toPlay:YES];
                [[XHAudioPlayerHelper shareInstance] setPlayingInfo:message];
            }
            break;
        }
        case XHBubbleMessageMediaTypeLocalPosition:
        {
//            XHDisplayLocationViewController *displayLocationViewController = [[XHDisplayLocationViewController alloc] init];
//            displayLocationViewController.coordinate=[message.location coordinate];
//            displayLocationViewController.geolocations = [message geolocations];
//            [self.navigationController pushViewController:displayLocationViewController animated:YES];
            LZDisplayLocationViewController *disLocationVC=[[LZDisplayLocationViewController alloc]init];
            disLocationVC.zoomLevel=message.imChatLogModel.imClmBodyModel.bodyModel.geozoom;
            disLocationVC.coordinate=[message.location coordinate];
//            disLocationVC.name=[message geolocations];
            disLocationVC.name = message.imChatLogModel.imClmBodyModel.bodyModel.geoaddress;
            disLocationVC.address = message.imChatLogModel.imClmBodyModel.bodyModel.geodetailposition;
            [self.navigationController pushViewController:disLocationVC animated:YES];
            break;
        }
        case XHBubbleMessageMediaTypeCard:
        {
            DDLogVerbose(@"----点击名片-----%@",message.imChatLogModel.imClmBodyModel.bodyModel.face);
            ContactFriendInfoViewController2 *friendInfoController=[ContactFriendInfoViewController2 controllerWithContactId:message.imChatLogModel.imClmBodyModel.bodyModel.uid];
            [self.navigationController pushViewController:friendInfoController animated:YES];
            break;
        }
        case XHBubbleMessageMediaTypeFile:
            [self multiMediaFileMessageDidSelected:message
                                       atIndexPath:indexPath
                            onMessageTableViewCell:messageTableViewCell];
            break;
        case XHBubbleMessageMediaCustomMsg:{
            [messageTableViewCell.messageBubbleView.lzCustomBubbleView clickCustomBubbleViewAction:message controller:self];
            break;
        }
        case XHBubbleMessageMediaTypeUrl:{
            NSString *linkStr = message.imChatLogModel.imClmBodyModel.bodyModel.urlstr;
            [self clickUrlLinkEvent:linkStr];
            break;
        }
        case XHBubbleMessageMediaTypeChatLog:{
            NSDictionary *bodyDic = [[message.imChatLogModel.body seriaToDic] lzNSDictonaryForKey:@"body"];
            ChatLogCombineViewController *chatlogCombineVC = [[ChatLogCombineViewController alloc] init];
            chatlogCombineVC.title = [bodyDic lzNSStringForKey:@"title"];
            NSMutableArray *msgArr = [[bodyDic lzNSStringForKey:@"chatlog"] serialToArr];
            chatlogCombineVC.messages = msgArr;
            chatlogCombineVC.chatViewModel = chatViewModel;
            chatlogCombineVC.toGroupModel = toGroupModel;
            chatlogCombineVC.contactType = self.contactType;
            [self.navigationController pushViewController:chatlogCombineVC animated:YES];
            break;
        }
        default:
            break;
    }
//    [self hideLoading];
}

/**
 *  双击文本消息，触发这个回调
 *
 *  @param message   被操作的目标消息Model
 *  @param indexPath 该目标消息在哪个IndexPath里面
 */
- (void)didDoubleSelectedOnTextMessage:(id <XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath{
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeText:{
            [self.view endEditing:YES];
            [LZMessageTextView showPopoverAt:self.view messageText:message.text];
            break;
        }
        default:
            break;
    }
}

/**
 *  点击图片类型的cell
 */
-(void)multiMediaPhotoMessageDidSelected:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    
    DDLogVerbose(@"浏览图片");
    photoBrowserArr = [chatViewModel getImageViewDataSource:_dialogid];
    
    /* 获取当前图片的index值 */
    int theIndex = -1;
    for (int i=0;i<[photoBrowserArr count];i++) {
        ImChatLogModel *chatLogModel = [photoBrowserArr objectAtIndex:i];
        if([message.imChatLogModel.msgid isEqualToString:chatLogModel.msgid]
           || (![NSString isNullOrEmpty:message.imChatLogModel.clienttempid]
               && ![NSString isNullOrEmpty:chatLogModel.clienttempid]
               && [message.imChatLogModel.clienttempid isEqualToString:chatLogModel.clienttempid] ) ){
               theIndex = i;
           }
    }
    if(theIndex==-1){
        return;
    }
    
    /* 组织所需数据 */
//    mwPhotos = [[NSMutableArray alloc] init];
//    for(int i=0;i<photoBrowserArr.count;i++){
//        MWPhoto *photo = [MWPhoto photoWithImage:[UIImage imageNamed:@"msg_chat_placeholderImage" ]];
//        [mwPhotos addObject:photo];
//    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    /* Show action button to allow sharing, copying, etc (defaults to YES) */
    browser.displayActionButton = YES;
    /* Whether to display left and right nav arrows on toolbar (defaults to NO) */
    browser.displayNavArrows = NO;
    /* Whether selection buttons are shown on each image (defaults to NO) */
    browser.displaySelectionButtons = NO;
    /* Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO) */
    browser.alwaysShowControls = NO;
    /* Images that almost fill the screen will be initially zoomed to fill (defaults to YES) */
    browser.zoomPhotosToFill = NO;
    /* Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES) */
    browser.enableGrid = YES;
    /* Whether to start on the grid of thumbnails instead of the first photo (defaults to NO) */
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = NO;
    /* Auto-play first video */
    browser.autoPlayOnAppear = NO;
    
    WEAKSELF
    AlertBlock alert = ^ {
        /* 从聊天界面进入的图片浏览 */
        NSMutableArray *customUIAlertActionArray = [[NSMutableArray alloc] init];
        [customUIAlertActionArray addObject:MWPhoto_AlertAction_SendToUser];
        [customUIAlertActionArray addObject:MWPhoto_AlertAction_SaveImage];
        [customUIAlertActionArray addObject:MWPhoto_AlertAction_IdentifyQrCode];
        [customUIAlertActionArray addObject:MWPhoto_AlertAction_SaveToDisk];
        [customUIAlertActionArray addObject:MWPhoto_AlertAction_Share];
        //[customUIAlertActionArray addObject:MWPhoto_AlertAction_DocumentCoop];

        
        UIAlertAction *locateOfChatAction = [UIAlertAction actionWithTitle:@"定位到聊天位置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *dic = [browser.otherInfo seriaToDic];
            NSString *msgid = [dic lzNSStringForKey:@"msgid"];
            NSString *clienttempid = [dic lzNSStringForKey:@"clienttempid"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf localForChatMsg:msgid clienttempid:clienttempid];
            });
            
            /* 在聊天界面进入图片浏览 */
            [weakSelf.navigationController popViewControllerAnimated:NO];
            
        }];
        [customUIAlertActionArray addObject:locateOfChatAction];
        browser.customUIAlertActionArray = customUIAlertActionArray;
        
        
    };
    browser.alertBlock = alert;
    /* 单击模式 (YES开启) */
    browser.isClickExit = YES;
    [browser setCurrentPhotoIndex:theIndex];    
    
    [self.navigationController pushViewController:browser animated:YES];
}

/**
 *  文本消息中， BubbleView 中的链接
 */
//- (void)clickBubbleViewSomeLink:(id <XHMessageModel>)message coreLabel:(HBCoreLabel*)coreLabel linkClick:(NSString*)linkStr linkType:(NSString *)linkType{
//    [self hideKeyBoard];
//    DDLogVerbose(@"点击（%@）链接地址----%@",linkType,linkStr);
//    /* 链接地址 */
//    if([linkType isEqualToString:HBMatchParserLinkTypeUrl]){
////        NSString *resultStr = [linkStr lowercaseString];
////        NSString *server = [NSString stringWithFormat:@"%@/R/S",[ModuleServerUtil GetH5ServerWithModule:Modules_H5_Default]];
////        server=server.lowercaseString;
////        if([resultStr hasPrefix:server]){
////            NSURL *liknUrl = [NSURL URLWithString:linkStr];
////            NSString *validID = [liknUrl lastPathComponent];
////            
////            ShareFileScanViewController *shareFileVC = [[ShareFileScanViewController alloc] init];
////            shareFileVC.shareid = validID;
////            [self pushNewViewController:shareFileVC];
////        }else{
////            WebViewController *webViewController = [[WebViewController alloc] init];
////            webViewController.url = linkStr;
////            [self pushNewViewController:webViewController];
////        }
//        NSString *resultStr = [LZUtils getDomainUrlTrunHostUrl:linkStr].lowercaseString;
//        
//        NSString *server = [NSString stringWithFormat:@"%@/T",[ModuleServerUtil GetH5ServerWithModule:Modules_H5_Default]];
//        NSString *serverShare = [NSString stringWithFormat:@"%@/R/S",[ModuleServerUtil GetH5ServerWithModule:Modules_H5_Default]];
//        server = [LZUtils getDomainUrlTrunHostUrl:server];
//        serverShare = [LZUtils getDomainUrlTrunHostUrl:serverShare];
//        server = server.lowercaseString;
//        serverShare = serverShare.lowercaseString;
//        if([resultStr hasPrefix:server] || [resultStr hasPrefix:serverShare]){
//            LZScanResultViewModel *scanResultViewModel = [[LZScanResultViewModel alloc] init];
//            scanResultViewModel.scanViewController = self;
////            [scanResultViewModel setDealWithScanResult:linkStr];
//            [scanResultViewModel getScanResultWithDataContext:linkStr];
//            
//        }else{
//            WebViewController *webViewController = [[WebViewController alloc] init];
//            webViewController.url = linkStr;
//            webViewController.isShowNavRightButton = YES;
//            [self pushNewViewController:webViewController];
//        }
//    }
//    /* 电话号码 */
//    else if( [linkType isEqualToString:HBMatchParserLinkTypeMobie] ){
//        linkMobile = linkStr;
//        NSString *title = [NSString stringWithFormat:@"%@%@",linkStr,LZGDCommonLocailzableString(@"message_maybe_number")];
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_cancel") destructiveButtonTitle:nil otherButtonTitles:LZGDCommonLocailzableString(@"message_call"),LZGDCommonLocailzableString(@"message_addto_contact"), nil];
//        actionSheet.tag=2000;
//        [actionSheet showInView:self.view];
//    }
//}

/**
 *  BubbleView 中的链接,新的代理方法
 */
- (void)newClickBubbleViewSomeLink:(id <XHMessageModel>)message linkClick:(NSString*)linkStr linkType:(NSString *)linkType {
    [self hideKeyBoard];
    DDLogVerbose(@"点击（%@）链接地址----%@",linkType,linkStr);
    
    /* 链接地址 */
    if([linkType isEqualToString:HBMatchParserLinkTypeUrl]){
        //        NSString *resultStr = [linkStr lowercaseString];
        //        NSString *server = [NSString stringWithFormat:@"%@/R/S",[ModuleServerUtil GetH5ServerWithModule:Modules_H5_Default]];
        //        server=server.lowercaseString;
        //        if([resultStr hasPrefix:server]){
        //            NSURL *liknUrl = [NSURL URLWithString:linkStr];
        //            NSString *validID = [liknUrl lastPathComponent];
        //
        //            ShareFileScanViewController *shareFileVC = [[ShareFileScanViewController alloc] init];
        //            shareFileVC.shareid = validID;
        //            [self pushNewViewController:shareFileVC];
        //        }else{
        //            WebViewController *webViewController = [[WebViewController alloc] init];
        //            webViewController.url = linkStr;
        //            [self pushNewViewController:webViewController];
        //        }
        [self clickUrlLinkEvent:linkStr];
    }
    /* 电话号码 */
    else if( [linkType isEqualToString:HBMatchParserLinkTypeMobie] ){
        linkMobile = linkStr;
        NSString *title = [NSString stringWithFormat:@"%@%@",linkStr,LZGDCommonLocailzableString(@"message_maybe_number")];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_cancel") destructiveButtonTitle:nil otherButtonTitles:LZGDCommonLocailzableString(@"message_call"),LZGDCommonLocailzableString(@"message_addto_contact"), nil];
        actionSheet.tag=2000;
        [actionSheet showInView:self.view];
    }
    /* 邮箱 */
    else if ([linkType isEqualToString:HBMatchParserLinkTypeEMail]) {
        linkEMail = linkStr;
        NSString *title = [NSString stringWithFormat:@"向%@发送邮件",linkStr];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_cancel") destructiveButtonTitle:nil otherButtonTitles:@"使用默认邮件账户", nil];
        actionSheet.tag = 9000;
        [actionSheet showInView:self.view];
    }
}

/**
 点击urllink类型的消息事件

 @param linkStr
 */
- (void)clickUrlLinkEvent:(NSString *)linkStr {
    NSString *resultStr = [LZUtils getDomainUrlTrunHostUrl:linkStr].lowercaseString;
    
    //        NSString *server = [NSString stringWithFormat:@"%@/T",[ModuleServerUtil GetH5ServerWithModule:Modules_H5_Default]];
    //        NSString *serverShare = [NSString stringWithFormat:@"%@/R/S",[ModuleServerUtil GetH5ServerWithModule:Modules_H5_Default]];
    //        server = [LZUtils getDomainUrlTrunHostUrl:server];
    //        serverShare = [LZUtils getDomainUrlTrunHostUrl:serverShare];
    //        server = server.lowercaseString;
    //        serverShare = serverShare.lowercaseString;
    NSString *resultHost = [LZUtils getUrlWithIP:resultStr];
    NSString *server = [LZUtils getUrlWithIP:[ModuleServerUtil GetH5ServerWithModule:Modules_H5_Default]].lowercaseString;
    if([resultHost isEqualToString:server]&&([resultStr rangeOfString:@"/t/"].location!=NSNotFound || [resultStr rangeOfString:@"/r/"].location!=NSNotFound )){
        LZScanResultViewModel *scanResultViewModel = [[LZScanResultViewModel alloc] init];
        scanResultViewModel.scanViewController = self;
        //            [scanResultViewModel setDealWithScanResult:linkStr];
        [scanResultViewModel getScanResultWithDataContext:linkStr webViewBlock:nil];
        
    }else{
        WebViewController *webViewController = [[WebViewController alloc] init];
        webViewController.url = linkStr;
        webViewController.isShowNavRightButton = YES;
        [self pushNewViewController:webViewController];
    }
}

#pragma mark - 未读消息view(顶部)
/**
 *  获取未读消息中的第一条消息
 */
-(void)getFirstUnreadMsgid{
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         ImChatLogModel *chatlogModel = [[ImChatLogDAL shareInstance] getFirstUnreadChatLogModelWithDialogId:_dialogid];
         if(chatlogModel!=nil){
             self.firstUnreadChatLogModel = chatlogModel;
         }
     });
}

/**
 *  点击新消息按钮到达顶部
 */
-(void)showUnreadMsgButtonClicked:(UIButton *)sender {
    
    isTapButton = YES;
    [self showLoadingWithText:LCProgreaaHUD_Show_Loading];
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
//        NSInteger count = [[ImChatLogDAL shareInstance] getMsgCountWithChatLogModel:self.firstUnreadChatLogModel];
        NSInteger count = self.newMessageNum;
        
        if(count>DEFAULT_CHAT_PAGECOUNT){
            /* 获取firstUnreadMsgid的位置 */
            NSMutableArray *resultArray = [chatViewModel getViewDataSource:weakSelf.dialogid
                                                                startCount:0
                                                                queryCount:count];
            weakSelf.existsMoreDateForLoading = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideLoading];
                
                weakSelf.messages = resultArray;
                [weakSelf.messageTableView reloadData];
                
                [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [self hideUnreadMsgButton];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideLoading];
                
                [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [self hideUnreadMsgButton];
            });
        }
    });
   
}

#pragma mark - UIActionSheetDelegate弹出添加手机alert
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag==2000) {
        if(buttonIndex==0){
            NSURL *tmpUrl=[AppUtils urlToNsUrl:[NSString stringWithFormat:@"telprompt://%@",linkMobile]];
            [[UIApplication sharedApplication]openURL:tmpUrl];
        }
        else if(buttonIndex==1){
            NSString *title = [NSString stringWithFormat:@"%@%@",linkMobile, LZGDCommonLocailzableString(@"message_maybe_number")];
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_cancel") destructiveButtonTitle:nil otherButtonTitles:LZGDCommonLocailzableString(@"message_create_new_contact"),LZGDCommonLocailzableString(@"message_add_to_contact"), nil];
            actionSheet.tag=3000;
            [actionSheet showInView:self.view];
        }
    } else if (actionSheet.tag==3000){
        if (buttonIndex==0) {
            /* 添加新建联系人 */
            [lzAB addNewContactMobileNum:linkMobile controller:self];            
        } else if (buttonIndex==1) {
            /* 添加到已有联系人 */
            [lzAB addIsHaveContactMobileNum:linkMobile controller:self];
        }
    }
    /* 选择视频通话还是语音通话 */
    else if (actionSheet.tag == 4000) {
        NSString *roomID = [LZUtils CreateGUID];
        if (buttonIndex==1 && self.appDelegate.lzGlobalVariable.msgCallStatus == MsgCallStatusNone) {
            /* 语音通话 */
            /* 弹出视频请求框，并且开始计时，60s后无应答自动关闭 */
            [[LZChatVideoModel shareInstance] addChatRoomViewUserName:toUserModel.username
                                                                 Face:toUserModel.face
                                                             RoomName:roomID
                                                                Other:@{@"dialogid":[self resetDialogID]}
                                                              IsVideo:NO];
            /* 设置正在通话中状态 */
            self.appDelegate.lzGlobalVariable.msgCallStatus = MsgCallStatusIsVoice;
            /* 发送消息给对方，消息状态为1 */
            [self sendVoiceOrVideoCall:Chat_Call_State_Request callDuration:@"" channelid:roomID isVideo:NO];
        } else if (buttonIndex==0 && self.appDelegate.lzGlobalVariable.msgCallStatus == MsgCallStatusNone) {
            /* 视频通话 */
            [[LZChatVideoModel shareInstance] addChatRoomViewUserName:toUserModel.username
                                                                 Face:toUserModel.face
                                                             RoomName:roomID
                                                                Other:@{@"dialogid":[self resetDialogID]}
                                                              IsVideo:YES];
            /* 设置正在通话中状态 */
            self.appDelegate.lzGlobalVariable.msgCallStatus = MsgCallStatusIsVideo;
            [self sendVoiceOrVideoCall:Chat_Call_State_Request callDuration:@"" channelid:roomID isVideo:YES];
        }
    }
    /* 删除 */
    else if (actionSheet.tag == 5000) {
        if (buttonIndex==0) {
            if (tmpMsgidArr.count > 1) {
                /* 相当于点击左上角取消 */
                [self cancleBtnEvent];
                /* 数组中的msgid排序 */
                NSArray *array = [tmpMsgidArr sortedArrayUsingSelector:@selector(compare:)];;
                tmpMsgidArr = [NSMutableArray arrayWithArray:array];
            }
            [self deleteMessages:tmpMsgidArr isSendAPI:YES];
        }
    }
    /* 点击重新呼叫视频通话 */
    else if (actionSheet.tag == 6000) {
        if (buttonIndex==0) {
            NSString *roomID = [LZUtils CreateGUID];
            if (self.appDelegate.lzGlobalVariable.msgCallStatus == MsgCallStatusNone) {
                /* 视频通话 */
                [[LZChatVideoModel shareInstance] addChatRoomViewUserName:toUserModel.username
                                                                     Face:toUserModel.face
                                                                 RoomName:roomID
                                                                    Other:@{@"dialogid":[self resetDialogID]}
                                                                  IsVideo:YES];
                /* 设置正在通话中状态 */
                self.appDelegate.lzGlobalVariable.msgCallStatus = MsgCallStatusIsVideo;
                [self sendVoiceOrVideoCall:Chat_Call_State_Request callDuration:@"" channelid:roomID isVideo:YES];
            }
            /* 重新放大正在通话的界面 */
            else {
                [[LZChatVideoModel shareInstance] showSignalEnlargeWindow];
            }
        }
    }
    /* 点击重新呼叫语音通话 */
    else if (actionSheet.tag == 7000) {
        if (buttonIndex==0) {
            NSString *roomID = [LZUtils CreateGUID];
            if (self.appDelegate.lzGlobalVariable.msgCallStatus == MsgCallStatusNone) {
                /* 语音通话 */
                /* 弹出视频请求框，并且开始计时，60s后无应答自动关闭 */
                [[LZChatVideoModel shareInstance] addChatRoomViewUserName:toUserModel.username
                                                                     Face:toUserModel.face
                                                                 RoomName:roomID
                                                                    Other:@{@"dialogid":[self resetDialogID]}
                                                                  IsVideo:NO];
                /* 设置正在通话中状态 */
                self.appDelegate.lzGlobalVariable.msgCallStatus = MsgCallStatusIsVoice;
                /* 发送消息给对方，消息状态为1 */
                [self sendVoiceOrVideoCall:Chat_Call_State_Request callDuration:@"" channelid:roomID isVideo:NO];
            }
            /* 重新放大正在通话的界面 */
            else {
                [[LZChatVideoModel shareInstance] showSignalEnlargeWindow];
            }
        }
    }
    
    else if (actionSheet.tag == 8000) {
        if (buttonIndex==0) {
            if (self.appDelegate.lzGlobalVariable.msgCallStatus == MsgCallStatusNone) {
                ImGroupCallModel *groupCallModel = [[ImGroupCallDAL shareInstance] getimGroupCallModelWithGroupid:[self resetDialogID]];
                if (groupCallModel.usercout == 7) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"人数已达上限，不能加入" message:nil delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm") otherButtonTitles:nil];
                    [alertView show];
                    return;
                }
                
                NSMutableArray *chatUsers = nil;
                chatUsers = [groupCallModel.chatusers serialToArr];
                UserModel *mineModel = [[UserDAL shareInstance] getUserDataWithUid:currentUserID];
                /* 将自己也加到数组中 */
                [chatUsers addObject:@{@"uid":currentUserID, @"face":mineModel.face, @"name":mineModel.username, @"agorauid":[NSNumber numberWithInteger:[LZUtils getRandomNumber]], @"jointime":[[AppDateUtil GetCurrentDateForString] stringByReplacingOccurrencesOfString:@" " withString:@"T"]}];
                
                /* 添加人 */
                [[LZChatVideoModel shareInstance] addNewMemberToCall:chatUsers];
                /* 设置正在通话中状态 */
                self.appDelegate.lzGlobalVariable.msgCallStatus = MsgCallStatusIsVoice;
                [[LZChatVideoModel shareInstance] addChatGroupRoomViewRoomName:groupCallModel.roomname
                                                                   UserInfoArr:chatUsers
                                                                         Other:@{@"dialogid":[self resetDialogID],
                                                                                 @"contacttype":[NSNumber numberWithInteger:_contactType],
                                                                                 @"groupname":toGroupModel.name,
                                                                                 @"iscanspeechuid":[toGroupModel.createuser isEqualToString:currentUserID] ?@"1":@"0",
                                                                                 @"isinitiateuid":@"0"
                                                                                 }
                                                                       IsVideo:nil];
                /* 给所有人发送消息加通知， */
                [self sendVideoCallForGroup:Chat_Group_Call_State_Join userArr:chatUsers channelid:@"" other:nil];
                /* 主动加入通话时，只给自己发送一个通知 */
                [self sendVideoCallForGroup:Chat_Group_Call_State_Receive userArr:chatUsers channelid:@"" other:nil];
            }
        }
    }
    else if (actionSheet.tag == 9000) {
        if (buttonIndex == 0) {
            NSURL *tmpUrl=[AppUtils urlToNsUrl:[NSString stringWithFormat:@"mailto:%@",linkEMail]];
            /* 在子线程中解析 */
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if ([ [UIApplication sharedApplication] canOpenURL:tmpUrl])
                {   // 看是否 允许跳转
                    [[UIApplication sharedApplication] openURL:tmpUrl];
                    
                }
            });
        }
    }
    else if (actionSheet.tag == 1001) {
        if (buttonIndex == 0) {
            // 选择的消息中，自定义表情/语音/名片/游戏/卡券/支付类消息不能转发。
            SelectMessageRootViewController *selectMsgRootVC = [[SelectMessageRootViewController alloc] init];
            selectMsgRootVC.delegate = self;
            NSMutableDictionary *otherInfo = [[NSMutableDictionary alloc] init];
            [otherInfo setObject:transmitMsgArr forKey:@"message"];
            selectMsgRootVC.otherInfo = otherInfo;
            XHBaseNavigationController *navController=[[XHBaseNavigationController alloc]initWithRootViewController:selectMsgRootVC];
            [self presentViewController:navController animated:YES completion:nil];
        } else {
            NSLog(@"合并转发");

            if (transmitMsgArr.count == 0) {
                UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"请选择要合并的消息" message:nil delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm") otherButtonTitles:nil];
                [alterView show];
                return;
            }
            if (transmitMsgArr.count > 50) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"合并转发最多可选50条消息" message:nil delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm") otherButtonTitles:nil];
                [alertView show];
                return;
            }
            
            SelectMessageRootViewController *selectMsgRootVC = [[SelectMessageRootViewController alloc] init];
            selectMsgRootVC.delegate = self;
            NSMutableDictionary *otherInfo = [[NSMutableDictionary alloc] init];
            [otherInfo setObject:transmitMsgArr forKey:@"combinemessage"];
            selectMsgRootVC.otherInfo = otherInfo;
            XHBaseNavigationController *navController=[[XHBaseNavigationController alloc]initWithRootViewController:selectMsgRootVC];
            [self presentViewController:navController animated:YES completion:nil];
        }
    }
}

/**
 *  点击文件类型的cell
 */
-(void)multiMediaFileMessageDidSelected:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    ScanFileViewController *scan = [[ScanFileViewController alloc] init];
    if( [message.imChatLogModel.imClmBodyModel.bodyModel.isresource isEqualToString:@"true"] ){
        scan.scanFileResId = message.imChatLogModel.imClmBodyModel.bodyModel.rid;
        scan.scanFileRVersion = message.imChatLogModel.imClmBodyModel.bodyModel.rversion;
        scan.scanFileExpId = message.imChatLogModel.imClmBodyModel.bodyModel.fileid;
        scan.scanFileRtype = 3;
    }
    else {
        scan.scanFileExpId = message.imChatLogModel.imClmBodyModel.bodyModel.fileid;
        scan.scanFilePhysicalName = message.imChatLogModel.imClmBodyModel.fileModel.smallfileclientname;
    }
    if ([AppUtils CheckIsImageWithName:message.imChatLogModel.imClmBodyModel.bodyModel.name]) {
        scan.isImagDocmentType= YES;
    }
    scan.scanFileName = message.imChatLogModel.imClmBodyModel.bodyModel.name;
    scan.scanFileSize = message.imChatLogModel.imClmBodyModel.bodyModel.size;
    if([message.imChatLogModel.imClmBodyModel.from isEqualToString:currentUserID]){
        scan.scanFileAbsolutePath = [FilePathUtil getChatSendImageDicAbsolutePath];
        scan.scanFileSmallAbsolutePath = [FilePathUtil getChatSendImageSmallDicAbsolutePath];
        scan.scanFileReleatePath = [FilePathUtil getChatSendImageDicRelatePath];
    }
    else {
        scan.scanFileAbsolutePath = [FilePathUtil getChatRecvImageDicAbsolutePath];
        scan.scanFileSmallAbsolutePath = [FilePathUtil getChatRecvImageSmallDicAbsolutePath];
        scan.scanFileReleatePath = [FilePathUtil getChatRecvImageDicRelatePath];
    }
    scan.Vc = self;
    scan.isNotShowRightPopItem = YES;
    scan.customPopTitleArray = [NSMutableArray arrayWithObjects:ScanFile_PopItemTitle_FileSendPerson,ScanFile_PopItemTitle_FileSaveNetDisk,ScanFile_PopItemTitle_FileThirdOpen, nil];
    
    [scan lookFileForScanFileWithController:self];
}

/**
 *  点击消息发送者的头像回调方法
 *
 *  @param indexPath 该目标消息在哪个IndexPath里面
 */
- (void)didSelectedAvatarOnMessage:(id <XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath{
    if (message.imChatLogModel.imClmBodyModel.fromtype != 20) {
        NSString *clickUid = message.imChatLogModel.from;
        //    if(![clickUid isEqualToString:currentUserID]){
        ContactFriendInfoViewController2 *friendInfoController=[ContactFriendInfoViewController2 controllerWithContactId:clickUid];
        [self.navigationController pushViewController:friendInfoController animated:YES];
        //    }
    } else {        
        toGroupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:[self resetDialogID]];
        // 点击机器人头像
        ChatGroupRobotViewController *groupRobotVC = [[ChatGroupRobotViewController alloc] init];
        groupRobotVC.toGroupModel = toGroupModel;
        groupRobotVC.bussinessid = message.imChatLogModel.imClmBodyModel.from;
        [self.navigationController pushViewController:groupRobotVC animated:YES];
    }    
}
/* 点击消息上菜单中更多按钮 */
- (void)clickMoreButton {
    self.pageViewMode = ContactPageViewModeSelect;
    /* 显示底部选择菜单，隐藏右上角设置按钮,左上角变成取消 */
    [self.messageInputView setHidden:YES];
    [self.moreMenuView setHidden:NO];
    /* 同事将选择数组中的元素全部删除 */
    [self.moreMenuView.selectMsgArray removeAllObjects];
//    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    for (UIBarButtonItem *barBtn in self.navigationItem.leftBarButtonItems) {
        barBtn.customView.hidden = YES;
    }
    self.navigationItem.rightBarButtonItems = nil;
    //两个按钮的父类view
    if (!_leftButtonView) {
        UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(5, 10, 50, 24)];
        _leftButtonView = leftButtonView;
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 24)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [cancelBtn setTitleColor:UIColorWithRGB(0, 133, 244) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancleBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [leftButtonView addSubview:cancelBtn];
        
        [self.navigationController.navigationBar addSubview:leftButtonView];
    }
    
    /* 隐藏键盘 */
    [self hideKeyBoard];
    self.isShowCheckBtn = YES;
    [self.messageTableView reloadData];
}

/**
 *  点击了MenuItem
 *
 *  @param sender 点击MenuItem项
 */
- (void)clickMenuItemAction:(id <XHMessageModel>)message index:(NSInteger)index{
    DDLogVerbose(@"点击Menu---%@----%ld",message.text,(long)index);
    switch (index) {
        /* 转发 */
        case 1:
        {
            SelectMessageRootViewController *selectMsgRootVC = [[SelectMessageRootViewController alloc] init];
            selectMsgRootVC.delegate = self;
            NSMutableDictionary *otherInfo = [[NSMutableDictionary alloc] init];
            [otherInfo setObject:[NSMutableArray arrayWithObject:message] forKey:@"message"];
            selectMsgRootVC.otherInfo = otherInfo;
            XHBaseNavigationController *navController=[[XHBaseNavigationController alloc]initWithRootViewController:selectMsgRootVC];
            [self presentViewController:navController animated:YES completion:nil];
            break;
        }
        case 2: {
            NSLog(@"点击了回复");
            /* 所点人的uid */
            NSString *clickUid = message.imChatLogModel.from;
            
            if (![clickUid isEqualToString:currentUserID]) {
                [self.messageInputView.inputTextView becomeFirstResponder];
                
                UserModel *userModel=[[UserDAL shareInstance] getUserModelForNameAndFace:clickUid];
                
                if (_contactType != Chat_ContactType_Main_One) {
                    if (![NSString isNullOrEmpty:self.messageInputView.inputTextView.text]) {
                        self.messageInputView.inputTextView.text = [self.messageInputView.inputTextView.text stringByAppendingFormat:@"\n「@%@ ：%@」\n- - - - - - - - - - - - - - -\n", userModel.username, message.text];
                    } else {
                        self.messageInputView.inputTextView.text = [self.messageInputView.inputTextView.text stringByAppendingFormat:@"「@%@ ：%@」\n- - - - - - - - - - - - - - -\n", userModel.username, message.text];
                    }
                    
                    if(![[atUsersDic allKeys] containsObject:clickUid]){
                        [atUsersDic setObject:[NSString stringWithFormat:@"@%@ ",userModel.username] forKey:clickUid];
                    }
                } else {
                    self.messageInputView.inputTextView.text = [NSString stringWithFormat:@"「%@：%@」\n- - - - - - - - - - - - - - -\n", userModel.username, message.text];
                }
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.messageInputView.holdDownButton.alpha = NO;
                    self.messageInputView.inputTextView.alpha = YES;
                } completion:^(BOOL finished) {
                    
                }];
                preMsgText = self.messageInputView.inputTextView.text;
                /* 滚动到底部 */
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self scrollToBottomAnimated:YES];
                });
            }
            break;
        }
        /* 保存到云盘 */
        case 3:
        {
            [[[PhotoBrowserViewController alloc] init] fileMessageSaveToNetDisk:message sourceController:self];
            break;
        }
        /*保存到协作文件*/
        case 4:{
            [[[PhotoBrowserViewController alloc] init] fileMessageSaveToCooFile:message sourceController:self imGroupModel:toGroupModel];
            break;
        }
        /* 留痕 */
        case 5:{
            NSMutableArray *msgArr = [NSMutableArray arrayWithObject:message];
            [self didDynamicTraceByBatch:msgArr];
            break;
        }
        /* 删除 */
        case 6:
        {
            NSMutableArray *msgArr = [NSMutableArray arrayWithObject:message.imChatLogModel.msgid];
            [self deleteMessages:msgArr isSendAPI:YES];
            break;
        }
        /* 撤销 */
        case 7:
        {
            [self recallMsgEvent:message.imChatLogModel.msgid];
            break;
        }
        /* 更多 */
        case 8:
        {
            NSLog(@"更多操作");
            [self clickMoreButton];
            [self layoutOtherMenuViewHiden:YES];
            break;
        }
    }
}
/* 点击多选的时候的取消按钮处理事件 */
- (void)cancleBtnEvent {
    [self.messageInputView setHidden:!self.messageInputView.hidden];
    [self.moreMenuView setHidden:!self.moreMenuView.hidden];
//    self.navigationItem.leftBarButtonItem.customView.hidden = !self.navigationItem.leftBarButtonItem.customView.hidden;
    for (UIBarButtonItem *barBtn in self.navigationItem.leftBarButtonItems) {
        barBtn.customView.hidden = !barBtn.customView.hidden;
    }
    [self addSettingButton];
    _leftButtonView.hidden = YES;
    _leftButtonView = nil;
    self.isShowCheckBtn = NO;
    [self.messageTableView reloadData];
    /* 点击删除后，刷新一下状态栏，以防期间有未读消息来 */
    [self refreshBackButtonText];
}
/**
 撤回消息

 @param message
 */
- (void)recallMsgEvent:(NSString *)messageid {
    [self showLoading];
    [self.appDelegate.lzservice sendToServerForGet:WebApi_Message routePath:WebApi_Message_RecallMsg moduleServer:Modules_Message getData:@{@"synckey":messageid} otherData:nil];
}

/**
 批量删除消息

 @param message
 */
- (void)deleteMessages:(NSMutableArray *)msgidArr isSendAPI:(BOOL)isSendAPI{
    /* 调API之前，先把自己的删除 */
    for (NSString *msgid in msgidArr) {
        [self deleteMsgWithMsgid:msgid];
    }
    if (isSendAPI) {
        NSDictionary *dic = @{@"container":_dialogid};
        [self.appDelegate.lzservice sendToServerForPost:WebApi_Message routePath:WebApi_Message_DeleteMsg moduleServer:Modules_Message getData:dic postData:msgidArr otherData:nil];
        /* 将要删除的消息添加到队列 */
        [chatViewModel addDeleteMsgToMsgQueue:msgidArr dialogID:_dialogid];
    }
}

/* 和API同时进行的删除消息 */
- (void)deleteMsgWithMsgid:(NSString *)msgid {
    
    ImChatLogModel *lastChatLogModel = [[ImChatLogDAL shareInstance] getLastChatLogModelWithDialogId:_dialogid];
    NSMutableArray *resultArray = [chatViewModel getViewDataSource:_dialogid startCount:0 queryCount:DEFAULT_CHAT_PAGECOUNT];
    BOOL isOnlyOneMsg = resultArray.count == 1 ? YES : NO;
    /* 修改数据库中删除isdel记录 */
    [[ImChatLogDAL shareInstance] deleteMessageWithMsgid:msgid];
    
    /* 最后一条时，更新最近联系人消息，刷新消息页签 */
    if(lastChatLogModel!=nil && [lastChatLogModel.msgid isEqualToString:msgid]){
        NSDictionary *chatDic = [lastChatLogModel.body seriaToDic];
        if (isOnlyOneMsg) {
            [[ImRecentDAL shareInstance] updatelastMessageWithDic:chatDic isOnlyOneMsg:isOnlyOneMsg];
        } else {            
            [[ImRecentDAL shareInstance] updateLastMsgWithDialogid:_dialogid];
        }
        
        if(_parsetype!=0 && [_dialogid rangeOfString:@"."].location!=NSNotFound){
            NSString *firstDialogID = [[_dialogid componentsSeparatedByString:@"."] objectAtIndex:0];
            [[ImRecentDAL shareInstance] updateMsgToNull:firstDialogID];
        }

        [chatViewModel refreshMessageRootVC:lastChatLogModel.dialogid];
    }
    ImChatLogModel *imchatmodel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:msgid orClienttempid:@""];
    /* 删除界面上的数据 */
    NSIndexPath *indexPath = [self getIndexPathByChatLogModel:imchatmodel updateSendStatus:-1 recvIsread:-1];
    if(indexPath!=nil){
        [self removeMessageAtIndexPath:indexPath];
    }
}

#pragma mark - EventBus Delegate

/**
 *  获取解析消息的队列
 */
-(dispatch_queue_t)chatQueue{
    if(_chatQueue==nil){
        _chatQueue = dispatch_queue_create("com.leading.leadingcloud.queue.chatvc", DISPATCH_QUEUE_SERIAL);
    }
    return _chatQueue;
}

/*
 事件代理
 */
- (void)eventOccurred:(NSString *)eventName event:(Event *)event
{
    [super eventOccurred:eventName event:event];
    /* 收到消息 */
    if([eventName isEqualToString:EventBus_Chat_RecvNewMsg]
       || [eventName isEqualToString:EventBus_Chat_RecvSystemMsg])
    {

        dispatch_async(self.chatQueue, ^{
            NSMutableArray *dataArray  = (NSMutableArray *)[event eventData];

            /* 接收到的消息ID数组 */
            NSMutableArray *msgids = [[NSMutableArray alloc] init];
            for(int i=0;i<dataArray.count;i++){
                ImChatLogModel *imChatLogModel = [dataArray objectAtIndex:i];
                
                NSString *msgid = [self didReceiveMessage:imChatLogModel];
                if(![NSString isNullOrEmpty:msgid] && ![imChatLogModel.handlertype hasPrefix:Handler_Message_LZChat_SR]){
                    [msgids addObject:msgid];
                }

                //当前为业务会话聊天窗口，需要把一级消息也发送出回执
                if(_sendToType == Chat_ToType_Five || _sendToType == Chat_ToType_Six ){
                    NSMutableArray *msgidsForFirst = [[ImChatLogDAL shareInstance] getRecvIsNoReadWithDialogId:[NSString stringWithFormat:@"%ld",(long)_sendToType]];
                    [msgids addObjectsFromArray:msgidsForFirst];
                }
            }
            
            if (msgids.count >0)
            {
                /* 发送消息回执 */
                NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
                [getData setObject:@"2" forKey:@"type"];
                [getData setObject:[NSString stringWithFormat:@"%ld",(long)otherNoReadCount] forKey:@"badge"];
                [self.appDelegate.lzservice sendToServerForPost:WebApi_Message routePath:WebApi_Message_Report moduleServer:Modules_Message getData:getData postData:msgids otherData:@{WebApi_DataSend_Other_ShowError:WebApi_DataSend_Other_SE_NotShowAll}];
            }
            
            /* 需要刷新title */
            if([eventName isEqualToString:EventBus_Chat_RecvSystemMsg]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadNavigationData];
                });
            }
        });
    }    
    else if([eventName isEqualToString:EventBus_Chat_UpdateSendStatus]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ImChatLogModel *imChatLogModel = (ImChatLogModel *)[event eventData];
            
            if(![imChatLogModel.dialogid isEqualToString:_dialogid]){
                return;
            }
            
            ImChatLogModel *chatLogModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:imChatLogModel.msgid orClienttempid:@""];
            NSIndexPath *indexPath = [self getIndexPathByChatLogModel:chatLogModel updateSendStatus:chatLogModel.sendstatus recvIsread:-1];
            if(indexPath!=nil){
                /* 添加已读、未读状态 */
                XHMessage *xhMessage = [self.messages objectAtIndex:indexPath.row];
                xhMessage.imChatLogModel = chatLogModel;
                [chatViewModel addReadStatusToMessage:xhMessage chatLogModel:chatLogModel];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    /* 更改View中的状态 */
                    XHMessageTableViewCell *cell = (XHMessageTableViewCell *)[self.messageTableView cellForRowAtIndexPath:indexPath];
                    cell.message = xhMessage;
                    [cell changeSendStatusInCell:xhMessage];
                });
            }
            /* 移除 */
            if (imChatLogModel.clienttempid) {
                [chatViewModel.uploadingDic removeObjectForKey:imChatLogModel.clienttempid];
            }
            /* 刷新消息页签 */            
            self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootForChatVC = YES;
        });
    }
    else if( [eventName isEqualToString:EventBus_Chat_RecvReadList]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *readListArray = (NSMutableArray *)[event eventData];
            for( ImChatLogModel *imChatLogModel in readListArray){
                if( [imChatLogModel.dialogid isEqualToString:_dialogid] ){

                    ImChatLogModel *chatLogModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:imChatLogModel.msgid orClienttempid:@""];
                    NSIndexPath *indexPath = [self getIndexPathByChatLogModel:chatLogModel updateSendStatus:-1 recvIsread:-1];
                    
                    if(indexPath!=nil){
                        XHMessage *xhMessage = [self.messages objectAtIndex:indexPath.row];
                        [chatViewModel addReadStatusToMessage:xhMessage chatLogModel:chatLogModel];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            /* 更改View中的状态 */
                            XHMessageTableViewCell *cell = (XHMessageTableViewCell *)[self.messageTableView cellForRowAtIndexPath:indexPath];
                            [cell changeSendStatusInCell:xhMessage];
                         });
                    }
                }
            }
        });
    }
    else if([eventName isEqualToString:EventBus_Chat_RefreshMessageRootVC])
    {
        /* 防止在隐藏导航栏进行多选时，来了新消息导航栏紊乱 */
        if ([self.navigationItem.leftBarButtonItems lastObject].customView.hidden != YES) {
            [self refreshBackButtonText];
        }
    }
    else if( [eventName isEqualToString:EventBus_Chat_DownloadChatlog] ){
        NSMutableDictionary *dataDic  = (NSMutableDictionary *)[event eventData];
        NSString *isDownloadMore = [dataDic lzNSStringForKey:@"isDownloadMore"];
        /* 拿到第一条msgid */
        firstMsgid = [dataDic lzNSStringForKey:@"msgid"];
        if (![isDownloadMore isEqualToString:@"1"]) {
            NSInteger pages = self.messages.count/DEFAULT_CHAT_PAGECOUNT;
            if(self.messages.count%DEFAULT_CHAT_PAGECOUNT > 0){
                pages += 1;
            }
            if( pages == 0 ){
                pages = 1;
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableArray *resultArray = [chatViewModel getViewDataSource:_dialogid startCount:0 queryCount:pages * DEFAULT_CHAT_PAGECOUNT];
                //self.existsMoreDateForLoading = resultArray.count >= pages * DEFAULT_CHAT_PAGECOUNT ? YES : NO;
                if(resultArray.count >= DEFAULT_CHAT_PAGECOUNT){
                    XHMessage *lastMessage = [resultArray objectAtIndex:0];
                    self.existsMoreDateForLoading = [[[ImChatLogDAL alloc] init] checkIsEarlierMsgWithDialogID:_dialogid datetime:lastMessage.imChatLogModel.showindexdate msgid:lastMessage.imChatLogModel.msgid];
                } else {
                    self.existsMoreDateForLoading = NO;
                }
                
                //        if(self.existsMoreDateForLoading){
                //            self.messageTableView.tableHeaderView = self.headerContainerView;
                //        } else {
                //            self.messageTableView.tableHeaderView = nil;
                //        }
                
                self.messages = resultArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.messageTableView reloadData];
                    [self scrollToBottomAnimated:NO];
                });
            });
        } else {
            /* 下载完成之后，就将变量置空，不然会多次下载 */
            NSNumber *downLoadCountNum = [dataDic lzNSNumberForKey:@"downloadcount"];
            if(downLoadCountNum.integerValue<50){
                firstMsgid = nil;
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableArray *resultArray = [chatViewModel getViewDataSource:_dialogid
                                                                    startCount:self.messages.count
                                                                    queryCount:DEFAULT_CHAT_PAGECOUNT];
                /* 继续下载后的消息数量大于0 */
                if (resultArray.count > 0) {
                    if(resultArray.count >= DEFAULT_CHAT_PAGECOUNT){
                        XHMessage *lastMessage = [resultArray objectAtIndex:0];
                        self.existsMoreDateForLoading = [[[ImChatLogDAL alloc] init] checkIsEarlierMsgWithDialogID:_dialogid datetime:lastMessage.imChatLogModel.showindexdate msgid:lastMessage.imChatLogModel.msgid];
                    } else {
                        self.existsMoreDateForLoading = NO;
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self insertOldMessages:resultArray];
                        //            weakSelf.loadingMoreMessage = NO;
                    });
                }
            });
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /* 发送消息回执 */
            [chatViewModel sendReportToServer:_dialogid];
        });
    }
    else if( [eventName isEqualToString:EventBus_More_User_LoadUser_ReloadChatView] ){
        NSMutableDictionary *dataDic  = (NSMutableDictionary *)[event eventData];
        NSDictionary *otherDataDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
        NSString *otherData = [otherDataDic lzNSStringForKey:WebApi_DataSend_Other_Operate];
        if(![NSString isNullOrEmpty:otherData]){
            if([otherData isEqualToString:@"reloadchatview"]){
                WEAKSELF
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSMutableArray *resultArray = [chatViewModel getViewDataSource:weakSelf.dialogid
                                                                        startCount:0
                                                                        queryCount:self.messages.count];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.messages = resultArray;
                        [weakSelf.messageTableView reloadData];
                    });
                });
            }
        }
    }
    else if( [eventName isEqualToString:EventBus_More_User_LoadUser] ){
        UserModel *userModel = (UserModel *)[event eventData];
        if([_dialogid isEqualToString:userModel.uid]){
            [self reloadNavigationData];
        }
    }
    else if( [eventName isEqualToString:EventBus_Chat_GetGroupInfo]){
        NSString *igid = [event eventData];
        
        if([[self resetDialogID] isEqualToString:igid]){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                toGroupModel = [[ImGroupDAL shareInstance] getImGroupWithIgid:[self resetDialogID]];
                if(_contactType == Chat_ContactType_Main_CoGroup){
                    chatViewModel.sendMode = toGroupModel.showmode;
                    [self setPopMenuItems];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadNavigationData];
                });
                [chatViewModel loadGroupAdminAndUser:[self resetDialogID]];
            });
        }
    }
    /* 群组关闭，开启的通知 */
    else if( [eventName isEqualToString:EventBus_ChatGroup_OperOrCloseGroup] ){
        NSDictionary *data = [event eventData];
        if(_contactType == Chat_ContactType_Main_ChatGroup ||
           _contactType == Chat_ContactType_Main_CoGroup ||
           _contactType == Chat_ContactType_Main_App_Seven ||
           _contactType == Chat_ContactType_Main_App_Eight ){
            if([[data lzNSStringForKey:@"groupid"] isEqualToString:toGroupModel.igid]){
                NSString *numIsClosed = [data lzNSStringForKey:@"isclosed"];
                toGroupModel.isclosed = numIsClosed.integerValue;
                [self addSettingButton];
            }
        }
    }
    /* 语音下载状态更改 */
    else if( [eventName isEqualToString:EventBus_Chat_UpdateVoiceDownloadStatus] ){
        ImChatLogModel *chatLogModel = [event eventData];
        
        NSIndexPath *indexPath = [self getIndexPathByChatLogModel:chatLogModel updateSendStatus:-1 recvIsread:-1];
        if(indexPath!=nil){
            /* 添加已读、未读状态 */
            XHMessage *xhMessage = [self.messages objectAtIndex:indexPath.row];
            xhMessage.imChatLogModel = chatLogModel;
            
            dispatch_async(dispatch_get_main_queue(), ^{

                /* 更改View中的状态 */
                XHMessageTableViewCell *cell = (XHMessageTableViewCell *)[self.messageTableView cellForRowAtIndexPath:indexPath];
                cell.message = xhMessage;
                if (cell.messageBubbleView.bubbleImageView.animating) {
                    [cell.messageBubbleView.bubbleImageView stopAnimating];
                    cell.messageBubbleView.bubbleImageView.animationImages = nil;
                }
                
                if(chatLogModel.imClmBodyModel.voiceModel.voiceIsDownFail){
                    cell.messageBubbleView.voiceDownLoadFail.hidden = NO;
//                    cell.messageBubbleView.bubbleImageView.image = [XHMessageBubbleFactory bubbleImageViewForRecvVoice:@"weChatBubble_Receiving_Solid"];
                }
                else {
                    cell.messageBubbleView.voiceDownLoadFail.hidden = YES;
                    cell.messageBubbleView.voiceDurationLabel.hidden = NO;
                    cell.messageBubbleView.voiceUnreadDotImageView.hidden = chatLogModel.imClmBodyModel.bodyModel.status;
                    cell.messageBubbleView.animationVoiceImageView.hidden = NO;
                }
            });
        }
        
    }
    /* 定位聊天记录 */
    else if ([eventName isEqualToString:EventBus_Chat_LocalInChat]) {
        NSDictionary *dic = [event eventData];
        NSString *msgid = [dic lzNSStringForKey:@"msgid"];
        NSString *clienttempid = [dic lzNSStringForKey:@"clienttempid"];
        [self localForChatMsg:msgid clienttempid:clienttempid];
    }
    /* 撤回消息 */
    else if ([eventName isEqualToString:EventBus_Chat_RecallMsg]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoading];
            /* 刷新消息界面，消息的变化 */
            [self.messageTableView reloadData];
            [self loadInitChatLog:NO newBottomMsgs:nil];
            /* 刷新消息页签 */
            [chatViewModel refreshMessageRootVC:self.dialogid];
        });
    }
    /* 删除消息 */
    else if ([eventName isEqualToString:EventBus_Chat_DeleteMsg]) {
        NSDictionary *dic = [event eventData];
        /* 在其他客户端删除 */
        NSMutableArray *msgidArr = [dic lzNSMutableArrayForKey:@"msgidlist"];
        [self deleteMessages:msgidArr isSendAPI:NO];
    }
    /* 业务扩展类型数据 */
    else if ([eventName isEqualToString:EventBus_BusinessSession_GetExtendTypeByCode]){
        NSMutableDictionary *dataContext = [event eventData];
        LZPluginManager *lzplugin = [[LZPluginManager alloc] init];

        CommonTemplateModel *templateModel = [[CommonTemplateModel alloc] init];
        [templateModel serialization:[dataContext lzNSStringForKey:@"linkconfig"]];
        [OpenTemplateModel openTemplateViewController:self Context:[NSMutableDictionary dictionaryWithDictionary:_tempContex] URLParamsData:nil Lzplugin:lzplugin Model:templateModel AppCode:[dataContext lzNSStringForKey:@"appcode"] RelationAppCodes:nil BaskLinkCode:nil templateModule:Template_BusinessSession];
    }
    else if ([eventName isEqualToString:EventBus_CloudCoo_Base_Get]) {
        NSMutableDictionary *dataContext = [event eventData];
        appcode = [dataContext lzNSStringForKey:@"appcode"];
    }
    /* 判断企业下是否给某应用授权 */
    else if ([eventName isEqualToString:EventBus_OrgLicenseIsExistsAuth]) {
        NSInteger dataContext = [[event eventData] integerValue];
        //        [self hideLoading];
        if (dataContext == 1) {
            /* 打开应用，传窗口 id 和类型，和oid */
            AppModel *appModel = [[AppDAL shareInstance]getAppModelWithAppId:msgAppModel.appid];
            if(appModel == nil){
                /* 判断网络是否连同 */
                if([LZUserDataManager readIsConnectNetWork]){
                    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                    NSString *h5Url = msgAppModel.msgiosconfig;
                    
                    if([h5Url rangeOfString:@"?"].location!=NSNotFound && ![NSString isNullOrEmpty:appModel.version]){
                        h5Url = [NSString stringWithFormat:@"%@&version=%@",h5Url,appModel.version];
                    }else if(![NSString isNullOrEmpty:appModel.version]){
                        h5Url = [NSString stringWithFormat:@"%@?version=%@",h5Url,appModel.version];
                    }
                    NSString *server = [ModuleServerUtil GetCommonAppWebServerWithAppCode:msgAppModel.appcode isuserdefault:YES isuserserverdata:NO block:nil];
                    if ([NSString isNullOrEmpty:server]) {
                        [UIAlertView alertViewWithMessage:LZGDCommonLocailzableString(@"login_server_location_get_fail")];
                        return;
                    }
                    BOOL alwaysShowClose = NO;
                    //加载Url
                    NSString *url = [NSString stringWithFormat:@"%@%@",server,h5Url];
                    url = [AppUtils replaceUrlParameter:url];
                    
                    WebViewController *webViewController = [[WebViewController alloc] init];
                    webViewController.url = url;
                    webViewController.alwaysShowClose = alwaysShowClose;
                    
                    /* 注册数据 */
                    NSMutableDictionary *contextForTemplate = [[NSMutableDictionary alloc] init];
                    [contextForTemplate setValue:Template_Message forKey:Template_Module];
                    [contextForTemplate setValue:_dialogid forKey:@"winid"];
                    [contextForTemplate setValue:[NSString stringWithFormat:@"%ld",(long)_contactType] forKey:@"wintype"];
                    [contextForTemplate setValue:[AppUtils GetCurrentOrgID] forKey:@"oid"];
                    
                    if(![NSString isNullOrEmpty:appModel.version]){
                        NSMutableDictionary *sysdataDic = [[NSMutableDictionary alloc] init];
                        [sysdataDic setValue:appModel.version forKey:@"lcmappversion"];
                        [webViewController.sessionStorage setObject:[sysdataDic dicSerial] forKey:@"lcm.systemdata"];
                    }
                    [webViewController.sessionStorage setValue:[contextForTemplate dicSerial] forKey:@"lcm.instancedata"];
                    
                    appDelegate.lzGlobalVariable.currentAppCode = @[msgAppModel.appcode];
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        isFirstShow = NO;
                        [self.navigationController pushViewController:webViewController animated:YES];
                    });
                }
                else{
                    [LCProgressHUD showFailure:LCProgressHUD_Show_NetWorkConnectFail];
                }
            }
            else{
                [self redirectTargetPage:appModel isFirstLoad:YES appid:msgAppModel.appid];
            }
        } else {
            /* 未授权 */
            [self showErrorWithText:@"该企业暂不支持此应用，请先授权"];
        }
    }
}

-(void)redirectTargetPage:(AppModel *)appModel isFirstLoad:(BOOL)isfirstload appid:(NSString *)appid{
    
    
    NSInteger templatetype = appModel.controllerModel.templatetype;
    
    if(templatetype==0){
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        appDelegate.lzGlobalVariable.currentOpenedAppId = appid;
        /* 判断网络是否连同 */
        if([LZUserDataManager readIsConnectNetWork]){
            //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /* 判断是否为单点登录 */
            NSString *appserver = appModel.appserver;
            NSString *sso = [[appserver seriaToDic] lzNSStringForKey:@"sso"];
            
            NSString *url = @"";
            BOOL alwaysShowClose = NO;
            NSString *h5Url = msgAppModel.msgiosconfig;
            //            [NSString isNullOrEmpty:appModel.controllerModel.webviewModel.h5url] ? appModel.html5 : appModel.controllerModel.webviewModel.h5url;
            
            if([h5Url rangeOfString:@"?"].location!=NSNotFound && ![NSString isNullOrEmpty:appModel.version]){
                h5Url = [NSString stringWithFormat:@"%@&version=%@",h5Url,appModel.version];
            }else if(![NSString isNullOrEmpty:appModel.version]){
                h5Url = [NSString stringWithFormat:@"%@?version=%@",h5Url,appModel.version];
            }
            /* 非SSO */
            if([NSString isNullOrEmpty:sso]){
                NSString *server = [ModuleServerUtil GetCommonAppWebServerWithAppCode:appModel.appcode isuserdefault:YES isuserserverdata:NO block:nil];
                if ([NSString isNullOrEmpty:server]) {
                    [UIAlertView alertViewWithMessage:LZGDCommonLocailzableString(@"login_server_location_get_fail")];
                    return;
                }
                //加载Url
                url = [NSString stringWithFormat:@"%@%@",server,h5Url];
            }
            else {
                NSString *afterReplaceSSO = [[AppUtils replaceUrlParameter:sso] stringByReplacingIGNOREOccurrencesOfString:@"{target}" withString:[LZUtils escape:h5Url]];
                
                if( [[sso lowercaseString] hasPrefix:@"http"] ){
                    url = afterReplaceSSO;
                }
                else {
                    NSString *server = [ModuleServerUtil GetCommonAppWebServerWithAppCode:appModel.appcode isuserdefault:YES isuserserverdata:NO block:nil];
                    if ([NSString isNullOrEmpty:server]) {
                        [UIAlertView alertViewWithMessage:LZGDCommonLocailzableString(@"login_server_location_get_fail")];
                        return;
                    }
                    //加载Url
                    url = [NSString stringWithFormat:@"%@%@",server,afterReplaceSSO];
                }
                alwaysShowClose = YES;
            }
            
            url = [AppUtils replaceUrlParameter:url];
            
            //            url = @"http://192.168.13.207:8088/AppPlus/Schedule/Mobile/View/ScheduleMain.html";//ScheduleColleague--ScheduleJurisdiction.html--ScheduleNewType.html--ScheduleMain.html
            //            url = @"http://192.168.21.4:8100/appplus/blueturnwhite/mobile/view/index.html";
            WebViewController *webViewController = [[WebViewController alloc] init];
            webViewController.url = url;
            //            webViewController.defaultTitle = appModel.name;
            webViewController.alwaysShowClose = alwaysShowClose;
            
            /* 注册数据 */
            NSMutableDictionary *contextForTemplate = [[NSMutableDictionary alloc] init];
            [contextForTemplate setValue:Template_Message forKey:Template_Module];
            [contextForTemplate setValue:_dialogid forKey:@"winid"];
            [contextForTemplate setValue:[NSString stringWithFormat:@"%ld",(long)_contactType] forKey:@"wintype"];
            [contextForTemplate setValue:[AppUtils GetCurrentOrgID] forKey:@"oid"];
            
            if(![NSString isNullOrEmpty:appModel.version]){
                NSMutableDictionary *sysdataDic = [[NSMutableDictionary alloc] init];
                [sysdataDic setValue:appModel.version forKey:@"lcmappversion"];
                [webViewController.sessionStorage setObject:[sysdataDic dicSerial] forKey:@"lcm.systemdata"];
            }
            [webViewController.sessionStorage setValue:[contextForTemplate dicSerial] forKey:@"lcm.instancedata"];
            
            appDelegate.lzGlobalVariable.currentAppCode = @[appModel.appcode];
            dispatch_async(dispatch_get_main_queue(), ^{
//                isFirstShow = NO;
                [self.navigationController pushViewController:webViewController animated:YES];
            });
            //          });
        } else {
            [LCProgressHUD showFailure:LCProgressHUD_Show_NetWorkConnectFail];
        }
        
    }
    else {
        
        /* VPN模式时，判断是否能够ping通 */
        if(isfirstload && templatetype==5){
            NSString *serverUrl = [ModuleServerUtil GetAppWebServerWithAppCode:appModel.appcode isusedefault:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *host = [AppUtils urlToNsUrl:serverUrl].host;
                
                [LCProgressHUD showLoading:LCProgreaaHUD_Show_Loading];
                
                appModels = appModel;
                [SimplePingHelper ping:host target:self sel:@selector(pingResult:)];
                
                return;
            });
        }
        
        
        lzplugin = [[LZPluginManager alloc] init];
        
        NSString *urlParamsData = nil;
        urlParamsData = appModel.nowappid;
        dispatch_async(dispatch_get_main_queue(), ^{
            [OpenTemplateModel openTemplateViewController:self Context:nil URLParamsData:urlParamsData Lzplugin:lzplugin Model:appModel.controllerModel AppCode:appModel.appcode RelationAppCodes:nil BaskLinkCode:nil templateModule:Template_App];
        });
    }
}
- (void)pingResult:(NSNumber*)success
{
    [LCProgressHUD hide];    if (success.boolValue) {
        CommonTemplateModel *newControllerModel = appModels.controllerModel;
        newControllerModel.templatetype = 2;
        newControllerModel.webviewinfo = newControllerModel.vpnwebinfo;
        appModels.controller = [[newControllerModel convertModelToDictionary] dicSerial];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.lzGlobalVariable.isNotOpenVPNWebView = NO;
        
    } else {
        
    }
    
    [self redirectTargetPage:appModels isFirstLoad:NO appid:nil];
}
#pragma mark - LZEmotionManagerView Delegate

/**
 *  键盘上的删除
 */
- (BOOL)inputTextViewShouldChangeTextInRange:(XHMessageTextView *)messageInputTextView {
    DDLogVerbose(@"删除文本框中内容");
    return [self deleteEmotionOrAt];
}

/**
 *  点击了删除表情的按钮
 *
 *  @param sender 删除按钮
 *
 *  @return 输入框中的内容
 */
- (NSString *)didClickLZEmotionDelBtn:(id)sender{
    DDLogVerbose(@"删除表情----%@",self.messageInputView.inputTextView.text);
    if([self deleteEmotionOrAt]){
        /* 删除表情的按钮可以删除输入框的文本 */
        [self.messageInputView.inputTextView deleteBackward];
    }
    
    return self.messageInputView.inputTextView.text;
}

/**
 *  删除输入框文本或表情或@
 *
 *  @return 是否需要执行系统的删除方法
 */
- (BOOL)deleteEmotionOrAt{
    if( self.messageInputView.inputTextRange.length == 0 ){
        //1.记录光标前后的字符串
        NSRange cursorRange = self.messageInputView.inputTextRange;
        NSInteger cursorLocation = self.messageInputView.inputTextRange.location;
        if( cursorLocation>=self.messageInputView.inputTextView.text.length ){
            cursorLocation = self.messageInputView.inputTextView.text.length;
        }
        NSString *beforeStr=[self.messageInputView.inputTextView.text substringToIndex:cursorLocation];
        NSString *behindStr=[self.messageInputView.inputTextView.text substringFromIndex:cursorLocation];
        
        //2.判断beforeStr是否以表情结尾
        BOOL isEndWithEmotion = NO;
        for (NSString *key in [self.emotionsDic allKeys]) {
            NSString *text = [self.emotionsDic lzNSStringForKey:key];
            if([beforeStr hasSuffix:text]){
                beforeStr = [beforeStr substringToIndex:[beforeStr rangeOfString:text options:NSBackwardsSearch].location];
                
                isEndWithEmotion = YES;
                cursorRange.location -= text.length;
                self.messageInputView.inputTextRange = cursorRange;
                break;
            }
        }
        
        //3.判断beforeStr是否以@结尾
        BOOL isEndWithAt = NO;
        if(!isEndWithEmotion){
            for(NSString *key in [atUsersDic allKeys]){
                NSString *text = [atUsersDic lzNSStringForKey:key];
                if([beforeStr hasSuffix:text]){
                    beforeStr = [beforeStr substringToIndex:[beforeStr rangeOfString:text options:NSBackwardsSearch].location];
                    
                    isEndWithAt = YES;
                    cursorRange.location -= text.length;
                    self.messageInputView.inputTextRange = cursorRange;
                    [atUsersDic removeObjectForKey:key];
                    break;
                }
            }
            
            for(NSString *key in [atRobotDic allKeys]){
                NSString *text = [atRobotDic lzNSStringForKey:key];
                if([beforeStr hasSuffix:text]){
                    beforeStr = [beforeStr substringToIndex:[beforeStr rangeOfString:text options:NSBackwardsSearch].location];
                    
                    isEndWithAt = YES;
                    cursorRange.location -= text.length;
                    self.messageInputView.inputTextRange = cursorRange;
                    [atRobotDic removeObjectForKey:key];
                    break;
                }
            }
        }
        
        //4.拼接新字符串
        if( isEndWithEmotion || isEndWithAt){
            self.messageInputView.inputTextView.text = [beforeStr stringByAppendingString:behindStr];
            /* 将光标设置在修改的位置 */
            self.messageInputView.inputTextView.selectedRange = cursorRange;
            return NO;
        }
        DDLogVerbose(@"删除表情或@处理完成");
    }
    return YES;
}

#pragma mark - LZSendStatusDelegate Delegate

/**
 *  点击了重发
 *
 *  @param sender 重新发送按钮
 */
- (void)reSendFailedMessage:(id <XHMessageModel>)message{
    DDLogVerbose(@"重发---%@",message.imChatLogModel.msgid);
    
    /* 先删除 */
    [self deleteFailedMessage:message];
    
    /* 再重发 */
    [self sendMessageWithImChatLogModel:message.imChatLogModel controller:self type:0 combineMsgArr:nil];
}

/**
 *  点击了删除
 *
 *  @param sender 删除发送失败的消息
 */
- (void)deleteFailedMessage:(id <XHMessageModel>)message{
    DDLogVerbose(@"删除---%@",message.text);
    NSString *msgid = message.imChatLogModel.msgid;
    
    ImChatLogModel *lastChatLogModel = [[ImChatLogDAL shareInstance] getLastChatLogModelWithDialogId:_dialogid];
    
    /* 删除数据库中的记录 */
    [[ImChatLogDAL shareInstance] deleteImChatLogWithMsgid:msgid];

    /* 最后一条时，更新最近联系人消息，刷新消息页签 */
    if(lastChatLogModel!=nil && [lastChatLogModel.msgid isEqualToString:message.imChatLogModel.msgid]){
        [[ImRecentDAL shareInstance] updateLastMsgWithDialogid:_dialogid];
        
        if(_parsetype!=0 && [_dialogid rangeOfString:@"."].location!=NSNotFound){
            NSString *firstDialogID = [[_dialogid componentsSeparatedByString:@"."] objectAtIndex:0];
            [[ImRecentDAL shareInstance] updateMsgToNull:firstDialogID];
        }
        
        [chatViewModel refreshMessageRootVC:_dialogid];
    }
    
    /* 删除界面上的数据 */
    NSIndexPath *indexPath = [self getIndexPathByChatLogModel:message.imChatLogModel updateSendStatus:-1 recvIsread:-1];
    if(indexPath!=nil){
        [self removeMessageAtIndexPath:indexPath];
    }
}


/**
 *  点击未读数量文本
 *
 *  @param sender 消息
 */
- (void)showNoReadList:(id <XHMessageModel>)message{
    DDLogVerbose(@"展现未读人员列表---%@",message.text);
    
//    ChatGroupRecvListViewController2 *recvListVC = [[ChatGroupRecvListViewController2 alloc] init];
    ChatGroupRecvListRootVC2 *recvListVC = [[ChatGroupRecvListRootVC2 alloc] init];
    recvListVC.msgid = message.imChatLogModel.msgid;
    recvListVC.dialogID = _dialogid;
    [self.navigationController pushViewController:recvListVC animated:YES];
}

#pragma mark - 转发消息 SelectMessageRootDelegate

-(void) dicClickItemDelegate:(NSInteger)contactType DialogID:(NSString *)dialogID contacName:(NSString *)contactName otherInfo:(NSMutableDictionary *)otherInfo{
    
    resend_contactTyep = contactType;
    resend_dialogID = dialogID;
    resend_contactName = contactName;
    resend_otherInfo = otherInfo;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LZGDCommonLocailzableString(@"message_confirm_sendto") message:contactName delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_cancel") otherButtonTitles:LZGDCommonLocailzableString(@"common_confirm"), nil];
    alertView.tag = 2;
    [alertView show];
}

#pragma mark - 发送消息
/**
 *  重发、转发调用
 */
-(void)sendMessageWithImChatLogModel:(ImChatLogModel *)imChatLogModel controller:(ChatViewController *)chatVC type:(NSInteger)type combineMsgArr:(NSArray *)selectCombineMsg{
    /* 文本 */
    if([imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_LZMsgNormal_Text]){
        [chatVC didSendTextAction:imChatLogModel.imClmBodyModel.content];
    }
    /* 图片 */
    else if([imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_Image_Download]){
        
        NSString *msgid = imChatLogModel.imClmBodyModel.msgid;
        NSString *clientTempId = imChatLogModel.imClmBodyModel.clienttempid;
        NSString *filePhysicalName = imChatLogModel.imClmBodyModel.fileModel.smalliconclientname;
        NSString *fileid = imChatLogModel.imClmBodyModel.bodyModel.fileid;
        NSString *fileShowName = imChatLogModel.imClmBodyModel.bodyModel.name;
        
        /* 转发 */
        if(type==1){
            
            NSString *filePath = [FilePathUtil getChatRecvImageDicAbsolutePath];
            if([imChatLogModel.imClmBodyModel.from isEqualToString:currentUserID]){
                filePath = [FilePathUtil getChatSendImageDicAbsolutePath];
            }
            [chatVC didResendAblumWithMsgId:msgid clienttempid:clientTempId filePath:filePath filePhysicalName:filePhysicalName fileid:fileid fileShowName:fileShowName];
        }
        /* 重发 */
        else {
            NSString *fileShowName = imChatLogModel.imClmBodyModel.bodyModel.name;
            NSString *filePhysicalName = imChatLogModel.imClmBodyModel.fileModel.smalliconclientname;
            
            UploadFileModel *fileModel = [[UploadFileModel alloc] init];
            fileModel.filePhysicalName = filePhysicalName;
            fileModel.fileShowName = fileShowName;
            
            NSMutableArray *sendArr = [[NSMutableArray alloc] init];
            [sendArr addObject:fileModel];
            [chatVC didSendAblumAction:sendArr];
        }
    }
    /* 视频 */
    else if ([imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_Micro_Video]){
        NSString *msgid = imChatLogModel.imClmBodyModel.msgid; // 消息id
        NSString *clientTempId = imChatLogModel.imClmBodyModel.clienttempid; // 客户端生成的临时id
        NSString *iconName = imChatLogModel.imClmBodyModel.fileModel.smalliconclientname;
        NSString *videoName = imChatLogModel.imClmBodyModel.fileModel.smallvideoclientname;
        /* 转发 */
        if (type == 1) {
            NSString *filePath = [FilePathUtil getChatRecvImageDicAbsolutePath];
            if([imChatLogModel.imClmBodyModel.from isEqualToString:currentUserID]){
                filePath = [FilePathUtil getChatSendImageDicAbsolutePath];
            }
            [chatVC didResendVideoWithMsgId:msgid clienttempid:clientTempId filePath:filePath iconName:iconName videoName:videoName];
        /* 重发 */
        } else {
            [chatVC didSendVideoActionCoverName:iconName filePhysicalName:videoName];
        }
        
    }
    /* 文件 */
    else if([imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_File_Download]){
        NSString *fileName = imChatLogModel.imClmBodyModel.bodyModel.name;
        NSString *name = [fileName substringToIndex:[fileName rangeOfString:@"." options:NSBackwardsSearch].location];
        long long size = imChatLogModel.imClmBodyModel.bodyModel.size;
		NSString *exptype = @"";
		if([fileName rangeOfString:@"."].location!=NSNotFound){
			exptype = [fileName substringFromIndex:[fileName rangeOfString:@"." options:NSBackwardsSearch].location+1];
		}
		
        ResModel *resModel = [[ResModel alloc] init];
        resModel.rid = imChatLogModel.imClmBodyModel.bodyModel.rid;
        resModel.expid = imChatLogModel.imClmBodyModel.bodyModel.fileid;
        resModel.icon = imChatLogModel.imClmBodyModel.bodyModel.icon;
        resModel.name = name;
        resModel.exptype = exptype;
        resModel.size = size;
        resModel.version = imChatLogModel.imClmBodyModel.bodyModel.rversion;
        resModel.rtype = 1;
        NSString *isresource = imChatLogModel.imClmBodyModel.bodyModel.isresource;
        if( ![NSString isNullOrEmpty:isresource] && [isresource isEqualToString:@"true"]){
            resModel.rtype = 3;
        }
        if(![imChatLogModel.imClmBodyModel.from isEqualToString:currentUserID]){
            /* 将文件复制到发送文件夹中 */
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *savePath = [FilePathUtil getChatSendImageDicAbsolutePath];
            NSString *netPath = [FilePathUtil getChatRecvImageDicAbsolutePath];
            [fileManager copyItemAtPath:[netPath stringByAppendingFormat:@"%@.%@",resModel.expid,resModel.exptype]
                                 toPath:[savePath stringByAppendingFormat:@"%@.%@",resModel.expid,resModel.exptype]
                                  error:nil];
        }
        [chatVC didSendNetDiskFile:resModel];
    }
    /* 名片 */
    else if([imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_Card]){
        NSString *uid = imChatLogModel.imClmBodyModel.bodyModel.uid;
        NSString *username = imChatLogModel.imClmBodyModel.bodyModel.username;
        NSString *face = imChatLogModel.imClmBodyModel.bodyModel.face;
        
        UserModel *userModel = [[UserModel alloc] init];
        userModel.uid = uid;
        userModel.username = username;
        userModel.face = face;
        
        [chatVC didSendCard:userModel];
    }
    /* urllink */
    else if ([imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_UrlLink]) {
        NSString *urlTitle = imChatLogModel.imClmBodyModel.bodyModel.urltitle;
        NSString *urlStr = imChatLogModel.imClmBodyModel.bodyModel.urlstr;
        NSString *urlImage = imChatLogModel.imClmBodyModel.bodyModel.urlimage;
        [chatVC didSendUrlLink:urlTitle urlStr:urlStr urlImage:urlImage];
    }
    // 共享文件
    else if ([imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_LZTemplateMsg_CooperationShareFile]) {
        
        [chatVC didSendShareMsg:imChatLogModel.imClmBodyModel.body];
    }
    /* 语音 */
    else if([imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_Voice]){
        NSString *voicePath = [FilePathUtil getChatSendImageDicAbsolutePath];
        NSString *voiceName = imChatLogModel.imClmBodyModel.voiceModel.wavname;
        NSString *voiceDuration = imChatLogModel.imClmBodyModel.bodyModel.duration;
        
        [chatVC didSendMessageWithVoice:[NSString stringWithFormat:@"%@%@",voicePath,voiceName] name:voiceName voiceDuration:voiceDuration];
    }
    /* 位置 */
    else if([imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_Geolocation]){
        /* 图片上传失败，重新发送 */
        if([NSString isNullOrEmpty:imChatLogModel.imClmBodyModel.bodyModel.fileid]){
            NSString *geoimagename = imChatLogModel.imClmBodyModel.geolocationModel.geoimagename;
            CGFloat zoom = imChatLogModel.imClmBodyModel.bodyModel.geozoom;
            CGFloat longitude = imChatLogModel.imClmBodyModel.bodyModel.geolongitude;
            CGFloat latitude = imChatLogModel.imClmBodyModel.bodyModel.geolatitude;
            NSString *address = imChatLogModel.imClmBodyModel.bodyModel.geoaddress;
            NSString *position = imChatLogModel.imClmBodyModel.bodyModel.geodetailposition;
            
            [chatVC didSendLocationAction:geoimagename zoom:zoom longitude:longitude latitude:latitude address:address position:position];
        }
        else {
            [chatVC didResendLocationAction:imChatLogModel];
        }
    }
    /* 消息模板 */
    else if([imChatLogModel.handlertype hasPrefix:Handler_Message_LZChat_LZTemplateMsg_BSform]){
        [chatVC didResendCustomMsg:imChatLogModel];
    }
    /* 合并转发消息 */
    else if (selectCombineMsg != nil && selectCombineMsg.count > 0) {
        NSMutableArray *tmparr = [NSMutableArray array];
        for (XHMessage *tmpmsg in selectCombineMsg) {
            NSMutableDictionary *chatlogDic = [tmpmsg.imChatLogModel.imClmBodyModel convertModelToDictionary];
            
            /* 将这个数组中合并消息的三层以上的 body 删除 */
//            chatlogDic = [self removeMoreChatlogBody:chatlogDic];
            
            [chatlogDic setObject:tmpmsg.faceid forKey:@"senduserface"];
            [chatlogDic setObject:tmpmsg.sender forKey:@"sendusername"];
            [chatlogDic removeObjectForKey:@"readstatus"];
            NSString *tmpStr = @"";
            tmpStr = [tmpStr dictionaryToJson:chatlogDic];
            [tmparr addObject:tmpStr];
        }
        NSString *title = @"";
        if (imRecentModel.contacttype == 0) {
            if ([imRecentModel.contactid isEqualToString:[AppUtils GetCurrentUserID]]) {
                title = [NSString stringWithFormat:@"%@的聊天记录",imRecentModel.contactname];
            } else {
                title = [NSString stringWithFormat:@"%@和%@的聊天记录",[AppUtils GetCurrentUserName],imRecentModel.contactname];
            }
        } else {
            title = @"群组的聊天记录";
        }
        
        [chatVC didSendChatLogTitle:title contentArr:tmparr];
    }
    /* 转发合并消息 */
    else if ([imChatLogModel.handlertype hasPrefix:Handler_Message_LZChat_ChatLog]) {
        NSString *title = imChatLogModel.imClmBodyModel.bodyModel.title;
        NSMutableArray *tmparr = imChatLogModel.imClmBodyModel.bodyModel.chatlogArr;
        [chatVC didSendChatLogTitle:title contentArr:tmparr];
    }
}
// 递归方法，清空三成合并消息的 body
- (NSMutableDictionary *)removeMoreChatlogBody:(NSDictionary *)chatlogDic {
    if (chatlogDic == nil || chatlogDic.count == 0) {
        return nil;
    }
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    if ([[chatlogDic lzNSStringForKey:@"handlertype"] isEqualToString:Handler_Message_LZChat_ChatLog]) {
        NSMutableArray *tmpArr = [[[chatlogDic lzNSDictonaryForKey:@"body"] lzNSStringForKey:@"chatlog"] serialToArr];
        NSLog(@"==============%@",tmpArr);
        for (NSMutableDictionary *tmpDic in tmpArr) {
            resultDic = [self removeMoreChatlogBody:tmpDic];
        }
    }
    
    return resultDic;
}
#pragma mark - UIAlert Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
        {
            /* 发送名片 */
            if(alertView.tag==1){
                [self didSendCard:sendCardUserModel];
            }
            /* 转发消息 */
            else if( alertView.tag==2){
                /* 成功转发多条消息后再判断 */
                if ([self.navigationItem.leftBarButtonItems lastObject].customView.hidden == YES) {
                    /* 相当于点击左上角取消 */
                    [self cancleBtnEvent];
                }
                [self dismissViewControllerAnimated:YES completion:nil];
                imRecentModel = [[ImRecentDAL shareInstance] getRecentModelWithContactid:_dialogid];
                NSString *beforeName = imRecentModel.contactname;
                
                ChatViewController *chatVC = [self createChatViewControllerContactType:resend_contactTyep DialogID:resend_dialogID];
                WEAKSELF
                ChatViewDidAppearBlock chatViewDidAppearBlock = ^(){
                    NSMutableArray *selectMsg = [resend_otherInfo objectForKey:@"message"];
                    for (id <XHMessageModel> message in selectMsg) {
                        ImChatLogModel *imChatLogModel = message.imChatLogModel;
                        [weakSelf sendMessageWithImChatLogModel:imChatLogModel controller:chatVC type:1 combineMsgArr:nil];
                    }
                    /* 合并消息 */
                    NSMutableArray *selectCombineMsg = [resend_otherInfo objectForKey:@"combinemessage"];
                    if (selectCombineMsg !=nil) {
                        [weakSelf sendMessageWithImChatLogModel:nil controller:chatVC type:1 combineMsgArr:selectCombineMsg];
                        
                    }
                };
                chatVC.chatViewDidAppearBlock = chatViewDidAppearBlock;
                chatVC.isPopToMsgTab = YES;
//                [self.appDelegate.lzGlobalVariable.messageRootVC pushChatViewControllerContactType:chatVC controller:self];
                [self.navigationController pushViewController:chatVC animated:YES];
                //为成员变量Window赋值则立即显示Window
                __sheetWindow = [Prompt showPromptWithStyle:PromptStyleSuccess title:@"已发送" detail:nil canleButtonTitle:@"留在当前聊天" okButtonTitle:[NSString stringWithFormat:@"返回和%@聊天",beforeName] callBlock:^(MyWindowClick buttonIndex) {
                    
                    //Window隐藏，并置为nil，释放内存 不能少
                    __sheetWindow.hidden = YES;
                    __sheetWindow = nil;
                    
                    if (buttonIndex == 0) {
                        /* 如果自己给自己转发，这个返回不执行 */
                        if (![_dialogid isEqualToString:resend_dialogID]) {
                            [self popViewControllerAnimated:YES];
                        }
                    }
                }];
            }
            break;
        }
        default:
            break;
    }
}


#pragma mark - 语音播放 XHAudioPlayerHelper Delegate

- (void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer {
    [[XHAudioPlayerHelper shareInstance] setPlayingInfo:nil];
    
//    if (!currentSelectedCell) {
//        /* 播放完成 */
//        [self didAudioPlayNextVoice];
//        return;
//    }
    [currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
    currentSelectedCell = nil;
}

- (void)didAudioPlayerSuccessFinishPlay:(AVAudioPlayer*)audioPlayer{
//    if (currentSelectedCell!=nil) {
        /* 播放完成 */
        [self didAudioPlayNextVoice];
//        return;
//    }
//    currentSelectedCell = nil;
}

-(void)didAudioPlayNextVoice{
    /* 当前点击的播放完成，开始自动播放下一条 */
    id<XHMessageModel> message = (id<XHMessageModel>)[[XHAudioPlayerHelper shareInstance] otherInfo];
    ImChatLogModel *chatLogModel = message.imChatLogModel;
    
    /* 当前用户发送的语音 */
    if([chatLogModel.from isEqualToString:self.currentUid]){
        return;
    }
    
    id<XHMessageModel> xhMessage = nil;
    int theIndex = -1;
    BOOL isStart = NO;
    for (int i=0;i<[self.messages count];i++) {
        xhMessage = [self.messages objectAtIndex:i];
        NSString *xhMessageMsgid = xhMessage.imChatLogModel.msgid;
        NSString *xhMessageClientTempID = xhMessage.imChatLogModel.clienttempid;
        if([xhMessageMsgid isEqualToString:chatLogModel.msgid]
           || (![NSString isNullOrEmpty:chatLogModel.clienttempid] && [xhMessageClientTempID isEqualToString:chatLogModel.clienttempid] ) ){
            isStart = YES;
            continue;
        }
        /* 已查找到刚播放完的语音 */
        if(isStart){
            /* 语音消息，接收到的，未播放过 */
            if([xhMessage.imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_Voice]
               && ![xhMessage.imChatLogModel.imClmBodyModel.from isEqualToString:currentUserID] ){
                /* 直到语音消息就停止 */
                if(!xhMessage.imChatLogModel.imClmBodyModel.bodyModel.status){
                    theIndex = i;
                }
                break;
            }
        }
    }
    /* 开始下一条的播放 */
    if(theIndex!=-1){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:theIndex inSection:0];
        XHMessageTableViewCell *cell = (XHMessageTableViewCell *)[self.messageTableView cellForRowAtIndexPath:indexPath];

        [self multiMediaMessageDidSelectedOnMessage:xhMessage atIndexPath:indexPath onMessageTableViewCell:cell];
    }
}

#pragma mark - 图片浏览 Delegate

#pragma mark - MWPhotoBrowserDelegate

/**
 *  重新设置NavigationController
 */
- (BOOL)lzPhotoBrowserSetNavigationController:(MWPhotoBrowser *)photoBrowser{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    return YES;
}
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return photoBrowserArr.count;
    return 0;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < photoBrowserArr.count) {
        
        DDLogVerbose(@"------------------%ld",(unsigned long)index);
        
        ImChatLogModel *chatLogModel = (ImChatLogModel *)[photoBrowserArr objectAtIndex:index];
        
        NSString *smallFolderPath = @"";
        NSString *oriFolderPath = @"";
        /* 文件夹路径 */
        if([chatLogModel.imClmBodyModel.from isEqualToString:currentUserID]){
            smallFolderPath = [FilePathUtil getChatSendImageSmallDicAbsolutePath];
            oriFolderPath = [FilePathUtil getChatSendImageDicAbsolutePath];
        } else {
            smallFolderPath = [FilePathUtil getChatRecvImageSmallDicAbsolutePath];
            oriFolderPath = [FilePathUtil getChatRecvImageDicAbsolutePath];
        }
        
        /* 客户端文件名称 */
        NSString *clientImageName = chatLogModel.imClmBodyModel.fileModel.smalliconclientname;
        NSString *smallImagePath = [NSString stringWithFormat:@"%@%@",smallFolderPath,clientImageName];
        NSString *oriImagePath = [NSString stringWithFormat:@"%@%@",oriFolderPath,clientImageName];
        
        /* url路径 */
        NSString *smallThumbnailUrl = [GalleryImageViewModel GetGalleryThumbnailImageUrlFileId:chatLogModel.imClmBodyModel.bodyModel.fileid size:@"200X200"];
        NSString *oriThumbnailUrl = [GalleryImageViewModel GetGalleryOriImageUrlFileId:chatLogModel.imClmBodyModel.bodyModel.fileid];
        
        /* 添加长按时所需参数 */
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        [dic setValue:chatLogModel.imClmBodyModel.bodyModel.name forKey:@"fileshowname"];
        [dic setValue:chatLogModel.imClmBodyModel.fileModel.smalliconclientname forKey:@"filephysicalname"];
        [dic setValue:chatLogModel.imClmBodyModel.msgid forKey:@"msgid"];
        if([NSString isNullOrEmpty:chatLogModel.imClmBodyModel.bodyModel.fileid]){
            [dic setValue:@"" forKey:@"fileid"];
        } else {
            [dic setValue:chatLogModel.imClmBodyModel.bodyModel.fileid forKey:@"fileid"];
        }
        if([NSString isNullOrEmpty:chatLogModel.imClmBodyModel.clienttempid]){
            [dic setValue:@"" forKey:@"clienttempid"];
        } else {
            [dic setValue:chatLogModel.imClmBodyModel.clienttempid forKey:@"clienttempid"];
        }
        if([chatLogModel.imClmBodyModel.from isEqualToString:currentUserID]){
            [dic setValue:[FilePathUtil getChatSendImageDicAbsolutePath] forKey:@"filepath"];
        } else {
            [dic setValue:[FilePathUtil getChatRecvImageDicAbsolutePath] forKey:@"filepath"];
        }
        NSString *otherInfo=[dic dicSerial];
        
        /* 获取所需的PhotoBrowser */
        MWPhoto *photo = [[[PhotoBrowserViewModel alloc] init] getMWPhotModelWithSmallImagePath:smallImagePath oriImagePath:oriImagePath smallThumbnailUrl:smallThumbnailUrl oriThumbnailUrl:oriThumbnailUrl photoBrowser:photoBrowser index:index otherInfo:otherInfo downloadFinishBlock:^{
            /* 更新数据库 */
            [[ImChatLogDAL shareInstance] updateRecvStatusWithMsgId:chatLogModel.imClmBodyModel.msgid withRecvstatus:Chat_Msg_Downloadsuccess];
        }];
        
        return photo;        
    }
    return nil;
}

- (BOOL)lzPhotoBrowserLongPressClickPhotoBrowser:(MWPhotoBrowser *)photoBrowser key:(NSString *)key{
    return [[[PhotoBrowserViewController alloc] init] clickDefaultLongPressActionPhotoBrowser:photoBrowser key:key sourceController:self];
}

#pragma mark - 处理回执

/**
 *  Cell可见之后的处理
 */
-(void)cellWillAppear:(id <XHMessageModel>) message{
    [super cellWillAppear:message];
    
    if ([message.imChatLogModel.msgid isEqualToString:self.firstUnreadChatLogModel.msgid]) {
        self.showUnreadMsgButton.hidden = YES;
    }
    
    if ([message.imChatLogModel.msgid isEqualToString:firstMsgid]) {
        /* 从数据库中获取记录 */
        [self downloadMoreMessagesScrollTotop];
    }
//    if(message.bubbleMessageType == XHBubbleMessageTypeReceiving
//       && message.imChatLogModel.recvisread == 0){
//        DDLogVerbose(@"需要发送回执的cell---: %@",message.text);
//        
//        /* 发送消息回执 */
//        NSMutableArray *postData = [[NSMutableArray alloc] init];
//        [postData addObject:message.imChatLogModel.msgid];
//        
//        NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
//        [getData setObject:@"2" forKey:@"type"];
////        [self.appDelegate.lzservice sendToServerForPost:WebApi_Message routePath:WebApi_Message_Report moduleServer:Modules_Message getData:getData postData:postData otherData:nil];
//    }
}

#pragma mark - 更改聊天界面背景图片的代理方法
-(void)setChangeChatViewControllerBackGround:(NSString *)filePhysicalName {
    NSString *savePath=[[FilePathUtil getChatSendImageDicAbsolutePath] stringByAppendingPathComponent:filePhysicalName];
    [super setBackgroundImage:[UIImage imageWithContentsOfFile:savePath]];
    [super setBackgroundColor:[UIColor clearColor]];
    [self showSuccessWithText:@"设置成功"];
    /* 设置背景图片后记录下来 */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:filePhysicalName forKey:@"chatviewbackground"];
    [defaults setObject:_dialogid forKey:@"dialogid"];
    [defaults synchronize];
}

#pragma mark - Privation Function

/**
 *  根据消息Model获取所在的NSIndexPath
 *
 *  @param chatLogModel 消息Model对象
 *
 *  @return cell所在的NSIndexPath值
 */
-(NSIndexPath *)getIndexPathByChatLogModel:(ImChatLogModel *)chatLogModel
                          updateSendStatus:(NSInteger)sendStatus
                                recvIsread:(NSInteger)recvIsread{
    
    int theIndex = -1;
    for (int i=0;i<[self.messages count];i++) {
        XHMessage *xhMessage = [self.messages objectAtIndex:i];
        NSString *xhMessageMsgid = xhMessage.imChatLogModel.msgid;
        NSString *xhMessageClientTempID = xhMessage.imChatLogModel.clienttempid;
        if([xhMessageMsgid isEqualToString:chatLogModel.msgid]
           || (![NSString isNullOrEmpty:chatLogModel.clienttempid] && [xhMessageClientTempID isEqualToString:chatLogModel.clienttempid] ) ){
            theIndex = i;
            
            /* 修改数据 */
            if(sendStatus!=-1){
                xhMessage.sendStatus = sendStatus;
            }
            if(recvIsread!=-1){
                xhMessage.imChatLogModel.recvisread = recvIsread;
            }
        }
    }
    if(theIndex==-1){
//        theIndex = (int)[self.messages count] - 1;
        return nil;
    }

    return [NSIndexPath indexPathForRow:theIndex inSection:0];
}

/**
 *  刷新返回按钮上的文字
 */
-(void)refreshBackButtonText{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *showText = nil;
        if( ![NSString isNullOrEmpty:_popToViewController] && [_popToViewController isEqualToString:@"back"]){
            showText = LZGDCommonLocailzableString(@"common_back");
        } else {
            showText = LZGDCommonLocailzableString(@"common_message");
            
            otherNoReadCount = [[ImRecentDAL shareInstance] getImRecentNoReadMsgCountWithExceptDialog:@[_dialogid]];
            if(otherNoReadCount > 0){
                if(otherNoReadCount<=99){
                    showText = [showText stringByAppendingFormat:@"(%ld)",(long)otherNoReadCount];
                } else {
                    showText = [showText stringByAppendingFormat:@"(99+)"];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{

            if (![backShowText isEqualToString:showText]) {
                backShowText = showText;
                [self addCustomDefaultBackButton:showText];
                [self reloadNavigationData];
            }
        });
    });
}


#pragma mark - 更换头像

/**
 *  更新头像后判断是否需要刷新此视图
 */
-(void)checkIsNeedRefresTableViewForUid:(NSString *)uid{
    for(int i=0;i<self.messages.count;i++){
        XHMessage *xhMessage = [self.messages objectAtIndex:i];
        if([xhMessage.imChatLogModel.from isEqualToString:uid]
           || [xhMessage.imChatLogModel.to isEqualToString:uid]){
            self.isNeedRefreshLZTableViewWhenViewAppear = YES;
            return;
        }
    }
}
-(void)refreshWhenViewAppearForUpdateUid{
    [self.messageTableView reloadData];
    [self reloadNavigationData];
}
#pragma mark - 页面敲击的时候，隐藏键盘
/**
 *  隐藏键盘
 */
-(void)hideKeyBoard{
    [self.view endEditing:YES];
    [self.messageInputView.inputTextView resignFirstResponder];
}
- (void)scrollToBottom {
    isFromPhotograph = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self scrollToBottomAnimated:NO];
        if (self.isAtBottom) {
            self.messageTableView.contentOffset = CGPointMake(0, self.messageTableView.contentOffset.y + 20);
        }
    });
}

/**
 通过通知改变发送状态
 */
- (void)changeSendState:(NSNotification *)noti {
    NSDictionary *dic = noti.userInfo;
    if ([dic[@"dialogID"] isEqualToString:_dialogid]) {
        ImChatLogModel *chatLogModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:dic[@"msgid"] orClienttempid:@""];
        NSIndexPath *indexPath = [self getIndexPathByChatLogModel:chatLogModel updateSendStatus:chatLogModel.sendstatus recvIsread:-1];
        if(indexPath!=nil){
            /* 添加已读、未读状态 */
            XHMessage *xhMessage = [self.messages objectAtIndex:indexPath.row];
            xhMessage.imChatLogModel = chatLogModel;
            [chatViewModel addReadStatusToMessage:xhMessage chatLogModel:chatLogModel];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                /* 更改View中的状态 */
                XHMessageTableViewCell *cell = (XHMessageTableViewCell *)[self.messageTableView cellForRowAtIndexPath:indexPath];
                cell.message = xhMessage;
                [cell changeSendStatusInCell:xhMessage];
            });
        }
    }
}

#pragma mark - 批量保存文件到云盘之后的操作
- (void)afterSaveToCloudByBatch:(NSNotification *)noti {
    NSDictionary *dic = noti.userInfo;
    if ([dic[@"issuccess"] isEqualToString:@"1"]) {
        if ([self.navigationItem.leftBarButtonItems lastObject].customView.hidden == YES) {
            /* 相当于点击左上角取消 */
            [self cancleBtnEvent];
        }
    } else {
        NSMutableArray<XHMessage *> *saveFailFileArray = dic[@"saveFailFileArray"];
        self.moreMenuView.selectMsgArray = saveFailFileArray;
    }
}

/**
 定位到消息中的位置
 */
- (void)localForChatMsg:(NSString *)msgid clienttempid:(NSString *)clienttempid {
    [self showLoadingWithText:LCProgreaaHUD_Show_Loading];
    /* 根据msgid或clienttempid获取该条消息的model */
    ImChatLogModel *imChatLogModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:msgid orClienttempid:clienttempid];
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /* 获取该条消息下有多少条消息 */
        NSInteger count = [[ImChatLogDAL shareInstance] getMsgCountWithChatLogModel:imChatLogModel];
    
        /* 获取位置 */
        NSMutableArray *resultArray = [chatViewModel getViewDataSource:weakSelf.dialogid
                                                            startCount:0
                                                            queryCount:count];
        
        NSInteger allHeight = 0;
        for (XHMessage *msg in resultArray) {
            /* 当在浏览图片的时候收到的新消息是没有保存heightforrow的，所以要临时计算 */
            if ([msg.imChatLogModel.heightforrow integerValue] == 0) {
                CGFloat calculateCellHeight = 0;
                NSIndexPath *indexPath = [self getIndexPathByChatLogModel:msg.imChatLogModel updateSendStatus:msg.imChatLogModel.sendstatus recvIsread:-1];
                if ([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:targetMessage:)]) {
                    calculateCellHeight = [self.delegate tableView:self.messageTableView heightForRowAtIndexPath:indexPath targetMessage:msg];
                } else {
                    calculateCellHeight = [self calculateCellHeightWithMessage:msg atIndexPath:indexPath];
                }
                allHeight += (calculateCellHeight + 20);
            } else {
                allHeight += ([msg.imChatLogModel.heightforrow integerValue] + 20);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (allHeight < LZ_SCREEN_HEIGHT - LZ_STATUS_NAV_HEIGHT - 44) {
                [weakSelf hideLoading];
                [weakSelf scrollToBottomAnimated:NO];
            } else {
                weakSelf.existsMoreDateForLoading = YES;
                [weakSelf hideLoading];
                weakSelf.messages = resultArray;
                [weakSelf.messageTableView reloadData];
                [weakSelf scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        });
    });
}

#pragma mark - LZMoreMenuViewDelegate

/**
 批量转发功能

 @param messageArray
 */
- (void)didSendMessageByBatch:(NSMutableArray *)messageArray {
    if (messageArray.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请选择要转发的消息" message:nil delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm") otherButtonTitles:nil];
        [alertView show];
        return;
    }
    for (XHMessage *tmpMsg in messageArray) {
        if ([tmpMsg.imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_Card] ||
            [tmpMsg.imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_Voice] ||
            [tmpMsg.imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_VideoCall] ||
             [tmpMsg.imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_VoiceCall]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"语音、名片、视频聊天不支持转发" message:nil delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm") otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    /* 未发送成功的消息不能转发 */
    for (XHMessage *tmpMsg in messageArray) {
        if (tmpMsg.sendStatus == Chat_Msg_SendFail) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未发送成功的消息不支持转发" message:nil delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm") otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    
    /* 选择逐条转发、合并转发 */
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:LZGDCommonLocailzableString(@"common_cancel")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"逐条转发", @"合并转发", nil];
    actionSheet.tag = 1001;
    transmitMsgArr = messageArray;
    [actionSheet showInView:self.view];
}

/**
 批量删除

 @param messageArray
 */
- (void)didDeleteMessageByBatch:(NSMutableArray *)messageArray {
    if (messageArray.count == 0) {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"请选择要删除的消息" message:nil delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm") otherButtonTitles:nil];
        [alterView show];
        return;
    }
    NSMutableArray *msgidArr = [NSMutableArray array];
    for (XHMessage *msg in messageArray) {
        [msgidArr addObject:msg.imChatLogModel.msgid];
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"是否删除消息？"
                                                             delegate:self
                                                    cancelButtonTitle:LZGDCommonLocailzableString(@"common_cancel")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:LZGDCommonLocailzableString(@"common_confirm"), nil];
    actionSheet.tag=5000;
    [actionSheet showInView:self.view];
    [tmpMsgidArr removeAllObjects];
    tmpMsgidArr = msgidArr;
}
/* 批量保存到云盘 */
- (void)didSaveToCloudByBatch:(NSMutableArray *)messageArray {
    if (messageArray.count == 0) {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"请选择要保存的消息" message:nil delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm") otherButtonTitles:nil];
        [alterView show];
        return;
    }
    for (XHMessage *tmpMsg in messageArray) {
        if (![tmpMsg.imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_Image_Download] &&
            ![tmpMsg.imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_File_Download] &&
            ![tmpMsg.imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_Micro_Video]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"只有视频、图片和文件能保存到云盘，请重新选择" message:nil delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm") otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    /* 未发送成功的消息不能保存 */
    for (XHMessage *tmpMsg in messageArray) {
        if (tmpMsg.sendStatus == Chat_Msg_SendFail) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未发送成功的消息不支持保存到云盘，请重新选择" message:nil delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm") otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
//    if (self.navigationItem.leftBarButtonItem.customView.hidden == YES) {
//        /* 相当于点击左上角取消 */
//        [self cancleBtnEvent];
//    }
    [[[PhotoBrowserViewController alloc] init] fileMessageSaveToNetDiskByBatch:messageArray sourceController:self];
    _leftButtonView.hidden = YES;
}
/* 动态留痕 */
- (void)didDynamicTraceByBatch:(NSMutableArray *)messageArray {
    NSLog(@"动态留痕");
    if (messageArray.count == 0) {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"请选择要留痕的消息" message:nil delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm") otherButtonTitles:nil];
        [alterView show];
        return;
    }
//    for (XHMessage *tmpMsg in messageArray) {
//        /* [tmpMsg.imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_Card] ||
//         [tmpMsg.imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_Voice] ||
//         */
//        if ([tmpMsg.imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_VideoCall] ||
//            [tmpMsg.imChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_VoiceCall]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"语音、名片、视频聊天不支持留痕" message:nil delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm") otherButtonTitles:nil];
//            [alertView show];
//            return;
//        }
//    }
    /* 未发送成功的消息不能 */
    for (XHMessage *tmpMsg in messageArray) {
        if (tmpMsg.sendStatus == Chat_Msg_SendFail) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未发送成功的消息不支持留痕" message:nil delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm") otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    if (messageArray.count > 50) {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"动态留痕最多可选50条消息" message:nil delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_confirm") otherButtonTitles:nil];
        [alterView show];
        return;
    }
    if (messageArray !=nil) {
        NSMutableArray *tmparr = [NSMutableArray array];
        for (XHMessage *tmpmsg in messageArray) {
            NSMutableDictionary *chatlogDic = [tmpmsg.imChatLogModel convertModelToDictionary];
            [chatlogDic addEntriesFromDictionary:[tmpmsg.imChatLogModel.imClmBodyModel convertModelToDictionary]];
            [chatlogDic removeObjectForKey:@"imClmBodyModel"];
            [chatlogDic removeObjectForKey:@"showindexdate"];
            [chatlogDic removeObjectForKey:@"readstatus"];
            [chatlogDic removeObjectForKey:@"body"];
            [chatlogDic setObject:tmpmsg.faceid forKey:@"senduserface"];
            [chatlogDic setObject:tmpmsg.sender forKey:@"sendusername"];
            [tmparr addObject:chatlogDic];
        }
        
        [self upContenct:tmparr appcodedataid:toGroupModel.relateid rangename:toGroupModel.name];
    }
    if ([self.navigationItem.leftBarButtonItems lastObject].customView.hidden == YES) {
        /* 相当于点击左上角取消 */
        [self cancleBtnEvent];
    }
    if ([LZUserDataManager readIsConnectNetWork]) {
        [self showSuccessWithText:@"留痕成功"];
    } else {
        [self showErrorWithText:@"留痕失败"];
    }
}
-(void)upContenct:(NSMutableArray *)messageArray appcodedataid:(NSString *)appcodedataid rangename:(NSString *)rangename{
    
    //此处自定义😯返回处理😯
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    
    // 用户ID
    param[@"releaseusername"]=[AppUtils GetCurrentOrgUsername];
    // 用户名字
    param[@"releaseuser"]=[[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
    //发布时间
    param[@"releasedate"]=[AppDateUtil GetCurrentDateForString];
    //内容
//    param[@"content"]=mainTextView.text;
    
    param[@"posttemplatedata"] = [@{@"chatlog":[messageArray arraySerial]} dicSerial];
    
    param[@"favoritetitle"]=@"[聊天记录]";
    
    param[@"relevanceappcode"]=@"Cooperation";
    
    param[@"posttypecode"]=(toGroupModel.relatetype == 2) ? @"task" : @"group";
    
    param[@"appcode"]= (toGroupModel.relatetype == 2) ? @"task" : (toGroupModel.relatetype == Chat_ContactType_Second_CoGroup_Other ? appcode : @"group");
    //所属协作ID
    param[@"appcodedataid"]=appcodedataid;
    //所属协作名字
    param[@"rangename"]=rangename;
    //说说
    param[@"msgtype"]=@"0";
    param[@"posttemplateid"] = @"postmessage";
    param[@"posttemplatetype"] = @"1";
    
    param[@"postresourcetype"] = @"0";
    
    //用户头像
    param[@"releaseuserface"]=[[LZUserDataManager readCurrentUserInfo] objectForKey:@"face"];
    
    param[@"positiondic"]=nil;
    
    
    [[self appDelegate].lzservice sendToServerForPost:WebApi_CloudPost routePath:WebApi_CloudPostAddPost moduleServer:Modules_Default getData:@{@"isRefresh":@"1"} postData:param otherData:nil];
    
    
}
#pragma mark - 方便置顶，发送一条消息然后删除
- (void)sendMessageAndDeleteMsg:(NSNotification *)noti {
    NSDictionary *dic = noti.userInfo;
    if ([dic[@"dialogid"] isEqualToString:[self resetDialogID]]) {
        [self didSendTextAction:@"1"];
        [[ImChatLogDAL shareInstance] deleteImChatLogWithDialogid:[self resetDialogID]];
    }
}

#pragma mark - 视频语音重新呼叫代理
- (void)clickMessageForReCall:(BOOL)isVideo {
    if (isVideo) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"是否发起视频聊天？"
                                                                 delegate:self
                                                        cancelButtonTitle:LZGDCommonLocailzableString(@"common_cancel")
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:LZGDCommonLocailzableString(@"common_confirm"), nil];
        actionSheet.tag=6000;
        [actionSheet showInView:self.view];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"是否发起语音聊天？"
                                                                 delegate:self
                                                        cancelButtonTitle:LZGDCommonLocailzableString(@"common_cancel")
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:LZGDCommonLocailzableString(@"common_confirm"), nil];
        actionSheet.tag=7000;
        [actionSheet showInView:self.view];
    }
}

/**
 主动加入多人视频的点击方法
 */
- (void)isJoinGroupCallBtnClick {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"是否加入语音聊天？"
                                                             delegate:self
                                                    cancelButtonTitle:LZGDCommonLocailzableString(@"common_cancel")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:LZGDCommonLocailzableString(@"common_confirm"), nil];
    actionSheet.tag=8000;
    [actionSheet showInView:self.view];
}

#pragma mark - 判断是否需要打开或关闭某功能
-(void)checkIsFunctionSetting:(NSString *)sendText{
    if([sendText isEqualToString:Function_Set_ServiceCircle]){
        [AppUtils setFunctionSetting:Function_Set_ServiceCircle];
    }
    if([sendText isEqualToString:Function_Set_ChatVideo]){
        [AppUtils setFunctionSetting:Function_Set_ChatVideo];
    }
    if([sendText isEqualToString:Function_Set_DocumentCoop]){
        [AppUtils setFunctionSetting:Function_Set_DocumentCoop];
    }
    if([sendText isEqualToString:Function_Set_InfoHelp]){
        [AppUtils setFunctionSetting:Function_Set_InfoHelp];
    }
    if([sendText isEqualToString:Function_Set_InfoShare]){
        [AppUtils setFunctionSetting:Function_Set_InfoShare];
    }
    if([sendText isEqualToString:Function_Set_ProjectBranch]){
        [AppUtils setFunctionSetting:Function_Set_ProjectBranch];
    }
}

-(NSString *)resetDialogID{
    //为二级消息聊天框时，需要对二级消息列表刷新
    if(_parsetype!=0 && [_dialogid rangeOfString:@"."].location!=NSNotFound){
        NSString *secondDialogID = [[_dialogid componentsSeparatedByString:@"."] objectAtIndex:1];
        return secondDialogID;
    }
    return _dialogid;
}

@end
