//
//  SPPoolCell.h
//  shanpai
//
//  Created by liang chunyan on 14-11-26.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPPoolModel.h"

@interface SPPoolCell : UITableViewCell

@property (nonatomic, strong) SPPoolModel *model;

@property (nonatomic, assign) NSUInteger rowNumber;
/*!
 *  高度
 *
 *  @return
 */
+ (CGFloat)hightForCell;

@end
