//
//  TagTempParser.m
//  LeadingCloud
//
//  Created by dfl on 16/6/15.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "TagTempParser.h"
#import "UserContactGroupDAL.h"
#import "TagDataDAL.h"
#import "UserContactDAL.h"

@implementation TagTempParser

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(TagTempParser *)shareInstance{
    static TagTempParser *instance = nil;
    if (instance == nil) {
        instance = [[TagTempParser alloc] init];
    }
    return instance;
}

#pragma mark - 解析临时通知数据

/**
 *  解析临时通知数据
 *
 *  @param dataDic 数据
 */
-(BOOL)parse:(NSMutableDictionary *)dataDic{
    NSString *handlertype = [dataDic objectForKey:@"handlertype"];
    
    BOOL isSendReport = NO;
    
    /* 删除标签 */
    if([handlertype isEqualToString:Handler_User_Tag_RemoveTag]){
        isSendReport = [self parseUserTagRemoveTag:dataDic];
    }
    /* 添加标签 */
    else if([handlertype isEqualToString:Handler_User_Tag_AddTag]){
        isSendReport = [self parseUserTagAddTag:dataDic];
    }
    /* 修改标签名 */
    else if([handlertype isEqualToString:Handler_User_Tag_ReName]){
        isSendReport = [self parseUserTagReName:dataDic];
    }
    else {
        DDLogError(@"----------------收到未处理---临时消息类型通知:%@",dataDic);
    }
    
    return isSendReport;
}

/**
 *  删除标签的通知
 */
-(BOOL)parseUserTagRemoveTag:(NSMutableDictionary *)dataDic{
    
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *tagId=[body lzNSStringForKey:@"tagid"];
    
    //  1.先删除标签
    [[UserContactGroupDAL shareInstance]deleteByUCGId:tagId];
    //  2.删除标签关联的数据
    [[TagDataDAL shareInstance] deleteByDataExtend1Value:tagId];
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        self.appDelegate.lzGlobalVariable.isNeedRefreshContactFriendLabelListViewController2 = YES;
        __block TagTempParser * service = self;
        EVENT_PUBLISH_WITHDATA(service, EventBus_UserTag_RemoveTag, nil);
    });
    
    return YES;
}

/**
 *  添加标签的通知
 */
-(BOOL)parseUserTagAddTag:(NSMutableDictionary *)dataDic{
    
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    NSMutableArray<TagDataModel *> *tmpModels=[[NSMutableArray alloc]init];
    NSMutableArray<UserContactGroupModel *> *ucgModels=[[NSMutableArray alloc]init];
    //          解析返回的数据
    NSString *tagid=[body lzNSStringForKey:@"tagid"];
    NSString *tagvalue=[body lzNSStringForKey:@"tagvalue"];
    NSArray *addfriendlist=[body lzNSArrayForKey:@"addfriendlist"];
    for(int i=0;i<addfriendlist.count;i++){
        NSString *frienduid=[addfriendlist objectAtIndex:i];
        NSString *ucid = [[UserContactDAL shareInstance] getUserContactByUId:frienduid].ucid;
        TagDataModel *tmpModel=[[TagDataModel alloc]init];
        tmpModel.tdid=[LZUtils CreateGUID];
        tmpModel.taid=nil;
        tmpModel.name=nil;
        tmpModel.ttid=@"contactgroup";
        tmpModel.dataid=nil;
        tmpModel.oid=nil;
        tmpModel.uid=nil;//按照正常逻辑，这里应当将用户Id存到这里来，但是服务器返回的是 ctid，所有先不存
        tmpModel.dataextend1=tagid;//将标签id存到这里
        tmpModel.dataextend2=ucid;//将ctid存到这里
        [tmpModels addObject:tmpModel];
    }
    [[TagDataDAL shareInstance ]addDataWithTagDataArray:tmpModels];
    
    UserContactGroupModel *model=[[UserContactGroupModel alloc]init];
    model.ucgId=tagid;
    model.tagValue=tagvalue;
    //              加入数组
    [ucgModels addObject:model];
    [[UserContactGroupDAL shareInstance] addDataWithUserContactGroupArray:ucgModels];

    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        self.appDelegate.lzGlobalVariable.isNeedRefreshContactFriendLabelListViewController2 = YES;
    });
    
    return YES;
}

/**
 *  修改标签名通知
 */
-(BOOL)parseUserTagReName:(NSMutableDictionary *)dataDic{
    NSMutableDictionary *body=[dataDic lzNSMutableDictionaryForKey:@"body"];
    NSString *newtagid=[body lzNSStringForKey:@"newtagid"];
    NSString *tagValue=[body lzNSStringForKey:@"newtagname"];
    NSString *oldtagid=[body lzNSStringForKey:@"oldtagid"];
    
    /* 添加标签分组 */
    UserContactGroupModel *userCGModel=[[UserContactGroupModel alloc]init];
    userCGModel.ucgId=newtagid;
    userCGModel.tagValue=tagValue;
    [[UserContactGroupDAL shareInstance]addUserContactGroupModel:userCGModel];
    [[UserContactGroupDAL shareInstance]deleteByUCGId:oldtagid];
    NSMutableArray *tagArr=[[TagDataDAL shareInstance]getTagDataByTagId:oldtagid];
    for(int i=0;i<tagArr.count;i++){
        TagDataModel *tagmodel=[tagArr objectAtIndex:i];
        tagmodel.dataextend1=newtagid;
        [[TagDataDAL shareInstance]addTagDataModel:tagmodel];
    }
    
    /* 在主线程中发送通知 */
    dispatch_async(dispatch_get_main_queue(), ^{
        self.appDelegate.lzGlobalVariable.isNeedRefreshContactFriendLabelListViewController2 = YES;
    });
    
    return YES;
}

@end
