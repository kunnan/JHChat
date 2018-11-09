/************************************************************
 Author:  lz-fzj
 Date：   2016-03-01
 Version: 1.0
 Description: 【联系人】-【新的好友】数据表模型
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "UserIntervateModel.h"

#pragma mark - 【联系人】-【新的好友】数据表模型
/**
 *【联系人】-【新的好友】数据表模型
 */
@implementation UserIntervateModel

-(void)setIntervatedate:(NSDate *)intervatedate{
    if([intervatedate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)intervatedate;
        _intervatedate = [LZFormat String2Date:strDate];
    }else{
        _intervatedate=intervatedate;
    }
}

-(void)setActiondate:(NSDate *)actiondate{
    if([actiondate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)actiondate;
        _actiondate = [LZFormat String2Date:strDate];
    }else{
        _actiondate=actiondate;
    }
}

@end
