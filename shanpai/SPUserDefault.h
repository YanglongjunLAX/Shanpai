//
//  SPUserDefault.h
//  shanpai
//
//  Created by liang chunyan on 14-11-11.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPUserDefault : NSObject

@property (nonatomic, strong) NSUserDefaults  *userdefault;
/*!
 *  全局唯一的
 *
 *  @return
 */
+ (SPUserDefault *)standardDefault;

+ (id)objectForKey:(NSString *)defaultName;
+ (void)setObject:(id)value forKey:(NSString *)defaultName;
+ (void)removeObjectForKey:(NSString *)defaultName;
@end
