//
//  ChatLogCombineTableViewCell.m
//  LeadingCloud
//
//  Created by gjh on 2018/4/20.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import "ChatLogCombineTableViewCell.h"
#import "CommonFontModel.h"
#import "XHMessageModel.h"
#import "XHConfigurationHelper.h"
#import "NSString+IsNullOrEmpty.h"
#import "LZColorUtils.h"
#import "UIButton+Icon.h"
#import "UIView+XHRemoteImage.h"
#import "AppDateUtil.h"

@interface ChatLogCombineTableViewCell() {
    CGFloat curRatio;
}

@property (nonatomic, weak, readwrite) UIButton *avatarImage;
@property (nonatomic, weak, readwrite) UILabel *nameLabel;
@property (nonatomic, weak, readwrite) UILabel *timeLabel;
@property (nonatomic, weak, readwrite) ChatLogMsgBubbleView *combineMessageBubbleView;
@end

@implementation ChatLogCombineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setup];
}
#pragma mark - Life cycle

- (void)setup {
    self.opaque = YES;
    curRatio = [[CommonFontModel shareInstance]getHandeHeightRatio];    
}
/**
 初始化 cell
 */
- (instancetype)initWithMessage:(NSMutableDictionary *)message
                reuseIdentifier:(NSString *)cellIdentifier
                   messageModel:(id<XHMessageModel>)messageModel
                    contactType:(NSInteger)contactType {
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if (self) {        
        // 1、是否显示Time Line的label
        if (!_timeLabel) {
            UILabel *timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(LZ_SCREEN_WIDTH-80, kXHAvatarPaddingY, 70, 20.0f)];
            timestampLabel.textColor = [UIColor grayColor];
            timestampLabel.font = [UIFont systemFontOfSize:10.0f];
            timestampLabel.textAlignment = NSTextAlignmentRight;
//            timestampLabel.text = @"09:38";
            [self.contentView addSubview:timestampLabel];
            [self.contentView bringSubviewToFront:timestampLabel];
            _timeLabel = timestampLabel;
        }
        
        // 2、配置头像
        if (!_avatarImage) {
            CGRect avatarButtonFrame = CGRectMake(XH_AvatarPaddingX,
                                                  kXHAvatarPaddingY,
                                                  XH_AvatarImageSize,
                                                  XH_AvatarImageSize);
            
            UIButton *avatarImage = [[UIButton alloc] initWithFrame:avatarButtonFrame];
            [avatarImage setImage:[self getAvatarPlaceholderImage] forState:UIControlStateNormal];
            [self.contentView addSubview:avatarImage];
            self.avatarImage = avatarImage;
        }
        
        if (!_nameLabel) {
            // 3、配置用户名
            UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImage.width + XH_AvatarPaddingX*2, 12, LZ_SCREEN_WIDTH/2, XH_UserNameLabelHeight)];
            userNameLabel.textAlignment = NSTextAlignmentLeft;
            //            userNameLabel.backgroundColor = [UIColor clearColor];
            userNameLabel.font = [UIFont systemFontOfSize:12*curRatio];
            userNameLabel.textColor = UIColorWithRGB(125, 125, 125);
            userNameLabel.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:userNameLabel];
            _nameLabel = userNameLabel;
        }
        
        // 4、配置需要显示什么消息内容，比如语音、文字、视频、图片
        if (!_combineMessageBubbleView) {
            ChatLogMsgBubbleView *chatLogMsgBubbleView = [[ChatLogMsgBubbleView alloc] initWithFrame:CGRectZero message:message messageModel:messageModel contactType:contactType];
            [self.contentView addSubview:chatLogMsgBubbleView];
            [self.contentView sendSubviewToBack:chatLogMsgBubbleView];
            _combineMessageBubbleView = chatLogMsgBubbleView;
        }
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 得到默认头像
 */
- (UIImage *)getAvatarPlaceholderImage {
    NSString *avatarPalceholderImageName = [[XHConfigurationHelper appearance].messageTableStyle objectForKey:kXHMessageTableAvatarPalceholderImageNameKey];
    if (!avatarPalceholderImageName) {
        avatarPalceholderImageName = @"msg_user_default";
    }
    
    return [UIImage imageNamed:avatarPalceholderImageName];
}

/**
 配置 cell 内容
 */
- (void)configureCellWithMessage:(NSMutableDictionary *)message Premsg:(NSMutableDictionary *)Premsg messageModel:(id<XHMessageModel>)messageModel{
    
//    self.message = message;
    
    // 1、显示时间
    [self configCombineTimeLabel:message];
    
    // 2、配置头像
    [self configCombineAvatarWithMessage:message Premsg:Premsg];
    
    // 3、配置用户名
    [self configCombineUserNameWithMessage:message];
    
    // 4、配置需要显示什么消息内容，比如语音、文字、视频、图片
    [self configureMessageBubbleViewWithMessage:message messageModel:messageModel];
    
}
// 1、显示时间
- (void)configCombineTimeLabel:(NSMutableDictionary *)message {
    NSDate *timestamp = [LZFormat String2Date:[message lzNSStringForKey:@"senddatetime"]];
    self.timeLabel.text = [AppDateUtil getSystemShowTime:timestamp isShowMS:YES];
}
// 2、配置头像
- (void)configCombineAvatarWithMessage:(NSMutableDictionary *)message Premsg:(NSMutableDictionary *)Premsg{
    NSString *prefaceID = [Premsg lzNSStringForKey:@"senduserface"];
    NSString *faceID = [message lzNSStringForKey:@"senduserface"];
    
    if ([prefaceID isEqualToString:faceID]) {
        self.avatarImage.hidden = YES;
    } else {
        self.avatarImage.hidden = NO;
    }
    self.avatarImage.backgroundColor = [UIColor clearColor];
    self.avatarImage.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    // faceID不为空就会显示成员头像
    if (![NSString isNullOrEmpty:faceID]){
        [self configAvatarWithFaceId:faceID];
    } else {
        self.avatarImage.backgroundColor = [LZColorUtils getAppColorKey:@"color-1"];
        [self.avatarImage setImage:[UIImage imageNamed:@"app_icon_default"] forState:UIControlStateNormal];
        self.avatarImage.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    }
}
#pragma mark - 加载头像

/**
 *  根据FaceId加载头像
 *
 *  @param faceid 头像Id
 */
- (void)configAvatarWithFaceId:(NSString *)faceid {    
    [self.avatarImage loadFaceIcon:faceid isChangeToCircle:NO placeHolder:@"msg_user_default"];
}
- (void)configAvatarWithPhoto:(UIImage *)photo {
    [self.avatarImage setImage:photo forState:UIControlStateNormal];
}
- (void)configAvatarWithPhotoURLString:(NSString *)photoURLString {
    BOOL customLoadAvatarNetworkImage = [[[XHConfigurationHelper appearance].messageTableStyle objectForKey:kXHMessageTableCustomLoadAvatarNetworImageKey] boolValue];
    if (!customLoadAvatarNetworkImage) {
        XHMessageAvatarType avatarType = [[[XHConfigurationHelper appearance].messageTableStyle objectForKey:kXHMessageTableAvatarTypeKey] integerValue];
        self.avatarImage.messageAvatarType = avatarType;
        [self.avatarImage setImageWithURL:[NSURL URLWithString:photoURLString] placeholer:[self getAvatarPlaceholderImage]];
    }
}
// 3、配置用户名
- (void)configCombineUserNameWithMessage:(NSMutableDictionary *)message {
    self.nameLabel.text = [message lzNSStringForKey:@"sendusername"];
}
// 4、配置消息
- (void)configureMessageBubbleViewWithMessage:(NSMutableDictionary *)message messageModel:(id<XHMessageModel>)messageModel{
    
    XHBubbleMessageMediaType currentMediaType = messageModel.messageMediaType;
//    NSString *handlertype = [message lzNSStringForKey:@"handlertype"];
    
    for (UIGestureRecognizer *gesTureRecognizer in self.combineMessageBubbleView.bubblePhotoImageView.gestureRecognizers) {
        [self.combineMessageBubbleView.bubblePhotoImageView removeGestureRecognizer:gesTureRecognizer];
    }

    switch (currentMediaType) {
        case XHBubbleMessageMediaTypePhoto:{
            /* 设置cell代理 */
            self.combineMessageBubbleView.celldelegate = _delegate;
            self.combineMessageBubbleView.indexPath = _indexPath;
            
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapGestureRecognizerHandle:)];
            [self.combineMessageBubbleView.bubblePhotoImageView addGestureRecognizer:tapGestureRecognizer];
            break;
        }
        case XHBubbleMessageMediaTypeFile:
        case XHBubbleMessageMediaTypeLocalPosition:
        case XHBubbleMessageMediaTypeVideo:{
            /* 设置cell代理 */
            self.combineMessageBubbleView.celldelegate = _delegate;
            self.combineMessageBubbleView.indexPath = _indexPath;
            
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapGestureRecognizerHandle:)];
            [self.combineMessageBubbleView.bubbleView addGestureRecognizer:tapGestureRecognizer];
            break;
        }
        case XHBubbleMessageMediaTypeUrl:{
            /* 设置cell代理 */
            self.combineMessageBubbleView.celldelegate = _delegate;
            self.combineMessageBubbleView.indexPath = _indexPath;
            
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapGestureRecognizerHandle:)];
            [self.combineMessageBubbleView.lzUrlView addGestureRecognizer:tapGestureRecognizer];
            break;
        }
        case XHBubbleMessageMediaTypeChatLog:{
            /* 设置cell代理 */
            self.combineMessageBubbleView.celldelegate = _delegate;
            self.combineMessageBubbleView.indexPath = _indexPath;
            
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapGestureRecognizerHandle:)];
            [self.combineMessageBubbleView.chatlogView addGestureRecognizer:tapGestureRecognizer];
            break;
        }
        case XHBubbleMessageMediaTypeText: {
            /* HBCoreText 中点击链接使用的也是UITapGestureRecognizer,会造成这里的无法响应，因此使用HBCoreText中的delegate实现点击方法 */
            self.combineMessageBubbleView.celldelegate = _delegate;
            self.combineMessageBubbleView.indexPath = _indexPath;
            
//            UITapGestureRecognizer *doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognizerHandle:)];
//            doubleRecognizer.numberOfTapsRequired = 2;
//            [self.combineMessageBubbleView.lzNewDisplayTextView addGestureRecognizer:doubleRecognizer];
//            
//            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapGestureRecognizerHandle:)];
//            [self.combineMessageBubbleView.lzNewDisplayTextView addGestureRecognizer:tapGestureRecognizer];
//            
//            [tapGestureRecognizer requireGestureRecognizerToFail:doubleRecognizer];
            break;
        }
        case XHBubbleMessageMediaCustomMsg:{
            self.combineMessageBubbleView.celldelegate = _delegate;
            
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapGestureRecognizerHandle:)];
            [self.combineMessageBubbleView.lzCustomBubbleView addGestureRecognizer:tapGestureRecognizer];
            break;
        }
        default:
            break;
    }
    
    
    [self.combineMessageBubbleView configureCellWithCombineMessage:message messageModel:messageModel];
}
- (void)layoutSubviews {
    [super layoutSubviews];

    // 布局消息内容的View
    CGFloat bubbleX = 0.0f;
    CGFloat offsetX = 0.0f;
    bubbleX = XH_AvatarImageSize + XH_AvatarPaddingX * 2;

    CGRect bubbleMessageViewFrame = CGRectMake(bubbleX,
                                               0,
                                               CGRectGetWidth(self.contentView.bounds) - bubbleX - offsetX,
                                               CGRectGetHeight(self.contentView.bounds));
    
    _combineMessageBubbleView.frame = bubbleMessageViewFrame;
}


- (void)sigleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self setupNormalMenuController];
        if ([self.delegate respondsToSelector:@selector(multiMediaCombineMessageDidSelectedOnMessage:atIndexPath:onMessageTableViewCell:)]) {
            [self.delegate multiMediaCombineMessageDidSelectedOnMessage:self.combineMessageBubbleView.messageModel atIndexPath:self.indexPath onMessageTableViewCell:self];
        }
    }
}

- (void)doubleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(didDoubleSelectedOnTextMessage:atIndexPath:)]) {
            [self.delegate didDoubleSelectedOnTextMessage:self.combineMessageBubbleView.messageModel atIndexPath:self.indexPath];
        }
    }
}

-(void)tabGestureHandle{
    if ([self.delegate respondsToSelector:@selector(tapGestureForHideInputView)]) {
        [self.delegate tapGestureForHideInputView];
    }
}

#pragma mark - Gestures

- (void)setupNormalMenuController {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
}

- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self updateMenuControllerVisiable];
}

- (void)updateMenuControllerVisiable {
    [self setupNormalMenuController];
}
@end
