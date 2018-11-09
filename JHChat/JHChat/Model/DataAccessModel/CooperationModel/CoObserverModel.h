//
//  CoObserverModel.h
//  LeadingCloud
//
//  Created by wang on 2017/6/8.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JsonSerial.h"


@interface CoObserverModel : NSObject

@property(nonatomic,copy)NSString *cid;
@property(nonatomic,copy)NSString *cooid;
@property(nonatomic,copy)NSString *face;
@property(nonatomic,copy)NSString *oid;
@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *username;

@end
