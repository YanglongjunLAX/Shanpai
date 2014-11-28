//
//  SPCityViewController.h
//  shanpai
//
//  Created by liang chunyan on 14-11-6.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPBaseViewController.h"

typedef void (^changeCity)(NSString *cityName);

@interface SPCityViewController : SPBaseViewController
/*!
 *  切换城市的block
 */
@property (nonatomic, copy) changeCity  cityChanged;

@end
