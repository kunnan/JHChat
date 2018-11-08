//
//  LZImageUtils.m
//  LeadingCloud
//
//  Created by wchMac on 16/1/19.
//  Copyright © 2016年 LeadingSoft. All rights reserved.
//
/************************************************************
 Author:  wch
 Date：   2016-01-19
 Version: 1.0
 Description: 图片处理工具类
 History:
 <author>  <time>   <version >   <desc>
 ***********************************************************/

#import "LZImageUtils.h"
#import "UIImage+Resize.h"

@implementation LZImageUtils

/**
 *  压缩图片
 *
 *  @param image  图片
 *  @param width  宽度
 *  @param height 高度
 *
 *  @return 压缩后的图片
 */
+ (UIImage *)ScaleImage:(UIImage *)image width:(float)width height:(float)height
{
    if (width>image.size.width && height > image.size.height)
    {
        return image;
    }
    else
    {
        float iw = image.size.width;
        float ih = image.size.height;
        float iLw = iw;
        float iLh = ih;
        if (height < ih || width < iw)
        {
            if ((float)height / (float)ih < (float)width / (float)iw)
            {
                iLh = height;
                iLw = iLh * iw / ih;
            }
            else
            {
                iLw = width;
                iLh = iLw * ih / iw;
            }
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(iLw, iLh), NO, 0);
        [image drawInRect:CGRectMake(0, 0, iLw, iLh)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage;
    }
    
}

/**
 *  缩放为指定的宽和高
 */
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    CGFloat newsizeWidth;
    CGFloat newsizeHeight;
    NSInteger newHeight;
    newsizeWidth=size.width;
    newsizeHeight=size.height;
    CGFloat i=floor(newsizeHeight);//对num取整
    if(newsizeHeight!=i){
        newsizeHeight = floor(newsizeHeight);
        newHeight=roundf(newsizeHeight);
        newHeight=newHeight/10*10;
    }else{
        newsizeHeight = floor(newsizeHeight);
        newHeight=roundf(newsizeHeight);
    }
//    NSLog(@"%f,%f",image.size.width,image.size.height);
    
    UIGraphicsBeginImageContext(CGSizeMake(newsizeWidth, newHeight));
    [image drawInRect:CGRectMake(0, 0, newsizeWidth, newsizeHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



/**
 *  为图片纠正方向
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/**
 *  根据原图尺寸计算小图尺寸
 *
 *  @param oriSize 原图大小
 *  @param targetSize  最大值
 *  @param minSize  最小值
 *
 *  @return 缩小后的尺寸
 */
+(CGSize)CalculateSmalSize:(CGSize)oriSize maxSize:(float)maxSize minSize:(float)minSize{

    CGFloat smallHeight = 0; // oriSize.height;
    CGFloat smallWidth = 0; // oriSize.width;
    
    if(oriSize.width > oriSize.height){
        smallWidth = maxSize;
        smallHeight = (maxSize * oriSize.height) / oriSize.width;
    }
    else if(oriSize.width == oriSize.height){
        if (oriSize.width >= maxSize) {
            return CGSizeMake(maxSize, maxSize);
        } else if (oriSize.width < maxSize && oriSize.width > minSize) {
            return oriSize;
        } else {
            return CGSizeMake(minSize, minSize);
        }
    }
    else {
        smallHeight = maxSize;
        smallWidth = (maxSize * oriSize.width)  / oriSize.height;
    }
    
    /* 若宽或高小于某值，则重置 */
    smallHeight = smallHeight<minSize ? minSize : smallHeight;
    smallWidth = smallWidth<minSize ? minSize : smallWidth;
    
    return CGSizeMake(smallWidth, smallHeight);
}

@end
