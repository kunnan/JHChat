//
//  LZVideoPoepleItem.h
//  LeadingCloud
//
//  Created by wang on 2017/8/10.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZVideoPoepleItem : NSObject

@property (strong, nonatomic) NSNumber *agorauid;
@property (strong, nonatomic) NSString *face;
@property (strong, nonatomic) NSString *uid;

@property (assign, nonatomic) BOOL isVideo;
@property (assign, nonatomic) BOOL isChating;

@end
