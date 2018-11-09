//
//  MsgTemplateViewModel.h
//  LeadingCloud
//
//  Created by wchMac on 16/8/16.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "BaseViewModel.h"
#import "ImMsgTemplateDAL.h"

@interface MsgTemplateViewModel : BaseViewModel

/**
 *  根据Code获取对应的模板
 */
+(ImMsgTemplateModel *)getMsgTemplateModel:(NSString *)code;

@end
