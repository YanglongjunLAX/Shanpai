//
//  SPBeanHeadView.h
//  shanpai
//
//  Created by liang chunyan on 14-11-24.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
/*!
 *  页面类型
 */
typedef NS_ENUM(NSInteger, beanType){
    /*!
     *  获取金豆
     */
    spBeanTypeGet    = 0,
    /*!
     *  送金豆
     */
    spBeanTypeSend   = 1,
};

//点击联系人的block
typedef void (^linkman)();

@interface SPBeanHeadView : UIView

@property (nonatomic, assign) beanType  viewType;

@property (nonatomic, copy) linkman splinkman;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, readonly) NSString *money;

@property (nonatomic, readonly) NSString *content;

@end
