//
//  Add.m
//  FWZXinsurance
//
//  Created by ding on 2017/12/6.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "Add.h"
#import "ZmjPickView.h"
@implementation Add
{
    ZmjPickView *_zmjPickView;
}
- (void)chooseAddress:(CDVInvokedUrlCommand *)command{
    [self.viewController.view endEditing:YES];
    [self zmjPickView];
    [_zmjPickView show];
    [ProgressHUD showSuccess:@"正常"];
    __weak typeof(self) weakSelf = self;
    _zmjPickView.determineBtnBlock = ^(NSInteger shengId, NSInteger shiId, NSInteger xianId, NSString *shengName, NSString *shiName, NSString *xianName) {
         __strong typeof(weakSelf)strongSelf = weakSelf;
        CDVPluginResult *result = nil;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if(![Check isEmptyString:shengName])
        {
            //拼接字符串
            NSString *address=[NSString stringWithFormat:@"%@ %@ %@",shengName,shiName,xianName];
//            NSString *code = [NSString stringWithFormat:@"%ld %ld %ld",shengId,shiId,xianId];
            [dict setObject:@"成功" forKey:@"result_msg"];
            [dict setObject:@"1" forKey:@"result_code"];
            [dict setObject:address forKey:@"text"];
            [dict setObject:@(shengId) forKey:@"code_province"];
            [dict setObject:@(shiId) forKey:@"code_city"];
            [dict setObject:@(xianId) forKey:@"code_area"];
            result=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
            //传值（消息）到JS文件
            [strongSelf.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }else{
            [dict setObject:@"失败" forKey:@"result_msg"];
            [dict setObject:@"0" forKey:@"result_code"];
            
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
            [strongSelf.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }
    };
}
- (ZmjPickView *)zmjPickView{
    if (!_zmjPickView) {
        _zmjPickView = [[ZmjPickView alloc]init];
    }
    return _zmjPickView;
}
@end
