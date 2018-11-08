//
//  CLImageEditor.m
//
//  Created by sho yakushiji on 2013/10/17.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLImageEditor.h"

#import "_CLImageEditorViewController.h"

@interface CLImageEditor ()
{
    BOOL isHiddenNav;
}
@end


@implementation CLImageEditor

- (id)init
{
    return [_CLImageEditorViewController new];
}

- (id)initWithImage:(UIImage*)image
{
    return [self initWithImage:image delegate:nil];
}

- (id)initWithImage:(UIImage*)image delegate:(id<CLImageEditorDelegate>)delegate
{
    return [[_CLImageEditorViewController alloc] initWithImage:image delegate:delegate];
}

- (id)initWithDelegate:(id<CLImageEditorDelegate>)delegate
{
    return [[_CLImageEditorViewController alloc] initWithDelegate:delegate];
}

- (void)showInViewController:(UIViewController*)controller withImageView:(UIImageView*)imageView;
{
    
}

- (void)refreshToolSettings
{
    
}

- (CLImageEditorTheme*)theme
{
    return [CLImageEditorTheme theme];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    isHiddenNav = !isHiddenNav;
    // 把系统的导航控制器给隐藏掉 用自定义的
   // [self.navigationController setNavigationBarHidden:isHiddenNav animated:NO];
    
}
@end

