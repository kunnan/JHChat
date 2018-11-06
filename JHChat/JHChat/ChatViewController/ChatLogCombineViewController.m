//
//  ChatLogCombineViewController.m
//  LeadingCloud
//
//  Created by gjh on 2018/4/18.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import "ChatLogCombineViewController.h"
#import "CommonFontModel.h"
#import "ImChatLogDAL.h"
#import "XHMessageTableViewCell.h"
#import "AppDateUtil.h"
#import "NSDictionary+DicSerial.h"
#import "ScanFileViewController.h"
#import "LZDisplayLocationViewController.h"
#import "NSString+SerialToArray.h"
#import "GalleryImageViewModel.h"
#import "PhotoBrowserViewModel.h"
#import "LZMessageTextView.h"
#import "LZImageUtils.h"
#import "ModuleServerUtil.h"
#import "LZScanResultViewModel.h"
#import "WebViewController.h"

@interface ChatLogCombineViewController (){
    CGFloat curRatio;
    NSMutableArray <id<XHMessageModel>> *messageModelArr;
    
    /* 图片容器 */
    NSMutableArray *photoBrowserArr;
    /* 链接电话号码 */
    NSString *linkMobile;
    /* 链接电子邮箱 */
    NSString *linkEMail;
}

@end

@implementation ChatLogCombineViewController

- (void)viewDidLoad {
    /* 当加载该页面的时候，把控制器名称添加到数组中 */
    [self.appDelegate.lzSingleInstance.viewControllerArr addObject:[NSString stringWithUTF8String:object_getClassName(self)]];
    [super viewDidLoad];
    [self initilzer];
    [self setPopMenuItems];
    
    [self addCustomDefaultBackButton:LZGDCommonLocailzableString(@"common_back")];
    curRatio = [[CommonFontModel shareInstance]getHandeHeightRatio];
    self.transmitDelegate = self;
    self.transmitDataSource = self;
}

- (void)dealloc {
    [self.appDelegate.lzSingleInstance.viewControllerArr removeObject:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)initilzer {
    [self messages];
    // 初始化message tableView
    XHMessageTableView *messageTableView = [[XHMessageTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    messageTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    messageTableView.dataSource = self;
    messageTableView.delegate = self;
//    messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    messageTableView.height -= LZ_TOOLBAR_HEIGHT;
    messageTableView.tableFooterView = [[UIView alloc] init];
    messageTableView.backgroundColor = UIColorWithRGB(246, 246, 246);
    
    [self.view addSubview:messageTableView];
    [self.view sendSubviewToBack:messageTableView];
    _messageTableView = messageTableView;
    
}

/**
 *  设置长按弹出项
 */
- (void)setPopMenuItems{
    NSArray *popMenuArr = [[NSArray alloc] init];
    if ([NSString isNullOrEmpty:_toGroupModel.groupResourceModel.rpid] || _toGroupModel.groupResourceModel == nil) {
        popMenuArr = [[NSArray alloc] initWithObjects:LZGDCommonLocailzableString(@"message_copy"),
                      LZGDCommonLocailzableString(@"message_savetocloud"),
                      nil];
    } else {
        popMenuArr = [[NSArray alloc] initWithObjects:LZGDCommonLocailzableString(@"message_copy"),
                      LZGDCommonLocailzableString(@"message_savetocloud"),
                      _toGroupModel.groupResourceModel.buttontitle,
                      nil];
    }
    [[XHConfigurationHelper appearance] setupPopMenuTitles:popMenuArr];
}
#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messages.count;
}
#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *message = [self.transmitDataSource transmitMessageForRowAtIndexPath:indexPath];
    
    id <XHMessageModel> messageModel = [self.transmitDataSource transmitMessageModelForRowAtIndexPath:indexPath];

    CGFloat calculateCellHeight = 0;

    /* 根据不同的消息类型获取消息高度 */
    if(calculateCellHeight == 0){
        calculateCellHeight = [self calculateCellHeightWithMessage:message atIndexPath:indexPath messageModel:messageModel];
    }
    return calculateCellHeight;
}

- (CGFloat)calculateCellHeightWithMessage:(NSMutableDictionary *)message atIndexPath:(NSIndexPath *)indexPath messageModel:(id<XHMessageModel>)messageModel{
    CGFloat cellHeight = 0;
    NSString *handlertype = [message lzNSStringForKey:@"handlertype"];
    /* 文本 */
    if ([handlertype isEqualToString:Handler_Message_LZChat_LZMsgNormal_Text]) {
        CGSize textSize = [ChatLogMsgBubbleView neededSizeForCombineChatlogText:message];
        cellHeight = textSize.height+XH_UserNameLabelHeight+15;
    }
    /* 图片 */
    else if ([handlertype isEqualToString:Handler_Message_LZChat_Image_Download]) {
        
        cellHeight = messageModel.imChatLogModel.imClmBodyModel.fileModel.smalliconheight+45.0f;
    }
    /* 地理位置 */
    else if ([handlertype isEqualToString:Handler_Message_LZChat_Geolocation] ||
             [handlertype isEqualToString:Handler_Message_LZChat_File_Download] ||
             [handlertype isEqualToString:Handler_Message_LZChat_Micro_Video]) {
        cellHeight = 120;
    }
    else if ([handlertype isEqualToString:Handler_Message_LZChat_UrlLink]) {
        cellHeight = 180;
    }
    /* 合并消息 */
    else if ([handlertype isEqualToString:Handler_Message_LZChat_ChatLog]) {
        if ([message lzNSDictonaryForKey:@"body"].count == 0 || [message lzNSDictonaryForKey:@"body"]==nil) {
            // 获取实际气泡的大小
            CGSize textSize = [ChatLogMsgBubbleView neededSizeForCombineChatlogText:message];
            cellHeight = textSize.height+XH_UserNameLabelHeight+15;
        } else {
            CGSize bubbleSize = [XHMessageBubbleView getBubbleFrameWithMessage:messageModel];
            cellHeight = 50+bubbleSize.height;
        }        
    }
    else if (messageModel.messageMediaType == XHBubbleMessageMediaCustomMsg) {
        CGSize bubbleSize = [XHMessageBubbleView getBubbleFrameWithMessage:messageModel];
        cellHeight = 50+bubbleSize.height;
    }
        
    return cellHeight;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSMutableDictionary *premsg = indexPath.row > 0 ? _messages[indexPath.row-1] : nil;
    NSMutableDictionary *message = [self.transmitDataSource transmitMessageForRowAtIndexPath:indexPath];
    
    id <XHMessageModel> messageModel = [self.transmitDataSource transmitMessageModelForRowAtIndexPath:indexPath];
    static NSString *cellIdentifier = @"ChatLogCombineTableViewCell";
    
    ChatLogCombineTableViewCell *chatLogCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!chatLogCell) {
        chatLogCell = [[ChatLogCombineTableViewCell alloc] initWithMessage:message reuseIdentifier:cellIdentifier messageModel:messageModel contactType:_contactType];
    }
    chatLogCell.delegate = self;
    chatLogCell.indexPath = indexPath;
    [chatLogCell configureCellWithMessage:message Premsg:premsg messageModel:messageModel];
    [chatLogCell setBackgroundColor:tableView.backgroundColor];
    chatLogCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return chatLogCell;
}
/**
 *  Cell点击后事件处理
 *
 *  @param message              消息
 *  @param indexPath            序号
 *  @param messageTableViewCell cell
 */
- (void)multiMediaCombineMessageDidSelectedOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(ChatLogCombineTableViewCell *)chatLogCombineTableViewCell {
    NSMutableDictionary *messageDic = [self.transmitDataSource transmitMessageForRowAtIndexPath:indexPath];
//    id <XHMessageModel> messageModel = [self.transmitDataSource transmitMessageModelForRowAtIndexPath:indexPath];
    
    NSString *handlertype = [messageDic lzNSStringForKey:@"handlertype"];
    
    if ([handlertype isEqualToString:Handler_Message_LZChat_Image_Download]) {
        DDLogVerbose(@"浏览图片");
        photoBrowserArr = [NSMutableArray arrayWithObject:message.imChatLogModel];
        
        /* 获取当前图片的index值 */
        int theIndex = -1;
        for (int i=0;i<[photoBrowserArr count];i++) {
            ImChatLogModel *chatLogModel = [photoBrowserArr objectAtIndex:i];
            if([message.imChatLogModel.msgid isEqualToString:chatLogModel.msgid]
               || (![NSString isNullOrEmpty:message.imChatLogModel.clienttempid]
                   && ![NSString isNullOrEmpty:chatLogModel.clienttempid]
                   && [message.imChatLogModel.clienttempid isEqualToString:chatLogModel.clienttempid] ) ){
                   theIndex = i;
               }
        }
        if(theIndex==-1){
            return;
        }
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        /* Show action button to allow sharing, copying, etc (defaults to YES) */
        browser.displayActionButton = YES;
        /* Whether to display left and right nav arrows on toolbar (defaults to NO) */
        browser.displayNavArrows = NO;
        /* Whether selection buttons are shown on each image (defaults to NO) */
        browser.displaySelectionButtons = NO;
        /* Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO) */
        browser.alwaysShowControls = NO;
        /* Images that almost fill the screen will be initially zoomed to fill (defaults to YES) */
        browser.zoomPhotosToFill = NO;
        /* Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES) */
        browser.enableGrid = YES;
        /* Whether to start on the grid of thumbnails instead of the first photo (defaults to NO) */
        browser.startOnGrid = NO;
        browser.enableSwipeToDismiss = NO;
        /* Auto-play first video */
        browser.autoPlayOnAppear = NO;
        
        AlertBlock alert = ^ {
            /* 从聊天界面进入的图片浏览 */
            NSMutableArray *customUIAlertActionArray = [[NSMutableArray alloc] init];
            [customUIAlertActionArray addObject:MWPhoto_AlertAction_SendToUser];
            [customUIAlertActionArray addObject:MWPhoto_AlertAction_SaveImage];
            [customUIAlertActionArray addObject:MWPhoto_AlertAction_IdentifyQrCode];
            [customUIAlertActionArray addObject:MWPhoto_AlertAction_SaveToDisk];
            [customUIAlertActionArray addObject:MWPhoto_AlertAction_Share];
            
            browser.customUIAlertActionArray = customUIAlertActionArray;
        };
        browser.alertBlock = alert;
        /* 单击模式 (YES开启) */
        browser.isClickExit = YES;
        [browser setCurrentPhotoIndex:theIndex];
        
        [self.navigationController pushViewController:browser animated:YES];
    }
    else if ([handlertype isEqualToString:Handler_Message_LZChat_Geolocation]) {
        LZDisplayLocationViewController *disLocationVC=[[LZDisplayLocationViewController alloc]init];
        disLocationVC.zoomLevel=message.imChatLogModel.imClmBodyModel.bodyModel.geozoom;
        disLocationVC.coordinate=[message.location coordinate];
        //            disLocationVC.name=[message geolocations];
        disLocationVC.name = message.imChatLogModel.imClmBodyModel.bodyModel.geoaddress;
        disLocationVC.address = message.imChatLogModel.imClmBodyModel.bodyModel.geodetailposition;
        [self.navigationController pushViewController:disLocationVC animated:YES];
    }
    else if ([handlertype isEqualToString:Handler_Message_LZChat_File_Download]) {
        ScanFileViewController *scan = [[ScanFileViewController alloc] init];
        if( [message.imChatLogModel.imClmBodyModel.bodyModel.isresource isEqualToString:@"true"] ){
            scan.scanFileResId = message.imChatLogModel.imClmBodyModel.bodyModel.rid;
            scan.scanFileRVersion = message.imChatLogModel.imClmBodyModel.bodyModel.rversion;
            scan.scanFileExpId = message.imChatLogModel.imClmBodyModel.bodyModel.fileid;
            scan.scanFileRtype = 3;
        }
        else {
            scan.scanFileExpId = message.imChatLogModel.imClmBodyModel.bodyModel.fileid;
            scan.scanFilePhysicalName = message.imChatLogModel.imClmBodyModel.fileModel.smallfileclientname;
        }
        scan.scanFileName = message.imChatLogModel.imClmBodyModel.bodyModel.name;
        scan.scanFileSize = message.imChatLogModel.imClmBodyModel.bodyModel.size;
        if([message.imChatLogModel.imClmBodyModel.from isEqualToString:[AppUtils GetCurrentUserID]]){
            scan.scanFileAbsolutePath = [FilePathUtil getChatSendImageDicAbsolutePath];
            scan.scanFileSmallAbsolutePath = [FilePathUtil getChatSendImageSmallDicAbsolutePath];
            scan.scanFileReleatePath = [FilePathUtil getChatSendImageDicRelatePath];
        }
        else {
            scan.scanFileAbsolutePath = [FilePathUtil getChatRecvImageDicAbsolutePath];
            scan.scanFileSmallAbsolutePath = [FilePathUtil getChatRecvImageSmallDicAbsolutePath];
            scan.scanFileReleatePath = [FilePathUtil getChatRecvImageDicRelatePath];
        }
        scan.Vc = self;
        scan.isNotShowRightPopItem = YES;
        scan.customPopTitleArray = [NSMutableArray arrayWithObjects:ScanFile_PopItemTitle_FileSendPerson,ScanFile_PopItemTitle_FileSaveNetDisk,ScanFile_PopItemTitle_FileThirdOpen, nil];
        
        [scan lookFileForScanFileWithController:self];
    }
    else if ([handlertype isEqualToString:Handler_Message_LZChat_ChatLog]) {
        if ([messageDic lzNSDictonaryForKey:@"body"].count == 0 || [messageDic lzNSDictonaryForKey:@"body"]==nil) {
            
        } else {
            NSDictionary *bodyDic = [[message.imChatLogModel.body seriaToDic] lzNSDictonaryForKey:@"body"];
            ChatLogCombineViewController *chatlogCombineVC = [[ChatLogCombineViewController alloc] init];
            chatlogCombineVC.title = [bodyDic lzNSStringForKey:@"title"];
            NSMutableArray *msgArr = [[bodyDic lzNSStringForKey:@"chatlog"] serialToArr];
            chatlogCombineVC.messages = msgArr;
            chatlogCombineVC.chatViewModel = _chatViewModel;
            chatlogCombineVC.toGroupModel = _toGroupModel;
            [self.navigationController pushViewController:chatlogCombineVC animated:YES];
        }
        
    }
    else if ([handlertype isEqualToString:Handler_Message_LZChat_Micro_Video]) {
        /* 点击播放视频 */
//        NSString *videoID = [[message.imChatLogModel.body seriaToDic] lzNSStringForKey:@"videofileid"];
        NSString *videoID = [[[message.imChatLogModel.body seriaToDic] lzNSDictonaryForKey:@"body"] lzNSStringForKey:@"videofileid"];
        NSString *name = message.imChatLogModel.imClmBodyModel.fileModel.smallvideoclientname;
        if ([NSString isNullOrEmpty:name]) {
            name = [NSString stringWithFormat:@"%@.mp4",videoID];
        }
        // 发送失败的时候查看
        if ([NSString isNullOrEmpty:videoID]) {
            NSString *tempfileid =  [name substringToIndex:[name rangeOfString:@"." options:NSBackwardsSearch].location];
            videoID = tempfileid;
        }
        NSString *savePath = @"";
        NSString *relatePath = @"";
        if([message.imChatLogModel.imClmBodyModel.from isEqualToString:[AppUtils GetCurrentUserID]]){
            savePath=[FilePathUtil getChatSendImageDicAbsolutePath];
            relatePath = [FilePathUtil getChatSendImageDicRelatePath];
        } else {
            savePath=[FilePathUtil getChatRecvImageDicAbsolutePath];
            relatePath = [FilePathUtil getChatRecvImageDicRelatePath];
        }
        DLog(@"message : %@", message.videoConverPhoto);
        ScanFileViewController *scan = [[ScanFileViewController alloc] init];
        scan.scanFileExpId = videoID; /* 视频id */
        scan.scanFileName = name;
        scan.scanFilePhysicalName = name;
        scan.scanFileAbsolutePath = savePath;
        scan.isResItem= YES;
        scan.scanFileSize = [[[message.imChatLogModel.body seriaToDic] objectForKey:@"size"] longLongValue];
        scan.scanFileSmallAbsolutePath = [FilePathUtil getPostFileSmallDownloadDicAbsolutePath];
        scan.scanFileReleatePath = relatePath;
        scan.Vc = self;
        
        [scan lookFileForScanFileWithController:self];
    }
    else if (message.messageMediaType == XHBubbleMessageMediaTypeUrl) {
        NSString *linkStr = message.imChatLogModel.imClmBodyModel.bodyModel.urlstr;
        NSString *resultStr = [LZUtils getDomainUrlTrunHostUrl:linkStr].lowercaseString;
        
        NSString *resultHost = [LZUtils getUrlWithIP:resultStr];
        NSString *server = [LZUtils getUrlWithIP:[ModuleServerUtil GetH5ServerWithModule:Modules_H5_Default]].lowercaseString;
        if([resultHost isEqualToString:server]&&([resultStr rangeOfString:@"/t/"].location!=NSNotFound || [resultStr rangeOfString:@"/r/"].location!=NSNotFound )){
            LZScanResultViewModel *scanResultViewModel = [[LZScanResultViewModel alloc] init];
            scanResultViewModel.scanViewController = self;
            [scanResultViewModel getScanResultWithDataContext:linkStr webViewBlock:nil];
        }else{
            WebViewController *webViewController = [[WebViewController alloc] init];
            webViewController.url = linkStr;
            webViewController.isShowNavRightButton = YES;
            [self pushNewViewController:webViewController];
        }
    }
    else if (message.messageMediaType == XHBubbleMessageMediaCustomMsg) {
        
        [chatLogCombineTableViewCell.combineMessageBubbleView.lzCustomBubbleView clickCustomBubbleViewAction:message controller:self];
    }
}

/**
 *  双击文本消息，触发这个回调
 *
 *  @param message   被操作的目标消息Model
 *  @param indexPath 该目标消息在哪个IndexPath里面
 */
- (void)didDoubleSelectedOnTextMessage:(id <XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath{
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeText:{
            [self.view endEditing:YES];
            [LZMessageTextView showPopoverAt:self.view messageText:message.text];
            break;
        }
        default:
            break;
    }
}

/**
 *  BubbleView 中的链接,新的代理方法
 */
- (void)newClickBubbleViewSomeLink:(id <XHMessageModel>)message linkClick:(NSString*)linkStr linkType:(NSString *)linkType {
    
    DDLogVerbose(@"点击（%@）链接地址----%@",linkType,linkStr);
    
    /* 链接地址 */
    if([linkType isEqualToString:HBMatchParserLinkTypeUrl]){
        
        [self clickUrlLinkEvent:linkStr];
    }
    /* 电话号码 */
    else if( [linkType isEqualToString:HBMatchParserLinkTypeMobie] ){
        linkMobile = linkStr;
        NSString *title = [NSString stringWithFormat:@"%@%@",linkStr,LZGDCommonLocailzableString(@"message_maybe_number")];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_cancel") destructiveButtonTitle:nil otherButtonTitles:LZGDCommonLocailzableString(@"message_call"),LZGDCommonLocailzableString(@"message_addto_contact"), nil];
        actionSheet.tag=2000;
        [actionSheet showInView:self.view];
    }
    /* 邮箱 */
    else if ([linkType isEqualToString:HBMatchParserLinkTypeEMail]) {
        linkEMail = linkStr;
        NSString *title = [NSString stringWithFormat:@"向%@发送邮件",linkStr];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_cancel") destructiveButtonTitle:nil otherButtonTitles:@"使用默认邮件账户", nil];
        actionSheet.tag = 9000;
        [actionSheet showInView:self.view];
    }
}
/**
 点击urllink类型的消息事件
 
 @param linkStr
 */
- (void)clickUrlLinkEvent:(NSString *)linkStr {
    NSString *resultStr = [LZUtils getDomainUrlTrunHostUrl:linkStr].lowercaseString;

    NSString *resultHost = [LZUtils getUrlWithIP:resultStr];
    NSString *server = [LZUtils getUrlWithIP:[ModuleServerUtil GetH5ServerWithModule:Modules_H5_Default]].lowercaseString;
    if([resultHost isEqualToString:server]&&([resultStr rangeOfString:@"/t/"].location!=NSNotFound || [resultStr rangeOfString:@"/r/"].location!=NSNotFound )){
        LZScanResultViewModel *scanResultViewModel = [[LZScanResultViewModel alloc] init];
        scanResultViewModel.scanViewController = self;
        //            [scanResultViewModel setDealWithScanResult:linkStr];
        [scanResultViewModel getScanResultWithDataContext:linkStr webViewBlock:nil];
        
    }else{
        WebViewController *webViewController = [[WebViewController alloc] init];
        webViewController.url = linkStr;
        webViewController.isShowNavRightButton = YES;
        [self pushNewViewController:webViewController];
    }
}
- (void)eventOccurred:(NSString *)eventName event:(Event *)event {
    
}

- (NSMutableArray *)messages {
    if (!_messages) {
        _messages = [[NSMutableArray alloc] initWithCapacity:0];
    }
    messageModelArr = [NSMutableArray array];
    for (NSMutableDictionary *tmpDic in _messages) {
        NSString *msgid = [tmpDic lzNSStringForKey:@"msgid"];
        NSString *clienttempid = [tmpDic lzNSStringForKey:@"clienttempid"];
        ImChatLogModel *chatlogModel = [[ImChatLogDAL shareInstance] getChatLogModelWithMsgid:msgid orClienttempid:clienttempid];
        if (chatlogModel == nil) {
            /* 字典转model */
            chatlogModel = [[ImChatLogModel alloc] init];
//            NSString *handlerType = [resultDic lzNSStringForKey:@"handlertype"];
//            NSString *tmpStr = [[resultDic lzNSDictonaryForKey:@"body"] lzNSStringForKey:@"chatlog"];
//            NSString *title = [[resultDic lzNSDictonaryForKey:@"body"] lzNSStringForKey:@"title"];
//
//            if([handlerType isEqualToString:@"message.lzchat.chatlog"]){
//                [resultDic removeObjectForKey:@"body"];
//            }
            
//            [resultDic setObject:tmpStr forKey:@"body"];
//            if ([[resultDic objectForKey:@"body"] isKindOfClass:[NSDictionary class]]) {
//                NSString *tmpStr = @"";
//                tmpStr = [tmpStr dictionaryToJson:[resultDic lzNSDictonaryForKey:@"body"]];
//                [resultDic setObject:tmpStr forKey:@"body"];
//            }
            NSMutableDictionary *resultDic = [tmpDic mutableCopy];
            ImChatLogBodyModel *chatBodyModel = [[ImChatLogBodyModel alloc] init];
            if ([[tmpDic lzNSStringForKey:@"handlertype"] isEqualToString:Handler_Message_LZChat_Image_Download]) {
                ImChatLogBodyFileModel *fileModel = [[ImChatLogBodyFileModel alloc] init];
                
                fileModel.smalliconclientname = [NSString stringWithFormat:@"%@.jpg", [[tmpDic lzNSDictonaryForKey:@"body"] lzNSStringForKey:@"fileid"]];
                CGSize smallSize = [LZImageUtils CalculateSmalSize:CGSizeMake([[[tmpDic lzNSDictonaryForKey:@"body"] lzNSNumberForKey:@"width"] floatValue], [[[tmpDic lzNSDictonaryForKey:@"body"] lzNSNumberForKey:@"height"] floatValue]) maxSize:CHATVIEW_IMAGE_Height_Width_Max minSize:CHATVIEW_IMAGE_Height_Width_Min];
                fileModel.smalliconwidth = smallSize.width;
                fileModel.smalliconheight = smallSize.height;
                NSMutableDictionary *dic = [fileModel createDictionayFromModelProperties];
                [resultDic setObject:[dic dicSerial] forKey:@"fileinfo"];
            }
            [chatBodyModel serializationWithDictionary:resultDic];
            
            chatlogModel.msgid = chatBodyModel.msgid;
            chatlogModel.clienttempid = chatBodyModel.clienttempid;
            chatlogModel.from = chatBodyModel.from;
            chatlogModel.fromtype = chatBodyModel.fromtype;
            chatlogModel.to = chatBodyModel.to;
            chatlogModel.totype = chatBodyModel.totype;
            chatlogModel.body = [resultDic dicSerial];
            chatlogModel.handlertype = chatBodyModel.handlertype;
            
//            [chatlogModel serializationWithDictionary:resultDic];
//            if([handlerType isEqualToString:@"message.lzchat.chatlog"]){
//                ImChatLogBodyInnerModel *imChatLogBodyModel = [[ImChatLogBodyInnerModel alloc] init];
////                imChatLogBodyModel.chatlog = [tmpStr serialToArr]
////
////                chatlogModel.imClmBodyModel.bodyModel.chatlog = [tmpStr serialToArr];
////                chatlogModel.imClmBodyModel.bodyModel.title = title;
//            }
        }
        XHMessage *message = [_chatViewModel convertChatLogModelToXHMessage:chatlogModel];
        [messageModelArr addObject:message];
    }
    return _messages;
}

#pragma mark - XHMessageTableViewController DataSource

- (NSMutableDictionary *)transmitMessageForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _messages[indexPath.row];
}

- (id <XHMessageModel>)transmitMessageModelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return messageModelArr[indexPath.row];
}
#pragma mark - 图片浏览 Delegate

#pragma mark - MWPhotoBrowserDelegate

/**
 *  重新设置NavigationController
 */
- (BOOL)lzPhotoBrowserSetNavigationController:(MWPhotoBrowser *)photoBrowser{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    return YES;
}
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return photoBrowserArr.count;
    return 0;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < photoBrowserArr.count) {
        
        DDLogVerbose(@"------------------%ld",(unsigned long)index);
        
        ImChatLogModel *chatLogModel = (ImChatLogModel *)[photoBrowserArr objectAtIndex:index];
        
        NSString *smallFolderPath = @"";
        NSString *oriFolderPath = @"";
        /* 文件夹路径 */
        if([chatLogModel.imClmBodyModel.from isEqualToString:[AppUtils GetCurrentUserID]]){
            smallFolderPath = [FilePathUtil getChatSendImageSmallDicAbsolutePath];
            oriFolderPath = [FilePathUtil getChatSendImageDicAbsolutePath];
        } else {
            smallFolderPath = [FilePathUtil getChatRecvImageSmallDicAbsolutePath];
            oriFolderPath = [FilePathUtil getChatRecvImageDicAbsolutePath];
        }
        
        /* 客户端文件名称 */
        NSString *clientImageName = chatLogModel.imClmBodyModel.fileModel.smalliconclientname;
        NSString *smallImagePath = [NSString stringWithFormat:@"%@%@",smallFolderPath,clientImageName];
        NSString *oriImagePath = [NSString stringWithFormat:@"%@%@",oriFolderPath,clientImageName];
        
        /* url路径 */
        NSString *smallThumbnailUrl = [GalleryImageViewModel GetGalleryThumbnailImageUrlFileId:chatLogModel.imClmBodyModel.bodyModel.fileid size:@"200X200"];
        NSString *oriThumbnailUrl = [GalleryImageViewModel GetGalleryOriImageUrlFileId:chatLogModel.imClmBodyModel.bodyModel.fileid];
        
        /* 添加长按时所需参数 */
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        [dic setValue:chatLogModel.imClmBodyModel.bodyModel.name forKey:@"fileshowname"];
        [dic setValue:chatLogModel.imClmBodyModel.fileModel.smalliconclientname forKey:@"filephysicalname"];
        [dic setValue:chatLogModel.imClmBodyModel.msgid forKey:@"msgid"];
        if([NSString isNullOrEmpty:chatLogModel.imClmBodyModel.bodyModel.fileid]){
            [dic setValue:@"" forKey:@"fileid"];
        } else {
            [dic setValue:chatLogModel.imClmBodyModel.bodyModel.fileid forKey:@"fileid"];
        }
        if([NSString isNullOrEmpty:chatLogModel.imClmBodyModel.clienttempid]){
            [dic setValue:@"" forKey:@"clienttempid"];
        } else {
            [dic setValue:chatLogModel.imClmBodyModel.clienttempid forKey:@"clienttempid"];
        }
        if([chatLogModel.imClmBodyModel.from isEqualToString:[AppUtils GetCurrentUserID]]){
            [dic setValue:[FilePathUtil getChatSendImageDicAbsolutePath] forKey:@"filepath"];
        } else {
            [dic setValue:[FilePathUtil getChatRecvImageDicAbsolutePath] forKey:@"filepath"];
        }
        NSString *otherInfo=[dic dicSerial];
        
        /* 获取所需的PhotoBrowser */
        MWPhoto *photo = [[[PhotoBrowserViewModel alloc] init] getMWPhotModelWithSmallImagePath:smallImagePath oriImagePath:oriImagePath smallThumbnailUrl:smallThumbnailUrl oriThumbnailUrl:oriThumbnailUrl photoBrowser:photoBrowser index:index otherInfo:otherInfo downloadFinishBlock:^{
            /* 更新数据库 */
            [[ImChatLogDAL shareInstance] updateRecvStatusWithMsgId:chatLogModel.imClmBodyModel.msgid withRecvstatus:Chat_Msg_Downloadsuccess];
        }];
        
        return photo;
    }
    return nil;
}

- (BOOL)lzPhotoBrowserLongPressClickPhotoBrowser:(MWPhotoBrowser *)photoBrowser key:(NSString *)key{
    return [[[PhotoBrowserViewController alloc] init] clickDefaultLongPressActionPhotoBrowser:photoBrowser key:key sourceController:self];
}

/**
 *  点击了MenuItem
 *
 *  @param sender 点击MenuItem项
 */
- (void)clickMenuItemAction:(id <XHMessageModel>)message index:(NSInteger)index{
    DDLogVerbose(@"点击Menu---%@----%ld",message.text,(long)index);
    switch (index) {
            /* 保存到云盘 */
        case 0:
        {
            [[[PhotoBrowserViewController alloc] init] fileMessageSaveToNetDisk:message sourceController:self];
            break;
        }
            /*保存到协作文件*/
        case 1:{
            [[[PhotoBrowserViewController alloc] init] fileMessageSaveToCooFile:message sourceController:self imGroupModel:_toGroupModel];
            break;
        }
    }
}
@end
