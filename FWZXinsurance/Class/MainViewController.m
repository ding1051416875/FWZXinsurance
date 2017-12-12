//
//  MainViewController.m
//  FWZXinsurance
//
//  Created by 丁晓雷 on 2017/11/16.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    
//    self.startPage = @"http://139.219.62.113/web/login/login.html";
//    self.startPage = @"http://192.168.5.173/web/login/login.html";
    self.startPage = @"http://192.168.5.23:8100/web/login/login.html";
//    self.startPage = self.urlString;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //网络监测
    [self setNetwork];
    self.view.backgroundColor = kColor_White;
    self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.webView.scrollView.bounces = NO;
//    self.wkwebView.frame =CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
//    self.wkwebView.scrollView.bounces = NO;
    UIButton *back = [Maker makeBtn:CGRectMake(0, 10, 50, 50) title:@"" img:@"back" font:kFont_Lable_14 target:self action:@selector(backBtnClicked)];
//    [self.view addSubview:back];
}
- (void)backBtnClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setNetwork{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                [self alertControler:@"您正在使用WIFI环境"];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                [self alertControler:@"您正在使用自带网络"];
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"没有网络");
                [self alertControler:@"没有网络连接"];
            }
                break;
            case AFNetworkReachabilityStatusUnknown:
            {
                NSLog(@"未知网络");
                [self alertControler:@"正在使用未知网络"];
            }
                break;
            default:
                break;
        }
    }];
    // 开始监控
    [manager startMonitoring];
}
- (void)alertControler:(NSString *)status
{
    NSString *message = [NSString stringWithFormat:@"%@",status];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
//    [alert addAction:cancel];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)dealloc
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
