//
//  spStoreHeadView.h
//  shanpai
//
//  Created by liang chunyan on 14-11-20.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  商城

#import <UIKit/UIKit.h>

/*!
 *  点击广告的响应block
 *
 *  @param index 下标
 *  @param url   网址
 */
typedef void (^clickAtIndex)(NSInteger index,NSString *url);


@interface spStoreHeadView : UICollectionReusableView


@property (strong, nonatomic) NSArray    *dataArray;

@property (nonatomic, copy) clickAtIndex  action;

@end
