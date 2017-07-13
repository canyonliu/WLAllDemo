//
//  UIView+WLExtension.h
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/22.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WLExtension)
@property (nonatomic ,assign) CGFloat WL_x;
@property (nonatomic ,assign) CGFloat WL_y;
@property (nonatomic ,assign) CGFloat WL_width;
@property (nonatomic ,assign) CGFloat WL_height;
@property (nonatomic ,assign) CGFloat WL_centerX;
@property (nonatomic ,assign) CGFloat WL_centerY;

@property (nonatomic ,assign) CGSize WL_size;

@property (nonatomic, assign) CGFloat WL_right;
@property (nonatomic, assign) CGFloat WL_bottom;

+ (instancetype)WL_viewFromXib;
/** 在分类中声明@property， 只会生成方法的声明， 不会生成方法的实现和带有_线成员变量 */

@end
