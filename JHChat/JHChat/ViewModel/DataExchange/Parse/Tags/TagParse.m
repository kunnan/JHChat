//
//  TagParse.m
//  LeadingCloud
//
//  Created by wang on 16/2/19.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "TagParse.h"
#import "TagDataDAL.h"
#import "CooperationDynamicModel.h"

@implementation TagParse

+(TagParse *)shareInstance{
    static TagParse *instance = nil;
    if (instance == nil) {
        instance = [[TagParse alloc] init];
    }
    return instance;
}

-(void)parse:(NSMutableDictionary *)dataDic{
    
    NSString *route = [dataDic objectForKey:WebApi_Route];
    
    if ([route isEqualToString:WebApi_CloudTagCreat]) {
    // 创建标签
    
        NSDictionary *dict= [dataDic lzNSDictonaryForKey:WebApi_DataContext];
        TagDataModel *listObject=[[TagDataModel alloc]init];
        [listObject serializationWithDictionary:dict];
        
        [[TagDataDAL shareInstance]addTagDataModel:listObject];
        
        NSDictionary *postDict= [dataDic lzNSDictonaryForKey:WebApi_DataContext];
        NSString *ttid = [postDict objectForKey:@"ttid"];
        if (ttid && [ttid isEqualToString:@"post"]) {
            [[CooperationDynamicModel shareInstance]sendAddTagNoticePid:listObject.dataid TagId:listObject.tdid];
        }
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block TagParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Tags_TagParse_Creat, listObject);
        });
    } else if ([route isEqualToString:webApi_CloudTagCanel]){
        //删除标签
        NSDictionary *dict= [dataDic objectForKey:WebApi_DataSend_Get];
        NSString *tid=[dict objectForKey:@"tid"];
        [[TagDataDAL shareInstance]deleteTagid:tid];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block TagParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Tags_TagParse_Cannel, dict);
        });
	}else if ([route isEqualToString:webApi_CloudTagList]){
		
		NSArray *arr= [dataDic lzNSArrayForKey:WebApi_DataContext];
		
		NSMutableArray *dataArr = [NSMutableArray array];
		for (NSDictionary *dic in arr) {
			
			TagDataModel *model = [[TagDataModel alloc]init];
			
			[model serializationWithDictionary:dic];
			[dataArr addObject:model];
		}
		
		/* 在主线程中发送通知 */
		dispatch_async(dispatch_get_main_queue(), ^{
			__block TagParse * service = self;
			EVENT_PUBLISH_WITHDATA(service, EventBus_Tags_TagList, dataArr);
		});
	}else if ([route isEqualToString:webApi_CloudTagAdd]){
		
//		EventBus_Tags_TagParse_Add
		
		NSArray *arr= [dataDic lzNSArrayForKey:WebApi_DataContext];
		
		NSMutableArray *dataArr = [NSMutableArray array];
		for (NSDictionary *dic in arr) {
			
			TagDataModel *model = [[TagDataModel alloc]init];
			
			[model serializationWithDictionary:dic];
			[dataArr addObject:model];
		}
		
		/* 在主线程中发送通知 */
		dispatch_async(dispatch_get_main_queue(), ^{
			__block TagParse * service = self;
			EVENT_PUBLISH_WITHDATA(service, EventBus_Tags_TagParse_Add, dataArr);
		});
		
	}
	else if ([route isEqualToString:webApi_CloudTagDelete]){
		NSNumber *context= [dataDic lzNSNumberForKey:WebApi_DataContext];
		NSArray *postArr= [dataDic lzNSArrayForKey:WebApi_DataSend_Post];

		if (context.boolValue==true) {
			/* 在主线程中发送通知 */
			dispatch_async(dispatch_get_main_queue(), ^{
				__block TagParse * service = self;
				EVENT_PUBLISH_WITHDATA(service, EventBus_Tags_TagParse_Delete, postArr);
			});
		}
	}
    
}









#pragma mark -
#pragma mark - 解析数据(服务器返回的ErrorCode非0)

/**
 *  解析数据(服务器返回的ErrorCode非0)
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parseErrorDataContext:(NSMutableDictionary *)dataDic{
    
}


@end
