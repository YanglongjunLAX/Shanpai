//
//  SPMessageCell.m
//  shanpai
//
//  Created by liang chunyan on 14-11-25.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPMessageCell.h"

@interface SPMessageCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation SPMessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightOfCell:(SPMessageModel *)model
{
    CGFloat height = 0;
    NSString  *_content = model.content;
    
    CGFloat _width = CGRectGetWidth([UIScreen mainScreen].bounds) - 20;
    
    CGSize _textSize = [_content boundingRectWithSize:CGSizeMake(_width, 460) options:NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName:[UIFont systemFontOfSize:16],} context:nil].size;

    height = MAX(_textSize.height, 40.0f);
    
    height += 30.0f;
    
    return height;
}

- (void)setModel:(SPMessageModel *)model
{
    _model = model;
    if (self.model)
    {
        self.contentLabel.text = model.content;
        self.timeLabel.text    = model.created;
    }
}

- (void)setDictionary:(NSDictionary *)dictionary
{
    _dictionary = dictionary;
    if (self.dictionary)
    {
        self.contentLabel.text = dictionary[@"content"];
        self.timeLabel.text    = dictionary[@"created"];
    }
}

@end
