//
//  CeshiViewController.m
//  FWZXinsurance
//
//  Created by ding on 2017/11/29.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "CeshiViewController.h"
#import "AddressPickView.h"
#import "AddressPickTableView.h"
#import <UShareUI/UShareUI.h>
#import "Address.h"
#import "AddrObject.h"
#import "BankCardCameraViewController_iPad.h"
#import "QLPreviewViewController.h"
@interface CeshiViewController ()<UITableViewDelegate,UITableViewDataSource,UMSocialShareMenuViewDelegate,UIDocumentInteractionControllerDelegate>
{
    UIDocumentInteractionController *_documentController;
}
@property (nonatomic,strong) UITableView *tbView;
@property (nonatomic,strong) NSArray *titleAry;
@property (nonatomic,strong) Address *address;
@property(nonatomic, strong) AddressPickView *addressPickView;
@property(nonatomic, strong) UIView *backView;


@end

@implementation CeshiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    [self createUI];
    //初始化地址选择模块
    [self handlebackView];
    UIButton *btn = [Maker makeBtn:CGRectMake(10, 20, 100, 40) title:@"back" img:@"" font:kFont_Lable_12 target:self action:@selector(back)];
    [self.view addSubview:btn];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)orientChange:(NSNotification *)noti {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation)
    {
        case UIDeviceOrientationPortrait: {
            [UIView animateWithDuration:0.25 animations:^{
                self.view.transform = CGAffineTransformMakeRotation(0);
                self.view.frame = CGRectMake(0, 0, kWidth, kHeight);
            }];
        }
            break;
        case UIDeviceOrientationLandscapeLeft: {
            [UIView animateWithDuration:0.25 animations:^{
                self.view.transform = CGAffineTransformMakeRotation(M_PI*0.5);
                self.view.frame = CGRectMake(0, 0, kWidth, kHeight);
            }];
        }
            break;
        case UIDeviceOrientationLandscapeRight: {
            [UIView animateWithDuration:0.25 animations:^{
                self.view.transform = CGAffineTransformMakeRotation(-M_PI*0.5);
                self.view.frame = CGRectMake(0, 0, kWidth, kHeight);
            }];
        }
            break;
        default:
            break;
    }
}



- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
//创建UI界面
- (void)createUI
{
    
    _titleAry = @[@"分享",@"选择",@"doc",@"读取ppt",@"识别银行卡"];
    
    self.address = [[Address alloc] init];
    
    _tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-49) style:UITableViewStylePlain];
    _tbView.dataSource = self;
    _tbView.delegate = self;
    _tbView.showsVerticalScrollIndicator = NO;
    _tbView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tbView];
    _tbView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *const cid = @"1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    cell.textLabel.text = _titleAry[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *view = nil;
    switch (indexPath.row) {
        case 0:
        {
            [self initShare];
        }
            break;
        case 1:
        {
             [self jumpToSelectView];
        }
            break;
        case 2:
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"text" ofType:@"ppt"];
            NSURL *url = [NSURL fileURLWithPath:path];
            _documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
            [_documentController setDelegate:self];
            
            //当前APP打开  需实现协议方法才可以完成预览功能
            [_documentController presentPreviewAnimated:YES];
        }
            break;
        case 3:
        {
            view = [QLPreviewViewController new];
        }
            break;
        case 4:
        {
            view = [BankCardCameraViewController_iPad new];
        }
        default:
            
            break;
    }
    view.title = _titleAry[indexPath.row];
    view.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:view animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)handlebackView {
    self.backView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.39;
    self.backView.hidden = YES;
    [self.view addSubview:self.backView];
    UITapGestureRecognizer *blurviewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blurViewTaped:)];
    [self.backView addGestureRecognizer:blurviewTap];
    __weak typeof(self) weakSelf = self;
    self.addressPickView = [[AddressPickView alloc] init:self.address];
    self.addressPickView.confirmBlock = ^(Address *address){
        address.userName = weakSelf.address.userName;
        address.phone = weakSelf.address.phone;
        address.address = weakSelf.address.address;
        weakSelf.address = address;
    
        [weakSelf hideSelectView];
        [weakSelf.tbView reloadData];
        [weakSelf.view showSuccess:[NSString stringWithFormat:@"%@,%@,%@",weakSelf.address.provinceName,weakSelf.address.cityName,weakSelf.address.districtName]];
    };
    [self.view addSubview:self.addressPickView];
}

- (void)jumpToSelectView{
    [UIView animateWithDuration:0.6 animations:^{
        self.backView.hidden = NO;
        [self.addressPickView setY:(kHeight - 746/2)];
    }completion:^(BOOL finish){
        
    }];
}

- (void)hideSelectView{
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.hidden = YES;
        [self.addressPickView setY:kHeight];
    }completion:^(BOOL finish){
        
    }];
}

- (void)blurViewTaped:(id)sender{
    [self hideSelectView];
}

- (void)initShare
{
    
}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}
//
//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskAllButUpsideDown;
//}
//
//-(BOOL)shouldAutorotate
//{
//    return YES;
//}
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    
    //注意：此处要求的控制器，必须是它的页面view，已经显示在window之上了
    return self.navigationController;
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
