//
//  SPGuessFingerModel.h
//  shanpai
//
//  Created by liang chunyan on 14-12-5.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  猜拳网络请求在这里处理

#import <Foundation/Foundation.h>

@interface SPGuessFingerModel : NSObject
/*!
 *  请求随机好友信息
 *
 *  @param block 回调
 */
+ (void)spgRequestRandUserInfo:(void (^)(NSDictionary *, NSError *))block;
/*!
 *  开始猜拳
 *
 *  @param type  类型  1 2 3 对应：剪刀，石头，布
 *  @param block
 */
+ (void)spgPKStartAction:(NSString *)type reuserId:(NSString *)ruserid
                   block:(void (^)(NSDictionary *, NSError *))block;

@end
