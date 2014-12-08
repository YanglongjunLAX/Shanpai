//
//  SPGoldenRecordCell.m
//  shanpai
//
//  Created by liang chunyan on 14-12-4.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPGoldenRecordCell.h"

@interface SPGoldenRecordCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation SPGoldenRecordCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)hightForCell
{
    return 75.0f;
}

- (void)setModel:(SPGoldenRecordModel *)model
{
    _model = model;
    if (self.model)
    {
        self.contentLabel.text = self.model.title;
        self.timeLabel.text    = self.model.created;
    }
}

@end
