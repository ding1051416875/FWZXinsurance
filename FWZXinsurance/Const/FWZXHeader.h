//
//  FWZXHeader.h
//  FWZXinsurance
//
//  Created by 丁晓雷 on 2017/11/23.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#ifndef FWZXHeader_h
#define FWZXHeader_h
#pragma mark - 设备相关 ------------------------------------------------------------------------------------------
//__IPHONE_OS_VERSION_MAX_ALLOWED
#define IOS9   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IOS8   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 )
//#define IOS7   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
#define IOS6   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
#define kSCREN_BOUNDS  [[UIScreen mainScreen] applicationFrame]

#pragma mark UIColor-----------------------------------

#define kColor_Gray   [UIColor grayColor]
#define kColor_Black  [UIColor blackColor]
#define kColor_White  [UIColor whiteColor]
#define kColor_Red    [UIColor redColor]
#define kColor_Blue   [UIColor blueColor]
#define kColor_Green  [UIColor greenColor]
#define kColor_Clear  [UIColor clearColor]
//所有页面标题汉字的颜色（深灰色）


/**颜色RGB*/
#define RGB(r,g,b) ([UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f])
/**颜色RGBA*/
#define RGBA(r,g,b,a) ([UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)])

/**十六进制色值*/
#define hexColor(hex) [UIColor colorWithHex:hex]
/**主色**/
#define MainColor hexColor(0xef5757)
#define kColor_backgroundView hexColor(0xffffff)
#define kColor_BlackTitle hexColor(0x333333)
#define kColor_BlackTitleDetail hexColor(0x666666)
#define kColor_GrayTitle hexColor(0x999999)
#define kColor_GrayTitleDetail hexColor(0x808080)
#define kColor_line hexColor(0xf2f2f2)
#define kColor_border   hexColor(0xcccccc)
#define kColor_redTitle hexColor(0xff6666)
#define kColor_lineGray RGB(242,242,242)


/**拼接URL地址*/
#define kApendURL(str) [kHostAdress stringByAppendingString:str]


#pragma mark - Font ------------------------------------------------------------------------------------------

#define kFont_Light_10 [UIFont fontWithName:@"STHeitiSC-Light" size:10.0f]
#define kFont_Light_12 [UIFont fontWithName:@"STHeitiSC-Light" size:12.0f]
#define kFont_Light_13 [UIFont fontWithName:@"STHeitiSC-Light" size:13.0f]
#define kFont_Light_14 [UIFont fontWithName:@"STHeitiSC-Light" size:14.0f]
#define kFont_Light_15 [UIFont fontWithName:@"STHeitiSC-Light" size:15.0f]
#define kFont_Light_16 [UIFont fontWithName:@"STHeitiSC-Light" size:16.0f]
#define kFont_Light_18 [UIFont fontWithName:@"STHeitiSC-Light" size:18.0f]
#define kFont_Medium_12 [UIFont fontWithName:@"STHeitiSC-Medium" size:12.0f]
#define kFont_Medium_14 [UIFont fontWithName:@"STHeitiSC-Medium" size:14.0f]
#define kFont_Medium_16 [UIFont fontWithName:@"STHeitiSC-Medium" size:16.0f]
#define kFont_Medium_18 [UIFont fontWithName:@"STHeitiSC-Medium" size:18.0f]
#define kFont_Medium_22 [UIFont fontWithName:@"STHeitiSC-Medium" size:22.0f]

#define kFont_Number_Menu_12 [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:12.0f]
#define kFont_Number_Menu_14 [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:14.0f]
#define kFont_Number_Menu_16 [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:16.0f]

/**屏幕尺寸-宽度*/
#define kWidth ([UIScreen mainScreen].bounds.size.width)
/**屏幕尺寸-高度*/
#define kHeight ([UIScreen mainScreen].bounds.size.height)
#define kNavigationBarHeight 64
#define kTabbarHeight 49

/* { thread } */
#define __async_opt__  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define __async_main__ dispatch_async(dispatch_get_main_queue()


#define KHistorySearchPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PYSearchhistories.plist"]



//**AppDelegate**//
#define kApplicationDelegate ([UIApplication sharedApplication].deleagte)
/**NSUserDefaults*/
#define kUserDefaults [NSUserDefaults standardUserDefaults]
#define NetWorkStatus ((AppDelegate *)([UIApplication sharedApplication].delegate)).status

#define kLoginToken @"loginToken"
#define Ktoken [[NSUserDefaults standardUserDefaults] valueForKey:kLoginToken]

//创建URL
#define kInitURL(string) [NSURL URLWithString:string]

/**列表页筛选条件按钮的基础tag值*/
#define kOrderBtnBaseTag 1000

#define kpageSize 10

#define kFont_Lable_20 [UIFont systemFontOfSize:20]
#define kFont_Lable_19 [UIFont systemFontOfSize:19]
#define kFont_Lable_18 [UIFont systemFontOfSize:18]
#define kFont_Lable_17 [UIFont systemFontOfSize:17]
#define kFont_Lable_16 [UIFont systemFontOfSize:16]
#define kFont_Lable_15 [UIFont systemFontOfSize:15]
#define kFont_Lable_14 [UIFont systemFontOfSize:14]
#define kFont_Lable_13 [UIFont systemFontOfSize:13]
#define kFont_Lable_12 [UIFont systemFontOfSize:12]
#define kFont_Lable_10 [UIFont systemFontOfSize:10]


/**首次启动*/
static NSString *const kFirstLuanch=@"FirstLuanch";


#if __has_feature(objc_arc)
#define SAFE_ARC_PROP_RETAIN strong
#define SAFE_ARC_RETAIN(x) (x)
#define SAFE_ARC_RELEASE(x)
#define SAFE_ARC_AUTORELEASE(x) (x)
#define SAFE_ARC_BLOCK_COPY(x) (x)
#define SAFE_ARC_BLOCK_RELEASE(x)
#define SAFE_ARC_SUPER_DEALLOC()
#define SAFE_ARC_AUTORELEASE_POOL_START() @autoreleasepool {
#define SAFE_ARC_AUTORELEASE_POOL_END() }
#else
#define SAFE_ARC_PROP_RETAIN retain
#define SAFE_ARC_RETAIN(x) ([(x) retain])
#define SAFE_ARC_RELEASE(x) ([(x) release])
#define SAFE_ARC_AUTORELEASE(x) ([(x) autorelease])
#define SAFE_ARC_BLOCK_COPY(x) (Block_copy(x))
#define SAFE_ARC_BLOCK_RELEASE(x) (Block_release(x))
#define SAFE_ARC_SUPER_DEALLOC() ([super dealloc])
#define SAFE_ARC_AUTORELEASE_POOL_START() NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#define SAFE_ARC_AUTORELEASE_POOL_END() [pool release];
#endif


#define BocKey  @"fqqbocweb"

#define BUGLY_APP_ID @"d80c96a245"

#define kHostAdress             @"http://40.125.170.204:8082/FwCustom"


#define NSLog(format, ...) do { \
fprintf(stderr, "<%s : %d> %s\n", \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], \
__LINE__, __func__); \
(NSLog)((format), ##__VA_ARGS__); \
fprintf(stderr, "-------\n"); \
} while (0)
/**
 *  弱引用
 */
#define BXWeakSelf __weak typeof(self) weakSelf = self;

#define BXNoteCenter [NSNotificationCenter defaultCenter]

#define KUserDefault [NSUserDefaults standardUserDefaults]

#define BXScreenH [UIScreen mainScreen].bounds.size.height
#define BXScreenW [UIScreen mainScreen].bounds.size.width
#define BXScreenBounds [UIScreen mainScreen].bounds
#define BXKeyWindow [UIApplication sharedApplication].keyWindow

#endif /* FWZXHeader_h */
