//
//  SPDynamicHasImageCell.h
//  shanpai
//
//  Created by liang chunyan on 14-12-2.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPDynamicModel.h"

@interface SPDynamicHasImageCell : UITableViewCell

@property (nonatomic, strong) SPDynamicModel  *model;

//计算高度
+ (CGFloat)hightForCellWith:(SPDynamicModel *)model;

@end
