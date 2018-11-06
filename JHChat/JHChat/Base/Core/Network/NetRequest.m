//
//  NetRequest.m
//  LeadingCloud
//
//  Created by gjh on 2017/11/30.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "NetRequest.h"
#import "AFNetworking.h"

@implementation NetRequest

+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id))sucess failure:(void (^)(NSError *))failure{
    //实例化网络请求管理类
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    //配置请求超时时间
    manger.requestSerializer.timeoutInterval = 8;
    //配置MIME类型
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    [manger GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        sucess(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id))sucess failure:(void (^)(NSError *))failure{
    //实例化网络请求管理类
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    //配置请求超时时间
    manger.requestSerializer.timeoutInterval = 8;
    //配置MIME类型
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    [manger POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //执行成功
        sucess(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //执行失败
        failure(error);
    }];
}

@end
