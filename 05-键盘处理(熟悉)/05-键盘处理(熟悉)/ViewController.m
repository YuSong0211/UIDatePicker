

#import "ViewController.h"
#import "Province.h"
#import "yusongtextField.h"

@interface ViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet yusongtextField *birthdayField;
@property (weak, nonatomic) IBOutlet yusongtextField *cityField;

@property (nonatomic, weak) UIDatePicker *picker;
// 记录当前选中的省会的角标
@property (nonatomic, assign) int selProIndex;

@property (nonatomic, strong) NSMutableArray *provinces;

@end

@implementation ViewController

- (NSMutableArray *)provinces
{
    if (_provinces == nil) {
        _provinces = [NSMutableArray array];
        
        // 加载plist数组
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"provinces.plist" ofType:nil];
        NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
        for (NSDictionary *dict in dictArr) {
            Province *p = [Province provinceWithDict:dict];
            [_provinces addObject:p];
        }
    }
    
    return _provinces;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _birthdayField.delegate = self;
    _cityField.delegate = self;
    
    // 自定义生日键盘
    [self setUpbirthdayField];
    
    // 自定义城市键盘
    [self setUpCityField];
}
#pragma mark - 自定义城市键盘
- (void)setUpCityField
{
    // UIPickerView
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    _cityField.inputView = pickerView;
}

#pragma mark -UIPickerView代理和数据源
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// 返回第component列有多少
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) { // 设置省会
        return self.provinces.count;
    }else{ // 设置城市
        // 获取选中的省
        NSInteger proIndex = [pickerView selectedRowInComponent:0];
        Province *p = self.provinces[proIndex];
        return p.cities.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) { // 设置省会
        // 获取第0列第row的省
        Province *p = self.provinces[row];
        return p.name;
    }else{ // 设置城市
        // 福建 - 10
        // 获取选中的省
//        NSInteger proIndex = [pickerView selectedRowInComponent:0];
        Province *p = self.provinces[_selProIndex];
        NSLog(@"%@--%d",p.name,p.cities.count);
#warning BUG
        return p.cities[row];
    }
}

// 监听pickerView选中
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) { // 滚动的省会
        _selProIndex = row;
        [pickerView reloadComponent:1];
    }
    
    // 给城市的label赋值
    // 取出第0列选中省
    //NSInteger proIndex = [pickerView selectedRowInComponent:0];
    // 取出省会模型
    Province *p = self.provinces[_selProIndex];
    
    // 取出第1列选中的城市
    NSInteger cityIndex = [pickerView selectedRowInComponent:1];
    NSString *cityName = p.cities[cityIndex];
    _cityField.text = [NSString stringWithFormat:@"%@ %@",p.name,cityName];
}

#pragma mark - 自定义生日键盘
- (void)setUpbirthdayField
{
    // 创建UIDatePicker
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    // 设置UIDatePicker的模式UIDatePickerModeDate(年月日)
    picker.datePickerMode = UIDatePickerModeDate;
    // 设置UIDatePicker地区 zh:中国
    picker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    _picker = picker;
    // 监听UIDatePicker,继承UIControl,只要继承UIControl就能使用addTarget
    [picker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    // 自定义文本框键盘用inputView
    _birthdayField.inputView = picker;
    
}
// 只要UIDatePicker的值改变就会调用
- (void)dateChange:(UIDatePicker *)datePicker
{
    // 创建日期格式字符串
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    _birthdayField.text = [fmt stringFromDate:datePicker.date];
}


#pragma mark -UITextField代理
// 什么调用:在用户输入文本框的内容的时候调用,目的判断是否允许输入
// 作用:是否允许用户输入文本框在内容
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
}
// textField开始编辑的时候调用,textField弹出键盘的时候调用
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _birthdayField) { // 设置日期
        [self dateChange:_picker];
    }

}



@end
