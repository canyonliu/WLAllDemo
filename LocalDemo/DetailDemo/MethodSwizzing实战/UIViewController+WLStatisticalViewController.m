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
