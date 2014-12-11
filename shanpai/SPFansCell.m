//
//  SPFansCell.m
//  shanpai
//
//  Created by liang chunyan on 14-12-1.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPFansCell.h"

@interface SPFansCell()
/*!
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
/*!
 *  名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/*!
 *  关系
 */
@property (weak, nonatomic) IBOutlet UILabel *releationLabel;

//关系label点击事件
- (void)releationTap:(id)sender;
@end

@implementation SPFansCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.releationLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(releationTap:)];
    [self.releationLabel addGestureRecognizer:tapGes];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(SPFansModel *)model
{
    _model = model;
    /*!
     *  设置界面数据
     */
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
        switch ([self.model.relation intValue])
        {
            case 1:
                self.releationLabel.text = @"已关注";
                break;
            case 2:
                self.releationLabel.text = @"加关注";
                break;
            case 3:
                self.releationLabel.text = @"相互关注";
                break;
            default:
                break;
        }
    }
}

- (void)releationTap:(id)sender
{
    if (self.fansDynamic)
    {
        self.fansDynamic(self.model);
    }
}

@end
