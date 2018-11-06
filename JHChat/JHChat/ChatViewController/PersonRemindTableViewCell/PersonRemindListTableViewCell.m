//
//  PersonRemindListTableViewCell.m
//  LeadingCloud
//
//  Created by dfl on 2017/12/1.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "PersonRemindListTableViewCell.h"
#import "NSString+IsNullOrEmpty.h"
#import "UIImageView+Icon.h"
#import "UIView+Layout.h"
#import "AppDateUtil.h"

@interface PersonRemindListTableViewCell ()
{
    CGFloat curRatio;
}

@end

@implementation PersonRemindListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    curRatio = [[CommonFontModel shareInstance]getHandeHeightRatio];
    if (self) {
        /* 左侧图片 */
        self.cellCircleImage = [[UIImageView alloc] init];
        [self.cellCircleImage changToCircleWithWidth:LZ_Cell_IconWidthHeight50*curRatio];
        [self.contentView addSubview:self.cellCircleImage];
        
        /* 徽标(左侧) */
        self.cellBadgeViewLeft = [[LKBadgeView alloc] initWithFrame:CGRectMake(0, 0, 47*curRatio, 20*curRatio)];  //-2
        self.cellBadgeViewLeft.widthMode = LKBadgeViewWidthModeSmall;
        self.cellBadgeViewLeft.badgeColor = [UIColor whiteColor];
        self.cellBadgeViewLeft.textColor = [UIColor redColor];
        self.cellBadgeViewLeft.font = [UIFont systemFontOfSize:11*curRatio];
        self.cellBadgeViewLeft.heightMode = LKBadgeViewHeightModeCustom;
        self.cellBadgeViewLeft.customHeight = 17*curRatio;
        self.cellBadgeViewLeft.customHorizontalPadding = 5.5*curRatio;
        self.cellBadgeViewLeft.textOffset = CGSizeMake(0, 0.5);
        self.cellBadgeViewLeft.outlineColor = [UIColor redColor];
        self.cellBadgeViewLeft.outline = YES;
        self.cellBadgeViewLeft.outlineWidth = 1.0;
        [self.contentView addSubview:self.cellBadgeViewLeft];
        
        /* 标题 */
        self.cellTitle = [[UILabel alloc] init];
        [self.cellTitle setText:@""];
        self.cellTitle.font = [UIFont systemFontOfSize: 16*curRatio];
        //        [self.cellTitle setBackgroundColor:[UIColor redColor]];
        [self.contentView addSubview:self.cellTitle];
        
        /* 详细 */
        self.cellDetail = [[UILabel alloc] init];
        [self.cellDetail setText:@""];
        self.cellDetail.font = [UIFont systemFontOfSize:13*curRatio];
        [self.cellDetail setTextColor:[UIColor lightGrayColor]];
        //        [self.cellDetail setBackgroundColor:[UIColor grayColor]];
        [self.contentView addSubview:self.cellDetail];
        
        /* 时间 */
        self.cellDatetime = [[UILabel alloc] init];
        [self.cellDatetime setText:@""];
        self.cellDatetime.font = [UIFont systemFontOfSize:13*curRatio];
        [self.cellDatetime setTextColor:[UIColor lightGrayColor]];
        //        [self.cellDatetime setBackgroundColor:[UIColor grayColor]];
        [self.cellDatetime setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.cellDatetime];
        
        /* 设置约束 */
        [self.cellCircleImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(14*curRatio);
            make.top.equalTo(self.contentView).with.offset((64*curRatio-LZ_Cell_IconWidthHeight50*curRatio)/2);
            make.width.mas_equalTo(LZ_Cell_IconWidthHeight50*curRatio);
            make.height.mas_equalTo(LZ_Cell_IconWidthHeight50*curRatio);
        }];
        [self.cellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cellCircleImage.mas_right).with.offset(14*curRatio);
            //            make.right.equalTo(self.cellDatetime.mas_left);
            make.right.lessThanOrEqualTo(self.cellDatetime.mas_left).with.offset(-25*curRatio);
            //            make.top.equalTo(self.contentView).with.offset(Cell_Text_Top);
            //            make.bottom.equalTo(self.contentView.mas_centerY);
            make.top.equalTo(self.contentView).with.offset(12*curRatio);
            make.height.mas_equalTo(20*curRatio);
        }];
        [self.cellDatetime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(0-15*curRatio);
            make.top.equalTo(self.contentView).with.offset(12*curRatio);
            //            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(70*curRatio);
        }];
        [self.cellDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cellCircleImage.mas_right).with.offset(14*curRatio);
            make.right.equalTo(self.contentView).with.offset(0-40*curRatio - 15*curRatio - 14*curRatio);
            //            make.bottom.equalTo(self.contentView).with.offset(0-Cell_Detail_Bottom);
            //            make.right.equalTo(self.cellDatetime.mas_left);
            make.top.equalTo(self.cellTitle.mas_centerY).with.offset(14*curRatio);
            make.height.mas_equalTo(18*curRatio);
        }];
    }
    return self;
}

/*
 * 向Cell中填充数据
 */
- (void)setupViewModelItem:(id)viewModel atIndexPath:(NSIndexPath *)indexPath isBottom:(BOOL)isBottom{
    [self.cellCircleImage loadFaceIcon:nil isChangeToCircle:NO];
    [self.cellTitle setText:@"应用通知"];
    [self.cellDetail setText:@"请假单申请,发起人:王伟"];
    [self.cellDatetime setText:@"2017-12-01"];
    self.cellBadgeViewLeft.hidden = NO;
    self.cellBadgeViewLeft.centerX = LZ_Cell_IconWidthHeight50*curRatio+14*curRatio;
//    if(1<=99){
        self.cellBadgeViewLeft.text = [NSString stringWithFormat:@"%d",10];
//    } else {
//        self.cellBadgeViewLeft.text = @"99+";
//    }
    
}

@end
