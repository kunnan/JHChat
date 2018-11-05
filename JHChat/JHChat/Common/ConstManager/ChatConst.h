//
//  ChatConst.h
//  LeadingCloud
//
//  Created by wchMac on 15/12/30.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#ifndef ChatConst_h
#define ChatConst_h


#endif /* ChatConst_h */

static NSInteger const XH_AvatarImageSize = 40.0f;  //头像默认大小
static NSInteger const XH_AvatarPaddingX = 8.0;   //头像距离左右的距离

static NSInteger const XH_BubblePhotoMargin = 8.0f; // 图片类型消息，上下左右的边距

static NSInteger const XH_HaveBubbleMargin = 8.0f; // 文本、视频、表情气泡上下边的间隙
static CGFloat const XH_HaveBubbleVoiceMargin = 13.5f; // 语音气泡上下边的间隙
static CGFloat const XH_HaveBubblePhotoMargin = 6.5f; // 图片、地理位置气泡上下边的间隙---------------------（名片，文件待处理）

static NSInteger const XH_VoiceMargin = 20.0f; // 播放语音时的动画控件距离头像的间隙

static CGFloat const XH_BubbleViewArrowMarginWidth = 5.2f; // 气泡背景图片，箭头宽度

static NSInteger const XH_TextTopAndBottomBubbleMargin = 13.0f; // 文本在气泡内部的上下间隙
static NSInteger const XH_TextLeftTextHorizontalBubblePadding = 13.0f; // 文本的水平间隙
static NSInteger const XH_TextRightTextHorizontalBubblePadding = 13.0f; // 文本的水平间隙

static NSInteger const XH_VoiceUnReadDotSize = 10.0f; // 语音未读的红点大小

static NSInteger const XH_UserNameLabelHeight = 20;  //文件名，label的高度

static NSInteger const XH_NoneBubblePhotoMargin = (XH_HaveBubbleMargin - XH_BubblePhotoMargin); //---------------------（名片，文件待处理）
// 在没有气泡的时候，也就是在图片、视频、地理位置的时候，图片内部做了Margin，所以需要减去内部的Margin

#define XH_Chat_MaxSizeForText CGRectGetWidth([[UIScreen mainScreen] bounds]) * (kIsiPad ? 0.8 : (kIs_iPhone_6 ? 0.555 : (kIs_iPhone_6P ? 0.57 : 0.50)))
//#define XH_Chat_MaxSizeForText (kIsiPad ? 0.8*LZ_SCREEN_WIDTH : (kIs_iPhone_6 ? 0.55*LZ_SCREEN_WIDTH : (kIs_iPhone_6P ? 0.57*LZ_SCREEN_WIDTH : 0.50))

static NSInteger const LZMessageSystem_NoIcon_BubbleView_Pading = 10; //不显示头像时，bubble距离左右的间距





/* 固定尺寸 */
static NSInteger const Chat_Emotion_PageControlHeight = 38;
static NSInteger const Chat_Emotion_UpdatePageControlHeight = 10;
static NSInteger const Chat_Emotion_Counts = 80;
static NSInteger const Chat_Emotion_Rows = 4;
static NSInteger const Chat_Emotion_Columns = 7;
static NSInteger const Chat_Emotion_PageEmotions = 27;
static NSInteger const Chat_Emotion_Size = 28;

/* 图片小于此值时，不再进行压缩 */
static NSInteger const CHATVIEW_IMAGE_MINSIZE = 200;

/* 图片的宽高 */
static NSInteger const CHATVIEW_IMAGE_Height_Width_Max = 140;
static NSInteger const CHATVIEW_IMAGE_Height_Width_Min = 50;

/* 位置图片的宽、高 200 120 */
//#define CHATVIEW_GeoLocation_Width (LZ_SCREEN_WIDTH - 130)
#define CHATVIEW_GeoLocation_Width (XH_Chat_MaxSizeForText + XH_TextLeftTextHorizontalBubblePadding*2 + XH_BubbleViewArrowMarginWidth*2)
#define CHATVIEW_GeoLocation_Height (CHATVIEW_GeoLocation_Width * (kIs_iPhone_6 ? 0.555 : (kIs_iPhone_6P ? 0.57 : 0.50)))

/* 消息发送状态 */
static NSInteger const Chat_Msg_Sending = 1; //正在发送
static NSInteger const Chat_Msg_SendFail = 2; //发送失败
static NSInteger const Chat_Msg_SendSuccess = 3; //发送成功

/* 文件下载状态 */
static NSInteger const Chat_Msg_NoDownload = 1; //未下载
static NSInteger const Chat_Msg_Downloading = 2; //正在下载
static NSInteger const Chat_Msg_Downloadfail = 3; //下载失败
static NSInteger const Chat_Msg_Downloadsuccess = 4; //下载成功

/* 聊天框类型 ContaceType */

//最近联系人
//contenttype
//0:个人用户
//1:消息创建的普通群组
//2:和其他模块关联的群组
//    relatetype
//    0:普通工作组
//    1:协作任务的群组
//    2:项目的群组
//    3:和部门关联的工作组
//    4:和企业关联的工作组
//    5:其他模块或应用同步过来的群组(基础协作)
//3:应用  托管链接地址（局部页angular） --新的好友、新的协作等
//4:应用  非托管链接地址（完整的页）--目前没用到
//5:应用  使用模板--目前也没有使用
//6:企业提醒消息

static NSString * const Chat_ContactID_Five = @"5";  //对外业务会话
static NSString * const Chat_ContactID_Six = @"6";  //对内业务会话

static NSInteger const Chat_ContactType_Main_One = 0;  //单人聊天
static NSInteger const Chat_ContactType_Main_ChatGroup = 1;  //讨论组群聊天
static NSInteger const Chat_ContactType_Main_CoGroup = 2;    //工作组群聊天 （包括：工作圈、项目、任务、部门、企业）
static NSInteger const Chat_ContactType_Main_App_Three = 3;  //应用，非托管链接地址
static NSInteger const Chat_ContactType_Main_App_Four = 4;  //企业，托管链接地址
static NSInteger const Chat_ContactType_Main_App_Five = 5;  //模板替换参数方式
static NSInteger const Chat_ContactType_Main_App_Six = 6;  //企业提醒，个人提醒
static NSInteger const Chat_ContactType_Main_App_Seven = 7;  //对外业务会话
static NSInteger const Chat_ContactType_Main_App_Eight = 8;  //对内业务会话

static NSInteger const Chat_ContactType_Relate_CoGroup_Group = 0; // 工作圈
static NSInteger const Chat_ContactType_Relate_CoGroup_Project = 1; // 项目
static NSInteger const Chat_ContactType_Relate_CoGroup_Task = 2; // 任务
static NSInteger const Chat_ContactType_Relate_CoGroup_Department = 3; // 部门
static NSInteger const Chat_ContactType_Relate_CoGroup_Enterprise = 4; // 企业
static NSInteger const Chat_ContactType_Second_CoGroup_Other = 5;

static NSInteger const Chat_FromType_Zero = 0;  //单人
static NSInteger const Chat_FromType_One = 1;   //讨论组
static NSInteger const Chat_FromType_Two = 2;   //工作组
static NSInteger const Chat_FromType_Three = 3;  //应用，对应contacttype的3、4、5
static NSInteger const Chat_FromType_Four = 4;  //企业，对应contacttype的6
static NSInteger const Chat_FromType_Five = 5;  //个人提醒，对应contacttype的6

static NSInteger const Chat_ToType_Zero = 0;  //单人
static NSInteger const Chat_ToType_One = 1;   //讨论组
static NSInteger const Chat_ToType_Two = 2;   //工作组
static NSInteger const Chat_ToType_Four = 4;   //基础协作 （暂时废弃）
static NSInteger const Chat_ToType_Five = 5;   //对外业务会话
static NSInteger const Chat_ToType_Six = 6;   //对内业务会话

static NSInteger const Chat_MsgTemplate_One = 1;  //消息模板类型为1(进入自定义VC)---非托管链接地址，完整的页
static NSInteger const Chat_MsgTemplate_Two = 2;  //消息模板类型为2(进入自定义VC)---托管链接地址，局部页angular
static NSInteger const Chat_MsgTemplate_Three = 3;  //消息模板类型为3(进入聊天窗口)---模板参数替换方式
static NSInteger const Chat_MsgTemplate_Four = 4;  //消息模板类型为4(企业消息，进入聊天窗口)
static NSInteger const Chat_MsgTemplate_Five = 5;  //消息模板类型为5(个人提醒，进入聊天窗口)


//由于某些页面不只是从消息列表进入，所有无法使用模板中的code
static NSString * const Chat_ContactType_Second_Post = @"lzpost";  //协作动态
static NSString * const Chat_ContactType_Second_Cooperation = @"lzcooperation";  //新的协作
static NSString * const Chat_ContactType_Second_Newfriend = @"lznewfriend";  //新的好友
static NSString * const Chat_ContactType_Second_NewEnterprise = @"lznewenterprise";  //新的组织
static NSString * const Chat_ContactType_Second_NewStaff = @"lznewstaff";  //新的员工
static NSString * const Chat_ContactType_Second_NewApply = @"lzcooperation_apply"; // 新的成员
static NSString * const Chat_ContactType_Second_OutWardlBusiness = @"outwardlbusiness"; // 对外业务会话 处理业务会话（特殊处理）
static NSString * const Chat_ContactType_Second_InternalBusiness = @"internalbusiness"; // 对内业务会话 处理业务会话（特殊处理）


/* 消息发送队列 */
static NSInteger const Message_Queue_Sending = 1; //正在发送
static NSInteger const Message_Queue_SendFail = 2; //发送失败

/* 群 */
static NSInteger const ImGroup_Default_DownUserCount = 20; //登陆时默认下载群人员数量

/* 视频语音通话的状态(单人) */
static NSString * const Chat_Call_State_Request = @"1"; // 请求中（一分钟之内的不显示。超过一分钟发起方显示失败，接收方显示对方已取消）多人也使用
static NSString * const Chat_Call_State_Defeat = @"2"; // 发起失败（系统异常，对方根本没有收到）
static NSString * const Chat_Call_State_Canceled = @"3"; // 已取消（发起后主动取消，对方已取消）
static NSString * const Chat_Call_State_Refuse = @"4"; // 拒绝（发送方显示对方已拒绝，接收方显示已取消）
static NSString * const Chat_Call_State_Timeout = @"5"; // 超时（发送方显示对方无应答，接收方显示对方已取消）  多人也使用
static NSString * const Chat_Call_State_Finished = @"6"; // 已完成（带有通话时长）  多人也使用
static NSString * const Chat_Call_State_Busy = @"7"; // 对方忙线中（发送方显示，接收方不显示）
static NSString * const Chat_Call_State_Calling = @"8"; // 正在通话（双方都不显示）

/* 视频语音通话的状态(多人) */
static NSString * const Chat_Group_Call_State_Request = @"1";
static NSString * const Chat_Group_Call_State_Timeout = @"2";
static NSString * const Chat_Group_Call_State_Refuse = @"3";
static NSString * const Chat_Group_Call_State_Hangup = @"4";
static NSString * const Chat_Group_Call_State_Invite = @"5";
static NSString * const Chat_Group_Call_State_Join = @"6";
static NSString * const Chat_Group_Call_State_End = @"7";
static NSString * const Chat_Group_Call_State_Clear = @"8";
static NSString * const Chat_Group_Call_State_Update = @"9";
static NSString * const Chat_Group_Call_State_Receive = @"10";
static NSString * const Chat_Group_Call_State_Speech = @"10.5";


/* 消息日志错误类型 */
static NSInteger const Error_Type_Three = 3; //收到其它人已读的消息
static NSInteger const Error_Type_Four = 4; //收到新消息
static NSInteger const Error_Type_Five = 5; //记录日志，跟踪20161213，收到已读，数量减一
static NSInteger const Error_Type_Six = 6; //记录插件的调用日志
static NSInteger const Error_Type_Seven = 7; //记录写入到SessionStorage中的信息
static NSInteger const Error_Type_Eight = 8; //keychain中的信息
static NSInteger const Error_Type_Nine = 9; //plist中的信息
static NSInteger const Error_Type_Ten = 10; //点击通知之后，记录通知中的数据
static NSInteger const Error_Type_Eleven = 11; //应用页签是否存在重复数据
static NSInteger const Error_Type_Twelve = 12; //是否只存在一个长连接
static NSInteger const Error_Type_Fifth = 15; //DeviceToken
static NSInteger const Error_Type_Sixth = 16; //保存应用设置信息
static NSInteger const Error_Type_Seventeen = 17; //RSA加密失败，密码为nil
static NSInteger const Error_Type_Eighteen = 18; //获取消息模板失败
static NSInteger const Error_Type_Ninteen = 19; //记录WebView打开的Url地址
static NSInteger const Error_Type_Twenty = 20; // 图片消息的方向不是向上
static NSInteger const Error_Type_TwentyOne = 21; // 调用了阿里云的initWithEndpoint


