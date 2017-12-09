//
//  CeshiViewController.m
//  FWZXinsurance
//
//  Created by ding on 2017/11/29.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "CeshiViewController.h"

#import <UShareUI/UShareUI.h>
@interface CeshiViewController ()<UITableViewDelegate,UITableViewDataSource,UMSocialShareMenuViewDelegate>
@property (nonatomic,strong) UITableView *tbView;
@property (nonatomic,strong) NSArray *titleAry;


@end

@implementation CeshiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    [self createUI];
    UIButton *btn = [Maker makeBtn:CGRectMake(10, 20, 100, 40) title:@"back" img:@"" font:kFont_Lable_12 target:self action:@selector(back)];
    [self.view addSubview:btn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
//创建UI界面
- (void)createUI
{
    
    _titleAry = @[@"分享"];
    
    
    
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
//            view = [KeyFrameViewController new];
            [self initShare];
        }
            break;
       
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
- (void)initShare{
    
//    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    
    __weak typeof(self) weakSelf = self;
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [weakSelf shareWebPageToPlatformType:platformType];
    }];
}
//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    //    NSString *thumbURL =  [kUserDefaults objectForKey:kShareUrl];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"京宠" descr:@"最全面，最齐全的宠物社区服务平台" thumImage:[UIImage imageNamed:@"umshare"]];
    //设置网页地址
    shareObject.webpageUrl = @"www.baidu.com";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
    
}
- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
    }
    else{
        if (error) {
            result = [NSString stringWithFormat:@"分享失败 code: %d\n",(int)error.code];
        }
        else{
            result = [NSString stringWithFormat:@"分享失败"];
        }
    }
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享"
    //                                                    message:result
    //                                                   delegate:nil
    //                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
    //                                          otherButtonTitles:nil];
    //    [alert show];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"分享" message:result preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [ac addAction:confirm];
    [ac addAction:cancel];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:ac animated:YES completion:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(BOOL)shouldAutorotate
{
    return YES;
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
