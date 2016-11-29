//
//  PropertyRefreshViewController.m
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/25.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "PropertyRefreshViewController.h"

@interface PropertyRefreshViewController ()

//@property (nonatomic,strong) NSString *changedString;

@property (nonatomic,strong) UILabel *propertyLabel;

@end

@implementation PropertyRefreshViewController
@synthesize changedString = _changedString;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //     self.changedString这个的赋值一定要在 [super viewDidLoad]之后
    // 原因在于： 如果在push之前就进行赋值的话，会造成在访问changedString的setter方法的时候访问到UILabel *propertyLabel,这个时候super view还没有被加载进来，就会去访问[super viewDidLoad]方法，然后再执行[self viewDidLoad]方法，这样就会造成在访问到子类的一些属性后，其父类有些实例变量并没有初始化完成，内存上可能就会出问题：事实证明：_propertyLabel在访问[super viewDidLoad]之前和之后的内存地址是不一样的，而加载到本view的是前面的那个内存地址，此后更改的是后面的内存地址，这个内存地址并没有被附着在self.view上。所以这就是2s后为什么赋值changeString不能更改label.text的原因
    
//    self.changedString = @"改变前";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.propertyLabel];
}



- (UILabel *)propertyLabel{
    if (!_propertyLabel) {
        _propertyLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 100, self.view.bounds.size.width - 100, 30)];
//    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.f repeats:YES block:^(NSTimer * _Nonnull timer) {
        _propertyLabel.text = !self.changedString? @"nil":self.changedString;
//    }];
//        [timer fire];
//        [runloop addTimer:timer forMode:NSRunLoopCommonModes];
    }
    
    return _propertyLabel;
}

- (void)setChangedString:(NSString *)changedString{
    _changedString = changedString;
    [self.propertyLabel setText:_changedString];
//    [self.view layoutSubviews];
//    [self.propertyLabel setNeedsLayout];
}
- (NSString *)changedString{
    return _changedString;
}

@end
