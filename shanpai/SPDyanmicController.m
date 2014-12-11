//
//  SPDyanmicController.m
//  shanpai
//
//  Created by liang chunyan on 14-12-2.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPDyanmicController.h"
#import "SPDynamicModel.h"
#import "SPDynamicNoImageCell.h"
#import "SPDynamicHasImageCell.h"
#import "SPDynamicTableHead.h"


@interface SPDyanmicController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//分页
@property (nonatomic, assign) NSUInteger pageNumber;
//
@property (nonatomic, strong) NSMutableArray  *dataList;

//表头
@property (nonatomic, strong) SPDynamicTableHead  *tableHeadView;
- (void)loadData;
- (void)reloadData;
- (void)loadMoreData;
- (void)spdSetTableView;
/*!
 *  根据行为修改表头的按钮标题
 *
 *  @param action 行为
 */
- (void)modifyHeadButtonTitle:(NSString *)action;
@end

@implementation SPDyanmicController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"动态";
    
    self.pageNumber = 0;
    if (self.userID == nil && (self.userInfo != nil))
    {
        self.userID = self.userInfo.uid;
    }
    
    [self spdSetTableView];
    [self.tableView triggerPullToRefresh];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    if (self.tableHeadView && self.tableHeadView.superview)
    {
        [self.tableHeadView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
        [self.tableHeadView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
        [self.tableHeadView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
        [self.tableHeadView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    }
}

- (NSMutableArray *)dataList
{
    if (!_dataList)
    {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (SPDynamicTableHead *)tableHeadView
{
    if (!_tableHeadView)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SPDynamicHead"owner:self options:nil];
        _tableHeadView = nib[0];
        
        __weak __typeof(self)weakSelf = self;
        _tableHeadView.relationAction = ^{
        
            [SPDynamicModel spdSetRelation:weakSelf.userID block:^(NSDictionary *info, NSError *error) {
//                NSLog(@"%@",info);
                //成功
                if ([info[@"status"] integerValue] == 1)
                {
                    [weakSelf modifyHeadButtonTitle:info[@"action"]];
                }
            }];
            
        };
    }
    return _tableHeadView;
}

- (void)loadData
{
    [SPDynamicModel spdGetDynamicList:self.pageNumber
                                  uid:self.userID block:^(NSArray *array, NSError *error){
                                      if (self.pageNumber == 0)
                                      {
                                          [self.dataList removeAllObjects];
                                          [self.tableView reloadData];
                                      }
                                      if (array.count > 0)
                                      {
                                          [self.dataList addObjectsFromArray:array];
                                          [self.tableView reloadData];
                                          self.pageNumber++;
                                      }
                                      [self.tableView.pullToRefreshView stopAnimating];
                                      [self.tableView.infiniteScrollingView stopAnimating];
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

- (void)spdSetTableView
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 100)];
    
    [self.tableView.tableHeaderView addSubview:self.tableHeadView];
    
    if (self.userInfo)
    {
        self.tableHeadView.userInfo = self.userInfo;
    }
    
    __weak __typeof(self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf reloadData];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPDynamicModel *model = self.dataList[indexPath.row];
    UITableViewCell *cell = nil;
    //有图片
    if (model.picture.length > 1)
    {
        static NSString *hasImageIden = @"hasImageIden";
        SPDynamicHasImageCell *hCell = [tableView dequeueReusableCellWithIdentifier:hasImageIden];
        if (!hCell)
        {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SPDynamicHasImageCell" owner:self options:nil];
            hCell = array[0];
            hCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        hCell.model = model;
        cell = hCell;
    }
    //没有图片
    else
    {
        static NSString *noImageIden = @"noImageIden";
        SPDynamicHasImageCell *nCell = [tableView dequeueReusableCellWithIdentifier:noImageIden];
        if (!nCell)
        {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SPDynamicNoImageCell" owner:self options:nil];
            nCell = array[0];
            nCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        nCell.model = model;
        cell = nCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat hight = 0.0f;
    SPDynamicModel *model = self.dataList[indexPath.row];
    if (model.picture.length > 1)
    {
        hight = [SPDynamicHasImageCell hightForCellWith:model];
    }
    else
    {
        hight = [SPDynamicNoImageCell heightForCell:model];
    }
    return hight;
}

- (void)modifyHeadButtonTitle:(NSString *)action
{
    if ([action isEqualToString:@"add"])
    {
        self.tableHeadView.releationTitle = @"取消关注";
    }
    else if ([action isEqualToString:@"rm"])
    {
        self.tableHeadView.releationTitle = @"添加关注";
    }
}

@end
