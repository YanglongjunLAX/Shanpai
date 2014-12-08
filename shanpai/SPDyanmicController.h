//
//  SPDyanmicController.h
//  shanpai
//
//  Created by liang chunyan on 14-12-2.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPBaseViewController.h"
#import "SPFansModel.h"

@interface SPDyanmicController : SPBaseViewController
/*!
 *  要显示动态的用户id
 */
@property (nonatomic, copy) NSString *userID;
/*!
 *  用户信息
 */
@property (nonatomic, strong) SPFansModel  *userInfo;

@end
