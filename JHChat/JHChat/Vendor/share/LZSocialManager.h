//
//  LZSocialManager.h
//  LeadingCloud
//
//  Created by wang on 2017/10/12.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#define QQAppid @"101434378"
#define WeChatAppid @"wx94fb586c7085bad7"
#define WeChatAppSecret @"1d3ce354c3ee6d24751fd6e340ef0543"
#define WeiBoAppid @"871318040"
#define WeiBoRedirectURI @"https://api.weibo.com/oauth2/default.html"

typedef NS_ENUM(NSInteger, SocialType) {
	SocialTypeQQ,
	SocialTypeWeChat,
	SocialTypeWeiBo
};

@interface LZSocialManager : NSObject


typedef void (^LZSocialSucess)(id result, NSString *error);
typedef void (^LZLoginSucessInfo)(NSString *openid, NSString *token);
typedef void (^LZSocialFail)(id result, NSString *error);


+(LZSocialManager*)defaultManager;


- (void)openOtherLoginType:(SocialType)type URI:(NSString*)url CompletionSucess:(LZLoginSucessInfo)completion fail:(LZSocialFail)fail;

//是否安装qq
- (BOOL)isInstallQQ;

- (BOOL)isInstallWeChat;

- (BOOL)isInstallWeibo;


- (void)registerWeChat;


- (BOOL)HandleOpenURL:(NSURL *)url Type:(SocialType)type;


@end
