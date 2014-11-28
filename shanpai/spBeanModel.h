//
//  spBeanModel.h
//  shanpai
//
//  Created by liang chunyan on 14-11-24.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  送金豆 求金豆

#import <Foundation/Foundation.h>

@interface spBeanModel : NSObject
/*!
 *  求金豆
 *
 *  @param phone   电话号码
 *  @param money   金豆数量
 *         content 留言
 *  @param success 成功 OR 失败
 */
+ (void)spkGetBeanPhone:(NSString *)phone
                  money:(NSString *)money
                content:(NSString *)content
                success:(void (^)(id responseObject))success;
/*!
 *  送金豆
 *
 *  @param phone   电话
 *  @param money   金豆数量
 *  @param content 留言
 *  @param success 成功 or 失败
 */
+ (void)spkSendBeanPhone:(NSString *)phone
                   money:(NSString *)money
                 content:(NSString *)content
                 success:(void (^)(id responseObject))success;

@end
