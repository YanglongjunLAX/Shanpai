//
//  SPCityData.h
//  shanpai
//
//  Created by liang chunyan on 14-11-10.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPCityData : NSObject
@property (nonatomic, copy) NSString  *arrchild_id;
@property (nonatomic, copy) NSString  *arrparent_id;
@property (nonatomic, copy) NSString  *cat_id;
@property (nonatomic, copy) NSString  *cat_name;
@property (nonatomic, copy) NSString  *child;
@property (nonatomic, copy) NSString  *clat;
@property (nonatomic, copy) NSString  *clng;
@property (nonatomic, copy) NSString  *create_time;
@property (nonatomic, copy) NSString  *firstletter;
@property (nonatomic, copy) NSString  *image;
@property (nonatomic, copy) NSString  *level;
@property (nonatomic, copy) NSString  *listorder;
@property (nonatomic, copy) NSString  *parent_id;
@property (nonatomic, copy) NSString  *status;
/*!
 *  初始化
 *
 *  @param info
 *
 *  @return
 */
- (id)initWithInfo:(NSDictionary *)info;

/*!
 *  请求城市列表
 *
 *  @param pageNumber 开始
 *  @param pageSize   列表大小
 *  @param success    成功
 *  @param failure    失败
 */
+ (void)getCityList:(NSInteger)pageNumber
           pageSize:(NSInteger)pageSize
            success:(void (^)(NSInteger status, NSDictionary *info))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
