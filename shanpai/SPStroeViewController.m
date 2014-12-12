//
//  SPStroeViewController.m
//  shanpai
//
//  Created by liang chunyan on 14-11-6.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPStroeViewController.h"
#import "SPAdData.h"
#import "SPStroeSData.h"
#import "spStoreHeadView.h"
#import "spStoreHeadView.h"
#import "SpStoreViewCell.h"
#import "SVModalWebViewController.h"
#import "SPExchangeController.h"

#define kForItemWith     150.0f
#define kForItemHight    170.0f

@interface SPStroeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) spStoreHeadView   *sheadView;
@property (nonatomic, strong) NSArray           *adArray;//广告数组

@property (nonatomic, strong) NSMutableArray  *dataList;
@property (nonatomic, assign) NSInteger   pageNumber;

- (void)configCollectionView;
/*!
 *  请求广告信息
 */
- (void)requestAdInfo;
/*!
 *  分页获取商城数据
 *
 *  @param pageIndex 页数
 *  @param pageSize  每页长度
 */
- (void)requestStoreInfo:(NSInteger)pageIndex
                pageSize:(NSInteger)pageSize;
@end

@implementation SPStroeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商城";
    
    [self configCollectionView];
    
    [self setCityButton];
    [self setUserCenterButton];
    [self requestAdInfo];
    
    [self requestStoreInfo:self.pageNumber pageSize:20];
    
    self.pageNumber = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabbar];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
}

#pragma mark - getters
- (NSMutableArray *)dataList
{
    if (!_dataList)
    {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

#pragma mark - Private Method
- (void)configCollectionView
{
    self.collectionView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView reloadData];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"spStoreHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"spadview"];

    
    UINib *cellNib = [UINib nibWithNibName:@"SpStoreViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"SpStoreViewCell"];
    
    UICollectionViewFlowLayout   *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 130);
    
    CGFloat lrOffect = 2.0f;
    if (!(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
    {
        lrOffect = (CGRectGetWidth([UIScreen mainScreen].bounds) - kForItemWith*2)/3.0;
    }
    layout.sectionInset = UIEdgeInsetsMake(5, lrOffect, 5, lrOffect);
    
    layout.itemSize = CGSizeMake(kForItemWith, kForItemHight);
    
    [self.collectionView setCollectionViewLayout:layout];
    
    //下拉
//    __weak __typeof(self)weakSelf = self;
//    [self.collectionView addPullToRefreshWithActionHandler:^{
//        weakSelf.pageNumber = 0;
//        //设置时间为2
//        double delayInSeconds = 2.0;
//        //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
//        dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//        //推迟两纳秒执行
//        dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
//            [weakSelf requestStoreInfo:self.pageNumber+1 pageSize:20];
//        });
//    }];
//    
//    [self.collectionView addInfiniteScrollingWithActionHandler:^{
//        //设置时间为2
//        double delayInSeconds = 2.0;
//        //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
//        dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//        //推迟两纳秒执行
//        dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
//            [weakSelf requestStoreInfo:self.pageNumber+1 pageSize:20];
//        });
//    }];
}

- (void)requestAdInfo
{
    NSString *path = @"AdvertBanners/ls";
    NSDictionary *params = @{@"advType":@"store",@"listRows":@"5"};
    __weak __typeof(self)weakSelf = self;
    [SPAdData getTaskAdWithPath:path
                         params:params
                          block:^(NSArray *array, NSError *error) {
                              if (weakSelf.sheadView != nil)
                              {
                                  weakSelf.sheadView.dataArray = array;
                              }
                              else if (weakSelf.adArray == nil)
                              {
                                  weakSelf.adArray = array;
                                  [self.collectionView reloadData];
                              }
                          }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SpStoreViewCell";
    SpStoreViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    SPStroeSData *data = self.dataList[indexPath.row];
    cell.dataObj = data;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (ISLogined)
    {
        //进入兑换页面
        SPExchangeController *vc = [[SPExchangeController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.data = self.dataList[indexPath.row];
        [self.navigationController presentViewController:nav animated:YES completion:^{
            
        }];
    }
    else
    {
        [self pressentToLoginViewController];
    }
}

- (void)requestStoreInfo:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    NSDictionary *dicPars =@{@"p":[NSString stringWithFormat:@"%li",(long)pageIndex],
                             @"listRows":[NSString stringWithFormat:@"%li",(long)pageSize]};
    
    NSString *path = @"Store/ls/";
    
    __weak __typeof(self)weakSelf = self;//防止循环引用
    [SPStroeSData getStoreDatasWithPath:path
                                 params:dicPars
                                  block:^(NSArray *array, NSError *error){
                                      if (weakSelf.pageNumber == 0)
                                      {
                                          [weakSelf.dataList removeAllObjects];
                                      }
                                      if (array.count > 0)
                                      {
                                          [weakSelf.dataList addObjectsFromArray:array];
                                          [weakSelf.collectionView reloadData];
                                          self.pageNumber++;
                                      }
//                                      [weakSelf.collectionView.pullToRefreshView stopAnimating];
//                                      [weakSelf.collectionView.infiniteScrollingView stopAnimating];
                                  }];
}


/*!
 *  添加补充视图
 */
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {CGRectGetWidth(self.view.bounds),130};
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = nil;
    
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind withReuseIdentifier:@"spadview" forIndexPath:indexPath];
        self.sheadView = (spStoreHeadView *)view;
        if (self.adArray != nil)
        {
            self.sheadView.dataArray = self.adArray;
        }
        __weak __typeof(self)weakSelf = self;
        self.sheadView.action = ^(NSInteger index,NSString *url)
        {
            SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithAddress:url];
            [weakSelf presentViewController:webViewController animated:YES completion:NULL];
        };
    }
    else if([kind isEqual:UICollectionElementKindSectionFooter])
    {
        view = nil;
    }
    
    return view;
}

@end
