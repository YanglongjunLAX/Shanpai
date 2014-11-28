//
//  SPMessageController.m
//  shanpai
//
//  Created by liang chunyan on 14-11-25.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPMessageController.h"
#import "SPMessageCell.h"
#import "SPPKMesageModel.h"

@interface SPMessageController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray   *dataList;
@property (assign, nonatomic) NSInteger  pageNumber;

- (void)spmSetTableView;
/*!
 *  分页获取 游戏消息
 *
 *  @param pageNumber 页数
 *  @param pageSize   每页的大小
 */
- (void)spmGetPKMessage:(NSInteger)pageNumber
               pageSize:(NSInteger)pageSize;
/*!
 *  分页请求 系统消息
 *
 *  @param pageNumber 页数
 *  @param pageSize   每页大小
 */
- (void)spmRequestWith:(NSInteger)pageNumber pageSize:(NSInteger)pageSize;
/*!
 *  加载数据
 */
- (void)loadList;
/*!
 *  加载更多
 */
- (void)loadMore;
@end

@implementation SPMessageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pageNumber = 0;
    [self spmSetTableView];
    [self loadList];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"SPMessageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MessageIdenfi"];
    
    __weak __typeof(self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf performSelector:@selector(loadList) withObject:nil afterDelay:1];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf performSelector:@selector(loadMore) withObject:nil afterDelay:1.0];
    }];
}

- (void)setType:(NSInteger)type
{
    _type = type;
    if (self.type == 0)
    {
        self.title = @"系统消息";
    }
    else if (self.type == 1)
    {
        self.title = @"游戏消息";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageIdenfi"];
    
    if (self.type == 1)
    {
        cell.dictionary = self.dataList[indexPath.row];
    }
    else
    {
        cell.model = self.dataList[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)spmGetPKMessage:(NSInteger)pageNumber pageSize:(NSInteger)pageSize
{
    __weak __typeof(self)weakSelf = self;
    [SPPKMesageModel spmGetPKMessage:self.pageNumber listRow:20 block:^(NSArray *array, NSError *error)
     {
         [weakSelf.tableView.pullToRefreshView stopAnimating];
         if (self.pageNumber == 0)
         {
             [self.dataList removeAllObjects];
             [self.tableView reloadData];
         }
         [self.dataList addObjectsFromArray:array];
         if (array.count > 0)
         {
             self.pageNumber++;
             [self.tableView reloadData];
         }
    }];
}

- (void)loadList
{
    self.pageNumber = 0;
    if (self.type == 0)
    {
        [self spmRequestWith:self.pageNumber pageSize:20];
    }
    else
    {
        [self spmGetPKMessage:self.pageNumber + 1 pageSize:20];
    }
}

- (void)spmRequestWith:(NSInteger)pageNumber pageSize:(NSInteger)pageSize
{
    __weak __typeof(self)weakSelf = self;
    [SPMessageModel spmGetChatList:pageNumber listRow:20 type:@"System" block:^(NSArray *array, NSError *error)
     {
         [weakSelf.tableView.pullToRefreshView stopAnimating];
         if (weakSelf.pageNumber == 0)
         {
             [weakSelf.dataList removeAllObjects];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (self.dataList.count > 0)
                 {
                     self.pageNumber++;
                     [self.tableView reloadData];
                 }
             });
         }
         [weakSelf.dataList addObjectsFromArray:array];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             if (self.dataList.count > 0)
             {
                 [self.tableView reloadData];
             }
         });
     }];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.tableView beginUpdates];
    [self.tableView reloadData];
    [self.tableView endUpdates];
}

- (void)loadMore
{
    if (self.type == 0)
    {
        [self spmRequestWith:self.pageNumber pageSize:20];
    }
    else
    {
        [self spmGetPKMessage:self.pageNumber + 1 pageSize:20];
    }
}

@end
