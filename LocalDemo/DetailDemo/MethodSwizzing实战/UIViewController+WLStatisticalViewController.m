//
//  UIViewController+WLStatisticalViewController.m
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/21.
//  Copyright © 2016年 Baidu. All rights reserved.
//


#import "UIViewController+WLStatisticalViewController.h"
#import <objc/runtime.h>


@implementation UIViewController (WLStatisticalViewController)
+ (void)load{
    Method originMethod =  class_getInstanceMethod([self class], @selector(viewWillAppear:));//应该是类方法：class_getClassMethod([self class], @"viewWillAppear:");
    Method swizzleMethod = class_getInstanceMethod([self class], @selector(wl_statisticalViewWillAppear:));
    /**
     //     *  我们在这里使用class_addMethod()函数对Method Swizzling做了一层验证，如果self没有实现被交换的方法，会导致失败。
     //     *  而且self没有交换的方法实现，但是父类有这个方法，这样就会调用父类的方法，结果就不是我们想要的结果了。
     //     *  所以我们在这里通过class_addMethod()的验证，如果self实现了这个方法，class_addMethod()函数将会返回NO，我们就可以对其进行交换了。
     **/
    
    //为了避免交换很多次，导致完全碰运气哪个是自己想要的结果，所以强制只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //如果不存在，则替换为当前的wl方法
        
        if (class_addMethod([self class], @selector(viewWillAppear:), method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod))) {
            class_replaceMethod([self class], @selector(wl_statisticalViewWillAppear:),method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        } else {
            //如果本身实现了这个方法，就交换两个方法
            method_exchangeImplementations(originMethod, swizzleMethod);
        }

    });
}

- (void)wl_statisticalViewWillAppear:(BOOL)animated{
    //实际上调用的还是系统的viewwillappear，因为已经交换了
    [self wl_statisticalViewWillAppear:animated];

    
    NSString *str = [NSString stringWithFormat:@"%@", self.class];
    // 我们在这里加一个判断，将系统的UIViewController的对象剔除掉
    if(![str containsString:@"UI"]){
        NSLog(@"统计打点 : %@", self.class);
        NSLog(@"user go to the class of %@ ",[self class]);
    }
}


// 需要做一个事件响应的单独demo


// 什么时候调用:只要事件一传递给一个控件，那么这个控件就会调用自己的这个方法
// 作用:寻找并返回最合适的view
// UIApplication -> [UIWindow hitTest:withEvent:]寻找最合适的view告诉系统
// point:当前手指触摸的点
// point:是方法调用者坐标系上的点
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    // 1.判断下窗口能否接收事件
//    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) return nil;
//    // 2.判断下点在不在窗口上
//    // 不在窗口上
//    if ([self pointInside:point withEvent:event] == NO) return nil;
//    // 3.从后往前遍历子控件数组
//    int count = (int)self.subviews.count;
//    for (int i = count - 1; i >= 0; i--) {
//        // 获取子控件
//        UIView *childView = self.subviews[i];
//        // 坐标系的转换,把窗口上的点转换为子控件上的点
//        // 把自己控件上的点转换成子控件上的点
//        CGPoint childP = [self convertPoint:point toView:childView];
//        UIView *fitView = [childView hitTest:childP withEvent:event];
//        if (fitView) {
//            // 如果能找到最合适的view
//            return fitView;
//        }
//    }
//    // 4.没有找到更合适的view，也就是没有比自己更合适的view
//    return self;
//}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    // 想让控件随着手指移动而移动,监听手指移动
    // 获取UITouch对象
    UITouch *touch = [touches anyObject];
    // 获取当前点的位置
    CGPoint curP = [touch locationInView:self.view];
    // 获取上一个点的位置
    CGPoint preP = [touch previousLocationInView:self.view];
    // 获取它们x轴的偏移量,每次都是相对上一次
    CGFloat offsetX = curP.x - preP.x;
    // 获取y轴的偏移量
    CGFloat offsetY = curP.y - preP.y;
    // 修改控件的形变或者frame,center,就可以控制控件的位置
    // 形变也是相对上一次形变(平移)
    // CGAffineTransformMakeTranslation:会把之前形变给清空,重新开始设置形变参数
    // make:相对于最原始的位置形变
    // CGAffineTransform t:相对这个t的形变的基础上再去形变
    // 如果相对哪个形变再次形变,就传入它的形变
//    CGAffineTransform transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
    
}


// 直接替换imp的方法

//void (gOriginalViewDidAppear)(id, SEL , BOOL);
//
//void newViewDidAppear(UIViewController *self, SEL _cmd, BOOL animated)
//{
//    // call original implementation
//    gOriginalViewDidAppear(self, _cmd, animated);
//    
//    // Logging
//    
//}
//
//+ (void)load
//{
//    Method originalMethod = class_getInstanceMethod(self, @selector(viewDidAppear:));
//    gOriginalViewDidAppear = (void *)method_getImplementation(originalMethod);
//
//    
//    if(!class_addMethod(self, @selector(viewDidAppear:), (IMP) newViewDidAppear, method_getTypeEncoding(originalMethod))) {
//        method_setImplementation(originalMethod, (IMP) newViewDidAppear);
//    }
//}
//

@end
