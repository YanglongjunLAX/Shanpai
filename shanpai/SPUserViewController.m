//
//  SPUserViewController.m
//  shanpai
//
//  Created by liang chunyan on 14-11-11.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  个人中心

#import "SPUserViewController.h"
#import "SPUserCenterHeadView.h"//头部
#import "SPUserCenterData.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"//保存照片到自己建立的相册中
#import "SPjindouCell.h"
#import "SPBeanController.h"
#import "SPMyMessageController.h"
#import "SPSetController.h"
#import "SPPKPoolController.h"
#import "SPExangeController.h"

@interface SPUserViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray  *data;
@property (strong, nonatomic) UIView   *tableFootView;
@property (strong, nonatomic) UIView   *tableHeadView;
@property (strong, nonatomic) UIButton *loginOutButton;
@property (strong, nonatomic) SPUserCenterHeadView   *headView;

//退出登录
- (void)loginOutAction:(UIButton *)button;
//设置tableView
- (void)configTableView;
/*!
 *  设置表头和表尾的约束
 */
- (void)configConstraints;
/*!
 *  设置表头的点击事件
 */
- (void)configTableHeadEvent;
/*!
 *  切换头像
 */
- (void)changeHeadImage;
/*!
 *  跳转到粉丝
 */
- (void)gotoFansVC;
//跳转到关注
- (void)gotoAttentionVC;
//上传头像
- (void)upLoadImage:(UIImage *)image;
@end

@implementation SPUserViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人中心";
    [self setBackLeftItem];
    [self configTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self configConstraints];
}

- (void)configConstraints
{
    [self.loginOutButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:25.0f];
    [self.loginOutButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:25.0f];
    [self.loginOutButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    
    [self.headView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.headView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.headView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.headView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
}

#pragma mark - getters
- (NSArray *)data
{
    if (!_data)
    {
        _data = @[
          @"我的消息",
          @"奖金排行",
          @"兑换记录",
          @"金豆记录",
          @"修改密码",
          @"我的闹钟",
          @"设置",
          @"淘金豆",
          ];
    }
    return _data;
}

- (UIView *)tableFootView
{
    if (!_tableFootView)
    {
        _tableFootView = [[UIView alloc] init];
        _tableFootView.backgroundColor = [UIColor whiteColor];
        _tableFootView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 80.0f);
    }
    return _tableFootView;
}

- (UIView *)tableHeadView
{
    if (!_tableHeadView)
    {
        _tableHeadView = [[UIView alloc] init];
        _tableHeadView.backgroundColor = [UIColor clearColor];
        _tableHeadView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 175);
    }
    return _tableHeadView;
}

- (UIButton *)loginOutButton
{
    if (!_loginOutButton)
    {
        UIImage *logoutImage = [UIImage imageNamed:@"user_sign_out_btn"];
        logoutImage = [logoutImage stretchableImageWithLeftCapWidth:logoutImage.size.width*0.5 topCapHeight:logoutImage.size.height*0.5];
        UIImage *logoutImageHeight = [UIImage imageNamed:@"user_sign_out_btn_high_light"];
        logoutImageHeight = [logoutImageHeight stretchableImageWithLeftCapWidth:logoutImageHeight.size.width*0.5 topCapHeight:logoutImageHeight.size.height*0.5];
        
        _loginOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginOutButton setBackgroundImage:logoutImage forState:UIControlStateNormal];
        [_loginOutButton setBackgroundImage:logoutImageHeight forState:UIControlStateHighlighted];
        [_loginOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_loginOutButton addTarget:self
                            action:@selector(loginOutAction:)
                  forControlEvents:UIControlEventTouchUpInside];
        _loginOutButton.userInteractionEnabled = YES;
    }
    return _loginOutButton;
}

- (SPUserCenterHeadView *)headView
{
    if (!_headView)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SPUserCenterView"owner:self options:nil];
        _headView = nib[0];
    }
    return _headView;
}

- (void)configTableHeadEvent
{
    if (self.headView)
    {
        __weak __typeof(self)weakSelf = self;
        //点击关注
        self.headView.attenBlock = ^(){
            [weakSelf gotoAttentionVC];
        };
        
        //点击粉丝
        self.headView.funcsBlock = ^(){
            [weakSelf gotoFansVC];
        };
        
        //点击头像
        self.headView.changeHeadImage = ^(){
            [weakSelf changeHeadImage];
        };
    }
}

- (void)loginOutAction:(UIButton *)button
{
    //退出
    [SPUserData loginOut];
    //退出登录通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kForLoginOut object:self userInfo:nil];
    [self goback];
}

- (void)goback
{
    if (self.navigationController.viewControllers.count > 1)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

#pragma mark - private Method
- (void)configTableView
{
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = self.tableFootView;
    [self.tableView.tableFooterView addSubview:self.loginOutButton];
    self.tableView.tableHeaderView = self.tableHeadView;
    [self.tableHeadView addSubview:self.headView];
    [self.tableView reloadData];
    [self configTableHeadEvent];
}

#pragma mark - tableView delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    //求金豆，
    if (indexPath.row == 0)
    {
        SPjindouCell  *cell=[[[NSBundle mainBundle]loadNibNamed:@"SPjindouCell" owner:self options:nil]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        /*!
         *  求金豆，送金豆设置
         */
        __weak __typeof(self)weakSelf = self;
        cell.leftAction = ^(){
            SPBeanController * beanVC = [[SPBeanController alloc] init];
            
            beanVC.type = 1;
            [weakSelf.navigationController pushViewController:beanVC animated:YES];
        };
        cell.rightAction = ^(){
            SPBeanController * beanVC = [[SPBeanController alloc] init];
//            __weak __typeof(self)weakSelf = self;
            beanVC.type = 0;
            [weakSelf.navigationController pushViewController:beanVC animated:YES];
        };
        return cell;
    }
    
    static NSString *cellReuseIdentifier   = @"SectionTwoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellReuseIdentifier];
    }
    cell.imageView.image = nil;
    cell.detailTextLabel.text = nil;
    switch (indexPath.row)
    {
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"user_msg_icon"];
            break;
            
        case 2:
            
            cell.imageView.image = [UIImage imageNamed:@"user_rank_icon"];
            break;
        case 3:
            
            cell.imageView.image = [UIImage imageNamed:@"user_convert_record_icon"];
            break;
        case 4:
            cell.imageView.image = [UIImage imageNamed:@"user_money_record_icon"];
            break;
        case 5:
            
            cell.imageView.image = [UIImage imageNamed:@"user_password_icon"];
            break;
        case 6:
            
            cell.imageView.image = [UIImage imageNamed:@"user_alarm_icon"];
            break;
        case 7:
            cell.imageView.image = [UIImage imageNamed:@"user_setting_icon"];
            break;
        case 8:
            cell.imageView.image = [UIImage imageNamed:@"user_jindou_icon"];
            break;
        default:
            break;
    }
    cell.textLabel.text = self.data[indexPath.row - 1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat hight = 55.0;
    if (indexPath.row==0)
    {
        hight = 75.0f;
    }
    return hight;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *v = nil;
    switch (indexPath.row)
    {
        case 1://我的消息
            v = [[SPMyMessageController alloc] init];
            break;
        case 2://奖池排行
            v = [[SPPKPoolController alloc] init];
            break;
        case 3://兑奖记录
            v = [[SPExangeController alloc] init];
            break;
//        case 4://金豆记录
//            v = [[[MarkRecodeViewController alloc] init] autorelease];
//            break;
//        case 5:
//            v = [[[MemberUpdatePswViewController alloc] init] autorelease];
//            break;
//        case 6:
//            v = [[[AlarmVC alloc]init]autorelease];
//            break;
        case 7:
            v = [[SPSetController alloc] init];
            break;
//        case 8:
//            [BOAD openIntegralWall:self];
//            break;
        default:
            break;
    }
    [self.navigationController pushViewController:v animated:YES];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)uiscrollView willDecelerate:(BOOL)decelerate{
    CGFloat yOffset  = uiscrollView.contentOffset.y;
    //打卡
    if (yOffset<-150) {
        [SPUserCenterData signIn];
    }
}


#pragma mark - Event Actions
- (void)changeHeadImage
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传头像"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照上传", @"上传手机中的照片", nil];
    [actionSheet showInView:self.view];
}

//actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }
    } else if (buttonIndex==1)
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
}

//选择图片代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [SVProgressHUD show];
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        //保存照片到百灵闪拍相册中
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library saveImage:image toAlbum:kForAppName withCompletionBlock:^(NSError *error) {
            
        }];
        
        [self performSelector:@selector(upLoadImage:)
                   withObject:image
                   afterDelay:0.5];
    }];
}

/*!
 *  跳转到粉丝
 */
- (void)gotoFansVC
{
    
}

//跳转到关注
- (void)gotoAttentionVC
{
}

//上传头像
- (void)upLoadImage:(UIImage *)image
{
    [SPUserCenterData updateHeadImage:image block:^(NSDictionary *dic, NSError *error)
     {
         //头像上传成功
         if ([dic[@"status"] integerValue] == 1)
         {
             NSArray *data = dic[@"data"];
             NSDictionary *info = data[0];
             //取得头像地址
             NSString *headUrl = info[@"avatar"];
             [SPUserData updateAvatar:headUrl];
             //更新用户头像
             [self.headView updateUserInfo];
         }
    }];
}

@end
