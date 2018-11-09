//
//  PostParse.m
//  LeadingCloud
//
//  Created by wang on 16/3/7.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "PostParse.h"

#import "CooperationExchange.h"
#import "PostFileModel.h"
#import "PostPromptDAL.h"
#import "CoMemberModel.h"
#import "PostZanModel.h"
#import "PostDAL.h"
#import "TagDataDAL.h"
#import "PostFileDAL.h"
#import "PostPraiseDAL.h"
#import "YMTextData.h"
#import "AppDateUtil.h"
#import "PostNotificationDAL.h"
#import "ResModel.h"
#import "ResDAL.h"
#import "PostTemplateDAL.h"
#import "PostCooperationTypeDAL.h"
#import "NSDictionary+DicSerial.h"
#import "LCProgressHUD.h"
#import "SysApiVersionDAL.h"

@implementation PostParse

+(PostParse *)shareInstance{
    static PostParse *instance = nil;
    if (instance == nil) {
        instance = [[PostParse alloc] init];
    }
    return instance;
}

-(void)parse:(NSMutableDictionary *)dataDic{

     NSString *route = [dataDic objectForKey:WebApi_Route];
    // 动态列表
     if ([route isEqualToString:WebApi_CloudPostList]|| [route isEqualToString:WebApi_CloudFollowNextPostList]) {
         
         [self parsePostList:dataDic];
     }
	//个人动态列表
	 else if ([route isEqualToString:WebApi_CloudUserPostList]){
		 
		 NSDictionary *contextDic = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
		 //原始数组
		 NSMutableArray *contextArr  = [contextDic lzNSMutableArrayForKey:@"postlist"];
		 
		 //post 字典
		 NSDictionary *postDict=[dataDic objectForKey:WebApi_DataSend_Post];
		 //开始
		 NSString *startindex=[postDict objectForKey:@"startindex"];
		 //长度
		 //列表类型
		 NSString *type=[postDict objectForKey:@"appcode"];

		 //协作id
		 NSString *uid = [postDict lzNSStringForKey:@"personalid"];
		 
		 BOOL isShowBlueFileName;// 是否展示文件名称
	
		isShowBlueFileName=YES;

		 NSMutableArray *pArr=[NSMutableArray array];
		 
		 for (NSDictionary *subDict in contextArr) {
			 
			 PostModel *pModel=[[PostModel alloc]init];
			 [pModel serializationWithDictionary:subDict];
			 pModel.isShowFileName=isShowBlueFileName;
			 
			 // 标签
			 if (pModel.tagdata) {
				 NSMutableArray *tagArr=[NSMutableArray array];
				 for (NSDictionary *tagDict in pModel.tagdata) {
					 
					 TagDataModel *tModel=[[TagDataModel alloc]init];
					 [tModel serializationWithDictionary:tagDict];
					 tModel.dataid=pModel.pid;
					 [tagArr addObject:tModel];
				 }

				 pModel.tagdata=tagArr;
				 
			 }
			 // 文件
			 if (pModel.rosourlist && [pModel.rosourlist count]!=0) {
				 NSMutableArray *fileArr=[NSMutableArray array];
				 for (NSDictionary *fileDict in pModel.rosourlist) {
					 PostFileModel *fModel=[[PostFileModel alloc]init];
					 [fModel serializationWithDictionary:fileDict];
					 fModel.descripti=[fileDict objectForKey:@"description"];
					 fModel.postID=pModel.pid;
					 [fileArr addObject:fModel];
					 
				 }
				 [[PostFileDAL shareInstance]addDataWithArray:fileArr];
				 pModel.rosourlist=fileArr;
			 }
			 
			 // 回复
			 if(pModel.replypostlist&&[pModel.replypostlist count]!=0){
				 NSMutableArray *replyArr=[NSMutableArray array];
				 for (NSDictionary *rDict in pModel.replypostlist) {
					 PostModel *rModel=[[PostModel alloc]init];
					 [rModel serializationWithDictionary:rDict];
					 [replyArr addObject:rModel];
				 }

				 pModel.replypostlist=replyArr;
			 }

			 //点赞
			 if(pModel.prainseusername&&[pModel.prainseusername count]!=0){
				 
				 NSMutableArray *zanArr=[NSMutableArray array];
				 
				 for (NSDictionary *zDict in pModel.prainseusername) {
					 PostZanModel *zModel=[[PostZanModel alloc]init];
					 [zModel serializationWithDictionary:zDict];
					 [zanArr addObject:zModel];
				 }
				 pModel.prainseusername=zanArr;
			 }

			 //地理位置
			 if (pModel.positiondiction && [pModel.positiondiction count]!=0) {
				 pModel.longitude=[NSString stringWithFormat:@"%@",[pModel.positiondiction objectForKey:@"longitude"]];
				 pModel.latitude=[NSString stringWithFormat:@"%@",[pModel.positiondiction objectForKey:@"latitude"]];
				 pModel.reference=[pModel.positiondiction objectForKey:@"reference"];
				 pModel.address=[pModel.positiondiction objectForKey:@"address"];
			 }
			 [pArr addObject:pModel];
			 
		 }
		 
		 

		 BOOL isLocation = NO; //是否做本地存储
		 if(type && [type isEqualToString:@"Cooperation"]){
			 isLocation = YES;
		 }
		 NSMutableArray *dataArr=[[CooperationExchange shareInstance]getPostListFromOrginDataArr:pArr IsRoot:isLocation];
		 NSMutableDictionary *dict=[NSMutableDictionary dictionary];
		 [dict setObject:dataArr forKey:@"data"];
		 [dict setObject:startindex forKey:@"startindex"];
		 [dict setObject:uid forKey:@"uid"];

		 
		 /* 在主线程中发送通知 */
		 dispatch_async(dispatch_get_main_queue(), ^{
			 __block PostParse * service = self;
			 EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_User_List, dict);
		 });
	 }
    //模板列表
     else if ([route isEqualToString:WebApi_CloudPostTempleList]){
		 
         [self parsePostTempleList:dataDic];
     }
	
    //动态类型
	
     else if ([route isEqualToString:WebApi_CloudGetPosttypeList]){
         [self parsePostTypeList:dataDic];

     }
    // 常用语列表
     else if ([route isEqualToString:WebApi_CloudPostGetPostCueList]){
		 
         NSMutableArray *contextArr  = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
         NSMutableArray *pArr=[NSMutableArray array];
         for (NSDictionary *subDict in contextArr) {
			 
             PostPromptModel *pModel=[[PostPromptModel alloc]init];
			 
             [pModel serializationWithDictionary:subDict];
             if (pModel.cueorgid && [pModel.cueorgid length]!=0) {
                 
             }else{
                 pModel.cueorgid=@"";
             }
             [pArr addObject:pModel];
         }
         [[PostPromptDAL shareInstance]deletePrompt];
         [[PostPromptDAL shareInstance]addDataWithArray:pArr];
         
         /* 在主线程中发送通知 */
         dispatch_async(dispatch_get_main_queue(), ^{
             __block PostParse * service = self;
             EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_Prompt, pArr);
         });
     }
    
    //删除常用语
     else if ([route isEqualToString:WebApi_CloudPostGetPostCueDel]){
         
         NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
         NSString *pcid=[param objectForKey:@"pcid"];
         
         [[PostPromptDAL shareInstance]deletePromptid:pcid];
         
         /* 在主线程中发送通知 */
         dispatch_async(dispatch_get_main_queue(), ^{
             __block PostParse * service = self;
             EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_Prompt_Del, pcid);
         });
     }
    
    // 协作常用语改变通知
     else if ([route isEqualToString:WebApi_CloudPostGetPostCueDetial]){
         
         NSDictionary *datacontext=[dataDic lzNSDictonaryForKey:WebApi_DataContext];
         PostPromptModel *pModel=[[PostPromptModel alloc]init];
         [pModel serializationWithDictionary:datacontext];
         [[PostPromptDAL shareInstance]addPromptModel:pModel];
         
         /* 在主线程中发送通知 */
         dispatch_async(dispatch_get_main_queue(), ^{
             __block PostParse * service = self;
             EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_Prompt_Change, nil);
         });
         
     }
    //添加常用语
     else if ([route isEqualToString:WebApi_CloudPostGetPostCueAdd]){
         
         NSString *pcid=[dataDic lzNSStringForKey:WebApi_DataContext];
         
         NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Post];
         NSString *cuename=[param objectForKey:@"cuename"];
         NSString *cueorgid=[param objectForKey:@"cueorgid"];
         NSString *creatdate=[param objectForKey:@"creatdate"];
         PostPromptModel *pModel=[[PostPromptModel alloc]init];
         pModel.pcid=pcid;
         pModel.cuename=cuename;
         pModel.cueorgid=cueorgid;
         pModel.cueuid=[[LZUserDataManager readCurrentUserInfo] objectForKey:@"uid"];
         pModel.createdate=[LZFormat String2Date:creatdate];
         [[PostPromptDAL shareInstance]addPromptModel:pModel];
         
         /* 在主线程中发送通知 */
         dispatch_async(dispatch_get_main_queue(), ^{
             __block PostParse * service = self;
             EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_Prompt_Add, pModel);
         });
     }
    //@好友成员
     else if ([route isEqualToString:WebApi_CloudPostGetmembermodellist]){
         
         NSDictionary *postDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
         
         NSDictionary *contextDic=[dataDic lzNSDictonaryForKey:WebApi_DataContext];
         NSArray *contextArr = [contextDic lzNSArrayForKey:@"data"];
         NSString *page = [NSString stringWithFormat:@"%@",[contextDic objectForKey:@"currentpage"]];
         
         NSMutableArray *memberArr=[NSMutableArray array];
         for (NSDictionary *dict in contextArr) {
             CoMemberModel *cModel=[[CoMemberModel alloc]init];
             [cModel serializationWithDictionary:dict];
             cModel.uname=[dict objectForKey:@"username"];
             [memberArr addObject:cModel];
         }
         
         NSString *lastid = [postDic lzNSStringForKey:@"lastid"];
         NSString *indexvalue = [postDic lzNSStringForKey:@"indexvalue"];
         NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:memberArr,@"member",lastid,@"lastid",indexvalue,@"indexvalue",page,@"page", nil];
         /* 在主线程中发送通知 */
         dispatch_async(dispatch_get_main_queue(), ^{
             __block PostParse * service = self;
             EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_MemberList, sendDic);
         });
     }
    //发布动态
     else if ([route isEqualToString:WebApi_CloudPostAddPost]||[route isEqualToString:WebApi_CloudPostAddbasepostPost]){
         
         NSDictionary *dataContext=[dataDic lzNSDictonaryForKey:WebApi_DataContext];
		 
		 NSString *pid = [dataContext lzNSStringForKey:@"pid"];
		 
		 if ([pid length]<=1) {
			 __block PostParse * service = self;

			 EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_Up_Failure, nil);

			 return;
			 
		 }
		 
         NSDictionary *postDic=[dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
         NSString *relevanceappcode = [postDic lzNSStringForKey:@"relevanceappcode"];
         YMTextData *textData;
        // YMTextData *notfileData;
		 YMTextData *rootData;

         if ([dataContext isKindOfClass:[NSDictionary class]]) {
             
             PostModel *pModel=[[PostModel alloc]init];
             [pModel serializationWithDictionary:dataContext];
             // 文件
             // NSArray *rosourlist=[subDict objectForKey:@"rosourlist"];
             if (pModel.rosourlist && [pModel.rosourlist count]!=0) {
                 NSMutableArray *fileArr=[NSMutableArray array];
                 for (NSDictionary *fileDict in pModel.rosourlist) {
                     PostFileModel *fModel=[[PostFileModel alloc]init];
                     [fModel serializationWithDictionary:fileDict];
                     fModel.descripti=[fileDict objectForKey:@"description"];
                     fModel.postID=pModel.pid;
                     [fileArr addObject:fModel];
                     
                 }
                 [[PostFileDAL shareInstance]addDataWithArray:fileArr];
                 pModel.rosourlist=fileArr;
             }
			 
             if (pModel.positiondiction && [pModel.positiondiction count]!=0) {
                 
                 pModel.longitude=[NSString stringWithFormat:@"%@",[pModel.positiondiction objectForKey:@"longitude"]];
                 pModel.latitude=[NSString stringWithFormat:@"%@",[pModel.positiondiction objectForKey:@"latitude"]];
                 pModel.reference=[pModel.positiondiction objectForKey:@"reference"];
                 pModel.address=[pModel.positiondiction objectForKey:@"address"];
             }
             pModel.isShowFileName=YES;
             textData=[[CooperationExchange shareInstance] getPostDataFormPostModel:pModel];
           //  pModel.isShowFileName = NO;
            // notfileData=[[CooperationExchange shareInstance] getPostDataFormPostModel:pModel];
			
			rootData =[[[CooperationExchange shareInstance]getPostListFromOrginDataArr:[NSMutableArray arrayWithObject:pModel] IsRoot:YES]firstObject];
			 
         }
         
      
         NSDictionary *getDict = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
		 
		 NSInteger isSubscribe = [[getDict lzNSStringForKey:@"isSubscribe"]integerValue];
         /* 在主线程中发送通知 */
         dispatch_async(dispatch_get_main_queue(), ^{
             __block PostParse * service = self;
             NSDictionary *sendDict = [NSDictionary dictionaryWithObjectsAndKeys:textData,@"data",[getDict lzNSStringForKey:@"corgid"],@"corgid",relevanceappcode,@"relevanceappcode", nil];
			 
			 NSDictionary *rootDict = [NSDictionary dictionaryWithObjectsAndKeys:rootData,@"data",[getDict lzNSStringForKey:@"corgid"],@"corgid",relevanceappcode,@"relevanceappcode", nil];

             EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_Add, sendDict);
			 
			 if (isSubscribe == 1) {
				 EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_AddRoot, rootDict);
			 }
             // 动态留痕，需要刷新动态
             if ([[getDict lzNSStringForKey:@"isRefresh"] isEqualToString:@"1"]) {
                 EVENT_PUBLISH_WITHDATA(service, EventBus_PostRoot_Refresh_Not, nil);
             }

             
			// EventBus_PostParse_AddRoot
             //EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_FileAdd, notfileData);
         });
     }
    //添加评论
     else if ([route isEqualToString:WebApi_CloudPostReplyPost]){
         
         NSDictionary *dataContext=[dataDic lzNSDictonaryForKey:WebApi_DataContext];
         __block PostParse * service = self;
         NSDictionary *getParam=[dataDic objectForKey:WebApi_DataSend_Get];
         NSInteger cIndex=[[getParam objectForKey:@"cindex"]integerValue];
         
         NSDictionary *postParam=[dataDic objectForKey:WebApi_DataSend_Post];
         
         NSMutableDictionary *dict=[NSMutableDictionary dictionary];
         PostModel *pModel=[[PostModel alloc]init];
         [pModel serializationWithDictionary:postParam];
         
         [[PostDAL shareInstance]addPostModel:pModel];
         dict[@"context"]=[dataContext objectForKey:@"content"];
         dict[@"pid"]=[dataContext objectForKey:@"pid"];
         dict[@"curindex"]=[NSString stringWithFormat:@"%ld",cIndex];
         dict[@"relatedpid"]=[postParam objectForKey:@"relatedpid"];
         dict[@"releasedate"]= [postParam lzNSStringForKey:@"releasedate"];
         NSString *type=[getParam objectForKey:@"type"];
         
         /* 在主线程中发送通知 */
         dispatch_async(dispatch_get_main_queue(), ^{
             if ([type isEqualToString:@"replay"]) {
                 //回复
                 dict[@"directrelateduser"]=[postParam objectForKey:@"directrelateduser"];
                 dict[@"directrelatedusername"]=[postParam objectForKey:@"directrelatedusername"];
                EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_AddReplys, dict);

             }else{
                 // 评论
                 EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_AddReply, dict);
             }
         });
     }
    //删除评论
     else if ([route isEqualToString:WebApi_CloudPostDelPost]){
         
//         NSString *dataContext=[dataDic lzNSStringForKey:WebApi_DataContext];
         
         NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
         NSString *pid=[param objectForKey:@"pid"];
         [[PostDAL shareInstance]delePostID:pid];
         
         /* 在主线程中发送通知 */
         dispatch_async(dispatch_get_main_queue(), ^{
             __block PostParse * service = self;
             EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_DelReply, param);
         });
     }
    // 点赞
     else if ([route isEqualToString:WebApi_CloudPostPraisePost]){
        
         NSString *ppid=[dataDic lzNSStringForKey:WebApi_DataContext];
         PostZanModel *zModel=[[PostZanModel alloc]init];
         NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
         zModel.pid=[param objectForKey:@"pid"];
         zModel.ppid=ppid;
         zModel.uid=[[LZUserDataManager readCurrentUserInfo]objectForKey:@"uid"];
         zModel.username=[[LZUserDataManager readCurrentUserInfo]objectForKey:@"username"];
         zModel.praisedate=[AppDateUtil GetCurrentDate];
         [[PostPraiseDAL shareInstance]addDataWithModel:zModel];
         
         NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:ppid,@"ppid",[param lzNSStringForKey:@"pid"],@"pid", nil];
        
         /* 在主线程中发送通知 */
         dispatch_async(dispatch_get_main_queue(), ^{
             __block PostParse * service = self;
             EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_AddZan, sendDic);
         });
         // 1 添加 0 取消
     }
    //取消点赞
     else if ([route isEqualToString:WebApi_CloudPostPraiseCannelPost]){
         
//         NSString *dataContext=[NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
         NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
         NSString *dataContext = [NSString stringWithFormat:@"%@",dataNumber];
         NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
         NSString *ppid=[param objectForKey:@"ppid"];
         [[PostPraiseDAL shareInstance]delePostPraiseID:ppid];
        if (dataContext&&[dataContext isEqualToString:@"1"]) {
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                 __block PostParse * service = self;
                 EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_CannelZan, param);
            });
         }
     } 
    
    
    //动态提醒
     else if ([route isEqualToString:WebApi_CloudPostRemindList]){
         NSDictionary *dataContext=[dataDic lzNSDictonaryForKey:WebApi_DataContext];
         
         //历史提醒
         NSArray *readpostremindlist=[dataContext lzNSArrayForKey:@"readpostremindlist"];
         //未读提醒
         NSArray *unreadpostremindlist=[dataContext lzNSArrayForKey:@"unreadpostremindlist"];

         NSMutableArray *notificationArr=[NSMutableArray array];
         for (NSDictionary *subDcit in readpostremindlist) {
             
             PostNotificationModel *nModel=[[PostNotificationModel alloc]init];
             
             [nModel serializationWithDictionary:subDcit];
             nModel.sendDateString=[AppDateUtil getSystemShowTime:nModel.senddatetime isShowMS:YES];
             PostNotificationParamModel *pModel=[[PostNotificationParamModel alloc]init];
             [pModel serializationWithDictionary:nModel.notificationparamsdic];
             nModel.paramModel=pModel;
             [notificationArr addObject:nModel];
         }
         
         [[PostNotificationDAL shareInstance]addDataWithArray:notificationArr];
         
         NSMutableArray *unnotificationArr=[NSMutableArray array];
         for (NSDictionary *subDcit in unreadpostremindlist) {
             
             PostNotificationModel *nModel=[[PostNotificationModel alloc]init];
             
             [nModel serializationWithDictionary:subDcit];
             nModel.sendDateString=[AppDateUtil getSystemShowTime:nModel.senddatetime isShowMS:YES];
             PostNotificationParamModel *pModel=[[PostNotificationParamModel alloc]init];
             [pModel serializationWithDictionary:nModel.notificationparamsdic];
             nModel.paramModel=pModel;
             [unnotificationArr addObject:nModel];
         }
         
         [[PostNotificationDAL shareInstance]addDataWithArray:unnotificationArr];
         
         NSMutableArray *data = [[CooperationExchange shareInstance]getPostRemindListFromOriginArr:notificationArr];
         NSMutableArray *undata = [[CooperationExchange shareInstance]getPostRemindListFromOriginArr:unnotificationArr];
         
         __block PostParse * service = self;
         
         
         NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:data,@"read",undata,@"unread", nil];
         
         /* 在主线程中发送通知 */
         dispatch_async(dispatch_get_main_queue(), ^{
      
            EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_Notification, sendDic);
         });
     }
    
    //未读提醒
     else if ([route isEqualToString:WebApi_CloudPostunreadRemindList]){
         NSDictionary *dataContext=[dataDic lzNSDictonaryForKey:WebApi_DataContext];
         
         //历史提醒
         //未读提醒
         NSArray *unreadpostremindlist=[dataContext lzNSArrayForKey:@"unreadpostremindlist"];
         NSMutableArray *notificationArr=[NSMutableArray array];
         for (NSDictionary *subDcit in unreadpostremindlist) {
             
             PostNotificationModel *nModel=[[PostNotificationModel alloc]init];
             
             [nModel serializationWithDictionary:subDcit];
             nModel.sendDateString=[AppDateUtil getSystemShowTime:nModel.senddatetime isShowMS:YES];
             PostNotificationParamModel *pModel=[[PostNotificationParamModel alloc]init];
             [pModel serializationWithDictionary:nModel.notificationparamsdic];
             nModel.paramModel=pModel;
             [notificationArr addObject:nModel];
         }
         [[PostNotificationDAL shareInstance]addDataWithArray:notificationArr];
         NSMutableArray *data = [[CooperationExchange shareInstance]getPostRemindListFromOriginArr:notificationArr];
         
         /* 在主线程中发送通知 */
         dispatch_async(dispatch_get_main_queue(), ^{
             __block PostParse * service = self;

            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_Post_New_Notification,data);
             
        });

     }
    // 历史提醒
     else if ([route isEqualToString:WebApi_CloudPostMoreRemindList]){
         NSArray *dataContext=[dataDic lzNSArrayForKey:WebApi_DataContext];
         NSMutableArray *notificationArr=[NSMutableArray array];
         for (NSDictionary *subDcit in dataContext) {
             
             PostNotificationModel *nModel=[[PostNotificationModel alloc]init];
             
             [nModel serializationWithDictionary:subDcit];
             nModel.sendDateString=[AppDateUtil getSystemShowTime:nModel.senddatetime isShowMS:YES];
             PostNotificationParamModel *pModel=[[PostNotificationParamModel alloc]init];
             [pModel serializationWithDictionary:nModel.notificationparamsdic];
             nModel.paramModel=pModel;
             [notificationArr addObject:nModel];
         }
         [[PostNotificationDAL shareInstance]addDataWithArray:notificationArr];
         NSMutableArray *data = [[CooperationExchange shareInstance]getPostRemindListFromOriginArr:notificationArr];

         /* 在主线程中发送通知 */
         dispatch_async(dispatch_get_main_queue(), ^{
             __block PostParse * service = self;
             EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_History_Notification, data);
         });
     }
    // 动态详情
     else if ([route isEqualToString:WebApi_CloudPostGetPostShowModel]){
         
         NSDictionary *dict = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
         
         if (!([dict isKindOfClass:[NSDictionary class]] && [dict count]!=0)) {
             
             /* 在主线程中发送通知 */
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 __block PostParse * service = self;
                 EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_Detial, [NSMutableArray array]);
                });
            return;
         }

         NSArray *contextArr=[NSArray arrayWithObject:dict];
         
         NSDictionary *getDict=[dataDic objectForKey:WebApi_DataSend_Get];
         NSString *pid = [getDict objectForKey:@"pid"];
         
         [[PostDAL shareInstance]delePostReplyID:pid];
         
         NSMutableArray *pArr=[NSMutableArray array];
  
         for (NSDictionary *subDict in contextArr) {
             
             PostModel *pModel=[[PostModel alloc]init];
             [pModel serializationWithDictionary:subDict];
             pModel.isShowFileName=YES;
             // 标签
             //  NSArray *tagdata=[subDict objectForKey:@"tagdata"];
             if (pModel.tagdata) {
                 NSMutableArray *tagArr=[NSMutableArray array];
                 for (NSDictionary *tagDict in pModel.tagdata) {
                     
                     TagDataModel *tModel=[[TagDataModel alloc]init];
                     [tModel serializationWithDictionary:tagDict];
                     tModel.dataid=pModel.pid;
                     [tagArr addObject:tModel];
                 }
                 [[TagDataDAL shareInstance] addDataWithTagDataArray:tagArr];
                 
                 pModel.tagdata=tagArr;
                 
             }
             
             // 文件
             // NSArray *rosourlist=[subDict objectForKey:@"rosourlist"];
             if (pModel.rosourlist && [pModel.rosourlist count]!=0) {
                 NSMutableArray *fileArr=[NSMutableArray array];
                 for (NSDictionary *fileDict in pModel.rosourlist) {
                     PostFileModel *fModel=[[PostFileModel alloc]init];
                     [fModel serializationWithDictionary:fileDict];
                     fModel.descripti=[fileDict objectForKey:@"description"];
                     fModel.postID=pModel.pid;
                     [fileArr addObject:fModel];
                     
                 }
                 [[PostFileDAL shareInstance]addDataWithArray:fileArr];
                 pModel.rosourlist=fileArr;
             }
             
             // 评论
             if(pModel.replypostlist&&[pModel.replypostlist count]!=0){
                 NSMutableArray *replyArr=[NSMutableArray array];
                 for (NSDictionary *rDict in pModel.replypostlist) {
                     PostModel *rModel=[[PostModel alloc]init];
                     [rModel serializationWithDictionary:rDict];
                     [replyArr addObject:rModel];
                 }
                 [[PostDAL shareInstance]addDataWithArray:replyArr];
                 pModel.replypostlist=replyArr;
             }
             //点赞
             [[PostPraiseDAL shareInstance]delePostPID:pModel.pid];

             if(pModel.prainseusername&&[pModel.prainseusername count]!=0){

                 NSMutableArray *zanArr=[NSMutableArray array];
                 
                 for (NSDictionary *zDict in pModel.prainseusername) {
                     PostZanModel *zModel=[[PostZanModel alloc]init];
                     [zModel serializationWithDictionary:zDict];
                     [zanArr addObject:zModel];
                 }
                 pModel.prainseusername=zanArr;
                 [[PostPraiseDAL shareInstance]addDataWithArray:zanArr];
                 
             }
             
             pModel.oid=[[[LZUserDataManager readCurrentUserInfo] objectForKey:@"notificaton"] objectForKey:@"selectoid"];
             if (pModel.positiondiction && [pModel.positiondiction count]!=0) {
                 
                 pModel.longitude=[NSString stringWithFormat:@"%@",[pModel.positiondiction objectForKey:@"longitude"]];
                 pModel.latitude=[NSString stringWithFormat:@"%@",[pModel.positiondiction objectForKey:@"latitude"]];
                 pModel.reference=[pModel.positiondiction objectForKey:@"reference"];
                 
             }

             [pArr addObject:pModel];
             
         }
         
        // [[PostDAL shareInstance]addDataWithArray:pArr];
         NSMutableArray *dataArr=[[CooperationExchange shareInstance]getPostListFromOrginDataArr:pArr IsRoot:NO];
         NSMutableArray *rootArr =[[CooperationExchange shareInstance]getPostListFromOrginDataArr:pArr IsRoot:YES];
         NSString *isNotiaction=[getDict objectForKey:@"isNotiaction"];
		 if (isNotiaction && [isNotiaction isEqualToString:@"1"]) {
//			 [[PostDAL shareInstance]addDataWithArray:pArr];

		 }
         /* 在主线程中发送通知 */
         dispatch_async(dispatch_get_main_queue(), ^{
             if (isNotiaction && [isNotiaction isEqualToString:@"1"]) {
                 //通知
                 __block PostParse * service = self;
                 //只通知根页面
                 EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_Post_add, dataArr);
				 EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_Post_addRoot, rootArr);
				 
			 }else if (isNotiaction && [isNotiaction isEqualToString:@"2"]){
				 __block PostParse * service = self;

				 EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_Post_read, dataArr);
			 }
			 else{
                 //详情
                 __block PostParse * service = self;
                 EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_Detial, dataArr);
             }
         });
     }
}

#pragma mark  动态列表
- (void)parsePostList:(NSMutableDictionary*)dataDic{
    
    NSDictionary *contextDic = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    //原始数组
    NSMutableArray *contextArr  = [contextDic lzNSMutableArrayForKey:@"postlist"];
    
    //post 字典
    NSDictionary *postDict=[dataDic objectForKey:WebApi_DataSend_Post];
	
	//post 字典
	NSDictionary *getDict=[dataDic objectForKey:WebApi_DataSend_Get];
	
	NSString *newpage = [getDict lzNSStringForKey:@"count"];
	
	if (newpage && [newpage isEqualToString:@"1"]) {
		
		NSString *oid=[postDict lzNSStringForKey:@"orgid"];

		if(contextArr.count>0){
			
			//
			NSDictionary *dic = contextArr.firstObject;
			
			NSString *pid = [dic lzNSStringForKey:@"pid"];

			NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:pid,@"pid",oid,@"orgid", nil];
			dispatch_async(dispatch_get_main_queue(), ^{
				__block PostParse * service = self;
				EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_NewList_page, dict);
			});
			
		}else{
			NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:oid,@"orgid", nil];
			dispatch_async(dispatch_get_main_queue(), ^{
				__block PostParse * service = self;
				EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_NewList_page, dict);
			});
		}
		
		//发送最新的动态id就好了
		return;
	}
    //开始
    NSString *startindex=[postDict objectForKey:@"startindex"];
    //长度
   // NSString *postcount=[postDict objectForKey:@"postcount"];
    //列表类型
    NSString *type=[postDict objectForKey:@"type"];

    //协作id
    NSString *appdataid = [postDict lzNSStringForKey:@"appdataid"];
    
    BOOL isShowBlueFileName;// 是否展示文件名称
    if (type && [type isEqualToString:@"Resources"]) {
        //是文件评论列表
        isShowBlueFileName=NO;
    }else{
        isShowBlueFileName=YES;
    }
    
    BOOL isLocation = NO; //是否做本地存储
    NSString *oid=[postDict lzNSStringForKey:@"orgid"];
    
    if(type && [type isEqualToString:@"Cooperation"]){
        isLocation = YES;
    }
    
    
    NSMutableArray *pArr=[NSMutableArray array];
    
    for (NSDictionary *subDict in contextArr) {
        
        PostModel *pModel=[[PostModel alloc]init];
        [pModel serializationWithDictionary:subDict];
        pModel.isShowFileName=isShowBlueFileName;
        
        if (isLocation) {
            // 清除之前数据
            [[PostDAL shareInstance]delePostID:pModel.pid];
        }
        
        // 标签
        if (pModel.tagdata) {
            NSMutableArray *tagArr=[NSMutableArray array];
            for (NSDictionary *tagDict in pModel.tagdata) {
                
                TagDataModel *tModel=[[TagDataModel alloc]init];
                [tModel serializationWithDictionary:tagDict];
                tModel.dataid=pModel.pid;
                [tagArr addObject:tModel];
            }
            if (isLocation) {
            [[TagDataDAL shareInstance] addDataWithTagDataArray:tagArr];
            }
            pModel.tagdata=tagArr;
            
        }
        
        // 文件
        if (pModel.rosourlist && [pModel.rosourlist count]!=0) {
            NSMutableArray *fileArr=[NSMutableArray array];
            for (NSDictionary *fileDict in pModel.rosourlist) {
                PostFileModel *fModel=[[PostFileModel alloc]init];
                [fModel serializationWithDictionary:fileDict];
                fModel.descripti=[fileDict objectForKey:@"description"];
                fModel.postID=pModel.pid;
                [fileArr addObject:fModel];
                
            }
            [[PostFileDAL shareInstance]addDataWithArray:fileArr];
            pModel.rosourlist=fileArr;
        }
        
        // 回复
        if(pModel.replypostlist&&[pModel.replypostlist count]!=0){
            NSMutableArray *replyArr=[NSMutableArray array];
            for (NSDictionary *rDict in pModel.replypostlist) {
                PostModel *rModel=[[PostModel alloc]init];
                [rModel serializationWithDictionary:rDict];
                [replyArr addObject:rModel];
            }
            if (isLocation) {
            [[PostDAL shareInstance]addDataWithArray:replyArr];
            }
            pModel.replypostlist=replyArr;
        }
        
        if (isLocation) {
            //清空所有点赞
            [[PostPraiseDAL shareInstance]delePostPID:pModel.pid];
        }


        //点赞
        if(pModel.prainseusername&&[pModel.prainseusername count]!=0){
            
            NSMutableArray *zanArr=[NSMutableArray array];
            
            for (NSDictionary *zDict in pModel.prainseusername) {
                PostZanModel *zModel=[[PostZanModel alloc]init];
                [zModel serializationWithDictionary:zDict];
                [zanArr addObject:zModel];
            }
            pModel.prainseusername=zanArr;
            if (isLocation) {
                [[PostPraiseDAL shareInstance]addDataWithArray:zanArr];
            }
        }
        
        if (isLocation) {
            
            pModel.oid=[postDict objectForKey:@"orgid"];

        }
        
        //地理位置
        if (pModel.positiondiction && [pModel.positiondiction count]!=0) {
            pModel.longitude=[NSString stringWithFormat:@"%@",[pModel.positiondiction objectForKey:@"longitude"]];
            pModel.latitude=[NSString stringWithFormat:@"%@",[pModel.positiondiction objectForKey:@"latitude"]];
            pModel.reference=[pModel.positiondiction objectForKey:@"reference"];
            pModel.address=[pModel.positiondiction objectForKey:@"address"];
        }
        [pArr addObject:pModel];
        
    }
    
    
    NSDate *starTime;
    NSDate *lastTime;
    if (pArr.count>0) {
        
        PostModel *firstModel=[pArr firstObject];
        starTime=firstModel.releasedate;
        PostModel *lastModel=[pArr lastObject];
        lastTime=lastModel.releasedate;
    }
    
    
    if(type && [type isEqualToString:@"Cooperation"] ){
        
        if ([startindex isEqualToString:@"0"]) {
            
            //starTime = [AppDateUtil GetCurrentDate];
            [[PostDAL shareInstance]delePostOid:oid];
        }else{
            //组织动态
            [[PostDAL shareInstance]delePostOid:oid ListStarTime:starTime EndTime:lastTime];
        }

        
    }
 
    if (isLocation) {
    [[PostDAL shareInstance]addDataWithArray:pArr];
    }
    
    NSMutableArray *dataArr=[[CooperationExchange shareInstance]getPostListFromOrginDataArr:pArr IsRoot:isLocation];
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setObject:dataArr forKey:@"data"];
    [dict setObject:startindex forKey:@"startindex"];
    [dict setValue:type forKey:@"type"];
    [dict setObject:appdataid forKey:@"appdataid"];
    [dict setObject:[postDict lzNSStringForKey:@"orgid"] forKey:@"oid"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block PostParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_PostParse_List, dict);
    });
}

#pragma mark -动态模板列表
- (void)parsePostTempleList:(NSMutableDictionary*)dataDic{
    
    NSMutableDictionary *dataContext = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *subDict in dataContext.allValues) {
        
        PostTemplateModel *tempModel = [[PostTemplateModel alloc]init];
        [tempModel serializationWithDictionary:subDict];
        tempModel.templateDic = [subDict objectForKey:@"template"];
        [tempArr addObject:tempModel];
    }
    [[PostTemplateDAL shareInstance]addDataWithArray:tempArr];
    
    /* 更新SysApiVersion */
    [[SysApiVersionDAL shareInstance] updateServerVersionToClientVersionWithCode:LogoinWebApi_api_template_gettemplatelist_1_S14];

    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block PostParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_SendFirstLaunchPercentage, nil);
    });
}

#pragma mark -动态类型

- (void)parsePostTypeList:(NSMutableDictionary*)dataDic{
    
    NSMutableDictionary *dataContext = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
      NSMutableArray *tempArr = [NSMutableArray array];
    [[PostCooperationTypeDAL shareInstance] deleAllPostCoopeationType];
    
    for (NSDictionary *subDict in dataContext.allValues) {
        
        PostCooperationTypeModel *tempModel = [[PostCooperationTypeModel alloc]init];
        [tempModel serializationWithDictionary:subDict];
        

        [tempArr addObject:tempModel];

    }
	[[PostCooperationTypeDAL shareInstance] addDataWithArray:tempArr];
    
    /* 更新SysApiVersion */
    [[SysApiVersionDAL shareInstance] updateServerVersionToClientVersionWithCode:LogoinWebApi_api_api_postv_getposttypelist_S15];

    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block PostParse * service = self;
        [LCProgressHUD sharedHideHUDForNotClickHide2].isNotShowStatus2 = YES;
        EVENT_PUBLISH_WITHDATA(service, EventBus_SendFirstLaunchPercentage, @"100");
    });
    
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
