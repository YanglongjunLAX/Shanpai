//
//  SPjindouCell.h
//  shanpai
//
//  Created by liang chunyan on 14-11-21.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^jinDouAction)();

@interface SPjindouCell : UITableViewCell

@property (nonatomic, copy) jinDouAction leftAction;

@property (nonatomic, copy) jinDouAction rightAction;

@end
