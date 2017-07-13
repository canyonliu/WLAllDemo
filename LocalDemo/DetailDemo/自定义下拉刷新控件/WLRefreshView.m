//
//  WLRefreshView.m
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/12/2.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "WLRefreshView.h"
#import "UIView+WLExtension.h"

#define RefreshViewHeight 60

@interface WLRefreshView ()
@property (nonatomic,strong) CABasicAnimation *rotationAnimation;

@end

@implementation WLRefreshView

#pragma mark 图片旋转动画
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
- (UIImageView *)refreshBackImage{
    if (!_refreshBackImage) {
        _refreshBackImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blue"]];
        _refreshBackImage.frame = CGRectMake(0, -RefreshViewHeight, self.WL_width, 2);
        _refreshBackImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _refreshBackImage;
}

- (UIImageView *)refreshImage{
    if (!_refreshImage) {
        _refreshImage =[[UIImageView alloc]initWithImage: [UIImage imageNamed:@"refresh"]];
        _refreshImage.frame = CGRectMake(self.WL_centerX - 10 , 5, 20, 20);
    }
    return  _refreshImage;
}

- (UILabel *)refreshLabel{
    if (!_refreshLabel) {
        CGFloat refImageY = _refreshImage.WL_y + _refreshImage.WL_height + 15;
        _refreshLabel = [[UILabel alloc]initWithFrame:CGRectMake(50,refImageY , self.WL_width - 100, self.WL_height - refImageY)];
        _refreshLabel.textAlignment = NSTextAlignmentCenter;
        _refreshLabel.font = [UIFont systemFontOfSize:13];
        _refreshLabel.textColor = [UIColor darkGrayColor];
        _refreshLabel.text = self.refreshTitle ? self.refreshTitle:@"下拉即可刷新";
    }
    return _refreshLabel;
}



@end
