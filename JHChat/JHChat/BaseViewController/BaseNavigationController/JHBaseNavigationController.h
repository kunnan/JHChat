//
//  JHBaseNavigationController.h
//  JHChat
//
//  Created by gjh on 2018/11/6.
//  Copyright © 2018 gjh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHBaseNavigationController : UINavigationController
//重写返回按钮
-(void)pushViewControllerr:(UIViewController *)viewController animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
