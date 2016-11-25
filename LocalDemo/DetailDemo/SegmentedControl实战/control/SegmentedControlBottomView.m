//
//  SegmentedControlBottomView.m
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/22.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "SegmentedControlBottomView.h"

@implementation SegmentedControlBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.childViewController =
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES; // 开启分页
        self.bounces = NO; //没有弹簧效果
        
        
    }
    return self;
}

+ (instancetype)segmentedControlBottomViewWithFrame:(CGRect)frame{
    return [[self alloc]initWithFrame:frame];
}

/**
 *  给外界提供的方法（必须实现）
 *  @param index    外界控制器子控制器View的下表
 *  @param VC    外界控制器（主控制器、self的父控制器）
 */

- (void)showChildVCViewWithIndex:(NSInteger)index outsideVC:(UIViewController *)VC{
    CGFloat offsetX = index * self.frame.size.width;
    UIViewController *vc = VC.childViewControllers[index];
    if (vc.isViewLoaded) {// 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
        return;
    }
    [self addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, self.frame.size.width, self.frame.size.height);
}


#pragma mark setter

/**
 setter 方法里面不能使用self.childViewController,因为会死循环，反复调用setter方法，只能使用_childViewController
 */
- (void)setChildViewController:(NSArray *)childViewController{
    
    _childViewController = childViewController;
    self.contentSize = CGSizeMake(childViewController.count * self.frame.size.width,0);
    
    
}


@end
