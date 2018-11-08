//
//  LZSocialManager.m
//  LeadingCloud
//
//  Created by wang on 2017/10/12.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "LZSocialManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "XHHTTPClient.h"


@interface LZSocialManager()<TencentSessionDelegate,WXApiDelegate,WeiboSDKDelegate>{
	
	TencentOAuth *_tencentOAuth;
	LZLoginSucessInfo completionData;
	LZSocialFail failData;
	
	NSString *url;

}
@end

@implementation LZSocialManager

+(LZSocialManager*)defaultManager{
	static LZSocialManager *instance = nil;
	if (instance == nil) {
		instance = [[LZSocialManager alloc] init];
	}
	return instance;
}

- (void)openOtherLoginType:(SocialType)type URI:(NSString*)_url CompletionSucess:(LZLoginSucessInfo)completion fail:(LZSocialFail)fail{
	
	if (type ==SocialTypeQQ) {
		
		[self openQQLogin];
		
	}else if (type ==SocialTypeWeChat){
		
		[self openWeChatLogin];
		
	}else if (type ==SocialTypeWeiBo){
		url = _url;
		[self openWeiboLogin];
		
	}
	completionData = completion;
	failData = fail;
}


//qq 登录
- (void)openQQLogin{
	
	//要用block 😯
	_tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAppid andDelegate:self];

	NSArray *_permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,kOPEN_PERMISSION_GET_USER_INFO, nil];
	[_tencentOAuth authorize:_permissions inSafari:NO];
	
}

//是否安装qq
- (BOOL)isInstallQQ{
	
	return [TencentOAuth iphoneQQInstalled];
}

- (BOOL)isInstallWeChat{
	
	return [WXApi isWXAppInstalled];
	
}

- (BOOL)isInstallWeibo{
    
    return [WeiboSDK isWeiboAppInstalled];
    
}


/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
	
	if (_tencentOAuth.accessToken) {
		
		completionData(_tencentOAuth.openId,_tencentOAuth.accessToken);
		//获取用户信息。 调用这个方法后，qq的sdk会自动调用
		//- (void)getUserInfoResponse:(APIResponse*) response
		//这个方法就是 用户信息的回调方法。 QQ登录集成
		
		//[_tencentOAuth getUserInfo];
	}else{
		
		NSLog(@"accessToken 没有获取成功");
	}

}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
	
	
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
	
}
/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response{
	NSLog(@" response %@",response.jsonResponse);
	NSDictionary *dic = response.jsonResponse;
	
	//头像
//    NSString *bigface = [dic objectForKey:@"figureurl_qq_2"];
//    NSString *smialface = [dic objectForKey:@"figureurl_qq_1"];
	//性别
	NSString *gender = [dic objectForKey:@"gender"];
	//昵称
	NSString *nickname = [dic objectForKey:@"nickname"];
	
	NSString *openid = [_tencentOAuth openId];
//    NSString *accessToken = [_tencentOAuth accessToken];
	NSDate *expirationDate = [_tencentOAuth expirationDate];
	
//    NSDictionary *passData = [_tencentOAuth passData];
	
	
	NSString *showString = [NSString stringWithFormat:@"用户名:%@\n性别:%@\nuid:%@\n过期时间:%@",nickname,gender,openid,expirationDate];
	
	
	UIAlertView * desView = [[UIAlertView alloc]initWithTitle:@"提示" message:showString delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
	[desView show];
	
//	if (completionData) {
//		completionData(response.jsonResponse,response.errorMsg);
//	}
}


//微信登录 （整理时应该三合一😯）
- (void)openWeChatLogin{
	
	SendAuthReq *req = [[SendAuthReq alloc]init];
	req.scope = @"snsapi_userinfo";
	req.state = @"wechat";
	[WXApi sendReq:req];
	
}

- (void)registerWeChat{
	
	[WXApi registerApp:WeChatAppid];
	[WeiboSDK enableDebugMode:YES];
	[WeiboSDK registerApp:WeiBoAppid];
	

}

#pragma mark 微信登录回调。
-(void)loginSuccessByCode:(NSString *)code{
	NSLog(@"code %@",code);
	completionData(code,nil);

	return;
//    //__weak typeof(*&self) weakSelf = self;
//    NSString *url = [[NSString alloc] initWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeChatAppid,WeChatAppSecret,code];
//    [XHHTTPClient GETPath:url jsonSuccessHandler:^(LZURLConnection *connection, id json) {
//                        /*
//                 access_token   接口调用凭证
//                 expires_in access_token接口调用凭证超时时间，单位（秒）
//                 refresh_token  用户刷新access_token
//                 openid 授权用户唯一标识
//                 scope  用户授权的作用域，使用逗号（,）分隔
//                 unionid     当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段
//                 */
//                NSString* accessToken=[json valueForKey:@"access_token"];
//                NSString* openID=[json valueForKey:@"openid"];
//        
//                completionData(openID,accessToken);
//
//            //    [weakSelf requestUserInfoByToken:accessToken andOpenid:openID];
//        
//    } failureHandler:^(LZURLConnection *connection, NSData *responseData, NSURLResponse *response, NSError *error) {
//    
//    }];

}

-(void)requestUserInfoByToken:(NSString *)token andOpenid:(NSString *)openID{
	
	NSString *url = [[NSString alloc] initWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openID];
	[XHHTTPClient GETPath:url jsonSuccessHandler:^(LZURLConnection *connection, id json) {
//
//		NSString *nickname = [json valueForKey:@"nickname"];
//		NSString *headimgurl = [json valueForKey:@"headimgurl"];
//		NSString *unionid = [json valueForKey:@"unionid"];
//		NSString *openid = [json valueForKey:@"openid"];

	} failureHandler:^(LZURLConnection *connection, NSData *responseData, NSURLResponse *response, NSError *error) {
		
	}];
	
}

- (void)onResp:(BaseResp *)resp {
	
	if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
		if (resp.errCode == 0) {  //成功。
			//这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
				SendAuthResp *resp2 = (SendAuthResp *)resp;
				[self loginSuccessByCode:resp2.code];
		}else{ //失败
			
			failData(resp,@"登录失败");
			
		}
	}
	
}

//微博登录 （整理时应该三合一😯）
- (void)openWeiboLogin{
	
	WBAuthorizeRequest *request = [WBAuthorizeRequest request];
	request.redirectURI = url;
	request.scope = @"all";
	request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
						 @"Other_Info_1": [NSNumber numberWithInt:123],
						 @"Other_Info_2": @[@"obj1", @"obj2"],
						 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
	[WeiboSDK sendRequest:request];

}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
	
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
	if ([response isKindOfClass:WBAuthorizeResponse.class])
	{

        if([(WBAuthorizeResponse *)response accessToken]){		
            completionData([(WBAuthorizeResponse *)response userID],[(WBAuthorizeResponse *)response accessToken]);
        }
		
//		NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//														message:message
//													   delegate:nil
//											  cancelButtonTitle:NSLocalizedString(@"确定", nil)
//											  otherButtonTitles:nil];
		
//		self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
//		self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
//		self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
	//	[alert show];
	}
}


- (BOOL)HandleOpenURL:(NSURL *)url Type:(SocialType)type {
	if (type ==  SocialTypeQQ) {
		return [TencentOAuth HandleOpenURL:url];
	}
	else if (type == SocialTypeWeChat){
		return [WXApi handleOpenURL:url delegate:self];
	}
	else if (type ==SocialTypeWeiBo){
		return [WeiboSDK handleOpenURL:url delegate:self];
	}
	return YES;
	//要区分微信和其他的😯
}

@end
