//
//  MsgBaseParse.h
//  LeadingCloud
//
//  Created by wchMac on 16/3/11.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "LZBaseParse.h"

@interface MsgBaseParse : LZBaseParse

-(BOOL)checkIsOpenChatViewController;

-(BOOL)checkIsOpenTheChatViewController:(NSString *)dialogid;

@end
