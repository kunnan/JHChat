//
//  oss_ios_demo.m
//  oss_ios_demo
//
//  Created by zhouzhuo on 9/16/15.
//  Copyright (c) 2015 zhouzhuo. All rights reserved.
//

#import "AliyunOSS.h"
#import <AliyunOSSiOS/OSSService.h>
#import "ModuleServerUtil.h"
#import "AppDelegate.h"
#import "AliyunViewModel.h"
#import "TZImagePickerViewModel.h"
#import "UploadFileModel.h"
#import "NSData+Base64.h"

#import "AliyunRemotelyAccountDAL.h"
#import "AliyunRemotrlyServerDAL.h"

#import "NSString+SerialToDic.h"
#import "OSSClient+LZExpand.h"
#import "AppDelegate.h"

#import "FilePathUtil.h"
#import "AppDateUtil.h"
#import "ErrorDAL.h"

@interface AliyunOSS ()
{
    NSString *AccessKey;
    NSString *SecretKey;
    NSString *securitytoken;
    NSString *bucketName ;
    NSDictionary *ossDic;
    RemotelyServerModel *_remotelyServerModel;
    RemotelyAccountModel *_remotelytAccountModel;
     __block BOOL isfinish;
    
    NSString *endpoint;
    
    OSSClientConfiguration * conf;
    
    NSInteger initClient;
    
    NSDate *aliyunSendapiTime;
    NSDate *initClientTime;
    NSDate *didInitTime;
    // 保证初始化只走一次
    NSInteger initTag;
}
@property (nonatomic, strong) OSSClient *client;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) id<OSSCredentialProvider> credential;

@end
NSString * const multipartUploadKey = @"multipartUploadObject";
static dispatch_queue_t queue4demo;

@implementation AliyunOSS

static AliyunOSS *instance = nil;

+(void)setInstanceToNil
{
    instance = nil;
}
+ (instancetype)sharedInstance {
    @synchronized(self) {
        if (instance == nil) {
            instance = [AliyunOSS new];
            dispatch_async(dispatch_get_main_queue(), ^{
                AppDelegate *appDelegate2 = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate2.lzGlobalVariable.isInitAliyunClient = YES;
            });
        }
    }
    return instance;
}
//-(OSSClient *)client {
//    if (_client == nil ) {
//        _client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:self.credential clientConfiguration:conf];
//    }
//    return _client;
//}
//-(id<OSSCredentialProvider>)credential {
//    if (_credential== nil) {
//         _credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:AccessKey secretKeyId:SecretKey securityToken:securitytoken];
//    }
//    return _credential;
//}
-(void)setData:(NSData *)data {
    _data = data;
}
-(AppDelegate *)appDelegate {
    if (_appDelegate == nil) {
        _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return _appDelegate;
}
- (void)setupEnvironment {
    _remotelyServerModel = [AliyunViewModel getAliyunServer];
    _remotelytAccountModel = [AliyunViewModel getAcountModelFormLocal];
    
    [self setParametre];
}
-(void)setParametre{
    bucketName = _remotelyServerModel.bucket;
    AccessKey = _remotelytAccountModel.accesskey;
    
    SecretKey = _remotelytAccountModel.accesskeysecret;
    securitytoken = _remotelytAccountModel.securitytoken;
    
    //[OSSLog enableLog];
    [self initOSSClient];

}
- (void)runDemo {
    /*************** 以下每个方法调用代表一个功能的演示，取消注释即可运行 ***************/

    // 罗列Bucket中的Object
    // [self listObjectsInBucket];

    // 异步上传文件
    // [self uploadObjectAsync];

    // 同步上传文件
    // [self uploadObjectSync];

    // 异步下载文件
    // [self downloadObjectAsync];

    // 同步下载文件
    // [self downloadObjectSync];

    // 复制文件
    // [self copyObjectAsync];

    // 签名Obejct的URL以授权第三方访问
    // [self signAccessObjectURL];

    // 分块上传的完整流程
    // [self multipartUpload];

    // 只获取Object的Meta信息
    // [self headObject];

    // 罗列已经上传的分块
    // [self listParts];

    // 自行管理UploadId的分块上传
    // [self resumableUpload];
    
}

// get local file dir which is readwrite able
- (NSString *)getDocumentDirectory {
    NSString * path = NSHomeDirectory();
    NSLog(@"NSHomeDirectory:%@",path);
    NSString * userName = NSUserName();
    NSString * rootPath = NSHomeDirectoryForUser(userName);
    NSLog(@"NSHomeDirectoryForUser:%@",rootPath);
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (void)initOSSClient {
    
    [OSSLog enableLog];

    @synchronized (self) {
            didInitTime = [AppDateUtil GetCurrentDate];
            //  保证全局内只需要保持一个OSSClient
            NSInteger intervalTime = [AppDateUtil IntervalMinutes:initClientTime endDate:aliyunSendapiTime];
            NSInteger intervalDidInitTile = [AppDateUtil IntervalMinutes:initClientTime endDate:didInitTime];
            
            if (self.appDelegate.lzGlobalVariable.isInitAliyunClient) {
                self.appDelegate.lzGlobalVariable.isInitAliyunClient = NO;
                NSString *data = [NSString stringWithFormat:@"initClient:%ld,intervalTime:%ld,intervalDidInitTile:%ld,initTag:%ld",initClient,intervalTime,intervalDidInitTile,initTag];
                [[ErrorDAL shareInstance] addDataWithTitle:@"调用initWithEndpoint：" data:data errortype:Error_Type_TwentyOne];
                
                initTag ++;
                if (initClient == 1) {
                    initClient++;
                }
                initClientTime = [AppDateUtil GetCurrentDate];
                NSLog(@"走了阿里云初始化:%ld,%ld,%ld",initClient,intervalTime,initTag);
                NSLog(@"走了阿里云初始化2:%ld,%ld",initClient,intervalDidInitTile);
                _credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:AccessKey secretKeyId:SecretKey securityToken:securitytoken];
                conf = [OSSClientConfiguration new];
                conf.maxRetryCount = 2;
                conf.timeoutIntervalForRequest = 30;
                conf.timeoutIntervalForResource = 24 * 60 * 60;
                
                endpoint = @"";
                if([[_remotelyServerModel.rfsurl lowercaseString] hasPrefix:@"http"]){
                    endpoint = _remotelyServerModel.rfsurl;
                } else {
                    endpoint = [NSString stringWithFormat:@"https://%@.aliyuncs.com",_remotelyServerModel.rfsurl];
                }
                
                _client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:_credential clientConfiguration:conf];
           
            }
        }
}

#pragma mark work with normal interface

- (void)createBucket {
    OSSCreateBucketRequest * create = [OSSCreateBucketRequest new];
    create.bucketName = bucketName;
    create.xOssACL = @"public-read";
    create.location = [ossDic lzNSStringForKey:@"rfsurl"];

    OSSTask * createTask = [self.client createBucket:create];

    [createTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"create bucket success!");
        } else {
            NSLog(@"create bucket failed, error: %@", task.error);
        }
        return nil;
    }];
}

- (void)deleteBucket {
    OSSDeleteBucketRequest * delete = [OSSDeleteBucketRequest new];
    delete.bucketName = bucketName;

    OSSTask * deleteTask = [self.client deleteBucket:delete];

    [deleteTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"delete bucket success!");
        } else {
            NSLog(@"delete bucket failed, error: %@", task.error);
        }
        return nil;
    }];
}

- (void)listObjectsInBucket {
    OSSGetBucketRequest * getBucket = [OSSGetBucketRequest new];
    getBucket.bucketName = @"android-test";
    getBucket.delimiter = @"";
    getBucket.prefix = @"";


    OSSTask * getBucketTask = [self.client getBucket:getBucket];

    [getBucketTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            OSSGetBucketResult * result = task.result;
            NSLog(@"get bucket success!");
            for (NSDictionary * objectInfo in result.contents) {
                NSLog(@"list object: %@", objectInfo);
            }
        } else {
            NSLog(@"get bucket failed, error: %@", task.error);
        }
        return nil;
    }];
}

// 异步上传
- (void)uploadObjectAsync {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];

    // required fields
    put.bucketName = bucketName;
    put.objectKey = [NSString stringWithFormat:@"%@/%@",_remotelyServerModel.path,_objectKey];  // fileid
    
    //NSString * docDir = [self getDocumentDirectory];
    //NSString *path = [NSString stringWithFormat:@"%@%@",_AbsolutePath,_uploadfileModel.filePhysicalName];
    put.uploadingFileURL = [NSURL fileURLWithPath:_AbsolutePath];
//    put.uploadingData =  _data;
    // optional fields
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"当前上传段长度:%lld, 当前已经上传总长度:%lld, 一共需要上传的总长度:%lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        
    };
    
    //put.contentType = @"application/octet-stream";//设置文件类型
    put.contentMd5 = [OSSUtil base64Md5ForFilePath:_AbsolutePath]; //使用该请求头进行端到端检查
    put.contentEncoding = @"utf-8"; //指定该Object被下载时的内容编码格式
    put.contentDisposition = _fileName;//指定该Object被下载时的名称
    //put.objectMeta =  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value1", @"x-oss-meta-name1", nil];
    
    OSSTask * putTask = [self.client putObject:put];

    [putTask continueWithBlock:^id(OSSTask *task) {
        NSLog(@"objectKey: %@", put.objectKey);
        if (!task.error) {
            NSLog(@"upload object success!");
           
            [self callBack]; //上传成功后的回调
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
}

// 同步上传
- (void)uploadObjectSync {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];

    // required fields
    put.bucketName = bucketName;
    put.objectKey = _objectKey;
    NSString * docDir = [self getDocumentDirectory];
    put.uploadingFileURL = [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent:@"file1m"]];

    // optional fields
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
         // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    put.contentType = @"";
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    put.contentDisposition = @"";

    OSSTask * putTask = [self.client putObject:put];

    [putTask waitUntilFinished]; // 阻塞直到上传完成

    if (!putTask.error) {
        NSLog(@"upload object success!");
    } else {
        NSLog(@"upload object failed, error: %@" , putTask.error);
    }
}

// 追加上传

- (void)appendObject {
    OSSAppendObjectRequest * append = [OSSAppendObjectRequest new];

    // 必填字段
    append.bucketName = bucketName;
    append.objectKey = _objectKey;
    append.appendPosition = 0; // 指定从何处进行追加 已经上传总长度追加
    NSString * docDir = [self getDocumentDirectory];
    append.uploadingFileURL = [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent:@"file1m"]];

    // 可选字段
    append.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
         // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    // append.contentType = @"";
    // append.contentMd5 = @"";
    // append.contentEncoding = @"";
    // append.contentDisposition = @"";

    OSSTask * appendTask = [self.client appendObject:append];

    [appendTask continueWithBlock:^id(OSSTask *task) {
        NSLog(@"objectKey: %@", append.objectKey);
        if (!task.error) {
            NSLog(@"append object success!");
            OSSAppendObjectResult * result = task.result;
            NSString * etag = result.eTag;
            long nextPosition = result.xOssNextAppendPosition;
            NSLog(@"etag: %@, nextPosition: %ld", etag, nextPosition);
        } else {
            NSLog(@"append object failed, error: %@" , task.error);
        }
        return nil;
    }];
}
// 上传成功后的回调
-(void)callBack {
    AppDelegate *appDelegate2 = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    OSSPutObjectRequest * request = [OSSPutObjectRequest new];
    request.bucketName = bucketName;
    request.objectKey =[NSString stringWithFormat:@"%@/%@",_remotelyServerModel.path,_objectKey];;
    request.uploadingFileURL =[NSURL fileURLWithPath:_AbsolutePath];;

    NSData *nsdata = [_fileName dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    
    // 设置回调参数 文件类型在上传成功后的回调里面[NSString stringWithFormat:@"bucket=${bucket}&filename=%@&size=${size}&mimeType=${mimeType}&height=${imageInfo.height}&width=${imageInfo.width}&key=${object}",base64Decoded]
    request.callbackParam = @{
                              @"callbackUrl": [NSString stringWithFormat:@"%@/api/filemanager/handler/aliyunosscallbackfunction/%@/%@/%@",_remotelyServerModel.callbackurl,_remotelyServerModel.rfsid,File_Upload_FileType_File,appDelegate2.lzservice.tokenId],
                              @"callbackBody":[NSString stringWithFormat:@"bucket=${bucket}&filename=%@&size=${size}&mimeType=${mimeType}&height=${imageInfo.height}&width=${imageInfo.width}&key=${object}",base64Encoded],
                            @"callbackBodyType": @"application/x-www-form-urlencoded"
                              };
    // 设置自定义变量application/jsonapplication/x-www-form-urlencoded
    //                                request.callbackVar = @{
    //                                                        @"<var1>": @"<value1>",
    //                                                        @"<var2>": @"<value2>"
    //                                                        };
    request.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        //zz
        CGFloat send = [[NSString stringWithFormat:@"%lld",bytesSent] floatValue];
//        CGFloat ByteSent = [[NSString stringWithFormat:@"%lld",totalByteSent] floatValue];
        CGFloat BytesExpectedToSend = [[NSString stringWithFormat:@"%lld",totalBytesExpectedToSend] floatValue];
        if(self.lzFileProgressUpload){
            self.lzFileProgressUpload(send / (BytesExpectedToSend * 1.0f),self.tag,self.otherInfo);
        }

        NSLog(@"回调：%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
     
    };
    OSSTask * task = [self.client putObject:request];
    [task continueWithBlock:^id(OSSTask *task) {
        
        if (task.error) {
            
            OSSLogError(@"回调失败：%@", task.error);
            
        } else {
            
            OSSPutObjectResult * result = task.result;
            NSDictionary *dic = [result.serverReturnJsonString seriaToDic];
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
 //图片处理SDK
-(NSString *)getDownImageUrlWithObjectKey:(NSString*)objectKey withSize:(NSString*)size fixedOrLfit:(NSString*)parameter isExistedImg:(BOOL)isExistedImg{
    
    return [self getConstrainUrlWithObjectKey:objectKey withSize:size fixedOrLfit:parameter count:0 isExistedImg:isExistedImg];
    
}
-(NSString *)getDownImageUrlWithObjectKey2:(NSString*)objectKey withSize:(NSString*)size fixedOrLfit:(NSString*)parameter count:(NSInteger)count isExistedImg:(BOOL)isExistedImg{

    return [self getConstrainUrlWithObjectKey:objectKey withSize:size fixedOrLfit:parameter count:count isExistedImg:isExistedImg];

}
-(NSString*)getConstrainUrlWithObjectKey:(NSString*)objectKey withSize:(NSString*)size fixedOrLfit:(NSString*)parameter count:(NSInteger)count isExistedImg:(BOOL)isExistedImg{
    AliyunViewModel *aliyunViewModel = [[AliyunViewModel alloc] init];
    /* 对进入程序时加载消息头像进行处理<##> */
    __block NSInteger resCount = count;
    NSInteger repeatCount = count;

    
    _remotelyServerModel = [AliyunViewModel getAliyunServer];
    /* 是否过期 && resCount < 5*/
    if ([aliyunViewModel aliyunAccountIsOverTime] && resCount < 5) {
      
        if (!isExistedImg || !self.appDelegate.lzGlobalVariable.isSendingAliyunApi) {
           
            NSLog(@"获取新的账号信息：%ld",resCount);
            GetRemotelyAccountModel getAcount = ^(RemotelyAccountModel *acountModel) {
               aliyunSendapiTime = [AppDateUtil GetCurrentDate];
                self.appDelegate.lzGlobalVariable.isInitAliyunClient = YES;
                // 请求完成
                self.appDelegate.lzGlobalVariable.isSendingAliyunApi = NO;
                NSLog(@"获取url时，原账号过期===》》成功获取新的账号信息：%ld",resCount);
                self.appDelegate.lzGlobalVariable.aliyunAccountModel = acountModel;
                initClient++;
                NSLog(@"账号过期要走阿里云初始化:%ld",initClient);
                [self setupEnvironment];
                
                [self getDownImageUrlWithObjectKey2:objectKey withSize:size fixedOrLfit:parameter count:resCount isExistedImg:isExistedImg];
            };
            resCount ++;
            //请求前
            self.appDelegate.lzGlobalVariable.isSendingAliyunApi = YES;
            [[[AliyunViewModel alloc] init] sendApiGetRemotelyAcountModel:_remotelyServerModel.rfsid getAcountBlock:getAcount];
        }
    }
    
    if ([aliyunViewModel getAliyunAccountDateInterval] <= 55) {
        [self setupEnvironment];
        NSString * constrainURL = nil;
        OSSTask *task= nil;
        if (size == nil) {
            if (self.isread) {
                task = [self.client presignPublicURLWithBucketName:_remotelyServerModel.readbucket withObjectKey:[NSString stringWithFormat:@"%@/%@",_remotelyServerModel.path,objectKey]];
            }
            else {
                 task = [self.client presignConstrainURLWithBucketName:bucketName withObjectKey:[NSString stringWithFormat:@"%@/%@",_remotelyServerModel.path,objectKey]withExpirationInterval:30 * 60];// 有效期一个小时
            }
        }
        else {
            task = [self.client lzPresignConstrainURLWithBucketName:bucketName
                                                  withObjectKey:[NSString stringWithFormat:@"%@/%@",_remotelyServerModel.path,objectKey]
                                         withExpirationInterval:30 * 60
                                                 withParameters:@{@"x-oss-process": [NSString stringWithFormat:@"image/resize,m_%@,w_%@,h_%@",parameter,size,size]}];
        }
        
        if (!task.error) {
            constrainURL = task.result;

            
        } else {
            NSLog(@"error: %@", task.error);
        }
        
        //  [OSSClient retain]: message sent to deallocated instance 0x600002a43120
        return constrainURL;
    }
    
    if (repeatCount <=20) {
        repeatCount ++;
        /* 还需要从新请求 */
        [self getDownImageUrlWithObjectKey2:objectKey withSize:size fixedOrLfit:parameter count:repeatCount isExistedImg:isExistedImg];

    }
    
    return @"";
}


// 异步下载
- (void)downloadObjectAsync:(NSString*)objectKey {
    [self setupEnvironment];
    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
    // required
    request.bucketName = bucketName;
    request.objectKey = [NSString stringWithFormat:@"%@/%@",_remotelyServerModel.path,objectKey];;

    //optional
    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        NSLog(@"%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    };
    // NSString * docDir = [self getDocumentDirectory];
    // // 如果需要直接下载到文件，需要指明目标文件地址
     //request.downloadToFileURL = [NSURL fileURLWithPath:_AbsolutePath];

    // 图片处理
    //request.xOssProcess = @"image/resize,m_lfit,w_100,h_100";
    
    OSSTask * getTask = [self.client getObject:request];

    [getTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"download object success!");
            OSSGetObjectResult * getResult = task.result;
            NSLog(@"download dota length: %lu", [getResult.downloadedData length]);
        } else {
            NSLog(@"download object failed, error: %@" ,task.error);
            
        }
        return nil;
    }];
}
-(void)downImageWithKey:(NSString*)objectKey {
    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
    request.bucketName = bucketName;
    request.objectKey = [NSString stringWithFormat:@"%@/%@",_remotelyServerModel.path,objectKey];
    // 图片处理
    request.xOssProcess = @"image/resize,m_lfit,w_32,h_32";
    request.downloadToFileURL = [NSURL fileURLWithPath:_AbsolutePath];
    OSSTask * getTask = [self.client getObject:request];
    [getTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"download image success!");
            OSSGetObjectResult * getResult = task.result;
            NSLog(@"download image data: %@", getResult.downloadedData);
        } else {
            NSLog(@"download object failed, error: %@" ,task.error);
        }
        return nil;
    }];
    
    
}
// 同步下载
- (void)downloadObjectSync:(NSString*)objectKey {
    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
    // required
    request.bucketName = bucketName;
    request.objectKey =  [NSString stringWithFormat:@"%@/%@",_remotelyServerModel.path,objectKey];

    //optional
    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        NSLog(@"%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    };
    // NSString * docDir = [self getDocumentDirectory];
    // request.downloadToFileURL = [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent:@"downloadfile"]];
    // // 如果需要直接下载到文件，需要指明目标文件地址
    request.downloadToFileURL = [NSURL fileURLWithPath:_AbsolutePath];
    OSSTask * getTask = [self.client getObject:request];

    [getTask waitUntilFinished];

    if (!getTask.error) {
        OSSGetObjectResult * result = getTask.result;
        NSLog(@"download data length: %lu", [result.downloadedData length]);
    } else {
        NSLog(@"download data error: %@", getTask.error);
    }
}

// 获取meta
- (void)headObject {
    OSSHeadObjectRequest * head = [OSSHeadObjectRequest new];
    head.bucketName = bucketName;
    head.objectKey = _objectKey;

    OSSTask * headTask = [self.client headObject:head];

    [headTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            OSSHeadObjectResult * headResult = task.result;
            NSLog(@"all response header: %@", headResult.httpResponseHeaderFields);

            // some object properties include the 'x-oss-meta-*'s
            NSLog(@"head object result: %@", headResult.objectMeta);
        } else {
            NSLog(@"head object error: %@", task.error);
        }
        return nil;
    }];
}

// 删除Object
- (void)deleteObject {
    OSSDeleteObjectRequest * delete = [OSSDeleteObjectRequest new];
    delete.bucketName = bucketName;
    delete.objectKey =_objectKey;

    OSSTask * deleteTask = [self.client deleteObject:delete];

    [deleteTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"delete success !");
        } else {
            NSLog(@"delete erorr, error: %@", task.error);
        }
        return nil;
    }];
}

// 复制Object
- (void)copyObjectAsync {
    OSSCopyObjectRequest * copy = [OSSCopyObjectRequest new];
    copy.bucketName = bucketName; // 复制到哪个bucket
    copy.objectKey = _objectKey; // 复制为哪个object
    copy.sourceCopyFrom = [NSString stringWithFormat:@"/%@/%@",bucketName, _objectKey]; // 从哪里复制

    OSSTask * copyTask = [self.client copyObject:copy];

    [copyTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"copy success!");
        } else {
            NSLog(@"copy error, error: %@", task.error);
        }
        return nil;
    }];
}

// 签名URL授予第三方访问
- (void)signAccessObjectURL {
//    NSString * constrainURL = nil;
//    NSString * publicURL = nil;

    // sign constrain url
    OSSTask * task = [self.client presignConstrainURLWithBucketName:bucketName
                                                 withObjectKey:_objectKey
                                        withExpirationInterval:60 * 30];
    if (!task.error) {
//        constrainURL = task.result;
    } else {
        NSLog(@"error: %@", task.error);
    }

    // sign public url
    task = [self.client presignPublicURLWithBucketName:bucketName
                                    withObjectKey:_objectKey];
    if (!task.error) {
//        publicURL = task.result;
    } else {
        NSLog(@"sign url error: %@", task.error);
    }
}

// 分块上传
- (void)multipartUpload {

    __block NSString * uploadId = nil;
    __block NSMutableArray * partInfos = [NSMutableArray new];

    NSString * uploadToBucket = bucketName;
    NSString * uploadObjectkey = _objectKey;

    OSSInitMultipartUploadRequest * init = [OSSInitMultipartUploadRequest new];
    init.bucketName = uploadToBucket;
    init.objectKey = uploadObjectkey;
    init.contentType = @"application/octet-stream";
    //init.objectMeta = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value1", @"x-oss-meta-name1", nil];

    OSSTask * initTask = [self.client multipartUploadInit:init];

    [initTask waitUntilFinished];

    // 先获取到用来标识整个上传事件的UploadId
    if (!initTask.error) {
        OSSInitMultipartUploadResult * result = initTask.result;
        uploadId = result.uploadId;
        NSLog(@"init multipart upload success: %@", result.uploadId);
    } else {
        NSLog(@"multipart upload failed, error: %@", initTask.error);
        return;
    }

    for (int i = 1; i <= 20; i++) {
        @autoreleasepool {
            OSSUploadPartRequest * uploadPart = [OSSUploadPartRequest new];
            uploadPart.bucketName = uploadToBucket;
            uploadPart.objectkey = uploadObjectkey;
            uploadPart.uploadId = uploadId;
            uploadPart.partNumber = i; // part number start from 1

            NSString * docDir = [self getDocumentDirectory];
            // uploadPart.uploadPartFileURL = [NSURL URLWithString:[docDir stringByAppendingPathComponent:@"file1m"]];
            uploadPart.uploadPartData = [NSData dataWithContentsOfFile:[docDir stringByAppendingPathComponent:_objectKey]];

            OSSTask * uploadPartTask = [self.client uploadPart:uploadPart];

            [uploadPartTask waitUntilFinished];

            if (!uploadPartTask.error) {
                OSSUploadPartResult * result = uploadPartTask.result;
                uint64_t fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:uploadPart.uploadPartFileURL.absoluteString error:nil] fileSize];
                [partInfos addObject:[OSSPartInfo partInfoWithPartNum:i eTag:result.eTag size:fileSize]];
            } else {
                NSLog(@"upload part error: %@", uploadPartTask.error);
                return;
            }
        }
    }

    OSSCompleteMultipartUploadRequest * complete = [OSSCompleteMultipartUploadRequest new];
    complete.bucketName = uploadToBucket;
    complete.objectKey = uploadObjectkey;
    complete.uploadId = uploadId;
    complete.partInfos = partInfos;

    OSSTask * completeTask = [self.client completeMultipartUpload:complete];

    [completeTask waitUntilFinished];

    if (!completeTask.error) {
        NSLog(@"multipart upload success!");
    } else {
        NSLog(@"multipart upload failed, error: %@", completeTask.error);
        return;
    }
}

// 罗列分块
- (void)listParts {
    OSSListPartsRequest * listParts = [OSSListPartsRequest new];
    listParts.bucketName =bucketName;
    listParts.objectKey = _objectKey;
    listParts.uploadId = @"265B84D863B64C80BA552959B8B207F0";

    OSSTask * listPartTask = [self.client listParts:listParts];

    [listPartTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"list part result success!");
            OSSListPartsResult * listPartResult = task.result;
            for (NSDictionary * partInfo in listPartResult.parts) {
                NSLog(@"each part: %@", partInfo);
            }
        } else {
            NSLog(@"list part result error: %@", task.error);
        }
        return nil;
    }];
}

// 断点续传
- (void)resumableUpload {
    __block NSString * recordKey;

    NSString * docDir = [self getDocumentDirectory];
    NSString * filePath = [docDir stringByAppendingPathComponent:@"file10m"];
    NSString * bucketName2 = nil;
    NSString * objectKey = _objectKey;

    [[[[[[OSSTask taskWithResult:nil] continueWithBlock:^id(OSSTask *task) {
        // 为该文件构造一个唯一的记录键
        NSURL * fileURL = [NSURL fileURLWithPath:filePath];
        NSDate * lastModified;
        NSError * error;
        [fileURL getResourceValue:&lastModified forKey:NSURLContentModificationDateKey error:&error];
        if (error) {
            return [OSSTask taskWithError:error];
        }
        recordKey = [NSString stringWithFormat:@"%@-%@-%@-%@", bucketName2, objectKey, [OSSUtil getRelativePath:filePath], lastModified];
        // 通过记录键查看本地是否保存有未完成的UploadId
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        return [OSSTask taskWithResult:[userDefault objectForKey:recordKey]];
    }] continueWithSuccessBlock:^id(OSSTask *task) {
        if (!task.result) {
            // 如果本地尚无记录，调用初始化UploadId接口获取
            OSSInitMultipartUploadRequest * initMultipart = [OSSInitMultipartUploadRequest new];
            initMultipart.bucketName = bucketName;
            initMultipart.objectKey = objectKey;
            initMultipart.contentType = @"application/octet-stream";
            return [self.client multipartUploadInit:initMultipart];
        }
        OSSLogVerbose(@"An resumable task for uploadid: %@", task.result);
        return task;
    }] continueWithSuccessBlock:^id(OSSTask *task) {
        NSString * uploadId = nil;

        if (task.error) {
            return task;
        }

        if ([task.result isKindOfClass:[OSSInitMultipartUploadResult class]]) {
            uploadId = ((OSSInitMultipartUploadResult *)task.result).uploadId;
        } else {
            uploadId = task.result;
        }

        if (!uploadId) {
            return [OSSTask taskWithError:[NSError errorWithDomain:OSSClientErrorDomain
                                                             code:OSSClientErrorCodeNilUploadid
                                                         userInfo:@{OSSErrorMessageTOKEN: @"Can't get an upload id"}]];
        }
        // 将“记录键：UploadId”持久化到本地存储
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:uploadId forKey:recordKey];
        [userDefault synchronize];
        return [OSSTask taskWithResult:uploadId];
    }] continueWithSuccessBlock:^id(OSSTask *task) {
        // 持有UploadId上传文件
        OSSResumableUploadRequest * resumableUpload = [OSSResumableUploadRequest new];
        resumableUpload.bucketName = bucketName;
        resumableUpload.objectKey = objectKey;
        resumableUpload.uploadId = task.result;
        resumableUpload.uploadingFileURL = [NSURL fileURLWithPath:filePath];
        
        resumableUpload.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            NSLog(@"%lld %lld %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
        };
        return [self.client resumableUpload:resumableUpload];
    }] continueWithBlock:^id(OSSTask *task) {
        if (task.error) {
            if ([task.error.domain isEqualToString:OSSClientErrorDomain] && task.error.code == OSSClientErrorCodeCannotResumeUpload) {
                // 如果续传失败且无法恢复，需要删除本地记录的UploadId，然后重启任务
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:recordKey];
            }
        } else {
            NSLog(@"upload completed!");
            // 上传成功，删除本地保存的UploadId
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:recordKey];
        }
        return nil;
    }];
}
@end
