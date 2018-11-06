//
//  ChatLogCombineViewController.h
//  LeadingCloud
//
//  Created by gjh on 2018/4/18.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  gjh
 Date：   2018-04-18
 Version: 1.0
 Description: 合并转发聊天消息展示界面
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import "XHMessageTableViewController.h"
#import "ChatLogCombineTableViewCell.h"
#import "ChatViewModel.h"
#import "PhotoBrowserViewController.h"
#import "ImGroupModel.h"

@protocol ChatLogCombineViewControllerDataSource <NSObject>

@required

- (NSMutableDictionary *)transmitMessageForRowAtIndexPath:(NSIndexPath *)indexPath;

- (id <XHMessageModel>)transmitMessageModelForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol ChatLogCombineViewControllerDelegate <NSObject>

@required


@end

@interface ChatLogCombineViewController : XHBaseViewController<UITableViewDataSource, UITableViewDelegate, ChatLogCombineViewControllerDataSource, ChatLogCombineViewControllerDelegate,MWPhotoBrowserDelegate,XHMessageTableViewCellDelegate,UIActionSheetDelegate>

/**
 *  数据源，显示多少消息
 */
@property (nonatomic, strong) NSMutableArray *messages;

@property (nonatomic, weak) id<ChatLogCombineViewControllerDataSource> transmitDataSource;

@property (nonatomic, weak) id<ChatLogCombineViewControllerDelegate> transmitDelegate;

/**
 *  用于显示消息的TableView
 */
@property (nonatomic, weak, readonly) XHMessageTableView *messageTableView;

@property (nonatomic, strong) ChatViewModel *chatViewModel;

/* 群聊时，群ImGroupModel */
@property (nonatomic, strong) ImGroupModel *toGroupModel;

@property (nonatomic, assign) NSInteger contactType;  //聊天框类型

@end
