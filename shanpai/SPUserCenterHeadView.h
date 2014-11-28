//
//  SPUserCenterHeadView.h
//  shanpai
//
//  Created by liang chunyan on 14-11-12.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  点击事件
 */
typedef void (^attentionClicked)();

typedef void (^funcsClicked)();


@interface SPUserCenterHeadView : UIView

@property (nonatomic, copy) attentionClicked attenBlock;
@property (nonatomic, copy) funcsClicked     funcsBlock;
@property (nonatomic, copy) funcsClicked     changeHeadImage;

/*!
 *  刷新数据
 */
- (void)updateUserInfo;
@end
