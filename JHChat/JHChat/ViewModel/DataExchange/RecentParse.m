//
//  RecentParse.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "RecentParse.h"
#import "ImRecentModel.h"
#import "ImRecentDAL.h"

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

-(void)parse:(NSMutableDictionary *)dataDic{
    NSString *route = [dataDic objectForKey:WebApi_Route];
    
    if([route isEqualToString:WebApi_Recent_GetRecentData]){
        [self parseGetRecentData:dataDic];
    }
}

-(void)parseGetRecentData:(NSMutableDictionary *)dataDic{
    NSMutableArray *dataArray  = [dataDic objectForKey:WebApi_Data];
    
    NSMutableArray *allImRecentArr = [[NSMutableArray alloc] init];
    for(int i=0;i<dataArray.count;i++){
        NSDictionary *dataDic = [dataArray objectAtIndex:i];
        NSString *irid = [dataDic objectForKey:@"irid"];
        NSString *contactid = [dataDic objectForKey:@"contactid"];
        NSString *contactname = [dataDic objectForKey:@"contactname"];
        NSInteger contacttype = [[dataDic objectForKey:@"contacttype"] integerValue];
        NSDate *lastdate = [LZFormat string2Date:[dataDic objectForKey:@"lastdate"]];
        NSString *lastmsg = [dataDic objectForKey:@"lastmsg"];
        //            NSString *badge = [dataDic objectForKey:@"badge"];
        NSInteger badge = 0;
        
        ImRecentModel *imRecentModel = [[ImRecentModel alloc] init];
        imRecentModel.imRmIrId = irid;
        imRecentModel.imRmContactId = contactid;
        imRecentModel.imRmContactName = contactname;
        imRecentModel.imRmContactType = contacttype;
        imRecentModel.imRmLastDate = lastdate;
        imRecentModel.imRmLastMsg = lastmsg;
        imRecentModel.imRmBadge = badge;
        
        [allImRecentArr addObject:imRecentModel];
    }
    
    [[ImRecentDAL shareInstance] addDataWithArray:allImRecentArr];
}

@end
