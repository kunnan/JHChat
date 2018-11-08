//
//  WavConverterMP3.m
//  LeadingCloud
//
//  Created by dfl on 17/2/23.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "WavConverterMP3.h"
#import "FilePathUtil.h"
#import <AVFoundation/AVFoundation.h>
#import "LZFormat.h"
#import "LCProgressHUD.h"

@implementation WavConverterMP3


/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(WavConverterMP3 *)shareInstance{
    static WavConverterMP3 *instance = nil;
    if (instance == nil) {
        instance = [[WavConverterMP3 alloc] init];
    }
    return instance;
}

/* wav转MP3 */
- (NSString *)audio_PCMtoMP3:(NSString *)filePath{
    
    NSString *mp3FileName = [filePath lastPathComponent];
    mp3FileName = [mp3FileName stringByReplacingOccurrencesOfString:@".wav" withString:@".mp3"];
    NSString *mp3FilePath = [[FilePathUtil getAudioDicAbsolutePath] stringByAppendingPathComponent:mp3FileName];
    @try {
        int read, write;
        
        FILE *pcm = fopen([filePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
//        lame_t lame = lame_init();
//        lame_set_in_samplerate(lame, 11025.0);
////        lame_set_in_samplerate(lame, 8000.0);
//        lame_set_VBR(lame, vbr_default);
//        lame_init_params(lame);
        
        lame_t lame  = lame_init ();
        
        lame_set_num_channels (lame, 1 ); // 设置 1 为单通道，默认为 2 双通道
        
        lame_set_in_samplerate (lame, 11025.0 ); //11025.0取频  采样
        
        //lame_set_VBR(lame, vbr_default);
        
        lame_set_brate (lame, 8 );
        
        lame_set_mode (lame, 3 );
        
        lame_set_quality (lame, 2 ); /* 2=high 5 = medium 7=low 音 质 */
        
        lame_init_params (lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:filePath] error:nil]; // 生成文件移除原文件
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *toPath = [NSString stringWithFormat:@"%@新录音_%@.mp3",[FilePathUtil getAudioDicAbsolutePath],[LZFormat FormatNow2String]];
        
        //延迟加载
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [fileManager moveItemAtPath:mp3FilePath toPath:toPath error:nil];
//        });
        
        NSLog(@"MP3生成成功: %@",toPath);
        [LCProgressHUD hide];
        return toPath;
        
    }
    
}



@end
