//
//  BankCardRecogPro.h
//  BankCardRecogPro
//


#import <Foundation/Foundation.h>
#import "BankSlideLine.h"
#import <UIKit/UIKit.h>

@interface BankCardRecogPro : NSObject

//授权
@property (nonatomic ,copy) NSString *nsResult;
@property (nonatomic ,copy) NSString *devcode;
@property (nonatomic ,copy) NSString *lpDirectory;

//识别结果 默认值为@""  识别成功后自动赋值 
@property(copy, nonatomic) NSString *resultStr; //银行卡号码字符串
@property(copy, nonatomic) NSString *expiryDate; //凸卡信用卡到期日期
@property(assign, nonatomic) int imageRotate;       //银行卡旋转方向 0-未旋转 1-顺时针180度 3-顺时针270度 4-顺时针90度
//扫描识别后返回银行卡号码区域图片
@property(strong, nonatomic) UIImage *resultImg; //银行卡号码区域图片

/*
 初始化核心,调用其他方法之前，必须调用此初始化，否则，其他函数调用无效
 devcode:开发码
 返回值：0-核心初始化成功；其他失败，具体失败原因参照开发手册
 */
-(int)InitBankCardWithDevcode:(NSString *)devcode;

/*
 设置感兴区域
 参数：检边区域在实际图像中到整张图片上、下、左、右的距离，与图像分辨率和检边区域frame有关，详见demo设置
 */
- (void) setRoiWithLeft:(int)nLeft Top:(int)nTop Right:(int)nRight Bottom:(int)nBottom;

/*
 检边识别接口
 参数：图像帧数据以及其宽高
 返回值：BankSlideLine有5个属性；leftLine、rightLine、topLine、bottomLine的值为1时检测到边，为0时未检测到边线；
 allLine-0表示识别成功，allLine-1表示检测到边未识别，allLine-2表示未检测到边线
 */
- (BankSlideLine *) RecognizeStreamNV21Ex:(UInt8 *)buffer Width:(int)width Height:(int)height;

/*
 银行卡号码和信用卡到期是根据识别卡面获取的，目前只能识别凸卡信用卡到期日期;
 以下四条信息根据银行卡号获取到,cardNumber参数是内容为银行卡号的字符串；获取成功后银行信息保存在字典中;
 字典格式key值如下：
 bankCode = 机构代码;
 bankName = 银行名字
 cardType = 卡种
 cradName = 卡名
 */
- (NSDictionary *)getBankInfoWithCardNO:(NSString *)cardNumber;

/*
 设置是否开启过滤无效银行卡功能 不调用默认为不开启
 参数：YES开启 NO不开启
 无返回值
 */
- (void)setInvalidBankCard:(BOOL)isInvalid;

/*
 设置是否开启检测识别信用卡有效日期功能 不调用默认为不开启
 参数：YES开启 NO不开启
 无返回值
 */
- (void)setBankExpiryDateFlag:(BOOL)isRecognize;


/*
 获取识别核心版本号接口
 返回值：核心初始化成功返回核心版本号，否则为初始化错误提示代码
 */
- (NSString *)getRecogCoreVersion;

/*释放核心*/
- (void) recogFree;


@end
