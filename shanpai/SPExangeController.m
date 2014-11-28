//
//  SPExangeController.m
//  shanpai
//
//  Created by liang chunyan on 14-11-27.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  兑换记录

#import "SPExangeController.h"
#import "SPExangeModel.h"
#import "SPExangeCell.h"
#import "SVModalWebViewController.h"

//表格高度
#define TableCellHight  240.0f

@interface SPExangeController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (nonatomic, assign) NSUInteger  pageNumber;

- (void)speSetTableView;
//加载数据
- (void)loadListData;
@end

@implementation SPExangeController

- (void)viewDidLoad
{
    self.title = @"兑换记录";
    [super viewDidLoad];
    self.pageNumber = 0;
    [self speSetTableView];
    [self loadListData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *)dataList
{
    if (!_dataList)
    {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (void)speSetTableView
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SPExangeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ExangeIden"];
    __weak __typeof(self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        weakSelf.pageNumber = 0;
        [weakSelf loadListData];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadListData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"ExangeIden";
    SPExangeCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

//设定表单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TableCellHight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SPExangeModel *model = self.dataList[indexPath.row];
    
    NSString *path = @"http://shanpai.iushare.com/Api/";
    NSString *urlStr = [NSString stringWithFormat:@"%@Store/show/id/%@",path,model._id];
    SVModalWebViewController *vc = [[SVModalWebViewController alloc] initWithAddress:urlStr];
    [self presentViewController:vc animated:YES completion:^{
    }];
}


- (void)loadListData
{
    [SPExangeModel spEGetExangeList:self.pageNumber+1 block:^(NSArray *array, NSError *error)
     {
         if (self.pageNumber == 0)
         {
             [self.dataList removeAllObjects];
         }
         if (array.count > 0)
         {
             self.pageNumber++;
             [self.dataList addObjectsFromArray:array];
         }
         [self.tableView reloadData];
         [self.tableView.pullToRefreshView stopAnimating];
         [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

@end
