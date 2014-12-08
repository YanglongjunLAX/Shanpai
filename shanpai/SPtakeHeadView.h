//
//  SPtakeHeadView.h
//  shanpai
//
//  Created by liang chunyan on 14-11-28.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  点击按钮回调
 */
typedef void (^action)(NSString *content);

@interface SPtakeHeadView : UIView

@property(nonatomic, copy) action   sendAction;
@property(nonatomic, copy) action   noSendAction;

@property(nonatomic, readonly) NSString *content;

@property(nonatomic, strong) UIImage  *image;
/*!
 *  重新设置占位符  旋转的时候会字体拉伸
 */
- (void)reSetPlaceholder;

@end
