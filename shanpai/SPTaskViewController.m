//
//  SPTaskViewController.m
//  shanpai
//
//  Created by liang chunyan on 14-11-5.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPTaskViewController.h"
#import "SPTaskADView.h"
#import "SPTaskCell.h"
#import "SPTaskModel.h"
#import "SPTaskBeginController.h"

@interface SPTaskViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) SPTaskADView *adView;
@property (strong, nonatomic) NSMutableArray *dataList;

//分页请求页数
@property (assign, nonatomic) NSInteger  pageNumber;

//更新钱包数目
- (void)updateMoneyNumber;
//更新奖池的数目
- (void)updateRewardNumber:(NSString *)reward;
//设置表头
- (void)configTabHead;
- (void)sptSetTableView;
//加载
- (void)loadData;
@end

@implementation SPTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"任务";
    [self setCityButton];
    [self setUserCenterButton];
    [self updateRewardNumber:@""];
    [self configTabHead];
    self.pageNumber = 0;
    [self sptSetTableView];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar];
    [self updateMoneyNumber];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
}

- (NSMutableArray *)dataList
{
    if (!_dataList)
    {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

#pragma mark - private Method
//更新钱包数目
- (void)updateMoneyNumber
{
    //登录
    if (ISLogined)
    {
        NSString *creadits = [SPUserData spUserInfo].loginInfo[@"credits"];
        NSUInteger length = [creadits length];
        if (length > 4) {
            NSString *str = [creadits substringToIndex:length-4];
            
            creadits = [NSString stringWithFormat:@"%@W",str];
        }
        self.moneyLabel.text = creadits;
    }
    else
    {
        self.moneyLabel.text = @"0";
    }
}

//更新奖池的数目
- (void)updateRewardNumber:(NSString *)reward
{
    if (ISLogined)
    {
        NSString *money = [SPUserData spUserInfo].loginInfo[@"money"];
        NSUInteger length = [money length];
        if (length > 4) {
            NSString *str = [money substringToIndex:length-4];
            money = [NSString stringWithFormat:@"%@W",str];
        }
        self.rewardLabel.text = money;
    }
    else
    {
        self.rewardLabel.text = @"0";
    }
}

- (void)sptSetTableView
{
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SPTaskCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TaskIden"];
    [self.tableView reloadData];
    __weak __typeof(self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        weakSelf.pageNumber = 0;
        [weakSelf performSelector:@selector(loadData) withObject:nil afterDelay:1.5];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf performSelector:@selector(loadData) withObject:nil afterDelay:1.5];
    }];
}

- (void)configTabHead
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskIden"];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (ISLogined)
    {
        SPTaskModel *model = self.dataList[indexPath.row];
        
        NSString *module = model.module;
        if([module isEqualToString:@"TestPaper"])//答题
        {
            SPTaskBeginController *taskBeginVC = [[SPTaskBeginController alloc] init];
            taskBeginVC.model = model;
            taskBeginVC.type = SPTaskTestPaper;
            [self presentViewControllerWithNavc:taskBeginVC];
        }
        else if ([module isEqualToString:@"Questionnaire"])
        {
            SPTaskBeginController *taskBeginVC = [[SPTaskBeginController alloc] init];
            taskBeginVC.model = model;
            taskBeginVC.type = SPTaskQuestionnaire;
            [self presentViewControllerWithNavc:taskBeginVC];
        }
    }
    else
    {
        [self pressentToLoginViewController];
    }
}

- (void)loadData
{
    [SPTaskModel sptGetTaskList:self.pageNumber+1 listRow:20 block:^(NSArray *array, NSError *eror)
     {
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

@end
