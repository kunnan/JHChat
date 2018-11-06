//
//  ChatSettingController.m
//  LeadingCloud
//
//  Created by wchMac on 16/4/15.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "ChatSettingController.h"
#import "ImChatLogModel.h"
#import "MWGridCell.h"

#import "AppUtils.h"
#import "UIView+Layout.h"
#import "NSString+XHDiskSizeTransfrom.h"
#import "NSString+IsNullOrEmpty.h"
#import "ChatViewModel.h"
#import "GalleryImageViewModel.h"
#import "PhotoBrowserViewModel.h"
#import "ImChatLogDAL.h"
#import "ScanFileViewController.h"
#import "ResModel.h"
#import "ImChatLogDAL.h"
#import "NSDictionary+DicSerial.h"
#import "NSString+SerialToDic.h"
#import "PhotoBrowserViewController.h"
#import "ChatViewController.h"
#import "CommonFontModel.h"
#import "ModuleServerUtil.h"
#import "LZScanResultViewModel.h"
#import "WebViewController.h"

@interface ChatSettingController (){
    CGFloat curRatio;
}
@end

@implementation ChatSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    /* 当加载该页面的时候，把控制器名称添加到数组中 */
    [self.appDelegate.lzSingleInstance.viewControllerArr addObject:[NSString stringWithUTF8String:object_getClassName(self)]];
    _tableDataSourceArr = [[NSMutableArray alloc] init];
    
    curRatio = [[CommonFontModel shareInstance]getHandeHeightRatio];
    //初始化tableView
    _mainTableView=[[LZBaseTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    _mainTableView.delegate=self;
    _mainTableView.dataSource=self;
    _mainTableView.sectionFooterHeight=0;
    _mainTableView.sectionHeaderHeight=0;
    _mainTableView.notUseLoadingView = YES;
    _mainTableView.notUseEmptyView = YES;
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, LZ_SCREEN_WIDTH, 20)];
    _mainTableView.tableHeaderView=headView;
    
    [self.view addSubview:_mainTableView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UMengUtil beginLogPageView:@"ChatSettingController"];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UMengUtil endLogPageView:@"ChatSettingController"];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [(LZBaseTableView*)self.mainTableView hideLoadAndEmptyView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  控制器销毁的时候删除数组中的元素
 */
- (void)dealloc {
    
    [_mainTableView removeFromSuperview];
    _tableDataSourceArr = nil;
    _fileBrowserArr = nil;
    _imageBrowserArr = nil;
    
    [self.appDelegate.lzSingleInstance.viewControllerArr removeObject:[NSString stringWithUTF8String:object_getClassName(self)]];
}

#pragma mark tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _tableDataSourceArr.count;
}
//设置每个分组下tableview的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableDataSourceArr.count == 0) return 0;
    NSMutableArray *sectionArr = [_tableDataSourceArr objectAtIndex:section];
    return sectionArr.count;
}

//每个分组下边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0 || section==1) {
        return 40*curRatio;
    }
    return 20*curRatio;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 0;
}
//每一个分组下对应的tableview 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *sectionArr = [_tableDataSourceArr objectAtIndex:indexPath.section];
    NSMutableDictionary *itemDic = [sectionArr objectAtIndex:indexPath.row];
    if([[itemDic lzNSStringForKey:CUSTOMVIEW] isEqualToString:@"faceicon"]){
        return 120;
    } else if ([[itemDic lzNSStringForKey:CUSTOMVIEW] isEqualToString:@"roboticon"]) {
        return 80;
    } else if ([[itemDic lzNSStringForKey:CUSTOMVIEW] isEqualToString:@"roboticon_0"]) {
        return 0;
    }
    return LZ_TableViewCell_Height48*curRatio;
}

//设置每行对应的cell（展示的内容）
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        
        UILabel *celllblLeftTitle = nil;
        UILabel *celllblRightTitle = nil;
        
        /* 左侧添加文本框 */
        celllblLeftTitle = [[UILabel alloc] initWithFrame:CGRectMake(15*curRatio, 0, 160*curRatio, LZ_TableViewCell_Height48*curRatio)];
        celllblLeftTitle.font = [UIFont systemFontOfSize:16*curRatio];
        celllblLeftTitle.tag = 101;
        [cell.contentView addSubview:celllblLeftTitle];
        
        /* 右侧添加文本框 */
        celllblRightTitle = [[UILabel alloc] initWithFrame:CGRectMake(celllblLeftTitle.frame.origin.x+celllblLeftTitle.frame.size.width, 0, LZ_SCREEN_WIDTH-(celllblLeftTitle.frame.origin.x+celllblLeftTitle.frame.size.width)-36, LZ_TableViewCell_Height48*curRatio)];
        celllblRightTitle.font = [UIFont systemFontOfSize:14*curRatio];
        celllblRightTitle.textColor = [UIColor colorWithWhite:0.392 alpha:1.000];
        celllblRightTitle.textAlignment = NSTextAlignmentRight;
        celllblRightTitle.tag = 102;
        [cell.contentView addSubview:celllblRightTitle];
    }

    NSMutableArray *sectionArr = [_tableDataSourceArr objectAtIndex:indexPath.section];
    NSMutableDictionary *itemDic = [sectionArr objectAtIndex:indexPath.row];
    
    NSString *cellAccessory = [itemDic lzNSStringForKey:CellAccessory];
    NSString *selector = [itemDic lzNSStringForKey:SELECTOR];
    cell.selectionStyle = [selector isEqualToString:@""] ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleGray;
    cell.accessoryType = [cellAccessory isEqualToString:@"DisclosureIndicator"] ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    UILabel *lblLeftTitle = [cell.contentView viewWithTag:101];
    UILabel *lblRightTitle = [cell.contentView viewWithTag:102];
    lblLeftTitle.text = @"";
    lblRightTitle.text = @"";
    
    NSString *left = [itemDic objectForKey:LEFTTITLE];
    NSString *right = [itemDic objectForKey:RIGHTTITLE];
    if(![NSString isNullOrEmpty:left]){
        lblLeftTitle.text = left;
    }
    if(![NSString isNullOrEmpty:right]){
        lblRightTitle.text = right;
        if ([NSString isNullOrEmpty:cellAccessory] && [NSString isNullOrEmpty:selector]) {
            lblRightTitle.frame = CGRectMake(lblLeftTitle.frame.origin.x+lblLeftTitle.frame.size.width, 0, LZ_SCREEN_WIDTH-(lblLeftTitle.frame.origin.x+lblLeftTitle.frame.size.width)-16, LZ_TableViewCell_Height48);
        } else if ([cellAccessory isEqualToString:@"DisclosureIndicator"]) {
            lblRightTitle.frame = CGRectMake(lblLeftTitle.frame.origin.x+lblLeftTitle.frame.size.width-3, 0, LZ_SCREEN_WIDTH-(lblLeftTitle.frame.origin.x+lblLeftTitle.frame.size.width)-36, LZ_TableViewCell_Height48*curRatio);
        }
    }
    
    if([[itemDic objectForKey:CUSTOMVIEW] isEqualToString:@""]){
        /* 在其他的cell中会会出现开关的按钮 */
        for(UIView *subView in [cell.contentView subviews]){
            if([subView isKindOfClass:[UISwitch class]]){
                [subView removeFromSuperview];
            } else if ([subView isKindOfClass:[UIImageView class]]) {
                [subView removeFromSuperview];
            }
        }
    }
    else {
        NSMutableDictionary *obj = [[NSMutableDictionary alloc] init];
        [obj setObject:cell forKey:@"cell"];
        [obj setObject:itemDic forKey:@"data"];
        [self initCellCustomView:obj];
    }
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *sectionArr = [self.tableDataSourceArr objectAtIndex:indexPath.section];
    NSMutableDictionary *itemDic = [sectionArr objectAtIndex:indexPath.row];
    
    NSMutableDictionary *obj = [[NSMutableDictionary alloc] init];
    [obj setObject:itemDic forKey:@"data"];
    
    [self afterCellDidSelect:obj];
}

#pragma mark - 自定义处理

/**
 *  初始化自定义视图
 */
-(void)initCellCustomView:(NSMutableDictionary *)obj{

}

/**
 *  处理cell点击事件
 */
-(void)afterCellDidSelect:(NSMutableDictionary *)obj{
}


#pragma mark - 查看聊天文件

/**
 *  查看文件
 */
-(void)showChatViewControllerFile:(NSString *)dialogId{
    NSString *fileHandlerType = [NSString stringWithFormat:@"'%@','%@','%@','%@'",
                                 Handler_Message_LZChat_Image_Download,
                                 Handler_Message_LZChat_File_Download,
                                 Handler_Message_LZChat_Micro_Video,
                                 Handler_Message_LZChat_UrlLink];
    _fileBrowserArr = [[[ImChatLogDAL alloc] init] getChatLogWithDialogid:dialogId handlerType:fileHandlerType];
    
    NSString *imageHandlerType = [NSString stringWithFormat:@"'%@'",Handler_Message_LZChat_Image_Download];
    _imageBrowserArr = [[[ImChatLogDAL alloc] init] getChatLogWithDialogid:dialogId handlerType:imageHandlerType];
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.lzTag = @"grid";
    
    if (_fileBrowserArr.count == 0 && _imageBrowserArr.count == 0) {
        browser.isHaveFile = NO;
    } else {
        browser.isHaveFile = YES;
    }
    /* Show action button to allow sharing, copying, etc (defaults to YES) */
    browser.displayActionButton = NO;
    /* Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO) */
    browser.alwaysShowControls = NO;
    /* Images that almost fill the screen will be initially zoomed to fill (defaults to YES) */
    browser.zoomPhotosToFill = NO;
    /* Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES) */
    browser.enableGrid = YES;
    /* Whether to start on the grid of thumbnails instead of the first photo (defaults to NO) */
    browser.startOnGrid = YES;
    browser.isClickExit = YES;
    /* 滚动到底部 */
    if(_fileBrowserArr.count>0){
        [browser setCurrentPhotoIndex:_fileBrowserArr.count-1];
    }
    
    [self.navigationController pushViewController:browser animated:YES];
}


#pragma mark - MWPhotoBrowserDelegate

/**
 *  重新设置NavigationController
 */
- (BOOL)lzPhotoBrowserSetNavigationController:(MWPhotoBrowser *)photoBrowser{
    if([photoBrowser.lzTag isEqualToString:@"image"]){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
        return YES;
    } else if([photoBrowser.lzTag isEqualToString:@"grid"]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
        return YES;
    }
    return YES;
}

/**
 *  更新NavigationController
 */
- (BOOL)lzPhotoBrowserUpdateNavigationController:(MWPhotoBrowser *)photoBrowser{
    if([photoBrowser.lzTag isEqualToString:@"image"]){
        return NO;
    } else if([photoBrowser.lzTag isEqualToString:@"grid"]) {
        photoBrowser.title = LZGDCommonLocailzableString(@"message_chat_file");
        return YES;
    }
    return YES;
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    if([photoBrowser.lzTag isEqualToString:@"image"]){
        return _imageBrowserArr.count;
    } else if([photoBrowser.lzTag isEqualToString:@"grid"]) {
        return _fileBrowserArr.count;
    }
    return 0;
}

/**
 *  Grid方式浏览群文件
 */
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _fileBrowserArr.count) {
        ImChatLogModel *chatLogModel = (ImChatLogModel *)[_fileBrowserArr objectAtIndex:index];
        return [self getPhotoWithphotoBrowser:photoBrowser chatlogModel:chatLogModel atIndex:index];
    }
    return nil;
}

/**
 *  Grid模式，自定义显示视图
 */
- (MWGridCell *)lzMWGridPhotoBrowser:(MWPhotoBrowser *)photoBrowser collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImChatLogModel *clickChatLogModel = (ImChatLogModel *)[_fileBrowserArr objectAtIndex:indexPath.row];
    if(![clickChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_Image_Download]){
        MWGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[MWGridCell alloc] init];
        }
        cell.videoIndicator.hidden = YES;
        cell.customView.hidden = NO;
        [cell hideLoadingIndicator];
        
        if([clickChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_File_Download]){
            cell.customView.backgroundColor = [UIColor colorWithRed:0.809 green:0.994 blue:0.625 alpha:1.000];
            
            cell.backImageView.hidden = YES;
            cell.durationLbl.hidden = YES;
            cell.sizeVideoLbl.hidden = YES;
            cell.typeImageView.hidden = NO;
            cell.sizeLbl.hidden = NO;
            cell.titleLbl.hidden = NO;
            /* 类型图标 */
            [AppUtils GetImageWithID:clickChatLogModel.imClmBodyModel.bodyModel.icon exptype:clickChatLogModel.imClmBodyModel.bodyModel.name GetNewImage:^(UIImage *dataImage) {
                cell.typeImageView.image = dataImage;
            }];
//            typeImageView.image = [UIImage imageNamed:[AppUtils GetImageNameWithName:clickChatLogModel.imClmBodyModel.bodyModel.name]];
            
            /* 文件名称 */
            cell.titleLbl.text = clickChatLogModel.imClmBodyModel.bodyModel.name;
            
            /* 文件大小 */
            cell.sizeLbl.text = [NSString transformedValue:(long long)clickChatLogModel.imClmBodyModel.bodyModel.size];
            
        }
        /* urlLink类型 */
        else if ([clickChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_UrlLink]) {
            cell.customView.backgroundColor = [UIColor colorWithRed:0.809 green:0.994 blue:0.625 alpha:1.000];
            cell.backImageView.hidden = YES;
            cell.durationLbl.hidden = YES;
            cell.sizeVideoLbl.hidden = YES;
            cell.typeImageView.hidden = NO;
            cell.sizeLbl.hidden = NO;
            cell.titleLbl.hidden = NO;
            /* 类型图标 */
            [AppUtils GetImageWithID:clickChatLogModel.imClmBodyModel.bodyModel.urlimage exptype:@"link" GetNewImage:^(UIImage *dataImage) {
                cell.typeImageView.image = dataImage;
            }];
            cell.sizeLbl.numberOfLines = 3;
            cell.sizeLbl.text = clickChatLogModel.imClmBodyModel.bodyModel.urlstr;
            
            cell.titleLbl.text = clickChatLogModel.imClmBodyModel.bodyModel.urltitle;
        }
        /* 文件类型为视频 */
        else if ([clickChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_Micro_Video]) {
            cell.videoIndicator.hidden = NO;
            cell.backImageView.hidden = NO;
            cell.durationLbl.hidden = NO;
            cell.sizeVideoLbl.hidden = NO;
            cell.typeImageView.hidden = YES;
            cell.sizeLbl.hidden = YES;
            cell.titleLbl.hidden = YES;
            
            NSString *coverImageName = clickChatLogModel.imClmBodyModel.fileModel.smalliconclientname;
            NSString *savePath = @"";
            if([clickChatLogModel.imClmBodyModel.from isEqualToString:[[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"uid"]]){
                savePath=[FilePathUtil getChatSendImageDicAbsolutePath];
            } else {
                savePath=[FilePathUtil getChatRecvImageDicAbsolutePath];
            }
            
            NSString *picImagePath = [NSString stringWithFormat:@"%@%@",savePath,coverImageName];
            
            /* 加载本地图片 */
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if([fileManager fileExistsAtPath:picImagePath]){
                cell.backImageView.image = [UIImage imageWithContentsOfFile:picImagePath];
            } else {
                SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
                NSString *coverID = [[coverImageName componentsSeparatedByString:@"."] objectAtIndex:0];
                NSString *url = [GalleryImageViewModel GetGalleryThumbnailImageUrlFileId:coverID size:@"200X200"];
                [downloader downloadImageWithURL:[AppUtils urlToNsUrl:url]
                                         options:0
                                        progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                        }
                                       completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                           if (image && finished) {
                                               /* 将图片保存到本地 */
                                               [fileManager createFileAtPath:picImagePath contents:data attributes:nil];
                                               cell.backImageView.image = [UIImage imageWithContentsOfFile:picImagePath];
                                           } else {
                                               DDLogVerbose(@"视频封面图下载失败");
                                           }
                                       }];
            }
            /* 左下角时长显示 */
            cell.durationLbl.text = [NSString stringWithFormat:@"%@",clickChatLogModel.imClmBodyModel.bodyModel.duration];
            cell.sizeVideoLbl.text = [NSString transformedValue:(long long)clickChatLogModel.imClmBodyModel.bodyModel.size];
        }
        return cell;
    }
    else {
        return nil;
    }
}

/**
 *  点击表格中的某一项
 */
- (void)lzMWGridPhotoBrowser:(MWPhotoBrowser *)photoBrowser didSelectIndexPath:(NSIndexPath *)indexPath{
    DDLogVerbose(@"=================%ld",(long)indexPath.row);
    
    ImChatLogModel *clickChatLogModel = (ImChatLogModel *)[_fileBrowserArr objectAtIndex:indexPath.row];
    if([clickChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_File_Download]){
        DDLogVerbose(@"点击了文件");
        ScanFileViewController *scan = [[ScanFileViewController alloc] init];
        /* 资源包 */
        if( [clickChatLogModel.imClmBodyModel.bodyModel.isresource isEqualToString:@"true"] ){
            scan.scanFileResId = clickChatLogModel.imClmBodyModel.bodyModel.rid;
            scan.scanFileRVersion = clickChatLogModel.imClmBodyModel.bodyModel.rversion;
            scan.scanFileExpId = clickChatLogModel.imClmBodyModel.bodyModel.fileid;
            scan.scanFileRtype = 3;
        }
        else {
            scan.scanFileExpId = clickChatLogModel.imClmBodyModel.bodyModel.fileid;
        }
        scan.scanFileName = clickChatLogModel.imClmBodyModel.bodyModel.name;
        scan.scanFileSize = clickChatLogModel.imClmBodyModel.bodyModel.size;
        if([clickChatLogModel.imClmBodyModel.from isEqualToString:self.currentUid]){
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
        
        [scan lookFileForScanFileWithController:self];
    }
    /* 点击视频 */
    else if ([clickChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_Micro_Video]) {
        DDLogVerbose(@"点击的是视频");
        /* 点击播放视频 */
        NSString *videoID = [[[clickChatLogModel.body seriaToDic] lzNSDictonaryForKey:@"body"] lzNSStringForKey:@"videofileid"];
        NSString *name = clickChatLogModel.imClmBodyModel.fileModel.smallvideoclientname;
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
        if([clickChatLogModel.imClmBodyModel.from isEqualToString:[[LZUserDataManager readCurrentUserInfo] lzNSStringForKey:@"uid"]]){
            savePath=[FilePathUtil getChatSendImageDicAbsolutePath];
            relatePath = [FilePathUtil getChatSendImageDicRelatePath];
        } else {
            savePath=[FilePathUtil getChatRecvImageDicAbsolutePath];
            relatePath = [FilePathUtil getChatRecvImageDicRelatePath];
        }
        ScanFileViewController *scan = [[ScanFileViewController alloc] init];
        scan.scanFileExpId = videoID; /* 视频id */
        scan.scanFileName = name;
        scan.scanFilePhysicalName = name;
        scan.scanFileAbsolutePath = savePath;
        scan.isResItem= YES;
        scan.scanFileSize = [[[[clickChatLogModel.body seriaToDic] lzNSDictonaryForKey:@"body"] objectForKey:@"size"] longLongValue];
        scan.scanFileSmallAbsolutePath = [FilePathUtil getPostFileSmallDownloadDicAbsolutePath];
        scan.scanFileReleatePath = relatePath;
        scan.Vc = self;
        
        [scan lookFileForScanFileWithController:self];
    }
    else if ([clickChatLogModel.handlertype isEqualToString:Handler_Message_LZChat_UrlLink]) {
        NSString *linkStr = clickChatLogModel.imClmBodyModel.bodyModel.urlstr;
        [self clickUrlLinkEvent:linkStr];
    }
    /* 点击的是图片 */
    else {
        NSString *msgid = clickChatLogModel.msgid;
        NSString *clienttmepid = clickChatLogModel.clienttempid;
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.lzTag = @"image";
        browser.displayActionButton = NO;
        browser.alwaysShowControls = NO;
        browser.zoomPhotosToFill = NO;
        browser.enableGrid = NO;
        browser.startOnGrid = NO;
        browser.isClickExit = YES;
        WEAKSELF
        AlertBlock alert = ^ {
            /* 从聊天界面进入的图片浏览 */
            NSMutableArray *customUIAlertActionArray = [[NSMutableArray alloc] init];
            [customUIAlertActionArray addObject:MWPhoto_AlertAction_SendToUser];
            [customUIAlertActionArray addObject:MWPhoto_AlertAction_SaveImage];
            [customUIAlertActionArray addObject:MWPhoto_AlertAction_IdentifyQrCode];
            [customUIAlertActionArray addObject:MWPhoto_AlertAction_SaveToDisk];
            [customUIAlertActionArray addObject:MWPhoto_AlertAction_Share];
            
            UIAlertAction *locateOfChatAction = [UIAlertAction actionWithTitle:@"定位到聊天位置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *dic = [browser.otherInfo seriaToDic];
                
                /* 在主线程中发送通知 */
                dispatch_async(dispatch_get_main_queue(), ^{
                    /* 通知列表 */
                    __block ChatSettingController * service = weakSelf;
                    EVENT_PUBLISH_WITHDATA(service, EventBus_Chat_LocalInChat, dic);
                });
                /* 单人聊天的聊天文件中进入图片浏览 */
                for (UIViewController *controller in weakSelf.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[ChatViewController class]]) {
                        [weakSelf.navigationController popToViewController:controller animated:NO];
                    }
                }
            }];
            [customUIAlertActionArray addObject:locateOfChatAction];
            browser.customUIAlertActionArray = customUIAlertActionArray;
        };
        browser.alertBlock = alert;
        /* 获取当前图片的index值 */
        int theIndex = -1;
        for (int i=0;i<[_imageBrowserArr count];i++) {
            ImChatLogModel *chatLogModel = [_imageBrowserArr objectAtIndex:i];
            if([msgid isEqualToString:chatLogModel.msgid]
               || (![NSString isNullOrEmpty:clienttmepid]
                   && ![NSString isNullOrEmpty:chatLogModel.clienttempid]
                   && [clienttmepid isEqualToString:chatLogModel.clienttempid] ) ){
                   theIndex = i;
               }
        }
        if(theIndex==-1){
            return;
        }
        [browser setCurrentPhotoIndex:theIndex];
        
        [self.navigationController pushViewController:browser animated:YES];
    }
}

/**
 *  查看图片
 */
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if ([photoBrowser.lzTag isEqualToString:@"image"]) {
        if (index < _imageBrowserArr.count) {
            ImChatLogModel *chatLogModel = (ImChatLogModel *)[_imageBrowserArr objectAtIndex:index];
            return [self getPhotoWithphotoBrowser:photoBrowser chatlogModel:chatLogModel atIndex:index];
        }
    }
    return nil;
}

/**
 *  根据ChatLogModel获取Photo
 */
- (MWPhoto *)getPhotoWithphotoBrowser:(MWPhotoBrowser *)photoBrowser chatlogModel:(ImChatLogModel *)chatLogModel atIndex:(NSUInteger)index {
    NSString *smallFolderPath = @"";
    NSString *oriFolderPath = @"";
    /* 文件夹路径 */
    if([chatLogModel.imClmBodyModel.from isEqualToString:self.currentUid]){
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
    /* fileid为空时的容错处理 */
    NSString *fileid = [NSString isNullOrEmpty:chatLogModel.imClmBodyModel.bodyModel.fileid] ? @"" : chatLogModel.imClmBodyModel.bodyModel.fileid;
    NSString *fileShowName = [NSString isNullOrEmpty:chatLogModel.imClmBodyModel.bodyModel.name] ? @"" : chatLogModel.imClmBodyModel.bodyModel.name;
    
    /* url路径 */
    NSString *smallThumbnailUrl = [GalleryImageViewModel GetGalleryThumbnailImageUrlFileId:fileid size:@"200X200"];
    NSString *oriThumbnailUrl = [GalleryImageViewModel GetGalleryOriImageUrlFileId:fileid];
    
    /* grid模式只需要下载小图 */
    if([photoBrowser.lzTag isEqualToString:@"grid"]){
        oriImagePath = smallImagePath;
        oriThumbnailUrl = smallThumbnailUrl;
    }
    
    /* 添加长按时所需参数 */
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setObject:fileShowName forKey:@"fileshowname"];
    [dic setObject:chatLogModel.imClmBodyModel.fileModel.smalliconclientname forKey:@"filephysicalname"];
    [dic setObject:chatLogModel.imClmBodyModel.msgid forKey:@"msgid"];
    [dic setObject:fileid forKey:@"fileid"];
    if([NSString isNullOrEmpty:chatLogModel.imClmBodyModel.clienttempid]){
        [dic setObject:@"" forKey:@"clienttempid"];
    } else {
        [dic setObject:chatLogModel.imClmBodyModel.clienttempid forKey:@"clienttempid"];
    }
    if([chatLogModel.imClmBodyModel.from isEqualToString:self.currentUid]){
        [dic setObject:[FilePathUtil getChatSendImageDicAbsolutePath] forKey:@"filepath"];
    } else {
        [dic setObject:[FilePathUtil getChatRecvImageDicAbsolutePath] forKey:@"filepath"];
    }
    NSString *otherInfo=[dic dicSerial];
    
    /* 获取所需的PhotoBrowser */
    MWPhoto *photo = [[[PhotoBrowserViewModel alloc] init] getMWPhotModelWithSmallImagePath:smallImagePath oriImagePath:oriImagePath smallThumbnailUrl:smallThumbnailUrl oriThumbnailUrl:oriThumbnailUrl photoBrowser:photoBrowser index:index otherInfo:otherInfo downloadFinishBlock:^{
        /* 更新数据库 */
        [[ImChatLogDAL shareInstance] updateRecvStatusWithMsgId:chatLogModel.imClmBodyModel.msgid withRecvstatus:Chat_Msg_Downloadsuccess];
    }];
    
    return photo;
}

- (BOOL)lzPhotoBrowserLongPressClickPhotoBrowser:(MWPhotoBrowser *)photoBrowser key:(NSString *)key{
    return [[[PhotoBrowserViewController alloc] init] clickDefaultLongPressActionPhotoBrowser:photoBrowser key:key sourceController:self];
}

/**
 点击urllink类型的消息事件
 
 @param linkStr
 */
- (void)clickUrlLinkEvent:(NSString *)linkStr {
    NSString *resultStr = [LZUtils getDomainUrlTrunHostUrl:linkStr].lowercaseString;
    
    //        NSString *server = [NSString stringWithFormat:@"%@/T",[ModuleServerUtil GetH5ServerWithModule:Modules_H5_Default]];
    //        NSString *serverShare = [NSString stringWithFormat:@"%@/R/S",[ModuleServerUtil GetH5ServerWithModule:Modules_H5_Default]];
    //        server = [LZUtils getDomainUrlTrunHostUrl:server];
    //        serverShare = [LZUtils getDomainUrlTrunHostUrl:serverShare];
    //        server = server.lowercaseString;
    //        serverShare = serverShare.lowercaseString;
    NSString *resultHost = [LZUtils getUrlWithIP:resultStr];
    NSString *server = [LZUtils getUrlWithIP:[ModuleServerUtil GetH5ServerWithModule:Modules_H5_Default]].lowercaseString;
    if([resultHost isEqualToString:server]&&([resultStr rangeOfString:@"/t/"].location!=NSNotFound || [resultStr rangeOfString:@"/r/"].location!=NSNotFound)){
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

@end
