//
//  SignDrawViewController.m
//  FWZXinsurance
//
//  Created by ding on 2017/11/30.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "SignDrawViewController.h"
#import "PSDrawBoarderView.h"
#import "PSDataManager.h"
@interface SignDrawViewController ()
@property (nonatomic,strong) PSDrawBoarderView *drawBoarderView;

@end

@implementation SignDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.3f;
    [self.view addSubview:backgroundView];
    self.drawBoarderView = [[PSDrawBoarderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.drawBoarderView.backgroundColor = kColor_Clear;
    [self.view addSubview:self.drawBoarderView];
    
    __weak __typeof(self) weakself = self;
    self.drawBoarderView.back = ^(NSString *name){
        weakself.backImage(nil, NO);
        [weakself backClick];
    };
    self.drawBoarderView.saveImage = ^(UIImage *image) {
        weakself.backImage(image, YES);
        [weakself backClick];
    };
}
- (void)backClick {
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
