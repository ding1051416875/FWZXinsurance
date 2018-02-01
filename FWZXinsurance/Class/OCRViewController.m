//
//  OCRViewController.m
//  FWZXinsurance
//
//  Created by ding on 2017/11/28.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "OCRViewController.h"
#import <objc/runtime.h>

@interface OCRViewController ()

@end

@implementation OCRViewController
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *image = [Maker makeImgView:CGRectMake(0, 0, kWidth, kHeight) img:@"backgroundlaunch"];
    [self.view addSubview:image];
    
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
