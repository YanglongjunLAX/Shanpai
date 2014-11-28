//
//  SPUserData.m
//  shanpai
//
//  Created by liang chunyan on 14-11-10.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "SPUserData.h"
#import "SSKeychain.h"//安全保存账户密码
#import "Device.h"
#import "UIDevice-Hardware.h"

#define PASSWORD_SERVICE    @"SHANPAI_PASSWORD_SERVICE_"
#define kForLoginUserInfo   @"loginUserInfo"

NSString *spAccountChanged = @"com.shanpai.AccountChanged";

//用户名字
#define kForUserName        @"username"
//密码
#define kForPassword        @"password"
//appname
#define kForAppName1         @"appName"
//系统版本
#define kForSystemVersion   @"systemVersion"
//设备
#define kForDevice          @"device"
//语言
#define kForLanguage        @"language"
//id
#define kForDeviceId        @"deviceId"
//platform
#define kForPlatform        @"platform"
//手机号码
#define kForPhonenum        @"phonenum"
//验证码
#define kForVercode         @"vercode"

//注册请求借口
#define kForRegisterUrl     @"Member/addSmsUser"
//登录请求借口
#define kForLoginUrl        @"Public/checkLogin"

@interface SPUserData()
/*!
 *  清除数据
 */
- (void)clearProperty;

@end

@implementation SPUserData

//清除属性数据
- (void)clearProperty
{
    self.account    = nil;
    self.password   = nil;
    self.loginInfo  = nil;
}

- (void)setLoginInfo:(NSDictionary *)loginInfo
{
    _loginInfo = loginInfo;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:loginInfo forKey:kForLoginUserInfo];
}

+ (SPUserData *)spUserInfo
{
    static SPUserData *_sharedUserData = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedUserData = [[SPUserData alloc] init];
        //账户
        NSString *userAccount = [[SSKeychain accountsForService:PASSWORD_SERVICE] lastObject][@"acct"];
        //密码
        NSString *userPassword = [SSKeychain passwordForService:PASSWORD_SERVICE account:userAccount];
        if (_sharedUserData)
        {
            _sharedUserData.account  = userAccount;
            _sharedUserData.password = userPassword;
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            //用户登录信息
            if ([userDefault valueForKey:kForLoginUserInfo])
            {
                _sharedUserData.loginInfo = [userDefault valueForKey:kForLoginUserInfo];
            }
        }
    });
    return _sharedUserData;
}

+ (BOOL)isLogined
{
    return [SPUserData spUserInfo].account.length > 1;
//    NSString *userAccount = [[SSKeychain accountsForService:PASSWORD_SERVICE] lastObject][@"acct"];
//    return userAccount.length > 1;
}

+ (void)loginOut
{
    NSError *error;
    BOOL res = [SSKeychain deletePasswordForService:PASSWORD_SERVICE account:[self spUserInfo].account error:&error];
    if (res)//删除账号密码成功
    {
        [[self spUserInfo] clearProperty];
    }
}

+ (void)saveAccount:(NSString *)account pasword:(NSString *)password
{
    [SSKeychain setPassword:password forService:PASSWORD_SERVICE account:account];
    [SPUserData spUserInfo].account  = account;
    [SPUserData spUserInfo].password = password;
    //发出通知
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification postNotificationName:spAccountChanged object:self userInfo:nil];
}

+ (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
                 success:(void (^)(AFHTTPRequestOperation *, id))success
                 failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString *systemVersion = [NSString stringWithFormat:@"%@ %@" , [[UIDevice currentDevice] systemName] ,  [[UIDevice currentDevice] systemVersion]];
    NSString *device = [[UIDevice currentDevice] model];
    
    NSDictionary *userInfo = @{
                               kForUserName : account,
                               kForPassword : password,
                               kForAppName1  : AppName,
                               kForSystemVersion : systemVersion,
                               kForDevice   : device,
                               };
    
    [[SPHttpClient manager] POST:kForLoginUrl
                      parameters:userInfo
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             success(operation,responseObject);
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             failure(operation,error);
                         }];
}

+ (void)registerWithAccount:(NSString *)account
                   password:(NSString *)password
                    verCode:(NSString *)verCode
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *systemVersion = [NSString stringWithFormat:@"%@ %@" , [[UIDevice currentDevice] systemName] ,  [[UIDevice currentDevice] systemVersion]];
    NSString *device = [[UIDevice currentDevice] model];
    
    NSDictionary *userInfo = @{
                               kForPhonenum : account,
                               kForPassword : password,
                               kForAppName  : AppName,
                               kForSystemVersion : systemVersion,
                               kForDevice   : device,
                               kForVercode  : verCode
                               };
    
    [[SPHttpClient manager] POST:kForLoginUrl
                      parameters:userInfo
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             if (success)
                             {
                                 success(operation,responseObject);
                             }
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             if (failure)
                             {
                                 failure(operation,error);
                             }
                         }];
}

+ (void)updateAvatar:(NSString *)avatar
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[self spUserInfo].loginInfo];
    dic[@"avatar"] = avatar;
    [[self spUserInfo] setLoginInfo:dic];
    
}

+ (NSString *)userID
{
    if (!ISLogined)
    {
        return @"";
    }
    return [self spUserInfo].loginInfo[@"uid"];
}

+ (NSString *)money
{
    if (!ISLogined)
    {
        return nil;
    }
    return [self spUserInfo].loginInfo[@"money"];
}

@end
