//
//  SPPoolModel.h
//  shanpai
//
//  Created by liang chunyan on 14-11-26.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPPoolModel : NSObject
/*!
 *  属性
 */
@property (nonatomic, copy) NSString  *avatar;
@property (nonatomic, copy) NSString  *cityid;
@property (nonatomic, copy) NSString  *credits;
@property (nonatomic, copy) NSString  *money;
@property (nonatomic, copy) NSString  *nickname;
@property (nonatomic, copy) NSString  *uid;
/*!
 *  初始化
 *
 *  @param dictionary 字典
 *
 *  @return id
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;
/*!
 *  分页获取奖池的数据
 *
 *  @param pageNum 页数
 *  @param block   回调
 */
+ (void)sppGetPoolList:(NSInteger)pageNum
                 block:(void (^)(NSArray *, NSError *))block;

@end
