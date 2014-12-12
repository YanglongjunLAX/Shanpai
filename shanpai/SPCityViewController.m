//
//  SPCityViewController.m
//  shanpai
//
//  Created by liang chunyan on 14-11-6.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPCityViewController.h"
#import "SPCityData.h"

@interface SPCityViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSDictionary  *cityInfo;

@property (nonatomic, strong) NSMutableArray       *cityKeys;////

@property (nonatomic, strong) NSArray       *indexList;

@property (nonatomic, copy) NSString  *selectCity;

//设置tableView;
- (void)configTableView;
//获取城市列表
- (void)getCityList:(NSInteger)pageNumber pageSize:(NSInteger)pageSize;
@end

@implementation SPCityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"选择城市";
    [self setBackLeftItem];
    self.view.backgroundColor = [HXColor colorWithHexString:@"#F6F2ED"];
    [self configTableView];
    [self getCityList:0 pageSize:20];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSArray *)indexList
{
    if (!_indexList)
    {
        _indexList = @[@"当前城市",@"A", @"B", @"C",@"D", @"E", @"F",@"G", @"H", @"I",@"J", @"K", @"L",@"M", @"N", @"O",@"P", @"Q", @"R",@"S", @"T", @"U",@"V", @"W", @"X",@"Y", @"Z",];
    }
    return _indexList;
}

- (NSMutableArray *)cityKeys
{
    if (!_cityKeys)
    {
        _cityKeys = [[NSMutableArray alloc] initWithObjects:@"当前城市", nil];
    }
    return _cityKeys;
}

#pragma mark - Private Method
- (void)configTableView
{
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = UIView.new;
}

- (void)getCityList:(NSInteger)pageNumber pageSize:(NSInteger)pageSize
{
    [SPCityData getCityList:pageNumber
                   pageSize:pageSize
                    success:^(NSInteger status, NSDictionary *infot) {
                        self.cityInfo = infot;
                        [self.cityKeys addObjectsFromArray:[[self.cityInfo allKeys] sortedArrayUsingSelector:@selector(compare:)]];
                        // 主线程执行：
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                        });
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                        [self showTipMessage:@"获取失败"];
                        [SVProgressHUD showErrorWithStatus:@"获取失败"];
                    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.cityInfo allKeys].count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.cityKeys == 0)
    {
        return 0;
    }
    if(section == 0)
    {
        return 1;
    }
    NSString *key = self.cityKeys[section];
    NSArray *nameSection = [self.cityInfo objectForKey:key];
    return nameSection.count;
}

//设定表单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    //显示当前城市
    if (indexPath.section == 0)
    {
        NSString *cityString = [SPUserDefault objectForKey:kForCurrentCityName];
        if (cityString.length < 1)
        {
            cityString = @"没有定位到当前城市信息";
        }
        cell.textLabel.text  = cityString;
    }
    else
    {
        NSString     *key         = self.cityKeys[indexPath.section];
        NSArray      *nameSection = [self.cityInfo objectForKey:key];
        SPCityData   *data = nameSection[indexPath.row];
        cell.textLabel.text  = data.cat_name;
    }
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexList;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.cityKeys count] == 0)
        return nil;
    NSString *key = [self.cityKeys objectAtIndex:section];
    return key;
}

#pragma mark Table View Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index
{
    NSString *key = [self.indexList objectAtIndex:index];
    
    __block NSInteger r = 0;
    [self.cityKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *str = (NSString *)obj;
        if ([str isEqual:key])
        {
            r = idx;
            *stop = YES;
        }
    }];
    
    return r;
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section != 0)
    {
        NSString     *key         = self.cityKeys[indexPath.section];
        NSArray      *nameSection = [self.cityInfo objectForKey:key];
        SPCityData   *data = nameSection[indexPath.row];
        self.selectCity  = data.cat_name;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"亲，如果您想切换到其他城市，您在当前城市的奖金池的金豆会被清零的哦。您可以先收了金豆再来切换城市，或者继续留在当前城市"
                                                           delegate:self
                                                  cancelButtonTitle:@"不切换"
                                                  otherButtonTitles:@"继续切换",
                                  nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //切换城市
    if (buttonIndex == 1)
    {
        if (self.cityChanged)
        {
            self.cityChanged(self.selectCity);
            //可以返回
            if (self.navigationController.viewControllers.count > 1)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            }
        }
    }
}

@end
