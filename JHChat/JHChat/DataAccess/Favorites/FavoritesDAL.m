//
//  FavoritesDAL.m
//  LeadingCloud
//
//  Created by lz on 15/12/22.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
/************************************************************
 Author:  dfl
 Date：   2015-12-22
 Version: 1.0
 Description: 收藏数据处理
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "FavoritesDAL.h"
#import "NSString+IsNullOrEmpty.h"

@implementation FavoritesDAL

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(FavoritesDAL *)shareInstance{
    static FavoritesDAL *instance = nil;
    if (instance == nil || [AppUtils CheckIsRestInstance:instance.instanceUserIDTag guidTag:instance.instanceGUIDTag]) {
        instance = [[FavoritesDAL alloc] init];
    }
    return instance;
}

#pragma mark - 表结构操作

/**
 *  创建表
 */
-(void)createFavoritesTableIfNotExists
{
    NSString *tableName = @"favorites";
    
    /* 判断是否已经创建了此表 */
    if(![super checkIsExistsTable:tableName]){
        /*****************************************************************************
         自2016-05-06日起，此sql语句不允许再进行修改,若需要修改表结构，
         使用 updateUserTableCurrentDBVersion 并在"表结构更改说明.txt"中进行登记
         *****************************************************************************/
        [[self getDbBase] executeUpdate:[NSString stringWithFormat:
                                         @"Create Table If Not Exists %@("
                                         "[favoriteid] [varchar](50) PRIMARY KEY NOT NULL,"
                                         "[uid] [varchar](50) NULL,"
                                         "[oid] [varchar](50) NULL,"
                                         "[releaseuid] [varchar](50) NULL,"
                                         "[releaseuface] [varchar](50) NULL,"
                                         "[releaseuname] [varchar](50) NULL,"
                                         "[favoritetype] [varchar](50) NULL,"
                                         "[imageurl] [varchar](500) NULL,"
                                         "[favoritedate] [date] NULL,"
                                         "[title] [varchar](200) NULL,"
                                         "[issrc] [integer] NULL,"
                                         "[description] [varchar](500) NULL,"
                                         "[objectid] [varchar](50) NULL,"
                                         "[isfavorite] [integer] NULL);",
                                         tableName]];
        
    }
}
/**
 *  升级数据库
 */
-(void)updateFavoritesTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion{
    for (int i = currentDbVersion+1; i<=systemDbVersion; i++) {
        switch (i) {
            case 48:{
                [self AddColumnToTableIfNotExist:@"favorites" columnName:@"[size]" type:@"[integer]"];
                [self AddColumnToTableIfNotExist:@"favorites" columnName:@"[exptype]" type:@"[varchar](50)"];
                break;
            }
            case 51:{
                [self AddColumnToTableIfNotExist:@"favorites" columnName:@"[appcode]" type:@"[text]"];
                break;
            }
            case 57:{
                [self AddColumnToTableIfNotExist:@"favorites" columnName:@"[type]" type:@"[integer]"];
                break;
            }
        }
    }
}
#pragma mark - 添加数据
/**
 *  文件收藏
 *
 *  @param favoriteFileModel 收藏文件的model
 */
-(void)addDataWithFavoriteModel:(FavoritesModel*)favoriteFileModel{
    
    [[self getDbQuene:@"favorites" FunctionName:@"addDataWithFavoriteModel:(FavoritesModel*)favoriteFileModel"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        
        NSString *favoriteid = favoriteFileModel.favoriteid;
        NSString *uid = favoriteFileModel.uid;
        
        NSString *oid=favoriteFileModel.oid;
        NSString *releaseuid=favoriteFileModel.releaseuid;
        NSString *releaseuface=favoriteFileModel.releaseuface;
        NSString *releaseuname=favoriteFileModel.releaseuname;
        NSNumber *issrc=[NSNumber numberWithInteger:favoriteFileModel.issrc];
        
        NSString *favoritetype = favoriteFileModel.favoritetype;
        NSString *url = favoriteFileModel.imageurl;
        NSDate *favoritedate = favoriteFileModel.favoritedate;
        NSString *title = favoriteFileModel.title;
        NSString *descript = favoriteFileModel.descript;
        NSString *objectid = favoriteFileModel.objectid;
        NSNumber *isfavorite = [NSNumber numberWithInteger:favoriteFileModel.isfavorite];
        
        NSNumber *size = [NSNumber numberWithLongLong:favoriteFileModel.size];
        NSString *exptype = favoriteFileModel.exptype;
        
        NSString *appcode = favoriteFileModel.appcode;
        NSNumber *type = [NSNumber numberWithInteger:favoriteFileModel.type];
        
        NSString *sql = @"INSERT OR REPLACE INTO favorites(favoriteid,uid,favoritetype,imageurl,favoritedate,title,description,objectid,oid,releaseuid,releaseuface,releaseuname,issrc,isfavorite,size,exptype,appcode,type)"
        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        
        isOK = [db executeUpdate:sql,favoriteid,uid,favoritetype,url,favoritedate,title,descript,objectid,oid,releaseuid,releaseuface,releaseuname,issrc,isfavorite,size,exptype,appcode,type];
        if (!isOK) {
            DDLogError(@"插入失败");
        }
        
        if (!isOK) {
            *rollback = YES;
		[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"favorites" Sql:sql Error:@"插入失败" Other:nil];
            return;
        }
    }];

}

/**
 *  文件收藏列表
 *
 *  @param favoriteFileModel 收藏文件的model
 */
-(void)addDataWithFavoriteArray:(NSMutableArray*)favoriteFileArray{
    
	[[self getDbQuene:@"favorites" FunctionName:@"addDataWithFavoriteArray:(NSMutableArray*)favoriteFileArray"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = YES;
        for (int i = 0; i < [favoriteFileArray count]; i++) {
            FavoritesModel *favoriteFileModel = nil;
            favoriteFileModel = [favoriteFileArray objectAtIndex:i];
            NSString *favoriteid = favoriteFileModel.favoriteid;
            NSString *uid = favoriteFileModel.uid;
            NSString *favoritetype = favoriteFileModel.favoritetype;
            NSString *url = favoriteFileModel.imageurl;
            NSDate *favoritedate = favoriteFileModel.favoritedate;
            NSString *title = favoriteFileModel.title;
            NSString *description = favoriteFileModel.descript;
            NSString *objectid = favoriteFileModel.objectid;
            
            NSString *oid=favoriteFileModel.oid;
            NSString *releaseuid=favoriteFileModel.releaseuid;
            NSString *releaseuface=favoriteFileModel.releaseuface;
            NSString *releaseuname=favoriteFileModel.releaseuname;
            NSNumber *issrc=[NSNumber numberWithInteger:favoriteFileModel.issrc];
            NSNumber *isfavorite = [NSNumber numberWithInteger:favoriteFileModel.isfavorite];
            
            NSNumber *size = [NSNumber numberWithLongLong:favoriteFileModel.size];
            NSString *exptype = favoriteFileModel.exptype;
            
            NSString *appcode = favoriteFileModel.appcode;
            NSNumber *type = [NSNumber numberWithInteger:favoriteFileModel.type];
            
            NSString *sql = @"INSERT OR REPLACE INTO favorites(favoriteid,uid,favoritetype,imageurl,favoritedate,title,description,objectid,oid,releaseuid,releaseuface,releaseuname,issrc,isfavorite,size,exptype,appcode,type)"
            "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            // 崩到这
            isOK = [db executeUpdate:sql,favoriteid,uid,favoritetype,url,favoritedate,title,description,objectid,oid,releaseuid,releaseuface,releaseuname,issrc,isfavorite,size,exptype,appcode,type];
            if (!isOK) {
                DDLogError(@"插入失败");
            }
            
            if (!isOK) {
				[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"favorites" Sql:sql Error:@"插入失败" Other:nil];
                *rollback = YES;
                return;
            }


        }
        
    }];
    
}

#pragma mark - 删除数据
/**
 *  取消收藏
 *
 *  @param collectionId 收藏id
 */
-(void)deleteDidCollectionFile:(NSString*)collectionId{
    
    [[self getDbQuene:@"favorites" FunctionName:@"deleteDidCollectionFile:(NSString*)collectionId"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from favorites where objectid=?";
        isOK = [db executeUpdate:sql,collectionId];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"favorites" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
}
/**
 * 删除指定类型
 *
 *  @param collectionId 收藏类型
 */
-(void)deleteResCollectionFile:(NSString*)favoritestype{
    
    [[self getDbQuene:@"favorites" FunctionName:@"deleteResCollectionFile:(NSString*)favoritestype"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from favorites where favoritetype=?";
        isOK = [db executeUpdate:sql,favoritestype];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"favorites" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
    
    
}
-(void)deleteAllDidCollectionFile{
    
    [[self getDbQuene:@"favorites" FunctionName:@"deleteAllDidCollectionFile"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from favorites";
        isOK = [db executeUpdate:sql];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"favorites" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
    
    
}

-(void)deleAllFavoritesWithByType:(NSInteger)type{
    [[self getDbQuene:@"favorites" FunctionName:@"deleAllFavoritesWithByType:(NSInteger)type"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isOK = NO;
        NSString *sql = @"delete from favorites where type=?";
        isOK = [db executeUpdate:sql,[NSNumber numberWithInteger:type]];
        
        if (!isOK) {
			[[CommonAddErrorDalMessageModel defaultManager]addDalMessageTableName:@"favorites" Sql:sql Error:@"删除失败" Other:nil];

            DDLogError(@"删除失败 - updateMsgId");
        }
    }];
}


#pragma mark - 修改数据



#pragma mark - 查询数据
/**
 *  从收藏表中查询目标id(是文件的rid)
 *
 *  @return 目标id数组
 */
-(NSMutableArray*)selectAllObjectId:(NSString*)favoritetype
{
     NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"favorites" FunctionName:@"selectAllObjectId:(NSString*)favoritetype"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"Select favoriteid,uid,favoritetype,imageurl,favoritedate,title,description,objectid,oid,releaseuid,releaseuface,releaseuname,issrc,isfavorite,size,exptype From favorites Where favoritetype = '%@' Order by favoritedate desc",favoritetype];

        FMResultSet *resultSet=[db executeQuery:sql];
        while([resultSet next]) {
           
            [array addObject:[self convertResultSetToModel:resultSet]];
            
        }
        [resultSet close];
    }];
    
    return array;
}
/**
 *  通过收藏文件的objectid查询到该文件的日期
 *
 *  @param fileRid 文件的rid
 *
 *  @return 收藏文件的model
 */
-(FavoritesModel*)getcollectionDate:(NSString*)fileRid
{
    
    __block FavoritesModel *collectModel = nil;
    [[self getDbQuene:@"favorites" FunctionName:@"getcollectionDate:(NSString*)fileRid"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *sql = [NSString stringWithFormat:@"Select favoriteid,uid,favoritetype,imageurl,favoritedate,title,description,objectid,oid,releaseuid,releaseuface,releaseuname,issrc,isfavorite,size,exptype From favorites Where objectid = '%@'",fileRid];
        FMResultSet *resultSet=[db executeQuery:sql];
        if([resultSet next]) {
            
            collectModel = [self convertResultSetToModel:resultSet];
            
        }
        [resultSet close];
    }];
    
    return collectModel;
}

/**
 *  从收藏表中查询目标id(是文件的rid)
 *
 *  @return 目标id数组
 */
-(NSMutableArray*)selectAllStartNum:(NSInteger)startNum Count:(NSInteger)count state:(NSInteger)state type:(NSString *)type{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"favorites" FunctionName:@"selectAllStartNum:(NSInteger)startNum Count:(NSInteger)count state:(NSInteger)state type:(NSString *)type"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql;
        if([NSString isNullOrEmpty:type]){
           sql= [NSString stringWithFormat:@"Select * From favorites Where type = ? Order by favoritedate desc limit %ld,%ld",(long)startNum,(long)count];
        }
        else{
           sql= [NSString stringWithFormat:@"Select * From favorites Where type = ? and favoritetype = '%@' Order by favoritedate desc limit %ld,%ld",type,(long)startNum,(long)count];
        }
        
        FMResultSet *resultSet=[db executeQuery:sql,[NSNumber numberWithInteger:state]];
        while([resultSet next]) {
            FavoritesModel  * fModel=[self convertResultSetToModel:resultSet];
            NSString *favoritetype = [resultSet stringForColumn:@"favoritetype"];
            NSString *sql1;
//            if([favoritetype isEqualToString:@"2"]){
//               sql1= @"Select * From favorite_type Order by ftid=? asc";
//            }else{
               sql1= @"Select * From favorite_type Order by code=? asc";
//            }
            
            
            FMResultSet *resultSet1=[db executeQuery:sql1,favoritetype];
            while([resultSet1 next]) {
                
                fModel.favoriteTypeModel=[self convertResultTypeSetToModel:resultSet1];;
            }
            [array addObject:fModel];
            [resultSet1 close];
        }
        [resultSet close];
    }];
    
    return array;
}

/**
 *  从收藏表中查询目标id(是文件的rid)(类型查找)
 *
 *  @return 目标id数组
 */
-(NSMutableArray*)selectTypeAllStartNum:(NSInteger)startNum Count:(NSInteger)count Type:(NSString *)type{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"favorites" FunctionName:@"selectTypeAllStartNum:(NSInteger)startNum Count:(NSInteger)count Type:(NSString *)type"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql= [NSString stringWithFormat:@"Select * From favorites Where favoritetype='%@' Order by favoritedate desc limit %ld,%ld",type,(long)startNum,(long)count];
        FMResultSet *resultSet=[db executeQuery:sql];
        while([resultSet next]) {
            FavoritesModel  * fModel=[self convertResultSetToModel:resultSet];
            NSString *favoritetype = [resultSet stringForColumn:@"favoritetype"];
            NSString *sql1;
//            if([favoritetype isEqualToString:@"2"]){
//                sql1= @"Select * From favorite_type Order by ftid=? asc";
//            }else{
                sql1= @"Select * From favorite_type Order by code=? asc";
//            }
            
            FMResultSet *resultSet1=[db executeQuery:sql1,favoritetype];
            // 注意while和if的区别 while循环 如果是if的话 只会得到一个元素
            while([resultSet1 next]) {
                
                fModel.favoriteTypeModel=[self convertResultTypeSetToModel:resultSet1];;
            }
            [array addObject:fModel];
            [resultSet1 close];
        }
        [resultSet close];
    }];
    
    return array;
}

/**
 *  搜索收藏信息
 *
 *  @param searchText 搜索文本
 *
 *  @return 搜索结果
 */
-(NSMutableArray *)getFavoriteForSearch:(NSString *)searchText StartNum:(NSInteger)startNum Count:(NSInteger)count{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"favorites" FunctionName:@"getFavoriteForSearch:(NSString *)searchText StartNum:(NSInteger)startNum Count:(NSInteger)count"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql= [NSString stringWithFormat:@"Select * From favorites Where releaseuname like '%%%@%%' or title like '%%%@%%' Order by favoritedate desc limit %ld,%ld",searchText,searchText,(long)startNum,(long)count];
        FMResultSet *resultSet=[db executeQuery:sql];
        // 注意while和if的区别 while循环 如果是if的话 只会得到一个元素
        while([resultSet next]) {
            FavoritesModel  * fModel=[self convertResultSetToModel:resultSet];
            NSString *favoritetype = [resultSet stringForColumn:@"favoritetype"];
            
            NSString *sql1;
//            if([favoritetype isEqualToString:@"2"]){
//                sql1= @"Select * From favorite_type Order by ftid=? asc";
//            }else{
                sql1= @"Select * From favorite_type Order by code=? asc";
//            }
            FMResultSet *resultSet1=[db executeQuery:sql1,favoritetype];
            // 注意while和if的区别 while循环 如果是if的话 只会得到一个元素
            while([resultSet1 next]) {
                
                fModel.favoriteTypeModel=[self convertResultTypeSetToModel:resultSet1];;
            }
            [array addObject:fModel];
            [resultSet1 close];
        }
        [resultSet close];
    }];
    
    return array;
}

/**
 *  搜索收藏信息(类型)
 *
 *  @param searchText 搜索文本
 *
 *  @return 搜索结果
 */
-(NSMutableArray *)getFavoriteForSearch:(NSString *)searchText StartNum:(NSInteger)startNum Count:(NSInteger)count Type:(NSString *)type{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"favorites" FunctionName:@"getFavoriteForSearch:(NSString *)searchText StartNum:(NSInteger)startNum Count:(NSInteger)count Type:(NSString *)type"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql= [NSString stringWithFormat:@"Select * From favorites Where favoritetype='%@' and (releaseuname like '%%%@%%' or title like '%%%@%%') Order by favoritedate desc limit %ld,%ld",type,searchText,searchText,(long)startNum,(long)count];
        FMResultSet *resultSet=[db executeQuery:sql];
        // 注意while和if的区别 while循环 如果是if的话 只会得到一个元素
        while([resultSet next]) {
            FavoritesModel  * fModel=[self convertResultSetToModel:resultSet];
            NSString *favoritetype = [resultSet stringForColumn:@"favoritetype"];
            
            NSString *sql1;
//            if([favoritetype isEqualToString:@"2"]){
//                sql1= @"Select * From favorite_type Order by ftid=? asc";
//            }else{
                sql1= @"Select * From favorite_type Order by code=? asc";
//            }
            FMResultSet *resultSet1=[db executeQuery:sql1,favoritetype];
            // 注意while和if的区别 while循环 如果是if的话 只会得到一个元素
            while([resultSet1 next]) {
                
                fModel.favoriteTypeModel=[self convertResultTypeSetToModel:resultSet1];;
            }
            [array addObject:fModel];
            [resultSet1 close];
        }
        [resultSet close];
    }];
    
    return array;
}

/**
 *  搜索收藏信息(类型)
 *
 *  @param searchText 搜索文本
 *
 *  @return 搜索结果
 */
-(NSMutableArray *)getFavoriteForSearch:(NSString *)searchText StartNum:(NSInteger)startNum Count:(NSInteger)count Type:(NSString *)type state:(NSInteger)state{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [[self getDbQuene:@"favorites" FunctionName:@"getFavoriteForSearch:(NSString *)searchText StartNum:(NSInteger)startNum Count:(NSInteger)count Type:(NSString *)type state:(NSInteger)state"] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql;
        if([NSString isNullOrEmpty:type]){
            sql= [NSString stringWithFormat:@"Select * From favorites Where type= ? and (releaseuname like '%%%@%%' or title like '%%%@%%') Order by favoritedate desc limit %ld,%ld",searchText,searchText,(long)startNum,(long)count];
        }else{
            sql= [NSString stringWithFormat:@"Select * From favorites Where type= ? and favoritetype='%@' and (releaseuname like '%%%@%%' or title like '%%%@%%') Order by favoritedate desc limit %ld,%ld",type,searchText,searchText,(long)startNum,(long)count];
        }
        FMResultSet *resultSet=[db executeQuery:sql,[NSNumber numberWithInteger:state]];
        // 注意while和if的区别 while循环 如果是if的话 只会得到一个元素
        while([resultSet next]) {
            FavoritesModel  * fModel=[self convertResultSetToModel:resultSet];
            NSString *favoritetype = [resultSet stringForColumn:@"favoritetype"];
            
            NSString *sql1;
            //            if([favoritetype isEqualToString:@"2"]){
            //                sql1= @"Select * From favorite_type Order by ftid=? asc";
            //            }else{
            sql1= @"Select * From favorite_type Order by code=? asc";
            //            }
            FMResultSet *resultSet1=[db executeQuery:sql1,favoritetype];
            // 注意while和if的区别 while循环 如果是if的话 只会得到一个元素
            while([resultSet1 next]) {
                
                fModel.favoriteTypeModel=[self convertResultTypeSetToModel:resultSet1];;
            }
            [array addObject:fModel];
            [resultSet1 close];
        }
        [resultSet close];
    }];
    
    return array;
}


#pragma mark - Private Function

/**
 *  将FMResultSet转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return FavoritesModel
 */
-(FavoritesModel *)convertResultSetToModel:(FMResultSet *)resultSet{
    
    NSString *favoriteid = [resultSet stringForColumn:@"favoriteid"];
    NSString *uid = [resultSet stringForColumn:@"uid"];
    NSString *url = [resultSet stringForColumn:@"imageurl"];
    NSString *favoritetype = [resultSet stringForColumn:@"favoritetype"];
    NSDate *favoritedate = [resultSet dateForColumn:@"favoritedate"];
    NSString *title = [resultSet stringForColumn:@"title"];
    NSString *description = [resultSet stringForColumn:@"description"];
    NSString *objectid = [resultSet stringForColumn:@"objectid"];
    NSString *releaseuid=[resultSet stringForColumn:@"releaseuid"];
    NSString *releaseuface=[resultSet stringForColumn:@"releaseuface"];
    NSString *releaseuname=[resultSet stringForColumn:@"releaseuname"];
    NSInteger issrc=[resultSet intForColumn:@"issrc"];
    NSString *oid=[resultSet stringForColumn:@"oid"];
    NSInteger isfavorite = [resultSet intForColumn:@"isfavorite"];
    NSInteger size = [resultSet intForColumn:@"size"];
    NSString *exptype = [resultSet stringForColumn:@"exptype"];
    NSInteger type=[resultSet intForColumn:@"type"];
    
    FavoritesModel *collectionModel = [[FavoritesModel alloc] init];
    collectionModel.favoriteid = favoriteid;
    collectionModel.uid = uid;
    collectionModel.imageurl = url;
    collectionModel.favoritetype = favoritetype;
    collectionModel.favoritedate = favoritedate;
    collectionModel.title = title;
    collectionModel.descript = description;
    collectionModel.objectid = objectid;
    collectionModel.releaseuid=releaseuid;
    collectionModel.releaseuface=releaseuface;
    collectionModel.releaseuname=releaseuname;
    collectionModel.issrc=issrc;
    collectionModel.oid=oid;
    collectionModel.isfavorite = isfavorite;
    collectionModel.size = size;
    collectionModel.exptype = exptype;
    collectionModel.type = type;
    
    return collectionModel;
}

/**
 *  将FMResultSet转为Model
 *
 *  @param resultSet FMResultSet
 *
 *  @return FavoriteTypeModel
 */
-(FavoriteTypeModel *)convertResultTypeSetToModel:(FMResultSet *)resultSet{
    
    NSString *ftid = [resultSet stringForColumn:@"ftid"];
    NSString *name = [resultSet stringForColumn:@"name"];
    NSString *webviewfun = [resultSet stringForColumn:@"webviewfun"];
    NSString *iosviewfun = [resultSet stringForColumn:@"iosviewfun"];
    NSString *androidviewfun = [resultSet stringForColumn:@"androidviewfun"];
    NSString *webimagedirectory = [resultSet stringForColumn:@"web_image_directory"];
    NSString *iosimagedirectory = [resultSet stringForColumn:@"ios_image_directory"];
    NSString *androidimagedirectory=[resultSet stringForColumn:@"android_image_directory"];
    NSString *appid = [resultSet stringForColumn:@"appid"];
    NSString *applogo = [resultSet stringForColumn:@"applogo"];
    NSString *appcolor = [resultSet stringForColumn:@"appcolor"];
    NSString *appcode = [resultSet stringForColumn:@"appcode"];
	NSString *baselinkcode = [resultSet stringForColumn:@"baselinkcode"];

    NSInteger state = [resultSet intForColumn:@"state"];
    
    FavoriteTypeModel *favoriteTypeModel = [[FavoriteTypeModel alloc] init];
    favoriteTypeModel.ftid = ftid;
    favoriteTypeModel.name = name;
    favoriteTypeModel.webviewfun = webviewfun;
    favoriteTypeModel.iosviewfun = iosviewfun;
    favoriteTypeModel.androidviewfun = androidviewfun;
    favoriteTypeModel.web_image_directory = webimagedirectory;
    favoriteTypeModel.ios_image_directory = iosimagedirectory;
    favoriteTypeModel.android_image_directory = androidimagedirectory;
    favoriteTypeModel.appid = appid;
    favoriteTypeModel.applogo = applogo;
    favoriteTypeModel.appcolor = appcolor;
    favoriteTypeModel.appcode = appcode;
    favoriteTypeModel.state = state;
	favoriteTypeModel.baselinkcode = baselinkcode;
    return favoriteTypeModel;
}

@end
