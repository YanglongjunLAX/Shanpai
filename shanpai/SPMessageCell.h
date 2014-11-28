//
//  SPMessageCell.h
//  shanpai
//
//  Created by liang chunyan on 14-11-25.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  消息cell

#import <UIKit/UIKit.h>
#import "SPMessageModel.h"

@interface SPMessageCell : UITableViewCell
//消息model
@property (nonatomic, strong) SPMessageModel   *model;
//消息字典 
@property (nonatomic, strong) NSDictionary     *dictionary;
/*!
 *  cell的高度
 *
 *  @param model model独享
 *
 *  @return cell高度
 */
+ (CGFloat)heightOfCell:(SPMessageModel *)model;

@end
