//
//  JSPatchDemoViewController.m
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/17.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "JSPatchDemoViewController.h"



/**
 在官网上上传了一个main.js的脚本，用于下发数据
 */
@interface JSPatchDemoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)UITableView*table;

//创建可变数组来更新数据

@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation JSPatchDemoViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor grayColor];
    [self setUpVCWithContent];
    
}

#pragma mark -设置控制器的内容

-(void)setUpVCWithContent

{
    
    //自定义导航栏的标题控件
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,0,100,44)];
    
    label.text=@"JSpatchVC";
    
    label.textColor= [UIColor greenColor];
    
    label.font= [UIFont boldSystemFontOfSize:30];
    self.navigationItem.titleView= label;
    
    //自定义导航栏右边的item
    
    UIButton*button =[UIButton buttonWithType:UIButtonTypeContactAdd];
    
    [button addTarget:self action:@selector(addData) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem= rightButton;
    
    UITableView*table = [[UITableView alloc]initWithFrame:self.view.bounds];
    
    self.table= table;
    
    table.dataSource = self;
    table.delegate = self;
    
    [self.view addSubview:table];
    
}


#pragma mark UITableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


#pragma mark UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"JSPatchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.textColor = [UIColor redColor];
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        cell.textLabel.font= [UIFont systemFontOfSize:20];
        if(indexPath.row>4)
        {
            cell.textLabel.textColor= [UIColor blueColor];
            
            cell.textLabel.textAlignment = NSTextAlignmentRight;
            
            cell.textLabel.font= [UIFont boldSystemFontOfSize:25];
            
        }
        
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}





#pragma mark Event  main.js中重写了
//- (void)addData{
////    NSString *datas = @"";
//////
////    [self.dataArray addObject:datas];
//////
////    [self.table reloadData];
//}






#pragma mark getter
- (NSMutableArray*)dataArray{
    if(_dataArray==nil)
        
    {
        _dataArray= [NSMutableArray array];
        
        [_dataArray addObjectsFromArray:@[@"WayneLiu--1",@"WayneLiu--2",@"WayneLiu--3",@"WayneLiu--4",@"WayneLiu--5"]];
        
    }
    return _dataArray;
    
}

@end
