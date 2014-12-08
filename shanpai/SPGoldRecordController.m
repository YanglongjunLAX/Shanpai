//
//  SPGoldRecordController.m
//  shanpai
//
//  Created by liang chunyan on 14-12-4.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPGoldRecordController.h"
#import "SPGoldenRecordModel.h"
#import "SPGoldenRecordCell.h"

@interface SPGoldRecordController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray     *dataList;
@property (nonatomic, assign) NSUInteger          pageNumber;
- (void)spgSetTableView;
- (void)loadData;
- (void)reloadData;
- (void)loadMoreData;
@end

@implementation SPGoldRecordController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"金豆记录";
    [self spgSetTableView];
    self.pageNumber = 0;
    [self.tableView triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)dataList
{
    if (!_dataList)
    {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (void)spgSetTableView
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SPGoldenRecordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GodenRecordIden"];
    
    __weak typeof(self) weakSelf  = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf performSelector:@selector(reloadData) withObject:nil afterDelay:1.5f];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf performSelector:@selector(loadMoreData) withObject:nil afterDelay:1.5f];
    }];
}

- (void)loadData
{
    [SPGoldenRecordModel spgRequestGoldenList:self.pageNumber+1 block:^(NSArray *array, NSError *error)
     {
         if (self.pageNumber == 0)
         {
             [self.dataList removeAllObjects];
             [self.tableView reloadData];
         }
         if (array.count > 0)
         {
             [self.dataList addObjectsFromArray:array];
             self.pageNumber++;
             [self.tableView reloadData];
         }
         [self.tableView.infiniteScrollingView stopAnimating];
         [self.tableView.pullToRefreshView stopAnimating];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPGoldenRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GodenRecordIden"];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SPGoldenRecordCell hightForCell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
