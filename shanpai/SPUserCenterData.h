//
//  SPUserCenterData.h
//  shanpai
//
//  Created by liang chunyan on 14-11-21.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  个人中心网络事件

#import <Foundation/Foundation.h>

@interface SPUserCenterData : NSObject

/*!
 *  上传头像
 *
 *  @param image 头像
 *  @param block 上传完成block
 */
+ (void)updateHeadImage:(UIImage *)image
                       block:(void (^)(NSDictionary *, NSError *))block;
/*!
 *  打卡！！！打卡只用用户信息，不用参数回调
 */
+ (void)signIn;
/*!
 *  请求本周送金豆的次数
 *
 *  @param block 请求成功回调
 */
+ (void)spkGetSendNumber:(void (^)(NSDictionary *, NSError *))block;
@end
