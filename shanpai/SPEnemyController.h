//
//  SPEnemyController.h
//  shanpai
//
//  Created by liang chunyan on 14-12-8.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPBaseViewController.h"
#import "SPFansModel.h"
/*!
 *  选择好友回调
 *
 *  @param model 好友信息
 */
typedef void (^selectFans)(SPFansModel *model);

@interface SPEnemyController : SPBaseViewController

@property (nonatomic, copy) selectFans  selectFansFuncCall;

@end
