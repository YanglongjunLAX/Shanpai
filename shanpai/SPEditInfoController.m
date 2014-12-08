//
//  SPEditInfoController.m
//  shanpai
//
//  Created by liang chunyan on 14-12-4.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPEditInfoController.h"
#import "SPModifyInfoController.h"

@interface SPEditInfoController ()<UITableViewDataSource,UITableViewDelegate>
//标题
@property (nonatomic, strong) NSArray  *titles;
//右边标题
@property (nonatomic, strong) NSArray  *detailTitles;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)speSetTableView;
@end

@implementation SPEditInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"编辑资料";
    [self speSetTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSArray *)titles
{
    if (!_titles)
    {
        _titles = @[
                    @"选择性别",
                    @"更改昵称",
                    @"真实姓名",
                    @"手机号码",
                    @"邮政编码",
                    @"收货地址",
                    ];
    }
    return _titles;
}

- (NSArray *)detailTitles
{
//    if (!_detailTitles)
//    {
        _detailTitles = @[
                          [SPUserData userSex],
                          [SPUserData userNickName],
                          [SPUserData userName],
                          [SPUserData phonenum],
                          [SPUserData receive_postcode],
                          [SPUserData receive_address],
                          ];
//    }
    return _detailTitles;
}

- (void)speSetTableView
{
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"identifi";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:iden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    cell.textLabel.text = self.titles[indexPath.row];
    cell.detailTextLabel.text = self.detailTitles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 3)
    {
        [SVProgressHUD showSuccessWithStatus:@"功能还没有实现"];
    }
    else
    {
        SPModifyInfoController  *modiftVC = [[SPModifyInfoController alloc] init];
        switch (indexPath.row)
        {
            case 0:
                modiftVC.modifystyle = SPModifySex;
                break;
            case 1:
                modiftVC.modifystyle = SPModifyNickName;
                break;
            case 2:
                modiftVC.modifystyle = SPModifyName;
                break;
            case 4:
                modiftVC.modifystyle = SPModifyPostNumber;
                break;
            case 5:
                modiftVC.modifystyle = SPModifyPostAdder;
                break;
            default:
                break;
        }
        
        [self.navigationController pushViewController:modiftVC animated:YES];
    }
}

@end
