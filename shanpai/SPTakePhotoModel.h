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
              block:(void (^)(NSArray *, NSError *))block;

@end
