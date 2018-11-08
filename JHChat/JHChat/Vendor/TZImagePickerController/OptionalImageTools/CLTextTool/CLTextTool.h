//
//  CLTextTool.h
//
//  Created by sho yakushiji on 2013/12/15.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLImageToolBase.h"
@class CLTextTool;

@interface _CLTextView : UIView
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic,assign)BOOL isAgainEdit;

+ (void)setActiveTextView:(_CLTextView*)view;
- (id)initWithTool:(CLTextTool*)tool;
- (void)setScale:(CGFloat)scale;
- (void)sizeToFitWithMaxWidth:(CGFloat)width lineHeight:(CGFloat)lineHeight;
- (void)pushedDeleteBtn:(id)sender;
@end
@interface CLTextTool : CLImageToolBase


- (UIImage*)buildImage:(UIImage*)image;
@end
