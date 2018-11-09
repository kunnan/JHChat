//
//  CooperationParse.m
//  LeadingCloud
//
//  Created by wang on 16/3/3.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CooperationParse.h"
#import "CoMemberDAL.h"
#import "ImGroupDAL.h"
#import "ImGroupUserDAL.h"
#import "ImGroupModel.h"
#import "CoGroupDAL.h"
#import "CoTaskDAL.h"
#import "CoProjectDAL.h"
#import "CoObserverModel.h"

@implementation CooperationParse


+(CooperationParse *)shareInstance{
    static CooperationParse *instance = nil;
    if (instance == nil) {
        instance = [[CooperationParse alloc] init];
    }
    return instance;
}

-(void)parse:(NSMutableDictionary *)dataDic{
    
    NSString *route = [dataDic objectForKey:WebApi_Route];
    
     //成员列表（分页）
    if ([route isEqualToString:WebApi_CloudCooperationGetPageMemberList] ||
        [route isEqualToString:WebApi_CooperationBaseFile_Authority_Member] ){
        NSMutableArray *memberArr=[NSMutableArray array];
         NSDictionary *param=[dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
        NSDictionary *dataOther = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Other];
        BOOL isSearch  = [[dataOther lzNSStringForKey:@"issearch"] boolValue];
        if ([route isEqualToString:WebApi_CooperationBaseFile_Authority_Member]) {
            
            param=[dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
            NSInteger indexStar=[[param lzNSNumberForKey:@"index"] integerValue];
            NSString *cid=[param lzNSStringForKey:@"cid"];
            if (indexStar == 0 && !isSearch) {
                [[CoMemberDAL shareInstance]deleteUnMyCooperationId:cid];
            }
        }
       
        
        NSString *str=[param lzNSStringForKey:@"lastuid"];
        NSString *cid=[param lzNSStringForKey:@"cid"];
        
        if (str &&[str isEqualToString:@"0"] && !isSearch) {
            
            [[CoMemberDAL shareInstance]deleteUnMyCooperationId:cid];
        }

        NSDictionary *dataContext=[dataDic lzNSDictonaryForKey:WebApi_DataContext];
         NSArray *mArray=[dataContext lzNSArrayForKey:@"data"];
        if ([route isEqualToString:WebApi_CooperationBaseFile_Authority_Member]) {
            
            mArray=(NSArray*)[dataDic lzNSArrayForKey:WebApi_DataContext];
        }
        
        for (NSDictionary *mDict in mArray) {
            CoMemberModel *mModel=[[CoMemberModel alloc]init];
            [mModel serializationWithDictionary:mDict];
            mModel.cid= cid;
            
            if ([route isEqualToString:WebApi_CooperationBaseFile_Authority_Member]) {
              
                mModel.uname = [mDict lzNSStringForKey:@"username"];
                mModel.mid = [mDict lzNSStringForKey:@"face"];
                mModel.utype = 2;
                mModel.isvalid = 1;
                
            }
            
            [memberArr addObject:mModel];
            
        }
        if (!isSearch){
            
            [[CoMemberDAL shareInstance]addDataWithArray:memberArr];
        }
        
        NSNumber *currentpage = [dataContext lzNSNumberForKey:@"currentpage"];
        NSNumber *islastpage = [dataContext lzNSNumberForKey:@"islastpage"];
        if ([route isEqualToString:WebApi_CooperationBaseFile_Authority_Member]
            && memberArr.count < [[[dataDic lzNSDictonaryForKey:WebApi_DataSend_Post] lzNSNumberForKey:@"count"] integerValue]) {
            
            islastpage = [NSNumber numberWithBool:YES];
        }
        
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:str,@"start",memberArr,@"member",cid,@"cid",currentpage,@"currentpage",islastpage,@"islastpage",nil];

        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationParse * service = self;
            if ([route isEqualToString:WebApi_CooperationBaseFile_Authority_Member]
                && isSearch) {
                NSDictionary *dict2=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"start",memberArr,@"member",cid,@"cid",nil];
                
                EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Member_Search_List, dict2);
            }
            else {
                EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Member_List, dict);
            }
            
        });
    }
    
    //成员列表 搜素
    else if ([route isEqualToString:WebApi_CloudCooperationGetSearchMemberList] ){
        
        NSMutableArray *memberArr=[NSMutableArray array];
        
        NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
        NSString *str=[param objectForKey:@"lastuid"];
        NSString *cid=[param objectForKey:@"cid"];
        
//        if (str &&[str isEqualToString:@"0"]) {
//            
//            [[CoMemberDAL shareInstance]deleteCooperationId:cid];
//        }
//        
        
        NSArray *mArray=[dataDic lzNSArrayForKey:WebApi_DataContext];
        
        for (NSDictionary *mDict in mArray) {
            CoMemberModel *mModel=[[CoMemberModel alloc]init];
            [mModel serializationWithDictionary:mDict];
            mModel.cid= cid;
            [memberArr addObject:mModel];
            
        }
     //   [[CoMemberDAL shareInstance]addDataWithArray:memberArr];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:str,@"start",memberArr,@"member",cid,@"cid",nil];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Member_Search_List, dict);
        });
    }
    else if ([route isEqualToString:WebApi_CloudCooperationGetValidMemberList]){
        //通过的成员列表
        NSMutableArray *memberArr=[NSMutableArray array];
        NSDictionary *getDict = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
        
        NSString *cid = [getDict objectForKey:@"cid"];
        NSArray *mArray=[dataDic lzNSArrayForKey:WebApi_DataContext];
        
        for (NSDictionary *mDict in mArray) {
            CoMemberModel *mModel=[[CoMemberModel alloc]init];
            [mModel serializationWithDictionary:mDict];
            mModel.cid = cid;
            [memberArr addObject:mModel];
            
        }

        [[CoMemberDAL shareInstance]addDataWithArray:memberArr];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Member_Valid_List, nil);
        });
    }
    
    // 退出协作
    else if ([route isEqualToString:WebApi_CloudCoo_Member_quit]){
        
        NSDictionary *param =[dataDic objectForKey:WebApi_DataSend_Get];
        
        NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
        NSString *context = [NSString stringWithFormat:@"%@",dataNumber];
//        NSString *context=[NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
        NSString *cid = [param objectForKey:@"cid"];
        NSString *type = [param objectForKey:@"type"];
        if (context && [context isEqualToString:@"1"]) {
            
            [[CoMemberDAL shareInstance]deleteCooperationId:cid];
            
            if (type && [type isEqualToString:@"task"]) {
                
                [[CoTaskDAL shareInstance]deleteTaskid:cid];
            }else if (type && [type isEqualToString:@"group"]){
                [[CoGroupDAL shareInstance]deleteGroupid:cid];
            }
        }
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Member_Quit, cid);
        });
    }
    
    //删除成员
    else if ([route isEqualToString:WebApi_CloudCoo_Member_del]){
        
//        NSString *context=[NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
        NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
        NSString *context = [NSString stringWithFormat:@"%@",dataNumber];
        if (context &&[context isEqualToString:@"1"]) {
            //成功
            NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
            NSString *uid=[param objectForKey:@"uid"];
            NSString *cid=[param objectForKey:@"cid"];
            [[CoMemberDAL shareInstance]deleteMemberCooperationId:cid Uid:uid];
            
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                __block CooperationParse * service = self;
                EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_RemoveMember, cid);
                
                NSString *number = [NSString stringWithFormat:@"%d",-1];
                NSDictionary *sendDict = [NSDictionary dictionaryWithObjectsAndKeys:cid,@"cid",number,@"number", nil];
                EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_Member_Number_Notification, sendDict);
            });
            
        }else{
            
        }
    }
    
    //重新邀请
    else if ([route isEqualToString:WebApi_CloudCoo_Member_AfreshAdd]){
        
//        NSString *context=[NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
        NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
        NSString *context = [NSString stringWithFormat:@"%@",dataNumber];
        if (context &&[context isEqualToString:@"1"]) {
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                __block CooperationParse * service = self;
                EVENT_PUBLISH_WITHDATA(service, EventBus_Member_AfreshAdd, nil);
            });

        }else{
            
        }

    }
    //撤销邀请
    else if ([route isEqualToString:WebApi_CloudCoo_Member_RevokeAdd]){
//        NSString *context=[NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
        NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
        NSString *context = [NSString stringWithFormat:@"%@",dataNumber];
        if (context &&[context isEqualToString:@"1"]) {
            NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
            NSString *uid=[param objectForKey:@"uid"];
            NSString *cid=[param objectForKey:@"cid"];
            [[CoMemberDAL shareInstance]deleteMemberCooperationId:cid Uid:uid];

            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                __block CooperationParse * service = self;
                EVENT_PUBLISH_WITHDATA(service, EventBus_Member_RevokeAdd, uid);
                
                NSString *number = [NSString stringWithFormat:@"%d",-1];
                NSDictionary *sendDict = [NSDictionary dictionaryWithObjectsAndKeys:cid,@"cid",number,@"number", nil];
                EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_Member_Number_Notification, sendDict);
            });

        }else{
            
        }


    }
    
    //添加成员
    else if ([route isEqualToString:WebApi_CloudCoo_Member_Add]){
        
        NSDictionary *getDict=[dataDic objectForKey:WebApi_DataSend_Get];
        
        NSMutableArray *invitedperson=[dataDic lzNSMutableArrayForKey:WebApi_DataContext];
        
        NSMutableArray *memberArr =[NSMutableArray array];
        NSString *cid =[getDict objectForKey:@"cid"];
        
        for (NSDictionary *subDict in invitedperson) {
            
            CoMemberModel *cModle = [[CoMemberModel alloc]init];
            
            [cModle serializationWithDictionary:subDict];
            cModle.cid = cid;
            [memberArr addObject:cModle];
        }
        NSString *finish = [getDict objectForKey:@"isFinish"];
        
        if (finish && [finish integerValue]==1) {
            [[CoMemberDAL shareInstance]addDataWithArray:memberArr];
        }
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Member_Add, cid);
            
            NSString *number = [NSString stringWithFormat:@"%lu",memberArr.count];
            NSDictionary *sendDict = [NSDictionary dictionaryWithObjectsAndKeys:cid,@"cid",number,@"number", nil];
            
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_Member_Number_Notification, sendDict);
        });
    }
    //修改当前人参与身份
    else if ([route isEqualToString:WebApi_CloudCoo_SetMemberOrg]){
        
        
//        NSString *context=[NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
        
        NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
        NSString *context = [NSString stringWithFormat:@"%@",dataNumber];
        NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
        
        NSString *uid=[[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
        NSString *cid=[param objectForKey:@"cid"];
        NSString *oid=[param objectForKey:@"oid"];
        NSString *orgname=[param objectForKey:@"orgname"];

        NSString *did=[param objectForKey:@"did"];
        NSString *depname=[param objectForKey:@"deptname"];

        NSString *type =[param objectForKey:@"type"];
        //更新当前用户身份信息
        [[CoMemberDAL shareInstance]UpDataMemberCompanyCooperationId:cid Uid:uid Oid:oid OrgName:orgname Did:did DepName:depname];
        
        if (type&& [type isEqualToString:@"group"]) {
            //更新当前协作coid
            [[CoGroupDAL shareInstance]updateGroupId:cid withzGroupCoid:oid];
        }else if ((type&& [type isEqualToString:@"task"])){
            //更新当前任务oid
            [[CoTaskDAL shareInstance]updateTaskCompanyTid:cid Oid:oid];
        }else if ((type&& [type isEqualToString:@"project"])){
            //更新当前任务oid
            [[CoTaskDAL shareInstance]updateTaskCompanyTid:cid Oid:oid];
        }

        
        if (context &&[context isEqualToString:@"1"]) {
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                __block CooperationParse * service = self;
                EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Set_MemberOrg, cid);
            });
        }else{
            
        }
        
    }
    
    // 判断成员是否存在
    else if ([route isEqualToString:WebApi_CloudCoo_IsExitMember]){
        
        NSDictionary *getDict=[dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
        NSNumber *isSucess=[dataDic lzNSNumberForKey:WebApi_DataContext];
        NSString *cid = [getDict lzNSStringForKey:@"cid"];
        NSString *name = [getDict lzNSStringForKey:@"cname"];
        NSDictionary *sendDict = [NSDictionary dictionaryWithObjectsAndKeys:isSucess,@"isSucess",cid,@"cid",name,@"name", nil];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Member_Exist, sendDict);
        });
    }
	
	
	//得到协作观察者列表
	else if ([route isEqualToString:WebApi_CloudCoo_ObserverList]){
		
		NSDictionary *getDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
		NSString *cid = [getDic objectForKey:@"cid"];
		NSArray *dataContext = [dataDic lzNSArrayForKey:WebApi_DataContext];
		
		NSMutableArray *observerArr = [NSMutableArray array];
		
		for (NSDictionary *dic in dataContext) {
		
			CoObserverModel *observerModel = [[CoObserverModel alloc]init];
			
			[observerModel serializationWithDictionary:dic];
			
			[observerArr addObject:observerModel];
			
			
		}
		
		NSDictionary *sendDict = [NSDictionary dictionaryWithObjectsAndKeys:cid,@"cid",observerArr,@"data", nil];
		/* 在主线程中发送通知 */
		dispatch_async(dispatch_get_main_queue(), ^{
			__block CooperationParse * service = self;
			EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Member_ObservreList, sendDict);
		});

		
	}
	
	//删除协作观察者
	else if ([route isEqualToString:WebApi_CloudCoo_DelCo_Observer]){
	
		
		NSDictionary *getDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
		NSString *cooid = [getDic objectForKey:@"cooid"];
		
		NSNumber *dataContext = [dataDic lzNSNumberForKey:WebApi_DataContext];
		
		
		if (dataContext.boolValue == true) {
			
			NSDictionary *sendDict = [NSDictionary dictionaryWithObjectsAndKeys:cooid,@"cooid", nil];
			/* 在主线程中发送通知 */
			dispatch_async(dispatch_get_main_queue(), ^{
				__block CooperationParse * service = self;
				EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Member_DelObservre, sendDict);
			});
		}

		
	}
	//添加协作观察者
	else if ([route isEqualToString:WebApi_CloudCoo_AddCo_Observer]){
		
		
		NSArray *dataContext = [dataDic lzNSArrayForKey:WebApi_DataContext];

		if (dataContext && dataContext.count>0) {
			
			NSMutableArray *observerArr = [NSMutableArray array];
			NSDictionary *getDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
			NSString *cid = [getDic objectForKey:@"cid"];
			for (NSDictionary *dic in dataContext) {
				
				CoObserverModel *observerModel = [[CoObserverModel alloc]init];
				
				[observerModel serializationWithDictionary:dic];
				
				[observerArr addObject:observerModel];
				
			}

			NSDictionary *sendDict = [NSDictionary dictionaryWithObjectsAndKeys:cid,@"cid",observerArr,@"data", nil];
			/* 在主线程中发送通知 */
			dispatch_async(dispatch_get_main_queue(), ^{
				__block CooperationParse * service = self;
				EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Member_AddObservre, sendDict);
			});

		}else{
			
			//添加失败
		}
		
	}
	
	//得到协作订阅状态
	else if ([route isEqualToString:WebApi_CloudCoo_Base_Get_Subscribe]){
		NSDictionary *dataContext=[dataDic lzNSDictonaryForKey:WebApi_DataContext];
		
		NSString *cid = [dataContext lzNSStringForKey:@"cid"];
		NSNumber *subscription = [dataContext lzNSNumberForKey:@"subscription"];
	
		
		NSDictionary *sendDict = [NSDictionary dictionaryWithObjectsAndKeys:cid,@"cid",subscription,@"subscription",[NSNumber numberWithBool:YES],@"isSucess", nil];
		/* 在主线程中发送通知 */
		dispatch_async(dispatch_get_main_queue(), ^{
			__block CooperationParse * service = self;
			EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Member_Subscribe, sendDict);
		});
		
	}
	//设置协作订阅状态
	else if ([route isEqualToString:WebApi_CloudCoo_Base_Set_Subscribe]){
		
		NSDictionary *postDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
		NSNumber *isSucess = [dataDic lzNSNumberForKey:WebApi_DataContext];
		
		NSString *cid = [postDic lzNSStringForKey:@"cid"];
		
		NSNumber *issubscription = [postDic lzNSNumberForKey:@"issubscription"];
		
		NSDictionary *sendDict = [NSDictionary dictionaryWithObjectsAndKeys:cid,@"cid",issubscription,@"subscription",isSucess,@"isSucess", nil];
		
		NSDictionary *getDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
		
		NSString *isroot = [getDic lzNSStringForKey:@"isRoot"];
		
		
		if (isroot && [isroot integerValue]==1) {//动态根页面刷新
			
			/* 在主线程中发送通知 */
			dispatch_async(dispatch_get_main_queue(), ^{
				__block CooperationParse * service = self;
				
				EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Member_ResSubscribe, sendDict);
			});
		}else{
			
			
			/* 在主线程中发送通知 */
			dispatch_async(dispatch_get_main_queue(), ^{//订阅通知
				__block CooperationParse * service = self;
				EVENT_PUBLISH_WITHDATA(service, EventBus_PostRoot_Refresh_Not, nil);

				EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_Member_Subscribe, sendDict);
			});
		}
	}
    else if ([route isEqualToString:WebApi_Cooperation_Base_Get]) {
        NSDictionary *dataContextDic = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationParse *service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_CloudCoo_Base_Get,dataContextDic);
        });
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
