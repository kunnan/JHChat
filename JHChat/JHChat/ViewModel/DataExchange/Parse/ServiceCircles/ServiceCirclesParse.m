//
//  ServiceCirclesParse.m
//  LeadingCloud
//
//  Created by wang on 17/3/28.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "ServiceCirclesParse.h"
#import "ServerCirclesDAL.h"
#import "AppUtils.h"
#import "ServiceCircleModel.h"

@implementation ServiceCirclesParse


+(ServiceCirclesParse *)shareInstance{
    static ServiceCirclesParse *instance = nil;
    if (instance == nil) {
        instance = [[ServiceCirclesParse alloc] init];
    }
    return instance;
}

-(void)parse:(NSMutableDictionary *)dataDic{

    NSString *route = [dataDic lzNSStringForKey:WebApi_Route];
    // 我加入的
    if ([route isEqualToString:WebApi_CloudsServiceCircles_Getlist]) {
        
        NSArray *contextArr = [dataDic lzNSArrayForKey:WebApi_DataContext];
        
        NSDictionary *getDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
        NSString *oid = [getDic lzNSStringForKey:@"oid"];
        [[ServerCirclesDAL shareInstance]deleJoinServerCircles:oid];

        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSDictionary *dic in contextArr) {
            
            ServiceCirclesListItem *sclItem = [[ServiceCirclesListItem alloc]init];
            [sclItem serializationWithDictionary:dic];
            sclItem.isjoin = YES;
            [dataArr addObject:sclItem];
        }
        
        [[ServerCirclesDAL shareInstance]addDataWithAppArray:dataArr];
        NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:dataArr,@"data",oid,@"oid", nil];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block ServiceCirclesParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_ServiceCircles_Join_Getlist, sendDic);
        });

    }
    // 推荐的
    else if ([route isEqualToString:WebApi_CloudsServiceCircles_Recommended_Getlist]) {
        
        NSArray *contextArr = [dataDic lzNSArrayForKey:WebApi_DataContext];
        
        NSDictionary *getDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
        NSString *oid = [getDic lzNSStringForKey:@"oid"];
		
		
		
        [[ServerCirclesDAL shareInstance]deleRecommendServerCircles:oid];
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSDictionary *dic in contextArr) {
            
            ServiceCirclesListItem *sclItem = [[ServiceCirclesListItem alloc]init];
            [sclItem serializationWithDictionary:dic];
            sclItem.isjoin = NO;
            [dataArr addObject:sclItem];
        }
        [[ServerCirclesDAL shareInstance]addDataWithAppArray:dataArr];

        NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:dataArr,@"data",oid,@"oid", nil];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block ServiceCirclesParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_ServiceCircles_Recommended_Getlist, sendDic);
        });

    }
    
    else if ([route isEqualToString:WebApi_CloudsServiceCircles_Search_Getlist]){
        
        
        NSArray *contextArr = [dataDic lzNSArrayForKey:WebApi_DataContext];
        
        NSDictionary *getDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
        NSString *oid = [getDic lzNSStringForKey:@"oid"];
        
        
        NSDictionary *postDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
        NSString *name = [postDic lzNSStringForKey:@"name"];
        NSString *lastkey = [postDic lzNSStringForKey:@"startindex"];
        
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSDictionary *dic in contextArr) {
			
            ServiceCirclesListItem *sclItem = [[ServiceCirclesListItem alloc]init];
            [sclItem serializationWithDictionary:dic];
            sclItem.isjoin = [[ServerCirclesDAL shareInstance]isJoinSearverCircles:sclItem.scid];
            [dataArr addObject:sclItem];
        }
    //    [[ServerCirclesDAL shareInstance]addDataWithAppArray:dataArr];
        
        NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:dataArr,@"data",oid,@"oid",name,@"name",lastkey,@"lastkey", nil];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block ServiceCirclesParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_ServiceCircles_Search_Getlist, sendDic);
        });

        
    }
	/// 通过uid获取首页服务圈信息
	else if ([route isEqualToString:WebApi_CloudsServiceCircles_Getfirstpagebyuid]){
		NSDictionary *contextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
	
		NSString *scid = [contextDic lzNSStringForKey:@"scid"];
		if (scid && [scid length]>1) {
			//读取本地的
			NSDictionary *olddic = [LZUserDataManager readHomeSeriviceCircleUid:[AppUtils GetCurrentUserID]];
			NSString * oldfile = [olddic lzNSStringForKey:@"firstlogo"];
			
			[LZUserDataManager saveIsLoadHomeSeriviceCircle:YES Uid:[AppUtils GetCurrentUserID]];
			[LZUserDataManager saveHomeSeriviceCircle:contextDic Uid:[AppUtils GetCurrentUserID]];
			
			NSString *fileid = [contextDic lzNSStringForKey:@"firstlogo"];
			if (fileid && [fileid length]>0) { //每次都下载吗？是否要读取本地呢
				if(![fileid isEqualToString:oldfile]){ //不等时才下载
				[AppUtils GetImageWithFileID:fileid Size:nil GetNewImage:^(UIImage *image, NSData *data) {
					[[ServiceCircleModel shareInstance]saveMainFileLogo:data];
				}];
				}
			}else{
				[[ServiceCircleModel shareInstance]removeMainFileLogo];
			}
			NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:scid,@"scid", nil];

			dispatch_async(dispatch_get_main_queue(), ^{
				__block ServiceCirclesParse * service = self;
				EVENT_PUBLISH_WITHDATA(service, EventBus_ServiceCircles_Firstpage, sendDic);
			});
		}else{
			//没有主服务圈 删除
			[[ServiceCircleModel shareInstance]removeMainFileLogo];
			[[ServiceCircleModel shareInstance]saveMainHomeServiceCirclesInfo:nil Uid:[AppUtils GetCurrentUserID]];
		}
		
	}
	///  设置该服务圈是否为首页展示
	else if ([route isEqualToString:WebApi_CloudsServiceCircles_Developer_Setisfirstpage]){
		
		NSNumber *context = [dataDic lzNSNumberForKey:WebApi_DataContext];

		if (context.integerValue==1) {
			//成功 没有取消的啦
			NSDictionary *getDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
			
			dispatch_async(dispatch_get_main_queue(), ^{
				__block ServiceCirclesParse * service = self;
				EVENT_PUBLISH_WITHDATA(service, EventBus_ServiceCircles_Setisfirstpage, getDic);
			});
			
			
		}else{
			
			//设置失败了呗
			
		}

		
	}
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
