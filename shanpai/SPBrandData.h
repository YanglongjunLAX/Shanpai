//
//  SPBrandData.h
//  shanpai
//
//  Created by liang chunyan on 14-11-18.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPBrandData : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *created;//时间
@property (nonatomic, copy) NSString *hits;//点击
@property (nonatomic, copy) NSString *_id;//
@property (nonatomic, copy) NSString *jump_url;//跳转url
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *virtual_hits;

/*!
 *  用字典构造品牌数据
 *
 *  @param info 字典
 *
 *  @return 品牌类型
 */
- (id)initWithInfo:(NSDictionary *)info;

/*!
 *  分页请求品牌数据
 *
 *  @param pageNumber 页数
 *  @param pageSize   每页大小
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)requestBrandDatas:(NSInteger)pageNumber
                 pageSize:(NSInteger)pageSize
                  success:(void (^)(NSArray * array))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
