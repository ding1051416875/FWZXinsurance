//
//  Email.h
//  FWZXinsurance
//
//  Created by 丁晓雷 on 2017/11/24.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "CDVPlugin.h"

@interface Email : CDVPlugin
- (void)sendEmail:(CDVInvokedUrlCommand *)command;

@end
