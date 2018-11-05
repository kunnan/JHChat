//
//  UIAlertController+AlertWithMessage.m
//  LeadingCloud
//
//  Created by SY on 16/11/21.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "UIAlertController+AlertWithMessage.h"
/**
 UIAlertController拓展方法（ios8及以上）
 */
@implementation UIAlertController (AlertWithMessage)


/**
 直接显示弹窗消息，无回调，无按钮设置等

 @param message    提示消息
 @param controller 哪个控制器要弹框提示
 */
+(void)alertControllerWithMessage:(NSString *)message controller:(UIViewController*)controller{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:okAction];
    
    [controller presentViewController:alertController animated:YES completion:^{
    } ];
    
}

/**
 自定义提示框

 @param title      自定义提示框title
 @param message    要提示的消息
 @param controller 哪个控制器要弹出提示框
 */
+(void)alertControllerWithTitle:(NSString*)title message:(NSString*)message  controller:(UIViewController*)controller{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:sureAction];
    
    [controller presentViewController:alertController animated:YES completion:^{
        
    }];
    
}

+(void)alertControllerPastMessageWithTitle:(NSString*)title message:(NSString*)message  controller:(UIViewController*)controller{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = message;
    }];
    
    [alertController addAction:sureAction];
    
    [controller presentViewController:alertController animated:YES completion:^{
        
    }];
}
/**
 自定义提示框(title  message actiontitle controller)
 
 @param title      自定义提示框title
 @param message    要提示的消息
 actionWithTitle
 @param controller 哪个控制器要弹出提示框
 */
+(void)alertControllerWithTitle:(NSString*)title message:(NSString*)message actionWithTitleArr:(NSArray*)actiontitle  controller:(UIViewController*)controller alertClickBlock:(AlertClickBlock)clickBlock{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIView *messageParentView = [self getParentViewOfTitleAndMessageFromView:alertController.view];
    if (messageParentView && messageParentView.subviews.count > 1) {
        UILabel *messageLb = messageParentView.subviews[1];
        messageLb.textAlignment = NSTextAlignmentLeft;
    }
    for (int i = 0; i < actiontitle.count; i++) {
        
        if ([[actiontitle objectAtIndex:i] isEqualToString:@"取消"]) {
            [self addCancleButon:alertController];
            continue;
        }
        [alertController addAction:[UIAlertAction actionWithTitle:[actiontitle objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            clickBlock(action.title);
        }]];
       

    }
    
    [controller presentViewController:alertController animated:YES completion:^{
        
    }];
    
}
+(void)alertControllerWithCenterTitle:(NSString*)title message:(NSString*)message actionWithTitleArr:(NSArray*)actiontitle  controller:(UIViewController*)controller alertClickBlock:(AlertClickBlock)clickBlock {
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    for (int i = 0; i < actiontitle.count; i++) {
        
        if ([[actiontitle objectAtIndex:i] isEqualToString:@"取消"]) {
            [self addCancleButon:alertController];
            continue;
        }
        [alertController addAction:[UIAlertAction actionWithTitle:[actiontitle objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            clickBlock(action.title);
        }]];
        
        
    }
    
    [controller presentViewController:alertController animated:YES completion:^{
        
    }];
}
+(void)alertBottomAlertControllerWithTitle:(NSString*)title message:(NSString*)message actionWithTitleArr:(NSMutableArray*)actiontitle  controller:(UIViewController*)controller alertClickBlock:(AlertClickBlock)clickBlock{

    if (![actiontitle containsObject:@"取消"]) {
        [actiontitle addObject:@"取消"];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < actiontitle.count; i++) {
        
        if ([[actiontitle objectAtIndex:i] isEqualToString:@"取消"]) {
            [self addCancleButon:alertController];
            continue;
        }
        if ([[actiontitle objectAtIndex:i] isEqualToString:@"删除"]) {
            [self addDelButon:alertController blockClick:clickBlock];
            continue;
        }
        
        [alertController addAction:[UIAlertAction actionWithTitle:[actiontitle objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            clickBlock(action.title);
        }]];
    }
    
    [controller presentViewController:alertController animated:YES completion:^{
        
    }];
}
/**
 添加自定义alertController

 @param title title description
 @param message message description
 @param actiontitle actiontitle description
 @param controller controller description
 @param alertStyle alertStyle 0 1
 @param titleAndStyle value: 0(默认) 1（取消） 2（删除）
 @param clickBlock clickBlock description
 */
+(void)alertControllerWithTitle:(NSString*)title message:(NSString*)message actionWithTitleArr:(NSMutableArray*)actiontitle  controller:(UIViewController*)controller type:(UIAlertControllerStyle)alertStyle titleAndStyleDic:(NSDictionary*)titleAndStyle  alertClickBlock:(AlertClickBlock)clickBlock{
    if (![actiontitle containsObject:@"取消"]) {
        [actiontitle addObject:@"取消"];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:alertStyle];

    for (int i = 0; i < actiontitle.count; i++) {
        
        if ([[actiontitle objectAtIndex:i] isEqualToString:@"取消"]) {
            [self addCancleButon:alertController];
            continue;
        }
        if ([[actiontitle objectAtIndex:i] isEqualToString:@"删除"]) {
            [self addDelButon:alertController blockClick:clickBlock];
            continue;
        }
        // 指定actiontitle的类型并添加action
        if ([titleAndStyle lzNSStringForKey:[actiontitle objectAtIndex:i]]) {
            [self addAction:alertController title:[actiontitle objectAtIndex:i] style:[[titleAndStyle lzNSStringForKey:[actiontitle objectAtIndex:i]] integerValue] blockClick:clickBlock];
            continue;
        }
        [alertController addAction:[UIAlertAction actionWithTitle:[actiontitle objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            clickBlock(action.title);
        }]];
    }
    [controller presentViewController:alertController animated:YES completion:^{
        
    }];

}
+(void)addCancleButon:(UIAlertController*)alertController {
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
}
+(void)addDelButon:(UIAlertController*)alertController blockClick:(AlertClickBlock)clickBlock {
    [alertController addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        clickBlock(action.title);
    }]];
}
// 添加的title的类型
+(void)addAction:(UIAlertController*)alertController title:(NSString*)title style:(UIAlertActionStyle)style blockClick:(AlertClickBlock)clickBlock{
    [alertController addAction:[UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
        clickBlock(action.title);
    }]];
}
+ (UIView *)getParentViewOfTitleAndMessageFromView:(UIView *)view {
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            return view;
        }else{
            UIView *resultV = [self getParentViewOfTitleAndMessageFromView:subView];
            if (resultV) return resultV;
        }
    }
    return nil;
}

- (BOOL)willDealloc {
    return NO;
}
@end
