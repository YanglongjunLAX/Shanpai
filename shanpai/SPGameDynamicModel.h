//
//  SPGameDynamicModel.h
//  shanpai
//
//  Created by liang chunyan on 14-12-3.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 *  请求游戏动态结果
 */
typedef NS_ENUM(NSInteger, SPGameDynamicStyle){
    /*!
     *  错误
     */
    GameStyleError        = -1,
    /*!
     *  胜利
     */
    GameStyleWin          = 0,
    /*!
     *  输
     */
    GameStyleLose         = 1,
    /*!
     *  打平
     */
    GameStylePing         = 2,
};


@interface SPGameDynamicModel : NSObject

@property (nonatomic, copy) NSString  *code;
@property (nonatomic, copy) NSString  *content;
@property (nonatomic, copy) NSString  *create_time;
@property (nonatomic, copy) NSString  *created;
@property (nonatomic, copy) NSString  *_id;
@property (nonatomic, copy) NSString  *module;
@property (nonatomic, copy) NSString  *pk_id;
@property (nonatomic, copy) NSString  *state;
@property (nonatomic, copy) NSString  *title;
/*!
 *  用字典初始化
 *
 *  @param dictionary 字典
 *
 *  @return id
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;
/*!
 *  分页请求数据
 *
 *  @param pageNumber 页数
 *  @param block      完成的回调
 */
+ (void)spgRequestGameDynamicList:(NSUInteger)pageNumber
                            block:(void (^)(NSArray *, NSError *))block;
/*!
 *  请求游戏结果次数
 *
 *  @param style 类型
 *  @param block 完成回调
 */
+ (void)requestGameResultByType:(SPGameDynamicStyle)style
                          block:(void (^)(NSDictionary *, NSError *))block;
@end
