//
//  DemoListViewController.m
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/17.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "DemoListViewController.h"
#import "GeneralLogViewController.h"
#import "UniqueString.h"
#import "JSPatchDemoViewController.h"
#import "WLCollectionViewController.h"

@interface DemoListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *mainTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@property (nonatomic,strong)GeneralLogViewController *logVC;
@end

@implementation DemoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"☞ 欢迎来到lqc的Demo小屋 ☜";
    
    [self.view addSubview:self.mainTableView];
    [self.view bringSubviewToFront:self.mainTableView];
}


#pragma mark UITablViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UniqueString *unique = [[UniqueString alloc]initWithParam:nil];
            [self presentViewController:[self logViewCtrl:nil detailTitle:unique.result]  animated:YES completion:nil];
        }
        
    }else{
        if (indexPath.row == 0) {
            JSPatchDemoViewController *jspatchVC = [[JSPatchDemoViewController alloc]init];
            [self.navigationController pushViewController:jspatchVC animated:YES];
        }else if (indexPath.row == 1) {
            WLCollectionViewController *collectionVC = [[WLCollectionViewController alloc]init];
            [self.navigationController pushViewController:collectionVC animated:YES];
        }

        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"打印信息的section";
    }else if (section == 1){
        return @"需要push进导航栈的section";
    }else
        return @"creat by lqc";
}


#pragma mark UITableViewDatasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.separatorInset = UIEdgeInsetsMake(0, 40, 0, 40);
        
    }
    cell.textLabel.text = [self.dataSourceArray[indexPath.section] objectAtIndex:indexPath.row];
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSArray *arr = self.dataSourceArray[section];
//    return arr.count;
    
    return [[self.dataSourceArray objectAtIndex:section] count];
}



#pragma  mark getter
- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        [_mainTableView setBackgroundColor:[UIColor whiteColor]];
        _mainTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mainTableView.separatorColor = [UIColor orangeColor];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        
//        _mainTableView regi
    }
    return _mainTableView;
}


- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc]init];
        NSMutableArray *logSectionArr = [[NSMutableArray alloc]init];
        NSMutableArray *pushSectionArr = [[NSMutableArray alloc]init];
        
        [logSectionArr addObject:@"洗牌算法生成随机数"];
        
        [pushSectionArr addObject:@"JSPatch实战"];
        [pushSectionArr addObject:@"Collection实战--日历"];
        
        [_dataSourceArray addObject:logSectionArr];
        [_dataSourceArray addObject:pushSectionArr];
    }
    return _dataSourceArray;
}


- (GeneralLogViewController *)logViewCtrl:(NSString *)title detailTitle:(NSString *)detailTitle{
    if (!_logVC) {
        _logVC = [GeneralLogViewController initWithTitle:title detailTitle:detailTitle];
    }
    return _logVC;
}

@end
