//
//  SPPKView.m
//  shanpai
//
//  Created by liang chunyan on 14-12-3.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  pkTaiView

#import "SPPKView.h"
#import "TableViewCell.h"
#import "SPAdView.h"
#import "SPAdData.h"

@interface SPPKView()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//广告栏
@property (nonatomic, strong) SPAdView   *adview;

- (void)sppSettableView;
//加载广告信息
- (void)loadAdInfo;
@end

@implementation SPPKView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self sppSettableView];
    [self loadAdInfo];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    [self.tableView reloadData];
}

- (void)updateConstraints
{
    [super updateConstraints];
    if (self.adview && self.adview.superview)
    {
        [self.adview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.adview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [self.adview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.adview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    }
}

- (void)sppSettableView
{
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 130)];
    headView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headView;
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SPAdView" owner:self options:nil];
    self.adview = array[0];
    if (self.adview)
    {
//        __weak __typeof(self)weakSelf = self;
        self.adview.action = ^(NSInteger index,NSString *url)
        {
//            SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithAddress:url];
//            [weakSelf presentViewController:webViewController animated:YES completion:NULL];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pktaiOpenUrl"
                                                                object:nil
                                                              userInfo:@{
                                                                         @"url" : url
                                                                         }];
        };
    }
    [self.tableView.tableHeaderView addSubview:self.adview];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TableCellIden"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCellIden"];
    
    if (indexPath.row == 0)
    {
        cell.imageName = @"pk_finger_guessing_icon";
        cell.name      = @"猜拳：";
        cell.content   = @"和小伙伴们一起玩剪刀石头布！我等你，你在哪里？";
    }
    else if (indexPath.row == 1)
    {
        cell.imageName = @"pk_jigsaw_icon";
        cell.name      = @"拼图：";
        cell.content   = @"考验眼力与反应速度的时刻到了！";
    }
    else
    {
        cell.imageName = @"pk_guess_figure_icon";
        cell.name      = @"猜图：";
        cell.content   = @"我猜，我猜，我猜猜猜！猜来猜去也要把你猜明白！";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //pkTaiOpenViewController
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pkTaiOpenViewController"
                                                        object:nil
                                                      userInfo:@{
                                                                 @"row" : [NSString stringWithFormat:@"%ld",(long)indexPath.row]
                                                                 }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)loadAdInfo
{
    //请求的路径
    NSString *path = @"AdvertBanners/ls";
    //参数
    NSDictionary *params = @{@"advType":@"pk",@"listRows":@"5"};
    
    [SPAdData getTaskAdWithPath:path params:params block:^(NSArray *array, NSError *error) {
        self.adview.dataArray = array;
    }];
}

@end
