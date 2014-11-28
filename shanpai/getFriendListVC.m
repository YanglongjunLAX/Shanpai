//
//  getFriendList.m
//  shanpai5.0
//
//  Created by liang chunyan on 14-4-14.
//  Copyright (c) 2014年 arrowspeed. All rights reserved.
//

#import "getFriendListVC.h"
#import "getFriendCell.h"
#import "GetFriendModel.h"
#import "UIImageView+AFNetworking.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#define CELL_HEIGTH 80
#define WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define HEIGHT [UIScreen mainScreen].applicationFrame.size.height

@interface getFriendListVC ()<UISearchBarDelegate,UISearchDisplayDelegate>
{
    ABAddressBookRef getAddressBook;
    NSIndexPath *lastIndexPath;
    NSString * friendphoneNum;
    UIView * _headView;
    UISearchBar * _searchBar;
    UISearchDisplayController * _searchDC;
    NSArray * _searchArray;
    BOOL _search;
    NSUInteger _selectRow;
    NSString * _searchNum;
}
@end

@implementation getFriendListVC
@synthesize friendArray;
@synthesize friendTableView;
@synthesize phoneNumArray;
@synthesize AD_UserName;
@synthesize selectStatus;
@synthesize Delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"我的好友";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initViewAndData];
    [self _initCostomRightButton];
}

-(void)_initCostomRightButton
{
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * image = [UIImage imageNamed:@"nav_bar_confirm_icon.png"];
    [rightButton setFrame:CGRectMake(0, 0,image.size.width,image.size.height)];
    [rightButton setBackgroundImage:image forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(popGetQiuJinDou) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    
}

-(void)popGetQiuJinDou
{
    if (phoneNumArray.count <= 0)
    {
        return;
    }
    if (_search==YES)
    {
        for (int i = 0; i<AD_UserName.count; i++)
        {
            if ([_searchNum isEqualToString:[AD_UserName objectAtIndex:i]])
            {
                if ([Delegate respondsToSelector:@selector(getPhoneNum:)])
                    [Delegate getPhoneNum:[phoneNumArray objectAtIndex:i]];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
        }
    }else
    {
        if ([Delegate respondsToSelector:@selector(getPhoneNum:)])
            [Delegate getPhoneNum:[phoneNumArray objectAtIndex:_selectRow]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)_initViewAndData
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view setFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    
    _searchArray = [[NSArray alloc]init];
    AD_UserName = [[NSMutableArray alloc]init];
    friendArray = [[NSMutableArray alloc]init];
    phoneNumArray = [[NSMutableArray alloc]init];
    friendTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    friendTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    friendTableView.delegate=self;
    friendTableView.dataSource=self;
    friendTableView.tableFooterView = UIView.new;
    //    friendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:friendTableView];
    
    _headView = ({
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
        view.backgroundColor = [UIColor grayColor];
        view;
        
    });
    friendTableView.tableHeaderView=_headView;
    
    _searchBar = [[UISearchBar alloc]initWithFrame:_headView.frame];
    _searchBar.delegate=self;
    [_headView addSubview:_searchBar];
    
    _searchDC = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self] ;
    _searchDC.delegate=self;
    _searchDC.searchResultsDataSource=self;
    _searchDC.searchResultsDelegate=self;
    
    [self ReadAllPeoples];
}
//过滤搜索内容
-(void)SearchContentText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate * Predicate = [NSPredicate predicateWithFormat:
                               @"SELF contains[cd]%@",searchText];
    _searchArray = [AD_UserName filteredArrayUsingPredicate:Predicate];
    
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self SearchContentText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}


#pragma  mark - -tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView==self.searchDisplayController.searchResultsTableView)
        return _searchArray.count;
    else
        return AD_UserName.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * Identifiers = @"cell";
    getFriendCell  * cell = [tableView dequeueReusableCellWithIdentifier:Identifiers];
    if (!cell)
        cell = [[getFriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifiers];
    
    UIImage *image = [UIImage imageNamed:@"pk_default_avatar"];
    cell.headImgV.image=image;
    
    
    if (tableView==self.searchDisplayController.searchResultsTableView)
        cell.name.text = [_searchArray objectAtIndex:indexPath.row];
    else
        cell.name.text = [AD_UserName objectAtIndex:indexPath.row];
    
    cell.touchCount = 0;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //单选
    if (tableView==self.searchDisplayController.searchResultsTableView)
    {
        _search=YES;
        [self popGetQiuJinDou];
        _searchNum = [AD_UserName objectAtIndex:indexPath.row];
        
    }else
    {
        _search=NO;
        NSUInteger newRow = indexPath.row;
        NSUInteger oldRow = (lastIndexPath != nil) ? [lastIndexPath row] : -1;
        
        if (newRow != oldRow)
        {
            getFriendCell * newCell = (getFriendCell*)[ tableView cellForRowAtIndexPath:indexPath];
            [newCell.selectV setImage:[UIImage imageNamed:@"alarm_checked_icon.png"]];
            
            getFriendCell * oldCell = (getFriendCell*)[tableView cellForRowAtIndexPath:lastIndexPath];
            [oldCell.selectV setImage:[UIImage imageNamed:@"alarm_check_icon.png"]];
            
            lastIndexPath = indexPath;
        }else
        {
            getFriendCell * newCell = (getFriendCell*)[ tableView cellForRowAtIndexPath:indexPath];
            [newCell.selectV setImage:[UIImage imageNamed:@"alarm_checked_icon.png"]];
            
            getFriendCell * oldCell = (getFriendCell*)[tableView cellForRowAtIndexPath:lastIndexPath];
            [oldCell.selectV setImage:[UIImage imageNamed:@"alarm_check_icon.png"]];
            lastIndexPath = nil;
            
        }
        
    }
    
    _selectRow = indexPath.row;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CELL_HEIGTH;
    
}

#pragma maek - - Read All Peoples
-(void)ReadAllPeoples
{
    getAddressBook = nil;
    
    
    getAddressBook = ABAddressBookCreateWithOptions(NULL,NULL);//创建空电话本
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);//发出获取通讯录通知
    
    //用户同意访问通讯录后执行以下方法
    ABAddressBookRequestAccessWithCompletion(getAddressBook, ^(bool granted, CFErrorRef error) {
        
        dispatch_semaphore_signal(sema);//发送请求
        
        //用户同意
        [self showTongXunLu:getAddressBook];
    });
    
//    dispatch_release(sema);
    
}
-(void)showTongXunLu:(ABAddressBookRef)addressBook
{
    
    //获取通讯录内容
    NSArray * Peoples = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for (id Person in Peoples)
    {
        ABMultiValueRef getPhoneNums = ABRecordCopyValue((__bridge ABRecordRef)(Person), kABPersonPhoneProperty);
        
        NSString * fristName = (__bridge NSString *)(ABRecordCopyValue((__bridge ABRecordRef)(Person), kABPersonFirstNameProperty));
        
        NSString * userName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(Person), kABPersonLastNameProperty);
        
        NSString * phontNumber = [self getPhoneNumber:getPhoneNums];
        if ([self checkPhoneNumber:phontNumber])
        {
            [phoneNumArray addObject:phontNumber];
        }
        else
        {
            continue;
        }
        
        NSString * fullName  = @"";
        
        if (fristName.length <= 0 && userName.length > 0)
        {
            fullName = userName;
        }
        else if (fristName.length > 0 && userName.length <= 0)
        {
            fullName = fristName;
        }
        else if (fristName.length > 0 && userName.length > 0)
        {
            fullName = [NSString stringWithFormat:@"%@ %@",fristName,userName];
        }
        else
        {
            fullName = phontNumber;
        }
        
        [AD_UserName addObject:fullName];
        
        CFRelease(getPhoneNums);
        
    }

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.0*NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [friendTableView reloadData];
    });
}

- (NSString *)getPhoneNumber:(ABMultiValueRef)peopleNumbers
{
    NSMutableString *phoneNumber = [@"" mutableCopy];
    
    for(NSInteger j = 0; j < ABMultiValueGetCount(peopleNumbers); j++)
    {
        NSString * tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(peopleNumbers, j);
        
        phoneNumber = [tmpPhoneIndex mutableCopy];
        
        [phoneNumber replaceOccurrencesOfString:@"-" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [phoneNumber length])];
        [phoneNumber replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [phoneNumber length])];
        [phoneNumber replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [phoneNumber length])];
        if ([self checkPhoneNumber:phoneNumber])
        {
            break;
        }
    }
    
    return phoneNumber;
}

/*
 *!检查手机号码格式是否正确
 */
- (BOOL)checkPhoneNumber:(NSString*)string
{
    if (string.length <= 0)
    {
        return NO;
    }
    
     NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1\\d{10}$"];
    
    NSString *str = [string substringWithRange:NSMakeRange(0, 3)];
    if ([regextestmobile evaluateWithObject:string] == YES || ([str isEqualToString:@"+86"] && string.length == 14))
    {
        return YES;
    }
    
    return NO;
}

-(void)getPhoneNum:(NSString*)phoneNum
{
    NSLog(@"%@",phoneNum);
}

@end
