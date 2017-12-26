//
//  CameraViewController.m
//  FWZXinsurance
//
//  Created by ding on 2017/12/14.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "CameraViewController.h"
#import "CCPClipCaremaImage.h"
#define MAINSCREEN_BOUNDS  [UIScreen mainScreen].bounds
@interface CameraViewController ()
{
    CCPClipCaremaImage *view;
    //    UIImageView *imgV;
}
@end

@implementation CameraViewController
- (void)buildUI {
    if (!view) {
        
        view = [[CCPClipCaremaImage alloc] initWithFrame:self.view.bounds];
        view.transform =   CGAffineTransformMakeRotation(M_PI*2);
        [self.view addSubview:view];
        [self.view sendSubviewToBack:view];
    }
    [view startCamera];
    UIButton *flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [flashButton setBackgroundImage:[UIImage imageNamed:@"iconfont-llalbumflashon.png"] forState:UIControlStateNormal];
    flashButton.frame = CGRectMake(MAINSCREEN_BOUNDS.size.width - 50, 20, 30, 30);
    [flashButton addTarget:self action:@selector(flashAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [takePhotoButton setTitle:@"拍照" forState:UIControlStateNormal];
    takePhotoButton.titleLabel.textColor = [UIColor colorWithRed:82 green:172 blue:205 alpha:1.0];
    takePhotoButton.frame = CGRectMake(MAINSCREEN_BOUNDS.size.width - 80, self.view.center.y - 50, 80, 80);
    takePhotoButton.transform  = CGAffineTransformMakeRotation(-M_PI/2);
    [takePhotoButton addTarget:self action:@selector(takePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    //    imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
    //    imgV.backgroundColor = [UIColor redColor];
    //    imgV.contentMode = UIViewContentModeScaleAspectFit;
    //    imgV.image = nil;
    //    imgV.hidden = YES;
    //
    //    [self.view insertSubview:imgV aboveSubview:view];
    [self.view addSubview:flashButton];
    [self.view addSubview:takePhotoButton];
}


- (void)viewDidLoad {
    [self buildUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [view stopCamera];
}


- (void)flashAction:(UIButton *)sender {
    if ([view isOpenFlash]) {
        [sender setImage:[UIImage imageNamed:@"iconfont-llalbumflashon (1)"] forState:UIControlStateNormal];
    }
    else {
        [sender setImage:[UIImage imageNamed:@"iconfont-llalbumflashon"] forState:UIControlStateNormal];
    }
}

- (void)takePhotoAction:(UIButton *)sender {
    [view takePhotoWithCommit:^(UIImage *image) {
        //        imgV.image = image;
        //        imgV.hidden = NO;
        self.saveImage(image);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationMaskPortrait);
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
