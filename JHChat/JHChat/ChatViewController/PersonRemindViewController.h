//
//  PersonRemindViewController.h
//  LeadingCloud
//
//  Created by gjh on 2017/7/18.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "XHMessageTableViewController.h"

@interface PersonRemindViewController : XHMessageTableViewController

/**
 *  上拉是否可以继续加载
 */
@property (nonatomic, assign) BOOL loadingMorePersonRemindDate;

@property (nonatomic, assign) NSInteger contactType;  //聊天框类型
@property (copy, nonatomic) NSString *dialogid;     //对话框ID

/**
 *  解析消息的串行队列
 */
#if OS_OBJECT_USE_OBJC
@property (strong, nonatomic) dispatch_queue_t chatQueue;
#else
@property (assign, nonatomic) dispatch_queue_t chatQueue;
#endif

/**
 *  页面显示之后加载数据
 */
- (void)loadInitChatLog:(BOOL)isViewDidLoad newBottomMsgs:(NSMutableArray *)newMsgids;
@end
