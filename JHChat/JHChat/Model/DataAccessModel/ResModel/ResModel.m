//
//  ResModel.m
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "ResModel.h"

@implementation ResModel
-(id)valueForUndefinedKey:(NSString *)key {
    
    return nil;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}
-(void)setCreatedate:(NSDate *)createdate{
    if([createdate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)createdate;
        _createdate = [LZFormat String2Date:strDate];
    }
    else {
        _createdate = createdate;
    }
}

-(void)setUpdatedate:(NSDate *)newUpdatedate{
    if([newUpdatedate isKindOfClass:[NSString class]]){
        NSString *strUpdateDate = (NSString *)newUpdatedate;
        _updatedate = [LZFormat String2Date:strUpdateDate];
    }
    else {
        _updatedate = newUpdatedate;
    }
}
/* 上传下载用 */
- (ResFileModel *)resFileModel
{
    ResFileModel *fileModel = [[ResFileModel alloc] init];
    [fileModel serialization:self.fileinfo];
    return fileModel;
}
-(FavoritesModel *)favoriteModel {
    
    FavoritesModel *favriteBady = [[FavoritesModel alloc] init];
    [favriteBady serializationWithDictionary:self.favoritesDic];
    favriteBady.descript = [self.favoritesDic objectForKey:@"description"];
    return favriteBady;
}
@end
