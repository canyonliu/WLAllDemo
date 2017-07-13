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
#import "WLUnlockView.h"
#import "MethodSwizzleViewController.h"
#import "SegmentedViewController.h"
#import "UIWindow+Extension.h"
#import "KVOModel.h"
#import "TestForApi.h"

#import "PropertyRefreshViewController.h"
#import "AssetsViewController.h"
#import "WLRefreshViewController.h"



@interface DemoListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *mainTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@property (nonatomic,strong)GeneralLogViewController *logVC;

@property (nonatomic,strong)KVOModel *kvoModel;

@property (nonatomic,strong)TestForApi *apiModel;

///测试重写setter方法会不会即时刷新
@property (nonatomic,strong)PropertyRefreshViewController *propVC;
@end

@implementation DemoListViewController
{
//    @private
    NSString *kvoShowItem;
}


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
        }else if (indexPath.row == 1){
           NSDictionary* dict =  (NSDictionary *)[[UIApplication sharedApplication].keyWindow currentTopViewController];
            [self presentViewController:
                                    [self logViewCtrl:nil detailTitle:
                                    dict.description]
                                    animated:YES completion:nil];
        }else if (indexPath.row == 2){
            //观察KVO
            [self addObserverForMyself];
            //设置block
            [self observerBlock];

            [self presentViewController:[self logViewCtrl:self.dataSourceArray[indexPath.section][indexPath.row] detailTitle:self.kvoModel.name]  animated:YES completion:nil];
            
        }else if (indexPath.row == 3){
            self.apiModel = [[TestForApi alloc]init];
            [self presentViewController:[self logViewCtrl:nil detailTitle:self.apiModel.makeResult] animated:YES completion:nil];
        }
        
    }else{
        if (indexPath.row == 0) {
            JSPatchDemoViewController *jspatchVC = [[JSPatchDemoViewController alloc]init];
            [self.navigationController pushViewController:jspatchVC animated:YES];
        }else if (indexPath.row == 1) {
            WLCollectionViewController *collectionVC = [[WLCollectionViewController alloc]init];
            [self.navigationController pushViewController:collectionVC animated:YES];
        }else if (indexPath.row == 2){
            WLUnlockView *unlock = [[WLUnlockView alloc]initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, self.view.bounds.size.height - 100)];
            UIViewController *containerVC = [[UIViewController alloc]init];
            UIImageView *bgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
            [bgView setImage:[UIImage imageNamed:@"Home_refresh_bg"]];
            [containerVC.view addSubview: bgView];
            [containerVC.view addSubview: unlock];
            [self.navigationController pushViewController:containerVC animated:YES];
        }else if (indexPath.row == 3){
            MethodSwizzleViewController *swizzleVC = [[MethodSwizzleViewController alloc]init];
            [self.navigationController pushViewController:swizzleVC animated:YES];
        }else if (indexPath.row == 4){
            SegmentedViewController *segmentVC = [[SegmentedViewController alloc]init];
            [self.navigationController pushViewController:segmentVC animated:YES];
        }else if (indexPath.row == 5){
            self.propVC.changedString = @"改变前";
            [self.navigationController pushViewController:self.propVC animated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.propVC setChangedString:  @"changed后"];
               
            });
            
        }else if(indexPath.row == 6){
            [self.navigationController pushViewController:[AssetsViewController new] animated:YES];
        }else if (indexPath.row == 7){
            [self.navigationController pushViewController:[WLRefreshViewController new] animated:YES];
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


#pragma mark 观察KVO
- (void)addObserverForMyself{
    self.kvoModel = [[KVOModel alloc]initWithParam:nil];
    [self.kvoModel addObserver:self
           forKeyPath:@"name"
              options:NSKeyValueObservingOptionNew
              context:nil];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    id newValue = [change objectForKey:NSKeyValueChangeNewKey];
    [self.logVC setMessage:newValue];

    NSLog(@"old == %@",oldValue);
    NSLog(@"new == %@",newValue);
    //当界面快要消失的时候，一定要记得移除KVO，这里用的地方不正确
    [self.kvoModel removeObserver:self forKeyPath:@"name"];

}

#pragma mark 设置block
- (void)observerBlock{
    __weak typeof(self) wself = self;
    self.kvoModel.kvoBlcok = ^ NSString * (NSString *name){
        //                __strong typeof(wself) sself = wself;
        //下列方法说明了合理使用setter方法是可以不刷新的情况下改变界面上的元素的
        [wself.logVC setMessage:name];
        return @"block返回去";
        
    };
    
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
        NSMutableArray *logSectionArr = [[NSMutableArray alloc]initWithObjects:
                                         @"洗牌算法生成随机数",
                                         @"UIWindow的category",
                                         @"KVO实战",
                                         @"api测试类",
                                         nil];
        
        NSMutableArray *pushSectionArr = [[NSMutableArray alloc]initWithObjects:
                                          @"JSPatch实战",
                                          @"Collection实战--日历",
                                          @"Unlock手势解锁实战",
                                          @"MethodSwizzing黑魔法实战",
                                          @"SegmentedControl实战",
                                          @"尝试改变VC的自建属性，界面会不会即时改变",
                                          @"新建assetsViewController",
                                          @"自定义refresh控件",
                                          nil];
        

        [_dataSourceArray addObject:logSectionArr];
        [_dataSourceArray addObject:pushSectionArr];
    }
    return _dataSourceArray;
}


- (GeneralLogViewController *)logViewCtrl:(NSString *)title detailTitle:(NSString *)detailTitle{
//    if (!_logVC) {
        _logVC = [GeneralLogViewController initWithTitle:title detailTitle:detailTitle];
        
//    }
    return _logVC;
}

- (PropertyRefreshViewController *)propVC{
    if (!_propVC) {
        _propVC = [[PropertyRefreshViewController alloc]init];
        
    }
    return _propVC;
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"当前的offset:%.f",self.mainTableView.contentOffset.y);
}



@end
