//
//  CooperationToolAppParse.m
//  LeadingCloud
//
//  Created by SY on 16/6/2.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CooperationToolAppParse.h"
#import "CooAppModel.h"
#import "AppDAL.h"
#import "CoAppDAL.h"
#import "CoRoleDAL.h"
@implementation CooperationToolAppParse
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CooperationToolAppParse *)shareInstance{
    static CooperationToolAppParse *instance = nil;
    if (instance == nil) {
        instance = [[CooperationToolAppParse alloc] init];
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
    
    // 获取协作协作已加载的iOS应用（个人）
    if ([route isEqualToString:WebApi_CloudCooperationTool_GetOrgToolInfo]) {
        [self parseOrganizationTool:dataDic];
    }
    //获取协作协作已加载的iOS应用（个人）
    else if ([route isEqualToString:WebApi_CloudCooperationTool_GetPersonToolInfo]) {
        
        [self parseOrganizationTool:dataDic];
    }
    
    // 获取组织和个人购买支持协作的iOS应用
    else if ([route isEqualToString:WebApi_CloudCooperationTool_GetOrgAppList]) {
        [self parseOrganizationAppList:dataDic];
    }
    // 获取个人购买支持协作的iOS应用
    else if ([route isEqualToString:WebApi_CloudCooperstionTool_GetPersonAppList]) {
        [self parseOrganizationAppList:dataDic];
    }
    /* 添加协作区工具（组织和个人） */
    else if ([route isEqualToString:WebApi_CloudCooperationTool_AddCooTool]) {
        [self parseOrganizationAddTool:dataDic];
        
    }
    /* 添加协作区工具（个人）*/
    else if ([route isEqualToString:WebApi_CloudCooperationTool_AddPersonTool]) {
        [self parseOrganizationAddTool:dataDic];
        
    }
    // 移除协作区工具
    else if ( [route isEqualToString:WebApi_CloudCooperationTool_DeleteTool]) {
        
        [self parseDeleteTool:dataDic];
    }
    // 工具排序
    else if ([route isEqualToString:WebApi_CloudCooperationTool_ToolSort]) {
        [self parseToolSort:dataDic];
    }
    // 获取协作区已经应用关系列表
    else if ([route isEqualToString:WebApi_CloudCooperationTool_loadcooperationexportapp]) {
        [self parseloadcooperationexportapp:dataDic];
    }
}

// 获取已添加的工具
-(void)parseOrganizationTool:(NSMutableDictionary*)dataDic {
    
    NSMutableDictionary *contextDic = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableDictionary *dataGet = [dataDic objectForKey:WebApi_DataSend_Get];
    // 协作区类型
    NSString *type = [dataGet objectForKey:@"type"];
    NSString *cid = [dataGet objectForKey:@"cid"];
    NSMutableDictionary *appsDic = [contextDic objectForKey:@"apps"];
    NSMutableArray *appArray = [[NSMutableArray alloc] init];
    NSArray *refsArray = [contextDic objectForKey:@"refs"];
    for (int i = 0; i < [refsArray count]; i++) {
        NSDictionary *dic = [refsArray objectAtIndex:i];
        NSString *appid = [dic objectForKey:@"appid"];
        NSString *purchase = [dic objectForKey:@"purchase"];
        NSArray *appRolesArr = [dic lzNSArrayForKey:@"roles"];
        // 获取app
        NSDictionary *appDic = [appsDic lzNSDictonaryForKey:appid];
        CooAppModel *appModel = [[CooAppModel alloc] init];
        [appModel serializationWithDictionary:appDic];
        
        appModel.name = [dic lzNSStringForKey:@"name"];
        appModel.purchase = [purchase integerValue];
        appModel.type = type;
        // 排序用
        appModel.index = i;
        
        // 数据库主键
        appModel.cooAppid = [NSString stringWithFormat:@"%@%@",cid,appid];
        
        appModel.cid = cid;
        NSMutableArray *apps = nil;
        
        // 通过解析拿到的cid取出数据，如果没有取到的话就插入否则就不插入
        apps = [[CoAppDAL shareInstance] getUserAllApp:cid];
        for (int i = 0; i < [apps count]; i++) {
            // 获取数据库中原来的数据 如果存在的话就 删除 然后在插入
            [[CoAppDAL shareInstance] deleteAppDataWithCid:cid];
        }
     // 工具角色的控制
        NSArray *currentRoles = [[CoRoleDAL shareInstance] getRoleUidFromCid:cid];
        if (appRolesArr && [appRolesArr count]!=0) {
            
            for (NSString *roleID  in appRolesArr) {
                
                for (NSString *curRole in currentRoles) {
                    
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
    
    // 插入到数据库
    [[CoAppDAL shareInstance] addCooDataWithAppArray:appArray];
    

    NSMutableDictionary *toolDic = [[NSMutableDictionary alloc] init];
    [toolDic setObject:appArray forKey:type];

    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationToolAppParse * service = self;
        
        if ([type isEqualToString:@"group"]) {
            /* 工具列表用 */
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_CooTool_GetDidAddTool, toolDic);
          // EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_GroupPase_DetialTool, appArray);
        }
        else if ([type isEqualToString:@"task"]) {
            /* 工具列表用 */
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_CooTool_GetDidAddTool, toolDic);
            /* 临时通知请求api */
            EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskTool_ToolList, appArray);
        }
    });
}

// 获取组织和个人购买支持协作的iOS应用 （不用添加到数据库了）
-(void)parseOrganizationAppList:(NSMutableDictionary* )dataDic {
    
    NSMutableDictionary *contextDic = [dataDic lzNSMutableDictionaryForKey:WebApi_DataContext];
    NSMutableDictionary *dataGet = [dataDic objectForKey:WebApi_DataSend_Get];
    NSMutableArray *allAppModelArray = [[NSMutableArray alloc] init];
    
    for (NSString *appkey in contextDic.allKeys) {
        CooAppModel *appModle = [[CooAppModel alloc] init];
        NSDictionary *appDic = [contextDic lzNSDictonaryForKey:appkey];
        
        [appModle serializationWithDictionary:appDic];
        appModle.type = [dataGet objectForKey:@"type"];
        appModle.cid = [dataGet objectForKey:@"cid"];
        // 数据库主键
        appModle.cooAppid = [NSString stringWithFormat:@"%@%@",appModle.cid,appModle.appid];
        
        [allAppModelArray addObject:appModle];
    }
    
    // 插入到数据库
       // [[CoAppDAL shareInstance] addCooDataWithAppArray:allAppModelArray];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationToolAppParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_TaskTool_AppTool, allAppModelArray);
    });
    
}
// 组织添加应用工具
-(void)parseOrganizationAddTool:(NSMutableDictionary *)dataDic {
    NSMutableDictionary *contextDic = [dataDic objectForKey:WebApi_DataSend_Get];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    CooAppModel *app = [[CooAppModel alloc] init];
    [app serializationWithDictionary:contextDic];
    // 数据库主键
    app.cooAppid = [NSString stringWithFormat:@"%@%@",app.cid,app.appid];
    // 新添加的每个角色都可以看
    app.isShowApp = 1;
    [array addObject:app];
    [[CoAppDAL shareInstance] addCooDataWithAppArray:array];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationToolAppParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_Coo_CooTool_AddAppTool, app);
    });
}

// 删除协作区工具
-(void)parseDeleteTool:(NSMutableDictionary *)dataDic {
    NSMutableDictionary *dataGet = [dataDic objectForKey:WebApi_DataSend_Get];
    NSMutableDictionary *appDic = [[NSMutableDictionary alloc] init];
    [appDic setObject:[dataGet objectForKey:@"cid"] forKey:@"cid"];
    [appDic setObject:[dataGet objectForKey:@"appid"] forKey:@"appid"];
    // 通过cid和appid把本地删除
    [[CoAppDAL shareInstance] deleteAppDataWithCid:[dataGet objectForKey:@"cid"] appid:[dataGet objectForKey:@"appid"]];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationToolAppParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EvenTBus_Coo_CooTool_DeleteTool, appDic);
    });
}
// 工具排序
- (void)parseToolSort:(NSMutableDictionary*)dataDic {
    
    NSDictionary *dataGet = [dataDic lzNSDictonaryForKey:WebApi_DataSend_Get];
    NSString *appid = [dataGet lzNSStringForKey:@"appid"];
    NSString *beforeApp = [dataGet lzNSStringForKey:@"before"];
    NSString *cid = [dataGet lzNSStringForKey:@"cid"];
    // 对数组进行重新排序
    NSMutableArray *sortDidArr = nil;
    sortDidArr =[[CoAppDAL shareInstance] getUserAllApp:cid];
    // 获取要移动的app
    CooAppModel *moveApp = [[CoAppDAL shareInstance] getAppModelWithAppCid:cid appid:appid];
    CooAppModel *beforeAppModel = nil;
    if (![beforeApp isEqualToString:@"0"]) {
        // 获取移动后app的前面的app
        beforeAppModel = [[CoAppDAL shareInstance] getAppModelWithAppCid:cid appid:beforeApp];
        // 获取前面app在数组中的位置
        NSInteger index = 0;
        for (int i = 0; i < sortDidArr.count; i++) {
            CooAppModel *app = [sortDidArr objectAtIndex:i];
            if ([app.appid isEqualToString:beforeAppModel.appid]) {
                index = i;
            }
           
            // 找到数组中的appModel
            if ([app.appid isEqualToString:moveApp.appid]) {
                // 先移除要移动的app
                [sortDidArr removeObject:app];
            }
            
        }
       
        // 从新插入
        [sortDidArr insertObject:moveApp atIndex:index + 1];
        
    }
    // 移到最前面的位置
    else {
        for (int i = 0; i< sortDidArr.count; i++) {
            CooAppModel *app = [sortDidArr objectAtIndex:i];
            // 找到数组中的appModel
            if ([app.appid isEqualToString:moveApp.appid]) {
                // 先移除要移动的app
                [sortDidArr removeObject:app];
            }

        }
        // 数组不知道移除的是它里面的
        [sortDidArr insertObject:moveApp atIndex:0];
    }
    
    // 通过解析拿到的cid取出数据，如果没有取到的话就插入否则就不插入
   NSMutableArray *apps = [[CoAppDAL shareInstance] getUserAllApp:cid];
    
    for (int i = 0; i < [apps count]; i++) {
        // 获取数据库中原来的数据 如果存在的话就 删除 然后在插入
        [[CoAppDAL shareInstance] deleteAppDataWithCid:cid];
    }
    
    
    //   把排过序的从新加到数据库 没有移除干净
    [[CoAppDAL shareInstance] addCooDataWithAppArray:sortDidArr];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block CooperationToolAppParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBud_Coo_CooTool_ToolSort, sortDidArr);
    });
    
}
- (void)parseloadcooperationexportapp:(NSMutableDictionary*)dataDic {
    
    
    
    
    
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
