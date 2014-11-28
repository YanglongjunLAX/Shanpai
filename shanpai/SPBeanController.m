//
//  SPBeanController.m
//  shanpai
//
//  Created by liang chunyan on 14-11-24.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPBeanController.h"
#import "SPBeanHeadView.h"
#import "getFriendListVC.h"
#import "spBeanModel.h"

@interface SPBeanController ()<getFriendPhoneNumDelegate>
//表格，替代scrollView,
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SPBeanHeadView     *headView;

- (void)spcSetTableView;
- (void)spcSetTitle;
//发送
- (void)spBsendAction:(id)sender;
//检查输入内容的合法性
- (BOOL)spbCheck;
@end

@implementation SPBeanController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setBackLeftItem];
    [self spcSetTableView];
    [self spcSetTitle];
    [self configRightItemWithTitle:@"确定" action:@selector(spBsendAction:)];
}

- (void)spcSetTitle
{
    if (self.type == 0)
    {
        self.title = @"送金豆";
        self.headView.viewType = spBeanTypeSend;
    }
    else
    {
        self.title = @"求金豆";
        self.headView.viewType = spBeanTypeGet;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self.headView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.headView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.headView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.headView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
}

- (void)spcSetTableView
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, CGRectGetWidth(self.view.bounds), 170)];
    [self.tableView.tableHeaderView addSubview:self.headView];
}

- (SPBeanHeadView *)headView
{
    if (!_headView)
    {
        NSArray *array = [[NSBundle mainBundle]  loadNibNamed:@"SPBeanHeadView" owner:self options:nil];
        _headView = array[0];
        __weak __typeof(self)weakSelf = self;
        _headView.splinkman = ^{
            getFriendListVC *fvc = [[getFriendListVC alloc] init];
            fvc.Delegate = weakSelf;
            [weakSelf.navigationController pushViewController:fvc animated:YES];
        };
    }
    return _headView;
}

- (void)spBsendAction:(id)sender
{
    if (![self spbCheck])
    {
        return;
    }
    //送金豆
    if (self.type == 0)
    {
        [spBeanModel spkSendBeanPhone:self.headView.phone
                                money:self.headView.money
                              content:self.headView.content
                              success:^(id responseObject) {
                                  if (responseObject != nil)
                                  {
                                      NSDictionary *dic = (NSDictionary *)responseObject;
                                      if ([dic[@"status"] integerValue] == 1)
                                      {
                                          [self.navigationController popViewControllerAnimated:YES];
                                      }
                                  }
                              }];
    }
    else//求金豆
    {
        [spBeanModel spkGetBeanPhone:self.headView.phone
                               money:self.headView.money
                             content:self.headView.content
                             success:^(id responseObject) {
                                 if (responseObject != nil)
                                 {
                                     NSDictionary *dic = (NSDictionary *)responseObject;
                                     if ([dic[@"status"] integerValue] == 1)
                                     {
                                         [self.navigationController popViewControllerAnimated:YES];
                                     }
                                 }
                             }];
    }
}

- (BOOL)spbCheck
{
    NSInteger phoneLength = self.headView.phone.length;
    
    if (phoneLength>11||phoneLength<11)
    {
        [SVProgressHUD showErrorWithStatus:@"手机号码格式有误"];
        return NO;
    }
    if (self.headView.money.length < 1 || [self.headView.money isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"金币数量不能为空"];
        return NO;
    }
    return YES;
}

-(void)getPhoneNum:(NSString*)phoneNum
{
    self.headView.phone = phoneNum;
    NSLog(@"%@",phoneNum);
}

@end
