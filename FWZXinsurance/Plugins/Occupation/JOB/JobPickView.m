//
//  JobPickView.m
//  FWZXinsurance
//
//  Created by ding on 2017/12/27.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "JobPickView.h"
#import "ProvinceDataModel.h"
#define MainBackColor [UIColor colorWithRed:240/255.0 green:239/255.0 blue:245/255.0 alpha:1]
@interface JobPickView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView   *pickerView;

@property (strong, nonatomic) UIButton       *cancelBtn;

@property (strong, nonatomic) UIButton       *DetermineBtn;

@property (strong, nonatomic) UILabel        *addressLb;

@property (strong, nonatomic) UIView         *darkView;

@property (strong, nonatomic) UIView         *backView;

@property (strong, nonatomic) UIBezierPath   *bezierPath;

@property (strong, nonatomic) CAShapeLayer   *shapeLayer;

@property (strong, nonatomic) NSMutableArray        *shengArray;




@property (nonatomic,assign)NSInteger      selectRowWithProvince; //选中的省份对应的下标

@property (nonatomic,assign)NSInteger      selectRowWithCity; //选中的市级对应的下标

@property (nonatomic,assign)NSInteger      selectRowWithTown; //选中的县级对应的下标

@end
@implementation JobPickView
- (instancetype)initWithFrame:(CGRect)frame data:(NSString *)data
{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 300);
        
        //        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"jobs" ofType:@"json"];
        //        NSString *jsonStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSData *json = [[NSData alloc] initWithData:[data dataUsingEncoding:NSUTF8StringEncoding]];
        NSArray *array  = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ProvinceDataModel *model =[ProvinceDataModel showDataWith:obj];
            [self.shengArray addObject:model];
        }];
    
        
        self.selectRowWithProvince = 0;
        self.selectRowWithCity = 0;
        self.selectRowWithTown = 0;
        
        [self initGesture];
    }
    return self;
}
//- (instancetype)init{
//    self = [super init];
//    if (self) {
//        
//        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 300);
//        
////        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"jobs" ofType:@"json"];
////        NSString *jsonStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//        NSData *json = [[NSData alloc] initWithData:[self.data dataUsingEncoding:NSUTF8StringEncoding]];
//        NSArray *array  = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
//        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            ProvinceDataModel *model =[ProvinceDataModel showDataWith:obj];
//            [self.shengArray addObject:model];
//        }];
//     
//        self.selectRowWithProvince = 0;
//        self.selectRowWithCity = 0;
//        self.selectRowWithTown = 0;
//        
//         [self initGesture];
//    }
//    return self;
//}

- (void)show {
    
    [self initView];
}

- (void)initView {
    
    [self showInView:[[UIApplication sharedApplication].windows lastObject]];
    
    [self addSubview:self.darkView];
    [self addSubview:self.backView];
    [self.backView addSubview:self.cancelBtn];
    [self.backView addSubview:self.DetermineBtn];
    [self.backView addSubview:self.addressLb];
    [self.backView addSubview:self.pickerView];
    
    [self bezierPath];
    [self shapeLayer];
//    CityModelJob *city = _shengArray[0];
//    AreaModelJob *area = _shiArr[0];
//    ModelJob *model = _xianArr[0];
//    _addressLb.text = _addressStr.length > 0? _addressStr : [NSString stringWithFormat:@"%@%@%@",city.name,_shiArr.count > 0? area.name:0,_xianArr.count > 0? model.name:0];
}


- (void)initGesture {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
}

- (void)showInView:(UIView *)view {
    
    [UIView animateWithDuration:0.3 animations:^{
      
        self.frame = CGRectMake(0, -250, ScreenWidth, ScreenHeight + 300);
    } completion:^(BOOL finished) {
    }];
    
    [view addSubview:self];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.3 animations:^{

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
    NSInteger integer = 0;
    if (component==0) {
        integer = self.shengArray.count;
    }else if (component==1){
        ProvinceDataModel * model= self.shengArray[self.selectRowWithProvince];
        integer=model.city.count;
    }else if (component==2){
        ProvinceDataModel * model= self.shengArray[self.selectRowWithProvince];
        CityDataModel *cityModel=model.city[self.selectRowWithCity];
        integer=cityModel.District.count;
    }
    return integer;
}

// 返回第component列第row行的内容（标题）
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (component) {
            
        case 0:{
            ProvinceDataModel * model= self.shengArray[row];
            return  model.jobName;
        }
            
            break;
            
        case 1:
        {
            ProvinceDataModel * model= self.shengArray[self.selectRowWithProvince];
            CityDataModel *cityModel=model.city[row];
            
            return cityModel.jobName;
        }
            break;
            
        case 2:
        {
            ProvinceDataModel * model= self.shengArray[self.selectRowWithProvince];
            CityDataModel *cityModel=model.city[self.selectRowWithCity];
            DistrictDataModel *TeanModel=cityModel.District[row];
        
            return TeanModel.jobName;
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
    if (component==0)
    {
        self.selectRowWithProvince=row;
        self.selectRowWithCity=0;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        
    }
    else if (component==1)
    {
        self.selectRowWithCity=row;
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        
    }
    else
    {
        self.selectRowWithTown=row;
        
    }
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
    
    
//    CityModelJob *city = _shengArray[shengRow];
    ProvinceDataModel * model= self.shengArray[shengRow];
    CityDataModel *cityModel=model.city[shiRow];
    DistrictDataModel *TeanModel=cityModel.District[xianRow];
//    AreaModelJob *area = _shiArr[shiRow];
//    ModelJob *model = _xianArr[xianRow];
//    //    _addressLb.text = _addressStr.length > 0? _addressStr : [NSString stringWithFormat:@"%@%@%@",city.name,_shiArr.count > 0? area.name:0,_xianArr.count > 0? model.name:0];
//    _addressStr = [NSString stringWithFormat:@"%@%@%@",city.name,
//                   _shiArr.count > 0?  area.name:@"",
//                   _xianArr.count > 0? model.name:@""];
//    
    if (self.determineBtnBlock) {
        self.determineBtnBlock(TeanModel.jobName,TeanModel.jobCode);
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
