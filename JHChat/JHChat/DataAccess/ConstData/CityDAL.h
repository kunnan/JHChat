//
//  CityDAL.h
//  LeadingCloud
//
//  Created by lz on 16/1/14.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;
@interface CityDAL : NSObject

@property(nonatomic,strong) FMDatabase *dataBase;

-(NSMutableArray *)QueryData:(NSString *)bm;
-(void)insertData;
/**
 *  根据城市编码得到城市名称
 */
-(NSString *)getCityNameData:(NSString *)bm;

@end
