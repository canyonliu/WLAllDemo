//
//  AppDelegate.m
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/17.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoListViewController.h"
//#import<JSPatch/JSPatch.h>
#import "JSPatchPlatform/JSPatch.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    DemoListViewController *demoVC = [[DemoListViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:demoVC];
    
    self.window = [[UIWindow alloc]init];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
//    用于测试本地mian.js是否能够运行成功
//    [JSPatch testScriptInBundle];
    
    //线上
    [JSPatch startWithAppKey:@"fb18bf56d1d8f928"];
    [JSPatch sync];
    

    
    return YES;
}


#pragma  mark spotlight 相关事件处理
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler{
    NSString *identifier = userActivity.userInfo[@"kCSSearchableItemActivityIdentifier"];
    UINavigationController *navi = (UINavigationController *)self.window.rootViewController;
    
    DemoListViewController *vc = [navi viewControllers][0];
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(100, 200, 200, 200)];
    [img setImage:[UIImage imageNamed:[NSString stringWithFormat:@"h%@",identifier]]];
    [vc.mainTableView addSubview:img];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [img removeFromSuperview];
    });
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
