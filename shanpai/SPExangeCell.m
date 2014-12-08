//
//  SPExangeCell.m
//  shanpai
//
//  Created by liang chunyan on 14-11-27.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  兑换记录cell

#import "SPExangeCell.h"

@interface SPExangeCell()
@property (weak, nonatomic) IBOutlet UILabel *exangeNAme;
@property (weak, nonatomic) IBOutlet UIImageView *exangeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sendTagImageView;
@property (weak, nonatomic) IBOutlet UILabel *exangeTime;

@end

@implementation SPExangeCell

- (void)awakeFromNib {
    // Initialization code
    [self bringSubviewToFront:self.sendTagImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SPExangeModel *)model
{
    _model = model;
    if (self.model)
    {
        self.exangeNAme.text = self.model.title;
        [self.exangeImageView setImageWithURL:[NSURL URLWithString:self.model.image]];
        NSString *sendName = @"member_record_shop_nosend";
        if ([self.model.exchanged  isEqualToString:@"1"])
        {
            sendName = @"member_record_shop_send";
        }
        self.sendTagImageView.image = [UIImage imageNamed:sendName];
        self.exangeTime.text = self.model.create_time;
    }
}

@end
