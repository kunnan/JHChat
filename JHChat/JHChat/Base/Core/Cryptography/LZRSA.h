//
//  LZRSA.h
//  LeadingCloudFramework
//
//  Created by admin on 15/11/9.
//  Copyright © 2015年 LeadingSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZRSA : NSObject
-(NSString*)encrypt:(NSString*)modulus exponent:(NSString*)exponent content:(NSString*)content;
@end
