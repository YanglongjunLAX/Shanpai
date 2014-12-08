//
//  SPTakePhotoModel.h
//  shanpai
//
//  Created by liang chunyan on 14-11-28.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPTakePhotoModel : NSObject

/*!
 *  拍广告识别
 *
 *  @param image 广告图片
 *  @param block 成功回调函数
 */
+ (void)updateImage:(UIImage *)image
              block:(void (^)(NSDictionary *, NSError *))block;
/*!
 *  图像识别不成功 上传
 *
 *  @param content 内容
 *  @param itemID  返回的id
 *  @param block   结果block
 */
+ (void)uploadAd:(NSString *)content
          itemId:(NSString *)itemID
           block:(void (^)(NSDictionary *, NSError *))block;

@end
