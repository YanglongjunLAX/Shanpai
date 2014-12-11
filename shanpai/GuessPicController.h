//
//  GuessPicController.h
//  shanpai
//
//  Created by liang chunyan on 14-12-9.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPBaseViewController.h"
#import "SPPKresultModel.h"

@interface GuessPicController : SPBaseViewController

@property (nonatomic, assign) SPpkType  controllerType;

@property (nonatomic, strong) SPPKresultModel  *gameDynamicModel;

@end
