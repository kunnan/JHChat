//
//  LZGlobalVariable.m
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

#import "LZGlobalVariable.h"
#import "ImRecentDAL.h"
#import "NSObject+JsonSerial.h"
@implementation LZGlobalVariable

/**
 *  获取展现在当前页面的ViewController
 *
 *  @return 当前ViewController
 */
- (UIViewController *)getCurrentViewController
{
    UIViewController *result = nil;
    
    if(self.currentNavigationController.viewControllers.count>=1){
        result = [self.currentNavigationController.viewControllers objectAtIndex:self.currentNavigationController.viewControllers.count-1];
    }
    return result;
}

- (void)setChatDialogID:(NSString *)chatDialogID {
    _chatDialogID = chatDialogID;
}

- (void)setMsgCallStatus:(MsgCallStatus)msgCallStatus {
    _msgCallStatus = msgCallStatus;
}

- (void)setPcLoginInStatus:(PCLoginInStatus)pcLoginInStatus {
    _pcLoginInStatus = pcLoginInStatus;
}
/**
 *  是否需要刷新消息页签
 */
-(void)setIsNeedRefreshMessageRootVC:(BOOL)isNeedRefreshMessageRootVC{
    _isNeedRefreshMessageRootVC = isNeedRefreshMessageRootVC;
 
    if(isNeedRefreshMessageRootVC){
        dispatch_async(dispatch_get_main_queue(), ^{
            __block LZGlobalVariable * service = self;
            NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
            [dataDic setValue:_chatDialogID forKey:@"dialogid"];
            [dataDic setValue:@"" forKey:@"unreadcount"];
            EVENT_PUBLISH_WITHDATA(service, EventBus_SendDataToWebView,dataDic);
        });
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 若当前消息页面展现着，则刷新 */
            __block LZGlobalVariable * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RefreshMessageRootVC, nil);
            
            /* 刷新TabBar上的数字 */
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MainViewController_RefreshBadge object:nil];
        });
    }
}
/* 刷新headerView */
- (void)setIsNeedRefreshMessageRootHeaderView:(BOOL)isNeedRefreshMessageRootHeaderView {
    _isNeedRefreshMessageRootHeaderView = isNeedRefreshMessageRootHeaderView;
    
    if (isNeedRefreshMessageRootHeaderView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __block LZGlobalVariable * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RefreshMessageRootHeaderView, nil);
        });
    }
}
/**
 *  是否需要刷新消息页签(不向ChatViewController中发送EventBus)
 */
-(void)setIsNeedRefreshMessageRootForChatVC:(BOOL)isNeedRefreshMessageRootVC{
    _isNeedRefreshMessageRootVC = isNeedRefreshMessageRootVC;

    if(isNeedRefreshMessageRootVC){
        dispatch_async(dispatch_get_main_queue(), ^{
            __block LZGlobalVariable * service = self;
            NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
            [dataDic setValue:_chatDialogID forKey:@"dialogid"];
            [dataDic setValue:@"" forKey:@"unreadcount"];
            EVENT_PUBLISH_WITHDATA(service, EventBus_SendDataToWebView,dataDic);
        });
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 刷新TabBar上的数字 */
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MainViewController_RefreshBadge object:nil];
        });
    }
}
/* 是否有持久通知需要刷新消息页签 */
- (void)setIsNeedRefreshMessageRootForPermanentNotice:(BOOL)isNeedRefreshMessageRootForPermanentNotice {
    _isNeedRefreshMessageRootForPermanentNotice = isNeedRefreshMessageRootForPermanentNotice;
}
/**
 *  是否需要刷新联系人页签
 */
-(void)setIsNeedRefreshContactRootVC2:(BOOL)isNeedRefreshContactRootVC2{
    _isNeedRefreshContactRootVC2 = isNeedRefreshContactRootVC2;
    
    if(isNeedRefreshContactRootVC2){
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 若当前消息页面展现着，则刷新 */
            __block LZGlobalVariable * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Organization_RefreshContactRoot, nil);
        });
    }
}
///**
// *  是否需要刷新二级消息列表
// */
//-(void)setSeconMsgListRefresh:(BOOL)isNeedRefresh secondChatDialogID:(NSString *)secondChatDialogID{
//    _isNeedRefreshSecondMsgListVC = isNeedRefresh;
//
//    if(_isNeedRefreshSecondMsgListVC && [_secondChatDialogID isEqualToString:secondChatDialogID]){
//        /* 在主线程中发送通知 */
//        dispatch_async(dispatch_get_main_queue(), ^{
//            /* 若当前消息页面展现着，则刷新 */
//            __block LZGlobalVariable * service = self;
//            EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_RefreshSecondMsgVC, nil);
//        });
//    }
//}
/**
 *  是否需要刷新协作任务跟视图页签
 */
-(void)setIsNeedReloadCooperationTaskRootVC:(BOOL)isNeedReloadCooperationTaskRootVC {
    _isNeedReloadCooperationTaskRootVC = isNeedReloadCooperationTaskRootVC;
    
}
/**
 *  是否需要刷新云盘回收站视图
 */
-(void)setIsNeedAppNetDiskRecycleVC:(BOOL)isNeedAppNetDiskRecycleVC {
    _isNeedAppNetDiskRecycleVC= isNeedAppNetDiskRecycleVC;
}
/**
 *  是否需要刷新云盘我的文件视图
 */
-(void)setIsNeedRefreshNetDiskVC:(BOOL)isNeedRefreshNetDiskVC {
    _isNeedRefreshNetDiskVC = isNeedRefreshNetDiskVC;
}
    


/**
 *  是否需要刷新我的好友列表
 */
-(void)setIsNeedRefreshContactFriendListVC2:(BOOL)isNeedRefreshContactFriendListVC2{
    _isNeedRefreshContactFriendListVC2 = isNeedRefreshContactFriendListVC2;
    
    if(_isNeedRefreshContactFriendListVC2){
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 若我的好友页面展现着，则刷新 */
            __block LZGlobalVariable * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_RefreshContactFriendList, nil);
        });
    }
}

/**
 *  是否需要刷新好友标签列表
 */
-(void)setIsNeedRefreshContactFriendLabelListViewController2:(BOOL)isNeedRefreshContactFriendLabelListViewController2{
    _isNeedRefreshContactFriendLabelListViewController2 = isNeedRefreshContactFriendLabelListViewController2;
    
    if(_isNeedRefreshContactFriendLabelListViewController2){
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 若标签页面展现着，则刷新 */
            __block LZGlobalVariable * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_UserTag_RefreshContactFriendLabelListVC, nil);
        });
    }
}

/**
 *  是否需要刷新好友信息页面
 */
-(void)setIsNeedRefreshContactFriendInfoViewController:(BOOL)isNeedRefreshContactFriendInfoViewController{
    _isNeedRefreshContactFriendInfoViewController = isNeedRefreshContactFriendInfoViewController;
    
    if(isNeedRefreshContactFriendInfoViewController){
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 若好友信息页面展现着，则刷新 */
            __block LZGlobalVariable * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Colleaguelist_RefreshContactFriendInfoVC, nil);
        });
    }
}

/**
 *  是否需要刷新收藏页面
 */
-(void)setIsNeedRefreshMoreCollectionVC:(BOOL)isNeedRefreshMoreCollectionVC{
    _isNeedRefreshMoreCollectionVC=isNeedRefreshMoreCollectionVC;
    if(isNeedRefreshMoreCollectionVC){
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 若收藏页面展现着，则刷新 */
            __block LZGlobalVariable * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_FavoritesParse_RefreshMoreCollectionVC, nil);
        });
    }
}

-(void)setIsNeedRefreshAppRootVC:(BOOL)isNeedRefreshAppRootVC{
    _isNeedRefreshAppRootVC = isNeedRefreshAppRootVC;
    
    if(isNeedRefreshAppRootVC){
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            /* 若当前消息页面展现着，则刷新 */
            __block LZGlobalVariable * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_App_RefreshAppRootVC, nil);
            
            /* 刷新TabBar上的数字 */
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MainViewController_RefreshAppRemindBadge object:nil];
        });
    }
}

/**
 *  获取解析消息的队列
 */
-(dispatch_queue_t)msgQueue{
    if(_msgQueue==nil){
        _msgQueue = dispatch_queue_create("com.leading.leadingcloud.queue.message", DISPATCH_QUEUE_SERIAL);
    }
    return _msgQueue;
}

@end
