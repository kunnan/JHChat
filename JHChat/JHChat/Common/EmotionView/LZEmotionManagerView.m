//
//  LZEmotionManagerView.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/29.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-01-19
 Version: 1.0
 Description: 表情视图
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZEmotionManagerView.h"

@implementation LZEmotionManagerView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
        _isChangeColor = NO;
    }
    return self;
}

- (void)setup {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
    
    /* UIScroll 部分 */
    if (!_emotionScrollView) {
        UIScrollView *emotionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-Chat_Emotion_PageControlHeight)];
        emotionScrollView.backgroundColor = self.backgroundColor;
        emotionScrollView.pagingEnabled = YES;
        emotionScrollView.showsHorizontalScrollIndicator = NO;
        emotionScrollView.delegate = self;
        [self addSubview:emotionScrollView];
        self.emotionScrollView = emotionScrollView;
    }

    /* PageContrl 部分 */
    if (!_emotionPageControl) {
        UIPageControl *emotionPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emotionScrollView.frame)-5, CGRectGetWidth(self.bounds), Chat_Emotion_UpdatePageControlHeight)];
        emotionPageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.471 alpha:1.000];
        emotionPageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.678 alpha:1.000];
        emotionPageControl.backgroundColor = self.backgroundColor;
        emotionPageControl.hidesForSinglePage = YES;
        emotionPageControl.defersCurrentPageDisplay = YES;
        [emotionPageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:emotionPageControl];
        self.emotionPageControl = emotionPageControl;
    }
    
    /* 底部选择栏 */
    NSArray *titles = @[@""];
    
    XLSlideSwitch *slideSwitch = [[XLSlideSwitch alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds)-31, LZ_SCREEN_WIDTH-55, 31)];
    slideSwitch.delegate = self;
    slideSwitch.btnSelectedColor = [UIColor redColor];
    slideSwitch.btnNormalColor = [UIColor grayColor];
    slideSwitch.titles = titles;
    slideSwitch.adjustBtnSize2Screen = NO; //按钮的大小根据文字长短设定
    [self addSubview:slideSwitch];
    self.slideSwitch = slideSwitch;
    
    /* 竖向分割线 */
    UIView *viewVertical = [[UIView alloc] initWithFrame:CGRectMake(LZ_SCREEN_WIDTH-56, CGRectGetHeight(self.bounds)-31, 1, 31)];
    viewVertical.backgroundColor = [UIColor colorWithWhite:0.789 alpha:1.000];
    [self.slideSwitch addSubview:viewVertical];
    self.emotionVerticalSegmentLine = viewVertical;
    
    /* 发送按钮 */
    if(!_emotionSendButton){
//        float paddingRight = (CGRectGetWidth(self.bounds)-32.0*Chat_Emotion_Columns)/(Chat_Emotion_Columns+1);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//
        button.frame = CGRectMake(LZ_SCREEN_WIDTH-55,CGRectGetHeight(self.bounds)-31,55,31);

        if(self.img_done_title==nil){
            self.img_done_title = LZGDCommonLocailzableString(@"cooperation_send");
        }

        [button setBackgroundColor:self.backgroundColor];
        [button setTitle:self.img_done_title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:0.55 alpha:1.000] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickLZEmotionDoneBtn:)forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        self.emotionSendButton = button;
    }
}

-(void)setSendtitle:(NSString *)sendtitle{
    [_emotionSendButton setTitle:sendtitle forState:UIControlStateNormal];
}

#pragma mark SlideSwitchDelegate
-(void)slideSwitchDidselectTab:(NSUInteger)index
{
    //可以通过切换按钮的方法修改表情键盘
//    _slideSwitch.titles[index];
    switch (index) {
        case 0:
//            [self reloadEmotins];
            break;
        case !0:
//            [self.emotionScrollView removeFromSuperview];
            break;
            
        default:
            break;
    }
}

/**
 *  加载表情
 */
-(void)reloadEmotins{
    int pageEmotionCount = Chat_Emotion_PageEmotions;
    int emotionPages = (Chat_Emotion_Counts / pageEmotionCount + ((Chat_Emotion_Counts % pageEmotionCount) > 0 ? 1 : 0));
    
    /* 根据表情数量设置 */
    [self.emotionScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.bounds) * emotionPages,
                                                      CGRectGetHeight(self.bounds)-Chat_Emotion_PageControlHeight)];
    self.emotionPageControl.numberOfPages = emotionPages;
    
    /* 表情列间距 */
    float emotionHSpace = (CGRectGetWidth(self.bounds)-Chat_Emotion_Size*Chat_Emotion_Columns)/(Chat_Emotion_Columns+1);
    
    /* 表情行间距 */
    float emotionVSpace = (self.emotionScrollView.frame.size.height-Chat_Emotion_Size*Chat_Emotion_Rows)/(Chat_Emotion_Rows+1);
    
    int lastRow = 0;
    int lastColumn = 0;
    int lastPage = 0;
    
    //按页循环
    for(int i=0;i<emotionPages;i++)
    {
        //按行循环
        for(int j=0;j<Chat_Emotion_Rows;j++)
        {
            CGFloat padingTop = emotionVSpace + j*(Chat_Emotion_Size+emotionVSpace);
            for(int k=0;k<Chat_Emotion_Columns;k++)
            {
                
                int faceIndex = i*Chat_Emotion_Rows*Chat_Emotion_Columns + j*Chat_Emotion_Columns + k - (i*1);

                if(faceIndex>=Chat_Emotion_Counts){
                    break;
                }
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                
                CGFloat padingLeft =  emotionHSpace + i * CGRectGetWidth(self.bounds);
                
                /* 最后一行，最后一列，显示删除按钮 */
                if(j==Chat_Emotion_Rows-1 && k == Chat_Emotion_Columns-1){
                    //添加删除图片
                    button.frame = CGRectMake(padingLeft + k*(Chat_Emotion_Size+emotionHSpace),
                                              padingTop+2,
                                              28,
                                              28);
                                
                    [button setBackgroundImage:[ImageManager LZGetImageByFileName:@"msg_chat_face_delete"] forState:UIControlStateNormal];
                    
                    button.tag = 1000+emotionPages;
                    [button addTarget:self action:@selector(clickLZEmotionDelBtn:)forControlEvents:UIControlEventTouchUpInside];
                }
                else{
                    button.frame = CGRectMake(padingLeft + k*(Chat_Emotion_Size+emotionHSpace),
                                              padingTop,
                                              Chat_Emotion_Size,
                                              Chat_Emotion_Size);
                                
                    UIImage *tempImage = [ImageManager LZGetImageByFileName:[NSString stringWithFormat:@"%d.png",faceIndex]];
                    //                    UIImage *tempImage = [UIImage imageNamed:[NSString stringWithFormat:@"%d.gif",faceIndex]];
                    [button setBackgroundImage:tempImage forState:UIControlStateNormal];
                    button.tag = faceIndex;
                    [button addTarget:self action:@selector(selecteLZEmotion:)forControlEvents:UIControlEventTouchUpInside];
                    
                    /* 记录最后一个表情的位置 */
                    lastPage = i;
                    lastRow = j;
                    lastColumn = k;
                }
                
                [self.emotionScrollView addSubview:button];
            }
        }
    }
    
    /* 非整页 */
    if((Chat_Emotion_Counts % pageEmotionCount) != 0){
        /* 添加删除图片 */
        if(lastColumn<Chat_Emotion_Columns){
            lastColumn += 1;
        }
        else {
            lastRow += 1;
            lastColumn = 0;
        }
        
        CGFloat padingLeft =  emotionHSpace + lastPage * CGRectGetWidth(self.bounds);
        CGFloat padingTop = emotionVSpace + lastRow*(Chat_Emotion_Size+emotionVSpace);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(padingLeft + lastColumn*(Chat_Emotion_Size+emotionHSpace),
                                  padingTop+2,
                                  28,
                                  28);
        
        [button setBackgroundImage:[ImageManager LZGetImageByFileName:@"msg_chat_face_delete"] forState:UIControlStateNormal];
        
        button.tag = 1000+emotionPages;
        [button addTarget:self action:@selector(clickLZEmotionDelBtn:)forControlEvents:UIControlEventTouchUpInside];
        [self.emotionScrollView addSubview:button];
    }
}

///**
// *  加载表情
// */
//-(void)reloadEmotins{
//    int pageEmotionCount = Chat_Emotion_PageEmotions;
//    int emotionPages = (Chat_Emotion_Counts / pageEmotionCount + ((Chat_Emotion_Counts % pageEmotionCount) > 0 ? 1 : 0));
//    
//    /* 根据表情数量设置 */
//    [self.emotionScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.bounds) * emotionPages,
//                                                          CGRectGetHeight(self.bounds)-Chat_Emotion_PageControlHeight)];
//    self.emotionPageControl.numberOfPages = emotionPages;
//    
//    /* 表情列间距 */
//    float emotionHSpace = (CGRectGetWidth(self.bounds)-32.0*Chat_Emotion_Columns)/(Chat_Emotion_Columns+1);
//    
//    /* 表情行间距 */
//    float emotionVSpace = (self.emotionScrollView.frame.size.height-32.0*Chat_Emotion_Rows)/(Chat_Emotion_Rows+1);
//    
//    int lastRow = 0;
//    int lastColumn = 0;
//    int lastPage = 0;
//    
//    //按页循环
//    for(int i=0;i<emotionPages;i++)
//    {
//        //按行循环
//        for(int j=0;j<Chat_Emotion_Rows;j++)
//        {
//            CGFloat padingTop = emotionVSpace + j*(Chat_Emotion_Size+emotionVSpace);
//            for(int k=0;k<Chat_Emotion_Columns;k++)
//            {
//                
//                int faceIndex = i*Chat_Emotion_Rows*Chat_Emotion_Columns + j*Chat_Emotion_Columns + k - (i*3);
//                /* 最后一行，位移一位 */
//                if(j==Chat_Emotion_Rows-1){
//                    faceIndex -= 1;
//                    if(k==Chat_Emotion_Columns-2){
//                        faceIndex -= 1;
//                    }
//                }
//                
//                if(faceIndex>=Chat_Emotion_Counts){
//                    break;
//                }
//                
//                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                
//                CGFloat padingLeft =  emotionHSpace + i * CGRectGetWidth(self.bounds);
//                
//                /* 第三行，最后一列，显示删除按钮 */
//                if(j==Chat_Emotion_Rows-2 && k == Chat_Emotion_Columns-1){
//                    //添加删除图片
//                    button.frame = CGRectMake(padingLeft + k*(Chat_Emotion_Size+emotionHSpace),
//                                              padingTop+2,
//                                              28,
//                                              28);
//                    [button setBackgroundImage:[UIImage imageNamed:@"msg_chat_face_delete"] forState:UIControlStateNormal];
//                    
//                    button.tag = 1000+emotionPages;
//                    [button addTarget:self action:@selector(clickLZEmotionDelBtn:)forControlEvents:UIControlEventTouchUpInside];
//                }
//                /* 最后一行，倒数第二列，显示确定按钮 */
//                else if(j==Chat_Emotion_Rows-1 && k == Chat_Emotion_Columns-2){
//                    int btnSureWidth = 49;
//                    //添加确定图片
//                    button.frame = CGRectMake(padingLeft + k*(Chat_Emotion_Size+emotionHSpace) +
//                                              (Chat_Emotion_Size*2+emotionHSpace-btnSureWidth)/2 ,
//                                              padingTop+2,
//                                              btnSureWidth,
//                                              26);
//                    
//                    if(self.img_done_default==nil){
//                        self.img_done_default = @"msg_chat_face_done_default";
//                    }
//                    if(self.img_done_hl==nil){
//                        self.img_done_hl = @"msg_chat_face_done_default";
//                    }
//                    if(self.img_done_title==nil){
//                        self.img_done_title = LZGDCommonLocailzableString(@"common_confirm");
//                    }
//                    [button setBackgroundImage:[UIImage imageNamed:self.img_done_default] forState:UIControlStateNormal];
//                    [button setBackgroundImage:[UIImage imageNamed:self.img_done_hl] forState:UIControlStateSelected];
//                    [button setTitle:self.img_done_title forState:UIControlStateNormal];
//
//                    button.tag = 1100+emotionPages;
//                    [button addTarget:self action:@selector(clickLZEmotionDoneBtn:)forControlEvents:UIControlEventTouchUpInside];
//                }
//                /* 最后一行，最后一列 */
//                else if(j==Chat_Emotion_Rows-1 && k == Chat_Emotion_Columns-1){
//
//                }
//                else{
//                    button.frame = CGRectMake(padingLeft + k*(Chat_Emotion_Size+emotionHSpace),
//                                              padingTop,
//                                              Chat_Emotion_Size,
//                                              Chat_Emotion_Size);
//                    UIImage *tempImage = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",faceIndex]];
////                    UIImage *tempImage = [UIImage imageNamed:[NSString stringWithFormat:@"%d.gif",faceIndex]];
//                    [button setBackgroundImage:tempImage forState:UIControlStateNormal];
//                    button.tag = faceIndex;
//                    [button addTarget:self action:@selector(selecteLZEmotion:)forControlEvents:UIControlEventTouchUpInside];
//                    
//                    /* 记录最后一个表情的位置 */
//                    lastPage = i;
//                    lastRow = j;
//                    lastColumn = k;
//                }
//                
//                [self.emotionScrollView addSubview:button];
//            }
//        }
//    }
//    
//    /* 非整页 */
//    if((Chat_Emotion_Counts % pageEmotionCount) != 0){
//        /* 添加删除图片 */
//        if(lastColumn<Chat_Emotion_Columns){
//            lastColumn += 1;
//        }
//        else {
//            lastRow += 1;
//            lastColumn = 0;
//        }
//        
//        CGFloat padingLeft =  emotionHSpace + lastPage * CGRectGetWidth(self.bounds);
//        CGFloat padingTop = emotionVSpace + lastRow*(Chat_Emotion_Size+emotionVSpace);
//        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(padingLeft + lastColumn*(Chat_Emotion_Size+emotionHSpace),
//                                  padingTop+2,
//                                  28,
//                                  28);
//        [button setBackgroundImage:[UIImage imageNamed:@"msg_chat_face_delete"] forState:UIControlStateNormal];
//        
//        button.tag = 1000+emotionPages;
//        [button addTarget:self action:@selector(clickLZEmotionDelBtn:)forControlEvents:UIControlEventTouchUpInside];
//        [self.emotionScrollView addSubview:button];
//    }
//}

#pragma mark - Action
/**
 *  点击了表情
 */
-(void)selecteLZEmotion:(id)sender{
    UIButton *emotion = (UIButton *)sender;
    DDLogVerbose(@"点击表情-----%ld",emotion.tag);
    /* 点击表情后，发送按钮颜色改变 */
    [self.emotionSendButton setBackgroundColor:[UIColor colorWithRed:53/255.0 green:168/255.0 blue:244/255.0 alpha:1.000]];
    [self.emotionSendButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:1.000] forState:UIControlStateNormal];
    NSInteger emotionName = emotion.tag;
    NSString *emotionDescription = [[EmotionUtil getImageNameToDescription] objectForKey:[NSString stringWithFormat:@"%ld",emotionName]];
    NSString *sendEmotionText = [NSString stringWithFormat:@"[/%@]",emotionDescription];
    
    if ([self.delegate respondsToSelector:@selector(didSelecteLZEmotion:iconName:emotionText:)]) {
        [self.delegate didSelecteLZEmotion:sender iconName:[NSString stringWithFormat:@"%ld",emotionName] emotionText:sendEmotionText];
    }
}

/**
 *  点击了删除表情的按钮
 */
-(void)clickLZEmotionDelBtn:(id)sender{
    if ([self.delegate respondsToSelector:@selector(didClickLZEmotionDelBtn:)]) {
        NSString *result = [self.delegate didClickLZEmotionDelBtn:sender];
        NSLog(@"表情界面点击删除按钮，输入框中还剩下的内容%@",result);
        if ([result isEqualToString:@""] && _isChangeColor == NO) {
            /* 删除表情，如果输入框为空，发送按钮变为灰色 */
            [self.emotionSendButton setBackgroundColor:self.backgroundColor];
            [self.emotionSendButton setTitleColor:[UIColor colorWithWhite:0.55 alpha:1.000] forState:UIControlStateNormal];
        }
    }
}

/**
 *  点击了确定按钮
 */
-(void)clickLZEmotionDoneBtn:(id)sender{
    if ([self.delegate respondsToSelector:@selector(didClickLZEmotionDoneBtn:)]) {
        [self.delegate didClickLZEmotionDoneBtn:sender];
    }
    /* 点击发送后，按钮变成灰色不可用状态 */
    if (_isChangeColor == NO) {
        [self.emotionSendButton setBackgroundColor:self.backgroundColor];
        [self.emotionSendButton setTitleColor:[UIColor colorWithWhite:0.55 alpha:1.000] forState:UIControlStateNormal];
    }    

}

#pragma mark - UIPageController

- (IBAction)changePage:(id)sender
{
    NSInteger page = [sender currentPage];
    [self.emotionScrollView setContentOffset:CGPointMake(self.emotionScrollView.bounds.size.width * page, 0)];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)currentScrollView{

    NSInteger page = fabs(currentScrollView.contentOffset.x/CGRectGetWidth(self.bounds));
    [self.emotionPageControl setCurrentPage:page];
}

@end
