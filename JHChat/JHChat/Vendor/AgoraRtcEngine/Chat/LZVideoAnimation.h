//
//  LZAnimation.h
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LZVideoAnimation : NSObject
+ (CALayer *)replicatorLayer_Circle;

//波浪
+ (CALayer *)replicatorLayerWaveSize:(CGSize)size;

+ (CALayer *)replicatorLayer_Triangle;

+ (CALayer *)replicatorLayer_Grid;


@end
