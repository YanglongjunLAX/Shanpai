//
//  SPDynamicHasImageCell.m
//  shanpai
//
//  Created by liang chunyan on 14-12-2.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPDynamicHasImageCell.h"

@interface SPDynamicHasImageCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentTime;

@end

@implementation SPDynamicHasImageCell

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (CGFloat)hightForCellWith:(SPDynamicModel *)model
{
    CGFloat result = 0.0f;
    NSString *description = model.idescription;
    
    CGFloat _width = CGRectGetWidth([UIScreen mainScreen].bounds) - 20;
    
    CGSize _textSize = [description boundingRectWithSize:CGSizeMake(_width, 460) options:NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName:[UIFont systemFontOfSize:16],} context:nil].size;

    result = _textSize.height + 20 + 60 + 20 + 20;
    
    return result;
}

- (void)setModel:(SPDynamicModel *)model
{
    _model = model;
    if (self.model)
    {
        self.contentLabel.text = model.idescription;
        [self.contentImageView setImageWithURL:[NSURL URLWithString:model.picture]];
        self.contentTime.text = model.created;
    }
}

@end
