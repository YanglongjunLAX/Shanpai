//
//  SPExchangeController.m
//  shanpai
//
//  Created by liang chunyan on 14-11-19.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPExchangeController.h"
//兑换请求路径
#define kForExchangePath     @"StoreExchange/exchange"

@interface SPExchangeController ()
@property (weak, nonatomic) IBOutlet UIImageView    *imageView;
@property (weak, nonatomic) IBOutlet UILabel        *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *numberLabel;
@property (weak, nonatomic) IBOutlet UITextView     *textView;
@property (weak, nonatomic) IBOutlet UILabel        *costLabel;
@property (weak, nonatomic) IBOutlet UIButton       *buyButton;

- (void)updateViews;
/*!
 *  兑换按钮点击
 *
 *  @param button
 */
- (void)buyButtonClicked:(UIButton *)button;
@end

@implementation SPExchangeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.data.title;
//    [self setBackLeftItem];
    [self setBackLeftItemWithAction:@selector(backAction:)];
    [self updateViews];
}

- (void)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)updateViews
{
    self.costLabel.textColor = [UIColor colorWithHexString:@"#ff7e00"];
    self.textView.editable = NO;
    [self.imageView setImageWithURL:[NSURL URLWithString:self.data.photo]];
    self.nameLabel.text = self.data.title;
    
    self.textView.text = [NSString flattenHTML:self.data.content];
    self.costLabel.text = self.data.credits;
    self.numberLabel.text = self.data.surplus;
    
    [self.buyButton addTarget:self
                       action:@selector(buyButtonClicked:)
             forControlEvents:UIControlEventTouchUpInside];
}

- (void)buyButtonClicked:(UIButton *)button
{
    //兑换请求参数
    NSDictionary *params = @{
                             @"store_id"   :  self.data._id,
                             @"userid"     :  [SPUserData spUserInfo].loginInfo[@"uid"],
                             };
    
    
    [SVProgressHUD show];
    [[SPHttpClient manager] GET:kForExchangePath
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if ([responseObject[@"status"] integerValue] == 1)
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [SVProgressHUD showErrorWithStatus:@"兑换成功"];
                                });
                            }
                            else
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
                                });
                            }
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [SVProgressHUD showErrorWithStatus:@"商品兑换出错"];
                            });
                        }];

    
}

@end
