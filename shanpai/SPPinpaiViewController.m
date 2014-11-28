//
//  SPPinpaiViewController.m
//  shanpai
//
//  Created by liang chunyan on 14-11-6.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPPinpaiViewController.h"
#import "SPBrandData.h"
#import "SPBrandCell.h"
#import "SVModalWebViewController.h"
#import "SPAdView.h"
#import "SPAdData.h"//广告数据

@interface SPPinpaiViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray  *spDataArray;

@property (nonatomic, assign) NSInteger  pageNumber;
@property (nonatomic, strong) UIView   * headView;
@property (nonatomic, strong) SPAdView *adview;

//tabbarView
- (void)configTableView;
/*!
 *  分页加载
 *
 *  @param pageNumber 页数
 *  @param pagesize   长度
 */
- (void)requestDatasPageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pagesize;
- (void)getAdData;
@end

@implementation SPPinpaiViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"品牌";
    [self setCityButton];
    [self setUserCenterButton];
    [self configTableView];
    [self getAdData];
    
    self.pageNumber = 0;
    [self requestDatasPageNumber:self.pageNumber pageSize:10];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    if (self.adview && self.adview.superview)
    {
        [self.adview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.adview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [self.adview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.adview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    }
}

- (void)configTableView
{
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = self.headView;
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SPAdView" owner:self options:nil];
    self.adview = array[0];
    if (self.adview)
    {
        __weak __typeof(self)weakSelf = self;
        self.adview.action = ^(NSInteger index,NSString *url)
        {
            SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithAddress:url];
            [weakSelf presentViewController:webViewController animated:YES completion:NULL];
        };
    }
    [self.headView addSubview:self.adview];
    
    //下拉
    __weak __typeof(self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        weakSelf.pageNumber = 0;
        //设置时间为2
        double delayInSeconds = 2.0;
        //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
        dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        //推迟两纳秒执行
        dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
            [weakSelf requestDatasPageNumber:weakSelf.pageNumber+1 pageSize:20];
        });
    }];
    //上啦
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        
        //设置时间为2
        double delayInSeconds = 2.0;
        //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
        dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        //推迟两纳秒执行
        dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
            [weakSelf requestDatasPageNumber:weakSelf.pageNumber+1 pageSize:20];
        });
    }];
}

#pragma mark - getters
- (UIView *)headView
{
    if (!_headView)
    {
        _headView = [[UIView alloc] init];
        _headView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 130);
    }
    return _headView;
}

- (NSMutableArray *)spDataArray
{
    if (!_spDataArray)
    {
        _spDataArray = [[NSMutableArray alloc] init];
    }
    return _spDataArray;
}

#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.spDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPBrandCell  *cell=[[[NSBundle mainBundle]loadNibNamed:@"pinPaiCell" owner:self options:nil]firstObject];
    cell.spObj = self.spDataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SPBrandData  *dataObj = self.spDataArray[indexPath.row];
    
    NSString *urlString = dataObj.url;
    urlString = [NSString earseSpace:urlString];
    
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithAddress:urlString];
    [self presentViewController:webViewController animated:YES completion:NULL];
}

#pragma mark - private Method
- (void)requestDatasPageNumber:(NSInteger)pageNumber pageSize:(NSInteger)pagesize
{
    __weak __typeof(self)weakSelf = self;
    [SPBrandData requestBrandDatas:pageNumber
                          pageSize:pagesize
                           success:^(NSArray *array) {
                               if (weakSelf.pageNumber == 0)
                               {
                                   [weakSelf.spDataArray removeAllObjects];
                               }
                               [weakSelf.spDataArray addObjectsFromArray:array];
                               if (array.count > 0)
                               {
                                   weakSelf.pageNumber++;
                               }
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [weakSelf.tableView reloadData];
                               });
                               [weakSelf.tableView.pullToRefreshView stopAnimating];
                               [weakSelf.tableView.infiniteScrollingView stopAnimating];
                           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                               dispatch_async(dispatch_get_main_queue(), ^{
//                                   [weakSelf showTipMessage:@"获取列表失败"];
                                   [SVProgressHUD showErrorWithStatus:@"获取失败"];
                               });
                               [weakSelf.tableView.pullToRefreshView stopAnimating];
                               [weakSelf.tableView.infiniteScrollingView stopAnimating];
                           }];
}

- (void)getAdData
{
    //请求的路径
    NSString *path = @"AdvertBanners/ls";
    //参数
    NSDictionary *params = @{@"advType":@"brand",@"listRows":@"5"};
    
    [SPAdData getTaskAdWithPath:path params:params block:^(NSArray *array, NSError *error) {
//        NSLog(@"%@",array);
        self.adview.dataArray = array;
    }];
    
}

@end
