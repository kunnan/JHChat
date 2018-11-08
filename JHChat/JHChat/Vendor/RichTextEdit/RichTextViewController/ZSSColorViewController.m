//
//  ZSSColorViewController.m
//  ZSSRichTextEditor
//
//  Created by Nicholas Hubbard on 8/12/14.
//  Copyright (c) 2014 Zed Said Studio. All rights reserved.
//

#import "ZSSColorViewController.h"

@interface ZSSColorViewController ()
{
    BOOL isChange;
    NSString  *ht;
    NSString *html;
}
@end

@implementation ZSSColorViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"任务描述";
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame=CGRectMake(0, 0, 50, 30);
    [rightButton addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:[UIColor colorWithRed:32/255.0 green:135/255.0 blue:252/255.0 alpha:1] forState:UIControlStateNormal];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
     self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    // HTML Content to set in the editor
    ht = [NSString stringWithFormat:@"%@",self.taskdetial];
    
    // Set the base URL if you would like to use relative links, such as to images.
    
    // Set the toolbar item color
    self.toolbarItemTintColor = [UIColor blackColor];
    
    // Set the toolbar selected color
    self.toolbarItemSelectedTintColor = [UIColor lightGrayColor];
    
    // Set the HTML contents of the editor
    [self setHTML:ht];
    
}
-(void)textViewDidChange:(UITextView *)textView {
    
    isChange=YES;
}
-(void)rightBtnClick:(UIButton*)btn{
    
    if (isChange) {
        // 得到文本框输入的所有内容[self getHTML] <p>里面嵌套它的话 就显示不了
        // 编辑完直接传过去放到html里面显示
        html = [NSString stringWithFormat:@"%@",[self getHTML]];
        // 设置HTML编辑器的内容
        [self setHTML:html];
        
    }
    if (self.delegate &&[self.delegate respondsToSelector:@selector(CooperationTaskChangeDetial:)]) {
        [self.delegate CooperationTaskChangeDetial:html];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
