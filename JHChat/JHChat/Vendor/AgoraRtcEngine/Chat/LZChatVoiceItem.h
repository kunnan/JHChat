//
//  LZChatVoiceItem.h
//  LeadingCloud
//
//  Created by wang on 2018/3/7.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZChatVoiceItem : NSObject

@property (nonatomic,assign) NSUInteger uid;

@property (nonatomic,strong) NSString *face;

@property(nonatomic,strong) NSString *userid;

@property(nonatomic,assign) BOOL islinking;


@end
