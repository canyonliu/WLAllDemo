//
//  MethodSwizzleViewController.m
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/21.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "MethodSwizzleViewController.h"


@interface MethodSwizzleViewController ()

@end

@implementation MethodSwizzleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@",[self class]];
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *arr = @[@1,@2,@3,@4];
    [arr objectAtIndex:3];
    //正常来说是会崩溃的，但是使用了methodSwizzle为其增加了一层try catch,就可以捕获异常
    [arr objectAtIndex:4];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSLog(@"method had exchange!");
}

//
//- (void)viewWillDisappear:(BOOL)animated{
//    NSLog(@"method had exchange!");
//
//}
@end
