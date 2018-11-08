//
//  WavConverterMP3.h
//  LeadingCloud
//
//  Created by dfl on 17/2/23.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lame.h"

@interface WavConverterMP3 : NSObject

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(WavConverterMP3 *)shareInstance;

/* wav转MP3 */
- (NSString *)audio_PCMtoMP3:(NSString *)filePath;

@end
