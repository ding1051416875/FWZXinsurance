//
//  Occupation.m
//  FWZXinsurance
//
//  Created by ding on 2017/12/20.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "Occupation.h"
#import "AddressPickView.h"
#import "AddressPickTableView.h"
#import "Address.h"
#import "AddrObject.h"

#import "JobPickView.h"

@interface Occupation()
{
    JobPickView *_zmjPickView;
}
@property (nonatomic,strong) NSString *data;
//@property(nonatomic, strong) AddressPickView *addressPickView;
//@property(nonatomic, strong) UIView *backView;
@end
@implementation Occupation
- (void)getStage:(CDVInvokedUrlCommand *)command
{
    NSString *data = [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:0]];
    _data = data;
    [self.viewController.view endEditing:YES];
    [self zmjPickView];
    [_zmjPickView show];
    __weak typeof(self) weakSelf = self;
    _zmjPickView.determineBtnBlock = ^(NSString *xianName, NSString *code) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        CDVPluginResult *result = nil;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if(![Check isEmptyString:xianName])
        {
            [dict setObject:@"成功" forKey:@"result_msg"];
            [dict setObject:@"1" forKey:@"result_code"];
            [dict setObject:xianName forKey:@"result_data"];
            [dict setObject:code forKey:@"result_occupation_code"];
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
- (JobPickView *)zmjPickView{
    if (!_zmjPickView) {
        _zmjPickView = [[JobPickView alloc]initWithFrame:self.viewController.view.bounds data:_data];
    
    }
    return _zmjPickView;
}
//- (void)getStage:(CDVInvokedUrlCommand *)command
//{
//    NSString *url = [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:0]];
//    [kUserDefaults setObject:url forKey:@"stageUrl"];
//    [kUserDefaults synchronize];
//    self.address = [[Address alloc] init];
//    [self handlebackView:command url:url];
//    [self jumpToSelectView];
//}
//- (void)handlebackView:(CDVInvokedUrlCommand *)command url:(NSString *)url{
//    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
//    self.backView.backgroundColor = [UIColor blackColor];
//    self.backView.alpha = 0.39;
//    self.backView.hidden = YES;
//    [self.viewController.view addSubview:self.backView];
//    UITapGestureRecognizer *blurviewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blurViewTaped:)];
//    [self.backView addGestureRecognizer:blurviewTap];
//    __weak typeof(self) weakSelf = self;
//    self.addressPickView = [[AddressPickView alloc] init:self.address];
//    self.addressPickView.confirmBlock = ^(Address *address){
//        address.userName = weakSelf.address.userName;
//        address.phone = weakSelf.address.phone;
//        address.address = weakSelf.address.address;
//        weakSelf.address = address;
//        [weakSelf hideSelectView];
////        [weakSelf.viewController.view showSuccess:[NSString stringWithFormat:@"%@,%@,%@",weakSelf.address.provinceName,weakSelf.address.cityName,weakSelf.address.districtName]];
//        CDVPluginResult *result = nil;
//        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//        if(![Check isEmptyString:address.provinceName])
//        {
//            //拼接字符串
//            NSString *address=[NSString stringWithFormat:@"%@",weakSelf.address.districtName];
//            //            NSString *code = [NSString stringWithFormat:@"%ld %ld %ld",shengId,shiId,xianId];
//            [dict setObject:@"成功" forKey:@"result_msg"];
//            [dict setObject:@"1" forKey:@"result_code"];
//            [dict setObject:address forKey:@"result_data"];
//            [dict setObject:weakSelf.address.distId forKey:@"result_occupation_code"];
////            [dict setObject:@(shengId) forKey:@"code_province"];
////            [dict setObject:@(shiId) forKey:@"code_city"];
////            [dict setObject:@(xianId) forKey:@"code_area"];
//            result=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
//            //传值（消息）到JS文件
//            [weakSelf.commandDelegate sendPluginResult:result callbackId:command.callbackId];
//        }else{
//            [dict setObject:@"失败" forKey:@"result_msg"];
//            [dict setObject:@"0" forKey:@"result_code"];
//
//            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
//            [weakSelf.commandDelegate sendPluginResult:result callbackId:command.callbackId];
//        }
//    };
//    [self.viewController.view addSubview:self.addressPickView];
//}
//
//- (void)jumpToSelectView{
//    [UIView animateWithDuration:0.6 animations:^{
//        self.backView.hidden = NO;
//        [self.addressPickView setY:(kHeight - 746/2)];
//    }completion:^(BOOL finish){
//
//    }];
//}
//
//- (void)hideSelectView{
//    [UIView animateWithDuration:0.3 animations:^{
//        self.backView.hidden = YES;
//        [self.addressPickView setY:kHeight];
//    }completion:^(BOOL finish){
//
//    }];
//}
//
//- (void)blurViewTaped:(id)sender{
//    [self hideSelectView];
//}
@end
