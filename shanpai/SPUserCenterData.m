//
//  SPUserCenterData.m
//  shanpai
//
//  Created by liang chunyan on 14-11-21.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  个人中心model

#import "SPUserCenterData.h"

#define kForUploadHeadPath     @"Member/uploadAvatar"

@implementation SPUserCenterData

+ (void)load
{
    [super load];
    [self spkGetSendNumber:nil];
}

+ (void)updateHeadImage:(UIImage *)image
                  block:(void (^)(NSDictionary *, NSError *))block
{
    NSString *realyPath = [SPHttpClient getReallyUrlString:kForUploadHeadPath];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"ukey": kForHttpPassword,
                                 @"userid" : [SPUserData spUserInfo].loginInfo[@"uid"],
                                 };
    
    [manager POST:realyPath
       parameters:parameters
constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
         [formData appendPartWithFileData:imageData name:@"photo" fileName:@"photo.png" mimeType:@"image/jpeg"];
    }success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        //上传出错
        if ([responseObject[@"status"] integerValue] != 1)
        {
            [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:@"头像上传成功"];
            block(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"上传头像失败"];
    }];
}

+ (void)signIn
{
    NSString *path = @"Card/insert/";
    NSDictionary  *params = @{@"userid" : [SPUserData spUserInfo].loginInfo[@"uid"]};
    [SVProgressHUD show];
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [SVProgressHUD showSuccessWithStatus:responseObject[@"info"]];
                                });
                            }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD dismiss];
                        });
                    }];

}

+ (void)spkGetSendNumber:(void (^)(NSDictionary *, NSError *))block
{
    NSString *path = @"Beans/sendNum";
    NSDictionary *params = @{@"userid": [SPUserData userID]};
    [[SPHttpClient manager] GET:path
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSLog(@"%@",responseObject);
                            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                            [userDefault setObject:responseObject[@"snum"] forKey:@"sendnumber"];
                            if (block)
                            {
                                block(responseObject,nil);
                            }
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            if (block)
                            {
                                block(nil,error);
                            }
                            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                            [userDefault setObject:@"0" forKey:@"sendnumber"];
                        }];
}

@end
