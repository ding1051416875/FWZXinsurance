//
//  ResultViewController.m
//  IDCardDemo
//

#import "ResultViewController.h"
#import "ViewController.h"
//屏幕的宽、高
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ResultViewController ()

@end

@implementation ResultViewController

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageWithContentsOfFile:self.cropImagepath];
    self.imageView.image = image;
    self.textView.text = self.resultString;
    self.textView.layoutManager.allowsNonContiguousLayout = NO;
    
    UIButton *Btn = [Maker makeBtn:CGRectMake(10, 20, 100, 100) title:@"back" img:@"" font:kFont_Lable_16 target:self action:@selector(back)];
    [self.view addSubview:Btn];
}
- (void)back{
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
