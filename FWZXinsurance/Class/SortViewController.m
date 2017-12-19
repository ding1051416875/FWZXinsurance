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
    // Do any additional setup after loading the view.
//    UIImageView *image = [Maker makeImgView:CGRectMake(0, 0, kWidth, kHeight) img:@"background.png"];
//    [self.view addSubview:image];
    self.view.backgroundColor = hexColor(0xde7345);
 
    UIButton *xianmu = [UIButton buttonWithTitle:@"富卫在线服务器接口" titleColor:kColor_White font:kFont_Lable_16 target:self action:@selector(xiangmuBtn:)];
    xianmu.tag = 1;
    xianmu.frame = CGRectMake(kWidth/2-50, 100, 200, 40);
    [self.view addSubview:xianmu];
    
    UIButton *chajian = [UIButton buttonWithTitle:@"测试" titleColor:kColor_White font:kFont_Lable_16 target:self action:@selector(xiangmuBtn:)];
    chajian.tag=2;
    chajian.frame = CGRectMake(kWidth/2, 200, 100, 40);
//    [self.view addSubview:chajian];
    
    UIButton *OCR = [UIButton buttonWithTitle:@"demo" titleColor:kColor_White font:kFont_Lable_16 target:self action:@selector(xiangmuBtn:)];
    OCR.tag=3;
    OCR.frame = CGRectMake(kWidth/2, 250, 100, 40);
//    [self.view addSubview:OCR];
    
    UIButton *web = [UIButton buttonWithTitle:@"web" titleColor:kColor_White font:kFont_Lable_16 target:self action:@selector(xiangmuBtn:)];
    web.tag=4;
    web.frame = CGRectMake(kWidth/2, 300, 100, 40);
//    [self.view addSubview:web];
    UIButton *ocr = [UIButton buttonWithTitle:@"测试接口" titleColor:kColor_White font:kFont_Lable_16 target:self action:@selector(xiangmuBtn:)];
    ocr.tag=5;
    ocr.frame = CGRectMake(kWidth/2, 350, 100, 40);
//    [self.view addSubview:ocr];
    
    
}
- (void)xiangmuBtn:(UIButton *)btn
{
    if(btn.tag ==1)
    {
        MainViewController  *main = [[MainViewController alloc] init];
//        main.urlString = @"http://139.219.62.113/web/login/login.html";
        main.urlString = @"http://40.125.210.226/web/login/login.html";
        [self presentViewController:main animated:YES completion:nil];
    }else if(btn.tag==2){
        TestViewController *text = [[TestViewController alloc] init];
        [self presentViewController:text animated:YES completion:nil];
    }else if(btn.tag==3){
        CeshiViewController *orc = [[CeshiViewController alloc] init];
        [self presentViewController:orc animated:YES completion:nil];
    }else if(btn.tag==4){
//        WebViewController *web = [[WebViewController alloc] init];
//        [self presentViewController:web animated:YES completion:nil];
    }else{

        MainViewController  *main = [[MainViewController alloc] init];
//        main.urlString = @"http://192.168.5.173/web/login/login.html";
        main.urlString = @"http://192.168.5.74:8100/web/login/login.html";

        
        [self presentViewController:main animated:YES completion:nil];
    }
}
-(BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
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
