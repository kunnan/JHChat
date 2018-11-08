//
//  CLEmoticonTool.h
//
//  Created by Mokhlas Hussein on 01/02/14.
//  Copyright (c) 2014 iMokhles. All rights reserved.
//  CLImageEditor Author sho yakushiji.
//

#import "CLImageToolBase.h"
#import "LZEmotionManagerView.h"

@class CLEmoticonTool;

@interface _CLEmoticonView : UIView
+ (void)setActiveEmoticonView:(_CLEmoticonView*)view;
- (UIImageView*)imageView;
- (id)initWithImage:(UIImage *)image tool:(CLEmoticonTool*)tool;
- (void)setScale:(CGFloat)scale;


@end

@interface CLEmoticonTool : CLImageToolBase<LZEmotionManagerViewDelegate>
- (UIImage*)buildImage:(UIImage*)image;
-(void)hiddenEmotionView;

@end
