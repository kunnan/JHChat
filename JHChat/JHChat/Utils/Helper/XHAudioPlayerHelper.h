//
//  XHAudioPlayerHelper.h
//  MessageDisplayKit
//
//  Created by Aevitx on 14-1-22.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "XHMacro.h"

@protocol XHAudioPlayerHelperDelegate <NSObject>

@optional
- (void)didAudioPlayerBeginPlay:(AVAudioPlayer*)audioPlayer;
- (void)didAudioPlayerStopPlay:(AVAudioPlayer*)audioPlayer;
- (void)didAudioPlayerPausePlay:(AVAudioPlayer*)audioPlayer;
- (void)didAudioPlayerSuccessFinishPlay:(AVAudioPlayer*)audioPlayer;

@end

@interface XHAudioPlayerHelper : NSObject <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, copy) NSString *playingFileName;

@property (nonatomic, assign) id <XHAudioPlayerHelperDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *playingIndexPathInFeedList;//给动态列表用

@property (nonatomic, assign) id otherInfo;
@property (nonatomic, assign) id playingInfo;

+ (id)shareInstance;

- (AVAudioPlayer*)player;
- (BOOL)isPlaying;

- (void)managerAudioWithFileName:(NSString*)amrName toPlay:(BOOL)toPlay;
- (void)pausePlayingAudio;//暂停
- (void)stopAudio;//停止

#pragma mark - 近距离传感器

- (void)changeProximityMonitorEnableState:(BOOL)enable;

@end


