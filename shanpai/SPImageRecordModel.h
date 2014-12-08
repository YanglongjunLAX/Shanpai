//
//  SPImageRecordModel.h
//  shanpai
//
//  Created by liang chunyan on 14-12-4.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  拍照记录

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface SPImageRecordModel : BaseModel
/*!
 *  拍照记录model !!服务端返回的数据用不到的太多，建议去掉
 */
@property (nonatomic, copy) NSString   *content;
@property (nonatomic, copy) NSString   *create_time;
@property (nonatomic, copy) NSString   *created;
@property (nonatomic, copy) NSString   *iid;
@property (nonatomic, copy) NSString   *image;
@property (nonatomic, copy) NSString   *lat;
@property (nonatomic, copy) NSString   *lng;
@property (nonatomic, copy) NSString   *nickname;
@property (nonatomic, copy) NSString   *photo_id;
@property (nonatomic, copy) NSString   *state;
@property (nonatomic, copy) NSString   *status;
@property (nonatomic, copy) NSString   *title;
@property (nonatomic, copy) NSString   *type;
@property (nonatomic, copy) NSString   *update_time;
@property (nonatomic, copy) NSString   *user_id;

/*!
 *  分页请求
 *
 *  @param pageNumber 页码
 *  @param block      回调
 */
+ (void)spiRequestImageList:(NSUInteger)pageNumber
                      block:(void (^)(NSArray *, NSError *))block;

@end
