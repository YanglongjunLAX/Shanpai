//
//  SPGuessFingerController.h
//  shanpai
//
//  Created by liang chunyan on 14-12-5.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPBaseViewController.h"
#import "SPPKresultModel.h"

@interface SPGuessFingerController : SPBaseViewController
/*!
 *  页面类型
 */
@property (nonatomic, assign) SPpkType controllerType;

/*!
 *  游戏动态接受别人的邀请
 */
@property (nonatomic, strong) SPPKresultModel  *gameDynamicModel;

@end
