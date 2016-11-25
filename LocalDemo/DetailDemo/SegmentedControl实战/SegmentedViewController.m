//
//  SegmentedViewController.m
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/22.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "SegmentedViewController.h"
#import "StyleFiveVC.h"
#import "StyleNineVC.h"



@interface SegmentedViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSMutableArray *titleArray;
@property (nonatomic, strong)NSMutableArray *vcArray;



@end

@implementation SegmentedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@",[self class]];
    
    [self.view addSubview:self.myTableView];
}




#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.separatorInset = UIEdgeInsetsMake(10, 20, 10, 20);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor purpleColor];
        cell.textLabel.text = self.titleArray[indexPath.row];
    }
    return cell;
    
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:self.vcArray[indexPath.row] animated:YES];

}




- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc]initWithObjects:
                       @"指示器圆角背景",
                       @"标题按钮文字缩放效果",
                       nil];
    }
    return _titleArray;
}

- (NSMutableArray *)vcArray{
    if (!_vcArray) {
        _vcArray = [[NSMutableArray alloc]initWithCapacity:0];
        StyleFiveVC *fiveVC = [[StyleFiveVC alloc] init];
        StyleNineVC *nineVC = [[StyleNineVC alloc] init];
        
        [_vcArray addObject:fiveVC];
        [_vcArray addObject:nineVC];

    }
    return _vcArray;
}

- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _myTableView.backgroundColor = [UIColor whiteColor];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        
//        _myTableView register
    }
    return _myTableView;
}

@end
