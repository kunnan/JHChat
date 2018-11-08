//
//  LZChatVIewHandle.m
//  OpenVideoCall
//
//  Created by wang on 17/4/13.
//  Copyright © 2017年 Agora. All rights reserved.
//

#import "LZChatViewHandle.h"
#import "LZVideoSession.h"

@implementation LZChatViewHandle

+(LZChatViewHandle *)shareInstance{
    
    static LZChatViewHandle *instance = nil;
    if (instance == nil) {
        instance = [[LZChatViewHandle alloc] init];
    }
    return instance;
}

//视频没错的

- (UIView*)getShowViewFromArray:(NSArray*)sessions Frame:(CGRect)frame{
    
    //后台，显示的也是大视频的
    if (sessions.count<1){
        return  nil;
    }

    LZVideoSession *selfSession = sessions.firstObject;
    selfSession.hostingView.frame = frame;
    if (sessions.count==1) {
        
    }else if (sessions.count==2){
        
        LZVideoSession *secondSession = sessions[1];
        
        //对方是否禁止视频功能
        if (secondSession.isVideoMuted == YES) {
            
        }else{
            secondSession.hostingView.frame = frame;
            return secondSession.hostingView;

        }
    }
    
    return selfSession.hostingView;
}

- (UIView*)getSamleViewFromArray:(NSArray*)sessions Frame:(CGRect)frame{
    
    if (sessions.count<=1){
        return  nil;
    }
    
    
    if (sessions.count==2){
        
        LZVideoSession *secondSession = sessions[1];
        
        //对方是否禁止视频功能
        if (secondSession.isVideoMuted == NO) {
            
        }else{
            return nil;
            
        }
    }
    
    //小窗永远显示自己 没有就删除呗
    LZVideoSession *selfSession = sessions.firstObject;
    selfSession.hostingView.frame = frame;
	
	if (selfSession.isVideoMuted==YES) {
		//自己禁止视频功能nil
		return  nil;
	}
    return selfSession.hostingView;
}

//得到多人聊天
- (UIView*)getMorePeopleViewFromArray:(NSArray*)sessions View:(UIView*)supView{
    
    for (LZVideoSession *session in sessions) {
        
        if (session.isVideoMuted == NO) {
            
            session.hostingView.frame = CGRectMake(0, 0, 0, 0);
            [supView addSubview:session.hostingView];
        }
    }
    
    
    return supView;
    
}

- (BOOL)isShowVoiceViewFromeArray:(NSArray*)sessions{
    
    BOOL isVoice = false;
    
    if(sessions.count==1){
        LZVideoSession *firstSession = sessions[0];
        
        if (firstSession.isVideoMuted) {
            
            return true;
        }
    }
    
    if (sessions.count==2) {
        LZVideoSession *secondSession = sessions[1];

        LZVideoSession *firstSession = sessions[0];

        if (secondSession.isVideoMuted &&firstSession.isVideoMuted) {
            
            return true;
        }
    }
    
    return isVoice;
}


//是否是视频
- (BOOL)isShowVideoViewFromeArray:(NSArray*)sessions{
    
    BOOL isVideo = false;
    
    for (LZVideoSession *session in sessions) {
        
        if (session.isVideoMuted == NO) {
            
            return true;
        }
    }
    
    
    return isVideo;
}
@end
