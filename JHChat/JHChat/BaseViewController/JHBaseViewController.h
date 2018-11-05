//
//  JHBaseViewController.h
//  JHChat
//
//  Created by gjh on 2018/11/5.
//  Copyright © 2018 gjh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCProgressHUD.h"
#import "EventBus.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHBaseViewController : UIViewController<EventSyncSubscriber,EventSyncPublisher>
/* 界面可见时，是否需要刷新数据 */
@property (nonatomic, assign) BOOL isNeedRefreshLZTableViewWhenViewAppear;

@end

NS_ASSUME_NONNULL_END
