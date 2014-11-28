//
//  SPReSetViewController.h
//  shanpai
//
//  Created by liang chunyan on 14-11-5.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPBaseViewController.h"

typedef NS_ENUM(NSInteger,viewType)
{
    //设置密码
    resetPassward = 0,
    //注册
    registerType
};


@interface SPReSetViewController : SPBaseViewController

@property (nonatomic, assign) viewType controllerType;

@end
