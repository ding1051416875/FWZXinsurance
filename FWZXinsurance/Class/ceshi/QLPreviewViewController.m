//
//  QLPreviewViewController.m
//  FWZXinsurance
//
//  Created by ding on 2017/12/29.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "QLPreviewViewController.h"

@interface QLPreviewViewController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate>

@end

@implementation QLPreviewViewController
- (instancetype)init{
    self = [super init];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

#pragma mark - QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"text" ofType:@"ppt"];
    NSURL *url = [NSURL fileURLWithPath:path];
    return  url;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
