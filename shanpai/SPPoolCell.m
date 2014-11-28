//
//  SPPoolCell.m
//  shanpai
//
//  Created by liang chunyan on 14-11-26.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPPoolCell.h"

#define kForHightCell    70.0f

@interface SPPoolCell()
@property (weak, nonatomic) IBOutlet UILabel *row;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *number;

@end

@implementation SPPoolCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.backgroundView = [[UIView alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(SPPoolModel *)model
{
    _model = model;
    self.nameLabel.text = model.nickname;
    self.number.text = model.money;
    if (model.avatar != nil)
    {
        [self.headImage setImageWithURL:[NSURL URLWithString:model.avatar]];
    }
}

- (void)setRowNumber:(NSUInteger)row
{
    _rowNumber = row;
    self.row.text = [NSString stringWithFormat:@"%li",row + 1];
    switch (row)
    {
        case 0:
            self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#fee9a8"];
            break;
        case 1:
            self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#fef4d1"];
            break;
        case 2:
            self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#fffaec"];
            break;
        default:
            self.backgroundView.backgroundColor = [UIColor clearColor];
            break;
    }
}

+ (CGFloat)hightForCell
{
    return kForHightCell;
}


@end
