//
//  CommonFontModel.m
//  LeadingCloud
//
//  Created by wang on 17/2/23.
//  Copyright © 2017年 LeadingSoft. All rights reserved.
//

#import "CommonFontModel.h"

@implementation CommonFontModel

/**
 *  获取单一实例
 *
 *  @return 实例对象
 */
+(CommonFontModel *)shareInstance;{
    
    static CommonFontModel *instance = nil;
    if (instance == nil ) {
        instance = [[CommonFontModel alloc] init];
    }
    return instance;
}
/**
 字体大小是否发生改变 改变保存到本地
 
 @param font 字体
 
 @return
 */
- (BOOL)isChangeSystemFont:(NSString*)font{
    
    BOOL isChage = true;
    
    //系统字符串转换本地
    NSString *temp = [self getSaveAppString:font];
    
    //得到本地的
    NSString *loc = [self getFontStirng];
    
    if (!loc || [loc length]<2) {
        loc  = @"UICTContentSizeCategoryL";
    }
    
    if (temp && loc && [loc isEqualToString:temp]) {
        
        isChage = false;
    
    }else{
        [self setSystenFont:temp];
    }
    return isChage;
}
/**
 得到保存到应用的字符串
 */
- (NSString*)getSaveAppString:(NSString*)font{
    
    NSString *str = nil;
    
    if ([font isEqualToString:@"UICTContentSizeCategoryXS"]) {
        
        str  = @"UICTContentSizeCategoryM";
    }else if ([font isEqualToString:@"UICTContentSizeCategoryS"]){
        str  = @"UICTContentSizeCategoryM";
        
    }else if ([font isEqualToString:@"UICTContentSizeCategoryM"]){
        
        str  = @"UICTContentSizeCategoryM";
        
    }
    else if ([font isEqualToString:@"UICTContentSizeCategoryL"]){
        
        str  = @"UICTContentSizeCategoryL";
    }
    else if ([font isEqualToString:@"UICTContentSizeCategoryXL"]){
        
        str  = @"UICTContentSizeCategoryXL";
        
    }
    else if ([font isEqualToString:@"UICTContentSizeCategoryXXL"]){
        
        str  = @"UICTContentSizeCategoryXXL";
        
    }
    else if ([font isEqualToString:@"UICTContentSizeCategoryXXXL"]){
        str  = @"UICTContentSizeCategoryXXXL";
        
    }else{
        if(font && [font length]>2){
            str  = @"UICTContentSizeCategoryMAX";
        }else{
            str  = @"UICTContentSizeCategoryL";
        }
    }
    return str;
    
}

- (NSInteger)getLocationFont:(NSString*)font{
    
    
    NSInteger temp = 1;
    
    if ([font isEqualToString:@"UICTContentSizeCategoryM"]){
        temp  = 0;
    }
    else if ([font isEqualToString:@"UICTContentSizeCategoryL"]){
        temp  = 1;
    }
    else if ([font isEqualToString:@"UICTContentSizeCategoryXL"]){
        temp  = 2;
    }
    else if ([font isEqualToString:@"UICTContentSizeCategoryXXL"]){
        temp  = 3;
    }
    else if ([font isEqualToString:@"UICTContentSizeCategoryXXXL"]){
        temp  = 4;
        
    }else{
        if (font && [font length]>2) {
            temp  = 5;
        }
    }
    return temp;
    
}

- (CGFloat)getHandleHeightFromSystemFont:(CGFloat)height{
    
    CGFloat system = [self getHandeHeightRatio];
    //系数 标准为1
    return height*system;
}

//得到处理高度系数
- (CGFloat)getHandeHeightRatio{
    
    CGFloat system = [self getHandeFontRatio];
    //系数 标准为1
    return system;
    
//    return 1;
}
- (CGFloat)getHandleFontFromSystemFont:(CGFloat)font{
    
    CGFloat system = [self getHandeFontRatio];
    //系数 标准为1
    return font*system;
}
//得到处理字体系数
- (CGFloat)getHandeFontRatio{
    
    NSString *category = [self getFontStirng];
    
    if (!category || [category length]<2) {
        return 1;
    }
    return [self getScale:category];
    
//    return 1;
}

- (CGFloat)getScale:(NSString*)category{
    
    CGFloat scale = 1 ;
    
     if ([category isEqualToString:@"UICTContentSizeCategoryM"]){
        scale = 1-0.075;
    }
    else if ([category isEqualToString:@"UICTContentSizeCategoryL"]){
        scale = 1;
    }
    else if ([category isEqualToString:@"UICTContentSizeCategoryXL"]){
        scale = 1.075;
    }
    else if ([category isEqualToString:@"UICTContentSizeCategoryXXL"]){
        scale = 1+0.075*2;
    }
    else if ([category isEqualToString:@"UICTContentSizeCategoryXXXL"]){
        scale = 1+0.075*3;
    }else{
        if (category) {
            scale = 1+0.075*4;
        }
    }
    
    return scale;
}

- (NSString*)getFontStirng{
	
	
    return [LZUserDataManager getSystemFont];
}


- (void)setSystenFont:(NSString*)font{
    
    [self setTempSystenFont:font];
	
	[LZUserDataManager saveSystemFont:font];
}


- (void)setChangeSystenFont:(NSInteger)font isTempt:(BOOL)isTempt{
    
    NSString *fontString;
    
    if (font==0) {
        fontString = @"UICTContentSizeCategoryM";
    }else if (font==1){
        fontString = @"UICTContentSizeCategoryL";
    }
    else if (font==2){
        fontString = @"UICTContentSizeCategoryXL";
        
    }else if (font==3){
        fontString = @"UICTContentSizeCategoryXXL";
    }
    else if (font==4){
        fontString = @"UICTContentSizeCategoryXXXL";

    }else if (font==5){
        fontString = @"UICTContentSizeCategoryMAX";
    }
    
    
    if (isTempt==NO) {
        
        [self setSystenFont:fontString];
        
    }else{
        [self setTempSystenFont:fontString];
        
    }
}


#pragma mark 得到临时的
- (CGFloat)getHandleTempFontFromSystemFont:(CGFloat)font{
    
    CGFloat system = [self getHandeTempFontRatio];
    //系数 标准为1
    return font*system;

}


//得到处理字体系数
- (CGFloat)getHandeTempFontRatio{
    
    NSString *category = [self getTempFontStirng];
    
    if (!category) {
        return 1;
    }
    return [self getScale:category];
}

- (NSString*)getTempFontStirng{
    
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"tempfont"];
}

- (void)setTempSystenFont:(NSString*)font{
    
    [[NSUserDefaults standardUserDefaults]setObject:font forKey:@"tempfont"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
}
// 改变原有labe字体大小
-(void)changeFontWithLabel:(UILabel*)label {
    CGFloat oldfont = label.font.pointSize;
    CGFloat newFont = [self getHandleFontFromSystemFont:oldfont];
    label.font = [UIFont systemFontOfSize:newFont];
}


@end
