//
//  SPPKresultModel.h
//  shanpai
//
//  Created by liang chunyan on 14-12-10.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "BaseModel.h"

/*!
 *  游戏动态，点击cell时返回的数据模型
 */
@interface SPPKresultModel : BaseModel

@property (nonatomic, copy) NSString  *avatar;
@property (nonatomic, copy) NSString  *code;
@property (nonatomic, copy) NSString  *module;
@property (nonatomic, copy) NSString  *nickname;
@property (nonatomic, copy) NSString  *pk_id;
@property (nonatomic, copy) NSString  *ruserid;
@property (nonatomic, copy) NSString  *state;
@property (nonatomic, copy) NSString  *userid;

/*!
 *  猜拳拒绝
 *
 *  @param pkid       pkid
 *  @param situaction situaction
 *  @param block      回调
 */
+ (void)replyFingerRejectPKId:(NSString *)pkid
                   situaction:(NSString *)situaction
                         type:(NSString *)type
                        block:(void (^)(NSDictionary *, NSError *))block;
/*!
 *  拼图拒绝
 *
 *  @param pKid  pkID
 *  @param model @"GuessPic"
 *  @param block huidiao
 */
+ (void)replyGuessPicRejectPKId:(NSString *)pKid
                          model:(NSString *)model
                          block:(void (^)(NSDictionary *, NSError *))block;

@end
