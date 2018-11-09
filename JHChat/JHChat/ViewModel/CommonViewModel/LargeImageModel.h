//
//  LargeImageModel.h
//  LeadingCloud
//
//  Created by wang on 2018/4/4.
//  Copyright © 2018年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LargeImageBlock)(UIImage *image);

@interface LargeImageModel : NSObject{
	UIImage *sourceImage;
	CGContextRef destContext;
	
	LargeImageBlock completeBlock;
	
}


-(void)getLargeImagePath:(NSString*)path LargeCompleBlock:(LargeImageBlock)black;

-(void)getLargeImage:(UIImage*)image LargeCompleBlock:(LargeImageBlock)black;

@end
