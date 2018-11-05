//
//  RemotelyServerWebApi.h
//  LeadingCloud
//
//  Created by SY on 2017/6/22.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#ifndef RemotelyServerWebApi_h
#define RemotelyServerWebApi_h


#endif /* RemotelyServerWebApi_h */

static NSString * const WebApi_RemotelyServer = @"api/remotelyserver";
/* 获取远程文件服务器model */
static NSString * const WebApi_GetRemotelyServerModelAll = @"api/filemanager/getremotelyservermodelall/{tokenid}";
/* 获取远程文件服务器账号model */
static NSString * const WebApi_GetRemotelyAccountModel = @"api/filemanager/getremotelyaccountmodel/{rfsid}/{tokenid}";
/* 创建文件id(一次10个) */
static NSString * const WebApi_CreateFileid = @"api/filemanager/createfileid/{tokenid}";
