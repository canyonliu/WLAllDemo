//
//  SegmentedControlBottomView.h
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/22.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentedControlBottomView : UIScrollView
@property (nonatomic,strong) NSArray *childViewController;

+ (instancetype)segmentedControlBottomViewWithFrame:(CGRect)frame;


- (void)showChildVCViewWithIndex:(NSInteger)index outsideVC:(UIViewController *)VC;


@end
