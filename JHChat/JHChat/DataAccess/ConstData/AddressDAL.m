//
//  AddressDAL.m
//  LeadingCloud
//
//  Created by dfl on 2018/8/31.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import "AddressDAL.h"

@implementation AddressDAL


- (NSString*) getPath {
    return [[NSBundle mainBundle]pathForResource:@"addres" ofType:@"db"];
    //SELECT distinct province FROM "base_weather_area" WHERE code LIKE  '%010%' 
}


//得到所有省
-(NSMutableArray *)getProvinceQueryData{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    FMDatabase *_dataBase = [FMDatabase databaseWithPath:[self getPath]];
    _dataBase.isEncryption = NO;
    
    if ([_dataBase open]) {
        FMResultSet *rs = nil;
        rs = [_dataBase executeQuery:@"SELECT distinct province FROM base_weather_area WHERE code LIKE '%010%'"];
        
        while ([rs next]){
            NSString *province = [rs stringForColumn:@"province"];
            
            NSMutableDictionary *cityDic = [[NSMutableDictionary alloc] init];
            NSMutableArray *arrdata = [NSMutableArray array];
            
            FMResultSet *rmresult = [_dataBase executeQuery:@"select code,city from base_weather_area where province= ?",province];
            while ([rmresult next]) {
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                NSString *code = [rmresult stringForColumn:@"code"];
                NSString *city = [rmresult stringForColumn:@"city"];
                [dic setObject:code forKey:@"code"];
                [dic setObject:city forKey:@"city"];
                [arrdata addObject:dic];
            }
            [rmresult close];
            
            [cityDic setObject:province forKey:@"province"];
            [cityDic setObject:arrdata forKey:@"citydata"];
            
            [result addObject:cityDic];
        }
        [rs close];
        [_dataBase close];
    }
    
    return result;
}

@end
