//
//  getFriendCell.h
//  shanpai5.0
//
//  Created by liang chunyan on 14-4-14.
//  Copyright (c) 2014年 arrowspeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface getFriendCell : UITableViewCell
@property (strong, nonatomic) UIImageView * headImgV;
@property (strong, nonatomic) UIView      * headV;
@property (strong, nonatomic) UIImageView * selectV;
@property (strong, nonatomic) UILabel     * name;
@property (assign, nonatomic) NSInteger   touchCount;

@end
