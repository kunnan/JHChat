//
//  ResourceQuoteFolderModel.m
//  LeadingCloud
//
//  Created by SY on 2017/11/27.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "ResourceQuoteFolderModel.h"
#import "NSObject+JsonSerial.h"
@implementation ResourceQuoteFolderModel


-(void)setCreatedate:(NSDate *)createdate {
    if([createdate isKindOfClass:[NSString class]]){
        
        NSString *strDate = (NSString *)createdate;
        _createdate = [LZFormat String2Date:strDate];
    }
    else {
        _createdate = createdate;
    }
}
-(ResourceShareFolderModel *)rsfdata {
    ResourceShareFolderModel *shareFolder = [[ResourceShareFolderModel alloc] init];
    [shareFolder serializationWithDictionary:self.rsfDataDic];
    return shareFolder;
}
@end
