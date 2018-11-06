//
//  ChatCallBanListViewController.m
//  LeadingCloud
//
//  Created by gjh on 2018/7/23.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import "ChatCallBanListViewController.h"
#import "CommonFontModel.h"
#import "ImGroupUserDAL.h"
#import "UIImageView+Icon.h"
#import "ChatViewController.h"
#import "LZChatVideoModel.h"

@interface ChatCallBanListViewController () {
    
    CGFloat curRatio;
    BOOL isBanState; // 某人是否是禁言状态
    UIButton *banStateButton; //禁止状态按钮
    NSMutableArray *banUserArray; // 获取禁言的人的数组
    
    BOOL isAllBan; // 是否全员禁言
    UIButton *bottomButton;
    NSMutableArray *userarray;
}

@end

@implementation ChatCallBanListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /* 当加载该页面的时候，把控制器名称添加到数组中 */
    [self.appDelegate.lzSingleInstance.viewControllerArr addObject:[NSString stringWithUTF8String:object_getClassName(self)]];
    
    curRatio = [[CommonFontModel shareInstance]getHandeHeightRatio];
    [self setNavigationItemForRight:@"关闭"];
    
    /* 取消显示的加载圈 */
    self.tableView.notUseLoadingView = YES;
    /* 修改为正常状态 */
    [self.tableView setEditing:NO];
    // 初始不是禁言状态
    isBanState = NO;
    //底部创建一个全部禁言按钮
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(16, LZ_SCREEN_HEIGHT-52, LZ_SCREEN_WIDTH-32, 44);
    [bottomBtn setBackgroundImage:[UIImage imageNamed:@"login_btn_blue_default"] forState:UIControlStateNormal];
//     UIColorWithRGB(0, 147, 224)];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(allBanChatClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
    bottomButton = bottomBtn;
}

- (void)viewWillAppear:(BOOL)animated {
    
    userarray = [_dataDic lzNSMutableArrayForKey:@"userarray"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRightNavigationItemClicked) name:Chat_Group_CloseVC_Notice object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mutedNotice) name:Chat_Group_Muted_Notice object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(banListMemberUpdate:) name:Chat_Group_BanList_Notice object:nil];
    banUserArray = [[LZChatVideoModel shareInstance] getMuitCallArray];
    // 判断是否全员禁言
    isAllBan = YES;
    for (NSDictionary *tmpDic in banUserArray) {
        if (![[tmpDic lzNSNumberForKey:@"state"] boolValue]) {
            isAllBan = NO;
        }
    }
    if (isAllBan) {
        [bottomButton setTitle:@"取消全员静音" forState:UIControlStateNormal];
    } else {
        [bottomButton setTitle:@"全员静音" forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  控制器销毁的时候删除数组中的元素
 */
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Chat_Group_CloseVC_Notice object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Chat_Group_Muted_Notice object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Chat_Group_BanList_Notice object:nil];
    [self.appDelegate.lzSingleInstance.viewControllerArr removeObject:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (void)onRightNavigationItemClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return userarray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return LZ_TableViewCell_Height48*curRatio;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier=@"tableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UIImageView *cellImage = nil;
        UILabel *cellTitle = nil;
        /* 头像 */
        cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, (LZ_TableViewCell_Height48-LZ_Cell_IconWidthHeight32)/2*curRatio, LZ_Cell_IconWidthHeight32*curRatio, LZ_Cell_IconWidthHeight32*curRatio)];
        cellImage.tag = 101;
        cellImage.userInteractionEnabled = NO;
        [cell.contentView addSubview:cellImage];
        
        /* 右侧添加label */
        cellTitle = [[UILabel alloc] initWithFrame:CGRectMake(cellImage.frame.origin.x+cellImage.frame.size.width+15, (cellImage.frame.origin.y+5), LZ_SCREEN_WIDTH-(cellImage.frame.origin.x+cellImage.frame.size.width)-36-15, 18*curRatio)];
        CGFloat font1 = [[CommonFontModel shareInstance]getHandleFontFromSystemFont:15];
        cellTitle.font = [UIFont systemFontOfSize:font1];
        cellTitle.tag = 102;
        [cell.contentView addSubview:cellTitle];
        
    }
    UIImageView *imageView = [cell.contentView viewWithTag:101];
    UILabel *lblTitle = [cell.contentView viewWithTag:102];
    
    NSString *uid = [[userarray objectAtIndex:indexPath.row] lzNSStringForKey:@"uid"];
    NSString *agorauid = [[[userarray objectAtIndex:indexPath.row] lzNSNumberForKey:@"agorauid"] stringValue];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ImGroupUserModel *userModel = [[ImGroupUserDAL shareInstance] getGroupUserModelWithUid:uid];
        dispatch_async(dispatch_get_main_queue(), ^{
            lblTitle.text = [NSString isNullOrEmpty:userModel.username] ? [[userarray objectAtIndex:indexPath.row] lzNSStringForKey:@"name"] : userModel.username;
            [imageView loadFaceIcon:[[userarray objectAtIndex:indexPath.row] lzNSStringForKey:@"face"] isChangeToCircle:YES];
        });
    });
    
    UIButton *banStateBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    banStateBtn.frame=CGRectMake(0, 0, 26, 26*curRatio);
    // 获取禁言按钮的状态
    banUserArray = [[LZChatVideoModel shareInstance] getMuitCallArray];
    for (NSDictionary *tmpDic in banUserArray) {
        if ([[[tmpDic lzNSNumberForKey:@"uid"] stringValue] isEqualToString:agorauid]) {
            isBanState = [[tmpDic lzNSNumberForKey:@"state"] boolValue];
        }
    }
    if (!isBanState) {
        [banStateBtn setImage:[UIImage imageNamed:@"icon_record_default"] forState:UIControlStateNormal];
    } else {
        [banStateBtn setImage:[UIImage imageNamed:@"icon_record_on"] forState:UIControlStateNormal];
    }
    [banStateBtn addTarget:self action:@selector(onBanSpeechButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    banStateBtn.tag=indexPath.row;
    cell.accessoryView=banStateBtn;
    banStateButton = banStateBtn;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 *  在Cell上的【添加】按钮点击的时候
 *  @param button
 */
-(void)onBanSpeechButtonClick:(UIButton *)button{
    /* 判断网络是否连通 */
    if([LZUserDataManager readIsConnectNetWork]){
        [self showLoadingWithText:LZGDCommonLocailzableString(@"contact_please_hold_on")];
        
        // 点击的这个人的 uid
        NSString *banUid = [[userarray objectAtIndex:button.tag] lzNSStringForKey:@"uid"];
        NSString *agorauid = [[[userarray objectAtIndex:button.tag] lzNSNumberForKey:@"agorauid"] stringValue];
        NSNumber *contacttype = [_dataDic lzNSNumberForKey:@"contacttype"];
        NSString *dialogid = [_dataDic lzNSStringForKey:@"dialogid"];
        NSString *roomname = [_dataDic lzNSStringForKey:@"roomname"];
        
        // 获取禁言按钮的状态
        banUserArray = [[LZChatVideoModel shareInstance] getMuitCallArray];
        for (NSDictionary *tmpDic in banUserArray) {
            if ([[[tmpDic lzNSNumberForKey:@"uid"] stringValue] isEqualToString:agorauid]) {
                isBanState = [[tmpDic lzNSNumberForKey:@"state"] boolValue];
            }
        }
        // type: 1禁言 2取消禁言
        // isall 0:禁言某一个人 1:全部禁言|取消禁言
        // uid: isall为0时，被禁言者的id
        NSString *type = isBanState ? @"2" : @"1";
        NSDictionary *bodyDic = @{@"type":type, @"isall":@"0", @"uid":banUid};
        // 禁言的通知类型 handlertype 定为 message.lzchat.call.speech 怎么样，然后body里面定义几个属性区分具体行为
        ChatViewController *chat = [self createChatViewControllerContactType:[contacttype integerValue] DialogID:dialogid];
        [chat sendVideoCallForGroup:Chat_Group_Call_State_Speech userArr:userarray channelid:roomname other:bodyDic];
        
        // 更改按钮的状态
//        if (isBanState) {
//            [button setImage:[UIImage imageNamed:@"icon_record_default"] forState:UIControlStateNormal];
//        } else {
//            [button setImage:[UIImage imageNamed:@"icon_record_on"] forState:UIControlStateNormal];
//        }
    } else {
        [self showNetWorkConnectFail];
    }
}
// 全员禁言
- (void)allBanChatClick:(UIButton *)button {
    /* 判断网络是否连通 */
    if([LZUserDataManager readIsConnectNetWork]){
        [self showLoadingWithText:LZGDCommonLocailzableString(@"contact_please_hold_on")];
        
        NSNumber *contacttype = [_dataDic lzNSNumberForKey:@"contacttype"];
        NSString *dialogid = [_dataDic lzNSStringForKey:@"dialogid"];
        NSString *roomname = [_dataDic lzNSStringForKey:@"roomname"];
        
        // type: 1禁言 2取消禁言
        // isall 0:禁言某一个人 1:全部禁言|取消禁言
        // uid: isall为0时，被禁言者的id
        NSString *type = isAllBan ? @"2" : @"1";
        NSDictionary *bodyDic = @{@"type":type, @"isall":@"1"};
        // 禁言的通知类型 handlertype 定为 message.lzchat.call.speech 怎么样，然后body里面定义几个属性区分具体行为
        ChatViewController *chat = [self createChatViewControllerContactType:[contacttype integerValue] DialogID:dialogid];
        [chat sendVideoCallForGroup:Chat_Group_Call_State_Speech userArr:userarray channelid:roomname other:bodyDic];
//        banUserArray = [[LZChatVideoModel shareInstance] getMuitCallArray];
//        // 判断是否全员禁言
//        for (NSDictionary *tmpDic in banUserArray) {
//            if (![[tmpDic lzNSNumberForKey:@"state"] boolValue]) {
//                isAllBan = NO;
//            }
//        }
        
        [self hideLoading];
    } else {
        [self showNetWorkConnectFail];
    }
}

/* 禁言成功回调 */
- (void)mutedNotice {
    [self.tableView reloadData];
    [self hideLoading];
    banUserArray = [[LZChatVideoModel shareInstance] getMuitCallArray];
    // 判断是否全员禁言
    isAllBan = YES;
    for (NSDictionary *tmpDic in banUserArray) {
        if (![[tmpDic lzNSNumberForKey:@"state"] boolValue]) {
            isAllBan = NO;
        }
    }
    // 更改按钮的状态
    if (isAllBan) {
        [bottomButton setTitle:@"取消全员静音" forState:UIControlStateNormal];
        isAllBan = YES;
    } else {
        [bottomButton setTitle:@"全员静音" forState:UIControlStateNormal];
        isAllBan = NO;
    }
}
/* 更新列表成员 */
- (void)banListMemberUpdate:(NSNotification *)noti {
    NSDictionary *dic = noti.userInfo;
    NSArray *realchatusers = dic[@"realchatusers"];
    NSString *realchatStr = [realchatusers componentsJoinedByString:@","];
    NSMutableArray *newuserArr = [NSMutableArray array];
    if (realchatusers.count > userarray.count) {
        // 加人
        for (NSDictionary *tmpDic in dic[@"userarray"]) {
            if (![[tmpDic lzNSStringForKey:@"uid"] isEqualToString:[AppUtils GetCurrentUserID]]) {
                [newuserArr addObject:tmpDic];
            }
        }
    } else {
        // 减人
        for (NSDictionary *tmpDic in userarray) {
            if ([realchatStr containsString:[[tmpDic lzNSNumberForKey:@"agorauid"] stringValue]]) {
                [newuserArr addObject:tmpDic];
            }
        }
    }
    userarray = newuserArr;
    [self.tableView reloadData];
}

@end
