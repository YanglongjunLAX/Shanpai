//
//  SPTakePhotoModel.m
//  shanpai
//
//  Created by liang chunyan on 14-11-28.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPTakePhotoModel.h"
//图像识别地址
#define kForUloadImagePath   @"Advert/uploadPhoto"

@implementation SPTakePhotoModel

+ (void)updateImage:(UIImage *)image
              block:(void (^)(NSArray *, NSError *))block
{
    [SVProgressHUD showWithStatus:@"正在识别，请稍后..."];
    
    NSString *realyPath = [SPHttpClient getReallyUrlString:kForUloadImagePath];
    
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
         //上传出错
         if ([responseObject[@"status"] integerValue] != 1)
         {
             [SVProgressHUD showErrorWithStatus:responseObject[@"info"]];
             if (block)
             {
                 block(responseObject[@"data"],nil);
             }
         }
         else
         {
             [SVProgressHUD showSuccessWithStatus:@"识别成功"];
             if (block)
             {
                 block(responseObject[@"data"],nil);
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"图像无法识别"];
         if (block)
         {
             block(nil,error);
         }
     }];
}

@end
