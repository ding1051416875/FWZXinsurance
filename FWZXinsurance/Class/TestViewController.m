//
//  TestViewController.m
//  FWZXinsurance
//
//  Created by 丁晓雷 on 2017/11/23.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kColor_Green;
    self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.webView.scrollView.bounces = NO;
    UIButton *back = [Maker makeBtn:CGRectMake(10, 30, 80, 30) title:@"back" img:@"" font:kFont_Lable_14 target:self action:@selector(backBtnClicked)];
    [self.view addSubview:back];
}
- (void)backBtnClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
