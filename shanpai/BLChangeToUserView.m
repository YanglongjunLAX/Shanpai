//
//  BLChangeToUserView.m
//  shanpai
//
//  Created by liang chunyan on 14-11-5.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "BLChangeToUserView.h"
#import "SPUserData.h"

@interface BLChangeToUserView()
//切换头像的View
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation BLChangeToUserView

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
}

//设置圆角
- (void)didMoveToSuperview
{
    self.imageView.clipsToBounds      = YES;
    self.imageView.layer.cornerRadius = CGRectGetWidth(self.imageView.frame)*0.5;
}

- (void)setState:(LoginState)state
{
    _state = state;
    //没有登录
    if (state == 0)
    {
        self.imageView.image = [UIImage imageNamed:@"pk_default_avatar"];
    }//已经登录
    else if (state == 1)
    {
        //url
        NSString *urlStr = [SPUserData spUserInfo].loginInfo[@"avatar"];
        [self.imageView setImageWithURL:[NSURL URLWithString:urlStr]];
    }
}

- (void)updateImage
{
    if (ISLogined)
    {
        NSString *urlStr = [SPUserData spUserInfo].loginInfo[@"avatar"];
        [self.imageView setImageWithURL:[NSURL URLWithString:urlStr]];
    }
    else
    {
        self.imageView.image = [UIImage imageNamed:@"pk_default_avatar"];
    }
}

@end
