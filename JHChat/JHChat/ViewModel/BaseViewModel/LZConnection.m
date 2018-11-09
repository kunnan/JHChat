//
//  LZLongPolling.m
//  LeadingCloud
//
//  Created by admin on 15/11/12.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  huangyue
 Date：   2015-11-13
 Version: 1.0
 Description: 长链接 处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZConnection.h"
#import "XHHTTPClient.h"
#import "NSString+IsNullOrEmpty.h"
#import "LZUserDataManager.h"
#import "ModuleServerUtil.h"
#import "ErrorDAL.h"
#import "NSObject+JsonSerial.h"
#import "AppDateUtil.h"
#import "UIAlertView+AlertWithMessage.h"
#import "AppDelegate.h"
#import "NSDictionary+DicSerial.h"
#import "ImChatLogDAL.h"
#import "FileUtil.h"
#import "DataExchangeParse.h"

#define DEFAULT_AFTERDELAY 2 //默认延迟时间 X 秒
#define DEFAULT_REDOCOUNT 3 //默认重复尝试 X 次 3
#define DEFAULT_SENDTOSERVER_REDOCOUNT 1 //默认向服务器请求数据尝试 X 次 5


@interface LZConnection ()
{
    //基础链接
    LZConnectionSuccessHandler _successHandler;
    LZConnectionFailureHandler _failureHandler;
    
    //发送
    LZConnectionSendSuccessHandler _sendSuccessHandler;
    LZConnectionSendFailureHandler _sendFailureHandler;
    
    LZURLConnection * conn_polling;
    
    LZURLConnection * conn_login;
    
    LZURLConnection * conn_getmsg;
    
    LZURLConnection * conn_send;
    
    //重发消息
    LZResendMessageHandler _resendMessageHandler;
    
    //长连接返回值处理
    LZLongPullResultHandler _longPullResultHandler;
    
    AppDelegate *appDelegate;
    
    /* 队列中的webapi */
    NSMutableArray *_queueWeApiArray;
    
}

@property (nonatomic, copy) NSString *syncKey;
@property (nonatomic, assign) int pollingFailCount;
@property (nonatomic, assign) int loginFailCount;
@property (nonatomic, assign) int getMessageFailCount;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) BOOL iscancel;
@property (nonatomic, copy) NSString *tokenId;

@property (nonatomic, copy) NSString *tagForConnection;
@property (nonatomic, copy) NSString *tagForLongPool;

@property (nonatomic, assign) int parseMsgFailCount;


/* webapi执行出错次数 */
@property (nonatomic, assign) int queueGettingFailCount;

@end

@implementation LZConnection

/*
 初始化
 */
-(id) initWithReady
{
    self.tagForConnection = [LZUtils CreateGUID];
    return self;
}

-(void)dealloc{
     DDLogVerbose(@"LZConnection --- 被销毁了");
}

/*
 链接成功
 */
- (void)setSuccessHandler:(LZConnectionSuccessHandler)successHandler
{
    
    _successHandler = [successHandler copy];
    
    //conn_getmsg
}


/*
 出错消息
 */
- (void)setFailureHandler:(LZConnectionFailureHandler)failureHandler
{
    _failureHandler = [failureHandler copy];
}

/*
 发送消息成功
 */
- (void)setSendSuccessHandler:(LZConnectionSendSuccessHandler)sendSuccessHandler;
{
    _sendSuccessHandler = [sendSuccessHandler copy];
}
/*
 发送消息失败
 */
- (void)setSendFailureHandler:(LZConnectionSendFailureHandler)sendFailureHandler;
{
    _sendFailureHandler = [sendFailureHandler copy];
}

/*
 重新发送消息
 */
- (void)setResendMessageHandler:(LZResendMessageHandler)resendMessageHandler;
{
    _resendMessageHandler = [resendMessageHandler copy];
}

/*
 长连接返回值处理
 */
- (void)setLongPullResultHandler:(LZLongPullResultHandler)longPullResultHandler{
    _longPullResultHandler = [longPullResultHandler copy];
}

/*
 设置登录信息
 */
-(void) setLoginInfo:(NSString *)tokenId msgserver:(NSString*)msgserver serverUrl:(NSString *)serverUrl
{
    [self cancal_conn];
    
    self.iscancel = NO;

    [self resetting_status];

    //令牌
    self.tokenId = tokenId;
}

/*
 取消链接
 */
-(void) cancal_conn
{

    self.iscancel = YES;
    
    if(conn_polling!=nil)
    {
        [conn_polling cancel];
        conn_polling.iscancel = YES;
    }
    
    if(conn_login!=nil)
    {
        [conn_login cancel];
        
        conn_login.iscancel =YES;
    }
    
    if(conn_getmsg!=nil)
    {
        [conn_getmsg cancel];
        conn_getmsg.iscancel = YES;
    }
    
    if(conn_send!=nil)
    {
        [conn_send cancel];
        conn_send.iscancel = YES;
    }
}


-(void) resetting_status
{
    
    self.syncKey = @"0";

    NSMutableDictionary *syncDic = [LZUserDataManager readSynkInfo];
    NSString *tempSyncKey = [syncDic lzNSStringForKey:[AppUtils GetCurrentUserID]];
    
    if(![NSString isNullOrEmpty:tempSyncKey] )
    {
        self.syncKey = [NSString stringWithFormat:@"%@",tempSyncKey];
    }
    
//    [FileUtil clearFile];
//    [[ImChatLogDAL shareInstance] deleteImChatLog];
//    self.syncKey = @"255211029200904192_255211044145209347_255211072586784768";
    
    self.pollingFailCount = 0;
    
    self.loginFailCount=0;
    
    self.getMessageFailCount=0;
    
    
    self.status = 0;
    
    //未链接
    self.connected = NO;
    
}

/*
 取消链接
 */
-(void)cancel
{
    [self cancal_conn];
    
    [self resetting_status];
    //sethandler 不能调，不然控制不住重复登录
    self.connecting = NO;
}



/*
 登录IM
 */
-(void)login
{
 
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlString =[NSString stringWithFormat:@"%@/api/connection/login/%@",
                              [ModuleServerUtil GetServerWithModule:Modules_Message],
                              self.tokenId
                              ];
        NSLog(@"lzconnection login urlString:%@",urlString);
        dispatch_async(dispatch_get_main_queue(), ^{
    
            conn_login = [XHHTTPClient
                          GETPath: urlString
                          jsonSuccessHandler:^(LZURLConnection *connection,  id json){
                            
                              self.connecting = NO;
                              if(connection.iscancel == YES) return;
                              
                              NSLog(@"lzconnection login json:%@",json);
                              NSString *code = [[json objectForKey:@"ErrorCode"] objectForKey:@"Code"];
                              
                              //登录成功
                              if([code isEqualToString:@"0"])
                              {
                                  //取得手机需要的数据
                                  if([[json objectForKey:@"DataContext"] isKindOfClass:[NSDictionary class]]){
                                      NSDictionary *datacontext = [json objectForKey:@"DataContext"];
                                      /* 服务器时间 */
                                      NSString *strTime = [datacontext objectForKey:@"time"];
                                      NSDate *serverDate = [LZFormat String2Date:strTime];
                                      NSDate *nowDate = [[NSDate alloc] init];
                                      NSTimeInterval time=[nowDate timeIntervalSinceDate:serverDate];
                                      time = -(time-1);   //手动增加一秒的误差
                                      [LZUserDataManager saveIntervalSeconds:(int)round(time)]; //保存差值
                                      
                                      /* 是否有消息可取 */
                                      NSNumber *state = [datacontext objectForKey:@"state"];
                                      appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                      /* 当这个状态有改变时，再去更改变量并刷新消息页签 */
                                      if ([self getCurrentPCLoginInStatus] != state.integerValue) {
                                          appDelegate.lzGlobalVariable.pcLoginInStatus = [self getPCLoginInStatus:state.integerValue];
                                          appDelegate.lzGlobalVariable.isNeedRefreshMessageRootHeaderView = YES;
                                      }
                                      DDLogVerbose(@"手机端登录时，PC端登录的状态%@",state);
                                  } else {
                                  }
                                  
                                  self.loginFailCount=0;
                                  self.connected = YES;
                                  
                                  /* 请求基础数据 */
                                  if ( _successHandler) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          _successHandler(json);
                                      });
                                  }
                                  
                                  NSString *poolTag = [LZUtils CreateGUID];
                                  NSString *errorTitle = [NSString stringWithFormat:@"开始longPolling=%@",poolTag];
                                  [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:self.tagForConnection errortype:Error_Type_Twelve];
                                  
                                  self.tagForLongPool = poolTag;
                                  /* 发送长连接 */
                                  [self longPolling:poolTag];
                              }
                              else
                              {
                                  NSString *message = [[json objectForKey:@"ErrorCode"] objectForKey:@"Message"];
                                  
                                  NSLog(@"lzconnection login error code:%d ; message:%@",
                                        [code intValue],
                                        message);
                                  
                                  self.connected = NO;
                                  if ( _failureHandler) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          _failureHandler([code intValue], message);
                                      });
                                  }
                                  
                                  /* 处理错误数据，保存到model中 */
                                  NSString *postdatas=[NSString string];
                                  
                                  NSString *errordata=[NSString stringWithFormat:@"post:\n%@\nresult:\n%@",postdatas,[self JSONUnicode2Utf8:json]];
                                  [self getErrorInfoid:[LZUtils CreateGUID]
                                            ErrorUid:[AppUtils GetCurrentUserID]
                                            ErrorTitle:@"login请求失败（ErrorCode非零）"
                                            ErrorClass:@""
                                            ErrorMethod:urlString
                                            ErrorData:errordata
                                            ErrorDate:[AppDateUtil GetCurrentDateForString]
                                            ErrorType:1];
                                  
                                  
                                  

                              }
                              
                          }
                          failureHandler:^(LZURLConnection *connection,NSData *responseData, NSURLResponse *response, NSError *error){
                              self.connecting = NO;
                              if(connection.iscancel == YES) return;
                              
                              //多次检测
                              NSString *dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                              dataString = [NSString stringWithFormat:@"%@",dataString];
                              
                              NSLog(@"lzconnection login error responseData:%@, error:%@",dataString,error);
                              self.loginFailCount++;
                              
                              if (self.loginFailCount>=DEFAULT_REDOCOUNT) {
                                  self.loginFailCount=0;
                                  self.connected = NO;
                                  
                                  if ( _failureHandler) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          _failureHandler(8840000, dataString);
                                      });
                                  }
                                  
                                  
                              }
                              else
                              {
                                  if(connection.iscancel == YES) return;//确保
                                  [self performSelector:@selector(login)
                                             withObject:nil
                                             afterDelay:DEFAULT_AFTERDELAY];
                                  
                              }
                              
                              /* 处理错误数据，保存到model中 */
                              NSString *postdatas=[NSString string];
                             // postdatas=[postdatas dictionaryToJson:[dataDic objectForKey:WebApi_DataSend_Post]];
                              
                              
                              
                              NSString *errordata=[NSString stringWithFormat:
                                                   @"post:\n%@\nstatuscode:%ld\nerror:\n%@",
                                                   postdatas,
                                                   (long)((NSHTTPURLResponse*)response).statusCode,
                                                   error];
                              
                              [self getErrorInfoid:[LZUtils CreateGUID]
                                        ErrorUid:[AppUtils GetCurrentUserID]
                                        ErrorTitle:[NSString stringWithFormat:@"login请求失败(%ld)",(long)((NSHTTPURLResponse*)response).statusCode]
                                        ErrorClass:@""
                                        ErrorMethod:urlString
                                        ErrorData:errordata
                                        ErrorDate:[AppDateUtil GetCurrentDateForString]
                                        ErrorType:1];

                          }
                          ];
        });
    });
}

/*
 发送
 */
-(void)send:(NSDictionary *)data {
    if(self.iscancel == YES) return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
       NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@", [ModuleServerUtil GetServerWithModule:Modules_Message], WebApi_Message_Send, self.tokenId];
       
       NSLog(@"lzconnection send urlString:%@",urlString);
       
       conn_send = [XHHTTPClient POSTPath:urlString parameters:data jsonSuccessHandler:^(LZURLConnection *connection, id json){
           [self getErrorInfoid:[LZUtils CreateGUID]
                      ErrorUid:[AppUtils GetCurrentUserID]
                    ErrorTitle:[NSString stringWithFormat:@"发送的新消息-开始"]
                    ErrorClass:@""
                   ErrorMethod:@""
                     ErrorData:[NSString stringWithFormat:@"%@\n\n%@\n\n%@",[data dicSerial],json,urlString]
                     ErrorDate:[AppDateUtil GetCurrentDateForString]
                     ErrorType:2];
          //不用 cancal 拦截
          NSLog(@"lzconnection send json:%@",json);
          
          NSString *code = [[json objectForKey:@"ErrorCode"] objectForKey:@"Code"];
                                
          /* 只要服务器给返回数据，就认为处理正确，此处不再判断code */
          id datacontext = [json objectForKey:@"DataContext"];
          /* 空值处理 */
          if(datacontext == [NSNull null] || datacontext == nil){
             datacontext = @"";
          }
          NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
          [dataDic setObject:WebApi_Message forKey:WebApi_Controller];
          [dataDic setObject:WebApi_Message_Send forKey:WebApi_Route];
          [dataDic setObject:datacontext forKey:WebApi_DataContext];
          [dataDic setObject:[json objectForKey:@"ErrorCode"] forKey:WebApi_ErrorCode];
          if (data != nil) {
             [dataDic setObject:data forKey:WebApi_DataSend_Post];
          }
          if (_sendSuccessHandler) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                _sendSuccessHandler(dataDic);
             });
          }
          //返回正确
          if([code isEqualToString:@"0"]) {
             NSDictionary *datacontext = [json objectForKey:@"DataContext"];
             //数据正确
             if( [json objectForKey:@"DataContext"] != [NSNull null] && datacontext.count>0) {
                /* 记录消息的跟踪日志 */
                 [self getErrorInfoid:[LZUtils CreateGUID]
                             ErrorUid:[AppUtils GetCurrentUserID]
                           ErrorTitle:[NSString stringWithFormat:@"发送的新消息-成功"]
                           ErrorClass:@""
                          ErrorMethod:@""
                            ErrorData:[NSString stringWithFormat:@"%@\n\n%@\n\n%@",[data dicSerial],json,urlString]
                            ErrorDate:[AppDateUtil GetCurrentDateForString]
                            ErrorType:2];
             }
          } else {
             NSString *message = [[json objectForKey:@"ErrorCode"] objectForKey:@"Message"];
             NSLog(@"lzconnection send error code:%d ; message:%@",[code intValue], message);
             /* 处理错误数据，保存到model中 */
             NSString *postdatas=[NSString string];
             //字典转字符串
             postdatas=[postdatas dictionaryToJson:data];
             NSString *errordata=[NSString stringWithFormat:@"post:\n%@\nresult:\n%@",postdatas,[self JSONUnicode2Utf8:json]];
             [self getErrorInfoid:[LZUtils CreateGUID]
                         ErrorUid:[AppUtils GetCurrentUserID]
                       ErrorTitle:@"发送的新消息，send请求失败（ErrorCode非零）"
                       ErrorClass:@""
                      ErrorMethod:urlString
                        ErrorData:errordata
                        ErrorDate:[AppDateUtil GetCurrentDateForString]
                        ErrorType:1];
          }
       } failureHandler:^(LZURLConnection *connection, NSData *responseData, NSURLResponse *response, NSError *error) {
          //不用 cancal 拦截
          NSString *dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
          dataString = [NSString stringWithFormat:@"%@",dataString];
          NSLog(@"lzconnection send error responseData:%@, error:%@",dataString,error);
          if ( _sendFailureHandler) {
             
             dataString = [NSString isNullOrEmpty:dataString] ? @"" : dataString;
             dispatch_async(dispatch_get_main_queue(), ^{
                //840000 : 要重发
                NSMutableDictionary *returnData = [[NSMutableDictionary alloc] initWithDictionary:data];
                [returnData setObject:@{@"Code":@"8840000",@"Message":dataString} forKey:WebApi_ErrorCode];
                _sendFailureHandler(0,data);
             });
          }
          /* 处理错误数据，保存到model中 */
          NSString *postdatas=[NSString string];
          postdatas=[postdatas dictionaryToJson:[data objectForKey:WebApi_DataSend_Post]];
          NSString *errordata=[NSString stringWithFormat:@"post:\n%@\nstatuscode:%ld\nerror:\n%@", postdatas, (long)((NSHTTPURLResponse*)response).statusCode, error];
          [self getErrorInfoid:[LZUtils CreateGUID]
                      ErrorUid:[AppUtils GetCurrentUserID]
                    ErrorTitle:[NSString stringWithFormat:@"发送的新消息，send请求失败(%ld)",(long)((NSHTTPURLResponse*)response).statusCode]
                    ErrorClass:@""
                   ErrorMethod:urlString
                     ErrorData:errordata
                     ErrorDate:[AppDateUtil GetCurrentDateForString]
                     ErrorType:1];
       }];
    });
}

-(void) longPolling{
    
    NSString *poolTag = [LZUtils CreateGUID];
    NSString *errorTitle = [NSString stringWithFormat:@"失败，重新开始longPolling=%@",poolTag];
    [[ErrorDAL shareInstance] addDataWithTitle:errorTitle data:self.tagForConnection errortype:Error_Type_Twelve];
    
    self.tagForLongPool = poolTag;
    /* 发送长连接 */
    [self longPolling:poolTag];
}

/*
 长链接
 */
-(void) longPolling:(NSString *)poolTag
{
    if(self.iscancel == YES) return;
    if(![self.tagForLongPool isEqualToString:poolTag]) return;
    
    /* 重新发送ImMsgQueue表中发送失败了的数据 */
    if ( _resendMessageHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _resendMessageHandler(nil);
        });
    }    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlString =[NSString stringWithFormat:@"%@/api/connection/check/%@/%@",
                              [ModuleServerUtil GetServerWithModule:Modules_Message],
                              self.syncKey,
                              self.tokenId
                              ];
        NSLog(@"lzconnection longPolling urlString:%@",urlString);
        dispatch_async(dispatch_get_main_queue(), ^{
    
            conn_polling = [XHHTTPClient  GETPath: urlString
                               jsonSuccessHandler:^(LZURLConnection *connection, id json){
                                  
                                   if(connection.iscancel == YES) return;
                                   if(![self.tagForLongPool isEqualToString:poolTag]) return;
                                   
                                   NSLog(@"lzconnection longPolling json:%@",json);
                                   NSString *code = [[json objectForKey:@"ErrorCode"] objectForKey:@"Code"];
                                   //返回正确
                                   if([code isEqualToString:@"0"])
                                   {
                                       self.pollingFailCount = 0;
                                       
                                       if([[json objectForKey:@"DataContext"] isKindOfClass:[NSDictionary class]]){
                                           NSDictionary *datacontext = [json objectForKey:@"DataContext"];
                                           /* 服务器时间 */
                                           NSString *strTime = [datacontext objectForKey:@"time"];
                                           NSDate *serverDate = [LZFormat String2Date:strTime];
                                           NSDate *nowDate = [[NSDate alloc] init];
                                           NSTimeInterval time=[nowDate timeIntervalSinceDate:serverDate];
                                           time = -(time-1);   //手动增加一秒的误差
                                           [LZUserDataManager saveIntervalSeconds:(int)round(time)]; //保存差值
                                           
                                           [self getErrorInfoid:[LZUtils CreateGUID]
                                                       ErrorUid:[AppUtils GetCurrentUserID]
                                                     ErrorTitle:[NSString stringWithFormat:@"长连接数据返回--%@",self.tagForConnection]
                                                     ErrorClass:@""
                                                    ErrorMethod:@""
                                                      ErrorData:[NSString stringWithFormat:@"%@\n\n%@\n\n%@",poolTag,json,urlString]
                                                      ErrorDate:[AppDateUtil GetCurrentDateForString]
                                                      ErrorType:Error_Type_Twelve];
                                           
                                           /* 是否有消息可取 */
                                           NSNumber *retNum = [datacontext objectForKey:@"ret"];
                                           int ret = retNum.intValue;
                                           if(ret == 0 && self.status ==0)
                                           {
                                               //时间到期，没有数据可取
                                               [self longPolling:poolTag];
                                           }
                                           else if(ret==-10)
                                           {
                                               DDLogError(@"当前用户在另一客户端登录！");
                                               _longPullResultHandler(json);
                                               
                                           }
                                           else
                                           {
                                               [self getErrorInfoid:[LZUtils CreateGUID]
                                                           ErrorUid:[AppUtils GetCurrentUserID]
                                                         ErrorTitle:[NSString stringWithFormat:@"有数据可取--新"]
                                                         ErrorClass:@""
                                                        ErrorMethod:@""
                                                          ErrorData:[NSString stringWithFormat:@"%@\n\n%@",json,urlString]
                                                          ErrorDate:[AppDateUtil GetCurrentDateForString]
                                                          ErrorType:2];
                                               
                                               //有数据可以取
                                               [self getMessage:poolTag];
                                           }
                                           /* 是否有消息可取 */
                                           NSNumber *state = [datacontext objectForKey:@"state"];
                                           appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                           /* 当这个状态有改变时，再去更改变量并刷新消息页签 */
                                           if ([self getCurrentPCLoginInStatus] != state.integerValue) {
                                               appDelegate.lzGlobalVariable.pcLoginInStatus = [self getPCLoginInStatus:state.integerValue];
                                               appDelegate.lzGlobalVariable.isNeedRefreshMessageRootHeaderView = YES;
                                           }
                                           DDLogVerbose(@"PC端登录的状态%@",state);
                                       } else {
                                           int datacontext = [[json objectForKey:@"DataContext"] intValue];
                                           if(datacontext == 0 && self.status ==0)
                                           {
                                               //时间到期，没有数据可取
                                               [self longPolling:poolTag];
                                           }
                                           else if(datacontext==-10)
                                           {
                                               DDLogError(@"当前用户在另一客户端登录！");
                                               _longPullResultHandler(json);
                                           }
                                           else
                                           {
                                               [self getErrorInfoid:[LZUtils CreateGUID]
                                                           ErrorUid:[AppUtils GetCurrentUserID]
                                                         ErrorTitle:[NSString stringWithFormat:@"有数据可取--老"]
                                                         ErrorClass:@""
                                                        ErrorMethod:@""
                                                          ErrorData:[NSString stringWithFormat:@"%@\n\n%@",json,urlString]
                                                          ErrorDate:[AppDateUtil GetCurrentDateForString]
                                                          ErrorType:2];
                                               
                                               [self getMessage:poolTag];
                                           }
                                       }
                                   }
                                   else
                                   {
                                       
                                       NSString *message = [[json objectForKey:@"ErrorCode"] objectForKey:@"Message"];
                                       NSLog(@"lzconnection longPolling error code:%d; message:%@",[code intValue],message);
                                       self.pollingFailCount++;
                                       //出错5次，让重新登录
                                       if (self.pollingFailCount>=DEFAULT_REDOCOUNT) {
                                           self.pollingFailCount = 0;
                                           
                                           self.connected = NO;
                                           if ( _failureHandler) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   _failureHandler([code intValue], message);
                                               });
                                           }
                                       }
                                       else
                                       {
                                           if(connection.iscancel == YES) return;
                                           
                                           //出错后，延时再试
                                           [self performSelector:@selector(longPolling)
                                                      withObject:nil
                                                      afterDelay:DEFAULT_AFTERDELAY];
                                       }
                                       
                                       
                                       
                                       
                                       /* 处理错误数据，保存到model中 */
                                       NSString *postdatas=[NSString string];
                                       
                                       NSString *errordata=[NSString stringWithFormat:@"post:\n%@\nresult:\n%@",postdatas,[self JSONUnicode2Utf8:json]];
                                       [self getErrorInfoid:[LZUtils CreateGUID]
                                                ErrorUid:[AppUtils GetCurrentUserID]
                                                ErrorTitle:@"longPolling请求失败（ErrorCode非零）"
                                                ErrorClass:@""
                                                ErrorMethod:urlString
                                                ErrorData:errordata
                                                ErrorDate:[AppDateUtil GetCurrentDateForString]
                                                ErrorType:1];
                                       
                                       
                                       

                                   }
                                   
                               }
                                   failureHandler:^(LZURLConnection *connection, NSData *responseData, NSURLResponse *response, NSError *error){
                                       if(connection.iscancel == YES) return;
                                       
                                       NSString *dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                                       
                                       dataString = [NSString stringWithFormat:@"%@",dataString];
                                       
                                       NSLog(@"lzconnection longPolling error responseData:%@, error:%@",dataString,error);
                                       self.pollingFailCount++;
                                       //出错5次，让重新登录
                                       if (self.pollingFailCount>=DEFAULT_REDOCOUNT) {
                                           self.pollingFailCount = 0;
                                           
                                           self.connected = NO;
                                           
                                           if ( _failureHandler) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   
                                                   _failureHandler(8840000, dataString);
                                               });
                                           }
                                       }
                                       else
                                       {
                                           if(connection.iscancel == YES) return;
                                           
                                           //出错后，延时再试
                                           [self performSelector:@selector(longPolling)
                                                      withObject:nil
                                                      afterDelay:DEFAULT_AFTERDELAY];
                                       }
                                       /* 处理错误数据，保存到model中 */
                                       NSString *postdatas=[NSString string];
                                       //postdatas=[postdatas dictionaryToJson:[dataDic objectForKey:WebApi_DataSend_Post]];
                                       
                                       
                                       
                                       NSString *errordata=[NSString stringWithFormat:
                                                            @"post:\n%@\nstatuscode:%ld\nerror:\n%@",
                                                            postdatas,
                                                            (long)((NSHTTPURLResponse*)response).statusCode,
                                                            error];
                                       
                                       [self getErrorInfoid:[LZUtils CreateGUID]
                                                ErrorUid:[AppUtils GetCurrentUserID]
                                                ErrorTitle:[NSString stringWithFormat:@"longPolling请求失败(%ld)",(long)((NSHTTPURLResponse*)response).statusCode]
                                                ErrorClass:@""
                                                ErrorMethod:urlString
                                                ErrorData:errordata
                                                ErrorDate:[AppDateUtil GetCurrentDateForString]
                                                ErrorType:1];

                                   }
                            ];
        });
    });
}
# pragma mark - 得到当前的web端登录状态
- (NSInteger)getCurrentPCLoginInStatus {
    switch (appDelegate.lzGlobalVariable.pcLoginInStatus) {
        case PCLoginInStatusOutLine:
            return 0;
            break;
        case PCLoginInStatusInLineNoNotice:
            return 1;
            break;
        case PCLoginInStatusInLineAndNotice:
            return 2;
            break;
            
        default:
            return 3;
            break;
    }
}
- (PCLoginInStatus)getPCLoginInStatus:(NSInteger)status {
    switch (status) {
        case 0:
            return PCLoginInStatusOutLine;
            break;
        case 1:
            return PCLoginInStatusInLineNoNotice;
            break;
        case 2:
            return PCLoginInStatusInLineAndNotice;
            break;
        default:
            return PCLoginInStatusOther;
            break;
    }
}
/*
 取得消息
 */
-(void)getMessage:(NSString *)poolTag
{
    if(self.iscancel == YES) return;
    if(![self.tagForLongPool isEqualToString:poolTag]) return;
    
    [self getErrorInfoid:[LZUtils CreateGUID]
                ErrorUid:[AppUtils GetCurrentUserID]
              ErrorTitle:[NSString stringWithFormat:@"开始请求数据--1--%@",self.syncKey]
              ErrorClass:@""
             ErrorMethod:@""
               ErrorData:[NSString stringWithFormat:@"%@",self.syncKey]
               ErrorDate:[AppDateUtil GetCurrentDateForString]
               ErrorType:2];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self getErrorInfoid:[LZUtils CreateGUID]
                    ErrorUid:[AppUtils GetCurrentUserID]
                  ErrorTitle:[NSString stringWithFormat:@"开始请求数据--2--%@",self.syncKey]
                  ErrorClass:@""
                 ErrorMethod:@""
                   ErrorData:[NSString stringWithFormat:@"%@",self.syncKey]
                   ErrorDate:[AppDateUtil GetCurrentDateForString]
                   ErrorType:2];
        
        NSString *urlString =[NSString stringWithFormat:@"%@/%@/%@/%@",
                              [ModuleServerUtil GetServerWithModule:Modules_Message],
                              WebApi_Message_Get,
                              self.syncKey,
                              self.tokenId
                              ];
        
        NSLog(@"lzconnection getMessage urlString:%@",urlString);
        conn_getmsg = [XHHTTPClient  GETPath: urlString
                          jsonSuccessHandler:^(LZURLConnection *connection,id json){
                              
                              [self getErrorInfoid:[LZUtils CreateGUID]
                                          ErrorUid:[AppUtils GetCurrentUserID]
                                        ErrorTitle:[NSString stringWithFormat:@"接收到新消息-1"]
                                        ErrorClass:@""
                                       ErrorMethod:@""
                                         ErrorData:[NSString stringWithFormat:@"%@\n\n%@",json,urlString]
                                         ErrorDate:[AppDateUtil GetCurrentDateForString]
                                         ErrorType:2];
                              
                              if(connection.iscancel == YES) return;
                              
                              NSLog(@"lzconnection getMessage json:%@",json);
                              NSString *code = [[json objectForKey:@"ErrorCode"] objectForKey:@"Code"];
                              //返回正确
                              if([code isEqualToString:@"0"])
                              {
                                  self.getMessageFailCount = 0;
                                  NSDictionary *datacontext = [json objectForKey:@"DataContext"];
                                  //数据正确
                                  if( [json objectForKey:@"DataContext"] != [NSNull null] && datacontext.count>0)
                                  {
                                      /* 记录消息的跟踪日志 */
//                                      NSMutableArray *msglist = [datacontext lzNSMutableArrayForKey:@"msglist"];
//                                      if(msglist.count>0){
                                      
                                          NSNumber *count = [datacontext lzNSNumberForKey:@"count"];
                                          [self getErrorInfoid:[LZUtils CreateGUID]
                                                    ErrorUid:[AppUtils GetCurrentUserID]
                                                    ErrorTitle:[NSString stringWithFormat:@"接收到新消息：%ld条",count.integerValue]
                                                    ErrorClass:@""
                                                    ErrorMethod:@""
                                                    ErrorData:[NSString stringWithFormat:@"%@\n\n%@",json,urlString]
                                                    ErrorDate:[AppDateUtil GetCurrentDateForString]
                                                     ErrorType:2];
//                                      }
                                      
                                      if(!LeadingCloud_MsgParseSerial){
                                          //接收数据
                                          if ( _sendSuccessHandler) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
                                                  [dataDic setObject:WebApi_Message forKey:WebApi_Controller];
                                                  [dataDic setObject:WebApi_Message_Get forKey:WebApi_Route];
                                                  [dataDic setObject:datacontext forKey:WebApi_DataContext];
                                                  [dataDic setObject:[json objectForKey:@"ErrorCode"] forKey:WebApi_ErrorCode];
                                                  
                                                  _sendSuccessHandler(dataDic);
                                                  
                                              });
                                          }
                                          
                                          //同步Synk
                                          self.syncKey = [datacontext objectForKey:@"synckey"];
                                          //最后的 synckeys
                                          NSMutableDictionary *syncDic = [LZUserDataManager readSynkInfo];
                                          
                                          NSMutableDictionary *syncDicCopy = [[NSMutableDictionary alloc] init];
                                          for (NSString *key in [syncDic allKeys]) {
                                              [syncDicCopy setObject:[syncDic objectForKey:key] forKey:key];
                                          }
                                          
                                          [syncDicCopy setObject:[self.syncKey copy] forKey:[AppUtils GetCurrentUserID]];
                                          [LZUserDataManager saveSynkInfo:syncDicCopy];
                                      } else {
                                          [self parseMsgSerical:json dataContext:datacontext poolTag:poolTag url:urlString];
                                      }
                                  }
                                  
                                  
                                  //继续取数据
                                  if(!LeadingCloud_MsgParseSerial){
                                      if( [json objectForKey:@"DataContext"] != [NSNull null]
                                         && [[datacontext objectForKey:@"continueflag"] integerValue] == 1)
                                      {
                                          [self getErrorInfoid:[LZUtils CreateGUID]
                                                      ErrorUid:[AppUtils GetCurrentUserID]
                                                    ErrorTitle:[NSString stringWithFormat:@"继续请求数据"]
                                                    ErrorClass:@""
                                                   ErrorMethod:@""
                                                     ErrorData:[NSString stringWithFormat:@"%@\n\n%@",json,urlString]
                                                     ErrorDate:[AppDateUtil GetCurrentDateForString]
                                                     ErrorType:2];
                                          
                                          [self getMessage:poolTag];
                                      }
                                      else
                                      {
                                          [self longPolling:poolTag];
                                      }
                                  }
                              }
                              else
                              {
                                  
                                  NSString *message = [[json objectForKey:@"ErrorCode"] objectForKey:@"Message"];
                                  NSLog(@"lzconnection getMessage error code:%d; message:%@",[code intValue],message);
                                  
                                  self.getMessageFailCount++;
                                  
                                  if (self.getMessageFailCount>=DEFAULT_REDOCOUNT) {
                                      self.getMessageFailCount=0;
                                      if ( _failureHandler) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              _failureHandler([code intValue], message);
                                          });
                                      }
                                  }
                                  else
                                  {
                                      if(connection.iscancel == YES) return;
                                      
                                      [self performSelector:@selector(longPolling)
                                                 withObject:nil
                                                 afterDelay:DEFAULT_AFTERDELAY];
                                      
                                  }
                                  
                                  /* 处理错误数据，保存到model中 */
                                  NSString *postdatas=[NSString string];
                                  //字典转字符串
                                  //postdatas=[postdatas dictionaryToJson:data];
                                  
                                  NSString *errordata=[NSString stringWithFormat:@"post:\n%@\nresult:\n%@",postdatas,[self JSONUnicode2Utf8:json]];
                                  [self getErrorInfoid:[LZUtils CreateGUID]
                                            ErrorUid:[AppUtils GetCurrentUserID]
                                            ErrorTitle:@"getMessage请求失败（ErrorCode非零）"
                                            ErrorClass:@""
                                            ErrorMethod:urlString
                                            ErrorData:errordata
                                            ErrorDate:[AppDateUtil GetCurrentDateForString]
                                            ErrorType:1];
                                  
                                  
                                  

                              }
                          }
                              failureHandler:^(LZURLConnection *connection,NSData *responseData, NSURLResponse *response, NSError *error){
                                  
                                  if(connection.iscancel == YES) return;
                                  
                                  NSString *dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                                  dataString = [NSString stringWithFormat:@"%@",dataString];
                                  
                                  NSLog(@"lzconnection getMessage error responseData:%@, error:%@",dataString,error);
                                  
                                  
                                  self.getMessageFailCount++;
                                  
                                  if (self.getMessageFailCount>=DEFAULT_REDOCOUNT) {
                                      self.getMessageFailCount=0;
                                      if ( _failureHandler) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              _failureHandler(8840000, dataString);
                                          });
                                      }
                                  }
                                  else
                                  {
                                      if(connection.iscancel == YES) return;
                                      
                                      [self performSelector:@selector(longPolling)
                                                 withObject:nil
                                                 afterDelay:DEFAULT_AFTERDELAY];
                                      
                                  }
                                  
                                  /* 处理错误数据，保存到model中 */
                                  NSString *postdatas=[NSString string];
                                 // postdatas=[postdatas dictionaryToJson:[dataDic objectForKey:WebApi_DataSend_Post]];
                                  
                                  
                                  
                                  NSString *errordata=[NSString stringWithFormat:
                                                       @"post:\n%@\nstatuscode:%ld\nerror:\n%@",
                                                       postdatas,
                                                       (long)((NSHTTPURLResponse*)response).statusCode,
                                                       error];
                                  
                                  [self getErrorInfoid:[LZUtils CreateGUID]
                                            ErrorUid:[AppUtils GetCurrentUserID]
                                            ErrorTitle:[NSString stringWithFormat:@"getMessage请求失败(%ld)",(long)((NSHTTPURLResponse*)response).statusCode]
                                            ErrorClass:@""
                                            ErrorMethod:urlString
                                            ErrorData:errordata
                                            ErrorDate:[AppDateUtil GetCurrentDateForString]
                                            ErrorType:1];

                              }
                       ];
    });
}

-(void)parseMsgSerical:(id)json dataContext:(NSDictionary *)datacontext poolTag:(NSString *)poolTag url:(NSString *)urlString{

    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:WebApi_Message forKey:WebApi_Controller];
    [dataDic setObject:WebApi_Message_Get forKey:WebApi_Route];
    [dataDic setObject:datacontext forKey:WebApi_DataContext];
    [dataDic setObject:[json objectForKey:@"ErrorCode"] forKey:WebApi_ErrorCode];
    DDLogVerbose(@"parseMsgSerical:开始解析消息数据");
    
    NSDate *showindexdate = [AppDateUtil GetCurrentDate];
//    DDLogVerbose(@"当前时间-1：%@",[AppDateUtil GetCurrentDateForString]);
    
    [[DataExchangeParse shareInstance] parseGetMessgae:dataDic parseResult:^(BOOL parseResult) {
//        parseResult = NO;
        DDLogVerbose(@"parseMsgSerical:消息数据解析处理完成");
        NSInteger intervalSeconds = [AppDateUtil IntervalMilliSeconds:showindexdate endDate:[AppDateUtil GetCurrentDate]];
//        DDLogVerbose(@"当前时间-2：%@",[AppDateUtil GetCurrentDateForString]);
        DDLogVerbose(@"新消息处理的时间时长为:%ld毫秒",labs(intervalSeconds));
        [self getErrorInfoid:[LZUtils CreateGUID]
                    ErrorUid:[AppUtils GetCurrentUserID]
                  ErrorTitle:[NSString stringWithFormat:@"处理新消息耗时：%ld分钟|(%ld毫秒)",labs(intervalSeconds)/60000, labs(intervalSeconds)]
                  ErrorClass:@""
                 ErrorMethod:@""
                   ErrorData:[NSString stringWithFormat:@"%@",dataDic]
                   ErrorDate:[AppDateUtil GetCurrentDateForString]
                   ErrorType:2];
        
        BOOL isContinue = NO;
        if(parseResult){
            _parseMsgFailCount = 0;
            isContinue = YES;
        } else {
            if (_parseMsgFailCount<5) {
                _parseMsgFailCount += 1;
                isContinue = NO;
                [self getMessage:poolTag];
            } else {
                //超过五次解析失败
                DDLogVerbose(@"parseMsgSerical:超过五次解析失败。[消息解析失败]");
                
                isContinue = YES;
            }
        }
        
        if(isContinue){
            _parseMsgFailCount = 0;
            
            //同步Synk
            self.syncKey = [datacontext objectForKey:@"synckey"];
            //最后的 synckeys
            NSMutableDictionary *syncDic = [LZUserDataManager readSynkInfo];
            
            NSMutableDictionary *syncDicCopy = [[NSMutableDictionary alloc] init];
            for (NSString *key in [syncDic allKeys]) {
                [syncDicCopy setObject:[syncDic objectForKey:key] forKey:key];
            }
            
            [syncDicCopy setObject:[self.syncKey copy] forKey:[AppUtils GetCurrentUserID]];
            [LZUserDataManager saveSynkInfo:syncDicCopy];
            
            if( [json objectForKey:@"DataContext"] != [NSNull null]
               && [[datacontext objectForKey:@"continueflag"] integerValue] == 1)
            {
                [self getErrorInfoid:[LZUtils CreateGUID]
                            ErrorUid:[AppUtils GetCurrentUserID]
                          ErrorTitle:[NSString stringWithFormat:@"继续请求数据"]
                          ErrorClass:@""
                         ErrorMethod:@""
                           ErrorData:[NSString stringWithFormat:@"%@\n\n%@",json,urlString]
                           ErrorDate:[AppDateUtil GetCurrentDateForString]
                           ErrorType:2];
                
                [self getMessage:poolTag];
            }
            else
            {
                [self longPolling:poolTag];
            }
        }
    }];
    
    
}

#pragma mark - 非队列模式请求数据

/**
 *  调用WebApi(不需要队列模式)
 *
 *  @param sendDataDic 包含：webapicontroller，routepath，data，moduleserver
 */
-(void)sendToServer:(NSMutableDictionary *)sendDataDic
{
    if(self.iscancel == YES){
        if ( _sendFailureHandler) {
            NSString *showErrorType = [[sendDataDic lzNSDictonaryForKey:WebApi_DataSend_Other] lzNSStringForKey:WebApi_DataSend_Other_ShowError];
            
            if(![showErrorType isEqualToString:WebApi_DataSend_Other_SE_NotShowAll]){
                dispatch_async(dispatch_get_main_queue(), ^{
//                    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
//                    [dataDic setObject:@{@"Code":@"0",@"Message":LZGDCommonLocailzableString(@"common_network_link_fail")} forKey:WebApi_ErrorCode];
                    
                    [sendDataDic setObject:@{@"Code":@"0",@"Message":LZGDCommonLocailzableString(@"common_network_link_fail")} forKey:WebApi_ErrorCode];
                    /* WebApi所在Controller */
                    NSString *webApiController = [sendDataDic objectForKey:@"webapicontroller"];
                    /* WebApi的路由 */
                    NSString *routePath = [sendDataDic objectForKey:@"routepath"];
                    /* Post提交的数据 */
                    id postData = [sendDataDic objectForKey:@"postdata"];
                    NSMutableDictionary *getData = [sendDataDic lzNSMutableDictionaryForKey:@"getdata"];
                    /* 其它数据 */
                    NSDictionary *otherData = [sendDataDic objectForKey:@"otherdata"];
                    if(postData!=nil){
                        [sendDataDic setObject:postData forKey:WebApi_DataSend_Post];
                    }
                    if(getData!=nil){
                        [sendDataDic setObject:getData forKey:WebApi_DataSend_Get];
                    }
                    if(otherData!=nil){
                        [sendDataDic setObject:otherData forKey:WebApi_DataSend_Other];
                    }
                    [sendDataDic setObject:webApiController forKey:WebApi_Controller];
                    [sendDataDic setObject:routePath forKey:WebApi_Route];
                    
                    _sendFailureHandler(1,sendDataDic);
                });
            }
        }
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        /* WebApi所在Controller */
        NSString *webApiController = [sendDataDic objectForKey:@"webapicontroller"];
        /* WebApi的路由 */
        NSString *routePath = [sendDataDic objectForKey:@"routepath"];
        
        /* 是否为Post请求 */
        BOOL isPost = NO;
        if([[sendDataDic allKeys] containsObject:@"httpmethod"]
           && [[[sendDataDic objectForKey:@"httpmethod"] lowercaseString] isEqualToString:@"post"]){
            isPost = YES;
        }
        
        /* GET提交的数据 */
        NSMutableDictionary *getData = [sendDataDic lzNSMutableDictionaryForKey:@"getdata"];
        if(!getData){
            getData = [[NSMutableDictionary alloc] init];
        }
        [getData setObject:self.tokenId forKey:@"tokenid"];
        
        /* Post提交的数据 */
        id postData = [sendDataDic objectForKey:@"postdata"];
        
        /* 其它数据 */
        NSDictionary *otherData = [sendDataDic objectForKey:@"otherdata"];
        
        /* 服务器 */
        NSString *moduleServer = [sendDataDic objectForKey:@"moduleserver"];
        
        /* 出错次数 */
        __block int failCount = 0;
        if([[sendDataDic allKeys] containsObject:@"falicount"]){
            NSNumber *numberFailCount = (NSNumber *)[sendDataDic objectForKey:@"falicount"];
            failCount = numberFailCount.intValue;
        }
            
        NSString *server = @"";
        if([moduleServer hasPrefix:@"http://"] || [moduleServer hasPrefix:@"https://"] ){
            server = moduleServer;
        }
        else{
            server = [ModuleServerUtil GetServerWithModule:moduleServer];
        }

        
        NSString *urlString =[NSString stringWithFormat:@"%@/%@",
                              server,
                              routePath
                              ];
        for (NSString *key in [getData allKeys]) {
            NSString *value = [getData objectForKey:key];
            NSString *replaceKey = [NSString stringWithFormat:@"{%@}",key];
            urlString = [urlString stringByReplacingOccurrencesOfString:replaceKey withString:value];
        }

        DDLogVerbose(@"lzconnection sendToServerForGet:%@",urlString);
        
        /* 组织block中的数据 */
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
        [dataDic setObject:webApiController forKey:WebApi_Controller];
        [dataDic setObject:routePath forKey:WebApi_Route];
        if(postData!=nil){
            [dataDic setObject:postData forKey:WebApi_DataSend_Post];
        }
        if(getData!=nil){
            [dataDic setObject:getData forKey:WebApi_DataSend_Get];
        }
        if(otherData!=nil){
            [dataDic setObject:otherData forKey:WebApi_DataSend_Other];
        }
        
       
        
        XHJSONSuccessHandler successBlock = ^(LZURLConnection * connection, id json){
            /* 退出登录 */
            if([webApiController isEqualToString:@"logout"]){
                DDLogVerbose(@"logout -- lzconnection sendToServer success %@ return value:%@",routePath,json);
            }
            
            /* 是否被cancle掉 */
            if(connection.iscancel == YES) return;
            
            DDLogVerbose(@"lzconnection sendToServer success return value:%@",json);
            NSString *code = [[json objectForKey:@"ErrorCode"] objectForKey:@"Code"];
            
            id datacontext = [json objectForKey:@"DataContext"];
            /* 空值处理 */
            if(datacontext == [NSNull null] || datacontext == nil){
                datacontext = @"";
            }
            [dataDic setObject:datacontext forKey:WebApi_DataContext];
            [dataDic setValue:[json objectForKey:@"ErrorCode"] forKey:WebApi_ErrorCode];
            
            if(_sendSuccessHandler){
                dispatch_async(dispatch_get_main_queue(), ^{
                    _sendSuccessHandler(dataDic);
                });
            }
            
            //返回正确
            if([code isEqualToString:@"0"])
            {
            }
            else
            {
                DDLogError(@"lzconnection sendToServer error code return value:%@",json);
                
                /* 处理错误数据，保存到model中 */
                NSString *postdatas=[NSString string];
                //字典转字符串
                postdatas=[postdatas dictionaryToJson:[dataDic objectForKey:WebApi_DataSend_Post]];
                
                NSString *errordata=[NSString stringWithFormat:@"post:\n%@\nresult:\n%@",postdatas,[self JSONUnicode2Utf8:json]];
                [self getErrorInfoid:[LZUtils CreateGUID]
                          ErrorUid:[AppUtils GetCurrentUserID]
                          ErrorTitle:@"send2Server请求失败（ErrorCode非零）"
                          ErrorClass:@""
                          ErrorMethod:urlString
                          ErrorData:errordata
                          ErrorDate:[AppDateUtil GetCurrentDateForString]
                          ErrorType:1];
            }
            
        };
        
        XHHTTPFailureHandler failureBlock = ^(LZURLConnection * connection, NSData *responseData, NSURLResponse *response, NSError *error){
            
            
            /* 是否被cancle掉 */
            if(connection.iscancel == YES) return;
            NSString *dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            
            //DDLogError(@"lzconnection sendToServerForGet error responseData sendToServer:%@, error:%@",dataString,error);
            DDLogError(@"lzconnection sendToServer error code return value,responseData:%@;error:%@",dataString,error);
            
            failCount++;
            if (failCount>=DEFAULT_SENDTOSERVER_REDOCOUNT) {
                if ( _sendFailureHandler) {
                    dataString = [NSString isNullOrEmpty:dataString] ? @"" : dataString;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [dataDic setObject:@{@"Code":@"0",@"Message":dataString} forKey:WebApi_ErrorCode];
                        _sendFailureHandler(1,dataDic);
                    });
                }
            }
            else
            {
                [sendDataDic setObject:[NSNumber numberWithInt:failCount] forKey:@"falicount"];
                [self performSelector:@selector(sendToServer:)
                           withObject:sendDataDic
                           afterDelay:DEFAULT_AFTERDELAY];
            }
            
            /* 处理错误数据，保存到model中 */
            NSString *postdatas=[NSString string];
            postdatas=[postdatas dictionaryToJson:[dataDic objectForKey:WebApi_DataSend_Post]];
            
            
            
            NSString *errordata=[NSString stringWithFormat:
                                 @"post:\n%@\nstatuscode:%ld\nerror:\n%@",
                                 postdatas,
                                 (long)((NSHTTPURLResponse*)response).statusCode,
                                 error];
            
            [self getErrorInfoid:[LZUtils CreateGUID]
                      ErrorUid:[AppUtils GetCurrentUserID]
                      ErrorTitle:[NSString stringWithFormat:@"send2Server请求失败(%ld)",(long)((NSHTTPURLResponse*)response).statusCode]
                      ErrorClass:@""
                      ErrorMethod:urlString
                      ErrorData:errordata
                      ErrorDate:[AppDateUtil GetCurrentDateForString]
                      ErrorType:1];
            
        };

        if(!isPost){
            conn_send = [XHHTTPClient  GETPath: urlString
                             jsonSuccessHandler:successBlock
                             failureHandler:failureBlock
                         ];
        } else {
            conn_send = [XHHTTPClient  POSTPath: urlString
                                      parameters:postData
                             jsonSuccessHandler:successBlock
                                 failureHandler:failureBlock
                         ];
        }
            
    });
}

#pragma mark - 队列模式请求数据

-(void)removeAllWebApi{
    if(_queueWeApiArray){
        [_queueWeApiArray removeAllObjects];
    }
}

/**
 *  调用WebApi(采用队列模式)
 *
 *  @param sendDataDic 包含：webapicontroller，routepath，data，moduleserver
 */
-(void)sendToServerQueue:(NSMutableDictionary *)sendDataDic
{
    if(self.iscancel == YES){
        if ( _sendFailureHandler) {
            NSString *showErrorType = [[sendDataDic lzNSDictonaryForKey:WebApi_DataSend_Other] lzNSStringForKey:WebApi_DataSend_Other_ShowError];

            if(![showErrorType isEqualToString:WebApi_DataSend_Other_SE_NotShowAll]){
                dispatch_async(dispatch_get_main_queue(), ^{
//                    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
//                    [dataDic setObject:@{@"Code":@"0",@"Message":LZGDCommonLocailzableString(@"common_network_link_fail")} forKey:WebApi_ErrorCode];
                    
                    [sendDataDic setObject:@{@"Code":@"0",@"Message":LZGDCommonLocailzableString(@"common_network_link_fail")} forKey:WebApi_ErrorCode];
                    /* WebApi所在Controller */
                    NSString *webApiController = [sendDataDic objectForKey:@"webapicontroller"];
                    /* WebApi的路由 */
                    NSString *routePath = [sendDataDic objectForKey:@"routepath"];
                    /* Post提交的数据 */
                    id postData = [sendDataDic objectForKey:@"postdata"];
                    NSMutableDictionary *getData = [sendDataDic lzNSMutableDictionaryForKey:@"getdata"];
                    /* 其它数据 */
                    NSDictionary *otherData = [sendDataDic objectForKey:@"otherdata"];
                    if(postData!=nil){
                        [sendDataDic setObject:postData forKey:WebApi_DataSend_Post];
                    }
                    if(getData!=nil){
                        [sendDataDic setObject:getData forKey:WebApi_DataSend_Get];
                    }
                    if(otherData!=nil){
                        [sendDataDic setObject:otherData forKey:WebApi_DataSend_Other];
                    }
                    [sendDataDic setObject:webApiController forKey:WebApi_Controller];
                    [sendDataDic setObject:routePath forKey:WebApi_Route];
                    
                    _sendFailureHandler(1,sendDataDic);
                });
            }
        }
        return;
    }
    
    if(!_queueWeApiArray){
        _queueWeApiArray = [[NSMutableArray alloc] init];
    }
    /* 添加到队列中 */
    [_queueWeApiArray addObject:sendDataDic];
    
    /* 若队列中的WebApi未正在请求，则需要开始请求 */
    if(!_queueIsGettingData){
         _queueIsGettingData = YES;
        /* 开始上传 */
        [self sendToServerQueueBegin];
    }
}

-(void)sendToServerQueueBegin{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSMutableDictionary *sendDataDic = nil;
        
        /* 获取需要请求的WebApi信息 */
        if(_queueWeApiArray.count>0){
            sendDataDic = [_queueWeApiArray objectAtIndex:0];
            
            if(sendDataDic==nil){
                [_queueWeApiArray removeObjectAtIndex:0];
                
                self.queueGettingFailCount = 0;
                [self sendToServerQueueBegin];
                return;
            }
        } else {
            _queueIsGettingData = NO;
            return;
        }

        /* WebApi所在Controller */
        NSString *webApiController = [sendDataDic objectForKey:@"webapicontroller"];
        /* WebApi的路由 */
        NSString *routePath = [sendDataDic objectForKey:@"routepath"];
        
        /* 是否为Post请求 */
        BOOL isPost = NO;
        if([[sendDataDic allKeys] containsObject:@"httpmethod"]
           && [[[sendDataDic objectForKey:@"httpmethod"] lowercaseString] isEqualToString:@"post"]){
            isPost = YES;
        }
        
        /* GET提交的数据 */
        NSMutableDictionary *getData = [sendDataDic lzNSMutableDictionaryForKey:@"getdata"];
        if(!getData){
            getData = [[NSMutableDictionary alloc] init];
        }
        /* 在主线程中发送通知 */
        if([NSString isNullOrEmpty:self.tokenId]){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *errorDic = [[NSMutableDictionary alloc] init];
                [errorDic setObject:@{@"Code":@"0",@"Message":@"tokenid为空，请重新登录"} forKey:WebApi_ErrorCode];
                _sendFailureHandler(1,errorDic);
            });
            [_queueWeApiArray removeAllObjects];
            return;
        }
        [getData setObject:self.tokenId forKey:@"tokenid"];
        
        /* Post提交的数据 */
        id postData = [sendDataDic objectForKey:@"postdata"];
        /* 其它数据 */
        NSDictionary *otherData = [sendDataDic objectForKey:@"otherdata"];
        /* 服务器 */
        NSString *moduleServer = [sendDataDic objectForKey:@"moduleserver"];
        
        NSString *server = @"";
        if([moduleServer hasPrefix:@"http://"] || [moduleServer hasPrefix:@"https://"] ){
            server = moduleServer;
        }
        else{
            server = [ModuleServerUtil GetServerWithModule:moduleServer];
        }
        
        
        NSString *urlString =[NSString stringWithFormat:@"%@/%@",
                              server,
                              routePath
                              ];
        for (NSString *key in [getData allKeys]) {
            NSString *value = [getData objectForKey:key];
            NSString *replaceKey = [NSString stringWithFormat:@"{%@}",key];
            urlString = [urlString stringByReplacingOccurrencesOfString:replaceKey withString:value];
        }
        
        DDLogVerbose(@"lzconnection sendToServerQueueBegin:%@",urlString);
        /* 组织block中的数据 */
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
        [dataDic setObject:webApiController forKey:WebApi_Controller];
        [dataDic setObject:routePath forKey:WebApi_Route];
        if(postData!=nil){
            [dataDic setObject:postData forKey:WebApi_DataSend_Post];
        }
        if(getData!=nil){
            [dataDic setObject:getData forKey:WebApi_DataSend_Get];
        }
        if(otherData!=nil){
            [dataDic setObject:otherData forKey:WebApi_DataSend_Other];
        }
        
        XHJSONSuccessHandler successBlock = ^(LZURLConnection * connection, id json){
            /* 是否被cancle掉 */
            if(connection.iscancel == YES) return;
            
            DDLogVerbose(@"lzconnection sendToServerQueueBegin success return value:%@",json);
            
            NSString *code = [[json objectForKey:@"ErrorCode"] objectForKey:@"Code"];
            
            id datacontext = [json objectForKey:@"DataContext"];
            /* 空值处理 */
            if(datacontext == [NSNull null] || datacontext == nil){
                datacontext = @"";
            }
            [dataDic setObject:datacontext forKey:WebApi_DataContext];
            [dataDic setObject:[json objectForKey:@"ErrorCode"] forKey:WebApi_ErrorCode];
            
            if(_sendSuccessHandler){
                dispatch_async(dispatch_get_main_queue(), ^{
                    _sendSuccessHandler(dataDic);
                });
            }
            
            //返回正确
            if([code isEqualToString:@"0"])
            {
            }
            else
            {
                DDLogError(@"lzconnection sendToServerQueueBegin error code return value:%@",json);
                
                /* 请求失败，下次登录时仍需请求 */
                if([routePath isEqualToString:WebApi_Recent_GetRecentData]){
                    [LZUserDataManager saveLastestLoginDate:@""];
                }
                
                /* 处理错误数据，保存到model中 */
                NSString *postdatas=[NSString string];
                //字典转字符串
                postdatas=[postdatas dictionaryToJson:[dataDic objectForKey:WebApi_DataSend_Post]];
           
                NSString *errordata=[NSString stringWithFormat:@"post:\n%@\nresult:\n%@",
                                     postdatas,
                                     [self JSONUnicode2Utf8:json]
                                     ];
                [self getErrorInfoid:[LZUtils CreateGUID]
                          ErrorUid:[AppUtils GetCurrentUserID]
                          ErrorTitle:@"send2Server请求失败-Queue（ErrorCode非零）"
                          ErrorClass:@""
                          ErrorMethod:urlString
                          ErrorData:errordata
                          ErrorDate:[AppDateUtil GetCurrentDateForString]
                          ErrorType:1];
            }
            
            if(_queueWeApiArray.count>0){
                /* 开始下一次的请求 */
                [_queueWeApiArray removeObjectAtIndex:0];
            }
            self.queueGettingFailCount = 0;
            [self sendToServerQueueBegin];
        };
        
        XHHTTPFailureHandler failureBlock = ^(LZURLConnection * connection, NSData *responseData, NSURLResponse *response, NSError *error){
            /* 是否被cancle掉 */
            if(connection.iscancel == YES) return;
            
            NSString *dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            //DDLogError(@"lzconnection sendToServerForGet error responseData sendToServerQueue:%@, error:%@",dataString,error);
            DDLogError(@"lzconnection sendToServerForGet error code return value,responseData:%@;error:%@",dataString,error);
            
            self.queueGettingFailCount++;
            if (self.queueGettingFailCount>=DEFAULT_SENDTOSERVER_REDOCOUNT) {
                
                /* 请求失败，下次登录时仍需请求 */
                if([routePath isEqualToString:WebApi_Recent_GetRecentData]){
                    [LZUserDataManager saveLastestLoginDate:@""];
                }
                
                if ( _sendFailureHandler) {
                    dataString = [NSString isNullOrEmpty:dataString] ? @"" : dataString;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [dataDic setObject:@{@"Code":@"0",@"Message":dataString} forKey:WebApi_ErrorCode];
                        _sendFailureHandler(1,dataDic);
                    });
                }
                
                if(_queueWeApiArray.count>0){
                    /* 开始下一次的请求 */
                    [_queueWeApiArray removeObjectAtIndex:0];
                }
                self.queueGettingFailCount = 0;
                [self sendToServerQueueBegin];
            }
            else
            {
                [self performSelector:@selector(sendToServerQueueBegin)
                           withObject:nil
                           afterDelay:DEFAULT_AFTERDELAY];
                
            }

            
            /* 处理错误数据，保存到model中 */
            NSString *postdatas=[NSString string];
            postdatas=[postdatas dictionaryToJson:[dataDic objectForKey:WebApi_DataSend_Post]];
        
            
            NSString *errordata=[NSString stringWithFormat:
                                 @"post:\n%@\nstatuscode:%ld\nerror:\n%@",
                                 postdatas,
                                 (long)((NSHTTPURLResponse*)response).statusCode,
                                 error];
            
            [self getErrorInfoid:[LZUtils CreateGUID]
                      ErrorUid:[AppUtils GetCurrentUserID]
                      ErrorTitle:[NSString stringWithFormat:@"send2Server请求失败-Queue(%ld)",(long)((NSHTTPURLResponse*)response).statusCode]
                      ErrorClass:@""
                      ErrorMethod:urlString
                      ErrorData:errordata
                      ErrorDate:[AppDateUtil GetCurrentDateForString]
                      ErrorType:1];
        };

        if(!isPost){
            conn_send = [XHHTTPClient  GETPath: urlString
                            jsonSuccessHandler:successBlock
                                failureHandler:failureBlock
                         ];
        } else {
            conn_send = [XHHTTPClient  POSTPath: urlString
                                     parameters:postData
                             jsonSuccessHandler:successBlock
                                 failureHandler:failureBlock
                         ];
        }
    });
    
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

- (NSString*)JSONUnicode2Utf8:(NSDictionary *) unicodeJSONDic{
    if(unicodeJSONDic)
    {
        NSString * desc = [NSString stringWithCString:[[NSString stringWithFormat:@"%@",unicodeJSONDic] cStringUsingEncoding:NSUTF8StringEncoding]
                                             encoding:NSNonLossyASCIIStringEncoding];
        return desc;
    }
    else
        return @"";
}

@end
