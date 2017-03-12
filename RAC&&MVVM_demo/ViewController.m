//
//  ViewController.m
//  RAC&&MVVM_demo
//
//  Created by m on 2017/3/7.
//  Copyright © 2017年 XLJ. All rights reserved.
//

#import "ViewController.h"
#import "PersonListViewModel.h"

#import "PersonMVVM.h"
#import <ReactiveObjC/ReactiveObjC.h>

NSString *const MXPersonCellIdentifier = @"MXPersonCellIdentifier";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    PersonListViewModel *_personsViewModel;
    UITableView *_tableView;
//    UIButton *_buttonTest;
    
    PersonMVVM *_personMVVM;
}
@property (nonatomic) UIButton *buttonTest;

@end

@implementation ViewController

/**
 * RAC 在使用的时候，因为系统提供的信号始终存在的
 * 因此，所有的block中，如果出现`self.`, `/` `成员变量`,几乎百分百的循环引用
 * 解决的方法:
 1. weak
 2. @weakify(self) 在block外部使用这个
    @strongify(self)在block内部使用这个
    self.buttonTest.enabled = [x boolValue];

 */

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //1.RAC定义
//    [self testOne];
    
    //2.RAC常用代码
//    [self testTwo];
    
    //3.组合文本框
//    [self combineFieldTest1];
    //4. MVVM双向绑定
    [self bindDemo];
}

#pragma mark -- MVVM双向绑定
- (void)bindDemo{
    
    //1.准备数据
    _personMVVM = [[PersonMVVM alloc] init];
    _personMVVM.name = @"marlonxlj";
    _personMVVM.age = 20;
    
    
    UITextField *nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 40+80, 300, 50)];
    
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    [self.view addSubview:nameTextField];
    
    UITextField *ageTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 120+80, 300, 50)];
    ageTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:ageTextField];

    //双向绑定
    //1.模型(KVO数据)绑定->UI(text 属性)
    //如果使用基本数据类型绑定UI的内容，需要使用map函数，通过block对value的数值进行转换后才能绑定
    RAC(nameTextField, text) = RACObserve(_personMVVM, name);
    RAC(ageTextField, text) = [RACObserve(_personMVVM, age) map:^id _Nullable(id  _Nullable value) {
        return [value description];
    }];
    
    //2.UI->模型的绑定
    [[RACSignal combineLatest:@[nameTextField.rac_textSignal, ageTextField.rac_textSignal]] subscribeNext:^(id  _Nullable x) {
        
        _personMVVM.name = [x first];
        _personMVVM.age = [x[1] integerValue];
    }];
    
    //3.添加按钮，输出结果
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.center = self.view.center;
    [self.view addSubview:btn];
    
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
      
        NSLog(@"%@ %zd", _personMVVM.name, _personMVVM.age);
    }];
    
}

#pragma mark -- 组合文本框

- (void)combineFieldTest1{
    UITextField *nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 40, 300, 50)];
    
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    [self.view addSubview:nameTextField];
    
    UITextField *pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 120, 300, 50)];
    pwdTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:pwdTextField];
    
    [self buttonTestFunc];
    //组合信号--Tuple元组
    //reduce 返回值,合并两个信号的数据，进行汇总计算时使用
    //只有用户名和密码同时存在，才允许登录
    
//    __weak typeof(self) weakSelf = self;
    
    //RAC
    @weakify(self)
    [[RACSignal combineLatest:@[nameTextField.rac_textSignal, pwdTextField.rac_textSignal] reduce:^id _Nullable(NSString *name, NSString *pwd){
        NSLog(@"%@,%@", name, pwd);
        return @(name.length > 0 && pwd.length > 0);
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
//        weakSelf.buttonTest.enabled = [x boolValue];
        
        @strongify(self)
        self.buttonTest.enabled = [x boolValue];
    }];
}


- (void)combineFieldTest{
    UITextField *nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 40, 300, 50)];
    
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    [self.view addSubview:nameTextField];
    
    UITextField *pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 120, 300, 50)];
    pwdTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:pwdTextField];
    
    //组合信号--Tuple元组
    [[RACSignal combineLatest:@[nameTextField.rac_textSignal, pwdTextField.rac_textSignal]] subscribeNext:^(id  _Nullable x) {
        
        NSString *name = x[0];
        NSString *pwd = x[1];
        
        
        NSLog(@"---%@--- %@ ---",name, pwd);
    }];
    
//    [[nameTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"---%@---%@",x, [x class]);
//    }];
//    
//    [[pwdTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"---%@---%@",x, [x class]);
//    }];

}

#pragma mark -- 常用代码
- (void)testTwo{
    
//    [self buttonTest];
    
    [self textFiledTest];
}

- (void)textFiledTest
{
    UITextField *nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, 300, 50)];
    
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    [self.view addSubview:nameTextField];
    
    [[nameTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"---%@---%@",x, [x class]);
    }];
}
- (void)buttonTestFunc{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
    btn.center = self.view.center;
    [self.view addSubview:btn];
    
    //监听按钮事件
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"%@",x);
    }];

    _buttonTest = btn;
}
- (void)testOne{
    //1.加载数据
    [self loadData];
    //2.加载表格
    [self prepareTableView];

}

- (void)prepareTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MXPersonCellIdentifier];
}

- (void)loadData
{
    //1.实例化视图模型
    _personsViewModel = [[PersonListViewModel alloc] init];
    
    /**
     * next 是接收到数据 
     * error 接收到错误，错误处理
     * complected 信号完成
     */
    //订阅
    [[_personsViewModel loadPersons] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
        
        //刷新表格
        [_tableView reloadData];
    } error:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
    } completed:^{
        NSLog(@"完成");
    }];
    
}

#pragma mark -- Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _personsViewModel.personList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MXPersonCellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = _personsViewModel.personList[indexPath.row].name;
    
    return cell;
    
}

@end
