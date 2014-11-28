//
//  SPTaskADView.m
//  shanpai
//
//  Created by liang chunyan on 14-11-7.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPTaskADView.h"

static NSString *CellIdentifier = @"AdcellIdentifier";

@interface SPTaskADView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel          *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel          *descripetLabel;
@property (weak, nonatomic) IBOutlet UIPageControl    *pageController;

//布局
@property (nonatomic, strong) UICollectionViewFlowLayout   *layout;

//配置
- (void)configCollectionView;
@end

@implementation SPTaskADView
- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)awakeFromNib
{
//    [self configCollectionView];
}

#pragma mark Private Method
//配置collection
- (void)configCollectionView
{
    self.collectionView.delegate    = self;
    self.collectionView.dataSource  = self;
    self.collectionView.backgroundColor = [UIColor grayColor];
    [self.collectionView registerClass:[ADCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    if (!self.layout)
    {
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.minimumInteritemSpacing = 0;
        self.layout.minimumLineSpacing      = 0;
        //滚动方向
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    self.layout.itemSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 130.0f);
    
    [self.collectionView setCollectionViewLayout:self.layout];
    
}

- (void)setNumberOfPage:(NSUInteger)numberOfPage
{
    if (_numberOfPage != numberOfPage)
    {
        _numberOfPage = numberOfPage;
        self.pageController.numberOfPages = numberOfPage;
//        [self.collectionView reloadData]; //
    }
}

- (void)setType:(NSString *)type
{
    _type = type;
    self.typeLabel.text = type;
}

- (void)setDesStr:(NSString *)desStr
{
    _desStr = desStr;
    self.descripetLabel.text = desStr;
}

#pragma mark - collection delegate
#pragma mark - collection Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return self.dataArray.count;
    return self.numberOfPage;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellIdentifier = @"simpleCell";
    ADCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[ADCollectionViewCell alloc] init];
    }
//
//    __weak __typeof(&*self)weakSelf = self;
//    cell.webViewBlock = ^(NSInteger index)
//    {
//        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
//        [strongSelf showWebView:index];
//    };
//    
//    cell.QRCodeBlock = ^(NSString *path)
//    {
//        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
//        [strongSelf showQRCodeView:path];
//    };
//    
//    youxiu* yObj = (youxiu *)self.dataArray[indexPath.row];
//    cell.itemInfo = yObj;
//    
    return cell;
}

@end

/////////
@interface ADCollectionViewCell()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ADCollectionViewCell

- (id)init
{
    self = [super init];
    if (self)
    {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)updateConstraints
{
    [super updateConstraints];
    [_imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:.0f];
    [_imageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:.0f];
    [_imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:.0f];
    [_imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:.0f];
}

#pragma mark - Private Method
- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
//设置图片
- (void)setImageURL:(NSString *)imageURL
{
    [self.imageView setImageWithURL:[NSURL URLWithString:imageURL]];
}

@end

