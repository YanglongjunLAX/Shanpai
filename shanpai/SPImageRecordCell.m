//
//  SPImageRecordCell.m
//  shanpai
//
//  Created by liang chunyan on 14-12-5.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  拍照记录

#import "SPImageRecordCell.h"

@interface SPImageRecordCell()
@property (weak, nonatomic) IBOutlet UIImageView *ContentImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation SPImageRecordCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SPImageRecordModel *)model
{
    _model = model;
    if (self.model)
    {
        [self.ContentImageView setImageWithURL:[NSURL URLWithString:self.model.image]];
        self.timeLabel.text = self.model.created;
    }
}

@end
