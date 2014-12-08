//
//  SPFollowCell.m
//  shanpai
//
//  Created by liang chunyan on 14-12-2.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPFollowCell.h"

@interface SPFollowCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

- (void)messageClicked:(UIButton *)button;
@end

@implementation SPFollowCell

- (void)awakeFromNib
{
    //添加点击事件
    [self.messageButton addTarget:self
                           action:@selector(messageClicked:)
                 forControlEvents:UIControlEventTouchUpInside];
}

- (void)setModel:(SPFansModel *)model
{
    _model = model;
    if (self.model)
    {
        if (self.model.avatar.length > 1)
        {
            [self.headImageView setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:[UIImage imageNamed:@"user_header"]];
        }
        else
        {
            self.headImageView.image = [UIImage imageNamed:@"user_header"];
        }
        
        self.nameLabel.text = self.model.nickname;
    }
}

- (void)messageClicked:(UIButton *)button
{
    if (self.action)
    {
        self.action(self.model);
    }
}

@end
