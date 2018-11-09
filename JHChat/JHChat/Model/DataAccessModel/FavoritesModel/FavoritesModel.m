//
//  FavoritesModel.m
//  LeadingCloud
//
//  Created by lz on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "FavoritesModel.h"

@implementation FavoritesModel

-(void)setFavoritedate:(NSDate *)favoritedate{
    if([favoritedate isKindOfClass:[NSString class]]){
        NSString *strDate = (NSString *)favoritedate;
        _favoritedate = [LZFormat String2Date:strDate];
    }
    else {
        _favoritedate = favoritedate;
    }
}

@end
