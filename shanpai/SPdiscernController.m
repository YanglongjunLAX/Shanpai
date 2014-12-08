//
//  SP discernController.m
//  shanpai
//
//  Created by liang chunyan on 14-11-28.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  图像识别失败

#import "SPdiscernController.h"
#import "SPtakeHeadView.h"
#import "SPTakePhotoModel.h"

@interface SPdiscernController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SPtakeHeadView     *tableheadView;

- (void)spsSetTableView;
//上传照片
- (void)uploadImage;
//不上传照片
- (void)dontUpload;
@end

@implementation SPdiscernController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图像上传";
    [self spsSetTableView];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.tableheadView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.tableheadView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.tableheadView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.tableheadView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.image && self.tableheadView)
    {
        self.tableheadView.image = self.image;
    }
}

- (void)spsSetTableView
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, CGRectGetWidth(self.view.bounds), 400)];
    self.tableView.tableHeaderView = headView;
    [self.tableView.tableHeaderView addSubview:self.tableheadView];
}

- (SPtakeHeadView *)tableheadView
{
    if (!_tableheadView)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SPtakeHeadView" owner:self options:nil];
        _tableheadView = array[0];
        //循环引用
        __weak __typeof(self)weakSelf = self;
        //上传 || 不上传
        _tableheadView.sendAction = ^(NSString *content){
            [weakSelf uploadImage];
        };
        
        _tableheadView.noSendAction = ^(NSString *content){
            [weakSelf dontUpload];
        };
    }
    return _tableheadView;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.tableheadView reSetPlaceholder];
}

- (void)uploadImage
{
    [SPTakePhotoModel uploadAd:self.tableheadView.content
                        itemId:self.itemID
                         block:^(NSDictionary *info, NSError *eror) {
                             //上传成功
                             if ([info[@"status"] integerValue] == 1)
                             {
                                 [self.navigationController popToRootViewControllerAnimated:YES];
                             }
                         }];
}

- (void)dontUpload
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
