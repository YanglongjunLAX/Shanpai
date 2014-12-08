//
//  SPDynamicModel.h
//  shanpai
//
//  Created by liang chunyan on 14-12-2.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  动态

#import <Foundation/Foundation.h>

@interface SPDynamicModel : NSObject
/*!
 *  属性
 */
@property (nonatomic, copy) NSString    *avatar;
@property (nonatomic, copy) NSString    *content;
@property (nonatomic, copy) NSString    *created;
@property (nonatomic, copy) NSString    *idescription;
@property (nonatomic, copy) NSString    *fans_count;
@property (nonatomic, copy) NSString    *follow_count;
@property (nonatomic, copy) NSString    *_id;
@property (nonatomic, copy) NSString    *item_id;
@property (nonatomic, copy) NSString    *module;
@property (nonatomic, copy) NSString    *nickname;
@property (nonatomic, copy) NSString    *picture;
@property (nonatomic, copy) NSString    *status;
@property (nonatomic, copy) NSString    *title;
@property (nonatomic, copy) NSString    *uid;
//使用字典进行初始化
- (id)initWithDictionary:(NSDictionary *)dictionary;
/*!
 *  获取用户动态
 *
 *  @param pageNumber 页数
 *  @param uid        用户id
 *  @param block      回调
 */
+ (void)spdGetDynamicList:(NSInteger)pageNumber
                      uid:(NSString *)uid
                   block:(void (^)(NSArray *, NSError *))block;
/*!
 *  设置用户关系
 *
 *  @param userID 用户id
 *  @param block  成功回调
 */
+ (void)spdSetRelation:(NSString *)userID
                 block:(void (^)(NSDictionary *, NSError *))block;
/*!
 *  修改备注名字
 *
 *  @param newName 新备注名字
 *  @param userID  用户id
 *  @param block   回调函数
 */
+ (void)spdModifyNickName:(NSString *)newName
                   userID:(NSString *)userID
                    block:(void (^)(NSDictionary *, NSError *))block;
@end
