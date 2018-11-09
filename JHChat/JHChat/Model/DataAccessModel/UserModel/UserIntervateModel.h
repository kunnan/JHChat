/************************************************************
 Author:  lz-fzj
 Date：   2016-03-01
 Version: 1.0
 Description: 【联系人】-【新的好友】数据表模型
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"

#pragma mark - 【联系人】-【新的好友】数据表模型
/**
 *【联系人】-【新的好友】数据表模型
 */
@interface UserIntervateModel : NSObject
/**
 *  主键
 */
@property(nonatomic,copy)NSString *uiid;
/**
 *  主题id
 */
@property(nonatomic,copy)NSString *objid;
/**
 *  邮箱
 */
@property(nonatomic,copy)NSString *email;
/**
 *  手机号码
 */
@property(nonatomic,copy)NSString *mobile;

/**
 *  邀请时间
 */
@property(nonatomic,strong) NSDate *intervatedate;
/**
 *  类型（0，未注册；1.已注册）
 */
@property(nonatomic,assign)NSInteger type;
/**
 *  已注册用户的id
 */
@property(nonatomic,copy)NSString *uid;
/**
 *  用户名
 */
@property(nonatomic,copy)NSString *username;
/**
 *  操作时间
 */
@property(nonatomic,strong) NSDate *actiondate;
/**
 *  处理结果(0 拒绝    1 接受  2  未处理)
 */
@property(nonatomic,assign)NSInteger  result;
/**
 *  日志类型（0，未处理的；1，我处理的；2，我发送的）
 */
@property(nonatomic,assign)NSInteger  logtype;
/**
 *  好友头像
 */
@property(nonatomic,copy)NSString *face;


@end
