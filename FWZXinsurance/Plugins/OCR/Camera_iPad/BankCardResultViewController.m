//
//  ResultView.m
//  BankCardRecogDemo
//


#import "BankCardResultViewController.h"

@implementation BankCardResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];

    //图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 200)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = _image;
    [self.view addSubview:imageView];
    
    UITextView *textview = [[UITextView alloc] initWithFrame:CGRectMake(0, 264, self.view.bounds.size.width, self.view.bounds.size.height-264)];
    [self.view addSubview:textview];
    
    NSMutableString *result = [[NSMutableString alloc] init];
    for (NSString *str in [_resultDic allKeys]) {
        [result appendFormat:@"%@ : %@\n",str,_resultDic[str]];
    }
    
    //结果字段名替换为中文。。。。。。。。。。。。。。。。。。。。
    NSDictionary *dic = @{
                          @"cardNumber":@"卡号",
                          @"cardName":@"卡片名字",
                          @"bankCode":@"机构代码",
                          @"bankName":@"银行名称",
                          @"expiryDate":@"信用卡有效期",
                          @"cardType":@"卡片类型"
                          };
    NSString *string = [NSString stringWithString:result];
    for (NSString *key in [dic allKeys]) {
        NSString *value = [dic objectForKey:key];
        string = [string stringByReplacingOccurrencesOfString:key withString:value];
    }
    
    textview.text = string;
    textview.font = [UIFont systemFontOfSize:17.0];
    textview.textAlignment = NSTextAlignmentCenter;
    textview.editable = NO;
    
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}
@end
