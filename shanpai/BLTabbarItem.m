
//
//  Created by mj on 13-4-21.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "BLTabbarItem.h"

@interface BLTabbarItem() {

    NSString *_title;
}

@end


@implementation BLTabbarItem

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
    {
        self.adjustsImageWhenHighlighted = NO;
        self.imageView.contentMode = UIViewContentModeCenter;
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return self;
}

// 去掉高亮效果
- (void)setHighlighted:(BOOL)highlighted{}

#pragma mark 设置标题和图标
- (void)setTitle:(NSString *)title icon:(NSString *)icon
{
    _title = title;
    // 1.设置图片
    [self setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:[icon fileNameAppendString:@"_current"]] forState:UIControlStateSelected];
    
    // 2.设置文字
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithHexString:@"#f37530"] forState:UIControlStateSelected];
    
    
    //文本尺寸
    CGSize textSize = [self.currentTitle sizeWithAttributes: @{NSFontAttributeName:self.titleLabel.font}];
    self.imageEdgeInsets = UIEdgeInsetsMake(-6, textSize.width, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(self.currentImage.size.height + 3, -self.currentImage.size.width , 0, 0);
}
@end