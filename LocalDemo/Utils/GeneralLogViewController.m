//
//  GeneralLogViewController.m
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/17.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "GeneralLogViewController.h"

@interface GeneralLogViewController ()
//@property (nonatomic,strong)NSString *commontitle;
//
//@property (nonatomic,strong)NSString *detailTitle;
//

//@property (nonatomic,assign)UIAlertControllerStyle style;

@end

@implementation GeneralLogViewController

- (instancetype)initWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle{
    if (self = [super init]) {        
        self.title = (title == nil)?@"执行结果或log信息":title;
        self.message = (detailTitle == nil)?@"无结果产出喔，你可能需要查看你的代码！":detailTitle;
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [self addAction:ok];
    }
    
    return self;

}


+ (instancetype)initWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle{
    return [[self alloc]initWithTitle:title detailTitle:detailTitle];
}


@end
