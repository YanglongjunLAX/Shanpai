//
//  SPGoldenRecordCell.h
//  shanpai
//
//  Created by liang chunyan on 14-12-4.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SPGoldenRecordModel.h"

@interface SPGoldenRecordCell : UITableViewCell

@property (nonatomic, strong) SPGoldenRecordModel  *model;

/*!
 *  cell高度
 */
+ (CGFloat)hightForCell;
@end
