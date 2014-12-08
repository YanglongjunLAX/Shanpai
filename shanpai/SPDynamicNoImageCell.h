//
//  SPDynamicNoImageCell.h
//  shanpai
//
//  Created by liang chunyan on 14-12-2.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SPDynamicModel.h"

@interface SPDynamicNoImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) SPDynamicModel *model;

+ (CGFloat)heightForCell:(SPDynamicModel *)model;

@end
