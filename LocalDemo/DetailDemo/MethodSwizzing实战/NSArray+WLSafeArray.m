//
//  NSArray+WLSafeArray.m
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/21.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "NSArray+WLSafeArray.h"
#import <objc/runtime.h>


@implementation NSArray (WLSafeArray)

+ (void)load{
    //objc_getClass("__NSArrayI")  而不用 [self class]的原因是nsarray是类簇，抽象工厂在作祟
    Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
    Method toMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"),@selector(safeObjectAtIndex:));
    method_exchangeImplementations(fromMethod, toMethod);
}

- (id)safeObjectAtIndex:(NSInteger)index{
    if (self.count - 1 < index) {
        
        @try {
            return [self safeObjectAtIndex:index];
        } @catch (NSException *exception) {
            NSLog(@"保证了你不崩溃，但是这个类：%@ 取值越界了 %s",[self class],__func__);
            return nil;
        } @finally {
        }
    }else{
        return [self safeObjectAtIndex:index];
    }
}

@end
