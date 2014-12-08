//
//  SPTaskModel.h
//  shanpai
//
//  Created by liang chunyan on 14-11-27.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface SPTaskModel : BaseModel
/*!
 *  任务model
 */
@property (nonatomic, copy) NSString *auto_id;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *cityid;
@property (nonatomic, copy) NSString *created;
@property (nonatomic, copy) NSString *_description;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *listorder;
@property (nonatomic, copy) NSString *module;
@property (nonatomic, copy) NSString *newtitle;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *opentype;
@property (nonatomic, copy) NSString *start_date;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *top_time;
@property (nonatomic, copy) NSString *virtual_hits;

/*!
 *  获取任务的表格数组
 *
 *  @param pageNum  页数
 *  @param pagesize 每个大小
 *  @param block    请求成功的block
 */
+ (void)sptGetTaskList:(NSInteger)pageNum
               listRow:(NSInteger)pagesize
                 block:(void (^)(NSArray *, NSError *))block;

@end
