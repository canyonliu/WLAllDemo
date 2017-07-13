//
//  SegmentedControlDefault.m
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/22.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "SegmentedControlDefault.h"
#import "UIView+WLExtension.h"


#define indicatorViewColorDefualt [UIColor redColor]

@interface SegmentedControlDefault()
/** 存入所有标题按钮 */
@property (nonatomic, strong) NSMutableArray *storageAlltitleBtn_mArr;
/** 标题数组 */
@property (nonatomic, strong) NSArray *title_Arr;
/** 是否开启文字缩放功能 */
@property (nonatomic, assign) BOOL isScaleText;
/** 普通状态下的图片数组 */
@property (nonatomic, strong) NSArray *nomal_image_Arr;
/** 选中状态下的图片数组 */
@property (nonatomic, strong) NSArray *selected_image_Arr;
/** 标题按钮 */
@property (nonatomic, strong) UIButton *title_btn;
/** 标记是否是一个button */
@property (nonatomic, assign) BOOL isFirstButton;
/** 指示器 */
@property (nonatomic, strong) UIView *indicatorView;
/** 背景指示器下面的小indicatorView */
@property (nonatomic, strong) UIView *bgIndicatorView;
/** 带有图片的指示器 */
@property (nonatomic, strong) UIImageView *indicatorViewWithImage;

/** 临时button用来转换button的点击状态 */
@property (nonatomic, strong) UIButton *temp_btn;



@end

@implementation SegmentedControlDefault

/** 按钮字体的大小(字号) */
static CGFloat const btn_fontOfSize = 16;
/** 标题按钮文字的缩放倍数 */
static CGFloat const btn_scale = 0.14;
/** 按钮之间的间距(滚动时按钮之间的间距) */
static CGFloat const btn_Margin = 15;
/** 指示器的高度(默认指示器) */
static CGFloat const indicatorViewHeight = 2;
/** 点击按钮时, 指示器的动画移动时间 */
static CGFloat const indicatorViewTimeOfAnimation = 0.15;



#pragma mark life circle
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<WLSegmentedControlDefaultDelegate>)delegate childVcTitle:(NSArray *)childVcTitle isScaleText:(BOOL)isScaleText{
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.6];
        self.bounces = NO;
        self.wl_delegate = delegate;
        
        self.title_Arr = childVcTitle;
        
        self.isScaleText = isScaleText;
        
        [self setupSubviews];

    }
    return self;
}

+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<WLSegmentedControlDefaultDelegate>)delegate childVcTitle:(NSArray *)childVcTitle isScaleText:(BOOL)isScaleText{
    return [[self alloc]initWithFrame:frame delegate:delegate childVcTitle:childVcTitle isScaleText:isScaleText];
    
}


- (instancetype)initWithFrame:(CGRect)frame delegate:(id<WLSegmentedControlDefaultDelegate>)delegate nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr childVcTitle:(NSArray *)childVcTitle {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
        
        self.wl_delegate = delegate;
        self.nomal_image_Arr = nomalImageArr;
        self.selected_image_Arr = selectedImageArr;
        self.title_Arr = childVcTitle;
        
        [self setupSubviewsWithImage];
    }
    return self;
}

+ (instancetype)segmentedControlWithFrame:(CGRect)frame delegate:(id<WLSegmentedControlDefaultDelegate>)delegate nomalImageArr:(NSArray *)nomalImageArr selectedImageArr:(NSArray *)selectedImageArr childVcTitle:(NSArray *)childVcTitle {
    return [[self alloc] initWithFrame:frame delegate:delegate nomalImageArr:nomalImageArr selectedImageArr:selectedImageArr childVcTitle:childVcTitle];
}


#pragma Private
- (void)setupSubviews{
    CGFloat button_X = 0;
    CGFloat button_Y = 0;
    CGFloat button_H = self.frame.size.height;
    
    for(NSUInteger i = 0 ; i < self.title_Arr.count;i++){
        self.title_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _title_btn.titleLabel.font = [UIFont systemFontOfSize:btn_fontOfSize];
        _title_btn.tag = i;
        
        //计算内容的size
        CGSize buttonSize = [self sizeWithText:_title_Arr[i] font:[UIFont systemFontOfSize:btn_fontOfSize] maxSize:CGSizeMake(MAXFLOAT, button_H)];
        CGFloat button_W = 2 * btn_Margin + buttonSize.width;
        _title_btn.frame = CGRectMake(button_X, button_Y, button_W, button_H);
        
        [_title_btn setTitle:_title_Arr[i] forState:UIControlStateNormal];
        [_title_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_title_btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        button_X = button_X + button_W;
        [_title_btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //默认选择第一个
        if (i == 0) {
            [self buttonAction:_title_btn];
        }
        
        [self.storageAlltitleBtn_mArr addObject:_title_btn];
        [self addSubview:_title_btn];
    }
    
        CGFloat scrollWidth = CGRectGetMaxX(self.subviews.lastObject.frame);
        self.contentSize = CGSizeMake(scrollWidth, self.frame.size.height);
        
        
    UIButton *firstButton = self.subviews.firstObject;
    if (firstButton) {
        self.isFirstButton = YES;
    }

#pragma mark -- 为文字缩放添加的代码
    if (self.isScaleText) {
        firstButton.titleLabel.font = [UIFont systemFontOfSize:btn_fontOfSize * (1 + btn_scale)];
    }
    
    //添加指示器
    self.indicatorView = [[UIView alloc]init];
    _indicatorView.backgroundColor = indicatorViewColorDefualt;
    _indicatorView.WL_height = indicatorViewHeight;
    _indicatorView.WL_y = self.frame.size.height - 2 * indicatorViewHeight;
    [self addSubview:_indicatorView];
    
    
    CGSize buttonSize = [self sizeWithText:firstButton.titleLabel.text font:[UIFont systemFontOfSize:btn_fontOfSize] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
    if (self.isScaleText) {
        _indicatorView.WL_width = buttonSize.width + btn_scale *buttonSize.width;
    }else{
        _indicatorView.WL_width = buttonSize.width;
        
    }
    _indicatorView.WL_centerX = firstButton.WL_centerX;
    
}

- (void)setupSubviewsWithImage{
    
}

//计算富文本
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark - - - 按钮的点击事件
- (void)buttonAction:(UIButton *)sender {
    // 1、代理方法实现
    NSInteger index = sender.tag;
    if ([self.wl_delegate respondsToSelector:@selector(SegmentedControlDefault:didSelectTitleAtIndex:)]) {
        [self.wl_delegate SegmentedControlDefault:self didSelectTitleAtIndex:index ];
    }
    
    // 2、改变选中的button的位置
    [self selectedBtnLocation:sender];
}
/** 改变选中button的位置以及指示器位置变化（给外界scrollView提供的方法 -> 必须实现） */
- (void)changeThePositionOfTheSelectedBtnWithScrollView:(UIScrollView *)scrollView {
    // 1、计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 2、把对应的标题选中
    UIButton *selectedBtn = self.storageAlltitleBtn_mArr[index];
    
    // 3、滚动时，改变标题选中
    [self selectedBtnLocation:selectedBtn];
}

- (void)selectedBtnLocation:(UIButton *)button{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(indicatorViewTimeOfAnimation * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.temp_btn == nil) {
            button.selected = YES;
            _temp_btn = button;
        }else if(self.temp_btn != nil && self.temp_btn == button){
            button.selected = YES;
        }else if (self.temp_btn != nil && self.temp_btn != button){
            _temp_btn.selected = NO;
            button.selected = YES;
            _temp_btn = button;
        }
    });
    
//    2.改变指示器的位置
    if (self.segmentedControlIndicatorType == segmentedControlIndicatorTypeCenter) {
        [UIView animateWithDuration:indicatorViewTimeOfAnimation animations:^{
            self.indicatorView.WL_width = button.WL_width - btn_Margin;
            self.indicatorView.WL_centerX = button.WL_centerX;
        }];
    }else if (self.segmentedControlIndicatorType == segmentedControlIndicatorTypeBankground) {
        
        [UIView animateWithDuration:indicatorViewTimeOfAnimation animations:^{
            self.indicatorView.WL_width = button.WL_width;
            self.bgIndicatorView.WL_width = button.WL_width;
            self.indicatorView.WL_centerX = button.WL_width;
        }];
        
    } else if (self.segmentedControlIndicatorType == segmentedControlIndicatorTypeBottomWithImage) {
        
        [UIView animateWithDuration:indicatorViewTimeOfAnimation animations:^{
            self.indicatorViewWithImage.WL_centerX = button.WL_centerX;
        }];
        
    } else {
        
        // 改变指示器位置
        [UIView animateWithDuration:indicatorViewTimeOfAnimation animations:^{
            // 计算内容的Size
            [UIView animateWithDuration:indicatorViewTimeOfAnimation animations:^{
                self.indicatorView.WL_width = button.WL_width - 2 * btn_Margin;
                self.indicatorView.WL_centerX = button.WL_centerX;
            }];
        }];
    }
    
    // 3、滚动标题选中居中
    [self selectedBtnCenter:button];
    
}

/** 滚动标题选中居中 */

- (void)selectedBtnCenter:(UIButton *)button{
    CGFloat offsetX = button.center.x - self.frame.size.width * 0.5;
    if(offsetX < 0)offsetX = 0;
    
    CGFloat maxOffSetX = self.contentSize.width - self.frame.size.width;
    if(offsetX > maxOffSetX) offsetX = maxOffSetX;
    
    //滚动标题滚动条
    [self setContentOffset:CGPointMake(offsetX, 0) animated: YES];

}

#pragma mark Public
/** 文字渐显、缩放效果的实现（给外界 scrollViewDidScroll 提供的方法 -> 可供选择） */
- (void)selectedTitleBtnColorGradualChangeScrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat curPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    NSInteger beforeIndex = curPage;
    NSInteger afterIndex = curPage + 1;
    
    UIButton *beforeButton = self.storageAlltitleBtn_mArr[beforeIndex];
    UIButton *afterButton = nil;
    if (afterIndex < self.storageAlltitleBtn_mArr.count) {
        afterButton = self.storageAlltitleBtn_mArr[afterIndex];
    }
    
    
    // 计算下右边缩放比例
    CGFloat rightScale = curPage - beforeIndex;
    
    // 计算下左边缩放比例
    CGFloat leftScale = 1 - rightScale;
    if (self.titleFondGradualChange) {
        UIButton *firstButton = self.subviews.firstObject;
        if (self.isFirstButton) {
            firstButton.titleLabel.font = [UIFont systemFontOfSize:btn_fontOfSize];
        }
        beforeButton.transform = CGAffineTransformMakeScale(leftScale * btn_scale + 1, leftScale*btn_scale + 1);
        afterButton.transform = CGAffineTransformMakeScale(rightScale * btn_scale + 1, rightScale*btn_scale + 1);
        
    }
    
    if (self.titleColorGradualChange) {
        beforeButton.titleLabel.textColor = [UIColor colorWithRed:leftScale green:0 blue:0 alpha:1];
        afterButton.titleLabel.textColor = [UIColor colorWithRed:rightScale green:0 blue:0 alpha:1];
    }
    
    
}







#pragma mark getter
- (NSMutableArray *)storageAlltitleBtn_mArr{
    if (!_storageAlltitleBtn_mArr) {
        _storageAlltitleBtn_mArr = [NSMutableArray array];
    }
    return _storageAlltitleBtn_mArr;
}


#pragma mark setter
- (void)setSegmentedControlIndicatorType:(segmentedControlIndicatorType)segmentedControlIndicatorType {
    _segmentedControlIndicatorType = segmentedControlIndicatorType;
    
    // 取出第一个子控件1
    UIButton *firstButton = self.subviews.firstObject;
    
    if (self.segmentedControlIndicatorType == segmentedControlIndicatorTypeBottom) {
        
    } else if (self.segmentedControlIndicatorType == segmentedControlIndicatorTypeCenter) {
        
        // 指示器默认在第一个选中位置
        // 计算TitCleLabel内容的Size
        CGSize buttonSize = [self sizeWithText:firstButton.titleLabel.text font:[UIFont systemFontOfSize:btn_fontOfSize] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
        
        // 改变原指示器样式
        _indicatorView.WL_width = buttonSize.width + btn_Margin;
        _indicatorView.WL_centerX = firstButton.WL_centerX;
        CGFloat indicatorViewHeight_c = 25;
        self.indicatorView.WL_height = indicatorViewHeight_c;
        self.indicatorView.WL_y = (self.frame.size.height - indicatorViewHeight_c) * 0.5;
        
        self.indicatorView.alpha = 0.3;
        self.indicatorView.layer.cornerRadius = 7;
        self.indicatorView.layer.masksToBounds = YES;
        
    } else if (self.segmentedControlIndicatorType == segmentedControlIndicatorTypeBankground) {
        
        // 计算firstButton内容的Size
        CGSize buttonSize = [self sizeWithText:firstButton.titleLabel.text font:[UIFont systemFontOfSize:btn_fontOfSize] maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
        
        // 改变原指示器样式
        _indicatorView.WL_x = firstButton.WL_x;
        _indicatorView.WL_width = buttonSize.width + 2 * btn_Margin;
        CGFloat indicatorViewHeight_c = self.frame.size.height;
        self.indicatorView.WL_height = indicatorViewHeight_c;
        self.indicatorView.WL_y = 0;
        self.indicatorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        // 增加新的指示器（指示器底部的小指示器）
        self.bgIndicatorView = [[UIView alloc] init];
        _bgIndicatorView.backgroundColor = [UIColor redColor];
        _bgIndicatorView.WL_x = firstButton.WL_x;
        _bgIndicatorView.WL_width = _indicatorView.WL_width;
        _bgIndicatorView.WL_height = indicatorViewHeight;
        _bgIndicatorView.WL_y = _indicatorView.WL_height - indicatorViewHeight;
        [self.indicatorView addSubview:_bgIndicatorView];
        
    } else if (self.segmentedControlIndicatorType == segmentedControlIndicatorTypeBottomWithImage) {
        
        // 清除 alloc init 创建的指示器
        [self.indicatorView removeFromSuperview];
        self.indicatorView = nil;
        
        // 创建新的指示器样式（带有图片）
        self.indicatorViewWithImage = [[UIImageView alloc] init];
        _indicatorViewWithImage.image = [UIImage imageNamed:@"login_register_indicator"];
        _indicatorViewWithImage.WL_height = _indicatorViewWithImage.image.size.height;
        _indicatorViewWithImage.WL_y = self.WL_height - _indicatorViewWithImage.WL_height;
        _indicatorViewWithImage.WL_width = _indicatorViewWithImage.image.size.width;
        _indicatorViewWithImage.WL_centerX = firstButton.WL_centerX;
        [self addSubview:_indicatorViewWithImage];
    }
}




@end
