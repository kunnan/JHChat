//
//  ChatLogCombineTableViewCell.h
//  LeadingCloud
//
//  Created by gjh on 2018/4/20.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseTableViewCell.h"
#import "XHMessageBubbleView.h"
#import "ChatLogMsgBubbleView.h"

static const CGFloat kXHAvatarPaddingY = 15;

@interface ChatLogCombineTableViewCell : XHBaseTableViewCell

/**
 *  目标消息Model对象
 */
@property (nonatomic, strong)  id <XHMessageModel> message;

/**
 *  头像
 */
@property (nonatomic, weak, readonly) UIButton *avatarImage;

/**
 *  名称
 */
@property (nonatomic, weak, readonly) UILabel *nameLabel;

/**
 *  时间
 */
@property (nonatomic, weak, readonly) UILabel *timeLabel;

/**
 消息体
 */
@property (nonatomic, weak, readonly) ChatLogMsgBubbleView *combineMessageBubbleView;

/**
 *  Cell所在的位置，用于Cell delegate回调
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id <XHMessageTableViewCellDelegate> delegate;

/**
 初始化 cell
 */
- (instancetype)initWithMessage:(NSMutableDictionary *)message reuseIdentifier:(NSString *)cellIdentifier messageModel:(id<XHMessageModel>)messageModel contactType:(NSInteger)contactType;

/**
 配置 cell 内容
 */
- (void)configureCellWithMessage:(NSMutableDictionary *)message Premsg:(NSMutableDictionary *)Premsg messageModel:(id<XHMessageModel>)messageModel;

@end
