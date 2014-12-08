//
//  SPSetController.m
//  shanpai
//
//  Created by liang chunyan on 14-11-25.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  设置

#import "SPSetController.h"
#import "SVModalWebViewController.h"
#import "SPImageRecordController.h"
#import "SPOpinionBackController.h"

@interface SPSetController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray  *dataList;

- (void)spsSetTableView;
@end

@implementation SPSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self spsSetTableView];
}

- (void)spsSetTableView
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

- (NSArray *)dataList
{
    if (!_dataList)
    {
        _dataList = @[
                      @[@"拍照记录",@"分享"],
                      @[@"意见反馈",@"给我们评分",@"用户协议",@"检查更新",@"关于闪拍",@"使用帮助"],
                      ];
    }
    return _dataList;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.dataList[indexPath.section][indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                SPImageRecordController *imageRecordVC = [[SPImageRecordController alloc] init];
                [self.navigationController pushViewController:imageRecordVC animated:YES];
                break;
            }
            case 1:
            {
                break;
            }
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case 0://意见反馈
            {
                SPOpinionBackController  *opionVC = [[SPOpinionBackController alloc] init];
                [self.navigationController pushViewController:opionVC animated:YES];
                break;
            }
            case 1://给我们评分
            {
                [self openWebsetOut:kForGradeUrl];
                break;
            }
            case 2:
            {
                [self openWebsetInside:kForAgreement];
                break;
            }
            case 5:
            {
                [self openWebsetInside:kForHelpUrl];
                break;
            }
            default:
                break;
        }
    }
}

- (void)openWebsetOut:(NSString *)path
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
}

- (void)openWebsetInside:(NSString *)path
{
    SVModalWebViewController *vc = [[SVModalWebViewController alloc] initWithAddress:path];
    [self presentViewController:vc animated:YES completion:^{
    }];
}

@end
