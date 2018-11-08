/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "MKAnnotationView+WebCache.h"

#if SD_UIKIT || SD_MAC

#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"
#import "UIView+WebCache.h"

@implementation MKAnnotationView (WebCache)

- (void)sd_setImageWithURL:(nullable NSURL *)url {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 completed:nil];
}

- (void)sd_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 completed:nil];
}
/**
 *  LZ--wch修改，2016-01-03
 */
- (void)sd_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder cachePath:(nullable NSString *)cachePath cacheKey:(nullable NSString *)cacheKey{
	[self sd_setImageWithURL:url placeholderImage:placeholder options:0 cachePath:cachePath cacheKey:cacheKey completed:nil];
}
- (void)sd_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options completed:nil];
}

- (void)sd_setImageWithURL:(nullable NSURL *)url completed:(nullable SDExternalCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 completed:completedBlock];
}
/**
 *  LZ--wch修改，2016-01-03
 */
- (void)sd_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder cachePath:(nullable NSString *)cachePath cacheKey:(nullable NSString *)cacheKey completed:(nullable SDExternalCompletionBlock)completedBlock{
	[self sd_setImageWithURL:url placeholderImage:placeholder options:0 cachePath:cachePath cacheKey:cacheKey completed:completedBlock];

}
- (void)sd_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder completed:(nullable SDExternalCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(SDWebImageOptions)options
                 completed:(nullable SDExternalCompletionBlock)completedBlock {
    __weak typeof(self)weakSelf = self;
    [self sd_internalSetImageWithURL:url
                    placeholderImage:placeholder
                             options:options
                        operationKey:nil
                       setImageBlock:^(UIImage *image, NSData *imageData) {
                           weakSelf.image = image;
                       }
                            progress:nil
                           completed:completedBlock];
}

/**
 *  LZ--wch修改，2016-01-03
 */
- (void)sd_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options cachePath:(nullable NSString *)cachePath cacheKey:(nullable NSString *)cacheKey completed:(nullable SDExternalCompletionBlock)completedBlock{
	
	__weak typeof(self)weakSelf = self;
	[self sd_internalSetImageWithURL:url
					placeholderImage:placeholder
							 options:options
						operationKey:nil
					   setImageBlock:^(UIImage *image, NSData *imageData) {
						   weakSelf.image = image;
					   }
							progress:nil
						   cachePath:cachePath
							cacheKey:cacheKey
						   completed:completedBlock];
}

@end

#endif
