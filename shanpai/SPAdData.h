//
//  SPAdData.h
//  shanpai
//
//  Created by liang chunyan on 14-11-19.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPAdData : NSObject
/*!
 *  服务端返回的广告相关的参数，
 *  很多不知道作用！
 */
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *list_brand;
@property (nonatomic, copy) NSString *list_index;
@property (nonatomic, copy) NSString *list_pk;
@property (nonatomic, copy) NSString *list_store;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *tag_brand;
@property (nonatomic, copy) NSString *tag_index;
@property (nonatomic, copy) NSString *tag_pk;
@property (nonatomic, copy) NSString *tag_store;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *url;

/*!
 *  init with NSDictionary
 *
 *  @param info NSDictionary
 *
 *  @return adobj
 */
- (id)initWithInfo:(NSDictionary *)info;
/*!
 *  获取广告
 *
 *  @param path   路径
 *  @param params 参数
 *  @param block  返回的block，根据error判断是否成功
 */
+(void)getTaskAdWithPath:(NSString *)path
                  params:(NSDictionary*)params
                   block:(void (^)(NSArray *, NSError *))block;
@end
