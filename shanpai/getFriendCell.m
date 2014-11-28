//
//  getFriendCell.m
//  shanpai5.0
//
//  Created by liang chunyan on 14-4-14.
//  Copyright (c) 2014年 arrowspeed. All rights reserved.
//

#import "getFriendCell.h"
#define HEAD_X 17
#define HEAD_Y 15
#define HEAD_W 50
#define HEAD_H 50
@implementation getFriendCell
@synthesize selectV;
@synthesize headImgV;
@synthesize headV;
@synthesize name;
@synthesize touchCount;

#define WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        touchCount = 0;
        self.headImgV = ({
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(
                                                                                  HEAD_X,
                                                                                  HEAD_Y,
                                                                                  HEAD_W,
                                                                                  HEAD_H)];
            
            imageView.layer.cornerRadius=imageView.frame.size.width/2;
            imageView.layer.masksToBounds=YES;
            imageView;
        });
        [self addSubview:headImgV];
        
        self.name =({
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(HEAD_X+HEAD_W+10,
                                                                       HEAD_Y+13,
                                                                       HEAD_W+70,
                                                                       30)];
        
            [label setTextColor:[UIColor colorWithHexString:@"#333333"]];
            label;
            
        });
        [self addSubview:name];
        
        self.selectV = ({
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(
                                                                                   HEAD_X+260,
                                                                                   HEAD_Y+13,
                                                                                   HEAD_W/2,
                                                                                   HEAD_H/2)];
            
            [imageView setImage:[UIImage imageNamed:@"alarm_check_icon.png"]];
    
            imageView;
        });
        [self addSubview:selectV];
    
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(line, 0.5, 0.5, 0.5, 0.5);
    CGContextMoveToPoint(line,HEAD_X+HEAD_W+10 ,79);
    CGContextAddLineToPoint(line, WIDTH, 79);
    CGContextStrokePath(line);
}

@end
