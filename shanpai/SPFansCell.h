//
//  SPFansCell.h
//  shanpai
//
//  Created by liang chunyan on 14-12-1.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPFansModel.h"

typedef void (^releationFunc)(SPFansModel *model);

@interface SPFansCell : UITableViewCell

@property (nonatomic, strong) SPFansModel   *model;

/*!
 *  点击关系按钮，进入粉丝动态
 */
@property (nonatomic, copy) releationFunc    fansDynamic;

@end
