//
//  AppDelegate.m
//  FWZXinsurance
//
//  Created by 丁晓雷 on 2017/11/16.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "TestViewController.h"
#import "SortViewController.h"
#import <Bugly/Bugly.h>
#import <iflyMSC/iflyMSC.h>
#import <UMSocialCore/UMSocialCore.h>
@interface AppDelegate ()<BuglyDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //科大讯飞
    [self initXF];
    //Bugly检测
    [self setBugly];
    //友盟分享
    [self initUM];
    SortViewController *main = [[SortViewController alloc] init];
//    MainViewController *main = [[MainViewController alloc] init];
    self.window.rootViewController = main;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
//
//            interfaceOrientation == UIInterfaceOrientationLandscapeRight );
//}

- (void)initXF
{
    //Appid是应用的身份信息,具有唯一性,初始化时必须要传入Appid。
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"5a1d2e34"];
    [IFlySpeechUtility createUtility:initString];
}
- (void)setBugly
{
    BuglyConfig *config = [[BuglyConfig alloc] init];

    //#if DEBUG
    config.debugMode = YES;
    //#endif
    config.blockMonitorEnable = YES;
    config.blockMonitorTimeout = 1.5;
    config.channel =@"Bugly";
    config.consolelogEnable = NO;
    config.viewControllerTrackingEnable = NO;

    [Bugly startWithAppId:BUGLY_APP_ID
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    
    // NOTE: This is only TEST code for BuglyLog , please UNCOMMENT it in your code.
    [self performSelectorInBackground:@selector(testLogOnBackground) withObject:nil];
    
}
/**
 *    @brief TEST method for BuglyLog
 */
- (void)testLogOnBackground {
    int cnt = 0;
    while (1) {
        cnt++;
        
        switch (cnt % 5) {
            case 0:
                BLYLogError(@"Test Log Print %d", cnt);
                break;
            case 4:
                BLYLogWarn(@"Test Log Print %d", cnt);
                break;
            case 3:
                BLYLogInfo(@"Test Log Print %d", cnt);
                BLYLogv(BuglyLogLevelWarn, @"BLLogv: Test", NULL);
                break;
            case 2:
                BLYLogDebug(@"Test Log Print %d", cnt);
                BLYLog(BuglyLogLevelError, @"BLLog : %@", @"Test BLLog");
                break;
            case 1:
            default:
                BLYLogVerbose(@"Test Log Print %d", cnt);
                break;
        }
        
        // print log interval 1 sec.
        sleep(1);
    }
}

#pragma mark - BuglyDelegate
- (NSString *)attachmentForException:(NSException *)exception {
    NSLog(@"(%@:%d) %s %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__,exception);
    
    return @"This is an attachment";
}
- (void)initUM{
    //打开调试日志
//    [[UMSocialManager defaultManager] openLog:YES];
//    [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = NO;
//    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5a1e5260f43e482fdc0000ea"];
//    [self configUSharePlatforms];
//
//    [self confitUShareSettings];
    
    
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5a1e5260f43e482fdc0000ea"];
    //获取友盟social版本号
    NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession  appKey:@"wx5a2768ce01c9795d" appSecret:@"d4758ed8ca6d22e6c3595f2a13a6ffad" redirectURL:@""];
  
}
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}
- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession  appKey:@"wx5a2768ce01c9795d" appSecret:@"d4758ed8ca6d22e6c3595f2a13a6ffad" redirectURL:@""];
    /*
     * 移除相应平台的分享，如微信收藏
     */
//    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];

}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
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
