//
//  WLAddIbeaconViewController.m
//  LocalDemo
//
//  Created by QingCan on 2017/12/16.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "WLAddIbeaconViewController.h"
@interface WLAddIbeaconViewController ()<UITextFieldDelegate>
@property (nonatomic,strong,readwrite)NSString *name;
@property (nonatomic,strong,readwrite)NSUUID *uuid;
@property (nonatomic,assign,readwrite)uint16_t majorValue;
@property (nonatomic,assign,readwrite)uint16_t minorValue;

@end

@implementation WLAddIbeaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView{
    [super loadView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UITextField *nameField = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, 300, 40)];
    nameField.delegate = self;
    nameField.placeholder = @"name";
    nameField.borderStyle = UITextBorderStyleRoundedRect;
    nameField.tag = 100;
    [self.view addSubview:nameField];
    
    UITextField *uuidField = [[UITextField alloc]initWithFrame:CGRectMake(10, 160, 300, 40)];
    uuidField.delegate = self;
    uuidField.placeholder = @"uuid";
    uuidField.borderStyle = UITextBorderStyleRoundedRect;
//    NSString *uuid = [[NSUUID UUID] UUIDString];
    self.uuid = [[NSUUID alloc]initWithUUIDString:@"23A01AF0-232A-4518-9C0E-323FB773F5EF"];
    uuidField.text = @"23A01AF0-232A-4518-9C0E-323FB773F5EF";
    uuidField.tag = 101;
    [self.view addSubview:uuidField];
    
    UITextField *majorField = [[UITextField alloc]initWithFrame:CGRectMake(10, 220, 300, 40)];
    majorField.delegate = self;
    majorField.placeholder = @"major";
    majorField.borderStyle = UITextBorderStyleRoundedRect;
    majorField.tag = 102;
    [self.view addSubview:majorField];
    
    UITextField *minorField = [[UITextField alloc]initWithFrame:CGRectMake(10, 280, 300, 40)];
    minorField.delegate = self;
    minorField.placeholder = @"minor";
    minorField.borderStyle = UITextBorderStyleRoundedRect;
    minorField.tag = 103;
    [self.view addSubview:minorField];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(50, 340, 220, 40);
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(commitInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:submitButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 100) {
        self.name = textField.text;
    }else if (textField.tag == 101){
        self.uuid = [[NSUUID alloc]initWithUUIDString:textField.text];
    }else if (textField.tag == 102){
        self.majorValue = 1;
    }else if (textField.tag == 103){
        self.minorValue = 1;//[textField.text intValue];
    }
    [self.view becomeFirstResponder];
}



- (void)commitInfo:(id)sender{
    if (self.addItemCompletionBlock) {
        WLIbeaconItem *item = [WLIbeaconItem ibeconItemWithName:self.name uuid:self.uuid major:self.majorValue minor:self.minorValue];
        self.addItemCompletionBlock(item);
    }
}

@end
