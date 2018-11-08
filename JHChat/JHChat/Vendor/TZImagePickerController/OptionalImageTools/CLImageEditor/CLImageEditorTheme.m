//
//  CLImageEditorTheme.m
//
//  Created by sho yakushiji on 2013/12/05.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLImageEditorTheme.h"

@implementation CLImageEditorTheme

#pragma mark - singleton pattern

static CLImageEditorTheme *_sharedInstance = nil;

+ (CLImageEditorTheme*)theme
{
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CLImageEditorTheme alloc] init];
    });
    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [super allocWithZone:zone];
            return _sharedInstance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.bundleName                     = @"CLImageEditor";
        self.backgroundColor                = [UIColor blackColor];
        self.toolbarColor                   = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];//colorWithWhite:1 alpha:0.8];  [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:0.7]
		self.toolIconColor                  = @"black";
        self.toolbarTextColor               = [UIColor lightGrayColor];
        self.toolbarSelectedButtonColor     = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        self.toolbarTextFont                = [UIFont systemFontOfSize:10];
        self.statusBarStyle                 = UIStatusBarStyleDefault;
    }
    return self;
}

@end
