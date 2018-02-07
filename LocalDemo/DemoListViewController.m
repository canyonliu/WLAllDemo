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
#import "WLFeatureValidateLog.h"

#import "PropertyRefreshViewController.h"
#import "AssetsViewController.h"
#import "WLRefreshViewController.h"
#import "WLSpotlight.h"
#import "WLIbeaconsViewController.h"

#import <CoreMotion/CoreMotion.h>

#define Push_VC_Count 9
#define Log_VC_Count 4


@interface DemoListViewController ()<UITableViewDelegate,UITableViewDataSource>



@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@property (nonatomic,strong)GeneralLogViewController *logVC;

@property (nonatomic,strong)KVOModel *kvoModel;

@property (nonatomic,strong)TestForApi *apiModel;

///测试重写setter方法会不会即时刷新
@property (nonatomic,strong)PropertyRefreshViewController *propVC;

@property (nonatomic,strong)WLFeatureValidateLog *featureLog;
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
//    [self post];
    
}

- (void)dealloc{
    [self.featureLog removeObserver:self forKeyPath:@"result"];
}

- (void)post{
    //对请求路径的说明
    //http://120.25.226.186:32812/login
    //协议头+主机地址+接口名称
    //协议头(http://)+主机地址(120.25.226.186:32812)+接口名称(login)
    //POST请求需要修改请求方法为POST，并把参数转换为二进制数据设置为请求体
    
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2.根据会话对象创建task
    NSURL *url = [NSURL URLWithString:@"http://cp01-yangchengzhi.epc.baidu.com:8230/aps?service=package&action=api&uid=70A169DB86F17A89178D41D709574AA0879363413OMPJIPQMSM&ua=640_1136_iphone_9.2.0.0_0&ut=iPhone6%2C2_9.3.3&from=1099a&osname=baiduboxapp&osbranch=i0&cfrom=1099a&network=1_0&sid=156_266-583_1193-497_1037-397_819-485_1006-446_922-374_777-489_1014-571_1173-572_1174-584_1194-1002265_6421-1001843_5188-1002514_7123-1002429_6890-1002669_7608-1002350_6660-1002368_6703-1002527_7159-1002393_6780-1002579_7309-1002326_6595-1002646_7518"];
    
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //4.修改请求方法为POST
    request.HTTPMethod = @"POST";
    
    //5.设置请求体
    request.HTTPBody = [@"username=520it&pwd=520it&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    
    //6.根据会话对象创建一个Task(发送请求）
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //8.解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dict);
        
    }];
    
    //7.执行任务
    [dataTask resume];
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
        }else if (indexPath.row == 4){
            [self addObserverForAvarnessApi];

            [self presentViewController:[self logViewCtrl:nil detailTitle:[self.featureLog makeResult]] animated:YES completion:nil];
//            [self getUserActivity];
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
        }else if (indexPath.row == 8){
            [self.navigationController pushViewController:[WLSpotlight new] animated:YES];
        }else if (indexPath.row == 9){
            [self.navigationController pushViewController:[WLIbeaconsViewController new] animated:YES];
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


- (void)addObserverForAvarnessApi{
    [self.featureLog addObserver:self forKeyPath:@"result" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"name"]) {
        id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        [self.logVC setMessage:newValue];
        
        NSLog(@"old == %@",oldValue);
        NSLog(@"new == %@",newValue);
        //当界面快要消失的时候，一定要记得移除KVO，这里用的地方不正确
        [self.kvoModel removeObserver:self forKeyPath:@"name"];
    }else if ([keyPath isEqualToString:@"result"]){
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        [self.logVC setMessage:newValue];
    }
    

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
                                         @"测试iOS框架中的一些环境特征能否获取",
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
                                          @"spotlight尝试",
                                          @"ibeacon实战",
                                          nil];
        

        [_dataSourceArray addObject:logSectionArr];
        [_dataSourceArray addObject:pushSectionArr];
        // 测试valueForUndefinedKey崩溃
        @try {
            NSMutableDictionary *originDict = [NSMutableDictionary dictionary];
            [originDict setObject:@"beauty" forKey:@"meili"];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[originDict valueForKeyPath:@"liu.qing"]];
            NSLog(@"first dict ----- %@",dict);
            [originDict setObject:@{@"liu":dict} forKey:@"tips"];
            NSLog(@"originDict == %@",originDict);
            dict = [[NSMutableDictionary alloc] initWithDictionary:[originDict valueForKeyPath:@"liu.qing"]];
            NSLog(@"last dict ----- %@",dict);
        } @catch (NSException *ex) {
            NSLog(@"mmm %@",ex.description);
        }
        
        NSDictionary *dict = nil;
        NSString *str = dict[@"key"];
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

- (WLFeatureValidateLog *)featureLog{
    if (!_featureLog) {
        _featureLog = [[WLFeatureValidateLog alloc]init];
    }
    return _featureLog;
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"当前的offset:%.f",self.mainTableView.contentOffset.y);
}


@end
