//
//  CooperationPedningParse.m
//  LeadingCloud
//
//  Created by wang on 16/10/18.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CooperationPedningParse.h"
#import "CooperationpendingModel.h"
#import "CoTransactionPostInfoModel.h"
#import "CoTransactionPostInfoDAL.h"
#import "CoTransactionTypeDAL.h"
#import "TodolistModel.h"

@implementation CooperationPedningParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CooperationPedningParse *)shareInstance{
    
    static CooperationPedningParse *instance = nil;
    if (instance == nil) {
        instance = [[CooperationPedningParse alloc] init];
    }
    return instance;

}

/**
 *  解析数据
 *
 *  @param dataDic
 */
-(void)parse:(NSMutableDictionary *)dataDic{
    
    
    
    NSString *route = [dataDic objectForKey:WebApi_Route];
    
    
    //待处理列表（分页）
    if ([route isEqualToString:WebApi_CloudCooperationPendingList]){
        
        [self parsePendingList:dataDic];
    }
    
    //岗位列表
    else if ([route isEqualToString:WebApi_CloudCooperationPendingPostinfoList]){
        
        [self parsePendingPostInfoList:dataDic];
    }
	//新的提醒列表
	else if ([route isEqualToString:WebApi_CloudCooperationPendingNewList]){
		[self parsePendingNewList:dataDic];

	}
	else if ([route isEqualToString:WebApi_CloudCooperationPendingNewCount]){
		[self paresPendingNewCount:dataDic];

	}
    
    //得到筛选列表
    else if ([route isEqualToString:WebApi_CloudCooperationPendingTypeList]){
        
        [self parsePendingFilterList:dataDic];
    }
    
    //得到处理类型模型
    else if ([route isEqualToString:WebApi_CloudCooperationPendingModelType]){
        
        [self parsePendingTypeModelList:dataDic];
    }
    
    //得到处理数量
    else if ([route isEqualToString:WebApi_CloudCooperationPendingStatusCount]){
        
        [self paresPendingStatusCount:dataDic];
    }
    //单条事务模型
    else if ([route isEqualToString:WebApi_CloudCooperationPendingModelItem]){
        
        [self paresPendingModelItem:dataDic];

    }
    
    //单条事务类型
    else if ([route isEqualToString:WebApi_CloudCooperationPendingGetModelByType]){
        
        [self paresPendingGetModelByTsidType:dataDic];

    }

}


-(void)parsePendingList:(NSMutableDictionary *)dataDic{
    
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    
    NSArray *dataArr = [contextDic lzNSMutableArrayForKey:@"models"];
    
    NSDictionary *postDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    
    NSDictionary *param =[postDic lzNSDictonaryForKey:@"parameters"];
    
    NSString *status = [param lzNSStringForKey:@"status"];
    
    
    NSString *startindex = [postDic lzNSStringForKey:@"startindex"];

    NSString *searchcontext = [postDic lzNSStringForKey:@"searchcontext"];

    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *subDic  in dataArr) {
        
        CoTransactionModel *cModel = [[CoTransactionModel alloc]init];
        [cModel serializationWithDictionary:subDic];
        cModel.appName = [[subDic lzNSDictonaryForKey:@"appdata"]objectForKey:@"name"];
        cModel.appcolor = [[subDic lzNSDictonaryForKey:@"appdata"]objectForKey:@"appcolor"];
        cModel.appid = [[subDic lzNSDictonaryForKey:@"appdata"]objectForKey:@"appid"];
        cModel.appcode = [[subDic lzNSDictonaryForKey:@"appdata"]objectForKey:@"appcode"];

        cModel.bid = [[subDic lzNSDictonaryForKey:@"bdata"]objectForKey:@"bid"];
        cModel.bname = [[subDic lzNSDictonaryForKey:@"bdata"]objectForKey:@"name"];
        cModel.descript = [subDic lzNSStringForKey:@"description"];
        cModel.tiid = [NSString stringWithFormat:@"%@%@",cModel.ttid,cModel.businessid];
        [arr addObject:cModel];
    }
    NSString *count = [NSString stringWithFormat:@"%ld",arr.count];
    arr =  [[CooperationpendingModel shareInstance]getShowPendingItemArr:arr];
    
    NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:arr,@"data",status,@"status",startindex,@"startindex",count,@"count",searchcontext,@"search",[contextDic objectForKey:@"count"],@"total", nil];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationPedningParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Transaction_List, sendDic);
    });
    
}


-(void)parsePendingPostInfoList:(NSMutableDictionary *)dataDic{
    
    
    NSArray *dataArr = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *subDic  in dataArr) {
        
        CoTransactionPostInfoModel *cModel = [[CoTransactionPostInfoModel alloc]init];
        cModel.name = [subDic lzNSStringForKey:@"name"];
        cModel.postid = [subDic lzNSStringForKey:@"value"];
        [arr addObject:cModel];
    }
    
    NSDictionary *getDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
    NSString *eid = [getDic lzNSStringForKey:@"eid"];
    
    [[CoTransactionPostInfoDAL shareInstance]addDataWithArray:arr Orgid:eid];
    
    NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:arr,@"data",eid,@"oid", nil];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationPedningParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Transaction_PostInfo_List, sendDic);
    });

    
}

- (void)parsePendingNewList:(NSMutableDictionary *)dataDic{
	
	NSArray *dataArr = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
	NSMutableArray *arr = [NSMutableArray array];
	for (NSDictionary *dic in dataArr) {
		
		TodolistModel *tModel = [[TodolistModel alloc]init];
		[tModel serializationWithDictionary:dic];
		[arr addObject:tModel];
	}
	NSDictionary *getDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
	NSString *orgid = [getDic lzNSStringForKey:@"orgid"];
	
	
	NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:arr,@"data",orgid,@"orgid", nil];
	/* 在主线程中发送通知 */
	dispatch_async(dispatch_get_main_queue(), ^{
		__block CooperationPedningParse * service = self;
		EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Transaction_NewTodo_List, sendDic);
	});
}

-(void)parsePendingFilterList:(NSMutableDictionary *)dataDic{
    
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    
    NSArray *appdate = [contextDic lzNSArrayForKey:@"appdata"];
    NSMutableArray *appArr = [NSMutableArray array];
    for (NSDictionary *subDic  in appdate) {
        
        CoTransactionPostInfoModel *cModel = [[CoTransactionPostInfoModel alloc]init];
        cModel.name = [subDic lzNSStringForKey:@"value"];
        cModel.postid = [subDic lzNSStringForKey:@"key"];
        [appArr addObject:cModel];
    }
    NSArray *bdate = [contextDic lzNSArrayForKey:@"bdata"];
    NSMutableArray *bArr = [NSMutableArray array];
    for (NSDictionary *subDic  in bdate) {
        
        CoTransactionPostInfoModel *cModel = [[CoTransactionPostInfoModel alloc]init];
        cModel.name = [subDic lzNSStringForKey:@"value"];
        cModel.postid = [subDic lzNSStringForKey:@"key"];
        [bArr addObject:cModel];
    }
    
    NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:appArr,@"app",bArr,@"dep", nil];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationPedningParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Transaction_Filter_List, sendDic);
    });
    

}

- (void)parsePendingTypeModelList:(NSDictionary*)dataDic{
    
    NSArray *contextArr = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSDictionary *subDic in contextArr) {
        
        CoTransactionTypeModel *typeModel = [[CoTransactionTypeModel alloc]init];
        
        [typeModel serializationWithDictionary:subDic];
        typeModel.descript = [subDic lzNSStringForKey:@"description"];
        [dataArr addObject:typeModel];
    }
    [[CoTransactionTypeDAL shareInstance]deleteAllModel];
    [[CoTransactionTypeDAL shareInstance]addDataWithArray:dataArr];
}


- (void)paresPendingStatusCount:(NSDictionary*)dataDic{
    
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    
    NSString *handlecount = [contextDic objectForKey:@"handlecount"]; //处理中的数量
    NSString *notstartedcount = [contextDic objectForKey:@"notstartedcount"]; //未开始数量
    
    NSDictionary *postDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    
    NSDictionary *param =[postDic lzNSDictonaryForKey:@"parameters"];
    
    NSString *fromvalue = [param objectForKey:@"fromvalue"];
    
    NSDictionary *gettDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
    NSString *status = [gettDic lzNSStringForKey:@"status"];
    
    NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:handlecount,@"handlecount",notstartedcount,@"notstartedcount",fromvalue,@"fromvalue",status,@"status" ,nil];

    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationPedningParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Transaction_Status_Count, sendDic);
    });

}

- (void)paresPendingNewCount:(NSDictionary*)dataDic{

	NSNumber *contextDic = [dataDic lzNSNumberForKey:WebApi_DataContext];
	
	
	NSDictionary *getDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
	NSString *orgid = [getDic lzNSStringForKey:@"orgid"];
	
	
	NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:contextDic,@"data",orgid,@"orgid", nil];
	/* 在主线程中发送通知 */
	dispatch_async(dispatch_get_main_queue(), ^{
		__block CooperationPedningParse * service = self;
		EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Transaction_New_Tolo_Count, sendDic);
	});
	
}

- (void)paresPendingModelItem:(NSDictionary*)dataDic{
    
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    
    CoTransactionModel *cModel = [[CoTransactionModel alloc]init];
    [cModel serializationWithDictionary:contextDic];
    cModel.descript = [contextDic lzNSStringForKey:@"description"];
    cModel.appName = [[contextDic lzNSDictonaryForKey:@"appdata"]objectForKey:@"name"];
    cModel.appcolor = [[contextDic lzNSDictonaryForKey:@"appdata"]objectForKey:@"appcolor"];
    cModel.appid = [[contextDic lzNSDictonaryForKey:@"appdata"]objectForKey:@"appid"];
    cModel.appcode = [[contextDic lzNSDictonaryForKey:@"appdata"]objectForKey:@"appcode"];
    cModel.bid = [[contextDic lzNSDictonaryForKey:@"bdata"]objectForKey:@"bid"];
    cModel.bname = [[contextDic lzNSDictonaryForKey:@"bdata"]objectForKey:@"name"];
    cModel.tiid = [NSString stringWithFormat:@"%@%@",cModel.ttid,cModel.businessid];
    
    if ([contextDic count]<1) {
        cModel.status = 2;
        NSDictionary *getDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];

        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationPedningParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_TranSaction_Delete, getDic);
        });
        return;
    }
    
    NSDictionary *getDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
    NSString *status = [getDic objectForKey:@"status"];
    
        //通知
        //状态发生改变
        NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:cModel,@"data",status,@"status", nil];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationPedningParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_TranSaction_Update, sendDic);
        });

        
        

    
}

- (void)paresPendingGetModelByTsidType:(NSDictionary*)dataDic{
    
    NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    NSMutableArray *dataArr = [NSMutableArray array];
    
    CoTransactionTypeModel *typeModel = [[CoTransactionTypeModel alloc]init];
        
    [typeModel serializationWithDictionary:contextDic];
    typeModel.descript = [contextDic lzNSStringForKey:@"description"];
    [dataArr addObject:typeModel];
    [[CoTransactionTypeDAL shareInstance]addDataWithArray:dataArr];

    //状态发生改变
    NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:typeModel.ttid,@"ttid", nil];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationPedningParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Transaction_Model_Type, sendDic);
    });

}

#pragma mark - 解析数据(服务器返回的ErrorCode非0)
/**
 *  解析数据(服务器返回的ErrorCode非0)
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parseErrorDataContext:(NSMutableDictionary *)dataDic{
    
}

@end
