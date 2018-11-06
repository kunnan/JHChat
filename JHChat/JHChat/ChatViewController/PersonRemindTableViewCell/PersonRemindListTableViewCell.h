//
//  PersonRemindListTableViewCell.h
//  LeadingCloud
//
//  Created by dfl on 2017/12/1.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKBadgeView.h"
#import "CommonFontModel.h"

@interface PersonRemindListTableViewCell : UITableViewCell

/* 头像 */
@property (nonatomic, strong) UIImageView *cellCircleImage;
@property (nonatomic, strong) LKBadgeView *cellBadgeViewLeft;
@property (nonatomic, strong) UILabel *cellTitle;
@property (nonatomic, strong) UILabel *cellDetail;
@property (nonatomic, strong) UILabel *cellDatetime;

/*
 * 向Cell中填充数据
 */
- (void)setupViewModelItem:(id )viewModel atIndexPath:(NSIndexPath *)indexPath isBottom:(BOOL)isBottom;

@end
