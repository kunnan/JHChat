//
//  CooperationWorkGroupParse.m
//  LeadingCloud
//
//  Created by wang on 16/2/15.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CooperationWorkGroupParse.h"
#import "CoGroupModel.h"
#import "CoGroupDAL.h"
#import "CoMemberModel.h"
#import "CoMemberDAL.h"
#import "CooperationWorkGroupModel.h"
#import "TagDataDAL.h"
// 文件
#import "ResFolderModel.h"
#import "ResModel.h"
#import "ResDAL.h"
#import "ResFolderDAL.h"
#import "CooperationExchange.h"
#import "CoManageDAL.h"

#import "CooAppModel.h"
#import "LZUtils.h"
#import "CoAppDAL.h"
#import "CooLayoutModel.h"
#import "CoLayoutDAL.h"
#import "CoRoleDAL.h"

@implementation CooperationWorkGroupParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CooperationWorkGroupParse *)shareInstance{
    static CooperationWorkGroupParse *instance = nil;
    if (instance == nil) {
        instance = [[CooperationWorkGroupParse alloc] init];
    }
    return instance;
}

-(void)parse:(NSMutableDictionary *)dataDic{
    
    NSString *route = [dataDic lzNSStringForKey:WebApi_Route];
    
    if ([route isEqualToString:WebApi_CloudCooperationWorkGroupMyJoinList]) {
        //获得我加入工作组列表
        [self parseWorkGroupList:dataDic withWebApi:WebApi_CloudCooperationWorkGroupMyJoinList];
    }
    else if ([route isEqualToString:WebApi_CloudCooperationWorkGroupMyCreatList]){
        //获得我创建的工作组列表
        [self parseWorkGroupList:dataDic withWebApi:WebApi_CloudCooperationWorkGroupMyCreatList];
    }
    else if ([route isEqualToString:WebApi_CloudCooperationWorkGroupMyMangerList]){
        //获得我管理的工作组列表
        [self parseWorkGroupList:dataDic withWebApi:WebApi_CloudCooperationWorkGroupMyMangerList];
    }
    else if ([route isEqualToString:WebApi_CloudCooperationWorkGroupCloseList]){
        //获得我关闭的工作组列表
        [self parseWorkGroupList:dataDic withWebApi:WebApi_CloudCooperationWorkGroupCloseList];
    }
	// 获取我加入的组织类工作圈集合
	else if ([route isEqualToString:WebApi_CloudCooperationWorkGroupGetOrglist]){
		
		NSDictionary *param=[dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
		NSString *oid=[param objectForKey:@"oid"];
		
		
		NSMutableArray *groupListArr=[NSMutableArray array];
		NSMutableArray *contextArr  = [dataDic lzNSMutableArrayForKey:WebApi_DataContext];
		
		for (NSDictionary *dict in contextArr) {
			CoGroupModel *listObject=[[CoGroupModel alloc]init];
			listObject.coid=oid;
			[listObject serializationWithDictionary:dict];
			
			listObject.resourceid = [dict lzNSStringForKey:@"rpid"];
			
			[groupListArr addObject:listObject];
		}
		
		[[CoGroupDAL shareInstance]deleteOrgGroupOid:oid];
		
		NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:groupListArr,@"data", oid,@"oid",nil];
		
		[[CoGroupDAL shareInstance]addDataWithArray:groupListArr];
		
		/* 在主线程中发送通知 */
		dispatch_async(dispatch_get_main_queue(), ^{
			__block CooperationWorkGroupParse * service = self;
			EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroupParse_OrgList, sendDic);
		});


	}
	
	else if ([route isEqualToString:WebApi_CloudCooperationWorkGroupPostList]){
		
		NSArray *arr = [dataDic lzNSArrayForKey:WebApi_DataContext];
		
		NSMutableArray *data = [NSMutableArray array];
		for (NSDictionary *dic in arr) {
			
			CoGroupModel *gModel = [[CoGroupModel alloc]init];
			
			[gModel serializationWithDictionary:dic];
			[data addObject:gModel];
			
		}
		NSDictionary *getDic = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
		
		NSString *orgid = [getDic lzNSStringForKey:@"oid"];
		NSString *lastkey = [getDic lzNSStringForKey:@"lastkey"];
		
		
		NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:data,@"data",orgid,@"orgid",lastkey,@"lastkey", nil];
		
		/* 在主线程中发送通知 */
		dispatch_async(dispatch_get_main_queue(), ^{
			__block CooperationWorkGroupParse * service = self;
			EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroupParse_PostgroupList, sendDic);
		});

	}
    else if ([route isEqualToString:WebApi_CloudCooperationUpGroupimg]){
        // 上传工作组logo
        NSDictionary *dict =[dataDic lzNSDictonaryForKey:WebApi_DataContext];
        
        NSString *fileId = [dict lzNSStringForKey:@"fileid"];
        
        NSDictionary *getDict = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
        
        NSString *gid = [getDict lzNSStringForKey:@"gid"];
        
        NSDictionary *sendDict = [NSDictionary dictionaryWithObjectsAndKeys:fileId,@"fileid",gid,@"gid", nil];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationWorkGroupParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroupParse_Set_Logo_Image, sendDict);
        });
    }
    else if ([route isEqualToString:WebApi_CloudCooperationUpGroupimgLogo]){
        // 更改工作组logo
        NSDictionary *dict =[dataDic lzNSDictonaryForKey:WebApi_DataContext];
        
        NSString *fileId = [dict lzNSStringForKey:@"fileid"];
        
        NSDictionary *getDict = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
        
        NSString *gid = [getDict lzNSStringForKey:@"gid"];
        
        NSDictionary *sendDict = [NSDictionary dictionaryWithObjectsAndKeys:fileId,@"fileid",gid,@"gid", nil];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationWorkGroupParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroupParse_Set_Logo_Image, sendDict);
        });
    }
    
    else if([route isEqualToString:WebApi_CloudCooperationCreatWorkGroupForMobile]){
        
        //创建工作组
        NSDictionary *dict= [dataDic lzNSDictonaryForKey:WebApi_DataContext];
        CoGroupModel *listObject=[[CoGroupModel alloc]init];
        
        NSDictionary *postDict=[dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
        
        NSString *oid=[postDict objectForKey:@"oid"];
        listObject.coid=oid;
        listObject.cid = [dict objectForKey:@"cid"];
        listObject.gid=[dict objectForKey:@"gid"];
        listObject.gcode=[dict objectForKey:@"gcode"];
        listObject.name=[dict objectForKey:@"name"];
        listObject.oid=oid;
        listObject.currentusertype=4;
        listObject.des = [postDict objectForKey:@"des"];
        [[CoGroupDAL shareInstance]addNewGroupModel:listObject];
        
        
        
        CoManageModel *mItem = [[CoManageModel alloc]init];
        mItem.cid=listObject.cid;
        mItem.oid=oid;
        mItem.type=@"group";
        [[CoManageDAL shareInstance]addDataWithArray:[NSMutableArray arrayWithObject:mItem]];

        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationWorkGroupParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroupParse_Create, listObject);
        });
            
        NSLog(@"dataDic:%@",dataDic);
    }else if([route isEqualToString:WebApi_CloudCooperationWorkGroupDetial]){
        //工作组详情
        
        NSDictionary *dict= [dataDic lzNSDictonaryForKey:WebApi_DataContext];
        CooperationWorkGroupItem *item=[[CooperationExchange shareInstance]getWorkItemFronNetWorkData:dict];
        // 角色
        NSArray *currrolekey = [dict objectForKey:@"currrolekey"];
        item.curRolekeyArr = currrolekey;
        [[CoRoleDAL shareInstance]deleteCoRoleCid:item.groupID];
        [[CoRoleDAL shareInstance]addDataWithArray:currrolekey Cid:item.groupID];
        // 控制基本信息的显隐性
        NSMutableDictionary *layoutSetting = [dict objectForKey:@"layoutsetting"];
         CooLayoutModel *layoutModel = [[CooLayoutModel alloc] init];
        layoutModel.layout = layoutSetting;
        layoutModel.cid = [dict lzNSStringForKey:@"cid"];
        // 插入到数据库
        [[CoLayoutDAL shareInstance] addLayoutInfo:layoutModel];
        
        item.layout = layoutModel;
        
        // 已添加的工具
        NSDictionary *appTool = [dict objectForKey:@"iosapp"];
         NSMutableArray *appArray = [[NSMutableArray alloc] init];
        //    排序的refs
        NSArray *sortArr  = [appTool lzNSArrayForKey:@"refs"];
        for (int i = 0; i < sortArr.count; i++) {
            
            NSDictionary *appSortDic = [sortArr objectAtIndex:i];
            NSString *appid = [appSortDic lzNSStringForKey:@"appid"];

            NSString *purchase = [appSortDic lzNSStringForKey:@"purchase"];
            // 获取app
            NSDictionary *apps = [appTool lzNSDictonaryForKey:@"apps"];
            NSDictionary *appDic = [apps lzNSDictonaryForKey:appid];
            CooAppModel *appModel = [[CooAppModel alloc] init];
            appModel.purchase = [purchase integerValue];

            [appModel serializationWithDictionary:appDic];
            
            appModel.cid = item.groupID;
            appModel.name =[appSortDic lzNSStringForKey:@"name"];
            // 排序用
            appModel.index = i;
            // 数据库主键
            appModel.cooAppid = [NSString stringWithFormat:@"%@%@",appModel.cid,appModel.appid];
            // 通过解析拿到的cid取出数据，如果没有取到的话就插入否则就不插入
//            NSMutableArray *appsArr = [NSMutableArray arrayWithArray:[[CoAppDAL shareInstance] getUserAllApp:item.groupID]];
//            
//            for (int i = 0; i < [appsArr count]; i++) {
//                // 获取数据库中原来的数据 如果存在的话就 删除 然后在插入 保持数据同步
//                [[CoAppDAL shareInstance] deleteAppDataWithCid:item.groupID];
//            }
//            
          //  [appArray addObject:appModel];
            
            
            NSArray *appRolesArr = [ appSortDic lzNSArrayForKey:@"roles"];
//            // 空的都可以看到
//            if ([appRolesArr count] == 0) {
//                appModel.isShowApp = 1;
//            }
            if (appRolesArr && [appRolesArr count]!=0) {
                
                for (NSString *roleID  in appRolesArr) {
                    
                    for (NSString *curRole in currrolekey) {
                        
                        if ([roleID isEqualToString:curRole]) {
                            appModel.isShowApp = 1;
                            
                        }
                    }
                }
                
            }else{
                appModel.isShowApp = 1;
            }
            
                [appArray addObject:appModel];
        }
        [[CoAppDAL shareInstance]deleteAppDataWithCid:item.groupID];
        // 插入到数据库
        [[CoAppDAL shareInstance] addCooDataWithAppArray:appArray];
        NSMutableDictionary *appAndLayoutDic = [[NSMutableDictionary alloc] init];
        
        NSMutableArray *showArr = [NSMutableArray array];
        for (CooAppModel *appModel in appArray) {
            if (appModel.isShowApp==1) {
                [showArr addObject:appModel];
            }
        }
        item.toolArray = showArr;
        [appAndLayoutDic setObject:showArr forKey:@"appArray"];
        [appAndLayoutDic setObject:layoutModel forKey:@"layoutModel"];
        //cooperationTags
		
		NSArray *cooperationtags=[dict objectForKey:@"cooperationTags"];
		NSMutableArray *tags=[NSMutableArray array];
		for (NSDictionary *tDict in cooperationtags) {
			TagDataModel *tModel=[[TagDataModel alloc]init];
			[tModel serializationWithDictionary:tDict];
			[tags addObject:tModel];
		}
		item.tagArray = tags;
		
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationWorkGroupParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroupParse_Detial, item);
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroupParse_Detial_JsonData, dict);
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_GroupPase_DetialTool, appAndLayoutDic);
        });
    }
    
    //工作组基本信息
    else if ([route isEqualToString:WebApi_CloudCooperationWorkGroupBaseInfo]){
        
        NSDictionary *dataContext=[dataDic objectForKey:WebApi_DataContext];
        
        CooperationWorkGroupItem *item=[[CooperationExchange shareInstance]getWorkItemFronNetWorkData:dataContext];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationWorkGroupParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroupParse_BaseInfo, item);
        });

    }
    
    else if ([route isEqualToString:WebApi_CloudCooperationWorkGroupSetName]){
        //修改工作组名称
        NSDictionary *getParam=[dataDic objectForKey:WebApi_DataSend_Get];
        NSString *gid=[getParam objectForKey:@"gid"];
        NSString *name=[dataDic objectForKey:WebApi_DataSend_Post];
        
        [[CoGroupDAL shareInstance]updateGroupId:gid withzGroupName:name];
		
		NSDictionary *sendic = [NSDictionary dictionaryWithObjectsAndKeys:gid,@"cid",name,@"name", nil];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationWorkGroupParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Not_Coo_WorkGroup_SetName, sendic);
        });
    }
    else if ([route isEqualToString:WebApi_CloudCooperationWorkGroupSetDes]){
        //修改工作组描述
        NSDictionary *getParam=[dataDic objectForKey:WebApi_DataSend_Get];
        NSString *gid=[getParam objectForKey:@"gid"];
        NSString *des=[dataDic objectForKey:WebApi_DataSend_Post];
        
        [[CoGroupDAL shareInstance]updateGroupId:gid withzGroupDes:des];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationWorkGroupParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroupParse_Modify, nil);
        });
    }
    else if ([route isEqualToString:WebApi_CloudCooperationWorkGroupSetApplyroot]){
        //设置申请加入权限
        
        NSDictionary *getParam=[dataDic objectForKey:WebApi_DataSend_Get];
        NSString *gid=[getParam objectForKey:@"gid"];
        NSString *needing=[dataDic objectForKey:WebApi_DataSend_Post];
        
        [[CoGroupDAL shareInstance]updateGroupId:gid withzGroupApplyroot:[NSNumber numberWithInt:[needing intValue]]];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationWorkGroupParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroupParse_Set_ApplyRoot, gid);
        });
    }
    
    else if([route isEqualToString:WebApi_CloudCooperationWorkGroupDismiss]){
        //解散
        __block CooperationWorkGroupParse * service = self;

//        NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
        NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
        NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
        if ([contextDict isEqualToString:@"1"]){
            NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
            NSString *gid=[param objectForKey:@"groupId"];
            [[CoGroupDAL shareInstance]deleteGroupid:gid];
            
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroupParse_Set, WebApi_CloudCooperationWorkGroupDismiss);
            });
        }
        else{
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                EVENT_PUBLISH_WITHDATA(service, EventBus_WebApi_SendFail, (@{@"Code":@"0",@"Message":@"工作圈解散失败"}));
            });

        }
    }else if([route isEqualToString:WebApi_CloudCooperationWorkGroupTurnOff]){
        //关闭
//        NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
        NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
        NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
        __block CooperationWorkGroupParse * service = self;

        if ([contextDict isEqualToString:@"1"]){
            NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
            NSString *gid=[param objectForKey:@"groupId"];
            
            [[CoGroupDAL shareInstance]updateGroupId:gid withGroupState:0];
            
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroupParse_Set, WebApi_CloudCooperationWorkGroupTurnOff);
            });
        }
        else{
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                EVENT_PUBLISH_WITHDATA(service, EventBus_WebApi_SendFail, (@{@"Code":@"0",@"Message":@"关闭工作圈失败"}));
            });

        }
    }else if([route isEqualToString:WebApi_CloudCooperationWorkGroupTurnOn]){
        //开启
        __block CooperationWorkGroupParse * service = self;
//        NSString *contextDict  = [NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
        NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
        NSString *contextDict = [NSString stringWithFormat:@"%@",dataNumber];
        if ([contextDict isEqualToString:@"1"]){
            NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
            NSString *gid=[param objectForKey:@"groupId"];
            
            [[CoGroupDAL shareInstance]updateGroupId:gid withGroupState:1];
            
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroupParse_Set, WebApi_CloudCooperationWorkGroupTurnOn);
            });
        }
        else{
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                EVENT_PUBLISH_WITHDATA(service, EventBus_WebApi_SendFail, (@{@"Code":@"0",@"Message":@"开启工作圈失败"}));
            });

        }
    }

    //添加群组 搜索
    else if ([route isEqualToString:WebApi_CloudCooperationJoinWorkGroup]){
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationWorkGroupParse * service = self;
            NSDictionary *data  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroupParse_Join, data);
        });
    }
    else if ([route isEqualToString:WebApi_CloudCooperationJoinWorkGroupFormGid]){
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationWorkGroupParse * service = self;
            NSDictionary *data  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroupParse_Join_gid, data);
        });
    }
    
    // 申请加入
    else if ([route isEqualToString:WebApi_CloudCooperationApplyJoingWorkGroup]){
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationWorkGroupParse * service = self;
            
            NSNumber *sucess = [dataDic lzNSNumberForKey:WebApi_DataContext];
            if ([sucess integerValue]==1) {
                NSDictionary *postDict = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
                NSString *oid = [postDict lzNSStringForKey:@"oid"];
                EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroupParse_ApplyJoing, oid);
            }else{
                EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroupParse_ApplyJoing, nil);
            }
        });
    }

    //上传logo
    else if ([route isEqualToString:WebApi_CloudCooperationUpGroupLogo]){
        
        NSString *logo=[dataDic objectForKey:WebApi_DataSend_Post];
        
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            __block CooperationWorkGroupParse * service = self;
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroupParse_Logo, logo);
        });
    }
	//托付工作组
	else if ([route isEqualToString:WebApi_CloudCooperationGroupMemberSetCharge]){
		
		NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
		NSString *context = [NSString stringWithFormat:@"%@",dataNumber];
		if (context &&[context isEqualToString:@"1"]) {
			//成功
			NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
			NSString *uid=[param objectForKey:@"uid"];
			NSString *cid=[param objectForKey:@"gid"];
			
			[[CoMemberDAL shareInstance]upDataMemberUtypeCooperationTaskId:cid Uid:uid Utype:CoSuperadministrator];

			/* 在主线程中发送通知 */
			dispatch_async(dispatch_get_main_queue(), ^{
				__block CooperationWorkGroupParse * service = self;
				EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_SetChange, cid);
			});
			
		}else{
			
		}
	}
       else if ([route isEqualToString:WebApi_CloudCooperationGroupMemberSetAdmin]){
        //设置管理员
//        NSString *context=[NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
        NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
        NSString *context = [NSString stringWithFormat:@"%@",dataNumber];
        if (context &&[context isEqualToString:@"1"]) {
            //成功
            NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
            NSString *uid=[param objectForKey:@"uid"];
            NSString *cid=[param objectForKey:@"gid"];

            [[CoMemberDAL shareInstance]upDataMemberUtypeCooperationId:cid Uid:uid Utype:CoAdministrator];

            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                __block CooperationWorkGroupParse * service = self;
                EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_SetAdmins, uid);
            });
            
        }else{
            
        }

    }
    else if ([route isEqualToString:WebApi_CloudCooperationGroupMemberRemoveAdmin]){
        //移除管理员
//        NSString *context=[NSString stringWithFormat:@"%@",[dataDic lzNSStringForKey:WebApi_DataContext]];
        NSNumber *dataNumber  = [dataDic lzNSNumberForKey:WebApi_DataContext];
        NSString *context = [NSString stringWithFormat:@"%@",dataNumber];
        if (context &&[context isEqualToString:@"1"]) {
            //成功
            NSDictionary *param=[dataDic objectForKey:WebApi_DataSend_Get];
            NSString *uid=[param objectForKey:@"uid"];
            NSString *cid=[param objectForKey:@"gid"];
            
            [[CoMemberDAL shareInstance]upDataMemberUtypeCooperationId:cid Uid:uid Utype:2];
            
            /* 在主线程中发送通知 */
            dispatch_async(dispatch_get_main_queue(), ^{
                __block CooperationWorkGroupParse * service = self;
                EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_SetAdmins, uid);
            });
            
        }else{
            
        }
    }
}

#pragma mark 工作组列表
-(void)parseWorkGroupList:(NSMutableDictionary*)dataDic withWebApi:(NSString*)api{
    
    //获得我加入工作组列表
    NSDictionary *param=[dataDic lzNSDictonaryForKey:WebApi_DataSend_Post];
    NSString *oid=[param objectForKey:@"oid"];
    
   // [[CoGroupDAL shareInstance]deleteAllGroupOid:oid];
	NSString *name=[param objectForKey:@"name"];

    NSMutableArray *groupListArr=[NSMutableArray array];
    NSDictionary *datacontext  = [dataDic lzNSDictonaryForKey:WebApi_DataContext];
    
	NSMutableArray *contextArr  = [datacontext lzNSMutableArrayForKey:@"data"];

    NSString *page=[param lzNSStringForKey:@"page"];
    NSInteger subject = 0 ;
	NSArray *uids = [param lzNSArrayForKey:@"uids"];
	NSArray *tagids = [param lzNSArrayForKey:@"ctids"];

	if((name && [name length]>0)||uids.count>0||tagids>0){
		//搜索
		
	} else{
    if ([api isEqualToString:WebApi_CloudCooperationWorkGroupMyMangerList]) {
        //我管理的
        if([page isEqualToString:@"1"]){
            [[CoGroupDAL shareInstance]deleteUpAllMyMangeGroupOid:oid];
            [[CoManageDAL shareInstance]deleteMangeOid:oid type:@"group"];
        }
        subject =2 ;


    }else if ([api isEqualToString:WebApi_CloudCooperationWorkGroupCloseList]){
        //我关闭的
        subject =3 ;
        if([page isEqualToString:@"1"]){
            [[CoGroupDAL shareInstance]deleteAllMyCloseGroupOid:oid];
        }

    }else if ([api isEqualToString:WebApi_CloudCooperationWorkGroupMyJoinList]){
        //我加入的
        subject =0 ;
        if([page isEqualToString:@"1"]){
            [[CoGroupDAL shareInstance]deleteuUpAllMyJoinGroupOid:oid];
            
        }
    }else if ([api isEqualToString:WebApi_CloudCooperationWorkGroupMyCreatList]){
        //我创建的
        subject =1 ;
        if([page isEqualToString:@"1"]){
            [[CoGroupDAL shareInstance]deleteUpAllMyCreatGroupOid:oid];
        }
    }
		
}
    
    for (NSDictionary *dict in contextArr) {
        CoGroupModel *listObject=[[CoGroupModel alloc]init];
        listObject.coid=oid;
        [listObject serializationWithDictionary:dict];
        
        if (subject==0) {
            
            listObject.joinindex =1.0;
        }else if (subject==1){
            listObject.creatindex =1.0;

        }else if (subject==2){
            listObject.maginindex =1.0;
        }else if (subject==3){
            listObject.closeindex =1.0;
        }
        listObject.resourceid = [dict lzNSStringForKey:@"rpid"];
        
        [groupListArr addObject:listObject];
    }
    
    if ([api isEqualToString:WebApi_CloudCooperationWorkGroupMyMangerList]) {
        
        NSMutableArray *mangeArr = [NSMutableArray array];
        for (CoGroupModel *listObject in groupListArr) {
            CoManageModel *mItem = [[CoManageModel alloc]init];
            mItem.cid=listObject.cid;
            mItem.oid=oid;
            mItem.type=@"group";
            [mangeArr addObject:mItem];
        }
        [[CoManageDAL shareInstance]addDataWithArray:mangeArr];

    }
    NSInteger startIndex=[[param objectForKey:@"startIndex"]integerValue];

    [[CoGroupDAL shareInstance]addDataWithArray:groupListArr StartIndex:startIndex];
	
	NSNumber *islastpage = [datacontext lzNSNumberForKey:@"islastpage"];
	
	NSString *str =[NSString stringWithFormat:@"%@",islastpage];
    NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:groupListArr,@"data",page,@"page",str,@"islastpage",name,@"name", nil];
	
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationWorkGroupParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_WorkGroupParse_List, sendDic);
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
