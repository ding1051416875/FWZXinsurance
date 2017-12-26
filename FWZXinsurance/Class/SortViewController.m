//
//  SortViewController.m
//  FWZXinsurance
//
//  Created by 丁晓雷 on 2017/11/24.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "SortViewController.h"
#import "MainViewController.h"
#import "TestViewController.h"
#import "OCRViewController.h"
#import "WebViewController.h"
#import "CeshiViewController.h"
@interface SortViewController ()

@end

@implementation SortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = hexColor(0xde7345);
 
    UIButton *xianmu = [UIButton buttonWithTitle:@"226 富卫在线服务器接口" titleColor:kColor_White font:kFont_Lable_16 target:self action:@selector(xiangmuBtn:)];
    xianmu.tag = 1;
    xianmu.frame = CGRectMake(kWidth/2-100, 100, 200, 40);
    [self.view addSubview:xianmu];
    
    UIButton *chajian = [UIButton buttonWithTitle:@"开发测试" titleColor:kColor_White font:kFont_Lable_16 target:self action:@selector(xiangmuBtn:)];
    chajian.tag=2;
    chajian.frame = CGRectMake(kWidth/2-100, 200, 200, 40);
    [self.view addSubview:chajian];
    
    UIButton *OCR = [UIButton buttonWithTitle:@"69 测试服务器" titleColor:kColor_White font:kFont_Lable_16 target:self action:@selector(xiangmuBtn:)];
    OCR.tag=3;
    OCR.frame = CGRectMake(kWidth/2-100, 250, 200, 40);
    [self.view addSubview:OCR];
    
    UIButton *web = [UIButton buttonWithTitle:@"173 测试服务器" titleColor:kColor_White font:kFont_Lable_16 target:self action:@selector(xiangmuBtn:)];
    web.tag=4;
    web.frame = CGRectMake(kWidth/2-100, 300, 200, 40);
    [self.view addSubview:web];
    
    UIButton *ceshi = [UIButton buttonWithTitle:@"测试" titleColor:kColor_White font:kFont_Lable_16 target:self action:@selector(xiangmuBtn:)];
    ceshi.tag=5;
    ceshi.frame = CGRectMake(kWidth/2-100, 350, 200, 40);
    [self.view addSubview:ceshi];

    
    
}
- (void)xiangmuBtn:(UIButton *)btn
{
    if(btn.tag ==1)
    {
        MainViewController  *main = [[MainViewController alloc] init];
        main.urlString = @"http://40.125.210.226/web/login/login.html";
        [self presentViewController:main animated:YES completion:nil];
    }else if(btn.tag==2){
        TestViewController *text = [[TestViewController alloc] init];
        [self presentViewController:text animated:YES completion:nil];
    }else if(btn.tag==3){
        MainViewController  *main = [[MainViewController alloc] init];
        main.urlString = @"http://192.168.0.69/web/login/login.html";
        [self presentViewController:main animated:YES completion:nil];
        
    }else if(btn.tag==4){
        MainViewController  *main = [[MainViewController alloc] init];
        main.urlString = @"http://192.168.5.173/web/login/login.html";
        [self presentViewController:main animated:YES completion:nil];
    }else if (btn.tag==5){
        CeshiViewController *orc = [[CeshiViewController alloc] init];
        [self presentViewController:orc animated:YES completion:nil];
    }
}
-(BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            
            interfaceOrientation == UIInterfaceOrientationLandscapeRight );
}
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
