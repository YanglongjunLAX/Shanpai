//
//  SPGoldenRecordModel.h
//  shanpai
//
//  Created by liang chunyan on 14-12-4.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPGoldenRecordModel : NSObject
/*!
 *  金豆记录属性
 */
@property (nonatomic, copy) NSString    *created;
@property (nonatomic, copy) NSString    *credits;
@property (nonatomic, copy) NSString    *title;

- (id)initWithDictionary:(NSDictionary *)dictionary;
/*!
 *  分页请求
 *
 *  @param pageNumber 页数
 *  @param block      回调
 */
+ (void)spgRequestGoldenList:(NSUInteger)pageNumber
                       block:(void (^)(NSArray *, NSError *))block;

@end
