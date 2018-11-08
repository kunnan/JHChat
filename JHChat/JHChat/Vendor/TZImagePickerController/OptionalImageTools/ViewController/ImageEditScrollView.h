//
//  ImageEditScrollView.h
//  LeadingCloud
//
//  Created by SY on 2017/10/27.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageEditScrollViewDelegate <NSObject>
@optional
-(void)imageEditScrollViewTouchBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)imageEditScrollViewTouchEnded:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)imageEditScrollViewTouchMove:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)imageEditScrollViewTouchCancle:(NSSet *)touches withEvent:(UIEvent *)event;

@end
@interface ImageEditScrollView : UIScrollView

@property (nonatomic, weak) id<ImageEditScrollViewDelegate> imageEditScrollViewDelegate;
@end
