//
//  SPEnemyController.m
//  shanpai
//
//  Created by liang chunyan on 14-12-8.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  pk台，选择pk好友

#import "SPEnemyController.h"
#import "SPDyanmicController.h"//用户动态
#import "SPFansCell.h"

@interface SPEnemyController ()<UITableViewDataSource,UITableViewDelegate>
//
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSUInteger       pageNumber;
@property (nonatomic, strong) NSMutableArray  *dataList;
//分段选择器
@property (nonatomic, strong) UISegmentedControl *segmentControl;

//关注列表
@property (nonatomic, strong) NSMutableArray   *attentionList;
//最近列表
@property (nonatomic, strong) NSMutableArray   *nearList;
//周边
@property (nonatomic, strong) NSMutableArray   *aroundList;

- (void)speSettableView;
- (void)speSegmenteChanged:(id)sender;

- (void)loadData;
- (void)reloadData;
- (void)loadMoreData;
//请求关注列表
- (void)requestAttention;
//请求最近
- (void)requestNear;
//请求周边
- (void)requestAround;
//当前点击tableView的用户信息
- (SPFansModel *)currentFansModel:(NSInteger)index;
@end

@implementation SPEnemyController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = self.segmentControl;
    self.pageNumber = 0;
    [self speSettableView];
    [self.tableView triggerPullToRefresh];
}

- (void)speSettableView
{
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf performSelector:@selector(reloadData) withObject:nil afterDelay:1.5f];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf performSelector:@selector(loadMoreData) withObject:nil afterDelay:1.5f];
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SPFansCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"fansIden"];
}

- (NSMutableArray *)dataList
{
    if (!_dataList)
    {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (UISegmentedControl *)segmentControl
{
    if (!_segmentControl)
    {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"关注",@"最近",@"周边"]];
        _segmentControl.frame = CGRectMake(0, 0, 200, 40);
        _segmentControl.selectedSegmentIndex = 0;
        [_segmentControl addTarget:self
                            action:@selector(speSegmenteChanged:)
                  forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

//关注
- (NSMutableArray *)attentionList
{
    if (!_attentionList)
    {
        _attentionList = [[NSMutableArray alloc] init];
    }
    return _attentionList;
}

//最近
- (NSMutableArray *)nearList
{
    if (!_nearList)
    {
        _nearList = [[NSMutableArray alloc] init];
    }
    return _nearList;
}

//周边
- (NSMutableArray *)aroundList
{
    if (!_aroundList)
    {
        _aroundList = [[NSMutableArray alloc] init];
    }
    return _aroundList;
}

- (void)speSegmenteChanged:(id)sender
{
    switch (self.segmentControl.selectedSegmentIndex)
    {
        case 0:
        {
            if (self.attentionList.count < 1)
            {
                [self loadData];
            }
        }
            break;
        case 1:
        {
            if (self.nearList.count < 1)
            {
                [self loadData];
            }
        }
            break;
        case 2:
        {
            if (self.aroundList.count < 1)
            {
                [self loadData];
            }
        }
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

- (void)loadData
{
    switch (self.segmentControl.selectedSegmentIndex)
    {
        case 0:
        {
            [self requestAttention];
        }
            break;
        case 1:
        {
            [self requestNear];
        }
            break;
        case 2:
        {
            [self requestAround];
        }
            break;
        default:
            break;
    }
}

- (void)reloadData
{
    self.pageNumber = 0;
    [self loadData];
}

- (void)loadMoreData
{
    [self loadData];
}

//请求关注列表
- (void)requestAttention
{
    __weak typeof(self) weakSelf = self;
    [SPFansModel spfGetFollowList:self.pageNumber + 1 block:^(NSArray *array, NSError *error)
     {
         if (weakSelf.pageNumber == 0)
         {
             [weakSelf.attentionList removeAllObjects];
         }
         if (array.count > 0)
         {
             [weakSelf.attentionList addObjectsFromArray:array];
             weakSelf.pageNumber++;
         }
         [weakSelf.tableView reloadData];
         [weakSelf.tableView.pullToRefreshView stopAnimating];
         [weakSelf.tableView.infiniteScrollingView stopAnimating];
         
    }];
}

//请求最近
- (void)requestNear
{
    __weak typeof(self) weakSelf = self;
    [SPFansModel spfGetNearList:self.pageNumber + 1 block:^(NSArray *array, NSError *error)
     {
         if (weakSelf.pageNumber == 0)
         {
             [weakSelf.nearList removeAllObjects];
         }
         
         if (array.count > 0)
         {
             [weakSelf.nearList addObjectsFromArray:array];
             weakSelf.pageNumber++;
         }
         [weakSelf.tableView reloadData];
         [weakSelf.tableView.pullToRefreshView stopAnimating];
         [weakSelf.tableView.infiniteScrollingView stopAnimating];
    }];
}

//请求周边
- (void)requestAround
{
    __weak typeof(self) weakSelf = self;
    [SPFansModel spfGetAroundList:self.pageNumber+1 block:^(NSArray *array, NSError *error)
     {
         if (weakSelf.pageNumber == 0)
         {
             [weakSelf.aroundList removeAllObjects];
         }
         
         if (array.count > 0)
         {
             [weakSelf.aroundList addObjectsFromArray:array];
             weakSelf.pageNumber++;
         }
         
         [weakSelf.tableView reloadData];
         [weakSelf.tableView.pullToRefreshView stopAnimating];
         [weakSelf.tableView.infiniteScrollingView stopAnimating];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 0;
    switch (self.segmentControl.selectedSegmentIndex)
    {
        case 0:
        {
            result = self.attentionList.count;
        }
            break;
        case 1:
        {
            result = self.nearList.count;
        }
            break;
        case 2:
        {
            result = self.aroundList.count;
        }
            break;
        default:
            break;
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"fansIden";
    SPFansCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    __weak typeof(self) weakSelf = self;
    cell.fansDynamic = ^(SPFansModel *model)
    {
        SPDyanmicController *DyanmicVC = [[SPDyanmicController alloc] init];
        DyanmicVC.userInfo = model;
        [weakSelf.navigationController pushViewController:DyanmicVC animated:YES];
    };
    NSArray *array = nil;
    switch (self.segmentControl.selectedSegmentIndex)
    {
        case 0:
        {
            array = self.attentionList;
        }
            break;
        case 1:
        {
            array = self.nearList;
        }
            break;
        case 2:
        {
            array = self.aroundList;
        }
            break;
        default:
            break;
    }
    
    cell.model = array[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SPFansModel *model = [self currentFansModel:indexPath.row];
    
    if (self.selectFansFuncCall)
    {
        self.selectFansFuncCall(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (SPFansModel *)currentFansModel:(NSInteger)index
{
    NSArray *array = nil;
    switch (self.segmentControl.selectedSegmentIndex)
    {
        case 0:
        {
            array = self.attentionList;
        }
            break;
        case 1:
        {
            array = self.nearList;
        }
            break;
        case 2:
        {
            array = self.aroundList;
        }
            break;
        default:
            break;
    }
    return array[index];
}

@end
