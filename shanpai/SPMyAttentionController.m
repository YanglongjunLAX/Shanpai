//
//  SPMyAttentionController.m
//  shanpai
//
//  Created by liang chunyan on 14-12-2.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  关注

#import "SPMyAttentionController.h"
#import "SPFollowCell.h"
#import "SPFansModel.h"
#import "SPDyanmicController.h"

@interface SPMyAttentionController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray     *dataList;
@property (nonatomic, assign) NSUInteger          pageNumber;

- (void)spmSetTableView;
- (void)loadData;
- (void)reloadData;
- (void)loadMoreData;
@end

@implementation SPMyAttentionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的关注";
    [self spmSetTableView];
    self.pageNumber = 0;
//    [self loadData];
    [self.tableView triggerPullToRefresh];
}

- (NSMutableArray *)dataList
{
    if (!_dataList)
    {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (void)spmSetTableView
{
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SPFollowCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"followIden"];
    
    __weak __typeof(self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf performSelector:@selector(reloadData) withObject:nil afterDelay:1.5];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf performSelector:@selector(loadMoreData) withObject:nil afterDelay:1.5];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"followIden";
    SPFollowCell    *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SPFansModel *model = self.dataList[indexPath.row];
    //进入个人动态
    SPDyanmicController *dynamicVC = [[SPDyanmicController alloc] init];
    dynamicVC.userID = model.uid;
    dynamicVC.userInfo = model;
    [self.navigationController pushViewController:dynamicVC animated:YES];
}

- (void)loadData
{
    __weak __typeof(self)weakSelf = self;
    [SPFansModel spfGetFollowList:self.pageNumber + 1 block:^(NSArray *array, NSError *error)
     {
         if (weakSelf.pageNumber == 0)
         {
             [weakSelf.dataList removeAllObjects];
             [weakSelf.tableView reloadData];
         }
         if (array.count > 0)
         {
             [weakSelf.dataList addObjectsFromArray:array];
             [weakSelf.tableView reloadData];
             weakSelf.pageNumber++;
         }
         [weakSelf.tableView.pullToRefreshView stopAnimating];
         [weakSelf.tableView.infiniteScrollingView stopAnimating];
    }];
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

@end
