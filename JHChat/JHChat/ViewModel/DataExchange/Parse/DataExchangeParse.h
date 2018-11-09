//
//  DataExchangeParse.h
//  LeadingCloud
//
//  Created by wchMac on 16/5/27.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "LZBaseParse.h"

@interface DataExchangeParse : LZBaseParse<EventSyncPublisher>

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(DataExchangeParse *)shareInstance;

/**
 *  解析数据
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parse:(NSMutableDictionary *)dataDic;

/*
 同步解析长连接返回的消息数据
 */
-(void)parseGetMessgae:(NSMutableDictionary *)dataDic parseResult:(LZParseMsgResult)parseResult;

@end
