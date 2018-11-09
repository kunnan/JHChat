//
//  RecentParse.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2015-12-24
 Version: 1.0
 Description: 解析最近联系人
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "RecentParse.h"
#import "ImRecentModel.h"
#import "ImRecentDAL.h"
#import "NSString+IsNullOrEmpty.h"
#import "UserModel.h"
#import "UserDAL.h"
#import "ImGroupDAL.h"
#import "ImGroupModel.h"
#import "ImGroupUserDAL.h"
#import "ImGroupUserModel.h"
#import "ImChatLogDAL.h"
#import "ImChatLogModel.h"
#import "NSDictionary+DicSerial.h"
#import "NSArray+ArraySerial.h"
#import "ImGroupRobotWeatherDAL.h"

@interface RecentParse()<EventSyncPublisher>

@end

@implementation RecentParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(RecentParse *)shareInstance{
    static RecentParse *instance = nil;
    if (instance == nil) {
        instance = [[RecentParse alloc] init];
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
    if([route isEqualToString:WebApi_Recent_GetRecentData]){
        [self parseGetRecentData:dataDic];
    }
    else if( [route isEqualToString:WebApi_Recent_DeleteRecent] ){
        [self parseDeleteRecent:dataDic];
    }
    else if([route isEqualToString:WebApi_Recent_SetRecentStick]) {
        [self parseSetRecentStick:dataDic];
    }
    else if ([route isEqualToString:WebApi_Recent_SetRecentDisturb]) {
        [self parseSetRecentOneDisturb:dataDic];
    }
    /* 消息页签搜索页面 */
    else if([route isEqualToString:WebApi_ImFilterUser_SearchAll]) {
        [self parseImFilterUserSearchAll:dataDic];
    }
}

/**
 *  解析最近联系人数据
 */
-(void)parseGetRecentData:(NSMutableDictionary *)dataAllDic{
    NSMutableArray *dataArray  = [dataAllDic lzNSMutableArrayForKey:WebApi_DataContext];
    
    NSMutableArray *contactArray = [[ImRecentDAL shareInstance] getContactIDsArray]; //客户端显示的联系人id
    
    NSMutableArray *allImRecentArr = [[NSMutableArray alloc] init];
    
    NSMutableArray *allRelateUserArr = [[NSMutableArray alloc] init];
//    NSMutableArray *allRelateImGroupArr = [[NSMutableArray alloc] init];
//    NSMutableArray *allRelateImGroupUserArr = [[NSMutableArray alloc] init];
    for(int i=0;i<dataArray.count;i++){
        NSDictionary *dataDic = [dataArray objectAtIndex:i];
        NSString *irid = [dataDic objectForKey:@"irid"];
        NSString *contactid = [dataDic objectForKey:@"contactid"];
        NSString *contactname = [dataDic objectForKey:@"contactname"];
        NSInteger contacttype = [LZFormat Safe2Int32:[dataDic objectForKey:@"contacttype"]];
        NSInteger relatetype = [LZFormat Safe2Int32:[dataDic objectForKey:@"relatetype"]];
        NSString *face = [dataDic objectForKey:@"face"];
        NSDate *lastdate = [LZFormat String2Date:[dataDic objectForKey:@"lastdate"]];
        NSString *lastmsg = [dataDic lzNSStringForKey:@"lastmsg"];
        NSString *lastmsguser = [dataDic lzNSStringForKey:@"lastmsguser"];
        NSString *lastmsgusername = [dataDic lzNSStringForKey:@"lastmsgusername"];
        NSInteger isexistsgroup = [LZFormat Safe2Int32:[dataDic objectForKey:@"isexistsgroup"]];
        NSString *lastmsgid = [dataDic lzNSStringForKey:@"lastmsgid"];
        NSInteger parsetype = [LZFormat Safe2Int32:[dataDic objectForKey:@"parsetype"]];
        NSString *bkid = [dataDic lzNSStringForKey:@"bkid"];
        NSString *stick = @"0";
        id data = [dataDic objectForKey:@"stick"];
        if([data isKindOfClass:[NSNumber class]] || [data isKindOfClass:[NSString class]]) {
            stick = [NSString stringWithFormat:@"%@",data];
        }
        NSString *isonedisturb = @"0";
        id isonedisturbData = [dataDic objectForKey:@"disturb"];
        if([isonedisturbData isKindOfClass:[NSNumber class]] || [isonedisturbData isKindOfClass:[NSString class]]) {
            isonedisturb = [NSString stringWithFormat:@"%@",isonedisturbData];
        }
        
        if(![[dataDic allKeys] containsObject:@"isexistsgroup"]){
            isexistsgroup = 1;
        }

        ImRecentModel *imRecentModel=[[ImRecentDAL shareInstance] getRecentModelWithContactid:contactid];
        NSString *oldContactName = @"";
        if(imRecentModel == nil){
            imRecentModel = [[ImRecentModel alloc] init];
        } else {
            oldContactName = imRecentModel.contactname;
        }
        imRecentModel.irid = irid;
        imRecentModel.contactid = contactid;
        imRecentModel.contactname = contactname;
        imRecentModel.contacttype = contacttype;
        imRecentModel.relatetype = relatetype;
        imRecentModel.face = face;
        imRecentModel.lastdate = lastdate;
        imRecentModel.lastmsg = lastmsg;
        imRecentModel.lastmsguser = lastmsguser;
        imRecentModel.badge = 0;
        imRecentModel.isdel = 0;
        imRecentModel.isexistsgroup = isexistsgroup;
        imRecentModel.lastmsgid = lastmsgid;
        imRecentModel.parsetype = parsetype;
        imRecentModel.bkid = bkid;
        imRecentModel.stick = stick;
        imRecentModel.isonedisturb = isonedisturb;
        
        /* 获取发送者的用户名，有可能不对(如，用户更改过名称。所以待数据获取完之后需要更新此字段) */
        UserModel *userModel = [[UserDAL shareInstance] getUserModelForNameAndFace:lastmsguser];
        if(userModel!=nil){
            imRecentModel.lastmsgusername = userModel.username;
        } else {
            if ([NSString isNullOrEmpty:lastmsgusername]) {
                ImGroupRobotWeatherModel *groupWeatherModel = [[ImGroupRobotWeatherDAL shareInstance] getimGroupRobotWeatherModelWithRwid:lastmsguser];
                imRecentModel.lastmsgusername = groupWeatherModel.name;
            } else {
                imRecentModel.lastmsgusername = lastmsgusername;
            }
        }
        
        /* 对于被退出的群，使用本地的名称 */
        if(![NSString isNullOrEmpty:oldContactName] && isexistsgroup==0){
            imRecentModel.contactname = oldContactName;
        }
        
        if([NSString isNullOrEmpty:contactid]){
            continue;
        }
        
        if([NSString isNullOrEmpty:imRecentModel.irid]){
            imRecentModel.irid = [LZUtils CreateGUID];
        }
        
//        ImRecentModel *oriImRecentModel = [[ImRecentDAL shareInstance] getRecentModelWithContactid:contactid];
//        if(oriImRecentModel!=nil){
//            /* 先删除旧数据 */
//            [[ImRecentDAL shareInstance] deleteImRecentModelWithContactid:contactid];
//            
//            imRecentModel.badge = oriImRecentModel.badge;
//            imRecentModel.issettop = oriImRecentModel.issettop;
//            imRecentModel.isremindme = oriImRecentModel.isremindme;
//        }
        
        [allImRecentArr addObject:imRecentModel];
        [contactArray removeObject:contactid];
        
        /* 记录关联数据 */
        if( [dataDic objectForKey:@"relatedata"] != [NSNull null] ){
            if(imRecentModel.contacttype == Chat_ContactType_Main_One){
                id relatedata = [dataDic objectForKey:@"relatedata"];
                if([relatedata isKindOfClass:[NSMutableDictionary class]]){
                    NSMutableDictionary *userDic = (NSMutableDictionary *)relatedata;
                    UserModel *userModel=[[UserDAL shareInstance] getUserDataWithUid:[userDic objectForKey:@"uid"]];
                    if(userModel == nil){
                        userModel=[[UserModel alloc]init];
                    }
                    [userModel serializationWithDictionary:userDic];
                    
                    [allRelateUserArr addObject:userModel];
                }
            }
            else if( imRecentModel.contacttype == Chat_ContactType_Main_ChatGroup
                    || imRecentModel.contacttype == Chat_ContactType_Main_CoGroup){
                
                NSMutableDictionary *groupDic = [dataDic lzNSMutableDictionaryForKey:@"relatedata"];
                ImGroupModel *imGroupModel = [[ImGroupModel alloc] init];
                [imGroupModel serializationWithDictionary:groupDic];
                
                NSDictionary *groupresource = [groupDic lzNSDictonaryForKey:@"groupresource"];
                NSArray *imgrouprobots = [groupDic lzNSArrayForKey:@"imgrouprobots"];
                if (groupresource != nil && groupresource.count > 0) {
                    imGroupModel.groupresource = [groupresource dicSerial];
                }
                if (imgrouprobots != nil && imgrouprobots.count > 0) {
                    imGroupModel.imgrouprobots = [imgrouprobots arraySerial];
                }
                if(imGroupModel.imtype==Chat_ContactType_Main_ChatGroup){
                    imGroupModel.isshowinlist = imGroupModel.isshow;
                } else {
                    imGroupModel.isshowinlist = 0;
                }
                imGroupModel.isnottemp = 1;
                
                NSMutableArray *allImGroupUserArr=[NSMutableArray array];
                
                /* 解析群组人员信息 */
                NSArray *groupusers = [groupDic lzNSArrayForKey:@"groupuser"];
                for(int j=0;j<groupusers.count;j++){
                    NSDictionary *dataUserDic = [groupusers objectAtIndex:j];
                    
                    ImGroupUserModel *imGroupUserName= [[ImGroupUserModel alloc] init];
                    [imGroupUserName serializationWithDictionary:dataUserDic];
                    
                    [allImGroupUserArr addObject:imGroupUserName];
                }
                
                /* 删除此群组，避免人员出错 */
                [[ImGroupDAL shareInstance] deleteGroupWithIgid:imGroupModel.igid isDeleteImRecent:NO];
                [[ImGroupDAL shareInstance] addImGroupModel:imGroupModel];
                [[ImGroupUserDAL shareInstance] addDataWithImGroupUserArray:allImGroupUserArr];
            }
        }
    }
    
    [[ImRecentDAL shareInstance] addDataWithImRecentArray:allImRecentArr];
    /* 删除服务器端已经删除了的信息 */
//    [[ImRecentDAL shareInstance] updateIsDelContactid:contactArray];
    
    /* 保存关联数据 */
    [[UserDAL shareInstance] addDataWithUserArray:allRelateUserArr];
    
    self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
    /* 获取最近联系人后，扔需要获取所有的群组信息，所以此处不需要保持群信息(获取完群信息后会删除本地所有数据) */
//    [[ImGroupDAL shareInstance] addDataWithImGroupArray:allRelateImGroupArr];
//    [[ImGroupUserDAL shareInstance] addDataWithImGroupUserArray:allRelateImGroupUserArr];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        __block RecentParse * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_SendFirstLaunchPercentage, nil);
    });
}

/**
 *  解析删除最近联系人
 */
-(void)parseDeleteRecent:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *getData  = [dataDic objectForKey:WebApi_DataSend_Get];
    NSNumber *returnData  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSInteger result = returnData.integerValue;
    
    /* 数据删除成功 */
    if(result==1){        
        [[ImRecentDAL shareInstance] updateIsDelContactid:[[NSMutableArray alloc] initWithObjects:[getData objectForKey:@"recentid"], nil]];
        
        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
    }
}

/**
 解析会话置顶的 API
 */
-(void)parseSetRecentStick:(NSMutableDictionary *)dataDic {
    NSMutableDictionary *getData = [dataDic objectForKey:WebApi_DataSend_Get];
    NSNumber *returnData  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    NSString *returnStr = [returnData stringValue];
    
    NSString *recentid = [getData lzNSStringForKey:@"recentid"];
    /* 聊天会话置顶成功 */
    __block RecentParse * service = self;
    
    /* 判断该聊天是否在最近联系人列表，不在的话就先添加到列表 */
    BOOL isExist = [[ImRecentDAL shareInstance] checkIsShowRecentWithContactid:recentid];
    if (!isExist) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SendMessageAndDeleteMsg" object:nil userInfo:@{@"dialogid":recentid}];
    }
    
    /* 更新置顶状态 */
    [[ImRecentDAL shareInstance] updateSetStick:recentid state:returnStr];
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        EVENT_PUBLISH_WITHDATA(service, EventBus_WebApi_SetRecentStick, nil);
    });
    self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
}

/**
 解析消息页签个人免打扰的 API
 */
-(void)parseSetRecentOneDisturb:(NSMutableDictionary *)dataDic {
    NSMutableDictionary *getData = [dataDic objectForKey:WebApi_DataSend_Get];
    NSNumber *returnData  = [dataDic lzNSNumberForKey:WebApi_DataContext];
    BOOL returnBool = returnData.boolValue;
    if (returnBool) {
        NSString *recentid = [getData lzNSStringForKey:@"recentid"];
        NSString *state = [getData lzNSStringForKey:@"state"];
        /* 聊天会话置顶成功 */
        __block RecentParse * service = self;
        
        /* 更新置顶状态 */
        [[ImRecentDAL shareInstance] updateSetIsOneDisturb:recentid state:state];
        /* 在主线程中发送通知 */
        dispatch_async(dispatch_get_main_queue(), ^{
            EVENT_PUBLISH_WITHDATA(service, EventBus_WebApi_SetRecentOneDisturb, nil);
        });
        self.appDelegate.lzGlobalVariable.isNeedRefreshMessageRootVC = YES;
    }
}

/**
 解析消息页签搜索

 @param dataDic 
 */
- (void)parseImFilterUserSearchAll:(NSMutableDictionary *)dataDic {
    NSMutableDictionary *dataArray = [dataDic objectForKey:WebApi_DataContext];
    
    __block RecentParse * service = self;
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        EVENT_PUBLISH_WITHDATA(service, EventBus_ImFilterUser_SearchAll, dataArray);
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
