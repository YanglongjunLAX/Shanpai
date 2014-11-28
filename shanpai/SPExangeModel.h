//
//  SPExangeModel.h
//  shanpai
//
//  Created by liang chunyan on 14-11-27.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPExangeModel : NSObject
/*!
 *  模型属性
 */
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * create_time;
@property (nonatomic, copy) NSString * credits;
@property (nonatomic, copy) NSString * eid;
@property (nonatomic, copy) NSString * exchange_time;
@property (nonatomic, copy) NSString * exchanged;
@property (nonatomic, copy) NSString * _id;
@property (nonatomic, copy) NSString * image;
@property (nonatomic, copy) NSString * key;
@property (nonatomic, copy) NSString * num;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * surplus;
@property (nonatomic, copy) NSString * tag;
@property (nonatomic, copy) NSString * title;
/*!
 *  使用字典初始化
 *
 *  @param dictionary
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
+ (void)spEGetExangeList:(NSInteger)pageNum
                 block:(void (^)(NSArray *, NSError *))block;

@end
