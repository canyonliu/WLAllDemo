//
//  WLRefreshViewController.m
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/12/1.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "WLRefreshViewController.h"
#import "UIView+WLExtension.h"

#define NaviBarHeight 64
#define RefreshViewHeight 60

@interface WLRefreshViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *mainTableView;

//refresh相关
@property (nonatomic,strong)UIView *refreshView;
@property (nonatomic,strong)UILabel *refreshTitle;
@property (nonatomic,strong)UIImageView *refreshImage;
@property (nonatomic,strong)UIImageView *refreshBackImage;
@property (nonatomic,strong)CABasicAnimation *rotationAnimation;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)BOOL isAnimation;


@property (nonatomic,strong)NSMutableArray *dataSourceArray;
// 刷新的状态
@property (nonatomic,assign) WLRefreshState refreshState;
@property (nonatomic,assign)CGFloat currentOffY;

@end

@implementation WLRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDefault];
    
    [self.view addSubview:self.mainTableView];
//    [self.view addSubview:self.refreshView];
    
}

- (void)setupDefault{
    self.refreshState = WLRefreshState_Waiting;
    
    //    [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed:@"blue"] forBarMetrics:UIBarMetricsDefault];
    
    [self setTitle:[[self class] description]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    

}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* const identifier = @"refreshCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.text = self.dataSourceArray[indexPath.row];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark UIScrollviewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (self.refreshState == WLRefreshState_Refreshing) {
//        return;
//    }
    
    CGFloat offsetY = self.mainTableView.contentOffset.y;
    NSLog(@"offfSety== %f",offsetY);
    
    //    原点相对于当前的位置
//    if (offsetY < self.currentOffY && offsetY <= -64 - 40 && self.refreshState != WLRefreshState_Refreshing) {
        //        _refreshView.alpha = (-64 - offsetY)/40;
    CGFloat alpha = -(offsetY + NaviBarHeight)/RefreshViewHeight;
    if (alpha >= 1) {
        alpha = 1;
    }
    _refreshView.alpha = alpha;
//    @『『』』
    
    
    
    CGFloat originOffSet = -(offsetY + NaviBarHeight);
    CGFloat scale = originOffSet /(_refreshImage.WL_width + RefreshViewHeight/1.5f);
    NSLog(@"ddddd == %f",originOffSet);
    
    //控制背景图片的放大
    CGFloat backOffSet = -(offsetY + _refreshBackImage.image.size.height*0.5 + RefreshViewHeight + NaviBarHeight);
    NSLog(@"bbbbb--- %f",backOffSet);
    if (backOffSet >=0) {
        _refreshBackImage.WL_height = _refreshBackImage.image.size.height +   backOffSet;
    }
    
    
    
    //控制中间image的行为
    if (scale >= 1.23f) {
        //旋转
        if (!_isAnimation) {
            [self startAnimation];
        }

    }else{
        //放大
        self.refreshImage.WL_width = 20 * scale+0.1;
        self.refreshImage.WL_height = 20 * scale+0.1;
        // 平移
        CGFloat scaleX = originOffSet*3/(_refreshView.WL_centerX - 10);
        scaleX = scaleX > 1.f ? 1.f:scaleX;
        _refreshImage.WL_x = (_refreshView.WL_centerX - 10) * scaleX;
        
        if (_isAnimation && self.refreshState == WLRefreshState_Waiting) {
            [self stopAnimation];
        }

    }

    //控制title的改变
    if (offsetY <=   -(RefreshViewHeight + NaviBarHeight)) {

        self.refreshTitle.text = @"松开立即刷新";
        //            self.refreshView.WL_y =  self.currentOffY;
        //            self.refreshView.WL_height = -(offsetY + NaviBarHeight);
        self.refreshState = WLRefreshState_Refreshing;
        
    }else{
        self.refreshTitle.text = @"下拉即可刷新";
        //            self.refreshView.WL_y =  originOffSet + NaviBarHeight;
        //            self.currentOffY = self.refreshView.WL_y;
        //            self.refreshView.WL_height = RefreshViewHeight;
        self.refreshState = WLRefreshState_Waiting;
    }

    
    
    
 
//    }
//    self.currentOffY = offsetY;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.refreshState == WLRefreshState_Refreshing) {
        //do networking task
    
        // 增加顶部的内边距
        self.refreshTitle.text = @"正在加载";
        [UIView animateWithDuration:0.8 animations:^{
            UIEdgeInsets inset = self.mainTableView.contentInset;
            inset.top += self.refreshView.WL_height;
            self.mainTableView.contentInset = inset;
            
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.7f delay:1.6f options:(UIViewAnimationOptionCurveEaseOut) animations:^{
                self.refreshTitle.text = @"加载完成";
                
                UIEdgeInsets inset = self.mainTableView.contentInset;
                inset.top -= self.refreshView.WL_height;
                self.mainTableView.contentInset  = inset;

            } completion:^(BOOL finished) {
                // 修改文字
                self.refreshTitle.text = @"下拉可以加载数据...";
                self.refreshState = WLRefreshState_Waiting;
                
                self.refreshView.alpha = 0.0;
            }];
        }];
    }
}


#pragma mark 旋转
- (void)startAnimation{
    //方法一：(CAAnimation都是后台执行的，不会阻塞主线程)(但是不知道为什么这里还是会刷新不流畅，有可能是scrollView滚动是，要刷新整个界面？)
    
    _rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    _rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    _rotationAnimation.duration = 0.6;
    _rotationAnimation.cumulative = YES;
    _rotationAnimation.repeatCount = ULLONG_MAX;
    [_refreshImage.layer addAnimation:_rotationAnimation forKey:@"rotationAnimation"];
    self.isAnimation = YES;

    
    //方法二：
//    dispatch_queue_t queue = dispatch_queue_create("com.baidu.lqc.refreshQueue", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        _timer = [NSTimer scheduledTimerWithTimeInterval:0.8 repeats:NO block:^(NSTimer * _Nonnull timer) {
//            _rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//            _rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
//            _rotationAnimation.duration = 0.8;
//            _rotationAnimation.cumulative = YES;
//            _rotationAnimation.repeatCount = ULLONG_MAX;
//            [_refreshImage.layer addAnimation:_rotationAnimation forKey:@"rotationAnimation"];
//            self.isAnimation = YES;
//        }];
//        [_timer fire];
//        NSRunLoop *runloop = [NSRunLoop mainRunLoop];
//        [runloop addTimer:_timer forMode:NSRunLoopCommonModes];
//        
//
//    });
    
}

- (void)stopAnimation{
    if (_rotationAnimation) {
        [_refreshImage.layer removeAnimationForKey:@"rotationAnimation"];
//        _rotationAnimation = nil;
        self.isAnimation = NO;
    }
    if (_timer) {
        [_timer invalidate];
    }
}


#pragma mark getter
- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _mainTableView.backgroundColor = [UIColor colorWithRed:230.f green:160.f blue:160.f alpha:0.7];//后面的RGB无法使用
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorColor = [UIColor purpleColor];
        _mainTableView.separatorInset = UIEdgeInsetsMake(10, 50, 10, 10);
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.showsVerticalScrollIndicator = YES;
//        _mainTableView.contentInset = UIEdgeInsetsMake(self.refreshBackImage.image.size.height*0.5, 0, 0, 0);
//        [_mainTableView insertSubview:self.refreshBackImage atIndex:0];
        [_mainTableView addSubview:self.refreshView];
//        KVO太容易出事了
//        [_mainTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionPrior context:nil];
    }
    return _mainTableView;
}

- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc]initWithArray:@[@"njcois",@"ejwiho",@"dvihovodhsv",@"vefbfcdve"]];
    }
    return _dataSourceArray;
}


- (UIView *)refreshView{
    if (!_refreshView) {
        _refreshView = [[UIView alloc]initWithFrame:CGRectMake(0, -RefreshViewHeight, self.view.bounds.size.width, RefreshViewHeight)];
        _refreshView.backgroundColor = [UIColor lightGrayColor];
        [_refreshView addSubview:self.refreshTitle];
//        [_refreshView addSubview:self.refreshBackImage];
        [_refreshView addSubview:self.refreshImage];
    }
    return _refreshView;
}

- (UIImageView *)refreshBackImage{
    if (!_refreshBackImage) {
        _refreshBackImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scaleImage"]];
        _refreshBackImage.frame = CGRectMake(0, -2*RefreshViewHeight, self.view.WL_width, RefreshViewHeight);
        _refreshBackImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _refreshBackImage;
}

- (UIImageView *)refreshImage{
    if (!_refreshImage) {
        _refreshImage =[[UIImageView alloc]initWithImage: [UIImage imageNamed:@"refresh"]];
        _refreshImage.frame = CGRectMake(_refreshView.WL_centerX - 10 , 5, 20, 20);
    }
    return  _refreshImage;
}

- (UILabel *)refreshTitle{
    if (!_refreshTitle) {
        CGFloat refImageY = _refreshImage.WL_y + _refreshImage.WL_height + 15;
        _refreshTitle = [[UILabel alloc]initWithFrame:CGRectMake(50,refImageY , _refreshView.WL_width - 100, _refreshView.WL_height - refImageY)];
        _refreshTitle.textAlignment = NSTextAlignmentCenter;
        _refreshTitle.font = [UIFont systemFontOfSize:13];
        _refreshTitle.textColor = [UIColor darkGrayColor];
        _refreshTitle.text = @"下拉即可刷新";
    }
    return _refreshTitle;
}







//#pragma mark KVO
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
////    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
////    id newValue = [change objectForKey:NSKeyValueChangeNewKey];
//    if (self.refreshState == WLRefreshState_Refreshing) {
//        return;
//    }
//
//    CGFloat offsetY = self.mainTableView.contentOffset.y;
//    NSLog(@"offfSety== %f",offsetY);
//
//    //    原点相对于当前的位置
//    if (offsetY < self.currentOffY && offsetY <= -64 && self.refreshState == WLRefreshState_Waiting) {
////        _refreshView.alpha = (-64 - offsetY)/40;
//        CGFloat alpha =  (offsetY / 64.f + 1.f ) > 1 ?1.f :(offsetY / 64.f + 1.f );
//        _refreshView.alpha = alpha;
////        CGFloat bufferFloat = 30;
//        if (offsetY <= -40 - 64 ) {
//            self.refreshTitle.text = @"松开立即刷新";
////            self.refreshView.WL_y = 64;
////            self.refreshView.WL_height = -offsetY - 40 - 64;
//            self.refreshState = WLRefreshState_Refreshing;
//        }else{
//            self.refreshTitle.text = @"下拉即可刷新";
//            self.refreshState = WLRefreshState_Waiting;
//        }
//    }
//    self.currentOffY = offsetY;
//}



@end
