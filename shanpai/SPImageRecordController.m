//
//  SPImageRecordController.m
//  shanpai
//
//  Created by liang chunyan on 14-12-5.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPImageRecordController.h"
#import "SPImageRecordModel.h"
#import "SPImageRecordCell.h"

@interface SPImageRecordController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray     *dataList;

@property (nonatomic, assign) NSUInteger          pageNumber;

- (void)spiSettableView;
- (void)loadData;
- (void)reloadData;
- (void)loadMoreData;
@end

@implementation SPImageRecordController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"拍照记录";
    self.pageNumber = 0;
    
    [self spiSettableView];
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

- (void)spiSettableView
{
    self.tableView.delegate     = self;
    self.tableView.dataSource   = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SPImageRecordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ImageIden"];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf performSelector:@selector(reloadData)
                       withObject:nil
                       afterDelay:1.5f];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf performSelector:@selector(loadMoreData)
                       withObject:nil
                       afterDelay:1.5f];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPImageRecordCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageIden"];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [SPImageRecordModel spiRequestImageList:self.pageNumber+1
                                      block:^(NSArray *array, NSError *error) {
                                          if (weakSelf.pageNumber == 0)
                                          {
                                              [weakSelf.dataList removeAllObjects];
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [weakSelf.tableView reloadData];
                                              });
                                          }
                                          if (array.count > 0)
                                          {
                                              [weakSelf.dataList addObjectsFromArray:array];
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [weakSelf.tableView reloadData];
                                              });
                                              weakSelf.pageNumber++;
                                          }
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [weakSelf.tableView.pullToRefreshView stopAnimating];
                                              [weakSelf.tableView.infiniteScrollingView stopAnimating];
                                              
                                          });
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
