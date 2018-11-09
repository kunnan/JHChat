//
//  MsgBaseParse.m
//  LeadingCloud
//
//  Created by wchMac on 16/3/11.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "MsgBaseParse.h"
#import "ChatViewController.h"

@implementation MsgBaseParse

-(BOOL)checkIsOpenChatViewController{
    UIViewController *currentVC = [self.appDelegate.lzGlobalVariable getCurrentViewController];
    
    if([currentVC isKindOfClass:[ChatViewController class]] ){
        return YES;
    }
    
    return NO;
}

-(BOOL)checkIsOpenTheChatViewController:(NSString *)dialogid{
    UIViewController *currentVC = [self.appDelegate.lzGlobalVariable getCurrentViewController];
    
    if([currentVC isKindOfClass:[ChatViewController class]]
       && [self.appDelegate.lzGlobalVariable.currentChatViewControllerDialogid isEqualToString:dialogid] ){
        return YES;
    }
    
    return NO;
}

@end
