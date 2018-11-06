//
//  PersonRemindViewController.m
//  LeadingCloud
//
//  Created by gjh on 2017/7/18.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "PersonRemindViewController.h"
#import "ImMsgTemplateModel.h"
#import "MsgTemplateViewModel.h"
#import "OrgEnterPriseDAL.h"
#import "ImRecentDAL.h"
#import "ImRecentModel.h"
#import "ImChatLogDAL.h"
#import "PersonRemindViewModel.h"
#import "PersonRemindSettingViewController.h"


/* 默认每页的聊天记录数量 */
#define DEFAULT_CHAT_PAGECOUNT 15
@interface PersonRemindViewController () {
    
    /* 视图对应的ViewModel */
    PersonRemindViewModel *personRemindViewModel;
    /* 第一条消息的msgid */
    NSString *firstMsgid;
    
    /* 其它人未读消息数量 */
    NSInteger otherNoReadCount;
    
    /* 左上角返回按钮文本 */
    NSString *backShowText;
    
    /* 当前界面不可见时是否接收到了新消息 */
    BOOL isReceiveNewMsgWhenNextPage;
    /* 当前界面不可见时是否更改了消息状态 */
    BOOL isReceiveUpdateMsgWhenNextPage;
    // 提醒的contactid
    NSString *contactid;
}

@end

@implementation PersonRemindViewController

- (void)viewDidLoad {    
    /* 隐藏输入框 */
    self.isHideInputView = YES;
    
    /* 当加载该页面的时候，把控制器名称添加到数组中 */
    [self.appDelegate.lzSingleInstance.viewControllerArr addObject:[NSString stringWithUTF8String:object_getClassName(self)]];
    [super viewDidLoad];
    
    [self reloadTitle];
    
    [self setRightButton];
    /* 设置ViewModel相关数据 */
    personRemindViewModel = [[PersonRemindViewModel alloc] init];
    personRemindViewModel.contactType = _contactType;
    
    /* 获取数据源 */
    self.messages = [[NSMutableArray alloc] init];
    
    /* 自动下载聊天记录 */
    [personRemindViewModel checkIsNeedDownChatLog:_dialogid];
    
    /* 初始化数据 */
    [self loadInitChatLog:YES newBottomMsgs:nil];
    
    EVENT_SUBSCRIBE(self, EventBus_Chat_RecvNewMsg);
    EVENT_SUBSCRIBE(self, EventBus_Chat_UpdateMsgStatus);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [super setBackgroundColor:BACKGROUND_COLOR];
    
    [self refreshUnreadCount];
    
    if(isReceiveUpdateMsgWhenNextPage){
        [self.messageTableView reloadData];
    }
    if (isReceiveNewMsgWhenNextPage) {
//        [self loadInitChatLog:NO newBottomMsgs:nil];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *newChatLogs = [[NSMutableArray alloc] init];
            if(self.messages.count>0){
                XHMessage *xhMessage = [self.messages objectAtIndex:self.messages.count-1];
                ImChatLogModel *lastChatLogModel = xhMessage.imChatLogModel;
                
                newChatLogs = [[ImChatLogDAL shareInstance] getChatLogsWithDialogid:lastChatLogModel.dialogid datetime:lastChatLogModel.showindexdate];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(newChatLogs.count>0){
                    [self loadInitChatLog:NO newBottomMsgs:newChatLogs];
                }
            });
        });
    }
    
    
    //注册订阅
    EVENT_SUBSCRIBE(self, EventBus_Chat_DownloadChatlog);
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //取消订阅
    EVENT_UNSUBSCRIBE(self, EventBus_Chat_DownloadChatlog);
}

- (void)dealloc {
    [self.appDelegate.lzSingleInstance.viewControllerArr removeObject:[NSString stringWithUTF8String:object_getClassName(self)]];
    EVENT_UNSUBSCRIBE(self, EventBus_Chat_RecvNewMsg);
    EVENT_UNSUBSCRIBE(self, EventBus_Chat_UpdateMsgStatus);
}

- (BOOL)willDealloc {
    return NO;
}

/**
 加载title标题
 */
- (void)reloadTitle {
    ImMsgTemplateModel *imMsgTemplateModel = [MsgTemplateViewModel getMsgTemplateModel:_dialogid];
    /* 个人提醒 */
    if (imMsgTemplateModel.type == Chat_MsgTemplate_Five) {
        self.title = imMsgTemplateModel.name;
        contactid = imMsgTemplateModel.code;
    }
    /* 企业提醒 */
    else {
        OrgEnterPriseModel *orgEnterPriseModel = [[OrgEnterPriseDAL shareInstance] getEnterpriseByEId:_dialogid];
        if (orgEnterPriseModel != nil) {
            self.title = orgEnterPriseModel.shortname;
            contactid = orgEnterPriseModel.eid;
        } else {
            ImRecentModel *imRecentModel = [[ImRecentDAL shareInstance] getRecentModelWithContactid:_dialogid];
            self.title = imRecentModel.contactname;
            contactid = imRecentModel.contactid;
        }
    }
}

/**
 *  页面显示之后加载数据
 */
- (void)loadInitChatLog:(BOOL)isViewDidLoad newBottomMsgs:(NSMutableArray *)newMsgids{
    isReceiveNewMsgWhenNextPage = NO;
    isReceiveUpdateMsgWhenNextPage = NO;
    
    if(newMsgids ==nil || newMsgids.count<=0){
        /* 清空底部未读消息 */
        [self.hideInTopMsgArr removeAllObjects];
        [self.messageInputView resetBackTopButtonNum:self.hideInTopMsgArr.count];
        
        WEAKSELF
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
//            [weakSelf.messages removeAllObjects];
//            [weakSelf.messageTableView reloadData];
            NSMutableArray *resultArray = [personRemindViewModel getMessageDataSource:weakSelf.dialogid startCount:0 queryCount:DEFAULT_CHAT_PAGECOUNT];
            if(resultArray.count >= DEFAULT_CHAT_PAGECOUNT){
                XHMessage *lastMessage = [resultArray objectAtIndex:0];
                weakSelf.loadingMorePersonRemindDate = [[[ImChatLogDAL alloc] init] checkIsEarlierMsgWithDialogID:weakSelf.dialogid datetime:lastMessage.imChatLogModel.showindexdate msgid:lastMessage.imChatLogModel.msgid];
            } else {
                weakSelf.loadingMorePersonRemindDate = NO;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakSelf.messages = resultArray;
                [weakSelf.messageTableView reloadData];
                
//                [weakSelf scrollToBottomAnimated:NO];
            });
        });
    } else {
        for(int i=0;i<newMsgids.count;i++){
            ImChatLogModel *newChatLogModel = [newMsgids objectAtIndex:i];
            XHMessage *xhMessage = [personRemindViewModel addNewXHMessageWithImChatLogModel:newChatLogModel messages:self.messages];
            [self addMessageToPersonRemind:xhMessage isSend:NO callBack:nil];
        }
    }
    
}

/**
 *  返回按钮方法处理
 */
-(void)customDefaultBackButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 控制器左划返回调用方法
-(void)willMoveToParentViewController:(UIViewController *)parent {
    if (!parent) {
        /* 即将退出界面 */
        NSLog(@"即将退出界面");
        /* 清空底部未读消息 */
        [self.hideInTopMsgArr removeAllObjects];
        [self.messageInputView resetBackTopButtonNum:self.hideInTopMsgArr.count];
    } else {
        /* 即将进入界面 */
        NSLog(@"即将进入界面");
        /* 滚动到顶部 */
        [self scrollToTopAnimated:YES];
    }
}

-(void)didMoveToParentViewController:(UIViewController *)parent {
    if (!parent) {
        /* 已经退出界面 */
//        isTapButton = NO;
        NSLog(@"已经退出界面");
    } else {
        /* 已经进入界面 */
        NSLog(@"已经进入界面");
    }
}

/**
 *  刷新数字
 */
-(void)refreshUnreadCount{
    [personRemindViewModel refreshMsgUnReadCount:_dialogid];
    
    /* 左侧，设置返回按钮 */
    [self refreshBackButtonText];
    
    /* 发送消息回执 */
    [personRemindViewModel sendReportToServer:_dialogid];
}

/**
 *  刷新返回按钮上的文字
 */
-(void)refreshBackButtonText{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *showText = nil;
        showText = LZGDCommonLocailzableString(@"common_message");
        
//        otherNoReadCount = [[ImRecentDAL shareInstance] getImRecentNoReadMsgCount];
        otherNoReadCount = [[ImRecentDAL shareInstance] getImRecentNoReadMsgCountWithExceptDialog:@[_dialogid]];
        if(otherNoReadCount > 0){
            if(otherNoReadCount<=99){
                showText = [showText stringByAppendingFormat:@"(%ld)",(long)otherNoReadCount];
            } else {
                showText = [showText stringByAppendingFormat:@"(99+)"];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (![backShowText isEqualToString:showText]) {
                backShowText = showText;
                [self addCustomDefaultBackButton:showText];
            }
        });
    });
}

/* 添加右上角设置按钮 */
- (void)setRightButton {
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(0, 0, 24, 24);
    [rightBtn addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[ImageManager LZGetImageByFileName:@"msg_cota_btn_cog_default"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightButtonClick:(UIButton *)btn{
    PersonRemindSettingViewController * settingVC = [[PersonRemindSettingViewController alloc] init];
    settingVC.contactid = contactid;
    [self pushNewViewController:settingVC];
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
- (void)eventOccurred:(NSString *)eventName event:(Event *)event{
    [super eventOccurred:eventName event:event];
    /* 收到消息，添加到消息顶部 */
    if([eventName isEqualToString:EventBus_Chat_RecvNewMsg]) {
        DDLogVerbose(@"收到新消息----personremind");
        if(self.isViewLoaded && self.view.window){
            DDLogVerbose(@"收到新消息----personremind--提醒");
            [self refreshUnreadCount];
            dispatch_async(self.chatQueue, ^{
                NSMutableArray *dataArray  = (NSMutableArray *)[event eventData];
                
                /* 接收到的消息ID数组 */
                NSMutableArray *msgids = [[NSMutableArray alloc] init];
                for(int i=0;i<dataArray.count;i++) {
                    ImChatLogModel *imChatLogModel = [dataArray objectAtIndex:i];
                    
                    NSString *msgid = [self didReceiveMessage:imChatLogModel];
                    if(![NSString isNullOrEmpty:msgid] && ![imChatLogModel.handlertype hasPrefix:Handler_Message_LZChat_SR]){
                        [msgids addObject:msgid];
                    }
                }
                
                if (msgids.count >0) {
                    /* 发送消息回执 */
                    NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
                    [getData setObject:@"2" forKey:@"type"];
                    [getData setObject:[NSString stringWithFormat:@"%ld",(long)otherNoReadCount] forKey:@"badge"];
                    [self.appDelegate.lzservice sendToServerForPost:WebApi_Message routePath:WebApi_Message_Report moduleServer:Modules_Message getData:getData postData:msgids otherData:@{WebApi_DataSend_Other_ShowError:WebApi_DataSend_Other_SE_NotShowAll}];
                }
            });
        } else  {
            isReceiveNewMsgWhenNextPage = YES;
            DDLogVerbose(@"收到新消息----personremind--不提醒");
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
            NSMutableArray *resultArray = [personRemindViewModel getMessageDataSource:self.dialogid startCount:0 queryCount:pages * DEFAULT_CHAT_PAGECOUNT];
            //self.existsMoreDateForLoading = resultArray.count >= pages * DEFAULT_CHAT_PAGECOUNT ? YES : NO;
            if(resultArray.count >= DEFAULT_CHAT_PAGECOUNT){
                XHMessage *lastMessage = [resultArray objectAtIndex:0];
                self.loadingMorePersonRemindDate = [[[ImChatLogDAL alloc] init] checkIsEarlierMsgWithDialogID:self.dialogid datetime:lastMessage.imChatLogModel.showindexdate msgid:lastMessage.imChatLogModel.msgid];
            } else {
                self.loadingMorePersonRemindDate = NO;
            }
            
            self.messages = resultArray;
            [self.messageTableView reloadData];
        } else {
            /* 下载完成之后，就将变量置空，不然会多次下载 */
            firstMsgid = nil;
            NSMutableArray *resultArray = [personRemindViewModel getMessageDataSource:self.dialogid
                                                                startCount:self.messages.count
                                                                queryCount:DEFAULT_CHAT_PAGECOUNT];
            /* 继续下载后的消息数量大于0 */
            if (resultArray.count > 0) {
                if(resultArray.count >= DEFAULT_CHAT_PAGECOUNT){
                    XHMessage *lastMessage = [resultArray objectAtIndex:0];
                    self.loadingMorePersonRemindDate = [[[ImChatLogDAL alloc] init] checkIsEarlierMsgWithDialogID:self.dialogid datetime:lastMessage.imChatLogModel.showindexdate msgid:lastMessage.imChatLogModel.msgid];
                } else {
                    self.loadingMorePersonRemindDate = NO;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self insertOldPersonRemindMessages:resultArray];
                    //            weakSelf.loadingMoreMessage = NO;
                });
            }
        }
        
        /* 发送消息回执 */
        [personRemindViewModel sendReportToServer:_dialogid];
    } else if( [eventName isEqualToString:EventBus_Chat_UpdateMsgStatus] ){
        ImChatLogModel *chatLogModel = [event eventData];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            int theIndex = -1;
            for (int i=0;i<[self.messages count];i++) {
                XHMessage *xhMessage = [self.messages objectAtIndex:i];
                NSString *xhMessageMsgid = xhMessage.imChatLogModel.msgid;
                NSString *xhMessageClientTempID = xhMessage.imChatLogModel.clienttempid;
                if([xhMessageMsgid isEqualToString:chatLogModel.msgid]
                   || (![NSString isNullOrEmpty:chatLogModel.clienttempid] && [xhMessageClientTempID isEqualToString:chatLogModel.clienttempid] ) ){
                    theIndex = i;
                    
                    xhMessage.imChatLogModel = chatLogModel;
                }
            }
            if(theIndex!=-1){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(self.isViewLoaded && self.view.window){
        //                        [self.messageTableView reloadData];
                        NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:theIndex inSection:0];
                        [self.messageTableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                    } else {
                        isReceiveUpdateMsgWhenNextPage = YES;
                    }
                    
                });
            }
        });
    }
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
        XHMessage *xhMessage = [personRemindViewModel addNewXHMessageWithImChatLogModel:imChatLogModel messages:self.messages];
        [self addMessageToPersonRemind:xhMessage isSend:NO callBack:nil];
        return imChatLogModel.msgid;
    } else {
        return nil;
    }
}

#pragma mark - 上拉加载更多时的处理

- (void)loadMoreMessagesScrollToBottom {
    //    if (!self.loadingMoreMessage) {
    //        self.loadingMoreMessage = YES;
    //
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *resultArray = [personRemindViewModel getMessageDataSource:weakSelf.dialogid
                                                            startCount:self.messages.count
                                                            queryCount:DEFAULT_CHAT_PAGECOUNT];
        //weakSelf.existsMoreDateForLoading = resultArray.count >= DEFAULT_CHAT_PAGECOUNT ? YES : NO;
        if(resultArray.count >= DEFAULT_CHAT_PAGECOUNT){
            XHMessage *lastMessage = [resultArray objectAtIndex:0];
            weakSelf.loadingMorePersonRemindDate = [[[ImChatLogDAL alloc] init] checkIsEarlierMsgWithDialogID:weakSelf.dialogid datetime:lastMessage.imChatLogModel.showindexdate msgid:lastMessage.imChatLogModel.msgid];
        } else {
            weakSelf.loadingMorePersonRemindDate = NO;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf insertOldPersonRemindMessages:resultArray];
//            weakSelf.loadingMoreMessage = NO;
        });
    });
    //    }
}

- (BOOL)shouldLoadMoreMessagesScrollToBottom {
    if (self.loadingMorePersonRemindDate) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Cell点击后事件处理
/**
 *  Cell点击后事件处理
 *
 *  @param message              消息
 *  @param indexPath            序号
 *  @param messageTableViewCell cell
 */
- (void)multiMediaMessageDidSelectedOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaCustomMsg:{
            [messageTableViewCell.messageBubbleView.lzCustomBubbleView clickCustomBubbleViewAction:message controller:self];
            break;
        }
        default:
            break;
    }
}

@end
