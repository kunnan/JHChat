/************************************************************
 Author:  lz-fzj
 Date：   2016-02-29
 Version: 1.0
 Description: 【联系人】-【好友标签】数据库数据模型
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/
#import <Foundation/Foundation.h>

#pragma mark - 【联系人】-【好友标签】数据库数据模型
/**
 *  【联系人】-【好友标签】数据库数据模型
 */
@interface UserContactGroupModel : NSObject
/**
 *  标签id
 */
@property(nonatomic,strong)NSString *ucgId;
/**
 *  用户id（貌似没什么卵用】
 */
@property(nonatomic,strong)NSString *uId;
/**
 *  标签值
 */
@property(nonatomic,strong)NSString *tagValue;
/**
 *  添加时间
 */
@property(nonatomic,strong) NSDate *addTime;

/* 标签下的人员数量 */
@property(nonatomic,assign) NSInteger usercount;

@end
