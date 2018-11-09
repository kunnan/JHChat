//
//  ImMsgAppDAL.h
//  LeadingCloud
//
//  Created by gjh on 2018/10/8.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import "LZFMDatabase.h"
#import "ImMsgAppModel.h"

@interface ImMsgAppDAL : LZFMDatabase

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(ImMsgAppDAL *)shareInstance;
/**
 *  创建表
 */
-(void)createImMsgAppTableIfNotExists;
/**
 *  升级数据库
 */
-(void)updateImMsgAppTableCurrentDBVersion:(int)currentDbVersion systemDbVersion:(int)systemDbVersion;

/**
 *  批量添加数据
 */
-(void)addDataWithImMsgAppArray:(NSMutableArray *)imMsgAppArray;
/**
 *  单个数据
 */
-(void)addImMsgAppModel:(ImMsgAppModel *)imMsgAppModel;

/**
 *  ImMsgAppModel
 *
 *  @param
 *
 *  @return ImMsgAppModel
 */
-(NSMutableArray<ImMsgAppModel *> *)getimMsgAppModelArr;

/* 删除对应的数据 */
- (void)deleteImMsgAppModel;

/**
 *  根据name获取ImMsgAppModel
 *
 *  @param Name
 *
 *  @return ImMsgAppModel
 */
- (ImMsgAppModel *)getImMsgAppModelWithName:(NSString *)Name;
@end
