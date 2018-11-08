//
//  EmotionPlugin.m
//  LeadingCloud
//
//  Created by SY on 2017/6/1.
//  Copyright © 2017年 LeadingSoft. All rights reserved.

#import "EmotionPlugin.h"
#import "LZEmotionManagerView.h"
#import "NSObject+JsonSerial.h"
@interface EmotionPlugin ()<LZEmotionManagerViewDelegate>
{
    LZEmotionManagerView *emotionManagerView;
    NSString *emotionStr;
    NSString *emotionName;
}
@property (nonatomic, strong) JSNCRunParameter *tmpRunParameter;

@end
@implementation EmotionPlugin

-(void)selectEmotion:(JSNCRunParameter *)runParameter {
    
    if(_tmpRunParameter!=nil){
        JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:_tmpRunParameter resultType:JSNCRunResultType_None resultData:nil isFinished:YES];
        [self sendRunResult:runResult];
    }
    _tmpRunParameter=runParameter;
    
    [self executeBlockInMainThread:^(UIViewController * _Nonnull controller) {
        emotionManagerView = [[LZEmotionManagerView alloc] initWithFrame:CGRectMake(0, LZ_SCREEN_HEIGHT, LZ_SCREEN_WIDTH, KeyBoard_PhoneHeight)];
        emotionManagerView.isChangeColor = YES;
        emotionManagerView.sendtitle=LZGDCommonLocailzableString(@"common_finish");
        [emotionManagerView.emotionSendButton setBackgroundColor:[UIColor colorWithRed:53/255.0 green:168/255.0 blue:244/255.0 alpha:1.000]];
        [emotionManagerView.emotionSendButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:1.000] forState:UIControlStateNormal];
        [emotionManagerView reloadEmotins];
        emotionManagerView.delegate = self;
        [controller.view addSubview:emotionManagerView];
        [self showEmotion];
    }];
        
//    NSDictionary *dict=[EmotionUtil getImageNameToDescription];
//    NSArray *array=dict.allValues;
//    NSMutableArray *emotionArray=[NSMutableArray array];
//    for (NSString *str in array) {
//        
//        NSString *str1=[NSString stringWithFormat:@"[/%@]",str];
//        [emotionArray addObject:str1];
//    }

}
// 隐藏
-(void)hiddenEmotion:(JSNCRunParameter *)runParameter {
    
    [self hiddenEmotionView];
}
-(void)showEmotion{
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
    } completion:^(BOOL finished) {
        emotionManagerView.frame=CGRectMake(0, LZ_SCREEN_HEIGHT-KeyBoard_PhoneHeight, LZ_SCREEN_WIDTH, KeyBoard_PhoneHeight);
        
    }];
}
-(void)hiddenEmotionView{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
    } completion:^(BOOL finished) {
        
        emotionManagerView.frame=CGRectMake(0, LZ_SCREEN_HEIGHT, LZ_SCREEN_WIDTH, KeyBoard_PhoneHeight);
    }];

}
#pragma mark - LZEmotionManagerViewDelegate
-(void)didSelecteLZEmotion:(id)sender iconName:(NSString *)iconname emotionText:(NSString *)emotiontext {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:emotiontext forKey:@"emotiontext"];
    [dic setObject:@"emotion" forKey:@"result"];
    NSString *resultStr = [[NSString string] dictionaryToJson:dic];
    JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:self.tmpRunParameter resultType:JSNCRunResultType_Success resultData:resultStr isFinished:NO];
//    _tmpRunParameter=nil;//将临时变量置空
    [self sendRunResult:runResult];
    
}
-(NSString *)didClickLZEmotionDelBtn:(id)sender {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"del" forKey:@"result"];
    NSString *resultStr = [[NSString string] dictionaryToJson:dic];
    JSNCRunResult *runResult=[JSNCRunResult resultWithRunParameter:self.tmpRunParameter resultType:JSNCRunResultType_Success resultData:resultStr isFinished:NO];
//    _tmpRunParameter=nil;//将临时变量置空
    [self sendRunResult:runResult];
    return nil;
}
- (void)didClickLZEmotionDoneBtn:(id)sender{
    
    [self hiddenEmotionView];
}

@end
