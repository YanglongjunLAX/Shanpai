//
//  SPFansModel.h
//  shanpai
//
//  Created by liang chunyan on 14-12-2.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPFansModel : NSObject
/*!
 *  模型属性
 */
@property (nonatomic, strong) NSString   *avatar;
@property (nonatomic, strong) NSString   *buddy_lastuptime;
@property (nonatomic, strong) NSString   *buddyid;
@property (nonatomic, strong) NSString   *dateline;
@property (nonatomic, strong) NSString   *idescription;
@property (nonatomic, strong) NSString   *fans_count;
@property (nonatomic, strong) NSString   *follow_count;
@property (nonatomic, strong) NSString   *grade;
@property (nonatomic, strong) NSString   *group_id;
@property (nonatomic, strong) NSString   *_id;
@property (nonatomic, strong) NSString   *newdynamic;
@property (nonatomic, strong) NSString   *nickname;
@property (nonatomic, strong) NSString   *relation;
@property (nonatomic, strong) NSString   *remark;
@property (nonatomic, strong) NSString   *uid;
/*!
 *  使用字典初始化
 *
 *  @param dictionary 字典
 *
 *  @return 模型
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;
/*!
 *  分页获取粉丝数据
 *
 *  @param pageNum 页数
 *  @param block   回调
 */
+ (void)spfGetFansList:(NSInteger)pageNum
                 block:(void (^)(NSArray *, NSError *))block;
/*!
 *  分页获取我的关注
 *
 *  @param pageNumber 页数
 *  @param block      回调
 */
+ (void)spfGetFollowList:(NSInteger)pageNumber
                   block:(void (^)(NSArray *, NSError *))block;

@end
