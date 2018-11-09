//
//  ColleaguelistParse.m
//  LeadingCloud
//
//  Created by wchMac on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "ColleaguelistParse.h"
#import "UserContactModel.h"
#import "UserContactDAL.h"

@implementation ColleaguelistParse

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ColleaguelistParse *)shareInstance{
    static ColleaguelistParse *instance = nil;
    if (instance == nil) {
        instance = [[ColleaguelistParse alloc] init];
    }
    return instance;
}

-(void)parse:(NSMutableDictionary *)dataDic{
    NSString *route = [dataDic objectForKey:WebApi_Route];
    
    if([route isEqualToString:WebApi_Colleaguelist_GetColleagues]){
        [self parseGetColleagues:dataDic];
    }
}

-(void)parseGetColleagues:(NSMutableDictionary *)dataDic{
    NSMutableArray *dataArray  = [dataDic objectForKey:WebApi_Data];
    
    NSMutableArray *allUserContractArr = [[NSMutableArray alloc] init];
    for(int i=0;i<dataArray.count;i++){
        NSDictionary *dataDic = [dataArray objectAtIndex:i];
        NSString *ucid = [dataDic objectForKey:@"ucid"];
        NSString *uid = [dataDic objectForKey:@"uid"];
        
        UserContactModel *userContactModel = [[UserContactModel alloc] init];
        userContactModel.ucmUcid = ucid;
        userContactModel.ucmCtid = uid;
        
        [allUserContractArr addObject:userContactModel];
    }
    
    [[UserContactDAL shareInstance] addDataWithArray:allUserContractArr];
}


@end
