//
//  SPAdView.h
//  shanpai
//
//  Created by liang chunyan on 14-11-18.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  点击广告的响应block
 *
 *  @param index 下标
 *  @param url   网址
 */
typedef void (^clickAtIndex)(NSInteger index,NSString *url);

@interface SPAdView : UIView

@property (strong, nonatomic) NSArray    *dataArray;

@property (nonatomic, copy) clickAtIndex  action;

@end
