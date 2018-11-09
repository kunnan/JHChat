//
//  CityDAL.m
//  LeadingCloud
//
//  Created by lz on 16/1/14.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//

#import "CityDAL.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"

@implementation CityDAL

- (NSString*) getPath {
   return [[NSBundle mainBundle]pathForResource:@"constdata" ofType:@"db"];
}



//1.添加数据
-(void)insertData{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"txt"];
    //gbk编码 如果txt文件为utf-8的则使用NSUTF8StringEncoding
    NSStringEncoding gbk = CFStringConvertEncodingToNSStringEncoding(NSUTF8StringEncoding);
    //定义字符串接收从txt文件读取的内容
    NSString *str = [[NSString alloc] initWithContentsOfFile:plistPath encoding:gbk error:nil];
    //将字符串转为nsdata类型
    NSArray *array=[str componentsSeparatedByString:@"\n"];
    NSMutableArray *titArray=[NSMutableArray array];
    for (NSString *s in array) {
        
        NSArray *conArray=[s componentsSeparatedByString:@"\t"];
        
        for (NSString *cSting in conArray) {
            if (cSting&&[cSting length]!=0) {
                [titArray addObject:cSting];
            }
        }
    }
    for (NSString *sString in titArray) {
        NSLog(@"Sting:%@",sString);
        
    }
    
    
    FMDatabaseQueue* queue=[FMDatabaseQueue databaseQueueWithPath:[self getPath] isEncryption:NO];
    [queue inDatabase:^(FMDatabase* database){
        if (![database tableExists:@"city"]) {
//            [database executeUpdate:@"create table user (id integer primary key autoincrement not null,bm integer,city text)"];
            [database executeUpdate:@"CREATE TABLE IF NOT EXISTS City(bm text,city text)"];
        }
        
        for (int i=0; i<titArray.count/2; i++) {
            
            NSString *cityID=[titArray objectAtIndex:2*i];
            
            NSString *cityName=[titArray objectAtIndex:2*i+1];
            BOOL insert=[database executeUpdate:@"insert into user (bm,city) values (?,?)",cityID,cityName];
            if (insert) {
                DDLogVerbose(@"插入成功");
            }else{
                DDLogVerbose(@"插入成功");
            }
            
        }
        
    }];
    [queue close];
}

//２.查询数据
-(NSMutableArray *)QueryData:(NSString *)bm
{
    NSMutableArray *result = [[NSMutableArray alloc] init];

    _dataBase = [FMDatabase databaseWithPath:[self getPath]];
    _dataBase.isEncryption = NO;
    
    if ([_dataBase open]) {
        FMResultSet *rs = nil;
        if([bm isEqualToString:@"-"]){
            rs = [_dataBase executeQuery:@"SELECT bm,city FROM City Where bm like '%0000' order by bm"];
        }
        else if( [bm isEqualToString:@"110000"]||[bm isEqualToString:@"120000"]||[bm isEqualToString:@"500000"]||[bm isEqualToString:@"310000"]){
            //区分直辖市
            NSString *new = [bm substringToIndex:2];
//            rs = [_dataBase executeQuery:[NSString stringWithFormat:@"SELECT bm,city FROM City Where bm like '%@%%' and bm not like '%%00' order by bm",new]];
            rs = [_dataBase executeQuery:[NSString stringWithFormat:@"SELECT bm,city FROM City Where bm like '%@%%00' and bm not like '%%0000' order by bm",new]];
        }
        else if( [bm hasSuffix:@"0000"]){
            NSString *new = [bm substringToIndex:2];
            rs = [_dataBase executeQuery:[NSString stringWithFormat:@"SELECT bm,city FROM City Where bm like '%@%%' and bm like '%%00' and bm not like '%%0000' order by bm",new]];
        }
        else if( [bm hasSuffix:@"00"]){
            NSString *new = [bm substringToIndex:4];
            rs = [_dataBase executeQuery:[NSString stringWithFormat:@"SELECT bm,city FROM City Where bm like '%@%%' and bm not like '%%00' and bm not like '%%01' order by bm",new]];
        }
        while ([rs next]){
            NSString *bm = [rs stringForColumn:@"bm"];
            NSString *city = [rs stringForColumn:@"city"];
            
            NSMutableDictionary *cityDic = [[NSMutableDictionary alloc] init];
            [cityDic setObject:bm forKey:@"bm"];
            [cityDic setObject:city forKey:@"city"];
            
            [result addObject:cityDic];
        }
        [rs close];
        [_dataBase close];
    }
    
    return result;
}

/**
 *  根据城市编码得到城市名称
 */
-(NSString *)getCityNameData:(NSString *)bm{
    NSString *cityName;
    
    _dataBase = [FMDatabase databaseWithPath:[self getPath]];
    _dataBase.isEncryption = NO;
    
    if([bm isEqualToString:@""]||bm==nil)
    {
        [_dataBase close];
    }else{
    if ([_dataBase open]) {
        FMResultSet *rs = nil;
        
        rs = [_dataBase executeQuery:[NSString stringWithFormat:@"SELECT city FROM City Where bm=%@",bm]];
        while ([rs next]){
           cityName = [rs stringForColumn:@"city"];
            
        }
        [rs close];
        [_dataBase close];
    }
    }
    return cityName;
}

@end
