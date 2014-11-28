//
//  SPPKPoolController.m
//  shanpai
//
//  Created by liang chunyan on 14-11-26.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPPKPoolController.h"
#import "SPPoolCell.h"
#import "SPPoolModel.h"

@interface SPPKPoolController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *poolNumber;
@property (weak, nonatomic) IBOutlet UIButton *gainButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray  *dataList;

@property (nonatomic, assign) NSInteger  pageNumber;

/*!
 *  设置tableView
 */
- (void)sppSetTableView;
- (void)loadList;
- (void)loadMore;
- (void)shoudou:(UIButton *)button;
@end

@implementation SPPKPoolController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"奖池排行";
    self.pageNumber = 0;
    self.poolNumber.text = [SPUserData money];
    [self sppSetTableView];
    [self loadList];
    
    [self.gainButton addTarget:self
                        action:@selector(shoudou:)
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
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

- (void)sppSetTableView
{
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"SPPoolCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"poolIdenfi"];
    __weak __typeof(self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf performSelector:@selector(loadList) withObject:nil afterDelay:1.5];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf performSelector:@selector(loadMore) withObject:nil afterDelay:1.5];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPPoolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"poolIdenfi"];
    cell.model = self.dataList[indexPath.row];
    cell.rowNumber = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SPPoolCell hightForCell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)loadList
{
    self.pageNumber = 0;
    [SPPoolModel sppGetPoolList:self.pageNumber+1 block:^(NSArray *array, NSError *error) {
        if (array != nil && array.count > 0)
        {
            self.pageNumber +=1;
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:array];
            [self.tableView reloadData];
        }
        
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

- (void)loadMore
{
    [SPPoolModel sppGetPoolList:self.pageNumber+1 block:^(NSArray *array, NSError *error) {
        if (array != nil && array.count > 0)
        {
            self.pageNumber +=1;
            [self.dataList addObjectsFromArray:array];
            [self.tableView reloadData];
        }
        
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

- (void)shoudou:(UIButton *)button
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定收取奖池的金豆？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        NSMutableDictionary  *pars = [[NSMutableDictionary alloc] init];
        [pars setValue:[SPUserData userID] forKey:@"userid"];
        
        [SVProgressHUD show];
        [[SPHttpClient manager] GET:@"Member/recover"
                         parameters:pars
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"%@",responseObject);
                                [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
                            }
                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [SVProgressHUD dismiss];
                                });
                            }];
    }
}

@end
