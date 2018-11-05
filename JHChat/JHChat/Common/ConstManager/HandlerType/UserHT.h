//
//  UserHT.h
//  LeadingCloud
//
//  Created by wchMac on 16/5/9.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#ifndef UserHT_h
#define UserHT_h


#endif /* UserHT_h */

/* ===============================用户(user)=============================== */
static NSString * const Handler_User = @"user";

/* 账号(account) */
static NSString * const Handler_User_Account = @"account";
static NSString * const Handler_User_Account_UpdateMobile  = @"user.account.updatemobile";  //绑定手机号码--临时通知(已处理)
static NSString * const Handler_User_Account_UpdateEmail  = @"user.account.updateemail"; //绑定邮箱--临时通知(已处理)
static NSString * const Handler_User_Account_UpdatePwd  = @"user.account.updatepwd";  //修改密码--临时通知(已处理)
static NSString * const Handler_User_Account_CancelBindMobile  = @"user.account.cancelbindmobile";  //用户取消手机账号绑定--临时通知(已处理)
static NSString * const Handler_User_Account_CancelBindEmail  = @"user.account.cancelbindemail";  //用户取消邮箱账号绑定--临时通知(已处理)
static NSString * const Handler_User_Account_CancelBindWeXin  = @"user.account.cancelbindwechat";  //用户解绑微信--临时通知(已处理)
static NSString * const Handler_User_Account_CancelBindWeBo  = @"user.account.cancelbindwebo";  //用户解绑微博--临时通知(已处理)
static NSString * const Handler_User_Account_CancelBindQQ  = @"user.account.cancelbindqq";  //用户解绑微信--临时通知(已处理)

/* 个人基本信息(basicinfo) */
static NSString * const Handler_User_Basicinfo = @"basicinfo";
static NSString * const Handler_User_Basicinfo_ChangeFace  = @"user.basicinfo.changeface";  //用户头像更换--持久通知(已处理)
static NSString * const Handler_User_Basicinfo_UpdateUserName  = @"user.basicinfo.updateusername";  //用户名称改变--临时通知(已处理)
static NSString * const Handler_User_Basicinfo_SwitchIdentiType  = @"user.basicinfo.switchidentitype";  //用户身份切换的通知--临时通知(已处理)
static NSString * const Handler_User_Basicinfo_SetMainOeid  = @"user.basicinfo.setmainoeid";  //用户设置主企业的通知--临时通知(已处理)


/* 新的好友(friend) */
static NSString * const Handler_User_Friend = @"friend";
static NSString * const Handler_User_Friend_NewFriend  = @"user.friend.newfriend";  //新的好友--临时通知(已处理)、消息
static NSString * const Handler_User_Friend_AgreeFriend  = @"user.friend.agreefriend";  //接受邀请--临时通知(已处理)、消息(已处理)
static NSString * const Handler_User_Friend_RefuseFriend  = @"user.friend.refusefriend";  //拒绝邀请--临时通知(已处理)、消息(已处理)
static NSString * const Handler_User_Friend_DeleteInvite  = @"user.friend.deleteinvite";  //新的好友删除--临时通知(已处理)、消息(已处理)
static NSString * const Handler_User_Friend_AdjustTag  = @"user.friend.adjusttag";  //好友调整标签--临时通知(未处理)
static NSString * const Handler_User_Friend_SetEspecial  = @"user.friend.setespecial";  //设置星标好友--临时通知(已处理)
static NSString * const Handler_User_Friend_RemoveEspecial  = @"user.friend.removeespecial";  //移除星标好友--临时通知(已处理)
static NSString * const Handler_User_Friend_removeFriend  = @"user.friend.removefriend";  //移除好友--临时通知(已处理)



/* 标签(tag) */
static NSString * const Handler_User_Tag = @"tag";
static NSString * const Handler_User_Tag_AddTag = @"user.tag.addtag";  //添加一个标签--临时通知(已处理)
static NSString * const Handler_User_Tag_RemoveTag = @"user.tag.removetag";  //删除一个标签--临时通知(已处理)
static NSString * const Handler_User_Tag_ReName = @"user.tag.rename";  //修改标签名称--临时通知(已处理)



