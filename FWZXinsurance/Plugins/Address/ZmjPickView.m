//
//  ZmjPickView.m
//  ZmjPickView
//
//  Created by XLiming on 17/1/16.
//  Copyright © 2017年 郑敏捷. All rights reserved.
//

#import "ZmjPickView.h"
#import "AreaModel.h"
#import "CityModel.h"
#import "Model.h"
#define MainBackColor [UIColor colorWithRed:240/255.0 green:239/255.0 blue:245/255.0 alpha:1]

@interface ZmjPickView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView   *pickerView;

@property (strong, nonatomic) UIButton       *cancelBtn;

@property (strong, nonatomic) UIButton       *DetermineBtn;

@property (strong, nonatomic) UILabel        *addressLb;

@property (strong, nonatomic) UIView         *darkView;

@property (strong, nonatomic) UIView         *backView;

@property (strong, nonatomic) UIBezierPath   *bezierPath;

@property (strong, nonatomic) CAShapeLayer   *shapeLayer;

@property (strong, nonatomic) NSMutableArray        *shengArray;

@property (strong, nonatomic) NSMutableArray        *shiArray;

@property (strong, nonatomic) NSMutableArray        *xianArray;

@property (strong, nonatomic) NSMutableArray *shiArr;

@property (strong, nonatomic) NSMutableArray *xianArr;

@property (strong, nonatomic) NSString       *addressStr;

@property (nonatomic,strong) NSArray *cityList;

@property (nonatomic,strong) NSArray *areaList;

@end

@implementation ZmjPickView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 300);
        
        [self initData];
        
        [self initGesture];
    }
    return self;
}

- (void)show {
    
    [self initView];
}

- (void)initView {
    
    [self showInView:[[UIApplication sharedApplication].windows lastObject]];
    
    [self addSubview:self.darkView];
    [self addSubview:self.backView];
   
    [self.backView addSubview:self.cancelBtn];
    [self.backView addSubview:self.DetermineBtn];
//    [self.backView addSubview:self.addressLb];
    [self.backView addSubview:self.pickerView];
    
    [self bezierPath];
    [self shapeLayer];
    CityModel *city = _shengArray[0];
    AreaModel *area = _shiArr[0];
    Model *model = _xianArr[0];
    _addressLb.text = _addressStr.length > 0? _addressStr : [NSString stringWithFormat:@"%@%@%@",city.name,_shiArr.count > 0? area.name:0,_xianArr.count > 0? model.name:0];
}

- (void)initData {
    
    [self shiArr];
    [self xianArr];
    [self shengArray];
    [self shiArray];
    [self xianArray];
  
//    _shengArray = [self JsonObject:@"sheng.json"];
//    _shiArray   = [self JsonObject:@"shi.json"];
//    _xianArray  = [self JsonObject:@"xian.json"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"add" ofType:@"json"];
    NSString *jsonStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSData *json = [[NSData alloc] initWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *ary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
    
    for(NSDictionary *cityDic in ary){
        CityModel *cityModel = [CityModel cityModelWithDict:cityDic];
        self.cityList = cityModel.cityList;
        [_shengArray addObject:cityModel];
        NSLog(@"%@",_shiArray);
        for(NSDictionary *areaDic in self.cityList){
            AreaModel *areaModel = [AreaModel areaModelWithDict:areaDic];
            self.areaList = areaModel.areaList;
            [_shiArray addObject:areaModel];
            for(NSDictionary *dic in self.areaList){
                Model *model = [Model modelWithDict:dic];
                [_xianArray addObject:model];
            }
        }
    }

    CityModel *city = _shengArray[0];
    NSInteger index = [city.code integerValue];

    [_shiArr removeAllObjects];

    for (int i = 0; i < _shiArray.count; i++) {
        AreaModel *model = _shiArray[i];
        if ([model.code integerValue]/1000 == index/1000) {

            [_shiArr addObject:_shiArray[i]];
        }

    }
     AreaModel *model = _shiArray[0];
    index =[model.code integerValue];

    [_xianArr removeAllObjects];

    for (int i = 0; i < _xianArray.count; i++) {
        Model *model =_xianArray[i];
        if ([model.code integerValue]/100 == index/100) {

            [_xianArr addObject:_xianArray[i]];
        }
    }
}

- (void)initGesture {

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
}

- (void)showInView:(UIView *)view {
    
    [UIView animateWithDuration:0.3 animations:^{
//
//        CGPoint point = self.center;
//        point.y      -= 250;
//        self.center   = point;
        self.frame = CGRectMake(0, -250, ScreenWidth, ScreenHeight + 300);
    } completion:^(BOOL finished) {
    }];
    
    [view addSubview:self];
}

- (void)dismiss {

    [UIView animateWithDuration:0.3 animations:^{
//
//        CGPoint point = self.center;
//        point.y      += 250;
//        self.center   = point;
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 300);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

// 返回选择器有几列.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}

// 返回每组有几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    switch (component) {
            
        case 0:
            return _shengArray.count;
            break;
            
        case 1:
            return _shiArr.count;
            break;
            
        case 2:{
//            AreaModel *area  = _xianArr[component];
            return _xianArr.count;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

// 返回第component列第row行的内容（标题）
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (component) {
            
        case 0:{
            CityModel *city = _shengArray[row];
            return  city.name;
        }
           
            break;
            
        case 1:
        {
            AreaModel *model = _shiArr[row];
            return model.name;
        }
            break;
            
        case 2:
        {
            Model *area  = _xianArr[row];
            return area.name;
        }
            
            break;
            
        default:
            break;
    }
    return nil;
}

// 设置row字体，颜色
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel* pickerLabel            = (UILabel*)view;
    
    if (!pickerLabel){
        pickerLabel                 = [[UILabel alloc] init];
        pickerLabel.textAlignment   = NSTextAlignmentCenter;
        pickerLabel.backgroundColor = [UIColor clearColor];
        pickerLabel.font            = [UIFont systemFontOfSize:16.0];
    }
    
    pickerLabel.text                = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}

// 选中第component第row的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (component) {
            
        case 0:{

            CityModel  *city = _shengArray[row];
            NSInteger index = [city.code integerValue];

            [_shiArr removeAllObjects];
            
            for (int i = 0; i < _shiArray.count; i++) {
                AreaModel *model = _shiArray[i];
                if ([model.code integerValue]/10000 == index/10000) {

                    [_shiArr addObject:_shiArray[i]];
                }
            }
            [_pickerView selectRow:0 inComponent:1 animated:NO];
            [_pickerView reloadComponent:1];
            AreaModel *model = _shiArr[0];
            index = [model.code integerValue];
            
            [_xianArr removeAllObjects];
            
            for (int i = 0; i < _xianArray.count; i++) {
                Model *area = _xianArray[i];
                if ([area.code integerValue]/100 == index/100) {
                    
                    [_xianArr addObject:_xianArray[i]];
                }
            }
            [_pickerView selectRow:0 inComponent:2 animated:NO];
            [_pickerView reloadComponent:2];
        }
            break;
            
        case 1:{
            AreaModel *area = _shiArr[row];
            NSInteger index = [area.code integerValue];

            [_xianArr removeAllObjects];
            
            for (int i = 0; i < _xianArray.count; i++) {
                Model *area = _xianArray[i];
                if ([area.code integerValue]/100 == index/100) {
                    
                    [_xianArr addObject:_xianArray[i]];
                }
            }
            [_pickerView selectRow:0 inComponent:2 animated:NO];
            [_pickerView reloadComponent:2];
        }
            break;
            
        default:
            break;
    }
    
    NSInteger shengRow = [_pickerView selectedRowInComponent:0];
    NSInteger shiRow   = [_pickerView selectedRowInComponent:1];
    NSInteger xianRow  = [_pickerView selectedRowInComponent:2];
    
    CityModel *city = _shengArray[shengRow];
    AreaModel *area = _shiArr[shiRow];
    Model *model = _xianArr[xianRow];
    _addressLb.text = [NSString stringWithFormat:@"%@%@%@",city.name,
                       _shiArr.count > 0? area.name:0,
                       _xianArr.count > 0? model.name:0];
}

- (id)JsonObject:(NSString *)jsonStr {
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:jsonStr ofType:nil];
    NSData *jsonData   = [[NSData alloc] initWithContentsOfFile:jsonPath];
    NSError *error;
    id JsonObject      = [NSJSONSerialization JSONObjectWithData:jsonData
                                                  options:NSJSONReadingAllowFragments
                                                    error:&error];
    return JsonObject;
}

- (UIView *)darkView {
    if (!_darkView) {
        _darkView                 = [[UIView alloc]init];
        _darkView.frame           = self.frame;
        _darkView.backgroundColor = [UIColor blackColor];
        _darkView.alpha           = 0.3;
    }
    return _darkView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView                 = [[UIView alloc]init];
        _backView.frame           = CGRectMake(0, ScreenHeight, ScreenWidth, 250);
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIBezierPath *)bezierPath {
    if (!_bezierPath) {
        _bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.backView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    }
    return _bezierPath;
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer          = [[CAShapeLayer alloc] init];
        _shapeLayer.frame    = _backView.bounds;
        _shapeLayer.path     = _bezierPath.CGPath;
        _backView.layer.mask = _shapeLayer;
    }
    return _shapeLayer;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView                 = [[UIPickerView alloc]init];
        _pickerView.frame           = CGRectMake(0, 50, ScreenWidth, 200);
        _pickerView.delegate        = self;
        _pickerView.dataSource      = self;
        _pickerView.backgroundColor = MainBackColor;
    }
    return _pickerView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn       = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelBtn.frame = CGRectMake(0, 0, 50, 50);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)DetermineBtn {
    if (!_DetermineBtn) {
        _DetermineBtn       = [UIButton buttonWithType:UIButtonTypeSystem];
        _DetermineBtn.frame = CGRectMake(ScreenWidth - 50, 0, 50, 50);
        [_DetermineBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_DetermineBtn addTarget:self action:@selector(determineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _DetermineBtn;
}

- (UILabel *)addressLb {
    if (!_addressLb) {
        _addressLb               = [[UILabel alloc]init];
        _addressLb.frame         = CGRectMake(50, 0, ScreenWidth - 100, 50);
        _addressLb.textAlignment = NSTextAlignmentCenter;
        _addressLb.font          = [UIFont systemFontOfSize:16.0];
    }
    return _addressLb;
}

- (void)determineBtnAction:(UIButton *)button {
    
    NSInteger shengRow = [_pickerView selectedRowInComponent:0];
    NSInteger shiRow   = [_pickerView selectedRowInComponent:1];
    NSInteger xianRow  = [_pickerView selectedRowInComponent:2];
    CityModel *city = _shengArray[shengRow];
    AreaModel *area = _shiArr[shiRow];
    Model *model = _xianArr[xianRow];
//    _addressLb.text = _addressStr.length > 0? _addressStr : [NSString stringWithFormat:@"%@%@%@",city.name,_shiArr.count > 0? area.name:0,_xianArr.count > 0? model.name:0];
    _addressStr = [NSString stringWithFormat:@"%@%@%@",city.name,
                   _shiArr.count > 0?  area.name:@"",
                   _xianArr.count > 0? model.name:@""];
    
    if (self.determineBtnBlock) {
        self.determineBtnBlock([city.code integerValue],
                               _shiArr.count > 0?  [area.code integerValue]:0,
                               _xianArr.count > 0? [model.code integerValue]:0,
                               city.name,
                               _shiArr.count > 0?  area.name:@"",
                               _xianArr.count > 0? model.name:@"");
    }
    
    [self dismiss];
}
- (NSMutableArray *)shengArray
{
    if (!_shengArray) {
        _shengArray = [[NSMutableArray alloc] init];
    }
    return _shengArray;
}
- (NSMutableArray *)shiArray{
    if (!_shiArray) {
        _shiArray = [[NSMutableArray alloc] init];
    }
    return _shiArray;
}
- (NSMutableArray *)xianArray
{
    if (!_xianArray) {
        _xianArray = [[NSMutableArray alloc] init];
    }
    return _xianArray;
}
- (NSMutableArray *)shiArr {
    if (!_shiArr) {
        _shiArr  = [[NSMutableArray array]init];
    }
    return _shiArr;
}

- (NSMutableArray *)xianArr {
    if (!_xianArr) {
        _xianArr = [[NSMutableArray array]init];
    }
    return _xianArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
