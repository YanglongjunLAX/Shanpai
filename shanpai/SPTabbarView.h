//
//  SPTabbarView.h
//  shanpai
//
//  Created by liang chunyan on 14-11-4.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^spaction)(NSInteger index);

@interface SPTabbarView : UIView

//点击的Action
@property (nonatomic, copy) spaction action;

@end
