//
//  SPUpdateModel.h
//  shanpai
//
//  Created by liang chunyan on 14-12-12.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  检查更新

#import "BaseModel.h"
/*!
 *  检查更新model,开发完成时候添加到需要模块处
 */
@interface SPUpdateModel : BaseModel
/*!
 *  检查更新
 *
 *  @param block 回调函数
 */
+ (void)spuGetversionBlock:(void (^)(NSDictionary *, NSError *))block;
/*!
 *  得到当前的版本
 *
 *  @return 本地的版本
 */
+ (NSString *)spuGetLocalVersion;
/*!
 *  打开appstroe下载地址
 */
+ (void)openAppStoreUrl;
@end
