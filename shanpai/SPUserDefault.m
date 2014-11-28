//
//  SPUserDefault.m
//  shanpai
//
//  Created by liang chunyan on 14-11-11.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPUserDefault.h"

@implementation SPUserDefault

+ (SPUserDefault *)standardDefault
{
    static SPUserDefault *_sharedUserDefault = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedUserDefault = [[SPUserDefault alloc] init];
        if (_sharedUserDefault)
        {
            _sharedUserDefault.userdefault = [NSUserDefaults standardUserDefaults];
        }
    });
    return _sharedUserDefault;
}

+ (id)objectForKey:(NSString *)defaultName
{
    return [[self standardDefault].userdefault objectForKey:defaultName];
}

+ (void)setObject:(id)value forKey:(NSString *)defaultName
{
    [[self standardDefault].userdefault setObject:value forKey:defaultName];
}

+ (void)removeObjectForKey:(NSString *)defaultName
{
    [[self standardDefault].userdefault removeObjectForKey:defaultName];
}

@end
