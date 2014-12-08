//
//  SPDynamicNoImageCell.m
//  shanpai
//
//  Created by liang chunyan on 14-12-2.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPDynamicNoImageCell.h"

@implementation SPDynamicNoImageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForCell:(SPDynamicModel *)model
{
    CGFloat result = 0.0f;
    
    NSString *description = model.idescription;
    
    CGFloat _width = CGRectGetWidth([UIScreen mainScreen].bounds) - 20;
    
    CGSize _textSize = [description boundingRectWithSize:CGSizeMake(_width, 460) options:NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName:[UIFont systemFontOfSize:16],} context:nil].size;
    
    result += _textSize.height + 20 + 30;
    
    return result;
}

- (void)setModel:(SPDynamicModel *)model
{
    _model = model;
    if (self.model)
    {
        self.contentLabel.text = model.idescription;
        self.timeLabel.text    = model.created;
    }
}

@end
