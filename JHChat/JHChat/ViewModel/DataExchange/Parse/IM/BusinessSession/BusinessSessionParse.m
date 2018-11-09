//
//  BusinessSessionParse.m
//  LeadingCloud
//
//  Created by gjh on 17/4/5.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "BusinessSessionParse.h"
#import "BusinessSessionRecentDAL.h"
#import "NSObject+JsonSerial.h"
#import "ResModel.h"
#import "ResDAL.h"
#import "ResFolderDAL.h"
#import "ResFolderModel.h"
@implementation BusinessSessionParse
/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(BusinessSessionParse *)shareInstance{
    static BusinessSessionParse *instance = nil;
    if (instance == nil) {
        instance = [[BusinessSessionParse alloc] init];
    }
    return instance;
}

#pragma mark - 解析webapi请求的数据

/**
 *  解析数据
 *
 *  @param dataDic WebApi_Controller；WebApi_Route；WebApi_DataContext
 */
-(void)parse:(NSMutableDictionary *)dataDic{
    NSString *route = [dataDic objectForKey:WebApi_Route];
    
    /* 获取最近联系人 */
    if([route isEqualToString:WebApi_BusinessSession_GetBussinessInfo]){
        [self parseGetBussinessInfo:dataDic];
    }
    else if( [route isEqualToString:WebApi_BusinessSession_QueryModelList] ){
        [self parseQueryModelList:dataDic];
    }
    /* 获取会话记录列表 */
    else if ([route isEqualToString:WebApi_BusinessSession_Recent]){
        [self parseRecent:dataDic];
    }
    /* 获取业务会话工具列表 */
    else if ([route isEqualToString:WebApi_BusinessSession_Tool_Usable]){
        [self parseToolUsable:dataDic];
    }
    /* 获取实例下的会话列表 */
    else if ([route isEqualToString:WebApi_BusinessSession_Recent_Acquirelist]){
        [self parseRecentAcquirelist:dataDic];
    }
    /* 创建业务会话 */
    else if ([route isEqualToString:WebApi_BusinessSession_Recent_Create]){
        [self parseRecentCreate:dataDic];
    }
    /* 根据bsiid获取会话示例数据 */
    else if ([route isEqualToString:WebApi_BusinessSession_Ins_Acquire]){
        [self parseInsAcquire:dataDic];
    }
    /* 业务扩展类型数据 */
    else if ([route isEqualToString:WebApi_BusinessSession_GetExtendTypeByCode]){
        [self parseGetExtendTypeByCode:dataDic];
    }
    /* 表单列表数据 */
    else if ([route isEqualToString:WebApi_BusinessSessionForm_GetBsFormList]){
        [self parseGetBsFormList:dataDic];
    }
    /* 附件列表数据 */
    else if ([route isEqualToString:WebApi_BusinessSession_Attach_AcquireTypeInfo]){
        [self parseAttachAcquireTypeInfo:dataDic];
    }
    /* 获取附件列表中详细数据 */
    else if ([route isEqualToString:WebApi_BusinessSession_Attach_AcquireAll]){
        [self parseAttachAcquireAll:dataDic];
    }
    /* 获取附件相关信息 */
    else if ([route isEqualToString:WebApi_BusinessSession_AttachSet_Acquire]){
        [self parseAttachSetAcquire:dataDic];
    }
    /* 附件上传完以后写入附件信息 */
    else if ([route isEqualToString:WebApi_BusinessSession_AttachSet_Add]){
        [self parseAttachSetAdd:dataDic];
    }
    /* 附件删除 */
    else if ([route isEqualToString:WebApi_BusinessSession_Delete]){
        [self parseDelete:dataDic];
    }
    /* 会话状态权限判断 */
    else if ([route isEqualToString:WebApi_BusinessSession_Ins_ProcessingAuthority]){
        [self parseProcessingAuthority:dataDic];
    }
    /* 根据检索条件获取会话记录列表 */
    else if ([route isEqualToString:WebApi_BusinessSession_Search]){
        [self parseSearch:dataDic];
    }
}

- (void)parseGetBussinessInfo:(NSMutableDictionary *)data {
    
}

- (void)parseQueryModelList:(NSMutableDictionary *)data {
//    NSMutableArray *dataArray  = [data lzNSMutableArrayForKey:WebApi_DataContext];
//    NSMutableArray *modelArr = [NSMutableArray array];
//    for (NSDictionary *dataDict in dataArray) {
//        BusinessSessionRecentModel *model = [[BusinessSessionRecentModel alloc] init];
//        model.applyorgname = [dataDict lzNSStringForKey:@"applyorgname"];
//        model.available = [LZFormat Safe2Int32:[dataDict objectForKey:@"available"]];
//        model.belonguser = [dataDict lzNSStringForKey:@"belonguser"];
//        model.bid = [dataDict lzNSStringForKey:@"bid"];
//        model.bsid = [dataDict lzNSStringForKey:@"bsid"];
//        model.bsiid = [dataDict lzNSStringForKey:@"bsiid"];
//        model.bsitid = [dataDict lzNSStringForKey:@"bsitid"];
//        model.bsitrid = [dataDict lzNSStringForKey:@"bsitrid"];
//        model.bsname = [dataDict lzNSStringForKey:@"bsname"];
//        model.bstype = [LZFormat Safe2Int32:[dataDict objectForKey:@"bstype"]];
//        model.contactface = [dataDict lzNSStringForKey:@"contactface"];
//        model.contactid = [dataDict lzNSStringForKey:@"contactid"];
//        model.contacttype = [LZFormat Safe2Int32:[dataDict objectForKey:@"contacttype"]];
//        model.createtime = [LZFormat String2Date:[dataDict lzNSStringForKey:@"createtime"]];
//        model.lastmsg = [dataDict lzNSStringForKey:@"lastmsg"];
//        model.lasttime = [LZFormat String2Date:[dataDict lzNSStringForKey:@"lasttime"]];
//        model.name = [dataDict lzNSStringForKey:@"name"];
//        model.participationtype = [LZFormat Safe2Int32:[dataDict objectForKey:@"participationtype"]];
//        model.sessionstate = [LZFormat Safe2Int32:[dataDict objectForKey:@"sessionstate"]];
//        model.state = [LZFormat Safe2Int32:[dataDict objectForKey:@"state"]];
//        model.type = [LZFormat Safe2Int32:[dataDict objectForKey:@"type"]];
//        [modelArr addObject:model];
//    }
//    /* 批量添加model数据 */
//    [[BusinessSessionRecentDAL shareInstance] addDataWithBusinessSessionRecentArray:modelArr];
}

/**
 * 获取会话记录列表
 */
- (void)parseRecent:(NSMutableDictionary *)data {
    
    NSMutableArray *businessSessionRecentArr = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataArray  = [data lzNSMutableArrayForKey:WebApi_DataContext];
    for(NSDictionary *dic in dataArray){
        BusinessSessionRecentModel *businessSessionRecentModel = [[BusinessSessionRecentModel alloc] init];
        [businessSessionRecentModel serializationWithDictionary:dic];
        [businessSessionRecentArr addObject:businessSessionRecentModel];
    }
    [[BusinessSessionRecentDAL shareInstance] deleteAllData];
    [[BusinessSessionRecentDAL shareInstance]addDataWithBusinessSessionRecentArray:businessSessionRecentArr];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block BusinessSessionParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_BusinessSession_Recent, nil);
    });
}

/**
 * 获取业务会话工具列表
 */
- (void)parseToolUsable:(NSMutableDictionary *)data {
    NSMutableArray *dataArray  = [data lzNSMutableArrayForKey:WebApi_DataContext];\
    NSMutableArray *showArr = [NSMutableArray array];
    for(int i=0;i<dataArray.count;i++){
        NSDictionary *datadic = [dataArray objectAtIndex:i];
//        NSInteger datacount = [datadic lzNSNumberForKey:@"datacount"].integerValue;
        if(![[datadic lzNSStringForKey:@"name"] isEqualToString:@"指南"]){
            [showArr addObject:datadic];
        }
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block BusinessSessionParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_BusinessSession_Tool_Usable, showArr);
    });
}

/**
 * 获取实例下的会话列表
 */
- (void)parseRecentAcquirelist:(NSMutableDictionary *)data {
    NSMutableArray *businessSessionRecentArr = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataArray  = [data lzNSMutableArrayForKey:WebApi_DataContext];
    for(NSDictionary *dic in dataArray){
        BusinessSessionRecentModel *businessSessionRecentModel = [[BusinessSessionRecentModel alloc] init];
        [businessSessionRecentModel serializationWithDictionary:dic];
        [businessSessionRecentArr addObject:businessSessionRecentModel];
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block BusinessSessionParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_BusinessSession_Recent_Acquirelist, businessSessionRecentArr);
    });
}

/**
 * 创建业务会话
 */
- (void)parseRecentCreate:(NSMutableDictionary *)data {
    NSMutableDictionary *dataDic  = [data lzNSMutableDictionaryForKey:WebApi_DataContext];
    BusinessSessionRecentModel *businessSessionRecentModel = [[BusinessSessionRecentModel alloc] init];
    [businessSessionRecentModel serializationWithDictionary:dataDic];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block BusinessSessionParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_BusinessSession_Recent_Create, businessSessionRecentModel);
    });
}

/**
 * 根据bsiid获取会话示例数据
 */
- (void)parseInsAcquire:(NSMutableDictionary *)data {
    NSMutableDictionary *dataDic  = [data lzNSMutableDictionaryForKey:WebApi_DataContext];
//    NSString *applyuserid = [dataDic lzNSStringForKey:@"applyuserid"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block BusinessSessionParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_BusinessSession_Ins_Acquire, dataDic);
    });
}

/**
 * 业务扩展类型数据
 */
- (void)parseGetExtendTypeByCode:(NSMutableDictionary *)data {
    NSMutableDictionary *dataDic  = [data lzNSMutableDictionaryForKey:WebApi_DataContext];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block BusinessSessionParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_BusinessSession_GetExtendTypeByCode, dataDic);
    });
}

/**
 * 表单列表数据
 */
- (void)parseGetBsFormList:(NSMutableDictionary *)data {
    NSMutableArray *dataArr  = [data lzNSMutableArrayForKey:WebApi_DataContext];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block BusinessSessionParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_BusinessSession_GetBsFormList, dataArr);
    });
}

/**
 * 附件列表数据
 */
- (void)parseAttachAcquireTypeInfo:(NSMutableDictionary *)data {
    NSMutableArray *dataArr  = [data lzNSMutableArrayForKey:WebApi_DataContext];
    
    for ( int i = 0; i < dataArr.count; i++) {
        NSDictionary *dic = [dataArr objectAtIndex:i];
        ResFolderModel *folder = [[ResFolderModel alloc] init];
        folder.classid = [dic lzNSStringForKey:@"bsasid"];
        folder.rpid = [dic lzNSStringForKey:@"bsasid"];
        folder.parentid = @"-";
        [[ResFolderDAL shareInstance] addDataWithResFolderModel:folder];
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block BusinessSessionParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_BusinessSession_AttachSetAcquireList, dataArr);
    });
}

/**
 * 获取附件列表中详细数据
 */
- (void)parseAttachAcquireAll:(NSMutableDictionary *)data {
    NSMutableArray *dataArr  = [data lzNSMutableArrayForKey:WebApi_DataContext];
    NSMutableDictionary *dicdata = [data lzNSMutableDictionaryForKey:WebApi_DataSend_Get];
    
    NSString *classid = [dicdata lzNSStringForKey:@"bsasid"];
    NSString *rpid = nil;
    NSMutableArray *fileArr = [NSMutableArray array];
    
    for (int i  =0 ; i< dataArr.count; i++) {
         NSMutableDictionary *fileDic = [dataArr objectAtIndex:i];
        NSString *name = [fileDic lzNSStringForKey:@"name"];
        NSString *rid = [fileDic lzNSStringForKey:@"rid"];
        ResModel *  resModel = [[ResModel alloc] init];
        [resModel serializationWithDictionary:fileDic];
        resModel.rid = [NSString stringWithFormat:@"%@*",rid];
        resModel.expid = [fileDic lzNSStringForKey:@"fileid"];
        resModel.classid = [fileDic lzNSStringForKey:@"bsasid"];
        resModel.updatedate = [fileDic objectForKey:@"modifydate"];
        resModel.icon = [fileDic lzNSStringForKey:@"fileid"];
        resModel.clienttempid = [fileDic lzNSStringForKey:@"bsaid"];
        resModel.name = [AppUtils getFileNameRangePoint:name];
        resModel.exptype = [AppUtils getExpType:name];
        rpid =resModel.rpid;
        [fileArr addObject:resModel];
        
        
        
    }
    ResFolderModel *folderModel = [[ResFolderModel alloc] init];
    folderModel.classid = classid;
    folderModel.rpid = rpid;
    [[ResFolderDAL shareInstance] deleteFolderWithClassid:classid];
    [[ResFolderDAL shareInstance] addDataWithResFolderModel:folderModel];
    //folderModel.rpid =
    [[ResDAL shareInstance] deleteAllResWithClassid:classid];
    [[ResDAL shareInstance] addDataWithArray:fileArr];
   
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInteger:0] forKey:@"pre"];
    [dic setObject:fileArr forKey:@"data"];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block BusinessSessionParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_BusinessSession_AttachAcquireAll, dataArr);
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_NetDiskOrganization_OrganizationNormalList, dic);
    });
}

/**
 * 获取附件相关信息
 */
- (void)parseAttachSetAcquire:(NSMutableDictionary *)data {
    NSMutableDictionary *dataDic  = [data lzNSMutableDictionaryForKey:WebApi_DataContext];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block BusinessSessionParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_BusinessSession_AttachSetAcquire, dataDic);
    });
}

/**
 * 附件上传完以后写入附件信息
 */
- (void)parseAttachSetAdd:(NSMutableDictionary *)data {
    NSMutableDictionary *dataDic  = [data lzNSMutableDictionaryForKey:WebApi_DataContext];
//    NSMutableDictionary *dataPost = [data lzNSMutableDictionaryForKey:WebApi_DataSend_Post];
    NSMutableDictionary *otherData = [data lzNSMutableDictionaryForKey:WebApi_DataSend_Other];
    
    NSString *isImportNetFIle = [otherData lzNSStringForKey:@"importnetfile"];
    //NSString *clienttempid = [dataPost lzNSStringForKey:@"clienttempid"];
    NSString *name = [dataDic lzNSStringForKey:@"name"];
    NSString *rid = [dataDic lzNSStringForKey:@"rid"];
    ResModel *resM = [[ResModel alloc] init];
    [resM serializationWithDictionary:dataDic];
    // 上传完添加个记号 防止从云盘选择的时候以前的云盘数据给冲掉用的时候记得去掉
    resM.rid = [NSString stringWithFormat:@"%@*",rid];
    resM.icon = [dataDic lzNSStringForKey:@"fileid"];
    resM.expid = [dataDic lzNSStringForKey:@"fileid"];
    resM.uploadstatus = App_NetDisk_File_UploadSuccess;
    resM.clienttempid = [dataDic lzNSStringForKey:@"bsaid"];
    resM.classid = [dataDic lzNSStringForKey:@"bsasid"];
    resM.updatedate = [dataDic objectForKey:@"modifydate"];
    
    resM.name = [AppUtils getFileNameRangePoint:name];
    resM.exptype = [AppUtils getExpType:name];
    resM.downloadstatus = App_NetDisk_File_NoDownload;
    
    [[ResDAL shareInstance] deleteResWithRid:[resM.rid stringByReplacingOccurrencesOfString:@"*" withString:@""]];
   [[ResDAL shareInstance] addDataWithModel:resM];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        self.appDelegate.lzGlobalVariable.isRefreshBusinessSessionAttachmentVC = YES;
        __block BusinessSessionParse * service = self;
        if ([isImportNetFIle boolValue]) {
            EVENT_PUBLISH_WITHDATA(service, EventBus_BusinessSession_AttachSetAdd, resM);
        }
    });
}
/**
 * 附件删除
 */
- (void)parseDelete:(NSMutableDictionary *)data {
    
    NSNumber *dataDic  = [data lzNSNumberForKey:WebApi_DataContext];
    NSDictionary *getData = [data lzNSDictonaryForKey:WebApi_DataSend_Get];
    NSString *rid =[getData lzNSStringForKey:@"rid"];
   // if ([rid containsString:@"*"]) {
        rid = [NSString stringWithFormat:@"%@*",rid];
    //}
    
    [[ResDAL shareInstance] deleteResWithRid:rid];
    NSString *datastr = [NSString stringWithFormat:@"%@",dataDic];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        self.appDelegate.lzGlobalVariable.isRefreshBusinessSessionAttachmentVC = YES;
        __block BusinessSessionParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_App_Res_NetDiskIndex_DelFile, datastr);
    });
}

/**
 * 会话状态权限判断
 */
- (void)parseProcessingAuthority:(NSMutableDictionary *)data {
    NSNumber *dataDic  = [data lzNSNumberForKey:WebApi_DataContext];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block BusinessSessionParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_BusinessSession_ProcessingAuthority, dataDic);
    });
}

/**
 * 根据检索条件获取会话记录列表
 */
- (void)parseSearch:(NSMutableDictionary *)data {
    NSMutableArray *businessSessionRecentArr = [[NSMutableArray alloc] init];
    
    NSMutableArray *dataArray  = [data lzNSMutableArrayForKey:WebApi_DataContext];
    for(NSDictionary *dic in dataArray){
        BusinessSessionRecentModel *businessSessionRecentModel = [[BusinessSessionRecentModel alloc] init];
        [businessSessionRecentModel serializationWithDictionary:dic];
        [businessSessionRecentArr addObject:businessSessionRecentModel];
    }
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block BusinessSessionParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_BusinessSession_Search, businessSessionRecentArr);
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
