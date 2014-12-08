//
//  SPFollowCell.h
//  shanpai
//
//  Created by liang chunyan on 14-12-2.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPFansModel.h"

typedef void (^messageAction)(SPFansModel *model);

@interface SPFollowCell : UITableViewCell

@property (nonatomic, strong) SPFansModel    *model;

//点击私信按钮
@property (nonatomic, copy) messageAction    action;

@end
