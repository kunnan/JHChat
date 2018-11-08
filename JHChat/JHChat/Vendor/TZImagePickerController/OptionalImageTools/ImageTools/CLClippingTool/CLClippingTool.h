//
//  CLClippingTool.h
//
//  Created by sho yakushiji on 2013/10/18.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLImageToolBase.h"

@protocol CLippingDelegate <NSObject>

-(void)clippingGetRect:(CGRect)rect;

@end

@interface CLClippingTool : CLImageToolBase
-(UIImage*)bulidImage;
@end
