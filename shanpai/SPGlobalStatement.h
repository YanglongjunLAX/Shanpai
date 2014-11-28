//
//  SPGlobalStatement.h
//  shanpai
//
//  Created by liang chunyan on 14-11-5.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//  全局的一些状态声明

#ifndef shanpai_SPGlobalStatement_h
#define shanpai_SPGlobalStatement_h
//隐藏自定义tabbar通知
#define kForHiddenTabbar         @"com.shanpai.hiddenTabbar"
//显示自定义tabbar通知
#define kForShowTabbar           @"com.shanpai.showTabbar"
//登录成功通知
#define kForLoginSucces          @"com.shanpai.loginSuccess"
//退出登录通知
#define kForLoginOut             @"com.shanpai.loginOut"
//http请求url
#define kForShanPaiBaseURL       @"http://shanpai.iushare.com/Api/"
//评分地址
#define kForGradeUrl             @"http://shanpai.iushare.com/Api/AppStore/grade"
//使用帮助
#define kForHelpUrl              @"http://shanpai.iushare.com/Api/Public/help"
//用户协议
#define kForAgreement            @"http://shanpai.iushare.com/Api/Public/agreement"
//API请求的秘钥
#define kForHttpPassword         @"a0810c0d5cfd0a0a6d88929329f5ecf1"
//appname
#define AppName                  @"shanpai"

//deviceToken
#define kForDeviceToken          @"deviceToken"

//是否登录
#define ISLogined                [SPUserData isLogined]
//定位到得城市名称
#define kForCurrentCityName      @"com.shanpai.cityname"

#define SPFormatstring(XX) [NSString stringWithFormat:@"%@",XX]

#define kForAppName              @"百灵闪拍"

typedef NS_ENUM(NSInteger,LoginState)
{
    noLogin = 0,
    hasLogin
};

#endif
