//
//  LZFileTransferForHttp.m
//  LZMobileIM
//
//  Created by MisWCH on 15-4-28.
//  Copyright (c) 2015年 mis. All rights reserved.
//

#import "LZFileTransferForHttp.h"
#import <AliyunOSSiOS/OSSService.h>
#import "LZUtils.h"
#import "NSString+SerialToDic.h"
#import "ErrorDAL.h"
#import "AppDateUtil.h"
#import "NSDictionary+DicSerial.h"
#import "AliyunRemotrlyServerDAL.h"
#import "AliyunRemotelyAccountDAL.h"
#import "RemotelyServerModel.h"
#import "AliyunViewModel.h"
#import "RemotelyServerModel.h"
#import "RemotelyAccountModel.h"
#import "NSString+IsNullOrEmpty.h"
#import "AliyunOSS.h"
#import "AliyunFileidsDAL.h"

#define MAX_ERROR_TIMES ((self.maxErrorTimes !=0) ? self.maxErrorTimes : 3)
#define weakself typeof(self) __weak weakSelf = self;

@interface LZFileTransferForHttp ()
{
    RemotelyServerModel *_remotelyServerModel;
    RemotelyAccountModel *_remotelytAccountModel;
    NSString *AccessKey;
    NSString *SecretKey;
    NSString *securitytoken;
    NSString *bucketName;
    OSSClient * client;
    NSString *objectKey;
    
    OSSPutObjectRequest * put;
    OSSGetObjectRequest * objectRequest;
    
    

}
@property (nonatomic, strong) AppDelegate  * appDelegate;
@end

@implementation LZFileTransferForHttp

@synthesize delegate;
-(AppDelegate *)appDelegate {
    if (_appDelegate == nil) {
        _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return _appDelegate;
}
- (id)init {
    self = [super init];
    urlString=@"";//[[NSString alloc]init];
    dataNote=nil;//[[NSMutableData alloc]init];
    filesize = 0;
    downloaded = 0;
    fileTransferType = 0;// we
    contentType = @"";
    errortimes=0;
    
    //未进入错误区，即未响应错误事件；
    interErrorEvent = NO;

    token=  [self createGUID];// @"d008bb43-9cea-433b-854a-cbbdc71b7705";
//    if(![[LZUserDataManager readLoginID] isEqualToString:@""]){
//        token = [LZUserDataManager readLoginID];
//    }

    self.tag=@"";
    self.localFileName = @"";
    self.localPath = @"";
    self.remotePath = @"";
    self.remoteFileName = @"";
    
    NSString *fileprotocol = @"";
    NSString *fileserverip = @"";
    NSString *fileserverport = @"";
//    if([[LZUserDataManager readFileSetting] objectForKey:@"offlinefileprotocol"]){
//        fileprotocol = [[LZUserDataManager readFileSetting] objectForKey:@"offlinefileprotocol"];
//    }
//    if([[LZUserDataManager readFileSetting] objectForKey:@"fileserverip"]){
//        fileserverip = [[LZUserDataManager readFileSetting] objectForKey:@"fileserverip"];
//    }
//    if([[LZUserDataManager readFileSetting] objectForKey:@"fileserverport"]){
//        fileserverport = [[LZUserDataManager readFileSetting] objectForKey:@"fileserverport"];
//    }
    self.protocol = fileprotocol;
    self.server = fileserverip;
    self.port = fileserverport;
    
    return self;
}
#pragma mark -- 阿里云文件上传、下载

- (void)setupEnvironment {
    
    _remotelyServerModel =[AliyunViewModel getAliyunServer];
    _remotelytAccountModel = [AliyunViewModel getAcountModelFormLocal];
    // 添加读取区
    bucketName = self.isReadfile ? _remotelyServerModel.readbucket:_remotelyServerModel.bucket;
    AccessKey = _remotelytAccountModel.accesskey;
    SecretKey = _remotelytAccountModel.accesskeysecret;
    securitytoken = _remotelytAccountModel.securitytoken;
    
    [OSSLog enableLog];
    [self initOSSClient];
    
}
// 初始化阿里云
- (void)initOSSClient {
    //NSString *server = [ModuleServerUtil GetServerWithModule:Modules_File];
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   //NSString *  endPoint = @"https://oss-cn-beijing.aliyuncs.com";
    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:AccessKey secretKeyId:SecretKey securityToken:securitytoken];

    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 2;
    conf.timeoutIntervalForRequest = 30;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    
    NSString *endpoint = @"";
    
    if([[_remotelyServerModel.rfsurl lowercaseString] hasPrefix:@"http"] ){
        endpoint = _remotelyServerModel.rfsurl;
    }
    else {
        endpoint = [NSString stringWithFormat:@"https://%@.aliyuncs.com",_remotelyServerModel.rfsurl];
    }
    
    client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential clientConfiguration:conf];
}
// 异步上传
- (void)uploadObjectAsync {
     [self setupEnvironment];
    put = [OSSPutObjectRequest new];
    
    // required fields
    put.bucketName = bucketName;
    put.objectKey = [NSString stringWithFormat:@"%@/%@",_remotelyServerModel.path,objectKey];  // fileid
    
    //NSString * docDir = [self getDocumentDirectory];
    NSString *path = [[self getDocument] stringByAppendingPathComponent:[NSString stringWithFormat: @"%@%@" ,self.localPath,  self.localFileName]];
    put.uploadingFileURL = [NSURL fileURLWithPath:path];
    //    put.uploadingData =  _data;
    // optional fields
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"当前上传段长度:%lld, 当前已经上传总长度:%lld, 一共需要上传的总长度:%lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        
    };
    
    put.contentType = @"application/octet-stream";//设置文件类型
    put.contentMd5 = [OSSUtil base64Md5ForFilePath:path]; //使用该请求头进行端到端检查
    put.contentEncoding =  @"UTF-8"; //指定该Object被下载时的内容编码格式
   // put.contentDisposition ="attachment; filename='" + LZFileUtil.encodeURIComponent(file.getName()) + "'" self.showFileName;//指定该Object被下载时的名称
    
    put.contentDisposition = [NSString stringWithFormat:@"attachment; filename=%@",[self.showFileName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    put.cacheControl = @"max-age=691200, must-revalidate";
    
    NSString *esapteShowFileName = [self.showFileName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    put.contentDisposition = [NSString stringWithFormat:@"attachment; filename=%@",esapteShowFileName];
    
    // 可以在上传时设置元信息或者其他HTTP头部
   // put.objectMeta =  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value1", @"x-oss-meta-name1", nil];
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        NSLog(@"objectKey: %@", put.objectKey);
        if (!task.error) {
            NSLog(@"上传成功");
            
            [self callBack]; //上传成功后的回调
        } else {
            if(self.lzFileDidErrorUpload){
                self.lzFileDidErrorUpload(@"connection error",@"result is nil",self.tag,self.otherInfo);
            }
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
}
// 同步上传
- (void)uploadObjectSync {
    [self setupEnvironment];
    OSSPutObjectRequest * putSync = [OSSPutObjectRequest new];
    
    // required fields
    putSync.bucketName = bucketName;
    putSync.objectKey = [NSString stringWithFormat:@"%@/%@",_remotelyServerModel.path,objectKey];;
    
    NSString *path = [[self getDocument] stringByAppendingPathComponent:[NSString stringWithFormat: @"%@%@" ,self.localPath,  self.localFileName]];
    putSync.uploadingFileURL = [NSURL fileURLWithPath:path];
    
    // optional fields
    putSync.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    putSync.contentType =  @"application/octet-stream" ;
    putSync.contentMd5 = [OSSUtil base64Md5ForFilePath:path];
    putSync.contentEncoding = @"utf-8";
    putSync.contentDisposition = self.showFileName;
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask waitUntilFinished]; // 阻塞直到上传完成
    
    if (!putTask.error) {
         [self callBack]; //上传成功后的回调
        NSLog(@"upload object success!");
    } else {
        if(self.lzFileDidErrorUpload){
            self.lzFileDidErrorUpload(@"connection error",@"result is nil",self.tag,self.otherInfo);
        }

        NSLog(@"upload object failed, error: %@" , putTask.error);
    }
}

// 上传成功后的回调
-(void)callBack {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    OSSPutObjectRequest * request = [OSSPutObjectRequest new];
    request.bucketName = bucketName;
    request.objectKey =[NSString stringWithFormat:@"%@/%@",_remotelyServerModel.path,objectKey];
    
     NSString *path = [[self getDocument] stringByAppendingPathComponent:[NSString stringWithFormat: @"%@%@" ,self.localPath,  self.localFileName]];
    request.uploadingFileURL =[NSURL fileURLWithPath:path];;
    if ([NSString isNullOrEmpty:self.showFileName]) {
        self.showFileName = self.localFileName;
    }
    
    request.contentType = @"application/octet-stream";//设置文件类型
    request.contentMd5 = [OSSUtil base64Md5ForFilePath:path]; //使用该请求头进行端到端检查
    request.contentEncoding =  @"UTF-8"; //指定该Object被下载时的内容编码格式
    // put.contentDisposition ="attachment; filename='" + LZFileUtil.encodeURIComponent(file.getName()) + "'" self.showFileName;//指定该Object被下载时的名称
    //缓存时间，must-revalidate为必须遵循设置规则
    //metadata.AddHeader(Aliyun.OSS.Util.HttpHeaders.CacheControl, "max-age=691200, must-revalidate");
    request.cacheControl = @"max-age=691200, must-revalidate";
    
    request.contentDisposition = [NSString stringWithFormat:@"attachment; filename=%@",[self.showFileName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *nsdata = [self.showFileName dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    
    // 设置回调参数 文件类型在上传成功后的回调里面[NSString stringWithFormat:@"bucket=${bucket}&filename=%@&size=${size}&mimeType=${mimeType}&height=${imageInfo.height}&width=${imageInfo.width}&key=${object}",base64Decoded]
    request.callbackParam = @{
                              @"callbackUrl": [NSString stringWithFormat:@"%@/api/filemanager/handler/aliyunosscallbackfunction/%@/%@/%@",_remotelyServerModel.callbackurl,_remotelyServerModel.rfsid,File_Upload_FileType_File,appDelegate.lzservice.tokenId],
                              @"callbackBody":[NSString stringWithFormat:@"bucket=${bucket}&filename=%@&size=${size}&mimeType=${mimeType}&height=${imageInfo.height}&width=${imageInfo.width}&key=${object}",base64Encoded],
                              @"callbackBodyType": @"application/x-www-form-urlencoded"
                              };
    // 设置自定义变量application/jsonapplication/x-www-form-urlencoded
    //                                request.callbackVar = @{
    //                                                        @"<var1>": @"<value1>",
    //                                                        @"<var2>": @"<value2>"
    //                                                        };
    weakself
    request.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        __strong __typeof(self) strongSelf = weakSelf;
        //
        //CGFloat send = [[NSString stringWithFormat:@"%lld",bytesSent] floatValue];
        CGFloat ByteSent = [[NSString stringWithFormat:@"%lld",totalByteSent] floatValue];
        CGFloat BytesExpectedToSend = [[NSString stringWithFormat:@"%lld",totalBytesExpectedToSend] floatValue];
        if(weakSelf.lzFileProgressUpload){
            dispatch_async(dispatch_get_main_queue(), ^{
              
                strongSelf.lzFileProgressUpload(ByteSent / (BytesExpectedToSend * 1.0f),strongSelf.tag,strongSelf.otherInfo);
            });
        }
        NSLog(@"回调：%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        
    };
    OSSTask * task = [client putObject:request];
    [task continueWithBlock:^id(OSSTask *task) {
        
        if (task.error) {
            
            OSSLogError(@"回调失败：%@", task.error);
            if(self.lzFileDidErrorUpload){
                self.lzFileDidErrorUpload(@"回调失败",@"result is nil",self.tag,self.otherInfo);
            }
            
        } else {
            
            OSSPutObjectResult * result = task.result;
            NSDictionary *dic = [[result.serverReturnJsonString seriaToDic] objectForKey:@"DataContext"];
            //上传成功的回调
            if(self.lzFileDidSuccessUpload){
                self.lzFileDidSuccessUpload(dic, self.tag, self.otherInfo);
            }
            NSLog(@"Result - requestId: %@, headerFields: %@, servercallback: %@",
                  
                  result.requestId,
                  
                  result.httpResponseHeaderFields,
                  
                  result.serverReturnJsonString);
        }
        return nil;
    }];
}
// 异步下载
- (void)downloadObjectAsync:(NSString*)downObjectKey {
    [self setupEnvironment];
    objectRequest = [OSSGetObjectRequest new];
    // required
    objectRequest.bucketName = bucketName;
    objectRequest.objectKey = [NSString stringWithFormat:@"%@/%@",_remotelyServerModel.path,downObjectKey];;
    
    // 图片处理
    //objectRequest.xOssProcess = @"image/resize,m_lfit,w_100,h_100";
    
    //optional
    weakself
    objectRequest.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        __strong __typeof(self) strongSelf = weakSelf;
       // CGFloat byWritten = [[NSString stringWithFormat:@"%lld",bytesWritten] floatValue];
        CGFloat ByteSent = [[NSString stringWithFormat:@"%lld",totalBytesWritten] floatValue];
        CGFloat BytesExpectedToSend = [[NSString stringWithFormat:@"%lld",totalBytesExpectedToWrite] floatValue];
        if(weakSelf.lzFileProgressDownload){
            
            strongSelf.lzFileProgressDownload(ByteSent / (BytesExpectedToSend * 1.0f),strongSelf.tag,strongSelf.otherInfo);
        }
    };
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[self getDocument] stringByAppendingPathComponent:[NSString stringWithFormat: @"%@" ,self.localPath]];
    if(![fileManager fileExistsAtPath:path]){
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filepath = [NSString stringWithFormat:@"%@/%@",path,self.localFileName];
    // NSString * docDir = [self getDocumentDirectory];
    // 如果需要直接下载到文件，需要指明目标文件地址 会下载失败
     objectRequest.downloadToFileURL = [NSURL fileURLWithPath:filepath];
    
    OSSTask * getTask = [client getObject:objectRequest];
    
    [getTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"download object success!");
            OSSGetObjectResult * getResult = task.result;
            if(self.lzFileDidSuccessDownload){
                self.lzFileDidSuccessDownload(getResult.objectMeta,self.tag,self.otherInfo);
            }
            NSLog(@"download dota length: %lu", [getResult.downloadedData length]);
        } else {
            if(self.lzFileDidErrorDownload){
                self.lzFileDidErrorDownload(@"connection error",@"result is nil",self.tag,self.otherInfo);
            }
            NSLog(@"download object failed, error: %@" ,task.error);
            
        }
        return nil;
    }];
    //[getTask waitUntilFinished];  // 等待下载完才执行其他操作
}
-(void)downloadFile//:(NSString*)filename
{
    RemotelyServerModel *remotelyServerModel =[AliyunViewModel getAliyunServer];

    AliyunViewModel *aliyunViewModel = [[AliyunViewModel alloc] init];
    
    //    // 如果是在这个分区就是阿里云查看
    if ([self.fileDownId longLongValue] > [remotelyServerModel.minpartition longLongValue] && remotelyServerModel != nil
        && self.fileDownId) {
        // 判断账号是否过期
        if ([aliyunViewModel aliyunAccountIsOverTime]) {
            GetRemotelyAccountModel getAcount = ^(RemotelyAccountModel *acountModel) {
                NSLog(@"原账号过期===》》成功获取新的账号信息");
                [self downloadObjectAsync:self.fileDownId];
            };
            [[[AliyunViewModel alloc] init] sendApiGetRemotelyAcountModel:remotelyServerModel.rfsid getAcountBlock:getAcount];
        }
        else {
            [self downloadObjectAsync:self.fileDownId];
        }
         return;
    }
 
    NSLog(@"+++++++++走了理正云下载");
    filesize = 0;
    fileTransferType = 0;
    downloaded = 0;
    dataNote=[[NSMutableData alloc]init];
    
    //未进入错误区，即未响应错误事件；
    interErrorEvent = NO;
    
    //http地址
//    urlString=@"http://miscp.lizheng.com.cn:8081/FileDownload.aspx?filename=/2014-12/111.png&token=d008bb43-9cea-433b-854a-cbbdc71b7705";
    
    if(self.downloadUrl!=nil){
        urlString = self.downloadUrl;
    }
    else {
        urlString=@"%@://%@:%@/FileDownload.aspx?filename=%@%@&token=%@";
        urlString = [NSString stringWithFormat: urlString , self.protocol, self.server,self.port, self.remotePath,  self.remoteFileName, token];
    }
    
    //转成NSURL，
    NSURL *url=[AppUtils urlToNsUrl:urlString];
    //负载请求
    //NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //     request.timeoutInterval =
    //异步请求，通过一个delegate来做数据的下载以及Request的接受等等消息，
    //此处delegate:self，所以需要本类实现一些方法，并且定义receivedData做数据的接受
    
    //创建客户端文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[self getDocument] stringByAppendingPathComponent:[NSString stringWithFormat: @"%@" ,self.localPath]];
    if(![fileManager fileExistsAtPath:path]){
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    /* 使用post模式，下载资源包 */
    if(self.postDataForDownload!=nil){
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"]; //设置预期接收数据的格式
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"]; //设置发送数据的格式

//        NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
        
        NSData *postDatas = [NSJSONSerialization dataWithJSONObject:self.postDataForDownload options:NSJSONWritingPrettyPrinted error:nil];
        [request setHTTPBody:postDatas];
    }
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    [connection start];
}

// 停止文件下载
-(void)downloadFilePause
{
    
    if (objectRequest) {
        [objectRequest cancel];
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(downloadFile) object:nil];
    [connection cancel];
}
-(void)aliyunStarUpload {
    /* 上传的时候再对fileid处理一遍 */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *fileids = [[[AliyunViewModel  alloc] init] aliyunFileidsDelOverTimerfileids];
        if (fileids.count > 1) {
            objectKey = [fileids lastObject];  // 分配key
            NSLog(@"阿里云key:%@",objectKey);
            [[AliyunFileidsDAL shareInstance] deleteFileidWithFileid:objectKey];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self uploadObjectAsync]; // 开始异步上传
            });
        }
        else { // id用完的情况下
            NSLog(@"fileid不够用了");
            GetRemotelyFileids fileidsblock = ^(NSArray *fileids) {
                NSMutableArray *fileidarr = [NSMutableArray arrayWithArray:fileids];
                objectKey = [fileidarr lastObject];
                [[AliyunFileidsDAL shareInstance] deleteFileidWithFileid:objectKey];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self uploadObjectAsync]; // 开始异步上传
                });
            };
            [[[AliyunViewModel alloc] init] sendApiGetFileidswithSuccessBlock:fileidsblock];
        }
    });
}
// 上传文件
-(void)uploadFile //:(NSString*)filename
{
//   NSInteger mintes = [AppDateUtil IntervalMinutesForString:[LZUserDataManager getLastestLoginDate] endDate:[AppDateUtil GetCurrentDateForString]];
  
    /* 阿里云 */
    RemotelyServerModel *serverModel = [AliyunViewModel getAliyunServer];
    AliyunViewModel *aliyunViewModel = [[AliyunViewModel alloc] init];
    self.appDelegate.lzGlobalVariable.aliyunAccountModel = [[AliyunRemotelyAccountDAL shareInstance] getAccountModel];
    //NSMutableArray *fileids = [[AliyunFileidsDAL shareInstance] getFileids];
    if (serverModel.activationstatus == 1
        && serverModel != nil
        //&& self.appDelegate.lzGlobalVariable.aliyunAccountModel != nil
        && !self.isUserLeading
        && !self.isNotUserAliyun) { // 阿里云服务器激活了
        NSLog(@"阿里云账号已用时间：%ld",[aliyunViewModel getAliyunAccountDateInterval]);
        
        if ([aliyunViewModel aliyunAccountIsOverTime]) {
            GetRemotelyAccountModel getAcount = ^(RemotelyAccountModel *acountModel) {
                NSLog(@"原账号过期===》》成功获取新的账号信息");
                 [self aliyunStarUpload];
            };
            [[[AliyunViewModel alloc] init] sendApiGetRemotelyAcountModel:serverModel.rfsid getAcountBlock:getAcount];
            
        }
        else {
            [self aliyunStarUpload];
        }
       
        NSLog(@"++++++=====走了阿里云上传");
        return;
    }
    
    NSLog(@"++++++=====走了理正云上传");
    fileTransferType = 1;
    
    //未进入错误区，即未响应错误事件；
    interErrorEvent = NO;
    //json
    dataNote=[[NSMutableData alloc]init];
    
    
    //create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //Set Params
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:5*60*1000];
    [request setHTTPMethod:@"POST"];
    
    //Create boundary, it can be anything
    NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
    
    // set Content-Type in HTTP header
    NSString *contentType_in = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType_in forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    
    NSString *FileParamConstant = @"file";
    
    //NSData *imageData = [NSData dataWithContentsOfFile:@"/Users/yuwen/Library/Developer/CoreSimulator/Devices/53D92665-B19D-4E95-B5B0-441333AC27AB/data/Containers/Data/Application/DACB9EDF-41C2-4859-8201-AACE45170DFB/Documents/test/111.png"];
    
    //NSString *path = [[self getDocument] stringByAppendingPathComponent:@"test/111.png"];
    
    NSString *path = [[self getDocument] stringByAppendingPathComponent:[NSString stringWithFormat: @"%@%@" ,self.localPath,  self.localFileName]];// 获取本地文件
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        
        [self getErrorInfoid:[LZUtils CreateGUID]
                    ErrorUid:[AppUtils GetCurrentUserID]
                  ErrorTitle:[NSString stringWithFormat:@"文件上传失败"]
                  ErrorClass:@""
                 ErrorMethod:@""
                   ErrorData:[NSString stringWithFormat:@"%@\n\n%@",self.localPath,self.localFileName]
                   ErrorDate:[AppDateUtil GetCurrentDateForString]
                   ErrorType:2];
        //确定委托是否存在Entered方法
        if([delegate respondsToSelector:@selector(didErrorUpload:message:tag:otherInfo:)])
        {
            //发送委托方法，方法的参数
            [delegate  didErrorUpload: @"file not exists " message: [NSString stringWithFormat: @"%@%@" ,self.localPath,  self.localFileName] tag:self.tag otherInfo:self.otherInfo];
        }
        
        //确定block是否存在
        if(self.lzFileDidErrorUpload){
            self.lzFileDidErrorUpload(@"file not exists ",[NSString stringWithFormat: @"%@%@" ,self.localPath,  self.localFileName],self.tag,self.otherInfo);
        }
        
        return;
    }
    
    NSData *fileData = [NSData dataWithContentsOfFile:path];
    
    
    //FileOp *fileOp = [FileOp alloc];
    
    //NSString *path = [[self getDocument] stringByAppendingPathComponent:@"test/222.png"];
    
    
    //UIImage * image = [fileOp getImageFormDecoument:@"test/111.png"];
    
    //NSData *imageData = UIImageJPEGRepresentation(image, 1);
    //NSData *imageData = UIImagePNGRepresentation(image);
    
    filesize = fileData.length;
    
    //NSLog(@"打印%ld",(long)(imageData.length));
    //Assuming data is not nil we add this to the multipart form
    if (fileData)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"Content-Type:image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
//        NSString *extName = @"";
//        if([self.localFileName rangeOfString:@"."].location!=NSNotFound){
//            extName = [self.localFileName substringFromIndex:[self.localFileName rangeOfString:@"." options:NSBackwardsSearch].location];
//        }
        if ([self.showFileName length]>0) {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", FileParamConstant ,self.showFileName] dataUsingEncoding:NSUTF8StringEncoding]];

        }else{
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", FileParamConstant ,self.localFileName] dataUsingEncoding:NSUTF8StringEncoding]];

        }
        
        [body appendData:[@"Content-Type:application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:fileData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //Close off the request with the boundary
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the request
    [request setHTTPBody:body];
    
    //NSString *baseUrl = @"http://miscp.lizheng.com.cn:8081/FileUpload.aspx?filename=/2014-12/111.png&token=d008bb43-9cea-433b-854a-cbbdc71b7705&NeatUpload_PostBackID=fa01659d2-4d33-443a-bc48-8ca7f209f086";
    
    if(self.uploadUrl!=nil){
        urlString = self.uploadUrl;
    }
    else {
        urlString=@"%@://%@:%@/FileUpload.aspx?filename=%@%@&token=%@&NeatUpload_PostBackID=%@";
        urlString = [NSString stringWithFormat: urlString , self.protocol, self.server,self.port ,self.remotePath,  self.remoteFileName, token, [self createGUID]];
    }
    
    // set URL
    [request setURL:[LZUtils urlToNsUrl:urlString]];
    
//    [req setHTTPMethod:@"POST"];
//    [req setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    [connection start];
    
}

//停止文件上传
-(void)uploadFilePause
{
    if (put) {
        [put cancel]; // 阿里云取消上传
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(uploadFile) object:nil];
    //[[self class] cancelPreviousPerformRequestsWithTarget:self];
    [connection cancel];
}

-(NSString *) getDocument
{
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

//创建GUID
-(NSString *)createGUID{
    NSString *  result;
    CFUUIDRef   uuid;
    CFStringRef uuidStr;
    uuid = CFUUIDCreate(NULL);
    uuidStr = CFUUIDCreateString(NULL, uuid);
    result =[NSString stringWithFormat:@"%@", uuidStr];
    CFRelease(uuidStr);
    CFRelease(uuid);
    return result;
}

//请求返回
- (void) connection:(NSURLConnection *)connection
 didReceiveResponse:(NSURLResponse *)response{
    
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if(httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)]){
        NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
        
        if(self.downloadFileSize){
            filesize = self.downloadFileSize;
        }
        else {
            filesize = [[httpResponseHeaderFields objectForKey:@"Content-Length"] longLongValue];
        }
        contentType = [httpResponseHeaderFields objectForKey:@"Content-Type"] ;
        
    }
    
    if (fileTransferType==0) {
        NSLog(@"download file size:%ld ", (long)filesize);
    }
    
    NSLog(@"contentType:%@", contentType);
    NSLog(@"statusCode:%ld", (long)[httpResponse statusCode]);
    
    
}
//从网络上下载的数据,直到数据全部下载完成
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSMutableData *)data{
    [dataNote appendData:data];
    
    if (downloaded < filesize) {
        downloaded += data.length;
    }
    
    if (filesize > 0) {
        
        //确定委托是否存在Entered方法
        if(delegate && [delegate respondsToSelector:@selector(progressDownload:tag:otherInfo:)])
        {
            //发送委托方法，方法的参数
            [delegate progressDownload:downloaded / (filesize * 1.0f) tag:self.tag otherInfo:self.otherInfo];
        }
        //确定block是否存在
        if(self.lzFileProgressDownload){
            self.lzFileProgressDownload(downloaded / (filesize * 1.0f),self.tag,self.otherInfo);
        }
        
        //确定委托是否存在Entered方法
        if(delegate && [delegate respondsToSelector:@selector(progressDetailDownload:totalBytesWritten:totalLength:tag:otherInfo:)])
        {
            //发送委托方法，方法的参数
            [delegate progressDetailDownload:data.length totalBytesWritten:downloaded totalLength:filesize tag:self.tag otherInfo:self.otherInfo];
        }
    }
}



//上传进度
- (void)connection:(NSURLConnection  *)connection
   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{

    //确定委托是否存在Entered方法
    if(delegate && [delegate respondsToSelector:@selector(progressUpload:tag:otherInfo:)])
    {
        //发送委托方法，方法的参数
        [delegate progressUpload:totalBytesWritten / (totalBytesExpectedToWrite * 1.0f) tag:self.tag otherInfo:self.otherInfo];
    }
    //确定block是否存在
    if(self.lzFileProgressUpload){
        self.lzFileProgressUpload(totalBytesWritten / (totalBytesExpectedToWrite * 1.0f),self.tag,self.otherInfo);
    }
    
    //确定委托是否存在Entered方法
    if(delegate && [ delegate respondsToSelector:@selector(progressDetailUpload:totalBytesWritten:totalLength:tag:otherInfo:)])
    {
        //发送委托方法，方法的参数
        [ delegate progressDetailUpload:bytesWritten totalBytesWritten:totalBytesWritten totalLength:totalBytesExpectedToWrite tag:self.tag otherInfo:self.otherInfo];
    }
    
    
}
//http交互正常，完成。
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //未进入错误区，即未响应错误事件；
    //interErrorEvent = YES;
    
    if (interErrorEvent == YES) {
        return;
    }
    
    //过程中出错
    if (dataNote == nil) {
        
        NSLog(@"tag:%@, result:%@",self.tag , @" error");
        if (fileTransferType == 0) {
            if (errortimes < MAX_ERROR_TIMES) {
                errortimes++;
                
                NSLog(@"文件下载失败%d次，filename:%@, response return dataNote is null", errortimes, self.localFileName);
                //重新下载
//                if (self.appDelegate.xmppStream.isAuthenticated == YES) {
//                    NSLog(@"文件下载失败 - 已认证 - 2秒后重新下载");
//                    [self performSelector:@selector(downloadFile) withObject:nil afterDelay:2];
//                }
//                else
                {
                    NSLog(@"文件下载失败 - 未认证 - 2秒后重新下载");
                    [self performSelector:@selector(downloadFile) withObject:nil afterDelay:2];
                }
            }
            else
            {
                [self getErrorInfoid:[LZUtils CreateGUID]
                            ErrorUid:[AppUtils GetCurrentUserID]
                          ErrorTitle:[NSString stringWithFormat:@"文件下载失败"]
                          ErrorClass:@""
                         ErrorMethod:@""
                           ErrorData:@"result is nil"
                           ErrorDate:[AppDateUtil GetCurrentDateForString]
                           ErrorType:2];
                //确定委托是否存在Entered方法
                if(delegate && [delegate respondsToSelector:@selector(didErrorDownload:message:tag:otherInfo:)])
                {
                    //发送委托方法，方法的参数
                    [delegate  didErrorDownload: @"connection error" message: @"result is nil" tag:self.tag otherInfo:self.otherInfo];
                }
                
                //确定block是否存在
                if(self.lzFileDidErrorDownload){
                    self.lzFileDidErrorDownload(@"connection error",@"result is nil",self.tag,self.otherInfo);
                }
            }
        }
        else
        {
            if (errortimes < MAX_ERROR_TIMES) {
                errortimes++;
                
                NSLog(@"文件上传失败%d次，filename:%@, response return dataNote is null ", errortimes, self.localFileName);
                
//                //重新上传
//                if (self.appDelegate.xmppStream.isAuthenticated == YES) {
//                    NSLog(@"文件上传失败 - 已认证 - 2秒后重新上传");
//                    [self performSelector:@selector(uploadFile) withObject:nil afterDelay:2];
//                }
//                else
                {
                    NSLog(@"文件上传失败 - 未认证 - 10秒后重新上传");
                    [self performSelector:@selector(uploadFile) withObject:nil afterDelay:10];
                }

            }
            else
            {
                
                [self getErrorInfoid:[LZUtils CreateGUID]
                            ErrorUid:[AppUtils GetCurrentUserID]
                          ErrorTitle:[NSString stringWithFormat:@"文件上传失败"]
                          ErrorClass:@""
                         ErrorMethod:@""
                           ErrorData:@"result is nil"
                           ErrorDate:[AppDateUtil GetCurrentDateForString]
                           ErrorType:2];
                //确定委托是否存在Entered方法
                if(delegate && [delegate respondsToSelector:@selector(didErrorUpload:message:tag:otherInfo:)])
                {
                    //发送委托方法，方法的参数
                    [delegate  didErrorUpload: @"connection error" message: @"result is nil" tag:self.tag otherInfo:self.otherInfo];
                }
                
                //确定block是否存在
                if(self.lzFileDidErrorUpload){
                    self.lzFileDidErrorUpload(@"connection error",@"result is nil",self.tag,self.otherInfo);
                }
            }
        }
        
        return;
    }
    //download
    if (fileTransferType == 0) {
        
        //没有josn说明是正确下载
        if ([contentType rangeOfString:@"json"].location ==NSNotFound)
        {
            
            NSString *path = [[self getDocument] stringByAppendingPathComponent:[NSString stringWithFormat: @"%@%@" ,self.localPath,  self.localFileName]];
            
            //当完成交互，也就是说数据下载完成时，就创建该文件
            [[NSFileManager defaultManager]createFileAtPath:path contents:dataNote attributes:nil];
            
            NSLog(@"download success,%@",path);
            //成功
            if (dataNote.length == filesize) {
                NSArray *arrKey = [[NSArray alloc]initWithObjects:@"errmsg",@"errcode", nil];
                NSArray *arrValue = [[NSArray alloc]initWithObjects:@"ok",@"0", nil];
                NSDictionary *successDic = [[NSDictionary alloc]initWithObjects:arrValue
                                                                        forKeys:arrKey];
                
                //确定委托是否存在Entered方法
                if([delegate respondsToSelector:@selector(didSuccessDownload:tag:otherInfo:)])
                {
                    //发送委托方法，方法的参数
                    [delegate  didSuccessDownload: successDic tag:self.tag otherInfo:self.otherInfo];
                    /*{
                     errcode = 0;
                     errmsg = ok;
                     fileid = 8;
                     }
                     */
                }
                
                //确定block是否存在
                if(self.lzFileDidSuccessDownload){
                    self.lzFileDidSuccessDownload(successDic,self.tag,self.otherInfo);
                }
                
                [self getErrorInfoid:[LZUtils CreateGUID]
                            ErrorUid:[AppUtils GetCurrentUserID]
                          ErrorTitle:[NSString stringWithFormat:@"文件下载成功"]
                          ErrorClass:@""
                         ErrorMethod:@""
                           ErrorData:[NSString stringWithFormat:@"%@",[successDic dicSerial]]
                           ErrorDate:[AppDateUtil GetCurrentDateForString]
                           ErrorType:2];
            }
            else
            {
                //算失败
                NSString *jsonString = @"{errmsg:'原文件大小与下载的结果文件大小不一样',errcode:-5001}";
                
                if (errortimes < MAX_ERROR_TIMES) {
                    errortimes++;
                    NSLog(@"文件下载失败%d次，filename:%@, json error:%@", errortimes, self.localFileName, jsonString);
                    
//                    //重新下载
//                    if (self.appDelegate.xmppStream.isAuthenticated == YES) {
//                        NSLog(@"文件下载失败 - 已认证 - 2秒后重新下载");
//                        [self performSelector:@selector(downloadFile) withObject:nil afterDelay:2];
//                    }
//                    else
                    {
                        NSLog(@"文件下载失败 - 未认证 - 10秒后重新下载");
                        [self performSelector:@selector(downloadFile) withObject:nil afterDelay:2];
                    }
                }
                else
                {
                    
                    [self getErrorInfoid:[LZUtils CreateGUID]
                                ErrorUid:[AppUtils GetCurrentUserID]
                              ErrorTitle:[NSString stringWithFormat:@"文件下载失败"]
                              ErrorClass:@""
                             ErrorMethod:@""
                               ErrorData:[NSString stringWithFormat:@"%@",jsonString]
                               ErrorDate:[AppDateUtil GetCurrentDateForString]
                               ErrorType:2];
                    if(delegate && [delegate respondsToSelector:@selector(didErrorDownload:message:tag:otherInfo:)])
                    {
                        //发送委托方法，方法的参数
                        [delegate  didErrorDownload: @"json" message: jsonString tag:self.tag otherInfo:self.otherInfo];
                    }
                    
                    //确定block是否存在
                    if(self.lzFileDidErrorDownload){
                        self.lzFileDidErrorDownload(@"json",jsonString,self.tag,self.otherInfo);
                    }
                }
 
            }
        }
        else
        {
            //算失败
            NSString *jsonString = [[NSString alloc] initWithData:dataNote encoding:NSUTF8StringEncoding];
            
            if (errortimes < MAX_ERROR_TIMES) {
                errortimes++;
                NSLog(@"文件下载失败%d次，filename:%@, josn error:%@", errortimes, self.localFileName, jsonString);
                
//                //重新下载
//                if (self.appDelegate.xmppStream.isAuthenticated == YES) {
//                    NSLog(@"文件下载失败 - 已认证 - 2秒后重新下载");
//                    [self performSelector:@selector(downloadFile) withObject:nil afterDelay:2];
//                }
               // else
                {
                    NSLog(@"文件下载失败 - 未认证 - 10秒后重新下载");
                    [self performSelector:@selector(downloadFile) withObject:nil afterDelay:2];
                }
            }
            else
            {
                [self getErrorInfoid:[LZUtils CreateGUID]
                            ErrorUid:[AppUtils GetCurrentUserID]
                          ErrorTitle:[NSString stringWithFormat:@"文件下载失败"]
                          ErrorClass:@""
                         ErrorMethod:@""
                           ErrorData:[NSString stringWithFormat:@"%@",jsonString]
                           ErrorDate:[AppDateUtil GetCurrentDateForString]
                           ErrorType:2];

                if(delegate && [delegate respondsToSelector:@selector(didErrorDownload:message:tag:otherInfo:)])
                {
                    //发送委托方法，方法的参数
                    [delegate  didErrorDownload: @"json" message: jsonString tag:self.tag otherInfo:self.otherInfo];
                }
                
                //确定block是否存在
                if(self.lzFileDidErrorDownload){
                    self.lzFileDidErrorDownload(@"json",jsonString,self.tag,self.otherInfo);
                }
            }
        }
        
    }
    else
    {
        //正常返回为json
        if ([contentType rangeOfString:@"json"].location !=NSNotFound)
        {
            NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:dataNote options:kNilOptions error:nil];
            NSLog(@"tag:%@, upload success %@", self.tag, dic);

            // errcode == 0 为正确上传
            if ( ([[dic allKeys] containsObject:@"ErrorCode"]
                  && [[[dic lzNSDictonaryForKey:@"ErrorCode"] allKeys] containsObject:@"Code"]
                  &&  [[[dic objectForKey:@"ErrorCode"] objectForKey:@"Code"] intValue] == 0)
               ||
                ([[dic allKeys] containsObject:@"errcode"]
                && [dic[@"errcode"] intValue] == 0) ) {
                //NSString *jsonString = [[NSString alloc] initWithData:dataNote encoding:NSUTF8StringEncoding];
                
//                NSDictionary *dataContext = [dic objectForKey:@"DataContext"];
//                if (dataContext == nil) {
//                    NSString *jsonString = [[NSString alloc] initWithData:dataNote encoding:NSUTF8StringEncoding];
//                    dataContext = [jsonString seriaToDic];
//                }
                NSDictionary *dataContext = [dic lzNSDictonaryForKey:@"DataContext"];
                if(self.isCustomUploadUrl){
                    NSString *jsonString = [[NSString alloc] initWithData:dataNote encoding:NSUTF8StringEncoding];
                    dataContext = [jsonString seriaToDic];
                }
                    
                if(delegate && [delegate respondsToSelector:@selector(didSuccessUpload:tag:otherInfo:)])
                {
                    //发送委托方法，方法的参数
                    [delegate  didSuccessUpload:dataContext tag:self.tag otherInfo:self.otherInfo];
                }
                //确定block是否存在
                if(self.lzFileDidSuccessUpload){
                    self.lzFileDidSuccessUpload(dataContext, self.tag, self.otherInfo);
                }
                
                [self getErrorInfoid:[LZUtils CreateGUID]
                            ErrorUid:[AppUtils GetCurrentUserID]
                          ErrorTitle:[NSString stringWithFormat:@"文件上传成功"]
                          ErrorClass:@""
                         ErrorMethod:@""
                           ErrorData:[NSString stringWithFormat:@"%@",dataContext]
                           ErrorDate:[AppDateUtil GetCurrentDateForString]
                           ErrorType:2];
                
            }
            else
            {
                NSString *jsonString = [[NSString alloc] initWithData:dataNote encoding:NSUTF8StringEncoding];
                
                if (errortimes < MAX_ERROR_TIMES) {
                    errortimes++;
                    NSLog(@"文件上传失败%d次，filename:%@, json error:%@", errortimes, self.localFileName,jsonString);
                    
//                    //重新上传
//                    if (self.appDelegate.xmppStream.isAuthenticated == YES) {
//                        NSLog(@"文件上传失败 - 已认证 - 2秒后重新上传");
//                        [self performSelector:@selector(uploadFile) withObject:nil afterDelay:2];
//                    }
//                    else
                    {
                        NSLog(@"文件上传失败 - 未认证 - 10秒后重新上传");
                        [self performSelector:@selector(uploadFile) withObject:nil afterDelay:10];
                    }
                }
                else
                {

                    [self getErrorInfoid:[LZUtils CreateGUID]
                                ErrorUid:[AppUtils GetCurrentUserID]
                              ErrorTitle:[NSString stringWithFormat:@"文件上传失败"]
                              ErrorClass:@""
                             ErrorMethod:@""
                               ErrorData:[NSString stringWithFormat:@"%@",jsonString]
                               ErrorDate:[AppDateUtil GetCurrentDateForString]
                               ErrorType:2];
                    //算失败
                    if(delegate && [delegate respondsToSelector:@selector(didErrorUpload:message:tag:otherInfo:)])
                    {
                        //发送委托方法，方法的参数
                        [delegate  didErrorUpload: @"json" message: jsonString tag:self.tag otherInfo:self.otherInfo];
                    }
                    
                    //确定block是否存在
                    if(self.lzFileDidErrorUpload){
                        self.lzFileDidErrorUpload(@"json", jsonString, self.tag, self.otherInfo);
                    }
                }
            }
            
        }
        else
        {
            //算失败
            NSString *jsonString = [[NSString alloc] initWithData:dataNote encoding:NSUTF8StringEncoding];
            
            if (errortimes < MAX_ERROR_TIMES) {
                errortimes++;
                NSLog(@"文件上传失败%d次，filename:%@，html error:%@", errortimes, self.localFileName, jsonString);
                
//                //重新上传
//                if (self.appDelegate.xmppStream.isAuthenticated == YES) {
//                    NSLog(@"文件上传失败 - 已认证 - 2秒后重新上传");
//                    [self performSelector:@selector(uploadFile) withObject:nil afterDelay:2];
//                }
//                else
                {
                    NSLog(@"文件上传失败 - 未认证 - 10秒后重新上传");
                    [self performSelector:@selector(uploadFile) withObject:nil afterDelay:10];
                }
            }
            else
            {
                
                [self getErrorInfoid:[LZUtils CreateGUID]
                            ErrorUid:[AppUtils GetCurrentUserID]
                          ErrorTitle:[NSString stringWithFormat:@"文件上传失败"]
                          ErrorClass:@""
                         ErrorMethod:@""
                           ErrorData:[NSString stringWithFormat:@"%@",jsonString]
                           ErrorDate:[AppDateUtil GetCurrentDateForString]
                           ErrorType:2];
                if(delegate && [delegate respondsToSelector:@selector(didErrorUpload:message:tag:otherInfo:)])
                {
                    //发送委托方法，方法的参数
                    [delegate  didErrorUpload: @"html" message: jsonString tag:self.tag otherInfo:self.otherInfo];
                }
                //确定block是否存在
                if(self.lzFileDidErrorUpload){
                    self.lzFileDidErrorUpload(@"html", jsonString, self.tag, self.otherInfo);
                }
            }
        }
    }
}

//网络连接不成功，出现异常。
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    /*//如果出现异常，弹出对话框给出原因
     UIAlertView *errorAlert = [[UIAlertView alloc]
     initWithTitle: [error localizedDescription]
     message: [error localizedFailureReason]
     delegate:nil
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
     [errorAlert show];
     [errorAlert release];
     */
    
    //未进入错误区，即未响应错误事件；
    interErrorEvent = YES;
       
    
    if (fileTransferType == 0) {
        if (errortimes < MAX_ERROR_TIMES) {
            errortimes++;
            NSLog(@"文件下载失败%d次，filename:%@，connection error:%@, reason:%@", errortimes, self.localFileName, [error localizedDescription],[error localizedFailureReason]);
            
//            //重新下载
//            if (self.appDelegate.xmppStream.isAuthenticated == YES) {
//                NSLog(@"文件下载失败 - 已认证 - 2秒后重新下载");
//                [self performSelector:@selector(downloadFile) withObject:nil afterDelay:2];
//            }
//            else
            {
                NSLog(@"文件下载失败 - 未认证 - 10秒后重新下载");
                [self performSelector:@selector(downloadFile) withObject:nil afterDelay:2];
            }
        }
        else
        {
            [self getErrorInfoid:[LZUtils CreateGUID]
                        ErrorUid:[AppUtils GetCurrentUserID]
                      ErrorTitle:[NSString stringWithFormat:@"文件下载失败"]
                      ErrorClass:@""
                     ErrorMethod:@""
                       ErrorData:[NSString stringWithFormat:@"%@\n\n%@",[error localizedDescription], [error localizedFailureReason]]
                       ErrorDate:[AppDateUtil GetCurrentDateForString]
                       ErrorType:2];
            //确定委托是否存在Entered方法
            if(delegate && [delegate respondsToSelector:@selector(didErrorDownload:message:tag:otherInfo:)])
            {
                //发送委托方法，方法的参数
                [delegate  didErrorDownload: [error localizedDescription] message: [error localizedFailureReason] tag:self.tag otherInfo:self.otherInfo];
            }
            
            //确定block是否存在
            if(self.lzFileDidErrorDownload){
                self.lzFileDidErrorDownload([error localizedDescription],[error localizedFailureReason],self.tag,self.otherInfo);
            }
        }
        
    }
    else
    {
        if (errortimes < MAX_ERROR_TIMES) {
            errortimes++;
            NSLog(@"文件上传失败%d次，filename:%@，connection error:%@, reason:%@", errortimes, self.localFileName, [error localizedDescription],[error localizedFailureReason]);
            
//            //重新上传
//            if (self.appDelegate.xmppStream.isAuthenticated == YES) {
//                NSLog(@"文件上传失败 - 已认证 - 2秒后重新上传");
//                [self performSelector:@selector(uploadFile) withObject:nil afterDelay:2];
//            }
//            else
            {
                NSLog(@"文件上传失败 - 未认证 - 10秒后重新上传");
                [self performSelector:@selector(uploadFile) withObject:nil afterDelay:10];
            }
        }
        else
        {
            [self getErrorInfoid:[LZUtils CreateGUID]
                        ErrorUid:[AppUtils GetCurrentUserID]
                      ErrorTitle:[NSString stringWithFormat:@"文件上传失败"]
                      ErrorClass:@""
                     ErrorMethod:@""
                       ErrorData:[NSString stringWithFormat:@"%@\n\n%@",[error localizedDescription], [error localizedFailureReason]]
                       ErrorDate:[AppDateUtil GetCurrentDateForString]
                       ErrorType:2];
            //确定委托是否存在Entered方法
            if(delegate && [delegate respondsToSelector:@selector(didErrorUpload:message:tag:otherInfo:)])
            {
                //发送委托方法，方法的参数
                [delegate  didErrorUpload: [error localizedDescription] message: [error localizedFailureReason] tag:self.tag otherInfo:self.otherInfo];
            }
            //确定block是否存在
            if(self.lzFileDidErrorUpload){
                self.lzFileDidErrorUpload([error localizedDescription], [error localizedFailureReason], self.tag, self.otherInfo);
            }
        }
    }
    
}

-(void)getErrorInfoid:(NSString *)errorid ErrorUid:(NSString *)erroruid ErrorTitle:(NSString *)errortitle ErrorClass:(NSString *)errorclass ErrorMethod:(NSString *)errormethod ErrorData:(NSString *)errordata ErrorDate:(NSString *)errordate ErrorType:(NSInteger )errortype{
    ErrorModel *errorModel=[[ErrorModel alloc]init];
    
    errorModel.errorid=errorid;
    errorModel.errortitle=errortitle;
    errorModel.erroruid=erroruid;
    errorModel.errorclass=errorclass;
    errorModel.errormethod=errormethod;
    errorModel.errordata=errordata;
    errorModel.errordate=[LZFormat String2Date:errordate];
    errorModel.errortype=errortype;
    [[ErrorDAL shareInstance]addDataWithErrorModel:errorModel];
}

@end

