//
//  CLDrawTool.h
//
//  Created by sho yakushiji on 2014/06/20.
//  Copyright (c) 2014年 CALACULU. All rights reserved.
//

#import "CLImageToolBase.h"

@interface CLDrawTool : CLImageToolBase

- (void)drawingViewDidPan:(UIPanGestureRecognizer*)sender;
-(void)drawLine:(CGPoint)from to:(CGPoint)to lineColor:(UIColor*)lineColor;
- (UIImage*)buildImage;

@end
