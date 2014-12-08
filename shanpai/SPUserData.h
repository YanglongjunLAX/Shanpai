//
//  SPUserData.h
//  shanpai
//
//  Created by liang chunyan on 14-11-10.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  用户信息

#import <Foundation/Foundation.h>

extern NSString *spAccountChanged;

@interface SPUserData : NSObject
//账号
@property (nonatomic, copy) NSString *account;
//密码
@property (nonatomic, copy) NSString *password;

//用户信息
@property (nonatomic, strong) NSDictionary *loginInfo;
/*!
 *  退出登录
 */
+ (void)loginOut;
/*!
 *  用户ID 经常使用，
 *
 *  @return userid
 */
+ (NSString *)userID;
/*!
 *  用户昵称
 *
 *  @return 昵称
 */
+ (NSString *)userNickName;
/*!
 *  真实姓名
 *
 *  @return 姓名  ==送货地址那里要用
 */
+ (NSString *)userName;
/*!
 *  性别
 *
 *  @return 男 、 女
 */
+ (NSString *)userSex;
/*!
 *  奖池数量
 *
 *  @return 奖池
 */
+ (NSString *)money;
/*!
 *  手机号码
 *
 *  @return 手机号码
 */
+ (NSString *)phonenum;
/*!
 *  邮政编码
 *
 *  @return 邮政编码
 */
+ (NSString *)receive_postcode;
/*!
 *  收货地址
 *
 *  @return 地址
 */
+ (NSString *)receive_address;
/*!
 *  是否登录
 *
 *  @return
 */
+(BOOL)isLogined;
/*!
 *  全局的用户信息
 *
 *  @return 用户信息
 */
+ (SPUserData *)spUserInfo;
/*!
 *  保存账户密码
 *
 *  @param account  账号信息
 *  @param password 密码
 */
+ (void)saveAccount:(NSString *)account pasword:(NSString *)password;
/*!
 *  登录
 *
 *  @param account  账户
 *  @param password 密码
 *  @param success  登录成功block
 *  @param failure  登录失败block
 */
+ (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/*!
 *  注册
 *
 *  @param account  账户
 *  @param password 密码
 *  @param verCode  验证码
 *  @param success  注册成功bolck 可以根据返回值status判断
 *  @param failure  注册失败block
 */
+ (void)registerWithAccount:(NSString *)account
                   password:(NSString *)password
                    verCode:(NSString *)verCode
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/*!
 *  改变用户头像地址
 *
 *  @param avatar 头像地址
 */
+ (void)updateAvatar:(NSString *)avatar;
/*!
 *  更新用户信息到服务器
 *
 *  @param params 参数
 *  @param block  回调
 */
+ (void)updateUserInfo:(NSDictionary *)params
                 block:(void (^)(NSDictionary *info, NSError *error))block;
@end
