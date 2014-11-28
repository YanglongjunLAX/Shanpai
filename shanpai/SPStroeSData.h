//
//  SPStroeSData.h
//  shanpai
//
//  Created by liang chunyan on 14-11-19.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPStroeSData : NSObject
/*!
 *  商城数据
 */
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *created;
@property (nonatomic, copy) NSString *credits;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *surplus;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *title;
/*!
 *  init use Dictionary
 *
 *  @param dictionary Dictionary
 *
 *  @return id
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;
/*!
 *  获取商城的数组数据
 *
 *  @param path   路径
 *  @param params 请求参数
 *  @param block  成功返回的block
 */
+(void)getStoreDatasWithPath:(NSString *)path
                  params:(NSDictionary*)params
                   block:(void (^)(NSArray *, NSError *))block;

@end
