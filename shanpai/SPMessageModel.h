//
//  SPMessageModel.h
//  shanpai
//
//  Created by liang chunyan on 14-11-25.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPMessageModel : NSObject

@property (nonatomic, copy) NSString  * content;
@property (nonatomic, copy) NSString  * created;
@property (nonatomic, copy) NSString  * data;
@property (nonatomic, copy) NSString  * failures;
@property (nonatomic, copy) NSString  * isread;
@property (nonatomic, copy) NSString  * nickname;
@property (nonatomic, copy) NSString  * pmid;
@property (nonatomic, copy) NSString  * recvuid;
@property (nonatomic, copy) NSString  * remark;
@property (nonatomic, copy) NSString  * sended;
@property (nonatomic, copy) NSString  * senduid;
@property (nonatomic, copy) NSString  * status;
@property (nonatomic, copy) NSString  * taskType;
@property (nonatomic, copy) NSString  * title;
@property (nonatomic, copy) NSString  * type;

- (id)initWithDictionary:(NSDictionary *)dictionary;

/*!
 *  请求消息列表
 *
 *  @param pageNum  页数
 *  @param pagesize 每页大小
 *  @param type     类型
 *  @param block    请求完成block
 */
+ (void)spmGetChatList:(NSInteger)pageNum
               listRow:(NSInteger)pagesize
                  type:(NSString *)type
                 block:(void (^)(NSArray *, NSError *))block;

@end
