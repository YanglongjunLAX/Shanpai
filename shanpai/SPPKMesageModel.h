//
//  SPPKMesageModel.h
//  shanpai
//
//  Created by liang chunyan on 14-11-25.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 *  游戏消息，旧版本请求PK Message 此处为pkModel
 */
@interface SPPKMesageModel : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *created;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *module;
@property (nonatomic, copy) NSString *pk_id;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *title;
/*!
 *  初始化
 *
 *  @param dictionary 字典
 *
 *  @return id
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;

/*!
 *  请求PK消息列表
 *
 *  @param pageNumber 页数
 *  @param listRow    每页的大小
 *  @param block      请求完成的回调
 */
+ (void)spmGetPKMessage:(NSInteger)pageNumber
                listRow:(NSInteger)listRow
                  block:(void (^)(NSArray *, NSError *))block;
@end
