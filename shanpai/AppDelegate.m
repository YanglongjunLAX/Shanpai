//
//  AppDelegate.m
//  shanpai
//
//  Created by liang chunyan on 14-11-4.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
//定位信息
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //开始定位
    [self.locationManager startUpdatingLocation];
    //安装异常处理函数
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    return YES;
}

// 注册Device token
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    [Application setDeviceToken:[NSString stringWithFormat:@"%@",deviceToken]];
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
    //存贮
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:token forKey:kForDeviceToken];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - gettser
- (CLLocationManager *)locationManager
{
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 100.0f;
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (self.currentLocation.coordinate.latitude!=newLocation.coordinate.latitude && self.currentLocation.coordinate.longitude!=newLocation.coordinate.longitude)
    {
        self.currentLocation = newLocation;
    }
    
    //当前城市信息
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks)
        {
            NSString *myCity = placemark.locality;
            //显示西安地区
            if ([myCity isEqualToString:@"长安"])
            {
                myCity = @"西安";
            }
            //保存当前城市
            [[NSUserDefaults standardUserDefaults] setObject:myCity forKey:kForCurrentCityName];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}

#pragma mark - 异常处理函数
void UncaughtExceptionHandler(NSException *exception)
{
    //获取异常详细信息
//    NSArray *arr = [exception callStackSymbols];
//    [arr componentsJoinedByString:@"<br>"];
    NSString *reason = [exception reason];
    //接受异常信息的邮箱
    NSString *name = [exception name];
    //显示异常信息
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.title = name;
    alertView.message = reason;
    [alertView addButtonWithTitle:@"确定"];
    [alertView show];
}

@end
