//
//  ContactSelectParamsModel.h
//  LeadingCloud
//
//  Created by wchMac on 16/5/30.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#define OtherInfoType  @"otherinfotype"
#define OtherInfoTypeImGroup  @"otherinfotype_imgroup"

#define OtherInfoTypeData  @"otherinfotype_data"

/**
 * 联系人数据的加载模式
 */
typedef NS_ENUM(NSUInteger ,ContactSelectType){
    /**
     *  人员多选模式
     */
    ContactSelectTypeMultiple,
    /**
     *  人员单选模式
     */
    ContactSelectTypeSingle,
    /**
     *  人员单选并可移除模式(仅支持人员选择)
     */
    ContactSelectTypeSingleAndRemove
};

#define Contact_Select_NoSelect 0
#define Contact_Select_Selected 1
#define Contact_Select_Disable 2

@interface ContactSelectParamsModel : NSObject

/* 人员选择类型(默认多选) */
@property(nonatomic,assign) ContactSelectType selectType;

/* 已选人员为0时，点击按钮是否可用 */
@property(nonatomic,assign) BOOL isEnableClickWhenZero;

/* 是否包含选择聊天群 */
@property(nonatomic,assign) BOOL isIncludeSelectImGroup;

/* 是否包含邀请外部人员 */
@property(nonatomic,assign) BOOL isIncludeInviteOutsidePeople;

/* 选择的人员Model，说明：参数为UserModel数组 */
@property(nonatomic,strong) NSMutableArray *selectedUserModels;

/* 不允许选的人员，说明：参数为uid数组 或 UserModel 数组 */
@property(nonatomic,strong) NSMutableArray *disableSelectedUsers;

@end
