//
//  ShareActivityModel.m
//  LeadingCloud
//
//  Created by SY on 2017/5/24.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "ShareActivityModel.h"
#import "NSString+IsNullOrEmpty.h"
#import "XHBaseViewController.h"
#import "SelectMessageRootViewController.h"
#import "LZFileTransfer.h"
#import "LZCloudFileTransferMain.h"
#import "AppUtils.h"
#import "Prompt.h"
#import "XHBaseNavigationController.h"
#import "UIActivityViewController+Private.h"
#import "UIImageView+Icon.h"
#import "AppUtils.h"
@interface ShareActivityModel ()<SelectMessageRootDelegate,UIAlertViewDelegate>
{
    XHBaseViewController *xhSourceController;
    
    /* 转发，临时变量 */
    NSInteger resend_contactTyep;
    NSString *resend_dialogID;
    NSString *resend_contactName;
    NSMutableDictionary *resend_otherInfo;
    
    UIWindow *__sheetWindow;//window必须为全局变量或成员变量
    
    
}
@property(nonatomic, strong) NSMutableDictionary *infoDic;
@end

@implementation ShareActivityModel

-(NSMutableDictionary *)infoDic {
    if (_infoDic == nil) {
        _infoDic = [[NSMutableDictionary alloc] init];
    }
    return _infoDic;
}
/**
 分享网页

 @param text title
 @param imageArr 图片
 @param shareUrl url
 @param controller 当前控制器
 */
-(void)shareWithText:(NSString*)text image:(id)image url:(NSURL*)shareUrl controller:(UIViewController*)controller {
    _shareTag = ShareType_NetPage;
//    //分享的标题
//    NSString *textToShare = @"分享的标题。";
//    //分享的图片
//    UIImage *imageToShare = [UIImage imageNamed:@"屏幕快照 2017-05-17 14.32.42.png"];
//    //分享的url
//    NSURL *urlToShare = [NSURL URLWithString:@"http://www.baidu.com"];
//    if ([image isKindOfClass:[YYImage class]]) {
//         UIImage *image2 = [UIImage imageWithCGImage:((YYImage*)image).CGImage];
//        image = image2;
//    }
    if (image == nil) {
        image = [UIImage imageNamed:@"link"];
    }
    
    _infoDic = [[NSMutableDictionary alloc] init];
    [_infoDic setValue:text forKey:@"text"];
    [_infoDic setValue:shareUrl forKey:@"url"];
    [_infoDic setValue:image forKey:@"image"];
    
   // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
   [self getSmallImageWithImg:image isselfapp:^(BOOL isfinish, UIImage *image) {
        if (image == nil) {
            image = [UIImage imageNamed:@"link"];
        }
       // 又是YYImage惹的祸 会导致分享面板图片不显示
//       if ([image isKindOfClass:[YYImage class]]) {
//           UIImage *image2 = [UIImage imageWithCGImage:((YYImage*)image).CGImage];
//           image = image2;
//       }
        //  dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *array = [NSMutableArray arrayWithObjects:text,image,shareUrl, nil];
        [self addActivityWithArray:array controller:controller];
    }];
  
}

/**
 文件分享（图片（UIiamge类型）、文档和音视频（url类型）、文字（字符串类型））

 @param text title
 @param image iamge
 @param controller
 */
-(void)shareWithDataArr:(NSMutableArray*)array controller:(UIViewController*)controller {
    
    for (id data in array) {
        if ([data isKindOfClass:[UIImage class]]) {
            UIImage *image = data;
            UIImage *image2 = [UIImage imageWithCGImage:image.CGImage];
            [array removeObject:image];
            [array addObject:image2];
            _shareTag = ShareType_Image;
            _infoDic = [[NSMutableDictionary alloc] init];
            [_infoDic setValue:data forKey:@"image"];

        }
        else if ([data isKindOfClass:[NSURL class]]) {
            _infoDic = [[NSMutableDictionary alloc] init];
            [_infoDic setValue:data forKey:@"url"];
        }
        else if ([data isKindOfClass:[NSString class]]) {
            _infoDic = [[NSMutableDictionary alloc] init];
            [_infoDic setValue:data forKey:@"text"];
        }
    }
    [self addActivityWithArray:array controller:controller];
}

-(void)addActivityWithArray:(NSMutableArray*)array controller:(UIViewController*)controller{
    xhSourceController = (XHBaseViewController *)controller;
    
    if (!_isNotShowSelfApp) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isshare"];
    }
    _activityVC = [[UIActivityViewController alloc]initWithActivityItems:array applicationActivities:nil];

    NSString *suiteName = nil;
    if ([AppUtils CheckIsAppStoreVersion]) {
        suiteName = @"group.com.leading.leadingcloud.share";
    }
    else {
        suiteName = @"group.com.leading.leadingcloud.EE.share";
    }
    // 保存到沙盒
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:suiteName];
    [userDefaults setValue:@"leadingCloud.share" forKey:@"sharatag"];

   [xhSourceController presentViewController:_activityVC animated:YES completion:nil];
    // 分享之后的回调
   
    WEAKSELF
    _activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"completed");
            // 自己的app分享直接跳
            if ([activityType isEqualToString:@"com.leading.leadingcloud.EE.share"] || [activityType isEqualToString:@"com.leading.leadingcloud.share"]) {
                [weakSelf.infoDic setValue:[NSNumber numberWithBool:YES] forKey:@"isselfapp"];
                [weakSelf ShareToThisOn:nil sourceController:controller isselfApp:YES];
            }
          
            //分享 成功
        }
        else  {
            NSLog(@"cancled");
            //分享 取消
            _activityVC = nil;
            //直接退出
            [controller.extensionContext completeRequestReturningItems:@[] completionHandler:^(BOOL expired) {
                
            }];
        }
    };
}
-(void)ShareToThisOn:(NSDictionary *)dic  sourceController:(UIViewController *)sourceController isselfApp:(BOOL)isSelfApp{
    
    
    [xhSourceController dismissViewControllerAnimated:YES completion:nil];
    
    SelectMessageRootViewController *selectMsgRootVC = [[SelectMessageRootViewController alloc] init];
    selectMsgRootVC.delegate = self;
    NSMutableDictionary *otherInfo = [[NSMutableDictionary alloc] init];
    
    //[otherInfo setObject:dic forKey:@"sharedata"];
    selectMsgRootVC.otherInfo = otherInfo;
    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:selectMsgRootVC];
    [xhSourceController presentViewController:navController animated:YES completion:nil];
}
#pragma mark - 转发的Delegate

-(void) dicClickItemDelegate:(NSInteger)contactType DialogID:(NSString *)dialogID contacName:(NSString *)contactName otherInfo:(NSMutableDictionary *)otherInfo{
    
    resend_contactTyep = contactType;
    resend_dialogID = dialogID;
    resend_contactName = contactName;
    resend_otherInfo = otherInfo;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LZGDCommonLocailzableString(@"message_confirm_sendto") message:contactName delegate:self cancelButtonTitle:LZGDCommonLocailzableString(@"common_cancel") otherButtonTitles:LZGDCommonLocailzableString(@"common_confirm"), nil];
   
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
        {
            [xhSourceController dismissViewControllerAnimated:YES completion:nil];
            
            ChatViewController *chatVC = [xhSourceController createChatViewControllerContactType:resend_contactTyep DialogID:resend_dialogID];
            ChatViewDidAppearBlock chatViewDidAppearBlock = ^(){
                NSString *savePath = [FilePathUtil getChatSendImageDicAbsolutePath];
                /* 分享网页 */
                if ([_shareTag isEqualToString:ShareType_NetPage]) {
                    // 自己APP分享到自己APP
                    if ([[_infoDic objectForKey:@"isselfapp"] boolValue] && [[_infoDic objectForKey:@"image"] isKindOfClass:[NSString class]]) {
                        [chatVC didSendUrlLink:[_infoDic lzNSStringForKey:@"text"] urlStr:[[_infoDic objectForKey:@"url"] absoluteString] urlImage:[_infoDic lzNSStringForKey:@"image"]];
                        
                    }
                    if ([[_infoDic objectForKey:@"image"] isKindOfClass:[UIImage class]]) {
                        NSData *imagedata = UIImageJPEGRepresentation([_infoDic objectForKey:@"image"], 0.5);
                        if (imagedata == nil) {
                            imagedata = UIImagePNGRepresentation([_infoDic objectForKey:@"image"]);
                        }
                        NSString *name = [NSString stringWithFormat:@"IMG_%@.JPG",[[LZFormat FormatNow2String] substringWithRange:NSMakeRange(10, 4)]];
                        if(![NSString isNullOrEmpty:savePath]){
                            NSFileManager *fileManager = [NSFileManager defaultManager];
                            [fileManager createFileAtPath:[savePath stringByAppendingFormat:@"%@",name] contents:imagedata attributes:nil];
                            NSLog(@"图片途径：%@",savePath);
                        }
                        [self uploadBeginName:name controller:chatVC dic:_infoDic];
                    }
                   
                   
                }
                /* 图片分享 */
                else if ([_shareTag isEqualToString:ShareType_Image]) {
                    NSURL * sharedata = [_infoDic objectForKey:@"url"]; // 要换成data类型的数据才行
                    
                    NSString *name = [AppUtils getFileName:[sharedata absoluteString]];
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:sharedata]]; //得到相册图片 真机不可以
                    NSData * imageData = nil;
                    if([name.lowercaseString hasSuffix:@"png"]){
                        imageData =  UIImagePNGRepresentation(image);
                    }else{
                        imageData =  UIImageJPEGRepresentation(image, 1.0);
                    }
                    
                    
                    if(![NSString isNullOrEmpty:savePath]){
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        [fileManager createFileAtPath:[savePath stringByAppendingFormat:@"%@",name] contents:imageData attributes:nil];
                        NSLog(@"图片途径：%@",savePath);
                    }
                    [chatVC didResendAblumWithMsgId:@"" clienttempid:@"" filePath:@"" filePhysicalName:name fileid:@"" fileShowName:name];
                   
                }
                // 文本分享
                else if ([_shareTag isEqualToString:ShareType_Text]) {
                    [chatVC didSendTextAction:[_infoDic lzNSStringForKey:@"text"]];
                }
                // 视频分享
                else if ([_shareTag isEqualToString:ShareType_Video]) {
                    
                    NSURL *url = [_infoDic objectForKey:@"url"];
                    NSString *showName = [AppUtils getFileName:[url absoluteString]];
                    
                    if(![NSString isNullOrEmpty:savePath]){
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        [fileManager createFileAtPath:[savePath stringByAppendingFormat:@"%@",showName] contents:[NSData dataWithContentsOfURL:url] attributes:nil];
                        NSLog(@"保存路径：%@",savePath);
                    }
                    NSString *sendPath = [NSString stringWithFormat:@"%@%@",savePath,showName];
                    
                    [chatVC finishAliPlayShortVideo:sendPath];
                    
                }
                // 文档
                else if ([_shareTag isEqualToString:ShareType_File]) {
                    NSURL *data = [_infoDic objectForKey:@"url"];
                    NSString *name = [AppUtils getFileName:[data absoluteString]];
                    if(![NSString isNullOrEmpty:savePath]){
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        [fileManager createFileAtPath:[savePath stringByAppendingFormat:@"%@",name] contents:[NSData dataWithContentsOfURL:data] attributes:nil];
                        NSLog(@"保存路径：%@",savePath);
                    }
                    
                    /* 创建上传文件模型 */
                    UploadFileModel *fileModel = [[UploadFileModel alloc] init];
                    fileModel.filePhysicalName = name;
                    fileModel.fileShowName = name;
                    //                            fileModel.datafortest = data;
                    fileModel.showIndex = 0;
                    NSMutableArray *sendArr = [[NSMutableArray alloc] init];
                    [sendArr addObject:fileModel];
                    
                    [chatVC didSendFileAction:sendArr];
                }
            };
            chatVC.chatViewDidAppearBlock = chatViewDidAppearBlock;
            chatVC.isPopToMsgTab = YES;
            chatVC.isNotAllowSlideBack = YES;

            [xhSourceController.navigationController pushViewController:chatVC animated:YES];
            
            //  NSString *userid = [AppUtils GetCurrentUserID];
           // if (![userid isEqualToString:resend_dialogID]) {
                __sheetWindow = [Prompt showPromptWithStyle:PromptStyleSuccess title:@"已发送" detail:nil canleButtonTitle:@"留在当前聊天" okButtonTitle:[NSString stringWithFormat:@"返回"] callBlock:^(MyWindowClick buttonIndex) {
                    
                    //Window隐藏，并置为nil，释放内存 不能少
                    __sheetWindow.hidden = YES;
                    __sheetWindow = nil;
                    
                    if (buttonIndex == 0) {
                        [xhSourceController.navigationController popViewControllerAnimated:YES];
                    }
                }];

           // }
            
        }
             break;
    }
}
#pragma mark - 图片下载
/**
 分享网页获取小图
 
 @return 小图
 */
-(void)getSmallImageWithImg:(id)image isselfapp:(isFinish)isfinish{
    //UIImageView *viewImage = [[UIImageView alloc] init];
    if ([image isKindOfClass:[NSString class]]) {
        if([[image lowercaseString] rangeOfString:@"http" ].location !=NSNotFound)//_roaldSearchText
        {
            SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
            [downloader downloadImageWithURL:[AppUtils urlToNsUrl:image]
                                     options:0
                                    progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                        // progression tracking code
                                    }
                                   completed:^(UIImage *image2, NSData *data, NSError *error, BOOL finished) {
                                       if (image2 && finished) {
                                           isfinish(YES,image2);
                                       }
                                       else {
                                           isfinish(YES,[UIImage imageNamed:@"link"]);
                                       }
                                   }];
            //[viewImage loadResourceIconWithUrl:image placeImage:@"link"];
        }
        else {
            [AppUtils GetImageWithID:image exptype:@"link" GetNewImage:^(UIImage *dataImage) {
                isfinish(YES,dataImage);
            }];
            //[viewImage loadResourceIcon:image AndPlaceHoldIcon:image  expType:@"link"];
            
        }
        
        return;
    }
   
	if ([image isKindOfClass:[UIImage class]]) {
       image =(UIImage*)image;
    }
    isfinish(YES,image);
   
}
#pragma mark - 上传物理图片(本地路径里面的文件，还未上传到服务器)
-(void)uploadBeginName:(NSString*)name controller:(ChatViewController*)chatVc dic:(NSDictionary*)dic{
    
    // 从要上传的文件里始终得到第一个文件
    ResModel *resModel = [[ResModel alloc] init];
    resModel.filePhysicalName = name;
    
    LZFileProgressUpload lzFileProgressUpload = ^(float percent, NSString *tag, id otherInfo){
        NSLog(@"上传进度1111=======%@",[NSString stringWithFormat:@"%0.f%%",percent*100]);
        
    };
    LZFileDidSuccessUpload lzFileDidSuccessUpload = ^(NSDictionary *result, NSString *tag, id otherInfo){
        DDLogVerbose(@"文件上传成功1111 - result（json）：%@ - tag:%@",result,tag);
        [self afterUploadFinish:otherInfo WithIsSuccess:YES WithResult:result controller:(ChatViewController*)chatVc dic:dic];
    };
    LZFileDidErrorUpload lzFileDidErrorUpload = ^(NSString *title, NSString *message, NSString *tag, id otherInfo){
        [self afterUploadFinish:otherInfo WithIsSuccess:NO WithResult:nil controller:(ChatViewController*)chatVc dic:dic];
    };
    
    /* 组织otherInfo */
    NSMutableDictionary *otherInfoDic = [[NSMutableDictionary alloc] init];
    // 显示文件名
    [otherInfoDic setObject:resModel forKey:@"res"];
    
    LZFileTransfer * lzFileTransfer = [LZCloudFileTransferMain getLZFileTransferForUploadWithFileType:File_Upload_FileType_File Progress:lzFileProgressUpload success:lzFileDidSuccessUpload error:lzFileDidErrorUpload];
    
    // 要用物理文件名
    lzFileTransfer.localFileName = name;
    lzFileTransfer.showFileName = name;
    lzFileTransfer.localPath = [FilePathUtil getChatSendImageDicRelatePath];
    
    [lzFileTransfer uploadFile];
}

//上传成功、或失败后调用
-(void)afterUploadFinish:(id)otherInfo WithIsSuccess:(BOOL)isSuccess WithResult:(NSDictionary *)result controller:(ChatViewController*)chatVc dic:(NSDictionary*)dic{

    if (isSuccess) {
         [chatVc didSendUrlLink:[dic lzNSStringForKey:@"text"] urlStr:[[_infoDic objectForKey:@"url"] absoluteString] urlImage:[result lzNSStringForKey:@"fileid"]];
    }
    else {
        [chatVc didSendUrlLink:[dic lzNSStringForKey:@"text"] urlStr:[[_infoDic objectForKey:@"url"] absoluteString] urlImage:nil];
    }
   
    
}

@end
