//
//  SPGameDynamicView.m
//  shanpai
//
//  Created by liang chunyan on 14-12-3.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPGameDynamicView.h"
#import "SPGameDynamicCell.h"
#import "SPGameDynamicModel.h"

#import "SPGameDynamicHeadView.h"

@interface SPGameDynamicView()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray     *dataList;
@property (nonatomic, assign) NSUInteger          pageNumber;
@property (nonatomic, strong) SPGameDynamicHeadView  *tableViewHead;

- (void)spgSetTableView;
- (void)loadData;
- (void)reloadData;
- (void)loadMoreData;
@end

@implementation SPGameDynamicView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self spgSetTableView];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
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

- (SPGameDynamicHeadView *)tableViewHead
{
    if (!_tableViewHead)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SPGameDynamicHeadView" owner:self options:nil];
        _tableViewHead = nibs[0];
    }
    return _tableViewHead;
}

- (void)spgSetTableView
{
    self.tableView.delegate    = self;
    self.tableView.dataSource  = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 100)];
    self.tableView.tableHeaderView = headView;
    [self.tableView.tableHeaderView addSubview:self.tableViewHead];
    
    if (self.tableViewHead && self.tableViewHead.superview)
    {
        [self.tableViewHead autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
        [self.tableViewHead autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
        [self.tableViewHead autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
        [self.tableViewHead autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SPGameDynamicCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GameDynamic"];
    
    __weak __typeof(self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
//        [weakSelf reloadData];
        [weakSelf performSelector:@selector(reloadData) withObject:nil afterDelay:1.5f];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
//        [weakSelf loadMoreData];
        [weakSelf performSelector:@selector(loadMoreData) withObject:nil afterDelay:1.5f];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString   *iden = @"GameDynamic";
    SPGameDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

- (void)loadData
{
    __weak __typeof(self)weakSelf = self;
    [SPGameDynamicModel spgRequestGameDynamicList:self.pageNumber + 1
                                            block:^(NSArray *array, NSError *error){
                                                if (weakSelf.pageNumber == 0)
                                                {
                                                    [weakSelf.dataList removeAllObjects];
                                                    // 主线程执行：
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        // something
                                                        [weakSelf.tableView reloadData];
                                                    });

                                                }
                                                if (array.count > 0)
                                                {
                                                    [weakSelf.dataList addObjectsFromArray:array];
                                                    
                                                    weakSelf.pageNumber++;
                                                    // 主线程执行：
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        // something
                                                        [weakSelf.tableView reloadData];
                                                    });

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
