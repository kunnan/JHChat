//
//  PingUtils.h
//  LeadingCloud
//
//  Created by dfl on 17/5/3.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/ip_icmp.h>
#include <netdb.h>
#include <setjmp.h>
#include <errno.h>
#include <sys/time.h>
#import <netinet/udp.h>

@interface PingUtils : NSObject

//获取局域网本机IP
+ (NSString *)getLANIIPAdress;

//获取外网IP
+ (NSString *)getWANIIPAdress;

//检查IP能否PING成功
+ (BOOL)getAllReturnIpStr:(NSString *)dstaddrStr;
@end
