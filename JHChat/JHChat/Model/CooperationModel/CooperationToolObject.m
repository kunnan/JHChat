//
//  CooperationToolObject.m
//  LeadingCloud
//
//  Created by wang on 15/12/21.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import "CooperationToolObject.h"

@implementation CooperationToolObject

+(BOOL)isIOSSevent
{
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    
    if (version <7.1) {
        
        return YES;
    }
    else
    {
        return NO;
    }
    
}

+(UIColor*)creatColorRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b
{
    
    
    
    UIColor *color=[[UIColor alloc]initWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    
    return color;
}


+(CGSize)sizeWithLabelFont:(UIFont*)font Text:(NSString *)text Size:(CGSize)size
{
    
    if ([self isIOSSevent]==YES) {
        CGSize labelsize;
        
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        
        labelsize=[text boundingRectWithSize:CGSizeMake(size.width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:NULL].size ;
        NSLog(@"width:%f,height:%f",labelsize.width,labelsize.height);
        labelsize.height+=3;
        
        return  labelsize;
    }
    
    else
    {
        CGSize labelsize =[text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        
        return labelsize;
        
        
    }
    
}

+(UIView*)getLineViewFrame:(CGRect)frame{
    
    UIView *lineView=[[UIView alloc]initWithFrame:frame];
    lineView.backgroundColor=[self creatColorRed:244 green:244 blue:244];
    return lineView;
}

+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
