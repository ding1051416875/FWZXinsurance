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
#import "DBSphereView.h"
#import "Lottie.h"
#import "GSAudioTool.h"
@interface SortViewController ()
//雪花特效
@property (strong, nonatomic) CADisplayLink *displayLink;
@property (nonatomic,strong) UIImageView *animationView;
@property (nonatomic,strong) DBSphereView *sphereView;
@property (nonatomic,strong) NSTimer *snowTimer;
@property (nonatomic,strong) NSTimer *runTimer;
@end

@implementation SortViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _snowTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(makeSnow) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_snowTimer forMode:NSDefaultRunLoopMode];
    
    [self makeRun];
    _runTimer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(makeRun) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_runTimer forMode:NSDefaultRunLoopMode];
    
    [_sphereView timerStart];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_snowTimer invalidate];
    [_runTimer invalidate];
    [_sphereView timerStop];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = kColor_White;
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    bgView.image = [UIImage imageNamed:@"雪夜.jpg"];
    [self.view addSubview:bgView];
  //播放音乐
//    [[GSAudioTool sharedAudioTool] playBirthSong];
    //弹出提示
    [self showNewStatusesCount:nil];
    _sphereView = [[DBSphereView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
    _sphereView.center = self.view.center;
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *titleAry = @[@"SIT服务器",@"开发测试",@"69服务器",@"233服务器",@"74服务器",@"6服务器",@"测试",@"静态网页",@"4服务器"];
    for(NSInteger i=0;i<titleAry.count;i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:titleAry[i] forState:UIControlStateNormal];
        [btn setTitleColor:kColor_White forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:30];
        btn.frame = CGRectMake(0, 0, 200, 80);
        btn.tag  = i+1;
        [btn addTarget:self
                action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:btn];
        [_sphereView addSubview:btn];
    }
    [_sphereView setCloudTags:array];
    _sphereView.backgroundColor = kColor_Clear;
    [self.view addSubview:_sphereView];
    [self makeSnow];


    
    //奔跑的人
    UIImageView *animationView = [[UIImageView alloc] initWithFrame:CGRectMake(-60, kHeight-70, 60, 60)];
    animationView.image = [UIImage imageNamed:@"deliveryStaff0"];
    _animationView = animationView;
    [self.view addSubview:_animationView];
 
    
//    LOTAnimationView *fengcheView = [LOTAnimationView animationNamed:@"fengchedata"];
//    fengcheView.frame = CGRectMake((kWidth/2+10), kHeight - 150 ,100 ,100) ;
//    fengcheView.contentMode = UIViewContentModeScaleToFill;
//    fengcheView.loopAnimation = YES;
//
//    fengcheView.userInteractionEnabled = NO;
//    [self.view addSubview:fengcheView];
//    [fengcheView playWithCompletion:^(BOOL animationFinished) {
//
//    }];
    

    UIButton *play = [Maker makeBtn:CGRectMake(kWidth/2+100, 100, 80, 80) title:@"" img:@"star" font:kFont_Lable_10 target:self action:@selector(playMusic)];
    [self.view addSubview:play];
    UIButton *stop = [Maker makeBtn:CGRectMake(kWidth-200, 200, 100, 100) title:@"" img:@"star" font:kFont_Lable_10 target:self action:@selector(stopMusic)];
    [self.view addSubview:stop];
  
}
- (void)showNewStatusesCount:(NSInteger)count
{
    //1.创建一个UILabel
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15];
    
    //显示文字
    if (!count) {
        label.text= [NSString stringWithFormat:@"共有%ld条实例数据",count];
    }else{
        label.text = @"点击两颗不一样的✨，有惊喜";
    }
    
    //设置背景
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    //设置frame
    label.width = self.view.frame.size.width;
    label.height=35;
    label.x=0;
    label.y = CGRectGetMaxY([self.navigationController navigationBar].frame)-label.frame.size.height;
//    label.y =-label.frame.size.height;
    //添加到导航控制器的view
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    //动画
    CGFloat duratiom = 0.75;
    [UIView animateWithDuration:duratiom animations:^{
        
        label.transform = CGAffineTransformMakeTranslation(0, label.frame.size.height);
    }completion:^(BOOL finished) {
        //延迟delay秒 后 再执行动画
        CGFloat delay = 3.0;
        [UIView animateWithDuration:drand48() delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //恢复到原来的位置
            label.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            //删除控件
            [label removeFromSuperview];
        }];
    }];
}
- (void)playMusic
{
    [[GSAudioTool sharedAudioTool] playBirthSong];
}
- (void)stopMusic
{
    [[GSAudioTool sharedAudioTool] stopBirthSong];
}

- (void)buttonPressed:(UIButton *)btn
{
    //    [_sphereView timerStop];
    
    //    [UIView animateWithDuration:0.3 animations:^{
    //        btn.transform = CGAffineTransformMakeScale(2., 2.);
    //    } completion:^(BOOL finished) {
    //        [UIView animateWithDuration:0.3 animations:^{
    //            btn.transform = CGAffineTransformMakeScale(1., 1.);
    //        } completion:^(BOOL finished) {
    //            [_sphereView timerStart];
    //        }];
    //    }];
    
    if(btn.tag ==1)
    {
        MainViewController  *main = [[MainViewController alloc] init];
        main.urlString = @"http://139.219.229.132:8088/web/login/login.html";
        [self.navigationController pushViewController:main animated:YES];
    }else if(btn.tag==2){
        TestViewController *text = [[TestViewController alloc] init];
        [self.navigationController pushViewController:text animated:YES];
    }else if(btn.tag==3){
        MainViewController  *main = [[MainViewController alloc] init];
        main.urlString = @"http://192.168.0.69/web/login/login.html";
        [self.navigationController pushViewController:main animated:YES];
        
    }else if(btn.tag==4){
        MainViewController  *main = [[MainViewController alloc] init];
        main.urlString = @"http://192.168.11.233/web/login/login.html";
        [self.navigationController pushViewController:main animated:YES];
    }else if(btn.tag==5){
        MainViewController  *main = [[MainViewController alloc] init];
        main.urlString = @"http://192.168.5.74:8100/web/login/login.html";
        [self.navigationController pushViewController:main animated:YES];
    }else if (btn.tag==6){
        MainViewController  *main = [[MainViewController alloc] init];
        main.urlString = @"http://192.168.169.6/fw-proposal/web/login/login.html";
        
        [self.navigationController pushViewController:main animated:YES];
    }else if (btn.tag==7){
        CeshiViewController *orc = [[CeshiViewController alloc] init];
        [self.navigationController pushViewController:orc animated:YES];
    }else if (btn.tag==8){
        MainViewController  *main = [[MainViewController alloc] init];
        main.urlString = @"http://www.kianlee.cn/fuwei/web/login/login.html";
        [self.navigationController pushViewController:main animated:YES];
    }else if (btn.tag==9){
        MainViewController  *main = [[MainViewController alloc] init];
        main.urlString = @"http://192.168.169.4/fw-proposal/web/login/login.html";
        [self.navigationController pushViewController:main animated:YES];
    }
}

- (void)makeRun
{
    _animationView.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, 0), CGAffineTransformMakeScale(1, 1));
    NSArray *images = @[[UIImage imageNamed:@"deliveryStaff0"],
                        [UIImage imageNamed:@"deliveryStaff1"],
                        [UIImage imageNamed:@"deliveryStaff2"],
                        [UIImage imageNamed:@"deliveryStaff3"]
                        ];
    _animationView.animationImages = images;
    [_animationView startAnimating];
    [UIView animateWithDuration:5.0 animations:^{
        self.animationView.transform = CGAffineTransformMakeTranslation(kWidth+70, 0);
    }];
}
#define IMAGE_WIDTH            arc4random()%20 + 10
#define IMAGE_X                arc4random()%(int)kWidth
#define IMAGE_ALPHA            ((float)(arc4random()%10))/10
- (void)makeSnow
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"雪花.png"]];
    float x = IMAGE_WIDTH;
    imageView.frame = CGRectMake(IMAGE_X, -30, x, x);
    imageView.alpha = IMAGE_ALPHA;
    [self.view addSubview:imageView];
    
    [self snowFall:imageView];
}
- (void)snowFall:(UIImageView *)aImageView
{
    [UIView beginAnimations:[NSString stringWithFormat:@"%li",(long)aImageView.tag] context:nil];
    [UIView setAnimationDuration:6];
    [UIView setAnimationDelegate:self];
    aImageView.frame = CGRectMake(aImageView.frame.origin.x, kHeight, aImageView.frame.size.width, aImageView.frame.size.height);
    [UIView commitAnimations];
}
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor = hexColor(0xde7345);
//
//    UIButton *xianmu = [UIButton buttonWithTitle:@"SIT 服务器" titleColor:kColor_White font:kFont_Lable_16 target:self action:@selector(xiangmuBtn:)];
//    xianmu.tag = 1;
//    xianmu.frame = CGRectMake(kWidth/2-100, 100, 200, 40);
//    [self.view addSubview:xianmu];
//
//    UIButton *chajian = [UIButton buttonWithTitle:@"开发测试" titleColor:kColor_White font:kFont_Lable_16 target:self action:@selector(xiangmuBtn:)];
//    chajian.tag=2;
//    chajian.frame = CGRectMake(kWidth/2-100, 200, 200, 40);
//    [self.view addSubview:chajian];
//
//    UIButton *OCR = [UIButton buttonWithTitle:@"69 测试服务器" titleColor:kColor_White font:kFont_Lable_16 target:self action:@selector(xiangmuBtn:)];
//    OCR.tag=3;
//    OCR.frame = CGRectMake(kWidth/2-100, 250, 200, 40);
//    [self.view addSubview:OCR];
//
//    UIButton *web = [UIButton buttonWithTitle:@"233 测试服务器" titleColor:kColor_White font:kFont_Lable_16 target:self action:@selector(xiangmuBtn:)];
//    web.tag=4;
//    web.frame = CGRectMake(kWidth/2-100, 300, 200, 40);
//    [self.view addSubview:web];
//
//    UIButton *ceshi74 = [UIButton buttonWithTitle:@"74 测试" titleColor:kColor_White font:kFont_Lable_16 target:self action:@selector(xiangmuBtn:)];
//    ceshi74.tag=5;
//    ceshi74.frame = CGRectMake(kWidth/2-100, 350, 200, 40);
//    [self.view addSubview:ceshi74];
//
//    UIButton *ceshi56 = [UIButton buttonWithTitle:@"108 测试" titleColor:kColor_White font:kFont_Lable_16 target:self action:@selector(xiangmuBtn:)];
//    ceshi56.tag=6;
//    ceshi56.frame = CGRectMake(kWidth/2-100, 400, 200, 40);
//    [self.view addSubview:ceshi56];
//    UIButton *ceshi = [UIButton buttonWithTitle:@"测试" titleColor:kColor_White font:kFont_Lable_16 target:self action:@selector(xiangmuBtn:)];
//    ceshi.tag=7;
//    ceshi.frame = CGRectMake(kWidth/2-100, 450, 200, 40);
//    [self.view addSubview:ceshi];
//
//    UIButton *ceshi8 = [UIButton buttonWithTitle:@"静态IP" titleColor:kColor_White font:kFont_Lable_16 target:self action:@selector(xiangmuBtn:)];
//    ceshi8.tag=8;
//    ceshi8.frame = CGRectMake(kWidth/2-100, 500, 200, 40);
//    [self.view addSubview:ceshi8];
//
//
//
//}
- (void)xiangmuBtn:(UIButton *)btn
{
    if(btn.tag ==1)
    {
        MainViewController  *main = [[MainViewController alloc] init];
        main.urlString = @"http://139.219.229.132:8088/web/login/login.html";
        [self.navigationController pushViewController:main animated:YES];
    }else if(btn.tag==2){
        TestViewController *text = [[TestViewController alloc] init];
        [self.navigationController pushViewController:text animated:YES];
    }else if(btn.tag==3){
        MainViewController  *main = [[MainViewController alloc] init];
        main.urlString = @"http://192.168.0.69/web/login/login.html";
        [self.navigationController pushViewController:main animated:YES];
        
    }else if(btn.tag==4){
        MainViewController  *main = [[MainViewController alloc] init];
        main.urlString = @"http://192.168.11.233/web/login/login.html";
        [self.navigationController pushViewController:main animated:YES];
    }else if(btn.tag==5){
        MainViewController  *main = [[MainViewController alloc] init];
        main.urlString = @"http://192.168.5.74:8100/web/login/login.html";
        [self.navigationController pushViewController:main animated:YES];
    }else if (btn.tag==6){
        MainViewController  *main = [[MainViewController alloc] init];
        main.urlString = @"http://10.145.108.42/web/login/login.html";
        
        [self.navigationController pushViewController:main animated:YES];
    }else if (btn.tag==7){
        CeshiViewController *orc = [[CeshiViewController alloc] init];
        [self.navigationController pushViewController:orc animated:YES];
    }else if (btn.tag==8){
        MainViewController  *main = [[MainViewController alloc] init];
        main.urlString = @"http://www.kianlee.cn/fuwei/web/login/login.html";
        
        [self.navigationController pushViewController:main animated:YES];
        
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
