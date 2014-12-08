//
//  SPFansController.m
//  shanpai
//
//  Created by liang chunyan on 14-12-1.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPFansController.h"
#import "SPDyanmicController.h"
#import "SPFansModel.h"
#import "SPFansCell.h"


@interface SPFansController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, assign) NSUInteger  pageNumber;

- (void)spfSetTableView;
//加载数据
- (void)loadData;
//重新加载数据
- (void)reloadData;
//加载更多数据
- (void)loadMoreData;
@end

@implementation SPFansController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的粉丝";
    
    [self spfSetTableView];
    [self loadData];
}

- (void)spfSetTableView
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SPFansCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"fansIden"];
    
    __weak __typeof(self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf performSelector:@selector(reloadData) withObject:nil afterDelay:1.5f];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf performSelector:@selector(loadMoreData) withObject:nil afterDelay:1.5f];
    }];
}

- (NSMutableArray *)dataList
{
    if (!_dataList)
    {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"fansIden";
    SPFansCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    [SPFansModel spfGetFansList:self.pageNumber + 1 block:^(NSArray *array, NSError *error) {
        if (weakSelf.pageNumber == 0)
        {
            [weakSelf.dataList removeAllObjects];
            [weakSelf.tableView reloadData];
        }
        if (array.copy > 0)
        {
            [weakSelf.dataList addObjectsFromArray:array];
            weakSelf.pageNumber++;
            [weakSelf.tableView reloadData];
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
