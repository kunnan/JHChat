//
//  ChatOneSettingController.m
//  LeadingCloud
//
//  Created by wchMac on 16/3/1.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-03-01
 Version: 1.0
 Description: 单人，聊天设置界面
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "ChatOneSettingController.h"
#import "UIImageView+Icon.h"
#import "XHBaseNavigationController.h"
#import "ImGroupModel.h"
#import "AppDateUtil.h"
#import "GroupViewModel.h"
#import "ChatViewController.h"
#import "UIAlertView+AlertWithMessage.h"
#import "ImChatLogDAL.h"
#import "ContactFriendInfoViewController2.h"
#import "ImChatLogDAL.h"
#import "PhotoBrowserViewModel.h"
#import "UIView+Layout.h"
#import "LZUILabel.h"
#import "NSString+XHDiskSizeTransfrom.h"
#import "ChatViewModel.h"
#import "MWGridCell.h"
#import "ImRecentDAL.h"
#import "ContactRootViewController2.h"
#import "UserDAL.h"
#import "ImChatLogDAL.h"
#import "CommonFontModel.h"

@interface ChatOneSettingController ()<ContactSelectDelegate>{
    UISwitch *stickToTop;
    UISwitch *noDisturb;
    CGFloat curRatio;
}
@end

@implementation ChatOneSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LZGDCommonLocailzableString(@"message_chat_setting");
    /* 当加载该页面的时候，把控制器名称添加到数组中 */
    [self.appDelegate.lzSingleInstance.viewControllerArr addObject:[NSString stringWithUTF8String:object_getClassName(self)]];
    
    curRatio = [[CommonFontModel shareInstance]getHandeHeightRatio];
    /* 初始化数据 */
    [self loadData];

    [self addCustomDefaultBackButton:LZGDCommonLocailzableString(@"common_back")];
    
    //注册订阅
    EVENT_SUBSCRIBE(self, EventBus_Chat_ImGroup_Add);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UMengUtil beginLogPageView:@"ChatOneSettingController"];
    //注册订阅
    EVENT_SUBSCRIBE(self, EventBus_Chat_ClearChatlog);
    EVENT_SUBSCRIBE(self, EventBus_WebApi_SetRecentStick);
    EVENT_SUBSCRIBE(self, EventBus_WebApi_SetRecentOneDisturb);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UMengUtil endLogPageView:@"ChatOneSettingController"];
    //取消订阅
    EVENT_UNSUBSCRIBE(self, EventBus_Chat_ClearChatlog);
    EVENT_UNSUBSCRIBE(self, EventBus_WebApi_SetRecentStick);
    EVENT_UNSUBSCRIBE(self, EventBus_WebApi_SetRecentOneDisturb);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/**
 *  控制器销毁的时候删除数组中的元素
 */
- (void)dealloc {
    
    _toUserModel = nil;
    
    //取消订阅
    EVENT_UNSUBSCRIBE(self, EventBus_Chat_ImGroup_Add);
    [self.appDelegate.lzSingleInstance.viewControllerArr removeObject:[NSString stringWithUTF8String:object_getClassName(self)]];
}
/**
 *  组织数据
 */
-(void)loadData{
    
    [self.tableDataSourceArr removeAllObjects];

    //第一组 群成员
    NSMutableArray *firstGroupArr = [[NSMutableArray alloc] init];
    NSMutableDictionary *ffGroupInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:LZGDCommonLocailzableString(@"message_chat_member"),LEFTTITLE,@"",RIGHTTITLE,@"",CellAccessory,@"",SELECTOR,@"",CUSTOMVIEW,nil];
    NSMutableDictionary *fsGroupInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",LEFTTITLE,@"",RIGHTTITLE,@"",CellAccessory,@"",SELECTOR,@"faceicon",CUSTOMVIEW,nil];
    [firstGroupArr addObject:ffGroupInfo];
    [firstGroupArr addObject:fsGroupInfo];
    
    //第二组 聊天文件，置顶
    NSMutableArray *secondGroupArr = [[NSMutableArray alloc] init];
    NSMutableDictionary *sfGroupInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:LZGDCommonLocailzableString(@"message_chat_file"),LEFTTITLE,@"",RIGHTTITLE,@"DisclosureIndicator",CellAccessory,@"showChatFile:",SELECTOR,@"",CUSTOMVIEW,nil];
    NSMutableDictionary *stickToTop = [[NSMutableDictionary alloc] initWithObjectsAndKeys:LZGDCommonLocailzableString(@"message_msg_sticktotop"),LEFTTITLE,@"",RIGHTTITLE,@"no",CellAccessory,@"",SELECTOR,@"sticktotop",CUSTOMVIEW,nil];
    NSMutableDictionary *noDisturb = [[NSMutableDictionary alloc] initWithObjectsAndKeys:LZGDCommonLocailzableString(@"message_msg_no_distrub"),LEFTTITLE,@"",RIGHTTITLE,@"no",CellAccessory,@"",SELECTOR,@"nodisturb",CUSTOMVIEW,nil];
//    NSMutableDictionary *sCHGroupInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:LZGDCommonLocailzableString(@"message_change_chatview_background"),LEFTTITLE, @"", RIGHTTITLE,@"DisclosureIndicator",CellAccessory,@"changeChatViewControllerBackgroundColor:",SELECTOR,@"",CUSTOMVIEW, nil];
    
    [secondGroupArr addObject:stickToTop];
    [secondGroupArr addObject:noDisturb];
    [secondGroupArr addObject:sfGroupInfo];
//    [secondGroupArr addObject:sCHGroupInfo];
   
//    //第三组 清空聊天记录
//    NSMutableArray *thirdGroupArr = [[NSMutableArray alloc] init];
//    NSMutableDictionary *fifthGroupInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:LZGDCommonLocailzableString(@"message_delete_chat_content"),LEFTTITLE,@"",RIGHTTITLE,@"DisclosureIndicator",CellAccessory,@"clearChatLog:",SELECTOR,@"",CUSTOMVIEW,nil];
//    [thirdGroupArr addObject:fifthGroupInfo];
    
    if(firstGroupArr.count>0){
        [self.tableDataSourceArr addObject:firstGroupArr];
    }
    if(secondGroupArr.count>0){
        [self.tableDataSourceArr addObject:secondGroupArr];
    }
//    if(thirdGroupArr.count>0){
//        [self.tableDataSourceArr addObject:thirdGroupArr];
//    }
}

/**
 *  返回按钮方法处理
 */
-(void)customDefaultBackButtonClick
{
//    /* 有新消息时，需要刷新聊天窗口 */
//    if( [[ImRecentDAL shareInstance] getImRecentNoReadMsgCountWithDialogID:_toUserModel.uid]>0){
//        for (UIViewController *controller in self.navigationController.viewControllers) {
//            if ([controller isKindOfClass:[ChatViewController class]]) {
//                ChatViewController *chatVC = (ChatViewController *)controller;
//                if([chatVC.dialogid isEqualToString:_toUserModel.uid]){
//                    NSMutableArray *newChatLogs = [[NSMutableArray alloc] init];
//                    if(chatVC.messages.count>0){
//                        XHMessage *xhMessage = [chatVC.messages objectAtIndex:chatVC.messages.count-1];
//                        ImChatLogModel *lastChatLogModel = xhMessage.imChatLogModel;
//                        
//                        newChatLogs = [[ImChatLogDAL shareInstance] getChatLogsWithDialogid:lastChatLogModel.dialogid datetime:lastChatLogModel.showindexdate];
//                    }
//                    if(newChatLogs.count>0){
//                        [chatVC loadInitChatLog:NO newBottomMsgs:newChatLogs];
//                    }
//                }
//            }
//        }
//    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 自定义处理

/**
 *  初始化自定义视图
 */
-(void)initCellCustomView:(NSMutableDictionary *)obj{
    UITableViewCell *cell = [obj objectForKey:@"cell"];
    NSMutableDictionary *itemDic = [obj lzNSMutableDictionaryForKey:@"data"];
    
    if([[itemDic objectForKey:CUSTOMVIEW] isEqualToString:@"faceicon"]){
        for(UIView *subView in [cell.contentView subviews]){
            [subView removeFromSuperview];
        }        
        [cell.contentView addSubview:[self gerUserIcon]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if ([[itemDic lzNSStringForKey:CUSTOMVIEW] isEqualToString:@"sticktotop"]) {
        NSString *left = [itemDic lzNSStringForKey:LEFTTITLE];
        UILabel *lblLeftTitle = [cell.contentView viewWithTag:101];
        lblLeftTitle.text = left;
        
        stickToTop = [[UISwitch alloc] initWithFrame:CGRectMake(LZ_SCREEN_WIDTH-50-15, 7*curRatio, (44-7*2)*curRatio, 10*curRatio)];
        [stickToTop addTarget:self action:@selector(stickToTopClick:) forControlEvents:UIControlEventValueChanged];
        
        BOOL isStickToTop = [[ImRecentDAL shareInstance] checkRecentModelIsStick:_toUserModel.uid];
        [stickToTop setOn:isStickToTop];
        for(UIView *subView in [cell.contentView subviews]){
            if([subView isKindOfClass:[UISwitch class]]){
                [subView removeFromSuperview];
            }
        }
        [cell.contentView addSubview:stickToTop];
    }
    else if ([[itemDic lzNSStringForKey:CUSTOMVIEW] isEqualToString:@"nodisturb"]) {
        NSString *left = [itemDic lzNSStringForKey:LEFTTITLE];
        UILabel *lblLeftTitle = [cell.contentView viewWithTag:101];
        lblLeftTitle.text = left;
        
        noDisturb = [[UISwitch alloc] initWithFrame:CGRectMake(LZ_SCREEN_WIDTH-50-15, 7*curRatio, (44-7*2)*curRatio, 10*curRatio)];
        [noDisturb addTarget:self action:@selector(noDisturbClick:) forControlEvents:UIControlEventValueChanged];
        
        BOOL isNoDisturb = [[ImRecentDAL shareInstance] checkRecentModelIsNoDisturb:_toUserModel.uid];
        [noDisturb setOn:isNoDisturb];
        for(UIView *subView in [cell.contentView subviews]){
            if([subView isKindOfClass:[UISwitch class]]){
                [subView removeFromSuperview];
            }
        }
        [cell.contentView addSubview:noDisturb];
    }

}

/**
 *  处理cell点击事件
 */
-(void)afterCellDidSelect:(NSMutableDictionary *)obj{
    NSMutableDictionary *itemDic = [obj lzNSMutableDictionaryForKey:@"data"];
    
    if([[itemDic objectForKey:CUSTOMVIEW] isEqualToString:@""]){
        
        NSString *selector = [itemDic lzNSStringForKey:SELECTOR];
        
        if( ![NSString isNullOrEmpty:selector] ){
            SEL sel = NSSelectorFromString(selector);
            if([self respondsToSelector:sel])
            {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"

                [self performSelector:sel withObject:nil];
                
                #pragma clang diagnostic pop
            }
        }
    }
}

#pragma mark - 构建头像区

-(UIView *)gerUserIcon{
    UIView *usersView = [[UIView alloc] initWithFrame:CGRectMake(26, 0, LZ_SCREEN_WIDTH-26*2, 120)];
    
    NSInteger pading = 7;
    NSInteger iconHeight = 50;
    
    /* 我的头像 */
    NSString *currentFace = [[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"face"];
    UIImageView *iconMy = nil;
    UILabel *lblMy = nil;
    UIImageView *iconTo = nil;
    UILabel *lblTo = nil;
    UIImageView *iconAdd = nil;
    UILabel *lblAdd = nil;
    
    BOOL isAddMySelf = NO;
    if ([currentFace isEqualToString:_toUserModel.face]) {
        isAddMySelf = YES;
    }
    
    if(isAddMySelf){
        iconMy = [[UIImageView alloc] initWithFrame:CGRectMake(pading, 30, iconHeight, iconHeight)];
        [iconMy loadFaceIcon:currentFace];
        iconMy.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesMy = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toMyClick:)];
        [iconMy addGestureRecognizer:gesMy];
        
        lblMy = [[UILabel alloc] initWithFrame:CGRectMake(iconMy.frame.origin.x, iconMy.frame.origin.y+iconHeight, iconHeight, 20)];
        lblMy.textAlignment = NSTextAlignmentCenter;
        lblMy.font = [UIFont systemFontOfSize:12];
        lblMy.text = [[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"username"];
        
        [usersView addSubview:iconMy];
        [usersView addSubview:lblMy];
    }


    if (![currentFace isEqualToString:_toUserModel.face]) {
    
        /* 对方头像 */
        if(isAddMySelf){
            iconTo = [[UIImageView alloc] initWithFrame:CGRectMake(iconMy.frame.origin.x+iconMy.frame.size.width+pading*2, 30, iconHeight, iconHeight)];
        } else {
            iconTo = [[UIImageView alloc] initWithFrame:CGRectMake(pading, 30, iconHeight, iconHeight)];
        }
        [iconTo loadFaceIcon:_toUserModel.face];
        iconTo.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesTo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toUserClick:)];
        [iconTo addGestureRecognizer:gesTo];
        
        lblTo = [[UILabel alloc] initWithFrame:CGRectMake(iconTo.frame.origin.x, iconTo.frame.origin.y+iconHeight, iconHeight, 20)];
        lblTo.textAlignment = NSTextAlignmentCenter;
        lblTo.font = [UIFont systemFontOfSize:12];
        lblTo.text = _toUserModel.username;
        
        [usersView addSubview:iconTo];
        [usersView addSubview:lblTo];
    
        /* 添加按钮 */
        iconAdd = [[UIImageView alloc] initWithFrame:CGRectMake(iconTo.frame.origin.x+iconTo.frame.size.width+pading*2, 30, iconHeight, iconHeight)];
    } else {
        if(isAddMySelf){
            iconAdd = [[UIImageView alloc] initWithFrame:CGRectMake(iconMy.frame.origin.x+iconMy.frame.size.width+pading*2, 30, iconHeight, iconHeight)];
        } else {
            iconAdd = [[UIImageView alloc] initWithFrame:CGRectMake(pading, 30, iconHeight, iconHeight)];
        }
    }
    iconAdd.image = [ImageManager LZGetImageByFileName:@"app_item_more_blue"];
    iconAdd.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesAdd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewUser)];
    [iconAdd addGestureRecognizer:gesAdd];
    
    lblAdd = [[UILabel alloc] initWithFrame:CGRectMake(iconAdd.frame.origin.x-pading, iconAdd.frame.origin.y+iconHeight, iconHeight+pading*2, 20)];
    lblAdd.textAlignment = NSTextAlignmentCenter;
    lblAdd.font = [UIFont systemFontOfSize:12];
    lblAdd.textColor = LZColor_Button_TintColor;
    lblAdd.text = LZGDCommonLocailzableString(@"message_add_new_member");
    
    [usersView addSubview:iconAdd];
    [usersView addSubview:lblAdd];
    
    return usersView;
}

#pragma mark - 事件处理

-(void)toMyClick:(id)sender{
    ContactFriendInfoViewController2 *friendInfoController=[ContactFriendInfoViewController2 controllerWithContactId:self.currentUid];
    [self.navigationController pushViewController:friendInfoController animated:YES];
}

-(void)toUserClick:(id)sender{
    ContactFriendInfoViewController2 *friendInfoController=[ContactFriendInfoViewController2 controllerWithContactId:_toUserModel.uid];
    [self.navigationController pushViewController:friendInfoController animated:YES];
}

/**
 *  添加人员
 */
-(void)addNewUser{
    DDLogVerbose(@"处理人员选框");
    
    ContactRootViewController2 *controller = [[ContactRootViewController2 alloc] initWithPageViewModel:ContactPageViewModeSelect];
    
    ContactSelectParamsModel *selectParams = [[ContactSelectParamsModel alloc] init];
    DDLogVerbose(@"33333333--------%@",_toUserModel.uid);
    selectParams.disableSelectedUsers = [[NSMutableArray alloc] initWithObjects:self.currentUid,_toUserModel.uid, nil];
    
    controller.selectParams = selectParams;
    controller.selectDelegate = self;
    
    [self modalShowController:controller];
}

/**
 *  显示群聊天文件
 */
-(void)showChatFile:(id)sender{
    [super showChatViewControllerFile:_toUserModel.uid];
}

/* 聊天框置顶 */
- (void)stickToTopClick:(id)sender {
    BOOL isButtonOn = [stickToTop isOn];
    NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
    [getData setObject:_toUserModel.uid forKey:@"recentid"];
    if (isButtonOn) {
        [getData setObject:@"1" forKey:@"state"];
    } else {
        [getData setObject:@"0" forKey:@"state"];
    }
    /* 判断网络是否连通 */
    if ([LZUserDataManager readIsConnectNetWork]) {
        [self showLoadingInfo];
        [self.appDelegate.lzservice sendToServerForGet:WebApi_Recent
                                             routePath:WebApi_Recent_SetRecentStick
                                          moduleServer:Modules_Message
                                               getData:getData
                                             otherData:nil];
    } else {
        [self showNetWorkConnectFail];
        [stickToTop setOn:!isButtonOn];
    }
}

- (void)noDisturbClick:(id)sender {
    BOOL isButtonOn = [noDisturb isOn];
    NSMutableDictionary *getData = [[NSMutableDictionary alloc] init];
    [getData setObject:_toUserModel.uid forKey:@"recentid"];
    
    if (isButtonOn) {
        [getData setObject:@"1" forKey:@"state"];
    } else {
        [getData setObject:@"0" forKey:@"state"];
    }
    /* 判断网络是否连通 */
    if ([LZUserDataManager readIsConnectNetWork]) {
        [self showLoadingInfo];
        [self.appDelegate.lzservice sendToServerForGet:WebApi_Recent
                                             routePath:WebApi_Recent_SetRecentDisturb
                                          moduleServer:Modules_Message
                                               getData:getData
                                             otherData:nil];
    } else {
        [self showNetWorkConnectFail];
        [noDisturb setOn:!isButtonOn];
    }
}
/**
 修改聊天界面背景
 */
- (void)changeChatViewControllerBackgroundColor:(id)sender {
    WEAKSELF
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    /* 控制显不显示视频文件 */
    imagePickerVc.allowPickingVideo = NO;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        NSString *savePath=[FilePathUtil getChatSendImageDicAbsolutePath];
        [[[TZImagePickerViewModel alloc] init] operateSelectedPhotos:photos assets:assets isSelectOriginalPhoto:isSelectOriginalPhoto savePath:savePath callBack:^(NSMutableArray *backArr) {            
            DDLogVerbose(@"选择一张图片");
            UploadFileModel *model = [backArr objectAtIndex:0];
            
            if ([weakSelf.changeDelegate respondsToSelector:@selector(setChangeChatViewControllerBackGround:)]) {
                [weakSelf.changeDelegate setChangeChatViewControllerBackGround:model.filePhysicalName];
            }
        }];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
/**
 *  清空聊天记录
 */
-(void)clearChatLog:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:LZGDCommonLocailzableString(@"message_isconfirm_delete") delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_cancel") otherButtonTitles:LZGDCommonLocailzableString(@"message_isdelete"), nil];
    alertView.tag = 1;
    [alertView show];
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
        {
            [self showLoadingWithText:LCProgressHUD_Show_Processing];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
               /* 发送webapi,清空聊天记录 */
                
               [NSThread sleepForTimeInterval:2];
                
                /* 删除本地数据库记录 */
                [[ImChatLogDAL shareInstance] deleteImChatLogWithDialogid:_toUserModel.uid];
                
                /* 刷新聊天窗口 */
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[ChatViewController class]]) {
                        ChatViewController *chatVC = (ChatViewController *)controller;
                        if([chatVC.dialogid isEqualToString:_toUserModel.uid]){
                            [chatVC loadInitChatLog:NO newBottomMsgs:nil];
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showSuccessHaveText];
                });
            });
            break;
        }
        default:
            break;
    }
}

#pragma mark - EventBus Delegate

/*
 事件代理
 */
- (void)eventOccurred:(NSString *)eventName event:(Event *)event
{
    [super eventOccurred:eventName event:event];
    if([eventName isEqualToString:EventBus_Chat_ImGroup_Add]){
        NSMutableDictionary *dataDic = [event eventData];
        NSString *send = [dataDic lzNSStringForKey:@"other"];
        if([send isEqualToString:@"ChatOneSettingController"]){
            NSString *contactid = [dataDic lzNSStringForKey:@"igid"];
//            [LCProgressHUD hide];
            [self createPushChatViewControllerContactType:Chat_ContactType_Main_ChatGroup DialogID:contactid];
//            [self.navigationController pushViewController:chatVC animated:YES];
//            [self dismissViewControllerAnimated:YES completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideLoading];
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            });
        }
    }
    else if ( [eventName isEqualToString:EventBus_Chat_ClearChatlog] ){
        /* 删除本地数据库记录 */
        [[ImChatLogDAL shareInstance] deleteImChatLogWithDialogid:_toUserModel.uid];
        
        /* 刷新聊天窗口 */
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ChatViewController class]]) {
                ChatViewController *chatVC = (ChatViewController *)controller;
                if([chatVC.dialogid isEqualToString:_toUserModel.uid]){
                    [chatVC loadInitChatLog:NO newBottomMsgs:nil];
                }
            }
        }
        [self showSuccessHaveText];
    }
    else if([eventName isEqualToString:EventBus_WebApi_SetRecentStick] ||
            [eventName isEqualToString:EventBus_WebApi_SetRecentOneDisturb]) {
        [self hideLoading];
    }
}

#pragma mark - 人员选择 delegate

/**
 *  确定人员选择
 */
-(void)contactSelectOK:(UIViewController *)controller selectedUserModels:(NSMutableArray *)selectedUserModels otherInfo:(NSMutableDictionary *)otherInfo{
    /* 创建群聊 */
    [self showLoadingWithText:LZGDCommonLocailzableString(@"message_handling")];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UserModel *currentUserModel = [[UserModel alloc] init];
    currentUserModel.uid = [[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"uid"];
    currentUserModel.username = [[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"username"];
    currentUserModel.face = [[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"face"];
    
    [selectedUserModels addObject:currentUserModel];
    /* 如果两个人不是同一个人，就添加进去 */
    if (![currentUserModel.uid isEqualToString:_toUserModel.uid]) {
        [selectedUserModels addObject:_toUserModel];
    }
    /* 只选择一个人 */
    if(selectedUserModels.count==2){
        UserModel *userModel = [selectedUserModels objectAtIndex:0];
        [self createPushChatViewControllerContactType:Chat_ContactType_Main_One DialogID:userModel.uid];
        //        [self.navigationController pushViewController:chatVC animated:YES];
        [self dismissViewControllerAnimated:true completion:nil];
        [self hideLoading];
        return;
    }
//    ImGroupModel *existGroupModel = [[[GroupViewModel alloc] init] checkGroupIsExist:selectedUserModels];
    
    /* 组群存在就不创建，不存在创建 */
    /*if (existGroupModel!=nil) {
        [self createPushChatViewControllerContactType:Chat_ContactType_Main_ChatGroup DialogID:existGroupModel.igid];
//        [self pushNewViewController:chatVC];
//        [self dismissViewControllerAnimated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideLoading];
//                [self dismissViewControllerAnimated:YES completion:nil];
            });
        });
    } else {*/
        [[[GroupViewModel alloc] init] createChatGroup:selectedUserModels other:@"ChatOneSettingController"];
//    }
}


#pragma mark - 更换头像

/**
 *  更新头像后判断是否需要刷新此视图
 */
-(void)checkIsNeedRefresTableViewForUid:(NSString *)uid{
    if([_toUserModel.uid isEqualToString:uid] || [self.currentUid isEqualToString:uid]){
        self.isNeedRefreshLZTableViewWhenViewAppear = YES;
    }
}
-(void)refreshWhenViewAppearForUpdateUid{
    UserModel *userModel = [[UserDAL shareInstance] getUserModelForNameAndFace:_toUserModel.uid];
    if(userModel!=nil){
        _toUserModel.username = userModel.username;
    }
    
    [self.mainTableView reloadData];
}

@end
