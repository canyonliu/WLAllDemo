//
//  SegmentedControlDefault.h
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/22.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SegmentedControlDefault;
typedef enum : NSUInteger {
    segmentedControlIndicatorTypeBottom, // 指示器底部样式
    segmentedControlIndicatorTypeCenter, // 指示器中心背景样式
    segmentedControlIndicatorTypeBankground, // 指示器背景样式
    segmentedControlIndicatorTypeBottomWithImage, // 带有图片的指示器样式
} segmentedControlIndicatorType;  // SGSegmentedControlIndicatorType 指示器样式，默认为底部样式

@protocol WLSegmentedControlDefaultDelegate <NSObject>
// delegate 方法
- (void)SegmentedControlDefault:(SegmentedControlDefault *)segmentedControlDefault didSelectTitleAtIndex:(NSInteger)index;

@end



@interface SegmentedControlDefault : UIScrollView
/** 标题文字颜色(默认为黑色) */
@property (nonatomic, strong) UIColor *titleColorStateNormal;
/** 选中时标题文字颜色(默认为红色) */
@property (nonatomic, strong) UIColor *titleColorStateSelected;
/** 指示器的颜色(默认为红色) */
@property (nonatomic, strong) UIColor *indicatorColor;
/** 是否显示底部滚动指示器(默认为YES, 显示) */
@property (nonatomic, assign) BOOL showsBottomScrollIndicator;
/** 指示器样式(默认为底部样式) */
@property (nonatomic, assign) segmentedControlIndicatorType segmentedControlIndicatorType;

@property (nonatomic, weak) id<WLSegmentedControlDefaultDelegate> wl_delegate;
/**
 *  对象方法创建 SGSegmentedControlDefault
 *
 *  @param frame    frame
 *  @param delegate     delegate
 *  @param childVcTitle     子控制器标题数组
 *  @param isScaleText     是否开启文字缩放功能；默认不开启
 */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<WLSegmentedControlDefaultDelegate>)delegate childVcTitle:(NSArray *)childVcTitle isScaleText:(BOOL)isScaleText;
/**
 *  类方法创建 SGSegmentedControlDefault
 *
 *  @param frame    frame
 *  @param delegate     delegate
 *  @param childVcTitle     子控制器标题数组
 *  @param isScaleText     是否开启文字缩放功能；默认不开启
 */
+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<WLSegmentedControlDefaultDelegate>)delegate childVcTitle:(NSArray *)childVcTitle isScaleText:(BOOL)isScaleText;



/** 对象方法创建，带有图片的 SGSegmentedControlDefault */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<WLSegmentedControlDefaultDelegate>)delegate nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr childVcTitle:(NSArray *)childVcTitle;
/** 类方法创建，带有图片的 SGSegmentedControlDefault */
+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<WLSegmentedControlDefaultDelegate>)delegate nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr childVcTitle:(NSArray *)childVcTitle;

/** 改变选中button的位置以及指示器位置变化（给外界scrollView提供的方法 -> 必须实现） */
- (void)changeThePositionOfTheSelectedBtnWithScrollView:(UIScrollView *)scrollView;

/** 标题文字渐显效果(默认为NO), 与selectedTitleBtnColorGradualChangeScrollViewDidScroll方法，一起才会生效 */
@property (nonatomic, assign) BOOL titleColorGradualChange;
/** 标题文字缩放效果(默认为NO), 与selectedTitleBtnColorGradualChangeScrollViewDidScroll方法，一起才会生效 */
@property (nonatomic, assign) BOOL titleFondGradualChange;
/** 文字渐显、缩放效果的实现（给外界 scrollViewDidScroll 提供的方法 -> 可供选择） */
- (void)selectedTitleBtnColorGradualChangeScrollViewDidScroll:(UIScrollView *)scrollView;



@end
