//
//  ImMsgAppModel.h
//  LeadingCloud
//
//  Created by gjh on 2018/10/8.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImMsgAppModel : NSObject
/// 
@property(nonatomic,strong) NSString *appid;
///
@property(nonatomic,strong) NSString *logo;
///
@property(nonatomic,strong) NSString *appcode;
///
@property(nonatomic,strong) NSString *state;
///
@property(nonatomic,strong) NSString *msgiosconfig;
///
@property(nonatomic,strong) NSString *msgandroidconfig;
///
@property(nonatomic,strong) NSString *valid;
///
@property (nonatomic,strong) NSString *appcolour;

@property (nonatomic, strong) NSString *synthetiselogo;

@property (nonatomic, strong) NSString *msgwebconfig;

@property (nonatomic, strong) NSString *name;
@end
