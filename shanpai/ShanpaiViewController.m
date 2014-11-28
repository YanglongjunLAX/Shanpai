//
//  ShanpaiViewController.m
//  shanpai
//
//  Created by liang chunyan on 14-11-6.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "ShanpaiViewController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "SPTakePhotoModel.h"
#import "SVModalWebViewController.h"

@interface ShanpaiViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray  *dataList;

@property (nonatomic, strong) UIButton *takePhoto;
@property (nonatomic, strong) UIImage  *sourceImage;

- (void)spsSetTableView;
//拍照
- (void)takePhotoAction:(UIButton *)button;
//上传图片去识别
- (void)upLoadImage;
@end

@implementation ShanpaiViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"闪拍";
    [self spsSetTableView];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self.takePhoto autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [self.takePhoto autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [self.takePhoto autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar];
}

- (UIButton *)takePhoto
{
    if (!_takePhoto)
    {
        _takePhoto = [[UIButton alloc] init];
        [_takePhoto setTitle:@"开始拍照" forState:UIControlStateNormal];
        [_takePhoto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_takePhoto setBackgroundImage:[UIImage imageNamed:@"pai_btn"] forState:UIControlStateNormal];
        [_takePhoto addTarget:self action:@selector(takePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takePhoto;
}

- (void)spsSetTableView
{
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, CGRectGetWidth(self.view.bounds), 50)];
    self.tableView.tableFooterView = footView;
    [self.tableView.tableFooterView addSubview:self.takePhoto];
}

- (NSArray *)dataList
{
    if (!_dataList)
    {
        
        _dataList = @[
                      @"1.请确认手机照相机可以正常工作",
                      @"2.找到拍摄的广告图片",
                      @"3.开启拍照界面，把你的手机镜头对准任务目标",
                      @"4.按下\"啪\"拍下图像即可",
                      ];
    }
    return _dataList;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellReuseIdentifier   = @"shanpai";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellReuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.imageView.image = nil;
    cell.detailTextLabel.text = nil;
    
    cell.textLabel.text = self.dataList[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"如何使用闪拍";
}

- (void)takePhotoAction:(UIButton *)button
{
    if (!ISLogined)
    {
        [self pressentToLoginViewController];
    }
    else
    {
        //启用拍照功能
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }
    }
}

//选择图片代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak __typeof(self)weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
//        [SVProgressHUD show];
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        //保存照片到百灵闪拍相册中
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library saveImage:image toAlbum:kForAppName withCompletionBlock:^(NSError *error) {
            
        }];
        weakSelf.sourceImage = image;
        [self performSelector:@selector(upLoadImage)
                   withObject:nil
                   afterDelay:0.5];
    }];
}

- (void)upLoadImage
{
    [SPTakePhotoModel updateImage:self.sourceImage block:^(NSArray *array, NSError *error) {
        //识别不成功
        if (error || array == nil)
        {
            
        }
        else
        {
            __block NSString *url = nil;
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                if ([dic[@"type"] isEqualToString:@"url"] && dic[@"url"] != nil)
                {
                    url = dic[@"url"];
                    *stop = YES;
                }
            }];
            SVModalWebViewController *webVC = [[SVModalWebViewController alloc] initWithAddress:url];
            [self presentViewControllerWithNavc:webVC];
        }
    }];
}

@end
