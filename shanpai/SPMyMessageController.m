//
//  SPMyMessageController.m
//  shanpai
//
//  Created by liang chunyan on 14-11-25.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  分两个scetion比较好

#import "SPMyMessageController.h"
#import "SPMessageModel.h" //消息model
#import "SPMessageCell.h"
#import "SPMessageController.h"//游戏消息， 系统消息

@interface SPMyMessageController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray   * sectionOne;
@property (nonatomic, strong) NSMutableArray * sectionTwo;
@property (nonatomic, assign) NSInteger pageNumber;

//设置TableView
- (void)spmSetTableView;
/*!
 *  分页请求
 *
 *  @param pageNumber 页数
 *  @param pageSize   每页大小
 */
- (void)spmRequestWith:(NSInteger)pageNumber pageSize:(NSInteger)pageSize;

@end

@implementation SPMyMessageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息";
    
    [self spmSetTableView];
    
    self.pageNumber = 0;
    [self spmRequestWith:self.pageNumber + 1 pageSize:20];
}

- (void)spmSetTableView
{
    self.tableView.delegate     = self;
    self.tableView.dataSource   = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"SPMessageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MessageIdenfi"];
    
    [self.tableView reloadData];
}

- (NSArray *)sectionOne
{
    if (!_sectionOne)
    {
        _sectionOne = @[
                        @"系统消息",
                        @"游戏消息",
                        ];
    }
    return _sectionOne;
}

- (NSMutableArray *)sectionTwo
{
    if (!_sectionTwo)
    {
        _sectionTwo = [[NSMutableArray alloc] init];
    }
    return _sectionTwo;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat result = 0;
    if (indexPath.section == 0)
    {
        result = 70.0;
    }
    else
    {
        result = [SPMessageCell heightOfCell:self.sectionTwo[indexPath.row]];
    }
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 0;
    if (section == 0)
    {
        result = self.sectionOne.count;
    }
    else
    {
        result = self.sectionTwo.count;
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *mCell = nil;
    if (indexPath.section == 0)
    {
        static NSString *cellReuseIdentifier   = @"SectionTwoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellReuseIdentifier];
            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        cell.imageView.image = nil;
        cell.detailTextLabel.text = nil;
        if (indexPath.row == 0)
        {
            cell.imageView.image = [UIImage imageNamed:@"message_system"];
        }
        else if (indexPath.row == 1)
        {
            cell.imageView.image = [UIImage imageNamed:@"message_game"];
        }
        cell.textLabel.text = self.sectionOne[indexPath.row];
        mCell = cell;
    }
    else
    {
        SPMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageIdenfi"];
        cell.model = self.sectionTwo[indexPath.row];
        mCell = cell;
    }
    return mCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == 0)
    {
        title = nil;
    }
    else
    {
        title = @"私密消息";
    }
    return title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        SPMessageController *messageVC = [[SPMessageController alloc] init];
        messageVC.type = indexPath.row;
        [self.navigationController pushViewController:messageVC animated:YES];
    }
}

- (void)spmRequestWith:(NSInteger)pageNumber pageSize:(NSInteger)pageSize
{
    __weak __typeof(self)weakSelf = self;
    [SPMessageModel spmGetChatList:pageNumber listRow:20 type:@"Chatting" block:^(NSArray *array, NSError *error)
     {
         if (weakSelf.pageNumber == 0)
         {
             [weakSelf.sectionTwo removeAllObjects];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (self.sectionTwo.count > 0)
                 {
                     [self.tableView reloadData];
                 }
             });
         }
         [weakSelf.sectionTwo addObjectsFromArray:array];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             if (self.sectionTwo.count > 0)
             {
                 [self.tableView reloadData];
             }
         });
    }];
}

@end
