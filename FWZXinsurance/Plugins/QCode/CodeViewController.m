//
//  CodeViewController.m
//  FWZXinsurance
//
//  Created by ding on 2017/11/28.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "CodeViewController.h"

@interface CodeViewController ()

@end

@implementation CodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    UIButton *back = [Maker makeBtn:CGRectMake(20, 20, 60, 30) title:@"返回" img:@"" font:kFont_Lable_14 target:self action:@selector(backBtnClicked)];
    [self.view addSubview:back];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth/2, kHeight/2)];
    image.center = self.view.center;
    image.image = self.codeImage;
    [self.view addSubview:image];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
}
- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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
