//
//  XHHTTPClient.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-30.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHHTTPClient.h"


@interface NSString (URLEncoding)

- (NSString *)urlEncodedUTF8String;

@end

//@interface NSURLRequest (DictionaryPost)
//
//+ (NSURLRequest *)postRequestWithURL:(NSURL *)url
//                          parameters:(NSDictionary *)parameters;
//
//@end

@implementation NSString (URLEncoding)

- (NSString *)urlEncodedUTF8String {
    return (id)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(0, (CFStringRef)self, 0,
                                                                         (CFStringRef)@";/?:@&=$+{}<>,|", kCFStringEncodingUTF8));
}

@end

@implementation XHHTTPClient

/*
 GET JOSN
 */
+ (LZURLConnection *)GETPath:(NSString *)urlString
          jsonSuccessHandler:(XHJSONSuccessHandler)jsonSuccessHandler
              failureHandler:(XHHTTPFailureHandler)failureHandler {
    
    if([urlString rangeOfString:@"api/connection/check"].location == NSNotFound){
        /* 显示网络活动标识 */
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });
    }
    
    XHOperationNetworkKit *operation = [[XHOperationNetworkKit alloc]
                                        initWithRequest:[self requestWithURLString:urlString
                                                                        HTTPMethod:@"GET"
                                                                        parameters:nil]
                                        jsonSuccessHandler:jsonSuccessHandler
                                        failureHandler:failureHandler];
    return [operation startRequest];
}
/*
 POST JOSN
 */
+ (LZURLConnection *)POSTPath:(NSString *)urlString
                   parameters:(id)parameters
           jsonSuccessHandler:(XHJSONSuccessHandler)jsonSuccessHandler
               failureHandler:(XHHTTPFailureHandler)failureHandler {
    
    if([urlString rangeOfString:@"api/connection/check"].location == NSNotFound){
        /* 显示网络活动标识 */
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });
    }
    
    XHOperationNetworkKit *operation = [[XHOperationNetworkKit alloc]
                                        initWithRequest:[self requestWithURLString:urlString
                                                                        HTTPMethod:@"POST"
                                                                        parameters:parameters]
                                        jsonSuccessHandler:jsonSuccessHandler
                                        failureHandler:failureHandler];
  return   [operation startRequest];
}



/*
 设置请求参数
 */
+ (NSMutableURLRequest *)requestWithURLString:(NSString *)urlString HTTPMethod:(NSString *)method parameters:(id)parameters {
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    if(url == nil){
        url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:method];
    [request setTimeoutInterval:XHHTTPClientTimeoutInterval];
    
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"]; //设置预期接收数据的格式
    
    
    
    if (parameters !=nil) {
        
        if ([NSJSONSerialization isValidJSONObject:parameters])
        {
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"]; //设置发送数据的格式
            
            
            NSData *postDatas = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
            [request setHTTPBody:postDatas];
            
            NSString *str = [[NSString alloc] initWithData:postDatas encoding:NSUTF8StringEncoding];
            
            NSLog(@"requestWithURLString parameters JSON:%@",str);
            //[request setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
            
            //return request;
        }
        
        //键值对
        else if([parameters isKindOfClass:[NSDictionary class]])
        {
            NSMutableString *body = [NSMutableString string];
            
            NSDictionary *dictionary = (NSDictionary *)parameters;
            for (NSString *key in dictionary) {
                NSString *val = [dictionary objectForKey:key];
                if ([body length])
                    [body appendString:@"&"];
                [body appendFormat:@"%@=%@", [[key description] urlEncodedUTF8String],
                 [[val description] urlEncodedUTF8String]];
            }
            [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
        //数组
        else if([parameters isKindOfClass:[NSArray class]])
        {
            NSMutableString *body = [NSMutableString string];
            
            NSArray *array = (NSArray *)parameters;
            long count = array.count;
            for(long i=0; i<count; i++){
                NSString *val = [array objectAtIndex:i];
                if ([body length])
                    [body appendString:@"&"];
                [body appendFormat:@"%li=%@", i, [[val description] urlEncodedUTF8String]];
            }
            
            [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
        //字符串
        else if([parameters isKindOfClass:[NSString class]])
        {
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
            NSString *baseStr = (NSString *)parameters;
//            NSString *baseString = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                                                                 (CFStringRef)baseStr,
//                                                                                                 NULL,
//                                                                                                 CFSTR(":/?#[]@!$&’()*+,;="),
//                                                                                                 kCFStringEncodingUTF8);
            
            CFStringRef baseStringRef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                (CFStringRef)baseStr,
                                                                                NULL,
                                                                                CFSTR(":/?#[]@!$&’()*+,;="),
                                                                                kCFStringEncodingUTF8);
            NSString *baseString = (__bridge NSString *) baseStringRef;
            /* 单独post字符串时，前面需要加上= */
            NSString *postString = [NSString stringWithFormat:@"=%@",baseString];
            CFRelease(baseStringRef);
            [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    
    return request;
}

@end
